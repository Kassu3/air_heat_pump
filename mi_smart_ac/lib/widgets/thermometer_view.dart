import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // TARVITAAN VÄRINÄPALAUTETTA (HapticFeedback) VARTEN!
import 'package:mi_smart_ac/widgets/thermometer_dial_theme_extension.dart';
import 'dart:math';
import 'thermometer_placeholder_view.dart';
import 'thermometer_dial_view.dart';
import 'thermometer_summary_view.dart';
import 'thermometer_scale_view.dart';

enum Status {
  heating('HEATING'),
  cooling('COOLING'),
  reaching('REACHING');

  final String value;
  const Status(this.value);
}

class ThermometerView extends StatefulWidget {
  final double currentTemperature;
  final double targetTemperature; // Sormella säädettävä tavoite
  final ValueChanged<double>
      onCurrentTemperatureTick; // Kytketään ajastin päänäkymään
  final ValueChanged<double> onTargetTemperatureChanged;
  final Color modeColor;
  final String currentMode;
  final bool isEcoMode;

  const ThermometerView({
    super.key,
    required this.currentTemperature,
    required this.targetTemperature,
    required this.onCurrentTemperatureTick,
    required this.onTargetTemperatureChanged,
    required this.modeColor,
    required this.currentMode,
    this.isEcoMode = false,
  });

  @override
  State<ThermometerView> createState() => _ThermometerViewState();
}

class _ThermometerViewState extends State<ThermometerView> {
  final double ringSize = 220;

  final double minTemperature = 4.0;
  final double maxTemperature = 30.0;

  // Pidetään kirjaa edellisestä pyöristetystä asteluvusta värinää varten
  int _lastIntTemp = 22;

  // showStatus muuttuja (ohjaa tilatekstin näkyvyyttä)
  bool _showStatus = true;

