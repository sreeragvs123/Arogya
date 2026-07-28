import 'package:arogya/examples/widgets/shared_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/sidebar.dart';

class CheckupReceiptPage extends StatefulWidget {
  final String patientId;
  const CheckupReceiptPage({super.key, required this.patientId});

  @override
  State<CheckupReceiptPage> createState() => _CheckupReceiptPageState();
}

class _CheckupReceiptPageState extends State<CheckupReceiptPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;
  bool _receiptGenerated = false;

  // Patient search
  final _patientIdCtrl = TextEditingController();
  Map<String, dynamic>? _selectedPatient;

  // Checkup fields
  final _diagnosisCtrl = TextEditingController();
  final _symptomsCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  final _followUpCtrl = TextEditingController();

  // Medications + files
  final List<Map<String, dynamic>> _medications = [];
  final List<String> _uploadedFiles = [];

  // Mock patient DB
  final Map<String, Map<String, dynamic>> _patientDB = {
    'AY001234': {'name': 'Ravi Kumar',   'age': 45, 'gender': 'Male',   'bloodGroup': 'O+', 'doctor': 'Dr. Ramesh Iyer',  'department': 'Cardiology'},
    'AY001235': {'name': 'Leela Sharma', 'age': 62, 'gender': 'Female', 'bloodGroup': 'A+', 'doctor': 'Dr. Ramesh Iyer',  'department': 'Cardiology'},
    'AY001236': {'name': 'Anil Pillai',  'age': 38, 'gender': 'Male',   'bloodGroup': 'B+', 'doctor': 'Dr. Latha Suresh', 'department': 'Cardiology'},
  };

  @override
  void initState() {
    super.initState();
    if (widget.patientId.isNotEmpty) {
      _patientIdCtrl.text = widget.patientId;
      WidgetsBinding.instance.addPostFrameCallback((_) => _lookupPatient());
    }
  }

  @override
  void dispose() {
    _patientIdCtrl.dispose();
    _diagnosisCtrl.dispose();
    _symptomsCtrl.dispose();
    _notesCtrl.dispose();
    _followUpCtrl.dispose();
    super.dispose();
  }

  void _lookupPatient() {
    final id = _patientIdCtrl.text.trim().toUpperCase();
    final found = _patientDB[id];
    setState(() => _selectedPatient = found != null ? {...found, 'id': id} : null);
    if (found == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Patient "$id" not found.', style: GoogleFonts.dmSans()),
        backgroundColor: AppColors.errorRed,
        behavior: SnackBarBehavior.floating,
      ));
    }
  }

  Future<void> _generateReceipt() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedPatient == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please select a patient first.'),
        backgroundColor: AppColors.errorRed,
        behavior: SnackBarBehavior.floating,
      ));
      return;
    }
    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() { _isSubmitting = false; _receiptGenerated = true; });
  }

  void _resetForm() {
    setState(() {
      _receiptGenerated = false;
      _selectedPatient = null;
      _medications.clear();
      _uploadedFiles.clear();
      _patientIdCtrl.clear();
      _diagnosisCtrl.clear();
      _symptomsCtrl.clear();
      _notesCtrl.clear();
      _followUpCtrl.clear();
    });
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
                PageHeader(
                  isWide: isWide,
                  title: 'Checkup Receipt',
                  subtitle: 'Record treatment and send prescription to patient',
                ),
                Expanded(
                  child: _receiptGenerated
                      ? _ReceiptPreview(
                          patient: _selectedPatient!,
                          diagnosis: _diagnosisCtrl.text,
                          symptoms: _symptomsCtrl.text,
                          notes: _notesCtrl.text,
                          followUp: _followUpCtrl.text,
                          medications: List.from(_medications),
                          files: List.from(_uploadedFiles),
                          onReset: _resetForm,
                        )
                      : SingleChildScrollView(
                          padding: const EdgeInsets.all(24),
                          child: Center(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 800),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    // Step 1 — Patient
                                    _SectionCard(
                                      title: 'Patient',
                                      icon: Icons.person_search_rounded,
                                      child: _PatientSearchArea(
                                        controller: _patientIdCtrl,
                                        patient: _selectedPatient,
                                        onSearch: _lookupPatient,
                                      ),
                                    ),
                                    const SizedBox(height: 20),

                                    if (_selectedPatient != null) ...[
                                      // Step 2 — Checkup details
                                      _SectionCard(
                                        title: 'Checkup Details',
                                        icon: Icons.medical_information_rounded,
                                        child: _CheckupDetailsArea(
                                          diagnosisCtrl: _diagnosisCtrl,
                                          symptomsCtrl: _symptomsCtrl,
                                          notesCtrl: _notesCtrl,
                                          followUpCtrl: _followUpCtrl,
                                        ),
                                      ),
                                      const SizedBox(height: 20),

                                      // Step 3 — Medications
                                      _SectionCard(
                                        title: 'Medications',
                                        icon: Icons.medication_rounded,
                                        trailing: TextButton.icon(
                                          onPressed: () => _showMedicationDialog(context),
                                          icon: const Icon(Icons.add_rounded, size: 16),
                                          label: const Text('Add Medicine'),
                                        ),
                                        child: _MedicationArea(
                                          medications: _medications,
                                          onRemove: (i) => setState(() => _medications.removeAt(i)),
                                        ),
                                      ),
                                      const SizedBox(height: 20),

                                      // Step 4 — File uploads
                                      _SectionCard(
                                        title: 'Scan Reports & Documents',
                                        icon: Icons.upload_file_rounded,
                                        child: _FileUploadArea(
                                          files: _uploadedFiles,
                                          onAdd: () => setState(() =>
                                              _uploadedFiles.add('Scan_Report_${_uploadedFiles.length + 1}.pdf')),
                                          onRemove: (i) => setState(() => _uploadedFiles.removeAt(i)),
                                        ),
                                      ),
                                      const SizedBox(height: 28),

                                      // Submit
                                      SizedBox(
                                        height: 52,
                                        child: ElevatedButton.icon(
                                          onPressed: _isSubmitting ? null : _generateReceipt,
                                          icon: _isSubmitting
                                              ? const SizedBox(width: 18, height: 18,
                                                  child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.white))
                                              : const Icon(Icons.send_rounded, size: 18),
                                          label: Text(
                                            _isSubmitting ? 'Generating...' : 'Generate & Send Receipt to Patient',
                                            style: GoogleFonts.dmSans(fontSize: 15, fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Center(
                                        child: Text(
                                          'Receipt will be sent to the patient\'s Arogya app with medication alarms.',
                                          style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.mutedText),
                                        ),
                                      ),
                                      const SizedBox(height: 24),
                                    ],
                                  ],
                                ),
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

  // ── Medication dialog ───────────────────────────────────────────────────────
  void _showMedicationDialog(BuildContext context) {
    final nameCtrl = TextEditingController();
    final dosageCtrl = TextEditingController();
    final durationCtrl = TextEditingController();
    String frequency = 'Once daily';
    final Set<String> timing = {};
    final formKey = GlobalKey<FormState>();

    final frequencies = ['Once daily', 'Twice daily', 'Thrice daily', 'Every 8 hours', 'Every 6 hours', 'As needed'];
    final timingOptions = ['Morning', 'Afternoon', 'Evening', 'Night'];

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text('Add Medication',
              style: GoogleFonts.playfairDisplay(fontSize: 20, fontWeight: FontWeight.w700)),
          content: SizedBox(
            width: 440,
            child: Form(
              key: formKey,
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                TextFormField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Medicine name',
                    prefixIcon: Icon(Icons.medication_rounded, color: AppColors.mediumGreen, size: 20),
                  ),
                  validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 12),
                Row(children: [
                  Expanded(child: TextFormField(
                    controller: dosageCtrl,
                    decoration: const InputDecoration(labelText: 'Dosage (e.g. 500mg)'),
                  )),
                  const SizedBox(width: 12),
                  Expanded(child: TextFormField(
                    controller: durationCtrl,
                    decoration: const InputDecoration(labelText: 'Duration (e.g. 5 days)'),
                  )),
                ]),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: frequency,
                  decoration: const InputDecoration(labelText: 'Frequency'),
                  items: frequencies.map((f) => DropdownMenuItem(value: f, child: Text(f))).toList(),
                  onChanged: (v) => setDState(() => frequency = v!),
                ),
                const SizedBox(height: 14),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('When to take',
                      style: GoogleFonts.dmSans(fontSize: 13, color: AppColors.mutedText)),
                ),
                const SizedBox(height: 8),
                Row(
                  children: timingOptions.map((t) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () => setDState(() =>
                          timing.contains(t) ? timing.remove(t) : timing.add(t)),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                        decoration: BoxDecoration(
                          color: timing.contains(t) ? AppColors.primaryGreen : AppColors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: timing.contains(t) ? AppColors.primaryGreen : AppColors.borderColor,
                          ),
                        ),
                        child: Text(t,
                            style: GoogleFonts.dmSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: timing.contains(t) ? AppColors.white : AppColors.darkText)),
                      ),
                    ),
                  )).toList(),
                ),
                if (timing.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Select at least one time',
                          style: GoogleFonts.dmSans(fontSize: 11, color: AppColors.errorRed)),
                    ),
                  ),
              ]),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate() && timing.isNotEmpty) {
                  setState(() => _medications.add({
                    'name': nameCtrl.text,
                    'dosage': dosageCtrl.text,
                    'frequency': frequency,
                    'duration': durationCtrl.text.isEmpty ? '7 days' : durationCtrl.text,
                    'timing': timing.toList(),
                  }));
                  Navigator.pop(ctx);
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Patient Search Area ───────────────────────────────────────────────────────
class _PatientSearchArea extends StatelessWidget {
  final TextEditingController controller;
  final Map<String, dynamic>? patient;
  final VoidCallback onSearch;
  const _PatientSearchArea({required this.controller, required this.patient, required this.onSearch});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Expanded(
          child: TextFormField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'Patient ID (e.g. AY001234)',
              prefixIcon: Icon(Icons.qr_code_rounded, color: AppColors.mediumGreen, size: 20),
            ),
            onFieldSubmitted: (_) => onSearch(),
          ),
        ),
        const SizedBox(width: 12),
        ElevatedButton.icon(
          onPressed: onSearch,
          icon: const Icon(Icons.search_rounded, size: 18),
          label: const Text('Find Patient'),
        ),
      ]),
      if (patient != null) ...[
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.lightGreen.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.primaryGreen.withOpacity(0.3)),
          ),
          child: Row(children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: AppColors.lightGreen.withOpacity(0.5),
              child: Text(
                patient!['name'].toString().split(' ').take(2).map((w) => (w as String)[0]).join(),
                style: GoogleFonts.playfairDisplay(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primaryGreen),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(patient!['name'],
                    style: GoogleFonts.dmSans(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.darkText)),
                Text('ID: ${patient!['id']}  •  ${patient!['age']} yrs  •  ${patient!['gender']}  •  ${patient!['bloodGroup']}',
                    style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.mutedText)),
                Text('${patient!['department']} — ${patient!['doctor']}',
                    style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.mediumGreen, fontWeight: FontWeight.w500)),
              ]),
            ),
            const Icon(Icons.check_circle_rounded, color: AppColors.successGreen, size: 22),
          ]),
        ),
      ],
    ]);
  }
}

