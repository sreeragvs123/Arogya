import 'package:flutter/material.dart';
import 'package:frontend/data/models/summary/patient_summary.dart';
import '../../../core/routing/app_routes.dart';
import '../../../common/patient_dashboard_sidebar.dart';
import '../../../common/patient_dashboard_topbar.dart';
import '../widgets/patients_header_section.dart';
import '../widgets/patient_filter_bar.dart';
import '../widgets/active_patient_card.dart';
import '../widgets/patient_list_section.dart';

class PatientsPage extends StatelessWidget {
  const PatientsPage({super.key});

  static const PatientSummary _activePatient = PatientSummary(
    name: 'Vikram Malhotra',
    patientId: 'PID: 88291-AM',
    age: 45,
    gender: 'Male',
    status: 'Currently Consulting',
    lastVisit: 'Today, 09:15 AM',
    diagnosis: 'Type 2 Diabetes',
    isHighRisk: true,
  );

  static const List<PatientSummary> _patients = [
    PatientSummary(
      name: 'Anjali Sharma',
      patientId: 'PID: 90211-BX',
      age: 38,
      gender: 'Female',
      status: 'Scheduled',
      lastVisit: 'Oct 24, 2023',
      diagnosis: 'Hypertension',
    ),
    PatientSummary(
      name: 'Anjali Sharma',
      patientId: 'PID: 90211-BX',
      age: 38,
      gender: 'Female',
      status: 'Scheduled',
      lastVisit: 'Oct 24, 2023',
      diagnosis: 'Hypertension',
    ),
  ];

  void _openPatientDetail(BuildContext context) {
    // TODO: pass a patient id through route arguments once
    // PatientDetailPage accepts one instead of hardcoded data.
    Navigator.pushNamed(context, AppRoutes.patientDetail);
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
                        const PatientsHeaderSection(
                          totalPatients: 1284,
                          totalPatientsGrowth: '+12%',
                          newThisMonth: 48,
                          followUpsPending: 15,
                        ),
                        const SizedBox(height: 24),
                        PatientFilterBar(onApplyFilters: () {}),
                        const SizedBox(height: 20),
                        ActivePatientCard(
                          patient: _activePatient,
                          onEnterWorkspace: () => _openPatientDetail(context),
                        ),
                        const SizedBox(height: 24),
                        PatientListSection(
                          patients: _patients,
                          onWorkspaceTap: (_) => _openPatientDetail(context),
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