// Pumpun päänäkymä
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:mi_smart_ac/widgets/app_colors.dart';
import 'package:mi_smart_ac/widgets/thermometer_view.dart';
import '../utils/translations.dart';
import 'add_device_screen.dart';
import 'settings_screen.dart';

class MainThermostatScreen extends StatefulWidget {
  final String currentLanguage;
  final Function(String) onLanguageChanged;
  final bool isDarkTheme;
  final Function(bool) onThemeChanged;

  const MainThermostatScreen({
    super.key,
    required this.currentLanguage,
    required this.onLanguageChanged,
    required this.isDarkTheme,
    required this.onThemeChanged,
  });

  @override
  State<MainThermostatScreen> createState() => _MainThermostatScreenState();
}

dynamic thermostatInstance;

class _MainThermostatScreenState extends State<MainThermostatScreen> {
  final String _esp32Ip = "192.168.4.1";

  double _currentRoomTemperature = 22.0;
  double _targetTemperature = 20.0;
  int _insideHumidity = 49;
  double _powerElectricity = 1.2;
  bool _hasSensorError = false;

  bool _isPowerOn = true;
  bool _ecoMode = false;
  bool _isDeviceOnline = false;
  String _currentMode = "HEAT";
  String _fanSpeed = "AUTO";
  String _swingDirection = "AUTO";

  String get currentFanSpeed => _fanSpeed;
  String get currentSwingDirection => _swingDirection;
  bool get isDevicePowerOn => _isPowerOn;
  bool get isEcoMode => _ecoMode;

  Timer? _fetchTimer;

  // Simuloidaan päiviä edellisestä puhdistuksesta.
  int _daysSinceFilterClean = 32;

  void _resetFilterTimer() {
    setState(() {
      _daysSinceFilterClean = 0; // Nollataan laskuri
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.mainFilterCleared,
        content: Text(
          AppTranslations.translate(
              widget.currentLanguage, 'filter_cleared_msg'),
        ), //
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    thermostatInstance = this;
    _sendControlData();
    _fetchTelemetry();
    _fetchTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      _fetchTelemetry();
    });
  }

  @override
  void dispose() {
    _fetchTimer?.cancel();
    super.dispose();
  }

  Future<void> _fetchTelemetry() async {
    try {
      final url = Uri.parse('http://$_esp32Ip/api/status');
      final response = await http.get(url).timeout(const Duration(seconds: 1));
      if (response.statusCode == 200) {
        if (!mounted) return;
        final data = jsonDecode(response.body);
        setState(() {
          _isDeviceOnline = true;
          _currentRoomTemperature =
              (data['currentTemperature'] ?? _currentRoomTemperature)
                  .toDouble();
          _insideHumidity = data['insideHumidity'] ?? _insideHumidity;
          _powerElectricity =
              (data['powerElectricity'] ?? _powerElectricity).toDouble();
          _hasSensorError = data['sensorError'] ?? false;
          _fanSpeed = data['fanSpeed'] ?? _fanSpeed;
          _swingDirection = data['swingDirection'] ?? _swingDirection;
          _currentMode = data['currentMode'] ?? _currentMode;
          _isPowerOn = data['powerOn'] ?? _isPowerOn;
          _ecoMode = data['ecoMode'] ?? _ecoMode;
        });
      }
    } catch (e) {
      if (_isDeviceOnline) {
        debugPrint("Yhteys ESP32-laitteeseen katkesi: $e");
        if (mounted) {
          setState(() => _isDeviceOnline = false);
        }
      }
    }
  }

  Future<void> _sendControlData() async {
    try {
      final url = Uri.parse('http://$_esp32Ip/api/control');
      final body = jsonEncode({
        "targetTemperature": _targetTemperature,
        "currentMode": _currentMode,
        "fanSpeed": _fanSpeed,
        "swingDirection": _swingDirection,
        "powerOn": _isPowerOn,
        "ecoMode": _ecoMode,
      });
      await http
          .post(url, headers: {"Content-Type": "application/json"}, body: body)
          .timeout(const Duration(seconds: 1));
    } catch (e) {
      // Kun laite ei ole verkossa, sovellus toimii paikallisessa esittelytilassa //debugPrint("Virhe komennon lähetyksessä: $e");
    }
  }

  void togglePowerFromBottomBar() {
    setState(() {
      _isPowerOn = !_isPowerOn;
    });
    _sendControlData();
  }

  void toggleEcoModeFromBottomBar() {
    setState(() {
      _ecoMode = !_ecoMode;
    });
    _sendControlData();
  }

  void changeModeFromBottomBar(String newMode) {
    setState(() {
      _currentMode = newMode;
    });
    _sendControlData();
  }