// ── Checkup Details Area ──────────────────────────────────────────────────────
class _CheckupDetailsArea extends StatelessWidget {
  final TextEditingController diagnosisCtrl;
  final TextEditingController symptomsCtrl;
  final TextEditingController notesCtrl;
  final TextEditingController followUpCtrl;
  const _CheckupDetailsArea({
    required this.diagnosisCtrl,
    required this.symptomsCtrl,
    required this.notesCtrl,
    required this.followUpCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      TextFormField(
        controller: diagnosisCtrl,
        decoration: const InputDecoration(
          labelText: 'Diagnosis',
          prefixIcon: Icon(Icons.coronavirus_rounded, color: AppColors.mediumGreen, size: 20),
        ),
        validator: (v) => v == null || v.isEmpty ? 'Enter diagnosis' : null,
      ),
      const SizedBox(height: 14),
      TextFormField(
        controller: symptomsCtrl,
        maxLines: 2,
        decoration: const InputDecoration(
          labelText: 'Symptoms observed',
          prefixIcon: Icon(Icons.sick_rounded, color: AppColors.mediumGreen, size: 20),
        ),
      ),
      const SizedBox(height: 14),
      TextFormField(
        controller: notesCtrl,
        maxLines: 3,
        decoration: const InputDecoration(
          labelText: "Doctor's notes",
          prefixIcon: Icon(Icons.note_alt_rounded, color: AppColors.mediumGreen, size: 20),
        ),
      ),
      const SizedBox(height: 14),
      TextFormField(
        controller: followUpCtrl,
        decoration: const InputDecoration(
          labelText: 'Follow-up date (optional)',
          prefixIcon: Icon(Icons.event_rounded, color: AppColors.mediumGreen, size: 20),
        ),
      ),
    ]);
  }
}

