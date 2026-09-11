// presentation/hospital_dashboard/widgets/hospital_table_section.dart
import 'package:flutter/material.dart';
import 'package:frontend/domain/entities/hosptial_dashboard/doctor_summary_entity.dart';

class HospitalTableSection extends StatelessWidget {
  final List<DoctorSummaryEntity> doctors;
  final ValueChanged<DoctorSummaryEntity> onManagePrivileges;
  final ValueChanged<DoctorSummaryEntity> onResendPin;

  const HospitalTableSection({
    super.key,
    required this.doctors,
    required this.onManagePrivileges,
    required this.onResendPin,
  });

  static String _designationLabel(Designation d) {
    switch (d) {
      case Designation.seniorConsultant:
        return 'Senior Consultant';
      case Designation.consultant:
        return 'Consultant';
      case Designation.hod:
        return 'Head of Department';
      case Designation.attendingPhysician:
        return 'Attending Physician';
      case Designation.residentDoctor:
        return 'Resident Doctor';
    }
  }

  static String _statusLabel(DoctorStatus s) {
    switch (s) {
      case DoctorStatus.active:
        return 'Active Today';
      case DoctorStatus.inOpd:
        return 'In OPD';
      case DoctorStatus.onCall:
        return 'On Call Duty';
      case DoctorStatus.onLeave:
        return 'On Leave';
      case DoctorStatus.pendingFirstLogin:
        return 'Pending First Login';
      case DoctorStatus.inactive:
        return 'Inactive';
    }
  }

  static String _verificationLabel(VerificationStatus v) {
    switch (v) {
      case VerificationStatus.verified:
        return 'Verified NMC Council';
      case VerificationStatus.pending:
        return 'Pending Verification';
      case VerificationStatus.rejected:
        return 'Registration Rejected';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(color: Color(0x04000000), blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text(
                      'Hospital Clinical Staff Register',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF0F172A)),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${doctors.length} Staff on Roster',
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF475569)),
                      ),
                    ),
                  ],
                ),
                const Row(
                  children: [
                    Icon(Icons.check_circle_rounded, size: 14, color: Color(0xFF10B981)),
                    SizedBox(width: 4),
                    Text(
                      'Council Verification Synchronized',
                      style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            color: const Color(0xFFF8FAFC),
            child: const Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Text('HOSPITAL PRACTITIONER',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF64748B))),
                ),
                Expanded(
                  flex: 3,
                  child: Text('LICENSE & COUNCIL',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF64748B))),
                ),
                Expanded(
                  flex: 3,
                  child: Text('FACILITY & WARD',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF64748B))),
                ),
                Expanded(
                  flex: 3,
                  child: Text('STATUS',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF64748B))),
                ),
                Expanded(
                  flex: 3,
                  child: Text('DIRECT CONTACT',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF64748B))),
                ),
                SizedBox(
                  width: 130,
                  child: Text('ACTIONS',
                      textAlign: TextAlign.end,
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF64748B))),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE2E8F0)),
          if (doctors.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: Center(
                child: Text('No staff match the current filters', style: TextStyle(color: Color(0xFF94A3B8))),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: doctors.length,
              separatorBuilder: (context, index) => const Divider(height: 1, color: Color(0xFFF1F5F9)),
              itemBuilder: (context, index) => _buildDoctorRow(context, doctors[index]),
            ),
        ],
      ),
    );
  }

  Widget _buildDoctorRow(BuildContext context, DoctorSummaryEntity doc) {
    Color badgeBg;
    Color badgeText;
    switch (doc.status) {
      case DoctorStatus.active:
      case DoctorStatus.inOpd:
        badgeBg = const Color(0xFFDCFCE7);
        badgeText = const Color(0xFF166534);
        break;
      case DoctorStatus.onCall:
        badgeBg = const Color(0xFFEFF6FF);
        badgeText = const Color(0xFF1D4ED8);
        break;
      case DoctorStatus.pendingFirstLogin:
        badgeBg = const Color(0xFFFEF3C7);
        badgeText = const Color(0xFF92400E);
        break;
      case DoctorStatus.onLeave:
      case DoctorStatus.inactive:
        badgeBg = const Color(0xFFF1F5F9);
        badgeText = const Color(0xFF475569);
        break;
    }

    final initial = doc.doctorName.replaceFirst('Dr. ', '').trim().isNotEmpty
        ? doc.doctorName.replaceFirst('Dr. ', '').trim().substring(0, 1)
        : '?';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: const Color(0xFFE0E7FF),
                  child: Text(
                    initial,
                    style: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF3730A3)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doc.doctorName,
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF0F172A)),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${_designationLabel(doc.designation)} • ${doc.specialization}',
                        style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doc.licenseNumber,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF334155)),
                ),
                const SizedBox(height: 2),
                Text(
                  _verificationLabel(doc.verificationStatus),
                  style: TextStyle(
                    fontSize: 11,
                    color: doc.verificationStatus == VerificationStatus.verified
                        ? const Color(0xFF16A34A)
                        : doc.verificationStatus == VerificationStatus.rejected
                            ? const Color(0xFFDC2626)
                            : const Color(0xFFD97706),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(doc.hospitalName, style: const TextStyle(fontSize: 12, color: Color(0xFF334155))),
                const SizedBox(height: 2),
                Text(doc.wardOrDepartment, style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: badgeBg, borderRadius: BorderRadius.circular(20)),
                child: Text(
                  _statusLabel(doc.status),
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: badgeText),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(doc.email, style: const TextStyle(fontSize: 11, color: Color(0xFF2563EB))),
                const SizedBox(height: 2),
                Text(doc.phoneNumber, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
              ],
            ),
          ),
          SizedBox(
            width: 130,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () => onManagePrivileges(doc),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    side: const BorderSide(color: Color(0xFFE2E8F0)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Privileges', style: TextStyle(fontSize: 11, color: Color(0xFF334155))),
                ),
                const SizedBox(width: 6),
                IconButton(
                  onPressed: () => onResendPin(doc),
                  icon: const Icon(Icons.send_rounded, size: 14, color: Color(0xFF64748B)),
                  tooltip: 'Resend PIN',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}