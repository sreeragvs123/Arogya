import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../common/section_card.dart';

/// "Backup Method" panel — lets a clinician manually enter a patient ID
/// when QR scanning isn't available.
class BackupMethodCard extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSearch;
  final bool isSearching;

  const BackupMethodCard({
    super.key,
    required this.controller,
    required this.onSearch,
    this.isSearching = false,
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
            textInputAction: TextInputAction.search,
            onSubmitted: (_) => onSearch(),
            decoration: const InputDecoration(
              hintText: 'AR-XXXX-XXXX-XXXX',
              prefixIcon: Icon(Icons.badge_outlined, color: AppColors.textMuted),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isSearching ? null : onSearch,
              child: isSearching
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : Row(
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
