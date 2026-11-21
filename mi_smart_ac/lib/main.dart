// Sovelluksen käynnistys ja lataussivu
import 'package:flutter/material.dart';
import 'package:mi_smart_ac/screens/splash_screen.dart';
import 'package:mi_smart_ac/widgets/app_themes.dart';

void main() {
  runApp(const MideaSmartACApp());
}

class MideaSmartACApp extends StatefulWidget {
  const MideaSmartACApp({super.key});

  @override
  State<MideaSmartACApp> createState() => _MideaSmartACAppState();
}

class _MideaSmartACAppState extends State<MideaSmartACApp> {
  String _currentLanguage = 'English';
  bool _isDarkTheme = true;

  void _changeLanguage(String newLang) {
    setState(() {
      _currentLanguage = newLang;
    });
  }

  void _toggleTheme(bool newValue) {
    setState(() {
      _isDarkTheme = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Midea Smart AC',
      debugShowCheckedModeBanner: false,
      themeMode: _isDarkTheme ? ThemeMode.dark : ThemeMode.light,
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      home: SplashScreen(
        currentLanguage: _currentLanguage,
        onLanguageChanged: _changeLanguage,
        isDarkTheme: _isDarkTheme,
        onThemeChanged: _toggleTheme,
      ),
    );
  }
}
