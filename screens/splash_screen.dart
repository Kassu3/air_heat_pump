// 1. LATAUSSIVU (SPLASH SCREEN)
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mi_smart_ac/utils/translations.dart';
import 'package:mi_smart_ac/widgets/app_colors.dart';
import 'login_wifi_screen.dart';

class SplashScreen extends StatefulWidget {
  final String currentLanguage;
  final Function(String) onLanguageChanged;
  final bool isDarkTheme;
  final Function(bool) onThemeChanged;

  const SplashScreen({
    super.key,
    required this.currentLanguage,
    required this.onLanguageChanged,
    required this.isDarkTheme,
    required this.onThemeChanged,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();
    // Odotetaan 3 sekuntia ja siirrytään Wi-Fi / Kirjautumissivulle
    _navigationTimer = Timer(const Duration(seconds: 3), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => LoginAndWifiScreen(
            currentLanguage: widget.currentLanguage,
            onLanguageChanged: widget.onLanguageChanged,
            isDarkTheme: widget.isDarkTheme,
            onThemeChanged: widget.onThemeChanged,
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.ac_unit,
              size: 100,
              color: AppColors.splashIcon,
            ),
            const SizedBox(height: 24),
            const Text(
              'MIDEA SMART AC',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              AppTranslations.translate(
                  widget.currentLanguage, 'splash_subtitle'),
            ),
            const SizedBox(height: 48),
            CircularProgressIndicator(
              color: isDark
                  ? AppColors.circularProgressIndicator
                  : AppColors.splashIcon,
            ),
          ],
        ),
      ),
    );
  }
}
