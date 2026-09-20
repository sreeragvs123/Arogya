import 'package:flutter/material.dart';
import 'package:frontend/domain/entities/patients/patient_summary_entity.dart';
import '../../../core/theme/app_colors.dart';


class ActivePatientCard extends StatelessWidget {
  final PatientSummaryEntity patient;
  final VoidCallback onEnterWorkspace;

  const ActivePatientCard({
    super.key,
    required this.patient,
    required this.onEnterWorkspace,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(width: 4, height: 44, color: AppColors.primary),
          const SizedBox(width: 16),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  patient.name,
                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  children: const [
                    _Chip(text: 'ACTIVE SESSION', bg: Color(0xFFE1F3E8), fg: Color(0xFF1E8E4F)),
                    _Chip(text: 'CURRENTLY CONSULTING', bg: Color(0xFFEEF0FC), fg: AppColors.primary),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('LAST VISIT', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                const SizedBox(height: 4),
                Text(patient.lastVisit, style: const TextStyle(fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Wrap(
              spacing: 6,
              children: [
                _Chip(text: patient.diagnosis, bg: const Color(0xFFEEF0FC), fg: AppColors.primary),
                if (patient.isHighRisk)
                  const _Chip(text: 'High Risk', bg: Color(0xFFFCE4E4), fg: Color(0xFFC0392B)),
              ],
            ),
          ),
          ElevatedButton.icon(
            onPressed: onEnterWorkspace,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            icon: const Icon(Icons.dashboard_customize_outlined, size: 18),
            label: const Text('Enter Treatment Workspace'),
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String text;
  final Color bg;
  final Color fg;

  const _Chip({required this.text, required this.bg, required this.fg});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(
        text,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: fg),
      ),
    );
  }
}