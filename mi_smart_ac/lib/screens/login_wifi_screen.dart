// Kirjautuminen ja Wi-Fi-haku

import 'package:flutter/material.dart';
import 'package:mi_smart_ac/utils/translations.dart';
import 'package:mi_smart_ac/widgets/app_colors.dart';
import 'main_navigation_hub.dart';
import 'dart:async';

class LoginAndWifiScreen extends StatefulWidget {
  final String currentLanguage;
  final Function(String) onLanguageChanged;
  final bool isDarkTheme;
  final Function(bool) onThemeChanged;

  const LoginAndWifiScreen({
    super.key,
    required this.currentLanguage,
    required this.onLanguageChanged,
    required this.isDarkTheme,
    required this.onThemeChanged,
  });

  @override
  State<LoginAndWifiScreen> createState() => _LoginAndWifiScreenState();
}

class _LoginAndWifiScreenState extends State<LoginAndWifiScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isSearchingWifi = false;
  bool _isConnected = false;
  Timer? _wifiTimer;

  void _simuloiWifiHaku() {
    setState(() {
      _isSearchingWifi = true;
    });

    _wifiTimer?.cancel();
    _wifiTimer = Timer(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() {
        _isSearchingWifi = false;
        _isConnected = true;
      });
    });
  }

  @override
  void dispose() {
    _wifiTimer?.cancel();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    final Color onButtonText =
        isDark ? AppColors.loginCard : AppColors.lightBlendMode;

    final String wifiStatusText = _isSearchingWifi
        ? AppTranslations.translate(
            widget.currentLanguage, 'login_searching_device')
        : _isConnected
            ? AppTranslations.translate(
                widget.currentLanguage, 'login_connected_to')
            : AppTranslations.translate(
                widget.currentLanguage, 'login_not_connected');

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: () => widget.onThemeChanged(!isDark),
                  icon: Icon(
                    isDark
                        ? Icons.light_mode_outlined
                        : Icons.dark_mode_outlined,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                AppTranslations.translate(
                    widget.currentLanguage, 'login_title'),
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                AppTranslations.translate(
                    widget.currentLanguage, 'login_header'),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              // SÄHKÖPOSTIKENTTÄ
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: AppTranslations.translate(
                      widget.currentLanguage, 'login_email_label'),
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              // SALASANAKENTTÄ
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: AppTranslations.translate(
                      widget.currentLanguage, 'login_password_label'),
                  prefixIcon: const Icon(Icons.lock),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 40),
              // WI-FI YHTEYSKORTTI
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: isDark
                      ? colorScheme.surfaceContainerHigh
                      : colorScheme.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: isDark
                      ? [
                          BoxShadow(
                            color: AppColors.back.withValues(alpha: 0.4),
                            offset: Offset(4, 4),
                            blurRadius: 12,
                          ),
                          BoxShadow(
                            color: AppColors.lightText.withValues(alpha: 0.04),
                            offset: Offset(-4, -4),
                            blurRadius: 12,
                          ),
                        ]
                      : [
                          BoxShadow(
                            color: colorScheme.shadow.withValues(alpha: 0.2),
                            offset: Offset(4, 4),
                            blurRadius: 12,
                          ),
                          BoxShadow(
                            color: AppColors.lightText.withValues(alpha: 0.9),
                            offset: Offset(-4, -4),
                            blurRadius: 12,
                          ),
                        ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Icon(
                          _isConnected ? Icons.wifi : Icons.wifi_off,
                          color: _isConnected
                              ? AppColors.loginConnect
                              : AppColors.loginNotConnect,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            wifiStatusText,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: _isSearchingWifi ? null : _simuloiWifiHaku,
                      icon: _isSearchingWifi
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: onButtonText,
                              ),
                            )
                          : const Icon(Icons.search),
                      label: Text(
                        AppTranslations.translate(
                            widget.currentLanguage, 'login_btn_seacrh_connect'),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.loginButtonBackground,
                        foregroundColor: onButtonText,
                        padding: EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),
              // KIRJAUDU SISÄÄN -PAINIKE
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => MainNavigationHub(
                        currentLanguage: widget.currentLanguage,
                        onLanguageChanged: widget.onLanguageChanged,
                        isDarkTheme: isDark,
                        onThemeChanged: widget.onThemeChanged,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  backgroundColor: AppColors.loginButtonBackground,
                  foregroundColor: onButtonText,
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  AppTranslations.translate(
                      widget.currentLanguage, 'login_btn_login'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
