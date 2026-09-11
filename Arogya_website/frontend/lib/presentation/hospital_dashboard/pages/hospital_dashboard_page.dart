// presentation/hospital_dashboard/pages/hospital_dashboard_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/common/hospital_dashboard_sidebar.dart';
import 'package:frontend/common/hospital_dashboard_topbar.dart';
import 'package:frontend/core/utils/service_locator.dart';
import 'package:frontend/presentation/hospital_dashboard/bloc/hospital_dashboard_bloc.dart';
import 'package:frontend/presentation/hospital_dashboard/widgets/hospital_table_section.dart';
import '../../../core/routing/app_routes.dart';
import '../widgets/hospital_header_section.dart';
import '../widgets/hospital_metrics_row.dart';
import '../widgets/hospital_filter_bar.dart';
import '../widgets/hospital_provision_doctor_sheet.dart';

class HospitalDashboardPage extends StatefulWidget {
  final int hospitalId;

  const HospitalDashboardPage({super.key, required this.hospitalId});

  @override
  State<HospitalDashboardPage> createState() => _HospitalDashboardPageState();
}

class _HospitalDashboardPageState extends State<HospitalDashboardPage> {
  late final HospitalDashboardBloc _bloc;
  bool _isSidebarCollapsed = false;

  @override
  void initState() {
    super.initState();
    _bloc = sl<HospitalDashboardBloc>()..add(HospitalDashboardStarted(widget.hospitalId));
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  void _toggleSidebar() {
    setState(() {
      _isSidebarCollapsed = !_isSidebarCollapsed;
    });
  }

  void _openProvisionDoctorModal(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'HospitalProvisionDoctor',
      barrierColor: Colors.black45,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        return Align(
          alignment: Alignment.centerRight,
          child: Material(
            color: Colors.transparent,
            child: SizedBox(
              width: 560,
              height: double.infinity,
              child: HospitalProvisionDoctorSheet(
                onSaved: (doctorName) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Hospital credential issued for $doctorName'),
                      backgroundColor: const Color(0xFF0F172A),
                    ),
                  );
                  _bloc.add(HospitalDashboardStarted(widget.hospitalId));
                },
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: anim1, curve: Curves.easeOutCubic)),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        body: Row(
          children: [
            AppSidebar(
              isCollapsed: _isSidebarCollapsed,
              currentRoute: AppRoutes.hospitalDashboard,
              onToggleCollapse: _toggleSidebar,
            ),
            Expanded(
              child: Column(
                children: [
                  AppTopBar(
                    isSidebarCollapsed: _isSidebarCollapsed,
                    onToggleSidebar: _toggleSidebar,
                  ),
                  const Divider(height: 1, color: Color(0xFFE2E8F0)),
                  Expanded(
                    child: BlocBuilder<HospitalDashboardBloc, HospitalDashboardState>(
                      builder: (context, state) {
                        return SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              HospitalHeaderSection(
                                onAddDoctorTap: () => _openProvisionDoctorModal(context),
                                onImportCsv: () {},
                                onExportRegister: () {},
                              ),
                              const SizedBox(height: 20),

                              HospitalMetricsRow(
                                affiliatedDoctors: state.metrics?.totalStaff ?? 0,
                                activeDutyToday: state.metrics?.activeOnDuty ?? 0,
                                credentialReviewCount: state.metrics?.pendingReviews ?? 0,
                                clinicalSpecialtiesCount: state.metrics?.specialtyCount ?? 0,
                              ),
                              const SizedBox(height: 24),

                              HospitalFilterBar(
                                searchQuery: state.searchQuery,
                                onSearchChanged: (val) =>
                                    _bloc.add(HospitalDashboardSearchChanged(val)),
                                activeTab: state.activeTab,
                                onTabChanged: (val) =>
                                    _bloc.add(HospitalDashboardTabChanged(val)),
                                selectedDepartment: state.selectedDepartment,
                                onDepartmentChanged: (val) =>
                                    _bloc.add(HospitalDashboardDepartmentChanged(val)),
                                specializations: state.specializations,
                              ),
                              const SizedBox(height: 20),

                              if (state.isLoading)
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 4),
                                  child: LinearProgressIndicator(
                                    backgroundColor: Color(0xFFE2E8F0),
                                    color: Color(0xFF2563EB),
                                    minHeight: 3,
                                  ),
                                ),

                              if (state.errorMessage != null)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: Text(
                                    state.errorMessage!,
                                    style: const TextStyle(color: Colors.red, fontSize: 12),
                                  ),
                                ),

                              HospitalTableSection(
                                doctors: state.doctors,
                                onManagePrivileges: (doctor) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Editing privileges for ${doctor.doctorName}'),
                                      duration: const Duration(seconds: 2),
                                    ),
                                  );
                                },
                                onResendPin: (doctor) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Resending security PIN to ${doctor.phoneNumber}'),
                                      duration: const Duration(seconds: 2),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 16),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Page ${state.currentPage + 1} of ${state.totalPages}',
                                    style: const TextStyle(
                                        fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
                                  ),
                                  Row(
                                    children: [
                                      OutlinedButton(
                                        onPressed: state.currentPage > 0
                                            ? () => _bloc.add(
                                                HospitalDashboardPageChanged(state.currentPage - 1))
                                            : null,
                                        style: OutlinedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                          side: const BorderSide(color: Color(0xFFCBD5E1)),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                        ),
                                        child: const Text('Previous', style: TextStyle(fontSize: 12)),
                                      ),
                                      const SizedBox(width: 8),
                                      OutlinedButton(
                                        onPressed: state.currentPage + 1 < state.totalPages
                                            ? () => _bloc.add(
                                                HospitalDashboardPageChanged(state.currentPage + 1))
                                            : null,
                                        style: OutlinedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                          side: const BorderSide(color: Color(0xFFCBD5E1)),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                        ),
                                        child: const Text('Next', style: TextStyle(fontSize: 12)),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
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
      ),
    );
  }
}