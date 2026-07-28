import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class HospitalRegistrationApp extends StatelessWidget {
  const HospitalRegistrationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hospital Registration',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0A6EBD),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFF5F8FC),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFDDE3ED)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFDDE3ED)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF0A6EBD), width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE53935)),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          labelStyle: const TextStyle(color: Color(0xFF6B7A99)),
        ),
      ),
      home: const HospitalRegistrationScreen(),
    );
  }
}

class HospitalRegistrationScreen extends StatefulWidget {
  const HospitalRegistrationScreen({super.key});

  @override
  State<HospitalRegistrationScreen> createState() =>
      _HospitalRegistrationScreenState();
}

class _HospitalRegistrationScreenState
    extends State<HospitalRegistrationScreen> {
  final _pageController = PageController();
  int _currentPage = 0;
  final int _totalPages = 4;

  // ── Form Keys ──
  final _basicFormKey = GlobalKey<FormState>();
  final _locationFormKey = GlobalKey<FormState>();
  final _contactFormKey = GlobalKey<FormState>();
  final _accountFormKey = GlobalKey<FormState>();

  // ── Basic Info ──
  final _hospitalNameController = TextEditingController();
  String? _selectedHospitalType;
  final _registrationNumberController = TextEditingController();
  final _yearEstablishedController = TextEditingController();

  // ── Location ──
  final _address1Controller = TextEditingController();
  final _address2Controller = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _pinCodeController = TextEditingController();

  // ── Contact ──
  final _primaryPhoneController = TextEditingController();
  final _emergencyPhoneController = TextEditingController();
  final _officialEmailController = TextEditingController();
  final _websiteController = TextEditingController();

  // ── Account & Admin ──
  final _adminNameController = TextEditingController();
  final _adminDesignationController = TextEditingController();
  final _adminPhoneController = TextEditingController();
  final _adminEmailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreedToTerms = false;

  final List<String> _hospitalTypes = [
    'Government Hospital',
    'Private Hospital',
    'Trust / Charitable Hospital',
    'Clinic',
    'Specialty Center',
    'Multi-Specialty Hospital',
    'Nursing Home',
  ];

  final List<String> _pageLabels = [
    'Basic Info',
    'Location',
    'Contact',
    'Account',
  ];

  final List<IconData> _pageIcons = [
    Icons.local_hospital_rounded,
    Icons.location_on_rounded,
    Icons.contact_phone_rounded,
    Icons.manage_accounts_rounded,
  ];

  @override
  void dispose() {
    _pageController.dispose();
    _hospitalNameController.dispose();
    _registrationNumberController.dispose();
    _yearEstablishedController.dispose();
    _address1Controller.dispose();
    _address2Controller.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _pinCodeController.dispose();
    _primaryPhoneController.dispose();
    _emergencyPhoneController.dispose();
    _officialEmailController.dispose();
    _websiteController.dispose();
    _adminNameController.dispose();
    _adminDesignationController.dispose();
    _adminPhoneController.dispose();
    _adminEmailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _nextPage() {
    bool isValid = false;
    switch (_currentPage) {
      case 0:
        isValid = _basicFormKey.currentState?.validate() ?? false;
        break;
      case 1:
        isValid = _locationFormKey.currentState?.validate() ?? false;
        break;
      case 2:
        isValid = _contactFormKey.currentState?.validate() ?? false;
        break;
      case 3:
        isValid = _accountFormKey.currentState?.validate() ?? false;
        break;
    }

    if (isValid) {
      if (_currentPage < _totalPages - 1) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeInOut,
        );
        setState(() => _currentPage++);
      } else {
        _submitForm();
      }
    }
  }

  void _prevPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
      setState(() => _currentPage--);
    }
  }

  void _submitForm() {
    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please agree to the Terms & Conditions to proceed.'),
          backgroundColor: Color(0xFFE53935),
        ),
      );
      return;
    }
    // TODO: Send data to backend
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Color(0xFF2E7D32), size: 28),
            SizedBox(width: 8),
            Text('Registration Submitted'),
          ],
        ),
        content: const Text(
          'Your hospital registration is under review. You will receive a confirmation on your registered email once approved.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FA),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildStepIndicator(),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildBasicInfoPage(),
                  _buildLocationPage(),
                  _buildContactPage(),
                  _buildAccountPage(),
                ],
              ),
            ),
            _buildNavigationButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0A6EBD), Color(0xFF1488CC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.local_hospital_rounded,
                    color: Colors.white, size: 24),
              ),
              const SizedBox(width: 12),
              const Text(
                'MediConnect',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Hospital Registration',
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Complete all steps to register your hospital',
            style: TextStyle(
              color: Colors.white.withOpacity(0.85),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Row(
        children: List.generate(_totalPages, (index) {
          final isCompleted = index < _currentPage;
          final isActive = index == _currentPage;
          return Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: isCompleted
                              ? const Color(0xFF2E7D32)
                              : isActive
                                  ? const Color(0xFF0A6EBD)
                                  : const Color(0xFFE8EEF7),
                          shape: BoxShape.circle,
                          boxShadow: isActive
                              ? [
                                  BoxShadow(
                                    color: const Color(0xFF0A6EBD)
                                        .withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  )
                                ]
                              : null,
                        ),
                        child: Icon(
                          isCompleted
                              ? Icons.check_rounded
                              : _pageIcons[index],
                          color: (isCompleted || isActive)
                              ? Colors.white
                              : const Color(0xFF9BAABF),
                          size: 18,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _pageLabels[index],
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: isActive
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: isActive
                              ? const Color(0xFF0A6EBD)
                              : isCompleted
                                  ? const Color(0xFF2E7D32)
                                  : const Color(0xFF9BAABF),
                        ),
                      ),
                    ],
                  ),
                ),
                if (index < _totalPages - 1)
                  Expanded(
                    child: Container(
                      height: 2,
                      margin: const EdgeInsets.only(bottom: 20),
                      color: index < _currentPage
                          ? const Color(0xFF2E7D32)
                          : const Color(0xFFE8EEF7),
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildPageWrapper({required String title, required Widget child}) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A2340),
            ),
          ),
          const SizedBox(height: 4),
          Container(
            width: 36,
            height: 3,
            decoration: BoxDecoration(
              color: const Color(0xFF0A6EBD),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }

  Widget _buildBasicInfoPage() {
    return _buildPageWrapper(
      title: 'Basic Information',
      child: Form(
        key: _basicFormKey,
        child: Column(
          children: [
            _buildTextField(
              controller: _hospitalNameController,
              label: 'Hospital Name',
              icon: Icons.business_rounded,
              validator: (v) =>
                  v == null || v.isEmpty ? 'Hospital name is required' : null,
            ),
            const SizedBox(height: 16),
            _buildDropdownField(
              label: 'Hospital Type',
              icon: Icons.category_rounded,
              value: _selectedHospitalType,
              items: _hospitalTypes,
              onChanged: (val) =>
                  setState(() => _selectedHospitalType = val),
              validator: (v) =>
                  v == null ? 'Please select a hospital type' : null,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _registrationNumberController,
              label: 'Registration Number',
              icon: Icons.badge_rounded,
              hint: 'Official hospital registration number',
              validator: (v) => v == null || v.isEmpty
                  ? 'Registration number is required'
                  : null,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _yearEstablishedController,
              label: 'Year of Establishment',
              icon: Icons.calendar_today_rounded,
              hint: 'e.g. 2005',
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(4),
              ],
              validator: (v) {
                if (v == null || v.isEmpty) return 'Year is required';
                final year = int.tryParse(v);
                if (year == null || year < 1800 || year > DateTime.now().year) {
                  return 'Enter a valid year';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationPage() {
    return _buildPageWrapper(
      title: 'Location Details',
      child: Form(
        key: _locationFormKey,
        child: Column(
          children: [
            _buildTextField(
              controller: _address1Controller,
              label: 'Address Line 1',
              icon: Icons.location_on_rounded,
              validator: (v) =>
                  v == null || v.isEmpty ? 'Address is required' : null,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _address2Controller,
              label: 'Address Line 2 (Optional)',
              icon: Icons.add_location_alt_rounded,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: _cityController,
                    label: 'City',
                    icon: Icons.location_city_rounded,
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Required' : null,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTextField(
                    controller: _stateController,
                    label: 'State',
                    icon: Icons.map_rounded,
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Required' : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _pinCodeController,
              label: 'PIN Code',
              icon: Icons.pin_drop_rounded,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(6),
              ],
              validator: (v) {
                if (v == null || v.isEmpty) return 'PIN code is required';
                if (v.length != 6) return 'Enter a valid 6-digit PIN code';
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactPage() {
    return _buildPageWrapper(
      title: 'Contact Information',
      child: Form(
        key: _contactFormKey,
        child: Column(
          children: [
            _buildTextField(
              controller: _primaryPhoneController,
              label: 'Primary Phone Number',
              icon: Icons.phone_rounded,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
              validator: (v) {
                if (v == null || v.isEmpty) return 'Phone number is required';
                if (v.length != 10) return 'Enter a valid 10-digit number';
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _emergencyPhoneController,
              label: 'Emergency / Helpline Number (Optional)',
              icon: Icons.emergency_rounded,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _officialEmailController,
              label: 'Official Email Address',
              icon: Icons.email_rounded,
              keyboardType: TextInputType.emailAddress,
              hint: 'info@yourhospital.com',
              validator: (v) {
                if (v == null || v.isEmpty) return 'Email is required';
                final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                if (!emailRegex.hasMatch(v)) return 'Enter a valid email';
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _websiteController,
              label: 'Website URL (Optional)',
              icon: Icons.language_rounded,
              keyboardType: TextInputType.url,
              hint: 'https://yourhospital.com',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountPage() {
    return _buildPageWrapper(
      title: 'Account & Admin Setup',
      child: Form(
        key: _accountFormKey,
        child: Column(
          children: [
            _buildInfoBanner(
              'The admin will manage doctors and patient data on behalf of the hospital.',
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _adminNameController,
              label: 'Admin / Representative Name',
              icon: Icons.person_rounded,
              validator: (v) =>
                  v == null || v.isEmpty ? 'Admin name is required' : null,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _adminDesignationController,
              label: 'Designation',
              icon: Icons.work_rounded,
              hint: 'e.g. Hospital Manager, IT Head',
              validator: (v) =>
                  v == null || v.isEmpty ? 'Designation is required' : null,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _adminPhoneController,
              label: "Admin's Phone Number",
              icon: Icons.phone_android_rounded,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
              validator: (v) {
                if (v == null || v.isEmpty) return 'Phone number is required';
                if (v.length != 10) return 'Enter a valid 10-digit number';
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _adminEmailController,
              label: 'Login Email (Admin)',
              icon: Icons.alternate_email_rounded,
              keyboardType: TextInputType.emailAddress,
              hint: 'Used to log in to the portal',
              validator: (v) {
                if (v == null || v.isEmpty) return 'Login email is required';
                final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                if (!emailRegex.hasMatch(v)) return 'Enter a valid email';
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildPasswordField(
              controller: _passwordController,
              label: 'Password',
              obscure: _obscurePassword,
              onToggle: () =>
                  setState(() => _obscurePassword = !_obscurePassword),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Password is required';
                if (v.length < 8) return 'Minimum 8 characters required';
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildPasswordField(
              controller: _confirmPasswordController,
              label: 'Confirm Password',
              obscure: _obscureConfirmPassword,
              onToggle: () => setState(
                  () => _obscureConfirmPassword = !_obscureConfirmPassword),
              validator: (v) {
                if (v == null || v.isEmpty)
                  return 'Please confirm your password';
                if (v != _passwordController.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            _buildTermsCheckbox(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? hint,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, size: 20, color: const Color(0xFF6B7A99)),
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required IconData icon,
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
    String? Function(String?)? validator,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      validator: validator,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20, color: const Color(0xFF6B7A99)),
      ),
      borderRadius: BorderRadius.circular(12),
      items: items
          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool obscure,
    required VoidCallback onToggle,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon:
            const Icon(Icons.lock_rounded, size: 20, color: Color(0xFF6B7A99)),
        suffixIcon: IconButton(
          icon: Icon(
            obscure ? Icons.visibility_off_rounded : Icons.visibility_rounded,
            size: 20,
            color: const Color(0xFF6B7A99),
          ),
          onPressed: onToggle,
        ),
      ),
    );
  }

  Widget _buildInfoBanner(String message) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF90CAF9)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline_rounded,
              color: Color(0xFF1565C0), size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF1565C0),
                  height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTermsCheckbox() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(
          value: _agreedToTerms,
          onChanged: (val) => setState(() => _agreedToTerms = val ?? false),
          activeColor: const Color(0xFF0A6EBD),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: RichText(
              text: const TextSpan(
                style: TextStyle(fontSize: 13, color: Color(0xFF4A5568)),
                children: [
                  TextSpan(text: 'I agree to the '),
                  TextSpan(
                    text: 'Terms & Conditions',
                    style: TextStyle(
                        color: Color(0xFF0A6EBD),
                        fontWeight: FontWeight.w600),
                  ),
                  TextSpan(text: ' and '),
                  TextSpan(
                    text: 'Privacy Policy',
                    style: TextStyle(
                        color: Color(0xFF0A6EBD),
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNavigationButtons() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 12,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          if (_currentPage > 0)
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _prevPage,
                icon: const Icon(Icons.arrow_back_rounded, size: 18),
                label: const Text('Back'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF0A6EBD),
                  side: const BorderSide(color: Color(0xFF0A6EBD)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          if (_currentPage > 0) const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: ElevatedButton.icon(
              onPressed: _nextPage,
              icon: Icon(
                _currentPage == _totalPages - 1
                    ? Icons.check_circle_rounded
                    : Icons.arrow_forward_rounded,
                size: 18,
              ),
              label: Text(
                _currentPage == _totalPages - 1 ? 'Submit' : 'Continue',
                style: const TextStyle(
                    fontWeight: FontWeight.w700, fontSize: 15),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0A6EBD),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}