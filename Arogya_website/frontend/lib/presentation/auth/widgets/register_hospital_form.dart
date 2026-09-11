import 'package:flutter/material.dart';

import 'auth_field.dart';

class RegisterHospitalForm extends StatefulWidget {
  final TextEditingController hospitalNameController;
  final TextEditingController licenseController;
  final TextEditingController directorController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final ValueChanged<String?> onFacilityTypeChanged;

  final VoidCallback onSubmit;

  const RegisterHospitalForm({
    super.key,
    required this.hospitalNameController,
    required this.licenseController,
    required this.directorController,
    required this.emailController,
    required this.phoneController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.onFacilityTypeChanged,               // NEW
    required this.onSubmit,
  });

  @override
  State<RegisterHospitalForm> createState() =>
      _RegisterHospitalFormState();
}

class _RegisterHospitalFormState extends State<RegisterHospitalForm> {
  String? _facilityType;

  final List<String> _facilityTypes = [
    'General',
    'Multispecialty',
    'Superspecialty',
    'Teaching',
    'Clinic',
    'Nursing Home',
    'Trauma Center',
    'Rehabilitation',
    'Psychiatric',
    'Maternity',
    'Pediatric',
    'Cancer Center',
    'Cardiac Center',
    'Dental',
    'Eye Hospital',
    'Ayurvedic',
    'Community',
  ];

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Register Medical Institution',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w600,
            color: Color(0xFF0F172A),
          ),
        ),

        const SizedBox(height: 4),

        const Text(
          'Create your hospital entity. Once verified by our clinical desk, '
          'you can provision\ndoctor credentials and configure specialized departments.',
          style: TextStyle(
            fontSize: 14,
            height: 1.45,
            color: Color(0xFF64748B),
          ),
        ),

        const SizedBox(height: 13),

        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 11,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFEAF8F4),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFFB6E9DC),
            ),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.circle,
                size: 7,
                color: Color(0xFF009688),
              ),
              SizedBox(width: 6),
              Text(
                'New Facility',
                style: TextStyle(
                  fontSize: 11,
                  color: Color(0xFF00897B),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        Container(
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F8FC),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: const Color(0xFFDCE5EF),
            ),
          ),
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.info_outline,
                size: 18,
                color: Color(0xFF00897B),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Institutional registration requires valid national or state '
                  'healthcare accreditation. All registrations undergo a strict '
                  '24-hour compliance audit prior to live patient data synchronization.',
                  style: TextStyle(
                    fontSize: 11.5,
                    height: 1.5,
                    color: Color(0xFF64748B),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 25),

        _SectionTitle(
          title: '1. INSTITUTIONAL DETAILS',
        ),

        const SizedBox(height: 15),

        AuthField(
          label: 'HOSPITAL / MEDICAL CENTER NAME *',
          hint: 'e.g. St. Jude Memorial Hospital & Research Institute',
          icon: Icons.business_outlined,
          controller: widget.hospitalNameController,
        ),

        const SizedBox(height: 16),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _DropdownField(
                label: 'FACILITY TYPE *',
                value: _facilityType,
                items: _facilityTypes,
                hint: 'Select facility type...',
                icon: Icons.apartment_outlined,
                onChanged: (value) {
                  setState(() {
                    _facilityType = value;
                  });
                  widget.onFacilityTypeChanged(value);
                },
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: AuthField(
                label: 'CLINICAL LICENSE / REG. NO. *',
                hint: 'E.G. REG-MED-849204-IN',
                icon: Icons.description_outlined,
                controller: widget.licenseController,
              ),
            ),
          ],
        ),

        const SizedBox(height: 27),

        _SectionTitle(
          title: '2. PRIMARY ADMINISTRATOR CONTACT',
        ),

        const SizedBox(height: 15),

        AuthField(
          label: 'MEDICAL DIRECTOR / HEAD ADMIN NAME *',
          hint: 'e.g. Dr. Rajesh Varma (Chief Medical Officer)',
          icon: Icons.person_outline,
          controller: widget.directorController,
        ),

        const SizedBox(height: 16),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: AuthField(
                label: 'OFFICIAL WORK EMAIL *',
                hint: 'director@stjudememorial.org',
                icon: Icons.mail_outline,
                controller: widget.emailController,
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: AuthField(
                label: 'DIRECT CONTACT PHONE *',
                hint: '+91 98765 43210',
                icon: Icons.phone_outlined,
                controller: widget.phoneController,
                keyboardType: TextInputType.phone,
              ),
            ),
          ],
        ),

        const SizedBox(height: 27),

        _SectionTitle(
          title: '3. MASTER SECURITY PASSWORD',
        ),

        const SizedBox(height: 15),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: AuthField(
                label: 'CREATE MASTER PASSWORD *',
                hint: 'Enter password',
                icon: Icons.lock_outline,
                controller: widget.passwordController,
                obscureText: _obscurePassword,
                suffix: IconButton(
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    size: 18,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: AuthField(
                label: 'CONFIRM MASTER PASSWORD *',
                hint: 'Repeat password',
                icon: Icons.lock_outline,
                controller:
                    widget.confirmPasswordController,
                obscureText: _obscureConfirmPassword,
                suffix: IconButton(
                  onPressed: () {
                    setState(() {
                      _obscureConfirmPassword =
                          !_obscureConfirmPassword;
                    });
                  },
                  icon: Icon(
                    _obscureConfirmPassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    size: 18,
                  ),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: widget.onSubmit,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00695C),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7),
              ),
            ),
            child: const Text(
              'Submit Institution for Verification',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF00695C),
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(width: 10),
        const Expanded(
          child: Divider(
            color: Color(0xFFDCE4ED),
          ),
        ),
      ],
    );
  }
}

class _DropdownField extends StatelessWidget {
  final String label;
  final String? value;
  final String hint;
  final List<String> items;
  final IconData icon;
  final ValueChanged<String?> onChanged;

  const _DropdownField({
    required this.label,
    required this.value,
    required this.hint,
    required this.items,
    required this.icon,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Color(0xFF475569),
          ),
        ),
        const SizedBox(height: 7),
        DropdownButtonFormField<String>(
          initialValue: value,
          hint: Text(
            hint,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF94A3B8),
            ),
          ),
          items: items.map(
            (item) {
              return DropdownMenuItem(
                value: item,
                child: Text(
                  item,
                  style: const TextStyle(
                    fontSize: 13,
                  ),
                ),
              );
            },
          ).toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            prefixIcon: Icon(
              icon,
              size: 18,
              color: const Color(0xFF94A3B8),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xFFCBD5E1),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xFFCBD5E1),
              ),
            ),
          ),
        ),
      ],
    );
  }
}