import 'package:flutter/material.dart';
import 'package:mi_smart_ac/widgets/thermometer_placehoder_theme_extension.dart';
import 'app_colors.dart';

class ThermometerPlaceholderView extends StatelessWidget {
  const ThermometerPlaceholderView({super.key});

  final double placeholderSize = 244;

  @override
  Widget build(BuildContext context) {
    final placehoderTheme =
        Theme.of(context).extension<ThermometerPlacehoderTheme>();

    final placeholder1 =
        placehoderTheme?.placeholder1 ?? AppColors.darkPlaceholder1;
    final placeholder2 =
        placehoderTheme?.placeholder2 ?? AppColors.darkPlaceholder2;
    final shadowColor =
        placehoderTheme?.placeholderShadow ?? AppColors.darkPlaceholderShadow;
    final shaderMask1 =
        placehoderTheme?.shaderMask1 ?? AppColors.darkPlaceholderShaderMask1;
    final shaderMask2 =
        placehoderTheme?.shaderMask2 ?? AppColors.darkPlaceholderShaderMask2;
    final shaderBorder = placehoderTheme?.shaderBorder ??
        AppColors.darkPlaceholderShaderMaskBoder;
    final innerShadowPainter1 = placehoderTheme?.innerShadowPainter1 ??
        AppColors.darkInnerShadowMaskPainter1;
    final innerShadowPainter2 = placehoderTheme?.innerShadowPainter2 ??
        AppColors.darkInnerShadowMaskPainter2;

    return Container(
      width: placeholderSize,
      height: placeholderSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            placeholder1,
            placeholder2,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Stack(
        children: [
          // 3. MAAGINEN SISÄVARJO:
          Positioned.fill(
            child: CustomPaint(
              painter: InnerShadowMaskPainter(
                color1: innerShadowPainter1,
                color2: innerShadowPainter2,
              ),
            ),
          ),

          // 4. REUNUS: Hiusviiva
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  width: 0.8,
                  color: Colors.transparent,
                ),
              ),
              child: ShaderMask(
                shaderCallback: (bounds) {
                  return LinearGradient(
                    colors: [
                      shaderMask1,
                      shaderMask2,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(bounds);
                },
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      width: 0.8,
                      color: shaderBorder,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Luokka, joka maalaa kuopan yläreunaan alaspäin häviävän 3D-varjon
class InnerShadowMaskPainter extends CustomPainter {
  final Color color1;
  final Color color2;

  InnerShadowMaskPainter({
    required this.color1,
    required this.color2,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8 // Varjon paksuus reunoilla
      // Luodaan pystysuuntainen gradientti
      ..shader = LinearGradient(
        colors: [
          color1, // Tumma varjo ylhäällä
          color2, // Häviää täysin näkymättömiin alhaalla
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(rect)
      // Tehdään viivasta pehmeä ja sumea
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);

    // Piirretään varjorengas hieman siirretynä alaspäin
    final center = Offset(size.width / 2, (size.height / 2) + 3);
    final radius = (size.width / 2) - 3;

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant InnerShadowMaskPainter oldDelegate) {
    return oldDelegate.color1 != color1 || oldDelegate.color2 != color2;
  }
}
