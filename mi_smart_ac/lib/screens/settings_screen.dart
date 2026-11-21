// Kielivalikko, käyttöohje

import 'package:flutter/material.dart';
import '../utils/translations.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/app_colors.dart';

class SettingsScreen extends StatefulWidget {
  final String initialLanguage;
  final bool isDarkTheme;
  final Function(bool) onThemeChanged;

  const SettingsScreen({
    super.key,
    required this.initialLanguage,
    required this.isDarkTheme,
    required this.onThemeChanged,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late String _selectedLanguage;
  late bool _localIsDark;

  @override
  void initState() {
    super.initState();
    _selectedLanguage = widget.initialLanguage;

    _localIsDark = widget.isDarkTheme;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppTranslations.translate(_selectedLanguage, 'settings_title'),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, _selectedLanguage),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            AppTranslations.translate(_selectedLanguage, 'user_settings'),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          // 4 ERILAISTA KIELIVAIHTOEHTOA
          ListTile(
            leading: const Icon(
              Icons.language,
              color: AppColors.languageIcon,
            ),
            title: Text(
              AppTranslations.translate(_selectedLanguage, 'app_lang'),
            ),
            trailing: DropdownButton<String>(
              value: _selectedLanguage,
              dropdownColor: _localIsDark
                  ? AppColors.dropdownColor
                  : Theme.of(context).colorScheme.surfaceContainerHigh,
              underline: const SizedBox(),
              items: ["Suomi", "English", "Svenska", "Deutsch"].map((lang) {
                return DropdownMenuItem(value: lang, child: Text(lang));
              }).toList(),
              onChanged: (val) {
                if (val != null) {
                  setState(() => _selectedLanguage = val);
                }
              },
            ),
          ),
          const Divider(
            color: AppColors.dividerColor,
          ),

          SwitchListTile(
            value: _localIsDark,
            title: Text(
              _localIsDark
                  ? AppTranslations.translate(_selectedLanguage, 'dark_mode')
                  : AppTranslations.translate(_selectedLanguage, 'light_mode'),
            ),
            secondary: Icon(
              _localIsDark
                  ? Icons.dark_mode_outlined
                  : Icons.light_mode_outlined,
            ),
            onChanged: (bool newValue) {
              setState(() {
                _localIsDark = newValue;
              });

              widget.onThemeChanged(newValue);
            },
          ),
          const SizedBox(height: 32),

          Text(
            AppTranslations.translate(_selectedLanguage, 'support'),
            style: const TextStyle(
              color: AppColors.helpHeader,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          ListTile(
            leading: const Icon(
              Icons.menu_book_outlined,
              color: AppColors.markEco,
            ),
            title: Text(
              AppTranslations.translate(_selectedLanguage, 'manual'),
            ),
            subtitle: Text(
              AppTranslations.translate(_selectedLanguage, 'manual_sub'),
            ),
            trailing: const Icon(
              Icons.open_in_new,
              size: 20,
              color: AppColors.helpHeader,
            ),
            onTap: () async {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    AppTranslations.translate(
                        _selectedLanguage, 'toast_manual'),
                  ),
                ),
              );
              //Käyttöohje
              final Uri url = Uri.parse('https://midea.com');
              if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                throw Exception('Could not launch $url');
              }
            },
          ),
          const Divider(color: AppColors.dividerColor),
        ],
      ),
    );
  }
}
