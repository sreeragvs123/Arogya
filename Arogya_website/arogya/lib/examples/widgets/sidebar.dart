import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class AppSidebar extends StatelessWidget {
  const AppSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final currentRoute = ModalRoute.of(context)?.settings.name ?? '/dashboard';
    return Container(
      width: 240,
      color: AppColors.white,
      child: Column(children: [
        Container(
          padding: const EdgeInsets.all(24),
          child: Row(children: [
            const Icon(Icons.local_hospital_rounded, color: AppColors.primaryGreen, size: 24),
            const SizedBox(width: 10),
            Text('Arogya', style: GoogleFonts.playfairDisplay(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.primaryGreen)),
          ]),
        ),
        const Divider(height: 1),
        const SizedBox(height: 8),
        _SidebarItem(icon: Icons.dashboard_rounded, label: 'Dashboard', route: '/dashboard', currentRoute: currentRoute),
        _SidebarItem(icon: Icons.account_tree_rounded, label: 'Departments', route: '/departments', currentRoute: currentRoute),
        _SidebarItem(icon: Icons.medical_services_rounded, label: 'Doctors', route: '/doctors', currentRoute: currentRoute),
        _SidebarItem(icon: Icons.people_alt_rounded, label: 'Patients', route: '/patients', currentRoute: currentRoute),
        _SidebarItem(icon: Icons.inventory_2_rounded, label: 'Inventory', route: '/inventory', currentRoute: currentRoute),
        _SidebarItem(icon: Icons.person_add_rounded, label: 'Register Patient', route: '/patient-register', currentRoute: currentRoute),
        _SidebarItem(icon: Icons.receipt_long_rounded, label: 'Checkup Receipts', route: '/checkup-receipt', currentRoute: currentRoute),
        const Spacer(),
        const Divider(height: 1),
        _SidebarItem(icon: Icons.logout_rounded, label: 'Logout', route: '/', currentRoute: currentRoute),
        const SizedBox(height: 16),
      ]),
    );
  }
}

class _SidebarItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final String route;
  final String currentRoute;
  const _SidebarItem({required this.icon, required this.label, required this.route, required this.currentRoute});

  @override
  State<_SidebarItem> createState() => _SidebarItemState();
}

class _SidebarItemState extends State<_SidebarItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isActive = widget.currentRoute == widget.route;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => Navigator.pushReplacementNamed(context, widget.route),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          decoration: BoxDecoration(
            color: isActive ? AppColors.primaryGreen : _hovered ? AppColors.surfaceWhite : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(children: [
            Icon(widget.icon, size: 18, color: isActive ? AppColors.white : AppColors.mutedText),
            const SizedBox(width: 12),
            Text(widget.label, style: GoogleFonts.dmSans(fontSize: 13, fontWeight: isActive ? FontWeight.w600 : FontWeight.w400, color: isActive ? AppColors.white : AppColors.darkText)),
          ]),
        ),
      ),
    );
  }
}