// ── Medication Area ───────────────────────────────────────────────────────────
class _MedicationArea extends StatelessWidget {
  final List<Map<String, dynamic>> medications;
  final void Function(int) onRemove;
  const _MedicationArea({required this.medications, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    if (medications.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Text('No medications added yet.',
              style: GoogleFonts.dmSans(fontSize: 13, color: AppColors.mutedText)),
        ),
      );
    }
    return Column(children: [
      // Table header
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.lightGreen.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(children: [
          _MedColHeader(label: 'Medicine', flex: 3),
          _MedColHeader(label: 'Dosage', flex: 2),
          _MedColHeader(label: 'Frequency', flex: 2),
          _MedColHeader(label: 'Duration', flex: 2),
          _MedColHeader(label: 'Timing', flex: 3),
          const SizedBox(width: 30),
        ]),
      ),
      const SizedBox(height: 6),
      ...medications.asMap().entries.map((e) => _MedRow(
            med: e.value,
            onRemove: () => onRemove(e.key),
          )),
    ]);
  }
}

class _MedColHeader extends StatelessWidget {
  final String label;
  final int flex;
  const _MedColHeader({required this.label, required this.flex});

  @override
  Widget build(BuildContext context) => Expanded(
        flex: flex,
        child: Text(label,
            style: GoogleFonts.dmSans(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.primaryGreen)),
      );
}

