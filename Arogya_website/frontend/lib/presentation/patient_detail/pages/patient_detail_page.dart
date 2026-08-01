import 'package:flutter/material.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../common/app_sidebar.dart';
import '../../../common/app_top_bar.dart';
import '../widgets/clinical_report_panel.dart';
import '../widgets/patient_header.dart';
import '../widgets/prescription_panel.dart';
import '../widgets/recent_observations_card.dart';
import '../widgets/vitals_panel.dart';
import '../widgets/vitals_trend_card.dart';

class PatientDetailPage extends StatefulWidget {
  const PatientDetailPage({super.key});

  @override
  State<PatientDetailPage> createState() => _PatientDetailPageState();
}

class _PatientDetailPageState extends State<PatientDetailPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  static const List<ObservationData> _observations = [
    ObservationData(
      date: 'Oct 24, 2023',
      note: 'Reported mild insomnia and occasional dizziness. Blood sugar levels slightly elevated (142 mg/dL).',
    ),
    ObservationData(
      date: 'Sep 12, 2023',
      note: 'Annual checkup. BMI improved by 1.2 points. Recommend continued low-sodium diet.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PatientHeader(
                          name: 'Vikram Malhotra',
                          patientId: 'AR-9920-X',
                          isHighSensitivity: true,
                          age: '42',
                          gender: 'Male',
                          bloodGroup: 'B+ Positive',
                          height: '178 cm',
                          weight: '82 kg',
                          onFullHistory: () {}, // TODO: navigate to full history
                          onPrintQr: () {}, // TODO: generate + print QR
                        ),
                        const SizedBox(height: 24),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final isWide = constraints.maxWidth > 900;

                            final leftColumn = Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: const [
                                VitalsTrendCard(),
                                SizedBox(height: 20),
                                RecentObservationsCard(observations: _observations),
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
                                      labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14.5),
                                      tabs: const [
                                        Tab(text: 'Vitals'),
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
                                            const VitalsPanel(),
                                            const PrescriptionPanel(),
                                            ClinicalReportPanel(
                                              patientName: 'Vikram Malhotra',
                                              patientId: 'AR-9920-X',
                                              observationsText:
                                                  'Patient presents with mild insomnia and occasional dizziness. '
                                                  'Blood sugar levels slightly elevated (142 mg/dL). Vitals remain '
                                                  'stable with heart rate at 72 BPM and BP at 118/79 mmHg.',
                                              medicineName: 'Atorvastatin',
                                              medicineSchedule: '10mg - Once Daily',
                                              instructions:
                                                  'Low Sodium, High Fiber diet recommended. Follow-up in 14 days.',
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }

                            // AnimatedBuilder rebuilds this subtree whenever the
                            // TabController's index changes, so IndexedStack
                            // actually swaps the visible panel on tab tap.
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
                              children: [leftColumn, const SizedBox(height: 20), tabbedRightColumn],
                            );
                          },
                        ),
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
