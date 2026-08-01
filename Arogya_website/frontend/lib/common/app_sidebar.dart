import 'package:flutter/material.dart';
import '../core/routing/app_routes.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import 'nav_item.dart';

const List<NavItemData> kPortalNavItems = [
  NavItemData(
    icon: Icons.grid_view_rounded,
    label: 'Dashboard',
    routeName: AppRoutes.dashboard,
  ),
  NavItemData(
    icon: Icons.people_alt_outlined,
    label: 'My Patients',
    routeName: AppRoutes.myPatients,
  ),
  NavItemData(
    icon: Icons.qr_code_scanner_rounded,
    label: 'Scan Patient QR',
    routeName: AppRoutes.scanPatientQr,
  ),
  NavItemData(
    icon: Icons.notifications_none_rounded,
    label: 'Notifications',
    routeName: AppRoutes.notifications,
  ),
];

/// Fixed-width sidebar used on every clinician-facing page.
/// Pass in [currentRoute] so the active item highlights correctly.
class AppSidebar extends StatelessWidget {
  final String currentRoute;
  final String emergencyNumber;

  const AppSidebar({
    super.key,
    required this.currentRoute,
    this.emergencyNumber = '+91 999 888 777',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 248,
      color: AppColors.sidebarBackground,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildLogo(),
            const SizedBox(height: 8),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(top: 8),
                children: kPortalNavItems
                    .map(
                      (item) => NavItemTile(
                        data: item,
                        isSelected: item.routeName == currentRoute,
                        onTap: () {
                          if (item.routeName == currentRoute) return;
                          // TODO: hook up real navigation logic, e.g.
                          // Navigator.pushReplacementNamed(context, item.routeName);
                        },
                      ),
                    )
                    .toList(),
              ),
            ),
            _buildEmergencyCard(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.favorite, color: Colors.white, size: 16),
          ),
          const SizedBox(width: 10),
          const Text(
            'Arogya Portal',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.emergencyBackground,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Emergency Hotline',
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: AppColors.emergencyText,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              emergencyNumber,
              style: AppTextStyles.cardTitle.copyWith(
                fontSize: 16,
                color: AppColors.emergencyText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
