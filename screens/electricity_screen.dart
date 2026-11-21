// Sähkönkulutus

import 'package:flutter/material.dart';
import '../utils/translations.dart';
import '../widgets/app_colors.dart';

class ElectricityScreen extends StatelessWidget {
  final double currentElectricity;
  final String currentLanguage;

  const ElectricityScreen({
    super.key,
    required this.currentElectricity,
    required this.currentLanguage,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppTranslations.translate(currentLanguage, 'electr_title'),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // NYKYINEN KULUTUS
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: colorScheme.outlineVariant),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppTranslations.translate(
                              currentLanguage, 'electr_current'),
                          style: TextStyle(color: colorScheme.onSurfaceVariant),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          AppTranslations.translate(
                              currentLanguage, 'electr_today'),
                          style: TextStyle(
                            color: colorScheme.onSurfaceVariant,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    "${currentElectricity.toStringAsFixed(1)} kWh",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.languageIcon,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Text(
              AppTranslations.translate(currentLanguage, 'electr_history'),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            // PYLVÄSDIAGRAMMI
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: colorScheme.outlineVariant,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _buildAdvancedBar(context, 60, "04:00", "0.4 kWh"),
                    _buildAdvancedBar(context, 105, "08:00", "0.9 kWh"),
                    _buildAdvancedBar(context, 165, "12:00", "1.4 kWh"),
                    _buildAdvancedBar(context, 220, "16:00", "1.9 kWh"),
                    _buildAdvancedBar(context, 135, "20:00", "1.1 kWh"),
                    _buildAdvancedBar(context, 75, "24:00", "0.6 kWh"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdvancedBar(
      BuildContext context, double height, String label, String value) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    final List<Color> activeGradient = isDark
        ? [AppColors.darkTemperatureRing2, AppColors.darkTemperatureRing1]
        : [AppColors.lightTemperatureRing2, AppColors.lightTemperatureRing1];

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          value,
          style: TextStyle(
            color: colorScheme.onSurfaceVariant,
            fontSize: 10,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: 24,
          height: height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: activeGradient,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: colorScheme.onSurfaceVariant,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
