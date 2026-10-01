import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/common/hospital_dashboard_sidebar.dart';
import 'package:frontend/common/hospital_dashboard_topbar.dart';
import 'package:frontend/core/routing/app_routes.dart';
import 'package:frontend/core/utils/service_locator.dart';
import 'package:frontend/domain/entities/auth/auth_session.dart';
import 'package:frontend/domain/entities/hospital_staff/staff_entities.dart';
import 'package:frontend/domain/entities/hospital_staff/staff_enums.dart';
import 'package:frontend/domain/usecases/hospital_staff/staff_usecases.dart';
import '../bloc/hospital_staff_bloc.dart';
import '../widgets/register_staff_sheet.dart';
import '../widgets/staff_card.dart';
import '../widgets/staff_metrics_panel.dart';

class HospitalStaffPage extends StatefulWidget {
  final int hospitalId;
  final HospitalAdminSession? session;
  const HospitalStaffPage({super.key, required this.hospitalId, this.session});

  @override
  State<HospitalStaffPage> createState() => _HospitalStaffPageState();
}

class _HospitalStaffPageState extends State<HospitalStaffPage> {
  late final HospitalStaffBloc _bloc;
  bool _collapsed = false;

  @override
  void initState() {
    super.initState();
    _bloc = sl<HospitalStaffBloc>()..add(StaffStarted(widget.hospitalId));
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  Future<String?> _create(CreateStaffParams params) async {
    final res = await sl<CreateStaffUsecase>().call(params: params);
    return res.fold((f) => f.message, (_) => null);
  }

  void _openRegister(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'RegisterStaff',
      barrierColor: Colors.black45,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (dialogContext, _, __) => Align(
        alignment: Alignment.centerRight,
        child: Material(
          color: Colors.transparent,
          child: SizedBox(
            width: 520,
            height: double.infinity,
            child: RegisterStaffSheet(
              hospitalId: widget.hospitalId,
              onClose: () => Navigator.of(dialogContext).pop(),
              onSubmit: (params) async {
                final err = await _create(params);
                if (err == null && dialogContext.mounted) {
                  Navigator.of(dialogContext).pop();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('${params.fullName} registered as staff'),
                    backgroundColor: const Color(0xFF0F172A),
                  ));
                  _bloc.add(StaffStarted(widget.hospitalId));
                }
                return err;
              },
            ),
          ),
        ),
      ),
      transitionBuilder: (_, anim, __, child) => SlideTransition(
        position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
            .animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        body: Row(children: [
          AppSidebar(
            isCollapsed: _collapsed,
            currentRoute: AppRoutes.staffDirectory,
            onToggleCollapse: () => setState(() => _collapsed = !_collapsed),
            session: widget.session,
            hospitalId: widget.hospitalId,
          ),
          Expanded(
            child: Column(children: [
              AppTopBar(
                isSidebarCollapsed: _collapsed,
                onToggleSidebar: () => setState(() => _collapsed = !_collapsed),
                session: widget.session,
              ),
              const Divider(height: 1, color: Color(0xFFE2E8F0)),
              Expanded(
                child: BlocBuilder<HospitalStaffBloc, HospitalStaffState>(
                  builder: (context, state) {
                    return SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text('Hospital Dashboard : Non-Physician Staffs',
                                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, letterSpacing: -0.5, color: Color(0xFF0F172A))),
                              SizedBox(height: 4),
                              Text('Nursing, pharmacy, lab and administrative personnel.',
                                  style: TextStyle(fontSize: 13, color: Color(0xFF64748B))),
                            ]),
                            ElevatedButton.icon(
                              onPressed: () => _openRegister(context),
                              icon: const Icon(Icons.person_add_alt_1_rounded, size: 18),
                              label: const Text('Register Staff'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2563EB),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          ],
                        ),
const SizedBox(height: 24),
IntrinsicHeight(
  child: StaffMetricsPanel(total: state.totalElements),
),
const SizedBox(height: 24),
if (state.isLoading)
  const LinearProgressIndicator(minHeight: 3, color: Color(0xFF0F766E), backgroundColor: Color(0xFFE2E8F0)),
if (state.errorMessage != null)
  Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Text(state.errorMessage!, style: const TextStyle(color: Colors.red, fontSize: 12)),
  ),
const SizedBox(height: 8),
if (state.staff.isEmpty && !state.isLoading)
  const Padding(
    padding: EdgeInsets.symmetric(vertical: 60),
    child: Center(child: Text('No staff registered yet', style: TextStyle(color: Color(0xFF94A3B8)))),
  )
else
  Wrap(spacing: 14, runSpacing: 14, children: state.staff.map((s) => StaffCard(staff: s)).toList()),
const SizedBox(height: 16),
Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    Text('Page ${state.currentPage + 1} of ${state.totalPages}',
        style: const TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w500)),
    Row(children: [
      OutlinedButton(
        onPressed: state.currentPage > 0
            ? () => _bloc.add(StaffPageChanged(state.currentPage - 1))
            : null,
        child: const Text('Previous', style: TextStyle(fontSize: 12)),
      ),
      const SizedBox(width: 8),
      OutlinedButton(
        onPressed: state.currentPage + 1 < state.totalPages
            ? () => _bloc.add(StaffPageChanged(state.currentPage + 1))
            : null,
        child: const Text('Next', style: TextStyle(fontSize: 12)),
      ),
    ]),
  ],
),
                      ]),
                    );
                  },
                ),
              ),
            ]),
          ),
        ]),
      ),
    );
  }
}