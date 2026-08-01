import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class AuthFooterLinks extends StatelessWidget {
  final VoidCallback onPrivacyTap;
  final VoidCallback onTermsTap;
  final VoidCallback onSupportTap;

  const AuthFooterLinks({
    super.key,
    required this.onPrivacyTap,
    required this.onTermsTap,
    required this.onSupportTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(color: AppColors.divider),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _link('Privacy Policy', onPrivacyTap),
            _divider(),
            _link('Terms of Service', onTermsTap),
            _divider(),
            _link('Support', onSupportTap),
          ],
        ),
      ],
    );
  }

  Widget _link(String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap, // TODO: open respective legal/support page
      child: Text(text,
          style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
    );
  }

  Widget _divider() => const Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Text('/', style: TextStyle(color: AppColors.textMuted)),
      );
}
