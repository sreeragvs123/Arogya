import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/auth_layout.dart';
import '../widgets/form_section.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;
  bool _isLoading = false;

  // Step 1 — Hospital Info
  final _hospitalNameController = TextEditingController();
  final _registrationNoController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  String? _selectedHospitalType;

  // Step 2 — Address
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _pincodeController = TextEditingController();

  // Step 3 — Admin Account
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  final List<String> _hospitalTypes = [
    'Government',
    'Private',
    'Trust / NGO',
    'Clinic',
    'Multispecialty',
  ];

  @override
  void dispose() {
    _hospitalNameController.dispose();
    _registrationNoController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _pincodeController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submitRegistration() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    // TODO: call registration API
    Navigator.pushReplacementNamed(
      context,
      '/dashboard',
      arguments: {'hospitalName': _hospitalNameController.text},
    );
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      backgroundColor: AppColors.surfaceWhite,
      body: Row(
        children: [
          // Left panel (wide only)
          if (isWide)
            Container(
              width: 340,
              color: AppColors.primaryGreen,
              padding: const EdgeInsets.all(40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pushReplacementNamed(context, '/'),
                    child: Row(
                      children: [
                        const Icon(Icons.local_hospital_rounded,
                            color: AppColors.white, size: 28),
                        const SizedBox(width: 10),
                        Text('Arogya',
                            style: GoogleFonts.playfairDisplay(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: AppColors.white)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 48),
                  Text('Register your\nhospital today.',
                      style: GoogleFonts.playfairDisplay(
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          color: AppColors.white,
                          height: 1.2)),
                  const SizedBox(height: 16),
                  Text(
                      'Join Arogya and bring smart hospital management to your staff and patients.',
                      style: GoogleFonts.dmSans(
                          fontSize: 14,
                          color: AppColors.lightGreen,
                          height: 1.7)),
                  const SizedBox(height: 48),
                  _StepIndicator(currentStep: _currentStep),
                ],
              ),
            ),
          // Right panel — form
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                  horizontal: isWide ? 60 : 24, vertical: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!isWide) ...[
                    GestureDetector(
                      onTap: () =>
                          Navigator.pushReplacementNamed(context, '/'),
                      child: Row(
                        children: [
                          const Icon(Icons.local_hospital_rounded,
                              color: AppColors.primaryGreen, size: 24),
                          const SizedBox(width: 8),
                          Text('Arogya',
                              style: GoogleFonts.playfairDisplay(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primaryGreen)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                    _StepIndicator(currentStep: _currentStep, horizontal: true),
                    const SizedBox(height: 28),
                  ],
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 560),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (_currentStep == 0) _buildStep1(),
                          if (_currentStep == 1) _buildStep2(),
                          if (_currentStep == 2) _buildStep3(),
                          const SizedBox(height: 32),
                          Row(
                            children: [
                              if (_currentStep > 0)
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () => setState(
                                        () => _currentStep--),
                                    child: const Text('Back'),
                                  ),
                                ),
                              if (_currentStep > 0)
                                const SizedBox(width: 16),
                              Expanded(
                                child: SizedBox(
                                  height: 50,
                                  child: ElevatedButton(
                                    onPressed: _isLoading
                                        ? null
                                        : _currentStep < 2
                                            ? () => setState(
                                                () => _currentStep++)
                                            : _submitRegistration,
                                    child: _isLoading
                                        ? const SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                color: AppColors.white),
                                          )
                                        : Text(_currentStep < 2
                                            ? 'Continue'
                                            : 'Register Hospital'),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Center(
                            child: TextButton(
                              onPressed: () =>
                                  Navigator.pushNamed(context, '/login'),
                              child: Text(
                                'Already registered? Sign in',
                                style: GoogleFonts.dmSans(
                                    color: AppColors.mediumGreen,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ],
                      ),
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

  Widget _buildStep1() {
    return FormSection(
      title: 'Hospital information',
      subtitle: 'Basic details about your hospital',
      children: [
        TextFormField(
          controller: _hospitalNameController,
          decoration: const InputDecoration(
            labelText: 'Hospital Name',
            prefixIcon: Icon(Icons.local_hospital_rounded,
                color: AppColors.mediumGreen, size: 20),
          ),
          validator: (v) =>
              v == null || v.isEmpty ? 'Required' : null,
        ),
        const SizedBox(height: 14),
        TextFormField(
          controller: _registrationNoController,
          decoration: const InputDecoration(
            labelText: 'Registration Number',
            prefixIcon: Icon(Icons.numbers_rounded,
                color: AppColors.mediumGreen, size: 20),
          ),
          validator: (v) =>
              v == null || v.isEmpty ? 'Required' : null,
        ),
        const SizedBox(height: 14),
        DropdownButtonFormField<String>(
          value: _selectedHospitalType,
          decoration: const InputDecoration(
            labelText: 'Hospital Type',
            prefixIcon: Icon(Icons.category_rounded,
                color: AppColors.mediumGreen, size: 20),
          ),
          items: _hospitalTypes
              .map((t) =>
                  DropdownMenuItem(value: t, child: Text(t)))
              .toList(),
          onChanged: (v) =>
              setState(() => _selectedHospitalType = v),
          validator: (v) => v == null ? 'Select type' : null,
        ),
        const SizedBox(height: 14),
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            labelText: 'Official Email',
            prefixIcon: Icon(Icons.email_outlined,
                color: AppColors.mediumGreen, size: 20),
          ),
          validator: (v) =>
              v == null || !v.contains('@') ? 'Enter valid email' : null,
        ),
        const SizedBox(height: 14),
        TextFormField(
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(
            labelText: 'Phone Number',
            prefixIcon: Icon(Icons.phone_outlined,
                color: AppColors.mediumGreen, size: 20),
          ),
          validator: (v) =>
              v == null || v.length < 10 ? 'Enter valid phone' : null,
        ),
      ],
    );
  }

  Widget _buildStep2() {
    return FormSection(
      title: 'Hospital address',
      subtitle: 'Where is your hospital located?',
      children: [
        TextFormField(
          controller: _addressController,
          maxLines: 2,
          decoration: const InputDecoration(
            labelText: 'Street Address',
            prefixIcon: Icon(Icons.location_on_outlined,
                color: AppColors.mediumGreen, size: 20),
          ),
          validator: (v) =>
              v == null || v.isEmpty ? 'Required' : null,
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _cityController,
                decoration: const InputDecoration(labelText: 'City'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Required' : null,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: TextFormField(
                controller: _stateController,
                decoration: const InputDecoration(labelText: 'State'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Required' : null,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        TextFormField(
          controller: _pincodeController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Pincode',
            prefixIcon: Icon(Icons.pin_drop_outlined,
                color: AppColors.mediumGreen, size: 20),
          ),
          validator: (v) =>
              v == null || v.length < 6 ? 'Enter valid pincode' : null,
        ),
      ],
    );
  }

  Widget _buildStep3() {
    return FormSection(
      title: 'Admin account',
      subtitle: 'Create credentials to access your dashboard',
      children: [
        TextFormField(
          controller: _usernameController,
          decoration: const InputDecoration(
            labelText: 'Username',
            prefixIcon: Icon(Icons.manage_accounts_outlined,
                color: AppColors.mediumGreen, size: 20),
            helperText: 'Will be used to log in to the dashboard',
          ),
          validator: (v) =>
              v == null || v.length < 4 ? 'Min 4 characters' : null,
        ),
        const SizedBox(height: 14),
        TextFormField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          decoration: InputDecoration(
            labelText: 'Password',
            prefixIcon: const Icon(Icons.lock_outline_rounded,
                color: AppColors.mediumGreen, size: 20),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: AppColors.mutedText,
                size: 20,
              ),
              onPressed: () =>
                  setState(() => _obscurePassword = !_obscurePassword),
            ),
          ),
          validator: (v) =>
              v == null || v.length < 8 ? 'Min 8 characters' : null,
        ),
        const SizedBox(height: 14),
        TextFormField(
          controller: _confirmPasswordController,
          obscureText: _obscureConfirm,
          decoration: InputDecoration(
            labelText: 'Confirm Password',
            prefixIcon: const Icon(Icons.lock_outline_rounded,
                color: AppColors.mediumGreen, size: 20),
            suffixIcon: IconButton(
              icon: Icon(
                _obscureConfirm
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: AppColors.mutedText,
                size: 20,
              ),
              onPressed: () =>
                  setState(() => _obscureConfirm = !_obscureConfirm),
            ),
          ),
          validator: (v) => v != _passwordController.text
              ? 'Passwords do not match'
              : null,
        ),
      ],
    );
  }
}

class _StepIndicator extends StatelessWidget {
  final int currentStep;
  final bool horizontal;

  const _StepIndicator({required this.currentStep, this.horizontal = false});

  @override
  Widget build(BuildContext context) {
    final steps = ['Hospital Info', 'Address', 'Admin Account'];
    if (horizontal) {
      return Row(
        children: List.generate(steps.length, (i) {
          final done = i < currentStep;
          final active = i == currentStep;
          return Expanded(
            child: Row(
              children: [
                _Dot(done: done, active: active, label: steps[i]),
                if (i < steps.length - 1)
                  Expanded(
                    child: Container(
                      height: 2,
                      color: done
                          ? AppColors.primaryGreen
                          : AppColors.borderColor,
                    ),
                  ),
              ],
            ),
          );
        }),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(steps.length, (i) {
        final done = i < currentStep;
        final active = i == currentStep;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: done || active
                      ? AppColors.white
                      : AppColors.white.withOpacity(0.2),
                ),
                child: Icon(
                  done ? Icons.check_rounded : Icons.circle,
                  size: done ? 16 : 8,
                  color: done || active
                      ? AppColors.primaryGreen
                      : AppColors.white.withOpacity(0.4),
                ),
              ),
              const SizedBox(width: 12),
              Text(steps[i],
                  style: GoogleFonts.dmSans(
                      fontSize: 14,
                      fontWeight: active
                          ? FontWeight.w600
                          : FontWeight.w400,
                      color: active || done
                          ? AppColors.white
                          : AppColors.white.withOpacity(0.5))),
            ],
          ),
        );
      }),
    );
  }
}

class _Dot extends StatelessWidget {
  final bool done;
  final bool active;
  final String label;
  const _Dot({required this.done, required this.active, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: done || active
                ? AppColors.primaryGreen
                : AppColors.borderColor,
          ),
          child: Icon(
            done ? Icons.check_rounded : Icons.circle,
            size: done ? 14 : 6,
            color: AppColors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(label,
            style: GoogleFonts.dmSans(
                fontSize: 10,
                color: active
                    ? AppColors.primaryGreen
                    : AppColors.mutedText)),
      ],
    );
  }
}