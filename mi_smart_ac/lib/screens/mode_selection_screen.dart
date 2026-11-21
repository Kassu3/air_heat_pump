import 'package:flutter/material.dart';
import '../widgets/app_colors.dart';
import 'main_thermostat_screen.dart';
import 'package:mi_smart_ac/utils/translations.dart';
import '../widgets/neuforic_button.dart';

class ModeSelectionScreen extends StatefulWidget {
  final String currentLanguage;
  final Function(String) onLanguageChanged;

  const ModeSelectionScreen({
    super.key,
    required this.currentLanguage,
    required this.onLanguageChanged,
  });

  @override
  State<ModeSelectionScreen> createState() => _ModeSelectionScreenState();
}

class _ModeSelectionScreenState extends State<ModeSelectionScreen> {
  String _selectedMode = "AUTO";
  String _selectedSpeed = "Au";
  double _targetTemperature = 21.0; // ECO varten lämpötilan seuranta

  // ECO-toiminnon tilat: Off, ECO, RAJA (75%), RAJA (50%)
  String _ecoState = "Off";

  final List<String> _speeds = ["Au", "20%", "40%", "60%", "80%", "100%"];

  // Puhallusnopeuden säätölukitus (Auto, Kuivaus ja aktiivinen ECO lukitsee tämän)
  bool _canAdjustSpeed() {
    if (_selectedMode == "AUTO" || _selectedMode == "DRY") {
      return false;
    }
    if (_selectedMode == "COOL" && _ecoState != "Off") {
      return false; // ECO pakottaa AUTOn
    }
    return true;
  }

