import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import 'report_action_button.dart';

class ClinicalReportPanel extends StatelessWidget {
  final String sessionDuration;
  final String reportDate;
  final String reportRef;
  final String patientName;
  final String patientId;
  final String observationsText;
  final String medicineName;
  final String medicineSchedule;
  final String instructions;

  const ClinicalReportPanel({
    super.key,
    this.sessionDuration = '04:15',
    this.reportDate = 'Oct 24, 2023',
    this.reportRef = 'CSR-2023-0892',
    required this.patientName,
    required this.patientId,
    required this.observationsText,
    required this.medicineName,
    required this.medicineSchedule,
    required this.instructions,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Treatment Formulation',
                    style: TextStyle(fontFamily: 'Georgia', fontSize: 24, fontWeight: FontWeight.w700)),
                SizedBox(height: 4),
                Text('Compose diagnosis and digital prescription',
                    style: TextStyle(fontSize: 13.5, color: AppColors.textSecondary)),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text('Session Duration', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                Text(sessionDuration,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.primary)),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(
                          child: Text('Clinical Summary Report',
                              style: TextStyle(fontFamily: 'Georgia', fontSize: 19, fontWeight: FontWeight.w700)),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('Date: $reportDate', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                            Text('Ref: $reportRef', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text('Patient: $patientName | ID: $patientId',
                        style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Divider(height: 1, color: AppColors.divider),
                    ),
                    const Text('CLINICAL OBSERVATIONS',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 0.5, color: AppColors.primary)),
                    const SizedBox(height: 10),
                    Text(observationsText, style: const TextStyle(fontSize: 14.5, height: 1.6, color: AppColors.textPrimary)),
                    const SizedBox(height: 20),
                    const Text('PRESCRIBED REGIMEN',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 0.5, color: AppColors.primary)),
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.scaffoldBackground,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(medicineName, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5)),
                              Text(medicineSchedule, style: const TextStyle(fontSize: 13.5, color: AppColors.textSecondary)),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text('Instructions: $instructions',
                              style: const TextStyle(fontSize: 13.5, color: AppColors.textSecondary, height: 1.5)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    const Divider(color: AppColors.divider),
                    const SizedBox(height: 8),
                    const Align(
                      alignment: Alignment.centerRight,
                      child: Text('Digital Signature Pending',
                          style: TextStyle(fontSize: 12.5, color: AppColors.textMuted, fontStyle: FontStyle.italic)),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('Report Actions', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                  const SizedBox(height: 14),
                  ReportActionButton(icon: Icons.visibility_outlined, label: 'Review Document', onTap: () {}), // TODO
                  const SizedBox(height: 12),
                  ReportActionButton(icon: Icons.draw_outlined, label: 'Add Digital Signature', onTap: () {}), // TODO
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {}, // TODO: generate report + send to hospital ERP / patient app
                      icon: const Icon(Icons.send_outlined, size: 18, color: Colors.white),
                      label: const Text('Generate & Send',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                      style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.info_outline_rounded, size: 15, color: AppColors.textMuted),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Generating this report will automatically sync the data with the Hospital ERP and notify the patient via the Arogya App.',
                          style: const TextStyle(fontSize: 12, color: AppColors.textMuted, height: 1.5),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
