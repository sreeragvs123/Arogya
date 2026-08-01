import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class MorningOverviewCard extends StatelessWidget {
  final int consultationsToday;
  final int capacityPercent;

  const MorningOverviewCard({
    super.key,
    this.consultationsToday = 12,
    this.capacityPercent = 85,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('MORNING OVERVIEW',
              style: TextStyle(color: Colors.white70, fontSize: 11.5, fontWeight: FontWeight.w700, letterSpacing: 0.8)),
          const SizedBox(height: 10),
          Text('You have $consultationsToday consultations scheduled for today.',
              style: const TextStyle(color: Colors.white, fontSize: 15.5)),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('$capacityPercent%',
                      style: const TextStyle(
                          color: Colors.white, fontSize: 26, fontWeight: FontWeight.w700)),
                  const Text('Capacity Filled', style: TextStyle(color: Colors.white70, fontSize: 13)),
                ],
              ),
              const SizedBox(width: 24),
              Expanded(
                child: SizedBox(
                  height: 36,
                  // TODO: replace with a real sparkline (e.g. fl_chart) driven by trend data
                  child: CustomPaint(painter: _SparklinePainter()),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white54
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    final path = Path()
      ..moveTo(0, size.height * 0.6)
      ..quadraticBezierTo(size.width * 0.3, size.height, size.width * 0.55, size.height * 0.4)
      ..quadraticBezierTo(size.width * 0.75, 0, size.width, size.height * 0.1);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
