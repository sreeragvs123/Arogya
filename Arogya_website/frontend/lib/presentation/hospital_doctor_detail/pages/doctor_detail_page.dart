import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/utils/service_locator.dart';
import 'package:frontend/domain/entities/hosptial_dashboard/doctor_detail_entity.dart';
import 'package:frontend/domain/entities/hosptial_dashboard/doctor_summary_entity.dart';
import 'package:frontend/presentation/hospital_doctor_detail/bloc/doctor_detail_bloc.dart';

class DoctorDetailPage extends StatelessWidget {
  final int hospitalId;
  final int doctorId;

  const DoctorDetailPage({
    super.key,
    required this.hospitalId,
    required this.doctorId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<DoctorDetailBloc>()
        ..add(DoctorDetailStarted(hospitalId: hospitalId, doctorId: doctorId)),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        body: SafeArea(
          child: BlocBuilder<DoctorDetailBloc, DoctorDetailState>(
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTopBar(context),
                  const Divider(height: 1, color: Color(0xFFE2E8F0)),
                  Expanded(
                    child: state.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : state.errorMessage != null
                            ? Center(
                                child: Text(
                                  state.errorMessage!,
                                  style: const TextStyle(color: Colors.red),
                                ),
                              )
                            : state.doctor == null
                                ? const SizedBox.shrink()
                                : _DoctorDetailBody(doctor: state.doctor!),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF0F172A)),
          ),
          const SizedBox(width: 8),
          const Text(
            'Doctor Profile',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF0F172A)),
          ),
        ],
      ),
    );
  }
}

class _DoctorDetailBody extends StatelessWidget {
  final DoctorDetailEntity doctor;
  const _DoctorDetailBody({required this.doctor});

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

  static String _sexLabel(Sex? s) {
    switch (s) {
      case Sex.male:
        return 'Male';
      case Sex.female:
        return 'Female';
      case Sex.other:
        return 'Other';
      case null:
        return 'Not specified';
    }
  }

  static String _formatDate(DateTime? d) {
    if (d == null) return '—';
    return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
  }

  static String _formatDateTime(DateTime? d) {
    if (d == null) return '—';
    return '${_formatDate(d)} • ${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final initial = doctor.fullName.replaceFirst('Dr. ', '').trim().isNotEmpty
        ? doctor.fullName.replaceFirst('Dr. ', '').trim().substring(0, 1)
        : '?';

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _headerCard(initial),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _infoCard('Personal Information', [
                  _InfoRow('Sex', _sexLabel(doctor.sex)),
                  _InfoRow('Date of Birth', _formatDate(doctor.dateOfBirth)),
                ]),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _infoCard('License & Council', [
                  _InfoRow('License Number', doctor.licenseNumber),
                  _InfoRow('Verification', _verificationLabel(doctor.verificationStatus)),
                ]),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _infoCard('Facility', [
                  _InfoRow('Hospital', doctor.hospitalName),
                  _InfoRow('Specialization', doctor.specialization),
                ]),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _infoCard('Direct Contact', [
                  _InfoRow('Email', doctor.email),
                  _InfoRow('Phone', doctor.phoneNumber),
                ]),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _privilegesCard(),
          const SizedBox(height: 16),
          _infoCard('Account Timeline', [
            _InfoRow('Provisioned On', _formatDateTime(doctor.createdAt)),
            _InfoRow('Last Updated', _formatDateTime(doctor.updatedAt)),
            _InfoRow(
              'Last Login',
              doctor.lastLoginAt == null ? 'Never logged in' : _formatDateTime(doctor.lastLoginAt),
            ),
          ]),
        ],
      ),
    );
  }

  Widget _headerCard(String initial) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 36,
            backgroundColor: const Color(0xFFE0E7FF),
            child: Text(
              initial,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Color(0xFF3730A3)),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doctor.fullName,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Color(0xFF0F172A)),
                ),
                const SizedBox(height: 4),
                Text(
                  '${_designationLabel(doctor.designation)} • ${doctor.specialization}',
                  style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _badge(_statusLabel(doctor.status), const Color(0xFFDCFCE7), const Color(0xFF166534)),
                    const SizedBox(width: 8),
                    _badge(
                      _verificationLabel(doctor.verificationStatus),
                      doctor.verificationStatus == VerificationStatus.verified
                          ? const Color(0xFFDCFCE7)
                          : doctor.verificationStatus == VerificationStatus.rejected
                              ? const Color(0xFFFEE2E2)
                              : const Color(0xFFFEF3C7),
                      doctor.verificationStatus == VerificationStatus.verified
                          ? const Color(0xFF166534)
                          : doctor.verificationStatus == VerificationStatus.rejected
                              ? const Color(0xFF991B1B)
                              : const Color(0xFF92400E),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _badge(String label, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: fg)),
    );
  }

  Widget _infoCard(String title, List<_InfoRow> rows) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
          const SizedBox(height: 14),
          ...rows.map(
            (r) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 130,
                    child: Text(r.label, style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
                  ),
                  Expanded(
                    child: Text(
                      r.value,
                      style: const TextStyle(fontSize: 13, color: Color(0xFF334155), fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _privilegesCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Clinical Privileges',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _privilegeChip('Prescription Authority', doctor.prescriptionAuthority),
              _privilegeChip('Lab & Imaging Ordering', doctor.labImagingOrdering),
              _privilegeChip('Discharge Sign-off', doctor.dischargeSignoffAuthority),
            ],
          ),
        ],
      ),
    );
  }

  Widget _privilegeChip(String label, bool granted) {
    final bg = granted ? const Color(0xFFEFF6FF) : const Color(0xFFF1F5F9);
    final fg = granted ? const Color(0xFF1D4ED8) : const Color(0xFF94A3B8);
    final icon = granted ? Icons.check_circle_rounded : Icons.remove_circle_outline_rounded;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: fg),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: fg)),
        ],
      ),
    );
  }
}

class _InfoRow {
  final String label;
  final String value;
  const _InfoRow(this.label, this.value);
}