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
            const SizedBox(height: 15),
            const Text(
              'Hospital Dashboard : Physician Staffs',
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