import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class EncryptionFooter extends StatelessWidget {
  final String message;

  const EncryptionFooter({
    super.key,
    this.message = 'Encryption: 256-bit AES for all record transmissions',
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.lock_outline_rounded, size: 16, color: AppColors.textMuted),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            message,
            style: AppTextStyles.cardBody.copyWith(fontSize: 12, color: AppColors.textMuted),
          ),
        ),
      ],
    );
  }
}
