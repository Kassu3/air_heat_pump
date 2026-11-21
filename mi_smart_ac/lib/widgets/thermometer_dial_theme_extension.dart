import 'package:flutter/material.dart';

class ThermometerDialTheme extends ThemeExtension<ThermometerDialTheme> {
  final Color outerDial1;
  final Color outerDial2;
  final Color innerDial1;
  final Color innerDial2;
  final Color setpoint1;
  final Color setpoint2;
  final Color shadow1;
  final Color shadow2;
  final Color mask1;
  final Color mask2;
  final Color mode;
  final Color painter1;
  final Color painter2;
  final Color temperatureText;
  final Color temperatureRing1;
  final Color temperatureRing2;
  final Color scaleLine;
  final Color scaleText;

  const ThermometerDialTheme({
    required this.outerDial1,
    required this.outerDial2,
    required this.innerDial1,
    required this.innerDial2,
    required this.setpoint1,
    required this.setpoint2,
    required this.shadow1,
    required this.shadow2,
    required this.mask1,
    required this.mask2,
    required this.mode,
    required this.painter1,
    required this.painter2,
    required this.temperatureText,
    required this.temperatureRing1,
    required this.temperatureRing2,
    required this.scaleLine,
    required this.scaleText,
  });

  @override
  ThermometerDialTheme copyWith({
    Color? outerDial1,
    Color? outerDial2,
    Color? innerDial1,
    Color? innerDial2,
    Color? setpoint1,
    Color? setpoint2,
    Color? shadow1,
    Color? shadow2,
    Color? mask1,
    Color? mask2,
    Color? mode,
    Color? painter1,
    Color? painter2,
    Color? temperatureText,
    Color? temperatureRing1,
    Color? temperatureRing2,
    Color? scaleLine,
    Color? scaleText,
  }) {
    return ThermometerDialTheme(
      outerDial1: outerDial1 ?? this.outerDial1,
      outerDial2: outerDial2 ?? this.outerDial2,
      innerDial1: innerDial1 ?? this.innerDial1,
      innerDial2: innerDial2 ?? this.innerDial2,
      setpoint1: setpoint1 ?? this.setpoint1,
      setpoint2: setpoint2 ?? this.setpoint2,
      shadow1: shadow1 ?? this.shadow1,
      shadow2: shadow2 ?? this.shadow2,
      mask1: mask1 ?? this.mask1,
      mask2: mask2 ?? this.mask2,
      mode: mode ?? this.mode,
      painter1: painter1 ?? this.painter1,
      painter2: painter2 ?? this.painter2,
      temperatureText: temperatureText ?? this.temperatureText,
      temperatureRing1: temperatureRing1 ?? this.temperatureRing1,
      temperatureRing2: temperatureRing2 ?? this.temperatureRing2,
      scaleLine: scaleLine ?? this.scaleLine,
      scaleText: scaleText ?? this.scaleText,
    );
  }

  @override
  ThermometerDialTheme lerp(
      ThemeExtension<ThermometerDialTheme>? other, double t) {
    if (other is! ThermometerDialTheme) return this;
    return ThermometerDialTheme(
      outerDial1: Color.lerp(outerDial1, other.outerDial1, t)!,
      outerDial2: Color.lerp(outerDial2, other.outerDial2, t)!,
      innerDial1: Color.lerp(innerDial1, other.innerDial1, t)!,
      innerDial2: Color.lerp(innerDial2, other.innerDial2, t)!,
      setpoint1: Color.lerp(setpoint1, other.setpoint1, t)!,
      setpoint2: Color.lerp(setpoint2, other.setpoint2, t)!,
      shadow1: Color.lerp(shadow1, other.shadow1, t)!,
      shadow2: Color.lerp(shadow2, other.shadow2, t)!,
      mask1: Color.lerp(mask1, other.mask1, t)!,
      mask2: Color.lerp(mask2, other.mask2, t)!,
      mode: Color.lerp(mode, other.mode, t)!,
      painter1: Color.lerp(painter1, other.painter1, t)!,
      painter2: Color.lerp(painter2, other.painter2, t)!,
      temperatureText: Color.lerp(temperatureText, other.temperatureText, t)!,
      temperatureRing1:
          Color.lerp(temperatureRing1, other.temperatureRing1, t)!,
      temperatureRing2:
          Color.lerp(temperatureRing2, other.temperatureRing2, t)!,
      scaleLine: Color.lerp(scaleLine, other.scaleLine, t)!,
      scaleText: Color.lerp(scaleText, other.scaleText, t)!,
    );
  }
}