  void changeFanSpeedFromBottomBar(String newSpeed) {
    setState(() {
      _fanSpeed = newSpeed;
    });
    _sendControlData();
  }

  void changeSwingDirectionFromBottomBar(String newSwing) {
    setState(() {
      _swingDirection = newSwing;
    });
    _sendControlData();
  }

  @override
  Widget build(BuildContext context) {
    final bool showFilterWarning = _daysSinceFilterClean >= 30;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppTranslations.translate(widget.currentLanguage, 'title'),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.add_circle_outline),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  AddDeviceScreen(currentLanguage: widget.currentLanguage),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () async {
              final selectedLang = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsScreen(
                    key: ValueKey(
                        '${widget.isDarkTheme}_${widget.onLanguageChanged}'),
                    initialLanguage: widget.currentLanguage,
                    isDarkTheme: widget.isDarkTheme,
                    onThemeChanged: widget.onThemeChanged,
                  ),
                ),
              );
              if (selectedLang != null) {
                widget.onLanguageChanged(selectedLang);
              }
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            if (showFilterWarning) ...[
              _buildFilterWarningCard(),
              const SizedBox(height: 24),
            ],
            const SizedBox(height: 10),
            if (_hasSensorError) _buildErrorBanner(),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 8.0,
              ),
            ),
            const SizedBox(height: 16),
            AnimatedOpacity(
              opacity: _isPowerOn ? 1.0 : 0.3,
              duration: const Duration(milliseconds: 200),
              child: IgnorePointer(
                ignoring: !_isPowerOn,
                child: ThermometerView(
                  targetTemperature: _targetTemperature,
                  currentTemperature: _currentRoomTemperature,
                  onCurrentTemperatureTick: (newRoomTemp) {
                    setState(() {
                      _currentRoomTemperature = newRoomTemp;
                    });
                  },
                  modeColor: AppColors.modeColor,
                  currentMode: _isPowerOn
                      ? AppTranslations.translate(
                          widget.currentLanguage, 'mode_$_currentMode')
                      : AppTranslations.translate(
                          widget.currentLanguage, 'power_off'),
                  onTargetTemperatureChanged: (newTemp) {
                    setState(() => _targetTemperature = newTemp);
                    _sendControlData();
                  },
                  isEcoMode: _ecoMode,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const SizedBox(height: 16),
            const SizedBox(height: 24),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                children: [
                  Expanded(
                    child: _buildAdvancedCard(
                      AppTranslations.translate(
                          widget.currentLanguage, 'humidity'),
                      "$_insideHumidity %",
                      Icons.water_drop_outlined,
                      AppColors.waterDropIcon,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildAdvancedCard(
                      AppTranslations.translate(
                          widget.currentLanguage, 'outdoor'),
                      "-2.5 °C",
                      Icons.cloud_outlined,
                      AppColors.cloudIcon,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildAdvancedCard(
      String label, String value, IconData icon, Color color) {
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedOpacity(
      opacity: _isPowerOn ? 1.0 : 0.3,
      duration: const Duration(milliseconds: 200),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: 0.4),
              blurRadius: 12,
              offset: Offset(4, 4),
            ),
            BoxShadow(
              color: colorScheme.surfaceTint.withValues(alpha: 0.02),
              blurRadius: 12,
              offset: Offset(-4, -4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: color,
              size: 24,
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: TextStyle(
                color: colorScheme.onSurfaceVariant,
                fontSize: 12,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                color: colorScheme.onSurface,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.errorSensor.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.errorSensor),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: AppColors.errorSensor,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              AppTranslations.translate(widget.currentLanguage, 'error_sensor'),
              style: const TextStyle(
                color: AppColors.errorSensor,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterWarningCard() {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
        border: Border.all(color: colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.4),
            offset: Offset(4, 4),
            blurRadius: 12,
          ),
          BoxShadow(
            color: colorScheme.surfaceTint.withValues(alpha: 0.02),
            offset: Offset(-4, -4),
            blurRadius: 12,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.tertiary.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.air_rounded,
              color: colorScheme.tertiary,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppTranslations.translate(
                      widget.currentLanguage, 'filter_maintenance'),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "${AppTranslations.translate(widget.currentLanguage, 'filter_desc_start')}$_daysSinceFilterClean${AppTranslations.translate(widget.currentLanguage, 'filter_desc_end')}",
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 13,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: _resetFilterTimer,
                  style: TextButton.styleFrom(
                    backgroundColor:
                        colorScheme.tertiary.withValues(alpha: 0.15),
                    padding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    AppTranslations.translate(
                        widget.currentLanguage, 'fliter_mark_cleaned'),
                    style: TextStyle(
                      color: colorScheme.tertiary,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