class _MedRow extends StatelessWidget {
  final Map<String, dynamic> med;
  final VoidCallback onRemove;
  const _MedRow({required this.med, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Row(children: [
        Expanded(flex: 3, child: Text(med['name'],
            style: GoogleFonts.dmSans(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.darkText))),
        Expanded(flex: 2, child: Text(med['dosage'] ?? '—',
            style: GoogleFonts.dmSans(fontSize: 13, color: AppColors.mutedText))),
        Expanded(flex: 2, child: Text(med['frequency'],
            style: GoogleFonts.dmSans(fontSize: 13, color: AppColors.mutedText))),
        Expanded(flex: 2, child: Text(med['duration'],
            style: GoogleFonts.dmSans(fontSize: 13, color: AppColors.mutedText))),
        Expanded(
          flex: 3,
          child: Wrap(
            spacing: 4,
            children: (med['timing'] as List<dynamic>).map((t) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.lightGreen.withOpacity(0.3),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(t.toString(),
                  style: GoogleFonts.dmSans(fontSize: 10, color: AppColors.primaryGreen, fontWeight: FontWeight.w500)),
            )).toList(),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.close_rounded, size: 16, color: AppColors.mutedText),
          onPressed: onRemove,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
        ),
      ]),
    );
  }
}

// ── File Upload Area ──────────────────────────────────────────────────────────
class _FileUploadArea extends StatelessWidget {
  final List<String> files;
  final VoidCallback onAdd;
  final void Function(int) onRemove;
  const _FileUploadArea({required this.files, required this.onAdd, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      GestureDetector(
        onTap: onAdd,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 22),
          decoration: BoxDecoration(
            color: AppColors.surfaceWhite,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.borderColor),
          ),
          child: Column(children: [
            const Icon(Icons.cloud_upload_rounded, color: AppColors.mediumGreen, size: 32),
            const SizedBox(height: 6),
            Text('Click to upload PDF or image',
                style: GoogleFonts.dmSans(fontSize: 13, color: AppColors.mutedText)),
            Text('PDF, JPG, PNG up to 10MB each',
                style: GoogleFonts.dmSans(fontSize: 11, color: AppColors.borderColor)),
          ]),
        ),
      ),
      if (files.isNotEmpty) ...[
        const SizedBox(height: 12),
        ...files.asMap().entries.map((e) => Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.borderColor),
          ),
          child: Row(children: [
            const Icon(Icons.picture_as_pdf_rounded, color: AppColors.errorRed, size: 18),
            const SizedBox(width: 10),
            Expanded(child: Text(e.value, style: GoogleFonts.dmSans(fontSize: 13))),
            Text('Ready', style: GoogleFonts.dmSans(fontSize: 11, color: AppColors.successGreen, fontWeight: FontWeight.w500)),
            IconButton(
              icon: const Icon(Icons.close_rounded, size: 15, color: AppColors.mutedText),
              onPressed: () => onRemove(e.key),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 26, minHeight: 26),
            ),
          ]),
        )),
      ],
    ]);
  }
}

