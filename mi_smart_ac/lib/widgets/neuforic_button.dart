import 'package:flutter/material.dart';
import 'app_colors.dart';

class NeuforicButton extends StatefulWidget {
  final Widget icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isDarkTheme;
  final Color iconColor;

  const NeuforicButton(
      {super.key,
      required this.icon,
      required this.label,
      required this.isSelected,
      required this.onTap,
      this.isDarkTheme = true,
      required this.iconColor});

  @override
  State<NeuforicButton> createState() => _NeuforicButtonState();
}

class _NeuforicButtonState extends State<NeuforicButton> {
  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    final Color baseColor = colorScheme.surfaceContainerHigh;

    final Color shadowDark = isDark
        ? AppColors.back.withValues(alpha: 0.5)
        : colorScheme.shadow.withValues(alpha: 0.25);
    final Color shadowLight = isDark
        ? AppColors.lightText.withValues(alpha: 0.05)
        : AppColors.lightText.withValues(alpha: 0.9);

    final List<Color> activeGradient = isDark
        ? [AppColors.darkTemperatureRing1, AppColors.darkTemperatureRing2]
        : [AppColors.lightTemperatureRing1, AppColors.lightTemperatureRing2];

    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: 6, horizontal: 24),
        decoration: BoxDecoration(
          color: baseColor,
          borderRadius: BorderRadius.circular(20),
          gradient:
              widget.isSelected ? LinearGradient(colors: activeGradient) : null,
          boxShadow: widget.isSelected
              ? [
                  BoxShadow(
                    color: activeGradient.first.withValues(alpha: 0.4),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  )
                ]
              : [
                  BoxShadow(
                    color: shadowDark,
                    offset: const Offset(4, 4),
                    blurRadius: 12,
                  ),
                  BoxShadow(
                    color: shadowLight,
                    offset: const Offset(-4, -4),
                    blurRadius: 12,
                  ),
                ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconTheme(
              data: IconThemeData(
                color:
                    widget.isSelected ? AppColors.lightText : widget.iconColor,
                size: 28,
              ),
              child: widget.icon,
            ),
            const SizedBox(height: 8),
            Text(
              widget.label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: widget.isSelected
                    ? AppColors.lightText
                    : (isDark ? AppColors.helpHeader : AppColors.greyText),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
