import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';
import '../models/glucose_reading.dart';
import '../state/app_state.dart';
import '../hooks/app_translation.dart';

class TrendChart extends StatelessWidget {
  final List<GlucoseReading> readings;
  final double height;
  final bool isRTL;
  final bool showLabels;

  const TrendChart({
    super.key,
    required this.readings,
    this.height = 200,
    this.isRTL = false,
    this.showLabels = true,
  });

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final tr = AppTranslation(appState.language);

    if (readings.length < 2) {
      return SizedBox(
        height: height,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.show_chart, size: 48, color: Theme.of(context).colorScheme.outline),
              const SizedBox(height: 8),
              Text(
                tr.t('notEnoughData'),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      );
    }

    return SizedBox(
      height: height,
      child: CustomPaint(
        size: Size.infinite,
        painter: _TrendChartPainter(
          readings: readings,
          isRTL: isRTL,
          showLabels: showLabels,
          isDark: Theme.of(context).brightness == Brightness.dark,
        ),
      ),
    );
  }
}

class _TrendChartPainter extends CustomPainter {
  final List<GlucoseReading> readings;
  final bool isRTL;
  final bool showLabels;
  final bool isDark;

  _TrendChartPainter({
    required this.readings,
    required this.isRTL,
    required this.showLabels,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final palette = isDark ? AppColors.dark : AppColors.light;
    final chartLeft = showLabels ? 36.0 : 8.0;
    final chartRight = size.width - 8.0;
    final chartTop = 12.0;
    final chartBottom = size.height - (showLabels ? 24.0 : 8.0);
    final chartWidth = chartRight - chartLeft;
    final chartHeight = chartBottom - chartTop;

    const minValue = 40.0;
    const maxValue = 400.0;
    const rangeMin = 80.0;
    const rangeMax = 180.0;

    // Draw zone bands
    final normalTop = chartTop + chartHeight * (1 - (rangeMax - minValue) / (maxValue - minValue));
    final normalBottom = chartTop + chartHeight * (1 - (rangeMin - minValue) / (maxValue - minValue));

    // Low zone
    canvas.drawRect(
      Rect.fromLTRB(chartLeft, normalBottom, chartRight, chartBottom),
      Paint()..color = AppColors.statusColors('low', isDark).background.withAlpha(40),
    );

    // Normal zone
    canvas.drawRect(
      Rect.fromLTRB(chartLeft, normalTop, chartRight, normalBottom),
      Paint()..color = AppColors.statusColors('normal', isDark).background.withAlpha(60),
    );

    // High zone
    canvas.drawRect(
      Rect.fromLTRB(chartLeft, chartTop, chartRight, normalTop),
      Paint()..color = AppColors.statusColors('high', isDark).background.withAlpha(40),
    );

    // Draw horizontal guide lines
    final guidePaint = Paint()
      ..color = palette.border.withAlpha(60)
      ..strokeWidth = 0.5;

    for (final v in [80.0, 180.0]) {
      final y = chartTop + chartHeight * (1 - (v - minValue) / (maxValue - minValue));
      canvas.drawLine(Offset(chartLeft, y), Offset(chartRight, y), guidePaint);
    }

    // Draw data points and lines
    final sortedReadings = List<GlucoseReading>.from(readings)
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));

    final points = <Offset>[];
    for (int i = 0; i < sortedReadings.length; i++) {
      final reading = sortedReadings[i];
      double x;
      if (isRTL) {
        x = chartRight - (i / (sortedReadings.length - 1)) * chartWidth;
      } else {
        x = chartLeft + (i / (sortedReadings.length - 1)) * chartWidth;
      }
      final y = chartTop + chartHeight * (1 - (reading.value.clamp(40, 400) - minValue) / (maxValue - minValue));
      points.add(Offset(x, y));
    }

    // Draw connecting line
    if (points.length >= 2) {
      final linePaint = Paint()
        ..color = palette.primary.withAlpha(120)
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      final path = Path();
      path.moveTo(points[0].dx, points[0].dy);
      for (int i = 1; i < points.length; i++) {
        // Smooth curve
        final prev = points[i - 1];
        final curr = points[i];
        final controlX = (prev.dx + curr.dx) / 2;
        path.cubicTo(controlX, prev.dy, controlX, curr.dy, curr.dx, curr.dy);
      }
      canvas.drawPath(path, linePaint);

      // Draw gradient fill under line
      final fillPath = Path.from(path);
      fillPath.lineTo(points.last.dx, chartBottom);
      fillPath.lineTo(points.first.dx, chartBottom);
      fillPath.close();

      final fillPaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            palette.primary.withAlpha(40),
            palette.primary.withAlpha(5),
          ],
        ).createShader(Rect.fromLTRB(chartLeft, chartTop, chartRight, chartBottom));

      canvas.drawPath(fillPath, fillPaint);
    }

    // Draw data points
    for (int i = 0; i < points.length; i++) {
      final reading = sortedReadings[i];
      final statusColor = AppColors.statusColors(reading.status, isDark);
      final point = points[i];

      // Outer glow
      canvas.drawCircle(
        point,
        6,
        Paint()..color = statusColor.foreground.withAlpha(30),
      );
      // Point
      canvas.drawCircle(
        point,
        4,
        Paint()..color = statusColor.foreground,
      );
      // Inner white
      canvas.drawCircle(
        point,
        2,
        Paint()..color = Colors.white,
      );
    }

    // Y-axis labels
    if (showLabels) {
      for (final v in [80, 180, 300]) {
        final y = chartTop + chartHeight * (1 - (v - minValue) / (maxValue - minValue));
        final textPainter = TextPainter(
          text: TextSpan(
            text: '$v',
            style: TextStyle(color: palette.mutedForeground, fontSize: 10),
          ),
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        textPainter.paint(canvas, Offset(2, y - textPainter.height / 2));
      }
    }
  }

  @override
  bool shouldRepaint(covariant _TrendChartPainter oldDelegate) {
    return readings != oldDelegate.readings ||
        isRTL != oldDelegate.isRTL ||
        isDark != oldDelegate.isDark;
  }
}
