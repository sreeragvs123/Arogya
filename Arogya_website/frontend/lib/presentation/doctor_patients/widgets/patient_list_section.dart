import 'package:flutter/material.dart';
import 'package:frontend/domain/entities/patients/patient_summary_entity.dart';

import '../../../core/theme/app_colors.dart';


class PatientListSection extends StatelessWidget {
  final List<PatientSummaryEntity> patients;
  final ValueChanged<PatientSummaryEntity> onWorkspaceTap;

  const PatientListSection({
    super.key,
    required this.patients,
    required this.onWorkspaceTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _HeaderRow(),
        const Divider(height: 1, color: AppColors.divider),
        ...patients.map(
          (p) => _PatientRow(patient: p, onWorkspaceTap: () => onWorkspaceTap(p)),
        ),
      ],
    );
  }
}

class _HeaderRow extends StatelessWidget {
  const _HeaderRow();

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(
      fontSize: 11.5,
      fontWeight: FontWeight.w600,
      color: AppColors.textSecondary,
      letterSpacing: 0.4,
    );
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(flex: 3, child: Text('PATIENT IDENTITY', style: style)),
          Expanded(flex: 2, child: Text('STATUS', style: style)),
          Expanded(flex: 2, child: Text('LAST VISIT', style: style)),
          Expanded(flex: 2, child: Text('PRIMARY DIAGNOSIS', style: style)),
          Expanded(flex: 2, child: Text('ACTION', style: style)),
        ],
      ),
    );
  }
}

class _PatientRow extends StatelessWidget {
  final PatientSummaryEntity patient;
  final VoidCallback onWorkspaceTap;

  const _PatientRow({required this.patient, required this.onWorkspaceTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: const Color(0xFFEEF0FC),
                  child: Text(
                    patient.initials,
                    style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(patient.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                    Text(
                      patient.patientId,
                      style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF0FC),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  patient.status.toUpperCase(),
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
          Expanded(flex: 2, child: Text(patient.lastVisit)),
          Expanded(
            flex: 2,
            child: Container(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF0FC),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  patient.diagnosis,
                  style: const TextStyle(fontSize: 12, color: AppColors.primary),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: TextButton.icon(
              onPressed: onWorkspaceTap,
              icon: const Icon(Icons.dashboard_customize_outlined, size: 16),
              label: const Text('Workspace'),
              style: TextButton.styleFrom(foregroundColor: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}