  // ECO-painikkeen logiikka (kiertää kehää)
  void _cycleEcoState() {
    if (_selectedMode != "COOL") return; // Toimii vain jäähdytyksellä

    setState(() {
      if (_ecoState == "Off") {
        _ecoState = "ECO";
        _targetTemperature = 24.0; // Pakottaa 24 astetta
        _selectedSpeed = "Au"; // Pakottaa puhalluksen AUTOksi
      } else if (_ecoState == "ECO") {
        _ecoState = AppTranslations.translate(
            widget.currentLanguage, 'mode_eco_limit_75');
      } else if (_ecoState ==
          AppTranslations.translate(
              widget.currentLanguage, 'mode_eco_limit_75')) {
        _ecoState =
            AppTranslations.translate(widget.currentLanguage, 'mode_limit_50');
      } else {
        _ecoState = "Off"; // Palaa edelliseen toimintoon / normaaliin tilaan
      }

      // Synkronoidaan ECO-tila pääsivulle ja ESP32-rajapintaan:
      final bool isEcoNowActive = _ecoState != "Off";
      if (thermostatInstance != null &&
          thermostatInstance!.isEcoMode != isEcoNowActive) {
        thermostatInstance!.toggleEcoModeFromBottomBar();
      }
      if (isEcoNowActive) {
        thermostatInstance?.changeFanSpeedFromBottomBar("AUTO");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final List<Color> speedGradient = isDark //widget.isDarkTheme
        ? [const Color(0xFF00C6FF), const Color(0xFF0072FF)]
        : [const Color(0xFF8A2387), const Color(0xFFE94057)];

    final bool speedEnabled = _canAdjustSpeed();
    final bool isCooling = _selectedMode == "COOL";

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerHigh,
      appBar: AppBar(
        title: Text(
          AppTranslations.translate(widget.currentLanguage, "mode_title"),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${AppTranslations.translate(widget.currentLanguage, 'mode_set_temp_start')}${_targetTemperature.toInt()}${AppTranslations.translate(widget.currentLanguage, 'mode_set_temp_end')}",
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 13),

              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                childAspectRatio: 1.9,
                children: [
                  // AUTOMAATTI
                  NeuforicButton(
                    icon: Icon(Icons.brightness_auto_rounded),
                    iconColor: AppColors.markEco,
                    label: AppTranslations.translate(
                        widget.currentLanguage, 'mode_auto'),
                    isSelected: _selectedMode == "AUTO",
                    onTap: () => setState(() {
                      _selectedMode = "AUTO";
                      _selectedSpeed = "Au";
                      _ecoState = "Off"; // Nollaa ECO
                      if (thermostatInstance?.isEcoMode == true) {
                        thermostatInstance?.toggleEcoModeFromBottomBar();
                      }
                      thermostatInstance?.changeModeFromBottomBar("AUTO");
                    }),
                  ),

                  // JÄÄHDYTYS
                  NeuforicButton(
                    icon: Icon(Icons.ac_unit_rounded),
                    iconColor: AppColors.cloudIcon,
                    label: AppTranslations.translate(
                        widget.currentLanguage, 'mode_cool'),
                    isSelected: _selectedMode == "COOL",
                    onTap: () => setState(() {
                      _selectedMode = "COOL";
                      _selectedSpeed = "Au";
                      _ecoState = "Off";
                      thermostatInstance?.changeModeFromBottomBar("COOL");
                    }),
                  ),

                  // KUIVAUS
                  NeuforicButton(
                    icon: Icon(Icons.water_drop_rounded),
                    iconColor: AppColors.dropIcon,
                    label: AppTranslations.translate(
                        widget.currentLanguage, 'mode_dry'),
                    isSelected: _selectedMode == "DRY",
                    onTap: () => setState(() {
                      _selectedMode = "DRY";
                      _selectedSpeed = "20%";
                      _ecoState = "Off";
                      if (thermostatInstance?.isEcoMode == true) {
                        thermostatInstance?.toggleEcoModeFromBottomBar();
                      }
                      thermostatInstance?.changeModeFromBottomBar("DRY");
                    }),
                  ),

                  // LÄMMITYS
                  NeuforicButton(
                    icon: Icon(Icons.wb_sunny_rounded),
                    iconColor: AppColors.markStatusHeating,
                    label: AppTranslations.translate(
                        widget.currentLanguage, 'mode_heat'),
                    isSelected: _selectedMode == "HEAT",
                    onTap: () => setState(() {
                      _selectedMode = "HEAT";
                      _ecoState = "Off";
                      if (thermostatInstance?.isEcoMode == true) {
                        thermostatInstance?.toggleEcoModeFromBottomBar();
                      }
                      thermostatInstance?.changeModeFromBottomBar("HEAT");
                    }),
                  ),
                ],
              ),

              const SizedBox(height: 15),
              // FAN-PAINIKE
              SizedBox(
                width: double.infinity,
                child: NeuforicButton(
                  icon: Icon(Icons.air_rounded),
                  iconColor: AppColors.airIcon,
                  label: AppTranslations.translate(
                      widget.currentLanguage, 'mode_fan'),
                  isSelected: _selectedMode == "FAN",
                  onTap: () => setState(() {
                    _selectedMode = "FAN";
                    _ecoState = "Off";
                    if (thermostatInstance?.isEcoMode == true) {
                      thermostatInstance?.toggleEcoModeFromBottomBar();
                    }
                    thermostatInstance?.changeModeFromBottomBar("FAN");
                  }),
                ),
              ),

              const SizedBox(height: 10),

              // ENERGIANSÄÄSTÖ ECO-PAINIKE LUKITUSLOGIIKALLA
              AnimatedOpacity(
                duration: Duration(milliseconds: 200),
                opacity: isCooling ? 1.0 : 0.3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          AppTranslations.translate(
                              widget.currentLanguage, 'mode_energy_saving'),
                          style: TextStyle(
                            color: colorScheme.onSurfaceVariant,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: NeuforicButton(
                        icon: Icon(Icons.eco_rounded),
                        iconColor: AppColors.airIcon,
                        label: _ecoState == "Off"
                            ? AppTranslations.translate(
                                widget.currentLanguage, 'mode_eco_off')
                            : "${AppTranslations.translate(widget.currentLanguage, 'mode_eco_active')}$_ecoState", // Näytetään dynaamisesti painikkeessa aktiivinen tila ECO, 75%, 50% tai ECO pois
                        isSelected: _ecoState != "Off",
                        onTap: isCooling
                            ? _cycleEcoState
                            : () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  // Annetaan käyttäjälle ilmoitus, jos yrittää painaa väärässä tilassa
                                  SnackBar(
                                    content: Text(
                                      AppTranslations.translate(
                                          widget.currentLanguage,
                                          'mode_eco_only_cooling'),
                                    ),
                                  ),
                                );
                              },
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 15),

              // PUHALLUSNOPEUDEN SÄÄTIMEN LUKITUS
              AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: speedEnabled ? 1.0 : 0.4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          AppTranslations.translate(
                              widget.currentLanguage, 'fan'),
                          style: TextStyle(
                            color: colorScheme.onSurfaceVariant,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (!speedEnabled) ...[
                          const SizedBox(width: 8),
                          Text(
                            _selectedMode == "AUTO"
                                ? AppTranslations.translate(
                                    widget.currentLanguage,
                                    'mode_automatic_hint')
                                : AppTranslations.translate(
                                    widget.currentLanguage,
                                    'mode_locked_in_dry'),
                            style: TextStyle(
                              color: colorScheme.onSurfaceVariant
                                  .withValues(alpha: 0.7),
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ]
                      ],
                    ),
                    const SizedBox(height: 12),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: _speeds.map((speed) {
                        final bool isSelected = _selectedSpeed == speed;
                        return Expanded(
                          child: GestureDetector(
                            onTap: speedEnabled
                                ? () {
                                    setState(() => _selectedSpeed = speed);
                                    thermostatInstance
                                        ?.changeFanSpeedFromBottomBar(speed);
                                  }
                                : null,
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 200),
                              margin: EdgeInsets.symmetric(horizontal: 4),
                              padding: EdgeInsets.symmetric(vertical: 14),
                              decoration: BoxDecoration(
                                color: colorScheme.surfaceContainerHigh,
                                borderRadius: BorderRadius.circular(12),
                                gradient: isSelected
                                    ? LinearGradient(
                                        colors: speedGradient,
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                      )
                                    : null,
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: speedGradient.first
                                              .withValues(alpha: 0.3),
                                          blurRadius: 12,
                                          offset: Offset(0, 4),
                                        ),
                                      ]
                                    : [
                                        BoxShadow(
                                          color: colorScheme.shadow
                                              .withValues(alpha: 0.4),
                                          offset: Offset(3, 3),
                                          blurRadius: 12,
                                        ),
                                        BoxShadow(
                                          color: colorScheme.surfaceTint
                                              .withValues(alpha: 0.04),
                                          offset: Offset(-3, -3),
                                          blurRadius: 12,
                                        ),
                                      ],
                              ),
                              child: Center(
                                child: Text(
                                  speed,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: isSelected
                                        ? AppColors.lightText
                                        : colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 12),

                    // PUHALTIMEN SUUNTAUS
                    _buildControlRow(
                        AppTranslations.translate(
                            widget.currentLanguage, 'swing'),
                        ["UP", "MIDDLE", "DOWN", "SWING"],
                        thermostatInstance?.currentSwingDirection ?? "SWING",
                        'swing', (val) {
                      if (thermostatInstance?.isDevicePowerOn == false) return;
                      setState(() {
                        thermostatInstance
                            ?.changeSwingDirectionFromBottomBar(val);
                      });
                    }),
                    SizedBox(height: 90),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildControlRow(String label, List<String> options, String currentVal,
      String prefix, ValueChanged<String> onChanged) {
    final colorScheme = Theme.of(context).colorScheme;

    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color activePillColor = isDark
        ? AppColors.darkTemperatureRing2
        : AppColors.lightTemperatureRing2;

    return AnimatedOpacity(
      opacity: (thermostatInstance?.isDevicePowerOn ?? false) ? 1.0 : 0.3,
      duration: const Duration(milliseconds: 200),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurfaceVariant,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: options.map((opt) {
                bool isSel = currentVal == opt;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => onChanged(opt),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: isSel ? activePillColor : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        AppTranslations.translate(widget.currentLanguage,
                            '${prefix}_${opt.toUpperCase()}'),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight:
                              isSel ? FontWeight.bold : FontWeight.normal,
                          color: isSel
                              ? AppColors.lightText
                              : colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
