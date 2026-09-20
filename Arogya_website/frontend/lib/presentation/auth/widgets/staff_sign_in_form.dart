import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/utils/service_locator.dart';
import 'package:frontend/common/hospital_search/hospital_search_bloc.dart';
import 'package:frontend/presentation/auth/bloc/auth_bloc.dart';
import 'hospital_search_field.dart';

class StaffSignInForm extends StatefulWidget {
  final TextEditingController hospitalController;
  final TextEditingController departmentController;
  final TextEditingController staffIdController;
  final TextEditingController passwordController;

  const StaffSignInForm({
    super.key,
    required this.hospitalController,
    required this.departmentController,
    required this.staffIdController,
    required this.passwordController,
  });

  @override
  State<StaffSignInForm> createState() => _StaffSignInFormState();
}

class _StaffSignInFormState extends State<StaffSignInForm> {
  bool _obscurePassword = true;
  int? _selectedHospitalId;
  String? _selectedDepartment;

  static const _departments = ['Cardiology OPD', 'Emergency Ward', 'Laboratory'];

  InputDecoration _input(String hint, {Widget? suffixIcon}) => InputDecoration(
    hintText: hint,
    suffixIcon: suffixIcon,
    filled: true,
    fillColor: const Color(0xFFF7F8FC),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: BorderSide.none,
    ),
  );

  void _handleStaffSignIn() {
    if (_selectedHospitalId == null || _selectedDepartment == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select your hospital and department first')),
      );
      return;
    }
    context.read<AuthBloc>().add(
      StaffSignInEvent(
        hospitalId: _selectedHospitalId!,
        department: _selectedDepartment!,
        staffId: widget.staffIdController.text.trim(),
        password: widget.passwordController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Staff Portal Access',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        const Text('Select your affiliated hospital, department and enter your staff credentials.'),
        const SizedBox(height: 18),
        const Text('Affiliated Hospital / Health Center'),
        const SizedBox(height: 6),
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
        const SizedBox(height: 14),
        const Text('Assigned Department / Unit'),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          decoration: _input('Select active department or ward...'),
          items: _departments.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: (value) => setState(() {
            _selectedDepartment = value;
            widget.departmentController.text = value ?? '';
          }),
        ),
        const SizedBox(height: 14),
        const Text('Staff Username / Employee ID'),
        const SizedBox(height: 6),
        TextField(
          controller: widget.staffIdController,
          decoration: _input('e.g. STF-8821 or priya.nair@apollohealth.org'),
        ),
        const SizedBox(height: 14),
        const Text('Password / Access PIN'),
        const SizedBox(height: 6),
        TextField(
          controller: widget.passwordController,
          obscureText: _obscurePassword,
          decoration: _input(
            'Enter your secure staff password',
            suffixIcon: IconButton(
              icon: Icon(_obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined),
              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
            ),
          ),
        ),
        const SizedBox(height: 18),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _handleStaffSignIn,
            icon: const Icon(Icons.arrow_forward),
            label: const Text('Sign In to Staff Workspace'),
          ),
        ),
      ],
    );
  }
}