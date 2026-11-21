import 'package:flutter/material.dart';
import 'dart:math';
import 'package:mi_smart_ac/widgets/thermometer_dial_theme_extension.dart';

class ThermometerDialView extends StatelessWidget {
  final double degrees;

  const ThermometerDialView({
    super.key,
    this.degrees = 0,
  });

  final double outerDialSize = 200;
  final double innerDialSize = 172;
  final double setpointSize = 15;

  @override
  Widget build(BuildContext context) {
    final dialTheme = Theme.of(context).extension<ThermometerDialTheme>()!;
    return Container(
      width: outerDialSize,
      height: outerDialSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        // [Outer Dial 1 -> Outer Dial 2]
        gradient: LinearGradient(
          colors: [
            dialTheme.outerDial1,
            dialTheme.outerDial2,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        // Lisätään heti pehmeä 3D-varjo, jotta kiekko nousee visuaalisesti urasta ylös
        boxShadow: [
          // DROP SHADOW 1
          BoxShadow(
            color: dialTheme.shadow1,
            blurRadius: 20,
            offset: const Offset(0, 4), // Varjo alaoikealle
          ),
          // DROP SHADOW 2
          BoxShadow(
            color: dialTheme.shadow2,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 1. SISÄINEN VALOHEIJASTUS: Alareunan sumennettu hohde
          Positioned.fill(
            child: CustomPaint(
              painter: DialInnerLightPainter(
                color1: dialTheme.painter1,
                color2: dialTheme.painter2,
              ),
            ),
          ),

          // UUSI OVERLAY-REUNUS
          // Käytetään ShaderMaskia, jotta saa reunaviivalle liukuvärin kirkkaasta tummaan
          Positioned.fill(
            child: ShaderMask(
              shaderCallback: (bounds) {
                return LinearGradient(
                  colors: [
                    dialTheme.mask1, // Ylävasen kirkas valo
                    dialTheme.mask2, // Alaoikea varjo
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds);
              },
              blendMode: BlendMode
                  .srcIn, // Varmistaa, että gradientti tarttuu vain viivaan
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    width: 1.0,
                    color: dialTheme
                        .mode, // Väri yläpuolen ShaderMask-gradientilla
                  ),
                ),
              ),
            ),
          ),

          // 3. UUSI KERROS: Inner Dial (172x172 kokoinen sisänuppi)
          Center(
            child: Container(
              width: innerDialSize,
              height: innerDialSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                // [Inner Dial 1 -> Inner Dial 2]
                gradient: LinearGradient(
                  colors: [
                    dialTheme.innerDial1,
                    dialTheme.innerDial2,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),

          // 4. UUSI KERROS: Temperature Setpoint (Pyörivä osoitinnuppi)
          Center(
            child: SizedBox(
              width: innerDialSize,
              height: innerDialSize,
              child: Transform.rotate(
                // Muunnetaan asteet radiaaneiksi ja lisätään +180 astetta
                angle: (degrees + 180) * pi / 180,
                child: Align(
                  alignment: Alignment.topCenter, // Lukitaan nuppi yläreunaan
                  child: Container(
                    width: setpointSize,
                    height: setpointSize,
                    margin: EdgeInsets.only(top: setpointSize / 2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          dialTheme.setpoint1, // Temperature Setpoint 1
                          dialTheme.setpoint2, // Temperature Setpoint 2
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
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

// Luokka, joka maalaa kiekon alareunaan sumennetun valoheijastuksen
class DialInnerLightPainter extends CustomPainter {
  final Color color1;
  final Color color2;

  DialInnerLightPainter({
    required this.color1,
    required this.color2,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..shader = LinearGradient(
        colors: [
          color1, // Kirkkaampi valo alhaalla
          color2, // Häviää täysin näkymättömiin ylhäällä
        ],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      ).createShader(rect)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);

    // siirretään ympyrää hieman kaakkoon
    final center = Offset((size.width / 2) + 3, (size.height / 2) + 3);
    final radius = (size.width / 2) - 4;

    // Rajataan maalaus vain kiekon sisäpuolelle, jotta blurri ei karkaa ulos reunoista
    canvas.clipPath(Path()..addOval(Offset.zero & size));

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant DialInnerLightPainter oldDelegate) {
    return oldDelegate.color1 != color1 || oldDelegate.color2 != color2;
  }
}
