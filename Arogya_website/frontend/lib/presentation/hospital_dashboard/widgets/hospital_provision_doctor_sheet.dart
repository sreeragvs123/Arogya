// presentation/hospital_dashboard/widgets/hospital_provision_doctor_sheet.dart
import 'package:flutter/material.dart';
import 'package:frontend/presentation/hospital_dashboard/widgets/provision_doctor_sheet.dart';

/// Hospital Administration - Doctor Credential Provisioning Drawer / Sheet
class HospitalProvisionDoctorSheet extends StatelessWidget {
  final ValueChanged<String> onSaved;

  const HospitalProvisionDoctorSheet({super.key, required this.onSaved});

  @override
  Widget build(BuildContext context) {
    return ProvisionDoctorSheet(onSaved: onSaved);
  }
}