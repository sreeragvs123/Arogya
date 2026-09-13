import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/utils/service_locator.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../common/patient_dashboard_sidebar.dart';
import '../../../common/patient_dashboard_topbar.dart';
import '../../../common/snack_bar_helper.dart';
import '../../../domain/repositories/patient_detail/patient_detail_repository.dart';
import '../bloc/patient_details_bloc.dart';
import '../widgets/clinical_report_panel.dart';
import '../widgets/observations_panel.dart';
import '../widgets/patient_header.dart';
import '../widgets/prescription_panel.dart';
import '../widgets/recent_observations_card.dart';
import '../widgets/vitals_panel.dart';
import '../widgets/vitals_trend_card.dart';

class PatientDetailPage extends StatelessWidget {
  final String patientId;

  const PatientDetailPage({super.key, required this.patientId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<PatientDetailsBloc>()..add(PatientDetailsStarted(patientId)),
      child: const _PatientDetailView(),
    );
  }
}

class _PatientDetailView extends StatefulWidget {
  const _PatientDetailView();

  @override
  State<_PatientDetailView> createState() => _PatientDetailViewState();
}

class _PatientDetailViewState extends State<_PatientDetailView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final TextEditingController _clinicalNoteController = TextEditingController();

  final TextEditingController _heartRateController = TextEditingController();
  final TextEditingController _bloodPressureController = TextEditingController();
  final TextEditingController _bodyTempController = TextEditingController();
  final TextEditingController _bloodSugarController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _clinicalNoteController.dispose();
    _heartRateController.dispose();
    _bloodPressureController.dispose();
    _bodyTempController.dispose();
    _bloodSugarController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  void _showComingSoon(String feature) {
    SnackbarHelper.showSuccess(context, '$feature is coming soon.');
  }

  void _showPrintQrDialog(String patientDisplayId) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Patient QR Code'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 160,
              height: 160,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.softPanel,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.qr_code_2_rounded, size: 96, color: AppColors.primary),
            ),
            const SizedBox(height: 16),
            Text('ID: $patientDisplayId',
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
            const SizedBox(height: 4),
            const Text(
              'Scan this code in the Arogya app to link this patient\'s record.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12.5, color: AppColors.textSecondary),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Close'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(dialogContext);
              SnackbarHelper.showSuccess(context, 'Sent to printer.');
            },
            icon: const Icon(Icons.print_outlined, size: 18, color: Colors.white),
            label: const Text('Print'),
          ),
        ],
      ),
    );
  }

  void _showReviewDocumentDialog(String reportText) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Clinical Report Preview'),
        content: SizedBox(
          width: 480,
          child: SingleChildScrollView(
            child: Text(reportText.isEmpty ? 'Generate the report first to preview it.' : reportText),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Close'),
          ),
        ],
      ),
    );
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
                  child: BlocConsumer<PatientDetailsBloc, PatientDetailsState>(
                    listenWhen: (previous, current) =>
                        previous.actionFeedback.token != current.actionFeedback.token,
                    listener: (context, state) {
                      final feedback = state.actionFeedback;
                      if (feedback.kind == PatientDetailActionKind.none) return;
                      if (feedback.succeeded) {
                        SnackbarHelper.showSuccess(context, feedback.message ?? 'Done.');
                        if (feedback.kind == PatientDetailActionKind.vitalsUpdated) {
                          _heartRateController.clear();
                          _bloodPressureController.clear();
                          _bodyTempController.clear();
                          _bloodSugarController.clear();
                          _weightController.clear();
                          _heightController.clear();
                        }
                      } else {
                        SnackbarHelper.showError(
                          context,
                          feedback.message ?? 'Something went wrong. Please try again.',
                        );
                      }
                    },
                    builder: (context, state) {
                      if (state.status == PatientDetailsStatus.loading && state.patient == null) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (state.status == PatientDetailsStatus.failure && state.patient == null) {
                        return Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.cloud_off_rounded, size: 42, color: AppColors.textMuted),
                              const SizedBox(height: 12),
                              Text(state.errorMessage ?? 'Failed to load patient.',
                                  style: const TextStyle(color: AppColors.textSecondary)),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () => context
                                    .read<PatientDetailsBloc>()
                                    .add(const PatientDetailsRefreshRequested()),
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        );
                      }

                      final bloc = context.read<PatientDetailsBloc>();
                      final patient = state.patient!;
                      final vitals = state.vitals;
                      final observations = state.observations
                          .map((o) => ObservationData(date: o.date, note: o.note))
                          .toList();
                      final medicineLines = state.prescriptionDraft
                          .map((m) => '${m.displayName} — ${m.displaySchedule}')
                          .toList();
                      final report = state.clinicalReport;

                      return RefreshIndicator(
                        onRefresh: () async =>
                            bloc.add(const PatientDetailsRefreshRequested()),
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(28),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              PatientHeader(
                                name: patient.name,
                                patientId: patient.displayId,
                                isHighSensitivity: patient.isHighSensitivity,
                                age: '${patient.age}',
                                gender: patient.gender,
                                bloodGroup: patient.bloodGroup,
                                height: patient.heightCm,
                                weight: patient.weightKg,
                                photoUrl: patient.photoUrl,
                                onFullHistory: () => _showComingSoon('Full patient history'),
                                onPrintQr: () => _showPrintQrDialog(patient.displayId),
                              ),
                              const SizedBox(height: 24),
                              LayoutBuilder(
                                builder: (context, constraints) {
                                  final isWide = constraints.maxWidth > 900;

                                  final leftColumn = Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      VitalsTrendCard(
                                        heartRateBpm: vitals?.heartRateBpm ?? 0,
                                        heartRateStatus: vitals?.heartRateStatus ?? '—',
                                        heartRateBars: vitals?.heartRateTrend ??
                                            const [0.4, 0.55, 0.5, 0.75, 0.6, 0.5],
                                        bloodPressure: vitals?.bloodPressure ?? '—',
                                        bloodPressureStatus: vitals?.bloodPressureStatus ?? '—',
                                        bodyTempF: vitals?.bodyTempF ?? 0,
                                      ),
                                      const SizedBox(height: 20),
                                      RecentObservationsCard(observations: observations),
                                    ],
                                  );

                                  Widget buildRightColumn() {
                                    return Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(18),
                                        border: Border.all(color: AppColors.border),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          TabBar(
                                            controller: _tabController,
                                            isScrollable: true,
                                            labelColor: AppColors.primary,
                                            unselectedLabelColor: AppColors.textSecondary,
                                            indicatorColor: AppColors.primary,
                                            indicatorSize: TabBarIndicatorSize.label,
                                            labelStyle: const TextStyle(
                                                fontWeight: FontWeight.w600, fontSize: 14.5),
                                            tabs: const [
                                              Tab(text: 'Vitals'),
                                              Tab(text: 'Observations'),
                                              Tab(text: 'Prescription'),
                                              Tab(text: 'Clinical Report'),
                                            ],
                                          ),
                                          const Divider(height: 1, color: AppColors.divider),
                                          ConstrainedBox(
                                            constraints: const BoxConstraints(minHeight: 500),
                                            child: Padding(
                                              padding: const EdgeInsets.all(24),
                                              child: IndexedStack(
                                                index: _tabController.index,
                                                children: [
                                                  VitalsPanel(
                                                    heartRateController: _heartRateController,
                                                    bloodPressureController:
                                                        _bloodPressureController,
                                                    bodyTempController: _bodyTempController,
                                                    bloodSugarController: _bloodSugarController,
                                                    weightController: _weightController,
                                                    heightController: _heightController,
                                                    isSaving: state.isVitalsSaving,
                                                    onUpdateVitals: () => bloc.add(
                                                      VitalsUpdateSubmitted(
                                                        VitalsUpdateInput(
                                                          heartRateBpm:
                                                              _heartRateController.text,
                                                          bloodPressure:
                                                              _bloodPressureController.text,
                                                          bodyTempF: _bodyTempController.text,
                                                          bloodSugar: _bloodSugarController.text,
                                                          weightKg: _weightController.text,
                                                          heightCm: _heightController.text,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  ObservationsPanel(
                                                    symptoms: state.draftSymptoms,
                                                    onAddSymptom: (s) =>
                                                        bloc.add(SymptomAdded(s)),
                                                    onRemoveSymptom: (s) =>
                                                        bloc.add(SymptomRemoved(s)),
                                                    clinicalNoteController:
                                                        _clinicalNoteController,
                                                    isSavingNote: state.isObservationsSaving,
                                                    onSaveClinicalNote: () => bloc.add(
                                                      ObservationsSaveRequested(
                                                          _clinicalNoteController.text.trim()),
                                                    ),
                                                  ),
                                                  PrescriptionPanel(
                                                    items: state.prescriptionDraft,
                                                    isSaving: state.isPrescriptionSaving,
                                                    onAddItem: (name, dosage, frequency, timing) =>
                                                        bloc.add(PrescriptionItemAdded(
                                                      name: name,
                                                      dosage: dosage,
                                                      frequency: frequency,
                                                      timing: timing,
                                                    )),
                                                    onRemoveItem: (id) =>
                                                        bloc.add(PrescriptionItemRemoved(id)),
                                                    onDiscard: () => bloc
                                                        .add(const PrescriptionDiscardRequested()),
                                                    onSave: () =>
                                                        bloc.add(const PrescriptionSaveRequested()),
                                                  ),
                                                  ClinicalReportPanel(
                                                    sessionDuration:
                                                        report?.sessionDuration ?? '00:00',
                                                    reportDate: report?.reportDate ?? '',
                                                    reportRef: report?.reportRef ?? '',
                                                    signaturePending:
                                                        report?.signaturePending ?? true,
                                                    hasBeenGenerated: report != null,
                                                    isGenerating: state.isReportGenerating,
                                                    patientName: patient.name,
                                                    patientId: patient.displayId,
                                                    observationsText: state.observationsSummary,
                                                    medicineLines: medicineLines,
                                                    instructions: state.draftSymptoms.isEmpty
                                                        ? ''
                                                        : 'Review reported symptoms and advise accordingly.',
                                                    onReviewDocument: () =>
                                                        _showReviewDocumentDialog(
                                                            state.observationsSummary),
                                                    onAddSignature: () => bloc
                                                        .add(const ClinicalReportSignatureAdded()),
                                                    onGenerateAndSend: () => bloc.add(
                                                        const ClinicalReportGenerateRequested()),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }

                                  final tabbedRightColumn = AnimatedBuilder(
                                    animation: _tabController,
                                    builder: (context, _) => buildRightColumn(),
                                  );

                                  if (isWide) {
                                    return Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(width: 340, child: leftColumn),
                                        const SizedBox(width: 20),
                                        Expanded(child: tabbedRightColumn),
                                      ],
                                    );
                                  }

                                  return Column(
                                    children: [
                                      leftColumn,
                                      const SizedBox(height: 20),
                                      tabbedRightColumn
                                    ],
                                  );
                                },
                              ),
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
