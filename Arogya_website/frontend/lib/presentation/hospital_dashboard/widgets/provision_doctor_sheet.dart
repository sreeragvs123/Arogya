import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/core/utils/service_locator.dart';
import 'package:frontend/domain/usecases/hospital_dashboard/create_doctor_usecase.dart';

/// Arogya Hospital Administration - Doctor Credential Provisioning Drawer / Sheet
///
/// Permits hospital administrators to establish physician identity,
/// verify state medical council registrations, configure department & room allocations,
/// issue encrypted temporary PINs, and grant delegated clinical authorities.
class ProvisionDoctorSheet extends StatefulWidget {
  final int hospitalId;
  final ValueChanged<String> onSaved;

  const ProvisionDoctorSheet({
    super.key,
    required this.hospitalId,
    required this.onSaved,
  });

  @override
  State<ProvisionDoctorSheet> createState() => _ProvisionDoctorSheetState();
}

class _ProvisionDoctorSheetState extends State<ProvisionDoctorSheet> {
  final _formKey = GlobalKey<FormState>();

  // Text Controllers
  final _nameController = TextEditingController();
  final _licenseController = TextEditingController();
  final _roomController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();

  bool _isSaving = false;

  // Selectable Clinical Options
  String _department = 'GENERAL_PHYSICIAN';
  String _rank = 'HOD';
  late String _pin;
  bool _isCopied = false;

  // Delegated Clinical Authorities
  bool _prescriptionAuth = true;
  bool _labOrdering = true;
  bool _dischargeSignoff = false;

  final List<Map<String, String>> _departmentOptions = [
    {'value': 'GENERAL_PHYSICIAN', 'label': 'General Physician'},
    {'value': 'PEDIATRICIAN', 'label': 'Pediatrician'},
    {
      'value': 'GYNECOLOGIST_OBSTETRICIAN',
      'label': 'Gynecologist / Obstetrician (OB-GYN)',
    },
    {'value': 'GENERAL_SURGEON', 'label': 'General Surgeon'},
    {'value': 'ORTHOPEDIC_SURGEON', 'label': 'Orthopedic Surgeon'},
    {'value': 'CARDIOLOGIST', 'label': 'Cardiologist'},
    {'value': 'NEUROLOGIST', 'label': 'Neurologist'},
    {'value': 'GASTROENTEROLOGIST', 'label': 'Gastroenterologist'},
    {'value': 'NEPHROLOGIST', 'label': 'Nephrologist'},
    {'value': 'PULMONOLOGIST', 'label': 'Pulmonologist'},
    {'value': 'ENDOCRINOLOGIST', 'label': 'Endocrinologist'},
    {'value': 'ONCOLOGIST', 'label': 'Oncologist'},
    {'value': 'RADIOLOGIST', 'label': 'Radiologist'},
    {'value': 'ANESTHESIOLOGIST', 'label': 'Anesthesiologist'},
    {'value': 'PATHOLOGIST', 'label': 'Pathologist'},
    {
      'value': 'EMERGENCY_MEDICINE_PHYSICIAN',
      'label': 'Emergency Medicine Physician',
    },
    {'value': 'DERMATOLOGIST', 'label': 'Dermatologist'},
    {'value': 'PSYCHIATRIST', 'label': 'Psychiatrist'},
    {'value': 'ENT_SURGEON', 'label': 'ENT Surgeon'},
    {'value': 'UROLOGIST', 'label': 'Urologist'},
    {'value': 'OPHTHALMOLOGIST', 'label': 'Ophthalmologist'},
  ];

  final List<Map<String, String>> _designationOptions = [
    {'value': 'HOD', 'label': 'Head of Department (HOD)'},
    {'value': 'SENIOR_CONSULTANT', 'label': 'Senior Consultant'},
    {'value': 'CONSULTANT', 'label': 'Consultant'},
    {'value': 'ATTENDING_PHYSICIAN', 'label': 'Attending Physician'},
    {'value': 'RESIDENT_DOCTOR', 'label': 'Resident Doctor'},
    {'value': 'CLINICAL_FELLOW', 'label': 'Clinical Fellow'},
    {'value': 'JUNIOR_DOCTOR', 'label': 'Junior Doctor'},
    {'value': 'INTERN', 'label': 'Intern'},
  ];
  @override
  void initState() {
    super.initState();
    _generatePin();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _licenseController.dispose();
    _roomController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    super.dispose();
  }

