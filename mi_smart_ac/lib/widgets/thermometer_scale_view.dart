import 'package:flutter/material.dart';
import 'package:mi_smart_ac/widgets/thermometer_dial_theme_extension.dart';
import 'dart:math';
import 'app_colors.dart';

class ThermometerScaleView extends StatelessWidget {
  const ThermometerScaleView({super.key});

  final double scaleSize = 244;

  @override
  Widget build(BuildContext context) {
    final dialTheme = Theme.of(context).extension<ThermometerDialTheme>();
    final lineColor = dialTheme?.scaleLine ?? AppColors.darkScaleLine;
    final textColor = dialTheme?.scaleText ?? AppColors.darkTextStyle;
    return SizedBox(
      width: scaleSize,
      height: scaleSize,
      child: CustomPaint(
        painter: ScaleAndMarkingsPainter(
          lineColor: lineColor,
          textColor: textColor,
        ),
      ),
    );
  }
}

// Luokka, joka maalaa sekä viivat että luvut täydellisen symmetrisesti
class ScaleAndMarkingsPainter extends CustomPainter {
  final Color lineColor;
  final Color textColor;

  ScaleAndMarkingsPainter({
    required this.lineColor,
    required this.textColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Viivojen etäisyys keskipisteestä (istuu napakasti 244-kuopan reunalla)
    final double lineOuterRadius = 132;
    final double lineInnerRadius = lineOuterRadius - 7;

    // 1. VIIVOJEN MAALAUSTYYLI
    final linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round;

    // Piirretään 21 viivaa tasan vasemmalta (klo 9) yläkautta oikealle (klo 3)
    for (int line = 0; line < 21; line++) {
      final double degrees =
          -180 + (line * 9); // Aloitus -180° (klo 9) ja 9° välein myötäpäivään
      final double rad = degrees * pi / 180;

      // Viiva osoittaa ulkokehältä 8 pikseliä sisäänpäin kohti säädintä
      final startOffset = Offset(
        center.dx + lineInnerRadius * cos(rad),
        center.dy + lineInnerRadius * sin(rad),
      );
      final endOffset = Offset(
        center.dx + lineOuterRadius * cos(rad),
        center.dy + lineOuterRadius * sin(rad),
      );

      canvas.drawLine(startOffset, endOffset, linePaint);
    }

    // 2. NUMEROIDEN MAALAUSTYYLI
    final textStyle = TextStyle(
      color: textColor,
      fontSize: 12,
      fontWeight: FontWeight.bold,
      fontFamily: 'sans-serif',
    );

    // Numeroiden etäisyys keskipisteestä (työntää numerot reilusti viivojen ulkopuolelle!)
    // Koska lineRadius on n. 120, viemme tekstin etäisyydelle 138, eli 18px viivojen ulkopuolelle!
    final double textRadius = lineOuterRadius + 16;

    // Piirretään numerot 10°, 20° ja 30°
    final labels = {
      -180: '10°', // Tasan vasen laita (klo 9)
      -90: '20°', // Tasan yläreuna (klo 12)
      0: '30°', // Tasan oikea laita (klo 3)
    };

    labels.forEach((degree, text) {
      final double rad = degree * pi / 180;

      // Lasketaan tekstin dynaaminen keskipiste kehällä
      final textCenter = Offset(
        center.dx + textRadius * cos(rad),
        center.dy + textRadius * sin(rad),
      );

      // Luodaan TextPainter kirjaimen piirtämistä varten
      final textPainter = TextPainter(
        text: TextSpan(text: text, style: textStyle),
        textDirection: TextDirection.ltr,
      )..layout();

      // Korjataan tekstin sijoitus niin, että se piirtyy täsmälleen oman pisteensä keskelle
      final textOffset = Offset(
        textCenter.dx - (textPainter.width / 2),
        textCenter.dy - (textPainter.height / 2),
      );

      textPainter.paint(canvas, textOffset);
    });
  }

  @override
  bool shouldRepaint(covariant ScaleAndMarkingsPainter oldDelegate) {
    return oldDelegate.lineColor != lineColor ||
        oldDelegate.textColor != textColor;
  }
}
