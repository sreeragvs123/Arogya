import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/utils/service_locator.dart';
import 'package:frontend/domain/entities/patients/patient_summary_entity.dart';
import '../../../core/routing/app_routes.dart';
import '../../../common/patient_dashboard_sidebar.dart';
import '../../../common/patient_dashboard_topbar.dart';
import '../../../core/theme/app_colors.dart';
import '../bloc/patients_bloc.dart';
import '../widgets/patients_header_section.dart';
import '../widgets/patient_filter_bar.dart';
import '../widgets/active_patient_card.dart';
import '../widgets/patient_list_section.dart';

class PatientsPage extends StatelessWidget {
  const PatientsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<PatientsBloc>()..add(const PatientsStarted()),
      child: const _PatientsView(),
    );
  }
}

class _PatientsView extends StatelessWidget {
  const _PatientsView();

  void _openPatientDetail(BuildContext context, PatientSummaryEntity patient) {
    Navigator.pushNamed(context, AppRoutes.patientDetail, arguments: patient.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const AppSidebar(currentRoute: AppRoutes.myPatients),
          Expanded(
            child: Column(
              children: [
                const AppTopBar(),
                const Divider(height: 1),
                Expanded(
                  child: BlocBuilder<PatientsBloc, PatientsState>(
                    builder: (context, state) {
                      if (state.status == PatientsStatus.loading && state.summary == null) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (state.status == PatientsStatus.failure && state.summary == null) {
                        return Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.cloud_off_rounded, size: 42, color: AppColors.textMuted),
                              const SizedBox(height: 12),
                              Text(state.errorMessage ?? 'Failed to load patients.',
                                  style: const TextStyle(color: AppColors.textSecondary)),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () =>
                                    context.read<PatientsBloc>().add(const PatientsRefreshRequested()),
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        );
                      }

                      final summary = state.summary;
                      final bloc = context.read<PatientsBloc>();

                      return RefreshIndicator(
                        onRefresh: () async => bloc.add(const PatientsRefreshRequested()),
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(28),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              PatientsHeaderSection(
                                totalPatients: summary?.totalPatients ?? 0,
                                totalPatientsGrowth: summary?.totalPatientsGrowth ?? '+0%',
                                newThisMonth: summary?.newThisMonth ?? 0,
                                followUpsPending: summary?.followUpsPending ?? 0,
                              ),
                              const SizedBox(height: 24),
                              PatientFilterBar(
                                initialQuery: state.searchQuery,
                                sortBy: state.sortBy,
                                condition: state.condition,
                                onSearchChanged: (q) => bloc.add(PatientsSearchChanged(q)),
                                onSortChanged: (s) => bloc.add(PatientsSortChanged(s)),
                                onConditionChanged: (c) => bloc.add(PatientsConditionChanged(c)),
                                onApplyFilters: () => bloc.add(const PatientsApplyFiltersPressed()),
                              ),
                              const SizedBox(height: 20),
                              if (state.activePatient != null) ...[
                                ActivePatientCard(
                                  patient: state.activePatient!,
                                  onEnterWorkspace: () =>
                                      _openPatientDetail(context, state.activePatient!),
                                ),
                                const SizedBox(height: 24),
                              ],
                              if (state.isListLoading)
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 32),
                                  child: Center(child: CircularProgressIndicator()),
                                )
                              else if (state.patients.isEmpty)
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 32),
                                  child: Center(
                                    child: Text('No patients match your filters.',
                                        style: TextStyle(color: AppColors.textSecondary)),
                                  ),
                                )
                              else ...[
                                PatientListSection(
                                  patients: state.patients,
                                  onWorkspaceTap: (p) => _openPatientDetail(context, p),
                                ),
                                if (state.totalPages > 1) ...[
                                  const SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        onPressed: state.currentPage > 0
                                            ? () => bloc.add(PatientsPageChanged(state.currentPage - 1))
                                            : null,
                                        icon: const Icon(Icons.chevron_left_rounded),
                                      ),
                                      Text('Page ${state.currentPage + 1} of ${state.totalPages}'),
                                      IconButton(
                                        onPressed: state.currentPage + 1 < state.totalPages
                                            ? () => bloc.add(PatientsPageChanged(state.currentPage + 1))
                                            : null,
                                        icon: const Icon(Icons.chevron_right_rounded),
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ],
                          ),
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
