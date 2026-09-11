import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class ActivityData {
  final String title;
  final String description;
  final String timeAgo;
  final bool isHighlighted;

  const ActivityData({
    required this.title,
    required this.description,
    required this.timeAgo,
    this.isHighlighted = false,
  });
}

class ActivityTimelineItem extends StatelessWidget {
  final ActivityData data;
  final bool isLast;

  const ActivityTimelineItem({super.key, required this.data, this.isLast = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Container(
              width: 9,
              height: 9,
              decoration: BoxDecoration(
                color: data.isHighlighted ? AppColors.liveIndicator : AppColors.textMuted,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data.title,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5)),
                const SizedBox(height: 2),
                Text(data.description,
                    style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.4)),
                const SizedBox(height: 4),
                Text(data.timeAgo,
                    style: const TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
