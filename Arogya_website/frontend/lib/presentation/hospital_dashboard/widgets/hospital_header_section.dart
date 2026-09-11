// presentation/hospital_dashboard/widgets/hospital_header_section.dart
import 'package:flutter/material.dart';

class HospitalHeaderSection extends StatelessWidget {
  final VoidCallback onAddDoctorTap;
  final VoidCallback onImportCsv;
  final VoidCallback onExportRegister;

  const HospitalHeaderSection({
    super.key,
    required this.onAddDoctorTap,
    required this.onImportCsv,
    required this.onExportRegister,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Text('Hospital Governance',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF64748B))),
                Icon(Icons.chevron_right, size: 14, color: Color(0xFF94A3B8)),
                Text('Hospital Dashboard',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF2563EB))),
              ],
            ),
            const SizedBox(height: 6),
            const Text(
              'Hospital Dashboard — Clinical Staff & Doctors',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, letterSpacing: -0.5, color: Color(0xFF0F172A)),
            ),
            const SizedBox(height: 4),
            const Text(
              'Hospital administration dashboard for managing licensed practitioners, OPD duty shifts, and clinical governance.',
              style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
            ),
          ],
        ),
        Row(
          children: [
            OutlinedButton.icon(
              onPressed: onExportRegister,
              icon: const Icon(Icons.file_download_outlined, size: 16),
              label: const Text('Export Register'),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF334155),
                side: const BorderSide(color: Color(0xFFCBD5E1)),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(width: 10),
            ElevatedButton.icon(
              onPressed: onAddDoctorTap,
              icon: const Icon(Icons.person_add_alt_1_rounded, size: 18),
              label: const Text('Provision Doctor'),
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
      ],
    );
  }
}