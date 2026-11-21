import 'package:flutter/material.dart';

class ThermometerPlacehoderTheme
    extends ThemeExtension<ThermometerPlacehoderTheme> {
  final Color placeholder1;
  final Color placeholder2;
  final Color placeholderShadow;
  final Color shaderMask1;
  final Color shaderMask2;
  final Color shaderBorder;
  final Color innerShadowPainter1;
  final Color innerShadowPainter2;

  const ThermometerPlacehoderTheme({
    required this.placeholder1,
    required this.placeholder2,
    required this.placeholderShadow,
    required this.shaderMask1,
    required this.shaderMask2,
    required this.shaderBorder,
    required this.innerShadowPainter1,
    required this.innerShadowPainter2,
  });

  @override
  ThermometerPlacehoderTheme copyWith({
    Color? placeholder1,
    Color? placeholder2,
    Color? placeholderShadow,
    Color? shaderMask1,
    Color? shaderMask2,
    Color? shaderBorder,
    Color? innerShadowPainter1,
    Color? innerShadowPainter2,
  }) {
    return ThermometerPlacehoderTheme(
      placeholder1: placeholder1 ?? this.placeholder1,
      placeholder2: placeholder2 ?? this.placeholder2,
      placeholderShadow: placeholderShadow ?? this.placeholderShadow,
      shaderMask1: shaderMask1 ?? this.shaderMask1,
      shaderMask2: shaderMask2 ?? this.shaderMask2,
      shaderBorder: shaderBorder ?? this.shaderBorder,
      innerShadowPainter1: innerShadowPainter1 ?? this.innerShadowPainter1,
      innerShadowPainter2: innerShadowPainter2 ?? this.innerShadowPainter2,
    );
  }

  @override
  ThermometerPlacehoderTheme lerp(
      ThemeExtension<ThermometerPlacehoderTheme>? other, double t) {
    if (other is! ThermometerPlacehoderTheme) return this;
    return ThermometerPlacehoderTheme(
      placeholder1: Color.lerp(placeholder1, other.placeholder1, t)!,
      placeholder2: Color.lerp(placeholder2, other.placeholder2, t)!,
      placeholderShadow:
          Color.lerp(placeholderShadow, other.placeholderShadow, t)!,
      shaderMask1: Color.lerp(shaderMask1, other.shaderMask1, t)!,
      shaderMask2: Color.lerp(shaderMask2, other.shaderMask2, t)!,
      shaderBorder: Color.lerp(shaderBorder, other.shaderBorder, t)!,
      innerShadowPainter1:
          Color.lerp(innerShadowPainter1, other.innerShadowPainter1, t)!,
      innerShadowPainter2:
          Color.lerp(innerShadowPainter2, other.innerShadowPainter2, t)!,
    );
  }
}
