import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class WeeklySummaryCard extends StatelessWidget {
  final int efficiencyDeltaPercent;
  final double progress; // 0.0 - 1.0

  const WeeklySummaryCard({
    super.key,
    this.efficiencyDeltaPercent = 12,
    this.progress = 0.72,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Weekly Summary',
              style: TextStyle(fontFamily: 'Georgia', color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Text('Your efficiency is up by $efficiencyDeltaPercent% compared to last week.',
              style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.4)),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    backgroundColor: Colors.white24,
                    valueColor: const AlwaysStoppedAnimation(Colors.white),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text('${(progress * 100).round()}%',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13)),
            ],
          ),
        ],
      ),
    );
  }
}
