import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../common/section_card.dart';
import 'numbered_tip_item.dart';

const List<String> kScanningTips = [
  "Ensure screen brightness on the patient's device is at maximum for better recognition.",
  'Avoid direct glare from overhead clinical lighting on the phone screen.',
  'Hold the device steady about 10-15cm away from the camera lens.',
];

class ProTipsCard extends StatelessWidget {
  final List<String> tips;

  const ProTipsCard({super.key, this.tips = kScanningTips});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      backgroundColor: AppColors.softPanel,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.info_outline_rounded, size: 18, color: AppColors.textPrimary),
              SizedBox(width: 8),
              Text('Pro Tips for Scanning', style: AppTextStyles.label),
            ],
          ),
          const SizedBox(height: 16),
          for (int i = 0; i < tips.length; i++)
            NumberedTipItem(number: i + 1, text: tips[i]),
        ],
      ),
    );
  }
}
