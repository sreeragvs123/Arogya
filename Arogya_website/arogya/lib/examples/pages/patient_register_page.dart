import 'package:arogya/examples/widgets/shared_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/sidebar.dart';
import '../widgets/form_section.dart';

class PatientRegisterPage extends StatefulWidget {
  const PatientRegisterPage({super.key});

  @override
  State<PatientRegisterPage> createState() => _PatientRegisterPageState();
}

class _PatientRegisterPageState extends State<PatientRegisterPage> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;
  bool _isLoading = false;

  // Step 1 — Personal Info
  final _nameCtrl = TextEditingController();
  final _dobCtrl = TextEditingController();
  final _ageCtrl = TextEditingController();
  String? _selectedGender;
  final _aadharCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  String? _selectedBloodGroup;

  // Step 2 — Photo & Address
  final _addressCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  bool _photoUploaded = false;

  // Step 3 — Department & Doctor
  String? _selectedDept;
  String? _selectedDoctor;

  final List<String> _genders = ['Male', 'Female', 'Other'];
  final List<String> _bloodGroups = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];
  final List<String> _departments = ['Cardiology', 'Neurology', 'Orthopaedics', 'Paediatrics', 'General Medicine', 'Dermatology'];
  final Map<String, List<String>> _doctorsByDept = {
    'Cardiology': ['Dr. Ramesh Iyer', 'Dr. Latha Suresh'],
    'Neurology': ['Dr. Priya Nair', 'Dr. Arun Menon'],
    'Orthopaedics': ['Dr. Suresh Pillai'],
    'Paediatrics': ['Dr. Anitha Nair', 'Dr. Vinod Pillai'],
    'General Medicine': ['Dr. Rekha Kumar', 'Dr. Anil Das'],
    'Dermatology': ['Dr. Meena Varma'],
  };

  @override
  void dispose() {
    _nameCtrl.dispose(); _dobCtrl.dispose(); _ageCtrl.dispose();
    _aadharCtrl.dispose(); _phoneCtrl.dispose();
    _addressCtrl.dispose(); _cityCtrl.dispose();
    super.dispose();
  }

  Future<void> _submitRegistration() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;

    // Generate patient ID and navigate to QR card
    final patientId = 'AY${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
    Navigator.pushNamed(context, '/qr-card', arguments: {
      'patientId': patientId,
      'name': _nameCtrl.text,
      'dob': _dobCtrl.text,
      'age': _ageCtrl.text,
      'gender': _selectedGender,
      'aadhar': _aadharCtrl.text,
      'phone': _phoneCtrl.text,
      'bloodGroup': _selectedBloodGroup,
      'address': _addressCtrl.text,
      'city': _cityCtrl.text,
      'department': _selectedDept,
      'doctor': _selectedDoctor,
      'registrationDate': _formattedToday(),
      'username': patientId,
      'password': _dobCtrl.text.replaceAll('/', ''),
    });
    setState(() => _isLoading = false);
  }

  String _formattedToday() {
    final now = DateTime.now();
    const m = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return '${now.day.toString().padLeft(2,'0')} ${m[now.month-1]} ${now.year}';
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 900;
    return Scaffold(
      backgroundColor: AppColors.surfaceWhite,
      drawer: isWide ? null : const AppSidebar(),
      body: Row(
        children: [
          if (isWide) const AppSidebar(),
          Expanded(
            child: Column(
              children: [
                PageHeader(isWide: isWide, title: 'Register New Patient', subtitle: 'Create patient record and generate QR card'),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 720),
                        child: Column(
                          children: [
                            // Step indicator
                            _StepBar(currentStep: _currentStep),
                            const SizedBox(height: 28),
                            // Form card
                            Container(
                              padding: const EdgeInsets.all(28),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: AppColors.borderColor),
                              ),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    if (_currentStep == 0) _buildStep1(),
                                    if (_currentStep == 1) _buildStep2(),
                                    if (_currentStep == 2) _buildStep3(),
                                    const SizedBox(height: 28),
                                    Row(children: [
                                      if (_currentStep > 0) ...[
                                        Expanded(child: OutlinedButton(onPressed: () => setState(() => _currentStep--), child: const Text('Back'))),
                                        const SizedBox(width: 16),
                                      ],
                                      Expanded(
                                        child: SizedBox(
                                          height: 50,
                                          child: ElevatedButton(
                                            onPressed: _isLoading ? null : (_currentStep < 2 ? () => setState(() => _currentStep++) : _submitRegistration),
                                            child: _isLoading
                                                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.white))
                                                : Text(_currentStep < 2 ? 'Continue' : 'Register & Generate QR Card',
                                                    style: GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w600)),
                                          ),
                                        ),
                                      ),
                                    ]),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
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

  Widget _buildStep1() {
    return FormSection(
      title: 'Personal information',
      subtitle: 'Basic details of the patient',
      children: [
        Row(children: [
          Expanded(child: TextFormField(
            controller: _nameCtrl,
            decoration: const InputDecoration(labelText: 'Full Name', prefixIcon: Icon(Icons.person_rounded, color: AppColors.mediumGreen, size: 20)),
            validator: (v) => v == null || v.isEmpty ? 'Required' : null,
          )),
          const SizedBox(width: 14),
          Expanded(child: TextFormField(
            controller: _phoneCtrl,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(labelText: 'Phone Number', prefixIcon: Icon(Icons.phone_outlined, color: AppColors.mediumGreen, size: 20)),
            validator: (v) => v == null || v.length < 10 ? 'Enter valid phone' : null,
          )),
        ]),
        const SizedBox(height: 14),
        Row(children: [
          Expanded(child: TextFormField(
            controller: _dobCtrl,
            decoration: const InputDecoration(labelText: 'Date of Birth (DD/MM/YYYY)', prefixIcon: Icon(Icons.calendar_today_rounded, color: AppColors.mediumGreen, size: 18)),
            validator: (v) => v == null || v.isEmpty ? 'Required' : null,
          )),
          const SizedBox(width: 14),
          Expanded(child: TextFormField(
            controller: _ageCtrl,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Age', prefixIcon: Icon(Icons.numbers_rounded, color: AppColors.mediumGreen, size: 18)),
            validator: (v) => v == null || v.isEmpty ? 'Required' : null,
          )),
        ]),
        const SizedBox(height: 14),
        Row(children: [
          Expanded(child: DropdownButtonFormField<String>(
            value: _selectedGender,
            decoration: const InputDecoration(labelText: 'Gender'),
            items: _genders.map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
            onChanged: (v) => setState(() => _selectedGender = v),
            validator: (v) => v == null ? 'Select gender' : null,
          )),
          const SizedBox(width: 14),
          Expanded(child: DropdownButtonFormField<String>(
            value: _selectedBloodGroup,
            decoration: const InputDecoration(labelText: 'Blood Group'),
            items: _bloodGroups.map((b) => DropdownMenuItem(value: b, child: Text(b))).toList(),
            onChanged: (v) => setState(() => _selectedBloodGroup = v),
            validator: (v) => v == null ? 'Select blood group' : null,
          )),
        ]),
        const SizedBox(height: 14),
        TextFormField(
          controller: _aadharCtrl,
          keyboardType: TextInputType.number,
          maxLength: 12,
          decoration: const InputDecoration(
            labelText: 'Aadhaar Card Number',
            prefixIcon: Icon(Icons.credit_card_rounded, color: AppColors.mediumGreen, size: 20),
            counterText: '',
          ),
          validator: (v) => v == null || v.length != 12 ? 'Enter valid 12-digit Aadhaar' : null,
        ),
      ],
    );
  }

  Widget _buildStep2() {
    return FormSection(
      title: 'Photo & address',
      subtitle: 'Patient photo and residential details',
      children: [
        // Photo upload
        GestureDetector(
          onTap: () => setState(() => _photoUploaded = true),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 28),
            decoration: BoxDecoration(
              color: _photoUploaded ? AppColors.lightGreen.withOpacity(0.2) : AppColors.surfaceWhite,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _photoUploaded ? AppColors.primaryGreen : AppColors.borderColor,
                style: BorderStyle.solid,
              ),
            ),
            child: Column(children: [
              Icon(_photoUploaded ? Icons.check_circle_rounded : Icons.add_a_photo_rounded,
                  color: _photoUploaded ? AppColors.primaryGreen : AppColors.mutedText, size: 36),
              const SizedBox(height: 8),
              Text(_photoUploaded ? 'Photo uploaded' : 'Click to upload patient photo',
                  style: GoogleFonts.dmSans(fontSize: 13, color: _photoUploaded ? AppColors.primaryGreen : AppColors.mutedText, fontWeight: FontWeight.w500)),
              if (!_photoUploaded)
                Text('JPG, PNG up to 5MB', style: GoogleFonts.dmSans(fontSize: 11, color: AppColors.mutedText)),
            ]),
          ),
        ),
        const SizedBox(height: 14),
        TextFormField(
          controller: _addressCtrl,
          maxLines: 2,
          decoration: const InputDecoration(
            labelText: 'Street Address',
            prefixIcon: Icon(Icons.location_on_outlined, color: AppColors.mediumGreen, size: 20),
          ),
          validator: (v) => v == null || v.isEmpty ? 'Required' : null,
        ),
        const SizedBox(height: 14),
        TextFormField(
          controller: _cityCtrl,
          decoration: const InputDecoration(labelText: 'City', prefixIcon: Icon(Icons.location_city_rounded, color: AppColors.mediumGreen, size: 20)),
          validator: (v) => v == null || v.isEmpty ? 'Required' : null,
        ),
      ],
    );
  }

  Widget _buildStep3() {
    return FormSection(
      title: 'Department & doctor',
      subtitle: 'Assign the patient to a department and doctor',
      children: [
        DropdownButtonFormField<String>(
          value: _selectedDept,
          decoration: const InputDecoration(labelText: 'Department', prefixIcon: Icon(Icons.account_tree_rounded, color: AppColors.mediumGreen, size: 20)),
          items: _departments.map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
          onChanged: (v) => setState(() { _selectedDept = v; _selectedDoctor = null; }),
          validator: (v) => v == null ? 'Select department' : null,
        ),
        const SizedBox(height: 14),
        DropdownButtonFormField<String>(
          value: _selectedDoctor,
          decoration: const InputDecoration(labelText: 'Assign Doctor', prefixIcon: Icon(Icons.medical_services_rounded, color: AppColors.mediumGreen, size: 20)),
          items: (_selectedDept != null ? (_doctorsByDept[_selectedDept] ?? []) : [])
              .map((d) => DropdownMenuItem<String>(value: d, child: Text(d))).toList(),
          onChanged: (v) => setState(() => _selectedDoctor = v),
          validator: (v) => v == null ? 'Select doctor' : null,
          hint: Text(_selectedDept == null ? 'Select department first' : 'Select doctor',
              style: GoogleFonts.dmSans(color: AppColors.mutedText, fontSize: 14)),
        ),
        const SizedBox(height: 20),
        // Summary preview
        if (_nameCtrl.text.isNotEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceWhite,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.borderColor),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Registration summary', style: GoogleFonts.dmSans(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primaryGreen)),
              const SizedBox(height: 12),
              _SummaryRow(label: 'Name', value: _nameCtrl.text),
              _SummaryRow(label: 'Date of Birth', value: _dobCtrl.text),
              _SummaryRow(label: 'Aadhaar', value: _aadharCtrl.text.isNotEmpty ? '••••••••${_aadharCtrl.text.substring(_aadharCtrl.text.length > 4 ? _aadharCtrl.text.length - 4 : 0)}' : '—'),
              _SummaryRow(label: 'Department', value: _selectedDept ?? '—'),
              _SummaryRow(label: 'Doctor', value: _selectedDoctor ?? '—'),
              const Divider(height: 20),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: AppColors.lightGreen.withOpacity(0.25), borderRadius: BorderRadius.circular(8)),
                child: Row(children: [
                  const Icon(Icons.info_outline_rounded, color: AppColors.primaryGreen, size: 16),
                  const SizedBox(width: 8),
                  Expanded(child: Text('A QR card and login credentials will be generated after registration.', style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.primaryGreen))),
                ]),
              ),
            ]),
          ),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  const _SummaryRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(children: [
        SizedBox(width: 110, child: Text(label, style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.mutedText))),
        Expanded(child: Text(value, style: GoogleFonts.dmSans(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.darkText))),
      ]),
    );
  }
}

class _StepBar extends StatelessWidget {
  final int currentStep;
  const _StepBar({required this.currentStep});

  @override
  Widget build(BuildContext context) {
    final steps = ['Personal Info', 'Photo & Address', 'Department'];
    return Row(
      children: List.generate(steps.length, (i) {
        final done = i < currentStep;
        final active = i == currentStep;
        return Expanded(
          child: Row(children: [
            Column(children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 32, height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: done || active ? AppColors.primaryGreen : AppColors.borderColor,
                ),
                child: Icon(done ? Icons.check_rounded : Icons.circle, size: done ? 16 : 8, color: AppColors.white),
              ),
              const SizedBox(height: 4),
              Text(steps[i], style: GoogleFonts.dmSans(fontSize: 11, color: active ? AppColors.primaryGreen : AppColors.mutedText, fontWeight: active ? FontWeight.w600 : FontWeight.w400)),
            ]),
            if (i < steps.length - 1)
              Expanded(child: Container(height: 2, margin: const EdgeInsets.only(bottom: 18), color: done ? AppColors.primaryGreen : AppColors.borderColor)),
          ]),
        );
      }),
    );
  }
}