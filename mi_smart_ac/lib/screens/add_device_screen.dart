// Uuden laitteen lisääminen
import 'package:flutter/material.dart';
import 'package:mi_smart_ac/widgets/thermometer_dial_theme_extension.dart';
import '../utils/translations.dart';
import '../widgets/app_colors.dart';

class AddDeviceScreen extends StatefulWidget {
  final String currentLanguage;
  const AddDeviceScreen({super.key, required this.currentLanguage});

  @override
  State<AddDeviceScreen> createState() => _AddDeviceScreenState();
}

class _AddDeviceScreenState extends State<AddDeviceScreen> {
  final _nameController = TextEditingController();
  final _ipController = TextEditingController();
  String _selectedModel = "Midea Mission II";

  @override
  Widget build(BuildContext context) {
    final dialTheme = Theme.of(context).extension<ThermometerDialTheme>();
    final buttonColor1 =
        dialTheme?.temperatureRing1 ?? AppColors.darkTemperatureRing1;
    final buttonColor2 =
        dialTheme?.temperatureRing2 ?? AppColors.darkTemperatureRing2;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppTranslations.translate(widget.currentLanguage, 'add_title'),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              AppTranslations.translate(widget.currentLanguage, 'add_desc'),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: AppTranslations.translate(
                    widget.currentLanguage, 'add_name'),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _ipController,
              decoration: InputDecoration(
                labelText:
                    AppTranslations.translate(widget.currentLanguage, 'add_ip'),
                hintText: "192.168.4.1",
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _selectedModel,
              decoration: InputDecoration(
                labelText: AppTranslations.translate(
                    widget.currentLanguage, 'add_model'),
                border: const OutlineInputBorder(),
              ),
              items: ["Midea Mission II", "Midea Blanc", "Midea All Easy Pro"]
                  .map((model) {
                return DropdownMenuItem(
                  value: model,
                  child: Text(model),
                );
              }).toList(),
              onChanged: (val) => setState(() => _selectedModel = val!),
            ),
            const SizedBox(height: 32),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: LinearGradient(
                  colors: [buttonColor1, buttonColor2],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: buttonColor1.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        AppTranslations.translate(
                            widget.currentLanguage, 'add_success'),
                      ),
                    ),
                  );
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.add_moderator),
                label: Text(
                  AppTranslations.translate(widget.currentLanguage, 'add_save'),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  foregroundColor: AppColors.lightText,
                  padding: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
