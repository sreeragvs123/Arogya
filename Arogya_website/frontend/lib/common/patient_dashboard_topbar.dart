import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';

class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  final String userName;
  final String userRole;
  final String? avatarUrl;
  final ValueChanged<String>? onSearchChanged;
  final VoidCallback? onHelpTap;
  final VoidCallback? onProfileTap;

  const AppTopBar({
    super.key,
    this.userName = 'Dr. Ananya Sharma',
    this.userRole = 'Chief Medical Officer',
    this.avatarUrl,
    this.onSearchChanged,
    this.onHelpTap,
    this.onProfileTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(72);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredSize.height,
      color: AppColors.sidebarBackground,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          const Spacer(),
          IconButton(
            onPressed: onHelpTap, 
            icon: const Icon(Icons.help_outline_rounded, color: AppColors.textSecondary),
          ),
          const SizedBox(width: 8),
          InkWell(
            onTap: onProfileTap, 
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(userName,
                          style: AppTextStyles.label.copyWith(fontSize: 13.5)),
                      Text(userRole,
                          style: AppTextStyles.cardBody.copyWith(fontSize: 11.5)),
                    ],
                  ),
                  const SizedBox(width: 10),
                  CircleAvatar(
                    radius: 19,
                    backgroundColor: AppColors.softPanel,
                    backgroundImage:
                        avatarUrl != null ? NetworkImage(avatarUrl!) : null,
                    child: avatarUrl == null
                        ? const Icon(Icons.person, color: AppColors.textMuted, size: 20)
                        : null,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
