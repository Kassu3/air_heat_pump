import 'package:flutter/material.dart';
import 'package:mi_smart_ac/widgets/thermometer_dial_theme_extension.dart';
import 'app_colors.dart';
import 'thermometer_view.dart';

class ThermometerSummaryView extends StatelessWidget {
  final Status status;
  final bool showStatus;
  final double temperature;
  final bool isEcoMode;

  const ThermometerSummaryView({
    super.key,
    required this.status,
    required this.showStatus,
    required this.temperature,
    this.isEcoMode = false,
  });

  @override
  Widget build(BuildContext context) {
    final summaryTheme = Theme.of(context).extension<ThermometerDialTheme>();

    final tempTextColor =
        summaryTheme?.temperatureText ?? AppColors.darkMarkTemperature;

    return IgnorePointer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // 1. MARK: Temperature Status
          AnimatedOpacity(
            opacity: showStatus ? 0.6 : 0.0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeIn,
            child: Text(
              status.value,
              style: TextStyle(
                color: status == Status.heating
                    ? AppColors.markStatusHeating
                    : status == Status.cooling
                        ? AppColors.markStatusCooling
                        : AppColors.markStatusReaching,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
          ),

          const SizedBox(height: 2),

          // 2. MARK: Temperature
          Text(
            temperature.toStringAsFixed(0),
            style: TextStyle(
              color: tempTextColor,
              fontSize: 54,
              fontWeight: FontWeight.w200,
              letterSpacing: -1,
            ),
          ),

          const SizedBox(height: 4),

          // 3. MARK: Eco Leaf Vihreä ekolehti
          Icon(
            Icons.eco_rounded,
            color: isEcoMode
                ? AppColors.markEco
                : Theme.of(context)
                    .colorScheme
                    .onSurfaceVariant
                    .withValues(alpha: 0.25),
            size: 24,
          ),
        ],
      ),
    );
  }
}
