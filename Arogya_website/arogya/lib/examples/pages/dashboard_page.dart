import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/sidebar.dart';
import '../widgets/dashboard_stat_card.dart';

class DashboardPage extends StatefulWidget {
  final String hospitalName;
  const DashboardPage({super.key, required this.hospitalName});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      backgroundColor: AppColors.surfaceWhite,
      drawer: isWide ? null : const AppSidebar(),
      body: Row(
        children: [
          if (isWide) const AppSidebar(),
          Expanded(
            child: Column(
              children: [
                _TopBar(
                    hospitalName: widget.hospitalName, isWide: isWide),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Dashboard Overview',
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium),
                        const SizedBox(height: 6),
                        Text(
                            'Here\'s what\'s happening at ${widget.hospitalName} today.',
                            style:
                                Theme.of(context).textTheme.bodyMedium),
                        const SizedBox(height: 28),
                        _StatsGrid(),
                        const SizedBox(height: 32),
                        _QuickActionsRow(),
                        const SizedBox(height: 32),
                        _RecentActivitySection(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  final String hospitalName;
  final bool isWide;
  const _TopBar({required this.hospitalName, required this.isWide});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(
            bottom: BorderSide(color: AppColors.borderColor)),
      ),
      child: Row(
        children: [
          if (!isWide)
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu_rounded,
                    color: AppColors.primaryGreen),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
          const Icon(Icons.local_hospital_rounded,
              color: AppColors.primaryGreen, size: 22),
          const SizedBox(width: 10),
          Text(hospitalName,
              style: GoogleFonts.playfairDisplay(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryGreen)),
          const Spacer(),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.surfaceWhite,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.borderColor),
            ),
            child: Row(
              children: [
                const Icon(Icons.circle,
                    color: AppColors.successGreen, size: 8),
                const SizedBox(width: 6),
                Text('Online',
                    style: GoogleFonts.dmSans(
                        fontSize: 12,
                        color: AppColors.successGreen,
                        fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          const SizedBox(width: 14),
          IconButton(
            icon: const Icon(Icons.notifications_outlined,
                color: AppColors.mutedText),
            onPressed: () {},
          ),
          const CircleAvatar(
            radius: 17,
            backgroundColor: AppColors.lightGreen,
            child: Icon(Icons.person_rounded,
                color: AppColors.primaryGreen, size: 18),
          ),
        ],
      ),
    );
  }
}

class _StatsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 900;
    return GridView.count(
      crossAxisCount: isWide ? 4 : 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: isWide ? 1.6 : 1.4,
      children: const [
        DashboardStatCard(
          icon: Icons.account_tree_rounded,
          label: 'Departments',
          value: '12',
          color: AppColors.primaryGreen,
          route: '/departments',
        ),
        DashboardStatCard(
          icon: Icons.medical_services_rounded,
          label: 'Doctors',
          value: '48',
          color: AppColors.mediumGreen,
          route: '/doctors',
        ),
        DashboardStatCard(
          icon: Icons.people_alt_rounded,
          label: 'Active Patients',
          value: '134',
          color: AppColors.primaryGreen,
          route: '/patients',
        ),
        DashboardStatCard(
          icon: Icons.inventory_2_rounded,
          label: 'Medicine Items',
          value: '320',
          color: AppColors.mediumGreen,
          route: '/inventory',
        ),
      ],
    );
  }
}

class _QuickActionsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Quick actions',
            style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _ActionButton(
              icon: Icons.person_add_rounded,
              label: 'Register Patient',
              onTap: () =>
                  Navigator.pushNamed(context, '/patient-register'),
            ),
            _ActionButton(
              icon: Icons.add_business_rounded,
              label: 'Add Department',
              onTap: () =>
                  Navigator.pushNamed(context, '/departments'),
            ),
            _ActionButton(
              icon: Icons.receipt_long_rounded,
              label: 'New Checkup Receipt',
              onTap: () =>
                  Navigator.pushNamed(context, '/checkup-receipt'),
            ),
            _ActionButton(
              icon: Icons.qr_code_scanner_rounded,
              label: 'Scan Patient QR',
              onTap: () {},
            ),
            _ActionButton(
              icon: Icons.medication_rounded,
              label: 'Manage Inventory',
              onTap: () => Navigator.pushNamed(context, '/inventory'),
            ),
          ],
        ),
      ],
    );
  }
}

class _ActionButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton(
      {required this.icon,
      required this.label,
      required this.onTap});

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding:
              const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          decoration: BoxDecoration(
            color: _hovered
                ? AppColors.primaryGreen
                : AppColors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _hovered
                  ? AppColors.primaryGreen
                  : AppColors.borderColor,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.icon,
                  color: _hovered
                      ? AppColors.white
                      : AppColors.primaryGreen,
                  size: 18),
              const SizedBox(width: 8),
              Text(widget.label,
                  style: GoogleFonts.dmSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: _hovered
                          ? AppColors.white
                          : AppColors.darkText)),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecentActivitySection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final activities = [
      _Activity('Patient registered', 'Ravi Kumar — ID: AY002341', Icons.person_add_rounded, '2 min ago'),
      _Activity('Checkup receipt sent', 'Dr. Meera — Patient Leela S.', Icons.receipt_long_rounded, '15 min ago'),
      _Activity('Inventory updated', 'Paracetamol 500mg — 200 units added', Icons.inventory_2_rounded, '1 hr ago'),
      _Activity('QR card printed', 'New patient Anil P. onboarded', Icons.qr_code_2_rounded, '2 hr ago'),
      _Activity('Department added', 'Neurology dept. created', Icons.account_tree_rounded, '3 hr ago'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Recent activity',
            style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.borderColor),
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: activities.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, i) {
              final a = activities[i];
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 8),
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.lightGreen.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(a.icon,
                      color: AppColors.primaryGreen, size: 18),
                ),
                title: Text(a.title,
                    style: GoogleFonts.dmSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.darkText)),
                subtitle: Text(a.subtitle,
                    style: GoogleFonts.dmSans(
                        fontSize: 12, color: AppColors.mutedText)),
                trailing: Text(a.time,
                    style: GoogleFonts.dmSans(
                        fontSize: 11, color: AppColors.mutedText)),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _Activity {
  final String title;
  final String subtitle;
  final IconData icon;
  final String time;
  const _Activity(this.title, this.subtitle, this.icon, this.time);
}