import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../common/section_card.dart';

/// "Backup Method" panel — lets a clinician manually enter a patient ID
/// when QR scanning isn't available.
class BackupMethodCard extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSearch;

  const BackupMethodCard({
    super.key,
    required this.controller,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('BACKUP METHOD', style: AppTextStyles.cardEyebrow),
          const SizedBox(height: 8),
          const Text('Manual ID Entry', style: AppTextStyles.cardTitle),
          const SizedBox(height: 8),
          const Text(
            "If scanning fails, enter the 12-digit Patient ID manually.",
            style: AppTextStyles.cardBody,
          ),
          const SizedBox(height: 20),
          const Text('Patient Identifier', style: AppTextStyles.label),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            style: AppTextStyles.label,
            decoration: const InputDecoration(
              hintText: 'AR-XXXX-XXXX-XXXX',
              prefixIcon: Icon(Icons.badge_outlined, color: AppColors.textMuted),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              // TODO: validate the ID format, then call the patient-lookup
              // repository/bloc event before invoking onSearch's navigation.
              onPressed: onSearch,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text('Search Patient', style: AppTextStyles.buttonLabel),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward_rounded, size: 18, color: Colors.white),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
