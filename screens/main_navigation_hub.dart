import 'package:flutter/material.dart';
import 'package:mi_smart_ac/screens/main_thermostat_screen.dart';
import 'package:mi_smart_ac/screens/mode_selection_screen.dart';
import 'package:mi_smart_ac/screens/scheduler_screen.dart';
import 'package:mi_smart_ac/utils/translations.dart';
import 'package:mi_smart_ac/widgets/thermometer_dial_theme_extension.dart';
import '../widgets/app_colors.dart';
import 'electricity_screen.dart';

class MainNavigationHub extends StatefulWidget {
  final String currentLanguage;
  final Function(String) onLanguageChanged;
  final bool isDarkTheme;
  final Function(bool) onThemeChanged;

  const MainNavigationHub({
    super.key,
    required this.currentLanguage,
    required this.onLanguageChanged,
    required this.isDarkTheme,
    required this.onThemeChanged,
  });

  @override
  State<MainNavigationHub> createState() => _MainNavigationHubState();
}

class _MainNavigationHubState extends State<MainNavigationHub> {
  int _currentScreenIndex = 0;
  bool _isPowerOn = true;
  String _currentLanguage = "English";
  final double _powerElectricity = 1.2;

  void _changeLanguage(String newLang) {
    setState(() {
      _currentLanguage = newLang;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final Color bgNeu = colorScheme.surfaceContainerHigh;

    final List<Widget> appScreens = [
      MainThermostatScreen(
        currentLanguage: _currentLanguage,
        onLanguageChanged: _changeLanguage,
        isDarkTheme: widget.isDarkTheme,
        onThemeChanged: widget.onThemeChanged,
      ), // Päänäkymä
      ModeSelectionScreen(
        currentLanguage: _currentLanguage,
        onLanguageChanged: _changeLanguage,
      ), // Tila
      SchedulerScreen(
        currentLanguage: _currentLanguage,
        onLanguageChanged: _changeLanguage,
        onSaveSuccess: () {
          setState(() {
            _currentScreenIndex = 0;
          });
        },
      ), // Ajastin
      ElectricityScreen(
        currentLanguage: _currentLanguage,
        currentElectricity: _powerElectricity,
      ), // Sähkönseuranta
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,

      body: IndexedStack(
        index: _currentScreenIndex,
        children: appScreens,
      ),
      // KESKIPAINIKE
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        width: 76,
        height: 76,
        margin: EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
          color: bgNeu,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withAlpha(150),
              offset: Offset(4, 4),
              blurRadius: 8,
            ),
            BoxShadow(
              color: colorScheme.surfaceTint.withAlpha(15),
              offset: Offset(-4, -4),
              blurRadius: 8,
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () {
            setState(() {
              _isPowerOn = !_isPowerOn;
            });
            if (thermostatInstance != null) {
              thermostatInstance.togglePowerFromBottomBar();
            }
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          highlightElevation: 0,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 150),
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _isPowerOn
                  ? AppColors.isPowerOnButton.withValues(alpha: 0.2)
                  : bgNeu,
              border: Border.all(
                color: _isPowerOn
                    ? AppColors.isPowerOnButton
                    : colorScheme.outlineVariant,
              ),
              boxShadow: _isPowerOn
                  ? [
                      BoxShadow(
                        color: AppColors.isPoweronButtonShadow.withAlpha(100),
                        blurRadius: 12,
                        spreadRadius: 1,
                      ),
                    ]
                  : null,
            ),
            child: Icon(
              Icons.power_settings_new,
              color: _isPowerOn
                  ? AppColors.isPowerOnButton
                  : colorScheme.onSurfaceVariant,
              size: 30,
            ),
          ),
        ),
      ),

      // ALAPALKKI
      bottomNavigationBar: BottomAppBar(
        color: bgNeu,
        shape: CircularNotchedRectangle(),
        notchMargin: 6.0,
        elevation: 0,
        padding: EdgeInsets.zero,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Vasen puoli: Koti ja Mode
              _buildNeuNavButton(
                icon: Icons.home_rounded,
                label: AppTranslations.translate(_currentLanguage, 'nav_home'),
                index: 0,
              ),
              _buildNeuNavButton(
                icon: Icons.tune_rounded,
                label: AppTranslations.translate(_currentLanguage, 'nav_mode'),
                index: 1,
              ),

              const SizedBox(width: 60),

              const SizedBox(width: 32),
              // Oikea puoli Ajastin ja Sähkö
              _buildNeuNavButton(
                icon: Icons.calendar_today,
                label:
                    AppTranslations.translate(_currentLanguage, 'nav_schedule'),
                index: 2,
              ),
              _buildNeuNavButton(
                icon: Icons.bolt_rounded,
                label: AppTranslations.translate(
                    _currentLanguage, 'nav_electricity'),
                index: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // APUFUNTIO 3D Neuforiselle painikkeelle Ylöspäin kupera / Alaspäin upotettu
  Widget _buildNeuNavButton(
      {required IconData icon, required String label, required int index}) {
    final bool isSelected = _currentScreenIndex == index;
    final colorScheme = Theme.of(context).colorScheme;
    final dialTheme = Theme.of(context).extension<ThermometerDialTheme>();

    final Color bgNeu = colorScheme.surfaceContainerHigh;
    final Color activeColor =
        dialTheme?.temperatureRing2 ?? AppColors.navButtonSelected;
    final Color inactiveColor = colorScheme.onSurfaceVariant;

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentScreenIndex = index;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: Duration(microseconds: 150),
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: bgNeu,
                shape: BoxShape.circle,
                boxShadow: isSelected
                    ? [
                        // UPOTETTU Painettu alas
                        BoxShadow(
                          color: colorScheme.shadow.withAlpha(180),
                          offset: Offset(-1, -1),
                          blurRadius: 3,
                        ),
                        BoxShadow(
                          color: activeColor.withAlpha(120),
                          offset: Offset(1, 1),
                          blurRadius: 5,
                        ),
                      ]
                    : [
                        // KOHOLLA Ylöspäin kupera
                        BoxShadow(
                          color: colorScheme.shadow.withAlpha(140),
                          offset: Offset(3, 3),
                          blurRadius: 5,
                        ),
                        BoxShadow(
                          color: colorScheme.surfaceTint.withAlpha(15),
                          offset: Offset(-2, -2),
                          blurRadius: 4,
                        ),
                      ],
              ),
              child: Icon(
                icon,
                color: isSelected ? activeColor : inactiveColor,
                size: 20,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: isSelected ? activeColor : inactiveColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
