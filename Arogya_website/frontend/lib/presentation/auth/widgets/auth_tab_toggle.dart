import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

enum AuthTab { signIn, createAccount }

class AuthTabToggle extends StatelessWidget {
  final AuthTab selected;
  final ValueChanged<AuthTab> onChanged;

  const AuthTabToggle({super.key, required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.softPanel,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _segment(context, 'Sign In', AuthTab.signIn),
          _segment(context, 'Create Account', AuthTab.createAccount),
        ],
      ),
    );
  }

  Widget _segment(BuildContext context, String label, AuthTab tab) {
    final isActive = selected == tab;
    return Expanded(
      child: GestureDetector(
        onTap: () => onChanged(tab),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(9),
            boxShadow: isActive
                ? [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 6)]
                : null,
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isActive ? AppColors.primary : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