// ── Receipt Preview ───────────────────────────────────────────────────────────
class _ReceiptPreview extends StatelessWidget {
  final Map<String, dynamic> patient;
  final String diagnosis;
  final String symptoms;
  final String notes;
  final String followUp;
  final List<Map<String, dynamic>> medications;
  final List<String> files;
  final VoidCallback onReset;

  const _ReceiptPreview({
    required this.patient,
    required this.diagnosis,
    required this.symptoms,
    required this.notes,
    required this.followUp,
    required this.medications,
    required this.files,
    required this.onReset,
  });

  String get _today {
    final now = DateTime.now();
    const m = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return '${now.day.toString().padLeft(2, '0')} ${m[now.month - 1]} ${now.year}';
  }

  String get _receiptNo =>
      'RCP${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            // Success banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.successGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.successGreen.withOpacity(0.3)),
              ),
              child: Row(children: [
                const Icon(Icons.check_circle_rounded, color: AppColors.successGreen, size: 22),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Receipt generated & sent!',
                      style: GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.successGreen)),
                  Text('Medication alarms have been set up in the patient\'s Arogya app.',
                      style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.mutedText)),
                ])),
              ]),
            ),
            const SizedBox(height: 24),

            // Receipt card
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderColor),
                boxShadow: [BoxShadow(color: AppColors.cardShadow, blurRadius: 12, offset: const Offset(0, 4))],
              ),
              child: Column(children: [
                // Green header
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                  decoration: const BoxDecoration(
                    color: AppColors.primaryGreen,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Row(children: [
                    const Icon(Icons.local_hospital_rounded, color: AppColors.white, size: 22),
                    const SizedBox(width: 10),
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('Arogya Health Platform',
                          style: GoogleFonts.playfairDisplay(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.white)),
                      Text('Official Checkup Receipt',
                          style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.lightGreen)),
                    ]),
                    const Spacer(),
                    Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                      Text('Date: $_today',
                          style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.lightGreen)),
                      Text('Receipt #$_receiptNo',
                          style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.lightGreen)),
                    ]),
                  ]),
                ),

                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    // Patient strip
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceWhite,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.borderColor),
                      ),
                      child: Row(children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: AppColors.lightGreen.withOpacity(0.4),
                          child: Text(
                            patient['name'].toString().split(' ').take(2).map((w) => (w as String)[0]).join(),
                            style: GoogleFonts.playfairDisplay(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primaryGreen),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(patient['name'],
                              style: GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.darkText)),
                          Text('ID: ${patient['id']}  •  ${patient['age']} yrs  •  ${patient['gender']}  •  ${patient['bloodGroup']}',
                              style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.mutedText)),
                        ])),
                        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                          Text(patient['doctor'],
                              style: GoogleFonts.dmSans(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.primaryGreen)),
                          Text(patient['department'],
                              style: GoogleFonts.dmSans(fontSize: 11, color: AppColors.mutedText)),
                        ]),
                      ]),
                    ),
                    const SizedBox(height: 20),

                    // Checkup details
                    _ReceiptRow(label: 'Diagnosis', value: diagnosis),
                    if (symptoms.isNotEmpty) _ReceiptRow(label: 'Symptoms', value: symptoms),
                    if (notes.isNotEmpty) _ReceiptRow(label: "Doctor's Notes", value: notes),
                    if (followUp.isNotEmpty) _ReceiptRow(label: 'Follow-up', value: followUp),

                    // Medications
                    if (medications.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Text('Prescribed Medications',
                          style: GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.darkText)),
                      const SizedBox(height: 10),
                      ...medications.map((med) => _PrescriptionItem(med: med)),
                    ],

                    // Attached files
                    if (files.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Text('Attached Reports',
                          style: GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.darkText)),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: files.map((f) => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceWhite,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: AppColors.borderColor),
                          ),
                          child: Row(mainAxisSize: MainAxisSize.min, children: [
                            const Icon(Icons.picture_as_pdf_rounded, color: AppColors.errorRed, size: 14),
                            const SizedBox(width: 6),
                            Text(f, style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.darkText)),
                          ]),
                        )).toList(),
                      ),
                    ],
                    const SizedBox(height: 20),

                    // Alarm notice
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.lightGreen.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(children: [
                        const Icon(Icons.alarm_rounded, color: AppColors.primaryGreen, size: 18),
                        const SizedBox(width: 10),
                        Expanded(child: Text(
                          'Medication alarms have been automatically set up in the patient\'s Arogya app based on the prescription timing above.',
                          style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.primaryGreen, height: 1.5),
                        )),
                      ]),
                    ),
                  ]),
                ),
              ]),
            ),
            const SizedBox(height: 20),

            // Action buttons
            Row(children: [
              Expanded(child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.print_rounded, size: 18),
                label: const Text('Print Receipt'),
              )),
              const SizedBox(width: 12),
              Expanded(child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.download_rounded, size: 18),
                label: const Text('Download PDF'),
              )),
              const SizedBox(width: 12),
              Expanded(child: ElevatedButton.icon(
                onPressed: onReset,
                icon: const Icon(Icons.add_rounded, size: 18),
                label: const Text('New Receipt'),
              )),
            ]),
          ]),
        ),
      ),
    );
  }
}

