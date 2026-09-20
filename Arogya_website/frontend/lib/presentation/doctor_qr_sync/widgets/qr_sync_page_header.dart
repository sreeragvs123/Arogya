import 'package:flutter/material.dart';
import '../../../core/theme/app_text_styles.dart';

class QrSyncPageHeader extends StatelessWidget {
  const QrSyncPageHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text('AROGYA SECURE  •  ACCESS PROTOCOL', style: AppTextStyles.eyebrow),
        SizedBox(height: 10),
        Text('Patient Record Sync', style: AppTextStyles.pageTitle),
        SizedBox(height: 10),
        SizedBox(
          width: 620,
          child: Text(
            'Securely link to patient history by scanning the unique QR code '
            'generated in the Arogya Patient App.',
            style: AppTextStyles.pageSubtitle,
          ),
        ),
      ],
    );
  }
}
