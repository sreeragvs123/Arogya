import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/utils/service_locator.dart';
import 'package:frontend/domain/entities/auth/auth_session.dart';
import 'package:frontend/presentation/auth/bloc/auth_bloc.dart';
import 'package:frontend/presentation/auth/widgets/hospital_search_field.dart';
import 'package:frontend/presentation/doctor_dashboard/pages/doctor_page.dart';
import 'package:frontend/common/hospital_search/hospital_search_bloc.dart';
import 'package:frontend/domain/entities/auth/hospital.dart';

import 'auth_field.dart';

class DoctorSignInForm extends StatefulWidget {
  final TextEditingController hospitalController;
  final TextEditingController doctorIdController;
  final TextEditingController passwordController;

  const DoctorSignInForm({
    super.key,
    required this.hospitalController,
    required this.doctorIdController,
    required this.passwordController,
  });

  @override
  State<DoctorSignInForm> createState() => _DoctorSignInFormState();
}

class _DoctorSignInFormState extends State<DoctorSignInForm> {
  bool _obscurePassword = true;
  bool _rememberMe = false;
  int? _selectedHospitalId;

  void _handleDoctorSignIn() {
    context.read<AuthBloc>().add(
      DoctorSiginInEvent(
        hospitalId: _selectedHospitalId!,
        doctorId: widget.doctorIdController.text.trim(),
        password: widget.passwordController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Text(
              'Doctor Sign In',
              style: TextStyle(

                fontSize: 31,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0F172A),
              ),
            ),
            SizedBox(width: 12),
            _StatusBadge(text: 'Clinical Staff'),
          ],
        ),

        const SizedBox(height: 6),

        const Text(
          'Select your affiliated facility and enter your doctor\n'
          'credentials.',
          style: TextStyle(
            fontSize: 15,
            height: 1.45,
            color: Color(0xFF64748B),
          ),
        ),

        const SizedBox(height: 18),

        _InfoBox(
          icon: Icons.info_outline,
          text:
              'Doctor accounts are provisioned directly by hospital '
              'administration. If you require credentials, please '
              'contact your facility IT desk.',
        ),

        const SizedBox(height: 20),

        const Text(
          'Associated Hospital / Health Center',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF475569),
          ),
        ),

        const SizedBox(height: 8),

        BlocProvider(
          create: (_) => sl<HospitalSearchBloc>(),
          child: HospitalSearchField(
            controller: widget.hospitalController,
            onHospitalSelected: (hospital) {
              setState(() {
                widget.hospitalController.text = hospital.name;
                _selectedHospitalId = hospital.id;
              });
            },
          ),
        ),

        const SizedBox(height: 18),

        AuthField(
          label: 'Doctor ID or Clinical Work Email',
          hint: 'e.g. DOC-4820 or dr.adebayo@arogya.org',
          icon: Icons.badge_outlined,
          controller: widget.doctorIdController,
        ),

        const SizedBox(height: 18),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Password / Security PIN',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF475569),
              ),
            ),

            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
              ),
              child: const Text(
                'Reset PIN',
                style: TextStyle(color: Color(0xFF00796B), fontSize: 12),
              ),
            ),
          ],
        ),

        const SizedBox(height: 4),

        TextFormField(
          controller: widget.passwordController,
          obscureText: _obscurePassword,
          decoration: InputDecoration(
            hintText: '••••••••••',
            prefixIcon: const Icon(
              Icons.lock_outline,
              size: 18,
              color: Color(0xFF64748B),
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
              borderRadius: BorderRadius.circular(7),
              borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7),
              borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
            ),
          ),
        ),

        const SizedBox(height: 12),

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
              'Remember on this workstation',
              style: TextStyle(fontSize: 12, color: Color(0xFF475569)),
            ),

            const Spacer(),

            const Icon(Icons.lock_outline, size: 14, color: Color(0xFF00897B)),

            const SizedBox(width: 4),

            const Text(
              'HIPAA Secure',
              style: TextStyle(fontSize: 12, color: Color(0xFF00796B)),
            ),
          ],
        ),

        const SizedBox(height: 10),

        _SubmitButton(
          text: 'Access Clinical Portal',
          onPressed: () => _handleDoctorSignIn(),
        ),
        const SizedBox(height: 20),
        Center(
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DoctorDashBoardPage(
                    session: DoctorSession(
                      accessToken: 'dev-token',
                      expiresAt: DateTime.now().add(const Duration(hours: 1)),
                      role: UserRole.doctor,
                      doctorId: 1,
                      doctorName: 'Dev Doctor',
                      hospitalId: 1,
                    ),
                  ),
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



class _StatusBadge extends StatelessWidget {
  final String text;

  const _StatusBadge({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5F3),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFB2DFDB)),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          color: Color(0xFF00796B),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _InfoBox extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoBox({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: const Color(0xFFDCE4ED)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: const Color(0xFF00796B)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 12,
                height: 1.45,
                color: Color(0xFF64748B),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const _SubmitButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 2,
          backgroundColor: const Color(0xFF00695C),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward, size: 18),
          ],
        ),
      ),
    );
  }
}
