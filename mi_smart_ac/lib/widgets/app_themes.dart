// Teemat
import 'package:flutter/material.dart';
import 'package:mi_smart_ac/widgets/thermometer_dial_theme_extension.dart';
import 'package:mi_smart_ac/widgets/thermometer_placehoder_theme_extension.dart';
import 'app_colors.dart';

class AppThemes {
  // --- VAALEA TEEMA ---
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.lightBackground,
    cardColor: AppColors.lightCardBg,
    primaryColor: AppColors.lightPrimary,
    iconTheme: IconThemeData(color: AppColors.lightIcon),
    inputDecorationTheme: InputDecorationTheme(
      prefixIconColor: AppColors.lightInputIcon,
      hintStyle: TextStyle(color: AppColors.lightHintText),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: AppColors.lightInputBorder,
          width: 1.0,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: AppColors.loginInputClick,
          width: 2.0,
        ),
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: AppColors.lightIcon),
      actionsIconTheme: IconThemeData(color: AppColors.lightIcon),
      titleTextStyle: TextStyle(
        color: AppColors.lightTitle,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
    ),
    colorScheme: ColorScheme.light(
      surfaceContainer: AppColors.lightCardBg,
      surfaceContainerHigh: AppColors.lightFilterWarningCard,
      surfaceContainerLowest: AppColors.lightNavBackground,
      outlineVariant: AppColors.lightCardBorder,
      onSurface: AppColors.lightLabel,
      onSurfaceVariant: AppColors.lightHintText,
      shadow: AppColors.lightCardShadow,
      surfaceTint: AppColors.lightCardBg,
      tertiary: AppColors.lightFilterIconText,
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: AppColors.lightTitle),
      bodyMedium: TextStyle(color: AppColors.lightHintText),
      bodySmall: TextStyle(color: AppColors.lightTitle),
      titleMedium: TextStyle(color: AppColors.lightTitle),
    ),
    datePickerTheme: DatePickerThemeData(
      backgroundColor: AppColors.lightBackground,
      headerBackgroundColor: AppColors.lightTemperatureRing2,
      headerForegroundColor: AppColors.lightLightText,
      todayBorder: BorderSide(color: AppColors.lightTemperatureRing2),
      dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.lightTemperatureRing2;
        }
        return null;
      }),
      dayForegroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.lightText;
        }
        return AppColors.lightTitle;
      }),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.lightTemperatureRing2,
      ),
    ),
    timePickerTheme: TimePickerThemeData(
      backgroundColor: AppColors.lightBackground,
      dialHandColor: AppColors.lightTemperatureRing2,
      hourMinuteColor: AppColors.lightTemperatureRing2.withValues(alpha: 0.2),
      hourMinuteTextColor: AppColors.lightTemperatureRing2,
      dayPeriodColor: AppColors.lightTemperatureRing2.withValues(alpha: 0.2),
      dayPeriodTextColor: AppColors.lightTemperatureRing2,
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.snackBar,
      contentTextStyle: TextStyle(color: AppColors.lightBlendMode),
    ),
    sliderTheme: SliderThemeData(),
    extensions: [
      ThermometerDialTheme(
        outerDial1: AppColors.lightOuterDial1,
        outerDial2: AppColors.lightOuterDial2,
        innerDial1: AppColors.lightInnerDial1,
        innerDial2: AppColors.lightInnerDial2,
        setpoint1: AppColors.lightTempSetpoint1,
        setpoint2: AppColors.lightTempSetpoint2,
        shadow1: AppColors.lightOuterDialShadow1,
        shadow2: AppColors.lightOuterDialShadow2,
        mask1: AppColors.lightOuterShaderMask1,
        mask2: AppColors.lightOuterShaderMask2,
        mode: AppColors.lightBlendMode,
        painter1: AppColors.lightDialInnerPainter1,
        painter2: AppColors.lightDialInnerPainter2,
        temperatureText: AppColors.lightMarkTemperature,
        temperatureRing1: AppColors.lightTemperatureRing1,
        temperatureRing2: AppColors.lightTemperatureRing2,
        scaleLine: AppColors.lightScaleLine,
        scaleText: AppColors.lightTextStyle,
      ),
      ThermometerPlacehoderTheme(
        placeholder1: AppColors.lightPlaceholder1,
        placeholder2: AppColors.lightPlaceholder2,
        placeholderShadow: AppColors.lightPlaceholderShadow,
        shaderMask1: AppColors.lightPlaceholderShaderMask1,
        shaderMask2: AppColors.lightPlaceholderShaderMask2,
        shaderBorder: AppColors.lightPlaceholderShaderMaskBoder,
        innerShadowPainter1: AppColors.lightInnerShadowMaskPainter1,
        innerShadowPainter2: AppColors.lightInnerShadowMaskPainter2,
      ),
    ],
  );

  // --- TUMMA TEEMA ---
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: AppColors.darkPrimary,
    scaffoldBackgroundColor: AppColors.darkBackground,
    cardColor: AppColors.darkCardBg,
    iconTheme: IconThemeData(color: AppColors.darkIcon),
    inputDecorationTheme: InputDecorationTheme(
      prefixIconColor: AppColors.darkInputIcon,
      hintStyle: TextStyle(color: AppColors.darkHintText),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: AppColors.darkInputBorder,
          width: 1.0,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: AppColors.loginInputClick,
          width: 2.0,
        ),
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: AppColors.darkIcon),
      actionsIconTheme: IconThemeData(color: AppColors.darkIcon),
      titleTextStyle: TextStyle(
        color: AppColors.darkTitle,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: AppColors.darkTitle), // Syöteteksti
      bodyMedium: TextStyle(color: AppColors.helpHeader), // Ohjeteksti
      bodySmall: TextStyle(color: AppColors.darkTitle), // Otsikko
      titleMedium: TextStyle(color: AppColors.darkTitle),
    ),
    datePickerTheme: DatePickerThemeData(
      backgroundColor: AppColors.darkBackground,
      headerBackgroundColor: AppColors.darkTemperatureRing1,
      headerForegroundColor: AppColors.darkBackground,
      todayBorder: BorderSide(color: AppColors.darkTemperatureRing1),
    ),
    timePickerTheme: TimePickerThemeData(
      backgroundColor: AppColors.darkBackground,
      dialHandColor: AppColors.darkTemperatureRing1,
      hourMinuteColor: AppColors.darkTemperatureRing1.withValues(alpha: 0.2),
      hourMinuteTextColor: AppColors.darkTemperatureRing1,
    ),
    colorScheme: ColorScheme.dark(
      surfaceContainer: AppColors.darkCardBg,
      surfaceContainerHigh: AppColors.darkFilterWarningCard,
      surfaceContainerLowest: AppColors.darkNavBackground,
      outlineVariant: AppColors.darkCardBorder,
      onSurface: AppColors.darkLabel,
      onSurfaceVariant: AppColors.helpHeader,
      shadow: AppColors.darkCardShadow,
      surfaceTint: AppColors.darkCardBg,
      tertiary: AppColors.darkFilterIconText,
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.snackBar,
      contentTextStyle: TextStyle(color: AppColors.lightText),
    ),
    sliderTheme: SliderThemeData(),
    extensions: [
      ThermometerDialTheme(
        outerDial1: AppColors.darkOuterDial1,
        outerDial2: AppColors.darkOuterDial2,
        innerDial1: AppColors.darkInnerDial1,
        innerDial2: AppColors.darkInnerDial2,
        setpoint1: AppColors.darkTempSetpoint1,
        setpoint2: AppColors.darkTempSetpoint2,
        shadow1: AppColors.darkOuterDialShadow1,
        shadow2: AppColors.darkOuterDialShadow2,
        mask1: AppColors.darkOuterShaderMask1,
        mask2: AppColors.darkOuterShaderMask2,
        mode: AppColors.darkBlendMode,
        painter1: AppColors.darkDialInnerPainter1,
        painter2: AppColors.darkDialInnerPainter2,
        temperatureText: AppColors.darkMarkTemperature,
        temperatureRing1: AppColors.darkTemperatureRing1,
        temperatureRing2: AppColors.darkTemperatureRing2,
        scaleLine: AppColors.darkScaleLine,
        scaleText: AppColors.darkTextStyle,
      ),
      ThermometerPlacehoderTheme(
        placeholder1: AppColors.darkPlaceholder1,
        placeholder2: AppColors.darkPlaceholder2,
        placeholderShadow: AppColors.darkPlaceholderShadow,
        shaderMask1: AppColors.darkPlaceholderShaderMask1,
        shaderMask2: AppColors.darkPlaceholderShaderMask2,
        shaderBorder: AppColors.darkPlaceholderShaderMaskBoder,
        innerShadowPainter1: AppColors.darkInnerShadowMaskPainter1,
        innerShadowPainter2: AppColors.darkInnerShadowMaskPainter2,
      ),
    ],
  );
}