  // Sekuntiajastin
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Käynnistetään ajastin sekunnin välein
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _handleTimerTick();
    });
  }

  @override
  void dispose() {
    // Perutaan ajastin, kun näkymästä poistutaan
    _timer?.cancel();
    super.dispose();
  }

  // Ajastimen logiikka: vertaa lämpötiloja ja muuttaa arvoa asteella sekunnissa
  void _handleTimerTick() {
    final current = double.parse(widget.currentTemperature.toStringAsFixed(1));
    final target = double.parse(widget.targetTemperature.toStringAsFixed(1));

    if (current < target) {
      setState(() {
        _showStatus = true;
      });
      widget.onCurrentTemperatureTick(widget.currentTemperature + 1.0);
    } else if (current > target) {
      setState(() {
        _showStatus = true;
      });
      widget.onCurrentTemperatureTick(widget.currentTemperature - 1.0);
    } else {
      setState(() {
        _showStatus = false;
      }); // Piilotetaan teksti kun REACHING saavutetaan
    }
  }

  Status get _calculatedStatus {
    final current = double.parse(widget.currentTemperature.toStringAsFixed(1));
    final target = double.parse(widget.targetTemperature.toStringAsFixed(1));

    if (current < target) return Status.heating;
    if (current > target) return Status.cooling;
    return Status.reaching;
  }

  // KALIBROITU LASKENTA (ALKAA KLO 7:12 / 126°): Korjaa 10° kohdan osumaan tasan kymmeneen!
  double _calculateTargetTemperature(double degrees) {
    double angleFromStart = degrees - 126.0;
    if (angleFromStart < 0) {
      angleFromStart += 360.0;
    }

    // Kokonaismatka 126 asteesta (4°) aina 360 asteeseen (30°) asti on tasan 234 astetta (26 astetta × 9°)
    double factor = angleFromStart / 234.0;
    factor = factor.clamp(0.0, 1.0);

    return minTemperature + factor * (maxTemperature - minTemperature);
  }

  // KALIBROITU OSOITIN (ALKAA KLO 7:12): Synkronoi osoitinnupin paikan täydellisesti lukujen kanssa
  // Nyt 4° = 126°, 10° = tasan 180° (klo 9), 20° = tasan 270° (klo 12) ja 30° = tasan 360° (klo 3)
  double _calculateDegrees(double temperature) {
    double factor =
        (temperature - minTemperature) / (maxTemperature - minTemperature);
    factor = factor.clamp(0.0, 1.0);

    // Etenee 126 asteesta myötäpäivään tasan 234 astetta
    double degrees = 126.0 + (factor * 234.0);
    if (degrees >= 360) degrees -= 360;

    // Korjataan pyöritysraami vähentämällä tasan 90 astetta
    double finalDegrees = degrees - 90.0;
    if (finalDegrees < 0) finalDegrees += 360;

    return finalDegrees;
  }

  void _updateInteraction(Offset localPosition, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final angle =
        atan2(localPosition.dy - center.dy, localPosition.dx - center.dx);
    double degrees = angle * 180 / pi;
    if (degrees < 0) degrees += 360;

    // Estetään hyppäys kuolleella alueella alhaalla (0° - 126° välillä)
    if (degrees > 0 && degrees < 126) return;

    // MEKAANINEN LUKITUS: Napsautetaan kulma tasan 9 asteen välein viivoille
    double snappedDegrees = (degrees / 9.0).round() * 9.0;

    final newTarget = _calculateTargetTemperature(snappedDegrees);

    // Värinäpalaute
    int currentIntTemp = newTarget.round();
    if (currentIntTemp != _lastIntTemp) {
      HapticFeedback.lightImpact();
      _lastIntTemp = currentIntTemp;
    }

    widget.onTargetTemperatureChanged(newTarget);
  }

  @override
  Widget build(BuildContext context) {
    final currentDegrees = _calculateDegrees(widget.targetTemperature);

    // Liukurengas seuraa nyt dynaamisesti tavoitelämpötilaa ja kasvaa vastapäivään oikealta vasemmalle!
    final ringValue = (widget.targetTemperature - minTemperature) /
        (maxTemperature - minTemperature);
    final activeStatus = _calculatedStatus;

    final dialTheme = Theme.of(context).extension<ThermometerDialTheme>()!;
    final ringColor1 = dialTheme.temperatureRing1;
    final ringColor2 = dialTheme.temperatureRing2;

    return GestureDetector(
      onPanUpdate: (details) =>
          _updateInteraction(details.localPosition, Size(244, 244)),
      onPanDown: (details) =>
          _updateInteraction(details.localPosition, Size(244, 244)),
      child: SizedBox(
        width: 244, // 276
        height: 244, // 276
        child: Stack(
          alignment: Alignment.center,
          children: [
            // KERROS 0: Asteikkoviivat kaikkein alimpana taustalla (276x276)
            ThermometerScaleView(),

            // KERROS 1: 3D-kuoppapohja
            ThermometerPlaceholderView(),

            // KERROS 2: UUSI: Lämpötilan liukurengaskaari
            SizedBox(
              width: ringSize,
              height: ringSize,
              child: CustomPaint(
                painter: TemperatureRingPainter(
                  ringValue: ringValue,
                  color1: ringColor1,
                  color2: ringColor2,
                ),
              ),
            ),

            // KERROS 3: UUSI: Mekaaninen ulompi säädinkiekko (200x200)
            ThermometerDialView(
                degrees: currentDegrees), // Laitetaan kulmaksi aluksi 0

            // KERROS 4: UUSI: Lämpötilatekstit ja Tila suoraan nupin keskelle
            ThermometerSummaryView(
              status: activeStatus,
              showStatus: _showStatus,
              temperature: widget.targetTemperature,
              isEcoMode: widget.isEcoMode,
            ),
          ],
        ),
      ),
    );
  }
}

// Luokka, joka piirtää tarkan brändigradientti-kaaren pyöristetyillä päillä
class TemperatureRingPainter extends CustomPainter {
  final double ringValue;
  final Color color1;
  final Color color2;

  TemperatureRingPainter({
    required this.ringValue,
    required this.color1,
    required this.color2,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final double radius = (size.width / 2) - 5;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 13
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..shader = LinearGradient(
        colors: [
          color2,
          color1,
        ],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    // YMPYRÄKAARI: Alkaa täsmälleen 126 asteesta ja kasvaa myötäpäivään tasan 234 astetta suoraan oikealle sivulle (klo 3)!
    const double startAngle = 126 * pi / 180;
    final double sweepAngle = (234 * ringValue) * pi / 180;

    // Piirtää renkaan vain, jos arvo on nollaa suurempi
    if (ringValue > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant TemperatureRingPainter oldDelegate) {
    return oldDelegate.ringValue != ringValue ||
        oldDelegate.color1 != color1 ||
        oldDelegate.color2 != color2;
  }
}