  void _generatePin() {
    final random = Random();
    final num1 = 1000 + random.nextInt(9000);
    const letters = 'ABCDEFGHJKLMNPQRSTUVWXYZ';
    final s1 = letters[random.nextInt(letters.length)];
    final s2 = letters[random.nextInt(letters.length)];
    setState(() {
      _pin = 'AP-$num1-$s1$s2';
      _isCopied = false;
    });
  }

  void _copyPin() {
    Clipboard.setData(ClipboardData(text: _pin));
    setState(() {
      _isCopied = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Temporary PIN copied to clipboard'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _handleSave() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isSaving = true);

    final params = CreateDoctorParams(
      hospitalId: widget.hospitalId,
      fullName: _nameController.text.trim(),
      licenseNumber: _licenseController.text.trim(),
      department: _department,
      designation: _rank,
      email: _emailController.text.trim(),
      phoneNumber: _mobileController.text.trim(),
      temporaryPin: _pin,
      prescriptionAuthority: _prescriptionAuth,
      labImagingOrdering: _labOrdering,
      dischargeSignoffAuthority: _dischargeSignoff,
    );

    final result = await sl<CreateDoctorUsecase>().call(params: params);

    if (!mounted) return;
    setState(() => _isSaving = false);

    result.fold((failure) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(failure.message), backgroundColor: Colors.red),
      );
    }, (_) => widget.onSaved(_nameController.text.trim()));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.horizontal(left: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Color(0x1E000000),
            blurRadius: 30,
            offset: Offset(-8, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          // Drawer Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 22),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEFF6FF),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: const Color(0xFFDBEAFE),
                              ),
                            ),
                            child: const Text(
                              'APOLLO HEALTH CITY',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.8,
                                color: Color(0xFF1D4ED8),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Unit HOSP-BLR-0192',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF94A3B8),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Provision Doctor Credential',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Establish identity, verify state council registration, and allocate clinical ward authority.',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF64748B),
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Color(0xFF64748B)),
                  onPressed: () => Navigator.of(context).pop(),
                  tooltip: 'Close Drawer',
                ),
              ],
            ),
          ),

          // Scrollable Form Body
          Expanded(
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(28),
                children: [
                  // Section 1: Physician Identity
                  _buildSectionHeader('1. PHYSICIAN IDENTITY & REGISTRATION'),
                  const SizedBox(height: 14),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _buildFormField(
                          label: 'Full Legal Name *',
                          controller: _nameController,
                          hintText: 'e.g. Dr. Rajesh Koothrappali, MD',
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return 'Physician name is required';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildFormField(
                          label: 'Medical Council / License No. *',
                          controller: _licenseController,
                          hintText: 'e.g. MCI - 2018 - 94821',
                          isMono: true,
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return 'Valid registration is required';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),

                  // Section 2: Specialty & Role Assignment
                  _buildSectionHeader('2. SPECIALTY & ROLE ASSIGNMENT'),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: _buildDropdownField(
                          label: 'Clinical Department *',
                          value: _department,
                          items: _departmentOptions,
                          onChanged: (val) {
                            if (val != null) setState(() => _department = val);
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildDropdownField(
                          label: 'Designation / Rank *',
                          value: _rank,
                          items: _designationOptions,
                          onChanged: (val) {
                            if (val != null) setState(() => _rank = val);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),

                  // Section 3: Work Communication & Temporary Security PIN
                  _buildSectionHeader(
                    '3. WORK COMMUNICATION & TEMPORARY ACCESS',
                  ),
                  const SizedBox(height: 14),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _buildFormField(
                          label: 'Official Work Email *',
                          controller: _emailController,
                          hintText: 'e.g. r.koothrappali@apollohealth.org',
                          keyboardType: TextInputType.emailAddress,
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return 'Email is required';
                            }
                            if (!val.contains('@')) {
                              return 'Enter a valid email address';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildFormField(
                          label: 'Direct Mobile Number *',
                          controller: _mobileController,
                          hintText: 'e.g. +91 98451 22314',
                          keyboardType: TextInputType.phone,
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return 'Mobile number is required';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Security PIN Card
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Temporary Security PIN',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF0F172A),
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'Doctor must change this upon first portal sign-in.',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFF94A3B8),
                                  ),
                                ),
                              ],
                            ),
                            TextButton.icon(
                              onPressed: _generatePin,
                              icon: const Icon(
                                Icons.refresh_rounded,
                                size: 15,
                                color: Color(0xFF2563EB),
                              ),
                              label: const Text(
                                'Regenerate',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF2563EB),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _pin,
                                style: const TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 2.5,
                                  color: Color(0xFF1E293B),
                                ),
                              ),
                              Row(
                                children: [
                                  const Text(
                                    'Sent via encrypted SMS',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Color(0xFF94A3B8),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  IconButton(
                                    icon: Icon(
                                      _isCopied
                                          ? Icons.check_circle
                                          : Icons.copy_rounded,
                                      size: 16,
                                      color: _isCopied
                                          ? const Color(0xFF10B981)
                                          : const Color(0xFF64748B),
                                    ),
                                    tooltip: 'Copy PIN',
                                    onPressed: _copyPin,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Section 4: Delegated Clinical Privileges
                  _buildSectionHeader('4. DELEGATED CLINICAL PRIVILEGES'),
                  const SizedBox(height: 14),
                  _buildPrivilegeCard(
                    title: 'EHR Prescription Authority',
                    subtitle:
                        'Authorize digital signing for Schedule H & general pharmaceuticals',
                    icon: Icons.assignment_turned_in_outlined,
                    value: _prescriptionAuth,
                    onChanged: (val) => setState(() => _prescriptionAuth = val),
                  ),
                  const SizedBox(height: 10),
                  _buildPrivilegeCard(
                    title: 'Lab & Imaging Test Ordering',
                    subtitle:
                        'Permit direct radiology, MRI, and specialized pathology orders',
                    icon: Icons.science_outlined,
                    value: _labOrdering,
                    onChanged: (val) => setState(() => _labOrdering = val),
                  ),
                  const SizedBox(height: 10),
                  _buildPrivilegeCard(
                    title: 'Direct Discharge Sign-off',
                    subtitle:
                        'Final inpatient medical clearance authority without secondary review',
                    icon: Icons.exit_to_app_rounded,
                    value: _dischargeSignoff,
                    onChanged: (val) => setState(() => _dischargeSignoff = val),
                  ),
                ],
              ),
            ),
          ),

          // Drawer Footer Actions
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
            decoration: const BoxDecoration(
              color: Color(0xFFF8FAFC),
              border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                    side: const BorderSide(color: Color(0xFFCBD5E1)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF475569),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: _isSaving ? null : _handleSave,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 22,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: _isSaving
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.verified_user_rounded, size: 18),
                  label: Text(
                    _isSaving
                        ? 'Issuing Credentials...'
                        : 'Save & Issue Doctor Credentials',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.2,
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

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.0,
        color: Color(0xFF94A3B8),
      ),
    );
  }

  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    String? hintText,
    bool isMono = false,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          style: TextStyle(
            fontSize: 13,
            fontFamily: isMono ? 'monospace' : null,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF0F172A),
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
            isDense: true,
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFF2563EB),
                width: 1.5,
              ),
            ),
          ),
          validator: validator,
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<Map<String, String>> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Color(0xFF64748B),
              ),
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Color(0xFF0F172A),
              ),
              items: items.map((itemPair) {
                return DropdownMenuItem<String>(
                  value: itemPair["value"],
                  child: Text(itemPair["label"]!),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPrivilegeCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: const Color(0xFF2563EB)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF64748B),
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Switch(
            value: value,
            activeThumbColor: const Color(0xFF2563EB),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
