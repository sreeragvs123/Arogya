import 'package:flutter/material.dart';
import 'package:frontend/presentation/hospital_dashboard/pages/hospital_dashboard_page.dart';

import 'auth_field.dart';

class HospitalSignInForm extends StatefulWidget {
  final TextEditingController identifierController;
  final TextEditingController passwordController;
  final TextEditingController departmentController;

  final VoidCallback onSubmit;
  final VoidCallback onForgotPassword;

  const HospitalSignInForm({
    super.key,
    required this.identifierController,
    required this.passwordController,
    required this.departmentController,
    required this.onSubmit,
    required this.onForgotPassword,
  });

  @override
  State<HospitalSignInForm> createState() => _HospitalSignInFormState();
}

class _HospitalSignInFormState extends State<HospitalSignInForm> {
  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Text(
              'Hospital Sign In',
              style: TextStyle(
                fontSize: 31,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0F172A),
              ),
            ),
            SizedBox(width: 10),
            _FacilityBadge(),
          ],
        ),

        const SizedBox(height: 6),

        const Text(
          'Enter your institutional credentials to manage clinical '
          'departments, doctors, and\npatient records.',
          style: TextStyle(
            fontSize: 14.5,
            height: 1.45,
            color: Color(0xFF64748B),
          ),
        ),

        const SizedBox(height: 24),

        AuthField(
          label: 'Hospital Identifier or Admin Work Email',
          hint: 'e.g. HOSP-BLR-0192 or admin@apollohealth.org',
          icon: Icons.business_outlined,
          controller: widget.identifierController,
        ),

        const SizedBox(height: 18),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Institutional Access Code / Password',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF334155),
              ),
            ),
            TextButton(
              onPressed: widget.onForgotPassword,
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
              ),
              child: const Text(
                'Forgot Hospital Password?',
                style: TextStyle(color: Color(0xFF00695C), fontSize: 12),
              ),
            ),
          ],
        ),

        const SizedBox(height: 5),

        TextFormField(
          controller: widget.passwordController,
          obscureText: _obscurePassword,
          decoration: InputDecoration(
            hintText: '••••••••••••',
            prefixIcon: const Icon(
              Icons.lock_open_outlined,
              size: 18,
              color: Color(0xFF94A3B8),
            ),
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
              icon: Icon(
                _obscurePassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                size: 19,
                color: const Color(0xFF78909C),
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
            ),
          ),
        ),

        SizedBox(height: 30,),

        Row(
          children: [
            Checkbox(
              value: _rememberMe,
              onChanged: (value) {
                setState(() {
                  _rememberMe = value ?? false;
                });
              },
              visualDensity: VisualDensity.compact,
            ),

            const Text(
              'Remember this workstation',
              style: TextStyle(fontSize: 12, color: Color(0xFF475569)),
            ),

            const Spacer(),

            const Icon(
              Icons.verified_user_outlined,
              size: 15,
              color: Color(0xFF009688),
            ),

            const SizedBox(width: 4),

            const Text(
              'NABH & HIPAA Secure',
              style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
            ),
          ],
        ),

        const SizedBox(height: 11),

        SizedBox(
          width: double.infinity,
          height: 46,
          child: ElevatedButton(
            onPressed: widget.onSubmit,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00695C),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Sign In to Hospital Portal',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                SizedBox(width: 10),
                Icon(Icons.arrow_forward, size: 18),
              ],
            ),
          ),
        ),

        const SizedBox(height: 24),

        const Center(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'New medical institution? ',
                  style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
                ),
                TextSpan(
                  text: 'Register your hospital here',
                  style: TextStyle(
                    color: Color(0xFF00695C),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 20,),
        Center(
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const HospitalDashboardPage(hospitalId: 1),
                ),
              );
            },
            child: Text(
              'Developer Entry',
              style: TextStyle(color: Colors.red.shade400, fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }
}

class _FacilityBadge extends StatelessWidget {
  const _FacilityBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F8F5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF9DE5D2)),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.circle, size: 6, color: Color(0xFF00897B)),
          SizedBox(width: 5),
          Text(
            'Facility Admin',
            style: TextStyle(fontSize: 11, color: Color(0xFF00796B)),
          ),
        ],
      ),
    );
  }
}
