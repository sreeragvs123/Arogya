import 'package:flutter/material.dart';
import '../../../core/routing/app_routes.dart';
import '../../../common/app_sidebar.dart';
import '../../../common/app_top_bar.dart';
import '../widgets/activity_timeline_item.dart';
import '../widgets/consultation_card.dart';
import '../widgets/morning_overview_card.dart';
import '../widgets/recent_activity_card.dart';
import '../widgets/stat_alert_card.dart';
import '../widgets/weekly_summary_card.dart';
import '../../../core/theme/app_colors.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  static const List<ConsultationData> _consultations = [
    ConsultationData(
      patientName: 'Amitav Mukherjee',
      patientId: '#4492',
      time: '09:30 AM',
      reason: 'Post-Op Follow-up',
      reasonIcon: Icons.medical_information_outlined,
      initials: 'AM',
      avatarUrl: 'https://i.pravatar.cc/100?img=12',
    ),
    ConsultationData(
      patientName: 'Sana Kothari',
      patientId: '#5102',
      time: '10:15 AM',
      reason: 'General Checkup',
      reasonIcon: Icons.health_and_safety_outlined,
      initials: 'SK',
      avatarUrl: 'https://i.pravatar.cc/100?img=32',
      action: ConsultationAction.joinCall,
    ),
    ConsultationData(
      patientName: 'Rajiv Jain',
      patientId: '#3991',
      time: '11:00 AM',
      reason: 'Medication Review',
      reasonIcon: Icons.medication_outlined,
      initials: 'RJ',
    ),
  ];

  static const List<ActivityData> _activities = [
    ActivityData(
      title: 'Lab report uploaded',
      description: "Mrs. Kapoor's Blood Panel is ready for review.",
      timeAgo: '12 mins ago',
      isHighlighted: true,
    ),
    ActivityData(
      title: 'Prescription Refill',
      description: 'Approved refill for John Doe (Atorvastatin).',
      timeAgo: '45 mins ago',
    ),
    ActivityData(
      title: 'Note Draft Saved',
      description: 'Visit summary for Pt. #8829 (Internal Medicine).',
      timeAgo: '2 hours ago',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const AppSidebar(currentRoute: AppRoutes.dashboard),
          Expanded(
            child: Column(
              children: [
                const AppTopBar(),
                const Divider(height: 1),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(28),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final isWide = constraints.maxWidth > 900;

                        final mainColumn = Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Expanded(flex: 2, child: MorningOverviewCard()),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: StatAlertCard(
                                    icon: Icons.description_outlined,
                                    iconBackground: const Color(0xFFFCE3DE),
                                    iconColor: const Color(0xFFE0653F),
                                    badgeText: '+4 New',
                                    badgeColor: const Color(0xFFFBDCD5),
                                    label: 'Pending Reports',
                                    value: '28',
                                    onTap: () {},
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: StatAlertCard(
                                    icon: Icons.notifications_none_rounded,
                                    iconBackground: AppColors.softPanel,
                                    iconColor: AppColors.textSecondary,
                                    label: 'Critical Alerts',
                                    value: '03',
                                    onTap: () {},
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 28),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Upcoming Consultations',
                                        style: TextStyle(fontFamily: 'Georgia', fontSize: 18, fontWeight: FontWeight.w700)),
                                    SizedBox(height: 4),
                                    Text('Manage your patient queue and upcoming appointments',
                                        style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                                  ],
                                ),
                                TextButton.icon(
                                  onPressed: () {}, // TODO: navigate to calendar view
                                  icon: const Icon(Icons.arrow_forward_rounded, size: 16, color: AppColors.primary),
                                  label: const Text('View Calendar',
                                      style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600)),
                                  style: TextButton.styleFrom(iconAlignment: IconAlignment.end),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            for (final c in _consultations)
                              ConsultationCard(
                                data: c,
                                onAction: () {}, // TODO: start visit / join call
                                onOpenFile: () {}, // TODO: open patient chart
                              ),
                          ],
                        );

                        final rightRail = Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            RecentActivityCard(
                              activities: _activities,
                              onViewFullLog: () {},
                            ),
                            const SizedBox(height: 20),
                            const WeeklySummaryCard(),
                          ],
                        );

                        if (isWide) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(flex: 3, child: mainColumn),
                              const SizedBox(width: 24),
                              SizedBox(width: 320, child: rightRail),
                            ],
                          );
                        }

                        return Column(
                          children: [mainColumn, const SizedBox(height: 24), rightRail],
                        );
                      },
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
