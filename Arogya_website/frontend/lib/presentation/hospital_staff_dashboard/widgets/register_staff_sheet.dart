import 'package:flutter/material.dart';
import 'package:frontend/domain/entities/hospital_staff/staff_entities.dart';
import 'package:frontend/domain/entities/hospital_staff/staff_enums.dart';

class RegisterStaffSheet extends StatefulWidget {
  final int hospitalId;
  /// Returns an error message, or null on success.
  final Future<String?> Function(CreateStaffParams) onSubmit;
  final VoidCallback onClose;

  const RegisterStaffSheet({
    super.key,
    required this.hospitalId,
    required this.onSubmit,
    required this.onClose,
  });

  @override
  State<RegisterStaffSheet> createState() => _RegisterStaffSheetState();
}

class _RegisterStaffSheetState extends State<RegisterStaffSheet> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _empId = TextEditingController();
  final _phone = TextEditingController();
  final _address = TextEditingController();
  final _pin = TextEditingController();
  Sex? _sex;
  Department? _dept;
  DateTime? _dob;
  bool _submitting = false;
  String? _error;

  @override
  void dispose() {
    for (final c in [_name, _email, _empId, _phone, _address, _pin]) {
      c.dispose();
    }
    super.dispose();
  }

  String? _required(String? v) => (v == null || v.trim().isEmpty) ? 'Required' : null;

  Future<void> _pickDob() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _dob ?? DateTime(1995),
      firstDate: DateTime(1950),
      lastDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
    );
    if (d != null) setState(() => _dob = d);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _dob == null) {
      setState(() => _error = _dob == null ? 'Select a date of birth' : null);
      return;
    }
    setState(() {
      _submitting = true;
      _error = null;
    });
    final err = await widget.onSubmit(CreateStaffParams(
      hospitalId: widget.hospitalId,
      fullName: _name.text.trim(),
      email: _email.text.trim(),
      employeeId: _empId.text.trim(),
      phoneNumber: _phone.text.trim(),
      address: _address.text.trim(),
      sex: _sex!,
      dateOfBirth: _dob!,
      department: _dept!,
      temporaryPin: _pin.text.trim(),
    ));
    if (!mounted) return;
    setState(() {
      _submitting = false;
      _error = err;
    });
  }

  InputDecoration _dec(String label) => InputDecoration(
        labelText: label,
        isDense: true,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 12, 12),
            child: Row(children: [
              const Expanded(
                child: Text('Register Staff',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF0F172A))),
              ),
              IconButton(onPressed: widget.onClose, icon: const Icon(Icons.close_rounded)),
            ]),
          ),
          const Divider(height: 1),
          Expanded(
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  TextFormField(controller: _name, decoration: _dec('Full name'), validator: _required),
                  const SizedBox(height: 14),
                  Row(children: [
                    Expanded(
                        child: TextFormField(
                            controller: _empId,
                            decoration: _dec('Employee ID (login username)'),
                            validator: _required)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<Department>(
                        value: _dept,
                        isExpanded: true,
                        decoration: _dec('Department'),
                        items: Department.values
                            .map((d) => DropdownMenuItem(value: d, child: Text(prettyEnum(d))))
                            .toList(),
                        onChanged: (v) => setState(() => _dept = v),
                        validator: (v) => v == null ? 'Required' : null,
                      ),
                    ),
                  ]),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _email,
                    decoration: _dec('Email'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) => (v == null || !v.contains('@')) ? 'Enter a valid email' : null,
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                      controller: _phone,
                      decoration: _dec('Phone number'),
                      keyboardType: TextInputType.phone,
                      validator: _required),
                  const SizedBox(height: 14),
                  TextFormField(controller: _address, decoration: _dec('Address'), maxLines: 2, validator: _required),
                  const SizedBox(height: 14),
                  Row(children: [
                    Expanded(
                      child: DropdownButtonFormField<Sex>(
                        value: _sex,
                        decoration: _dec('Sex'),
                        items: Sex.values
                            .map((s) => DropdownMenuItem(value: s, child: Text(prettyEnum(s))))
                            .toList(),
                        onChanged: (v) => setState(() => _sex = v),
                        validator: (v) => v == null ? 'Required' : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: InkWell(
                        onTap: _pickDob,
                        child: InputDecorator(
                          decoration: _dec('Date of birth'),
                          child: Text(_dob == null
                              ? 'Select date'
                              : _dob!.toIso8601String().split('T').first),
                        ),
                      ),
                    ),
                  ]),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _pin,
                    decoration: _dec('Temporary PIN'),
                    obscureText: true,
                    keyboardType: TextInputType.number,
                    validator: (v) => (v == null || v.trim().length < 4) ? 'Min 4 digits' : null,
                  ),
                  if (_error != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Text(_error!, style: const TextStyle(color: Colors.red, fontSize: 12)),
                    ),
                ],
              ),
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitting ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F766E),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: _submitting
                    ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Text('Register Staff'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}