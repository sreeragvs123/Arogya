import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../common/section_card.dart';
import 'activity_timeline_item.dart';

class RecentActivityCard extends StatelessWidget {
  final List<ActivityData> activities;
  final VoidCallback onViewFullLog;

  const RecentActivityCard({
    super.key,
    required this.activities,
    required this.onViewFullLog,
  });

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      backgroundColor: AppColors.softPanel,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Recent Activity',
                  style: TextStyle(fontFamily: 'Georgia', fontSize: 17, fontWeight: FontWeight.w700)),
              Icon(Icons.history_rounded, color: AppColors.textSecondary),
            ],
          ),
          const SizedBox(height: 18),
          for (int i = 0; i < activities.length; i++)
            ActivityTimelineItem(data: activities[i], isLast: i == activities.length - 1),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: onViewFullLog, // TODO: navigate to full activity log
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.white,
                side: const BorderSide(color: AppColors.border),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('View Full Log',
                  style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            ),
          ),
        ],
      ),
    );
  }
}