class _ReceiptRow extends StatelessWidget {
  final String label;
  final String value;
  const _ReceiptRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(width: 130,
            child: Text(label, style: GoogleFonts.dmSans(fontSize: 13, color: AppColors.mutedText))),
        Expanded(child: Text(value,
            style: GoogleFonts.dmSans(fontSize: 13, color: AppColors.darkText, fontWeight: FontWeight.w500, height: 1.5))),
      ]),
    );
  }
}

class _PrescriptionItem extends StatelessWidget {
  final Map<String, dynamic> med;
  const _PrescriptionItem({required this.med});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Row(children: [
        const Icon(Icons.medication_rounded, color: AppColors.mediumGreen, size: 18),
        const SizedBox(width: 10),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('${med['name']}  ${med['dosage'] ?? ''}',
              style: GoogleFonts.dmSans(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.darkText)),
          Text('${med['frequency']} for ${med['duration']}',
              style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.mutedText)),
        ])),
        Wrap(
          spacing: 4,
          children: (med['timing'] as List<dynamic>).map((t) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: AppColors.primaryGreen,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(t.toString(),
                style: GoogleFonts.dmSans(fontSize: 10, color: AppColors.white, fontWeight: FontWeight.w600)),
          )).toList(),
        ),
      ]),
    );
  }
}

// ── Section Card wrapper ──────────────────────────────────────────────────────
class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;
  final Widget? trailing;
  const _SectionCard({required this.title, required this.icon, required this.child, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.lightGreen.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.primaryGreen, size: 18),
          ),
          const SizedBox(width: 10),
          Text(title,
              style: GoogleFonts.dmSans(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.darkText)),
          if (trailing != null) ...[const Spacer(), trailing!],
        ]),
        const SizedBox(height: 16),
        child,
      ]),
    );
  }
}
