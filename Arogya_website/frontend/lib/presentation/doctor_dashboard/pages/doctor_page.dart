import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/utils/service_locator.dart';
import 'package:frontend/domain/entities/auth/auth_session.dart';
import 'package:frontend/domain/entities/doctor_dashboard/consultation_entity.dart';
import '../../../core/routing/app_routes.dart';
import '../../../common/patient_dashboard_sidebar.dart';
import '../../../common/patient_dashboard_topbar.dart';
import '../../../common/snack_bar_helper.dart';
import '../bloc/dashboard_bloc.dart';
import '../widgets/consultation_card.dart';
import '../widgets/morning_overview_card.dart';
import '../widgets/recent_activity_card.dart';
import '../widgets/stat_alert_card.dart';
import '../widgets/weekly_summary_card.dart';
import '../../../core/theme/app_colors.dart';

class DoctorDashBoardPage extends StatelessWidget {
  final DoctorSession session;

  const DoctorDashBoardPage({super.key, required this.session});

  int get doctorId => session.doctorId!;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<DashboardBloc>()..add(DashboardStarted(doctorid: doctorId)),
      child: _DoctorDashBoardView(doctorId: doctorId, session: session),
    );
  }
}

class _DoctorDashBoardView extends StatelessWidget {
  final int doctorId;
  final DoctorSession session;

  const _DoctorDashBoardView({required this.doctorId, required this.session});

  void _openPatientChart(BuildContext context, String patientId) {
    Navigator.pushNamed(context, AppRoutes.patientDetail, arguments: patientId);
  }

  void _showComingSoon(BuildContext context, String feature) {
    SnackbarHelper.showSuccess(context, '$feature is coming soon.');
  }

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
                  child: BlocConsumer<DashboardBloc, DashboardState>(
                    listenWhen: (previous, current) =>
                        previous.actionResult.actionToken !=
                        current.actionResult.actionToken,
                    listener: (context, state) {
                      final result = state.actionResult;
                      if (result.consultation == null) return;
                      if (result.succeeded) {
                        final isJoinCall =
                            result.consultation!.action ==
                            ConsultationActionType.joinCall;
                        SnackbarHelper.showSuccess(
                          context,
                          isJoinCall
                              ? 'Joining call with ${result.consultation!.patientName}...'
                              : 'Visit started for ${result.consultation!.patientName}.',
                        );
                        _openPatientChart(
                          context,
                          result.consultation!.patientId,
                        );
                      } else {
                        SnackbarHelper.showError(
                          context,
                          result.errorMessage ??
                              'Something went wrong. Please try again.',
                        );
                      }
                    },
                    builder: (context, state) {
                      if (state.status == DashboardStatus.loading &&
                          state.summary == null) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (state.status == DashboardStatus.failure &&
                          state.summary == null) {
                        return _ErrorState(
                          message:
                              state.errorMessage ?? 'Failed to load dashboard.',
                          onRetry: () => context.read<DashboardBloc>().add(
                            DashboardRefreshRequested(doctorid: doctorId),
                          ),
                        );
                      }
                      if (state.status == DashboardStatus.success &&
                          state.summary != null) {
                        final summary = state.summary;

                        return RefreshIndicator(
                          onRefresh: () async {
                            context.read<DashboardBloc>().add(
                              DashboardRefreshRequested(doctorid: doctorId),
                            );
                          },
                          child: SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: const EdgeInsets.all(28),
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                final isWide = constraints.maxWidth > 900;
                                final mainColumn = Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: MorningOverviewCard(
                                            consultationsToday:
                                                summary
                                                    ?.morningOverview
                                                    .consultationsToday ??
                                                0,
                                            capacityPercent:
                                                summary
                                                    ?.morningOverview
                                                    .capacityPercent ??
                                                0,
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: StatAlertCard(
                                            icon: Icons.description_outlined,
                                            iconBackground: const Color(
                                              0xFFFCE3DE,
                                            ),
                                            iconColor: const Color(0xFFE0653F),
                                            badgeText:
                                                summary != null &&
                                                    summary.newReportsCount > 0
                                                ? '+${summary.newReportsCount} New'
                                                : null,
                                            badgeColor: const Color(0xFFFBDCD5),
                                            label: 'Pending Reports',
                                            value:
                                                '${summary?.pendingReportsCount ?? 0}',
                                            onTap: () => _showComingSoon(
                                              context,
                                              'Pending reports list',
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: StatAlertCard(
                                            icon: Icons
                                                .notifications_none_rounded,
                                            iconBackground: AppColors.softPanel,
                                            iconColor: AppColors.textSecondary,
                                            label: 'Critical Alerts',
                                            value:
                                                '${summary?.criticalAlertsCount ?? 0}'
                                                    .padLeft(2, '0'),
                                            onTap: () => Navigator.pushNamed(
                                              context,
                                              AppRoutes.notifications,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 28),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Upcoming Consultations',
                                              style: TextStyle(
                                                fontFamily: 'Georgia',
                                                fontSize: 18,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              'Manage your patient queue and upcoming appointments',
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: AppColors.textSecondary,
                                              ),
                                            ),
                                          ],
                                        ),
                                        TextButton.icon(
                                          onPressed: () => _showComingSoon(
                                            context,
                                            'Calendar view',
                                          ),
                                          icon: const Icon(
                                            Icons.arrow_forward_rounded,
                                            size: 16,
                                            color: AppColors.primary,
                                          ),
                                          label: const Text(
                                            'View Calendar',
                                            style: TextStyle(
                                              color: AppColors.primary,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          style: TextButton.styleFrom(
                                            iconAlignment: IconAlignment.end,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    if (state.consultations.isEmpty)
                                      const Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 24,
                                        ),
                                        child: Text(
                                          'No consultations scheduled for today.',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      )
                                    else
                                      for (final c in state.consultations)
                                        ConsultationCard(
                                          data: c,
                                          isActionLoading:
                                              state
                                                  .actionInProgressConsultationId ==
                                              c.id,
                                          onAction: () =>
                                              context.read<DashboardBloc>().add(
                                                DashboardConsultationActionPressed(
                                                  c,
                                                ),
                                              ),
                                          onOpenFile: () => _openPatientChart(
                                            context,
                                            c.patientId,
                                          ),
                                        ),
                                  ],
                                );

                                final rightRail = Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    RecentActivityCard(
                                      activities: state.activities,
                                      onViewFullLog: () => _showComingSoon(
                                        context,
                                        'Full activity log',
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    WeeklySummaryCard(
                                      efficiencyPercentDelta:
                                          summary
                                              ?.weeklySummary
                                              .efficiencyPercentDelta ??
                                          0,
                                      progress:
                                          summary?.weeklySummary.progress ?? 0,
                                    ),
                                  ],
                                );

                                if (isWide) {
                                  return Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(flex: 3, child: mainColumn),
                                      const SizedBox(width: 24),
                                      SizedBox(width: 320, child: rightRail),
                                    ],
                                  );
                                }

                                return Column(
                                  children: [
                                    mainColumn,
                                    const SizedBox(height: 24),
                                    rightRail,
                                  ],
                                );
                              },
                            ),
                          ),
                        );
                      }

                      return _ErrorState(
                        message: state.errorMessage ?? 'Unable to Fetch',
                        onRetry: () => context.read<DashboardBloc>().add(
                          DashboardRefreshRequested(doctorid: doctorId),
                        ),
                      );
                    },
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

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.cloud_off_rounded,
            size: 42,
            color: AppColors.textMuted,
          ),
          const SizedBox(height: 12),
          Text(message, style: const TextStyle(color: AppColors.textSecondary)),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}