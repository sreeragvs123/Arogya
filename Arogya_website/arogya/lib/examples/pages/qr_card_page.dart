import 'package:arogya/examples/widgets/shared_widgets.dart';
import 'package:arogya/examples/widgets/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';


class QrCardPage extends StatelessWidget {
  final Map<String, dynamic> patientData;
  const QrCardPage({super.key, required this.patientData});

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
                PageHeader(isWide: isWide, title: 'Patient QR Card', subtitle: 'Generated card — ready to print'),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 760),
                        child: Column(
                          children: [
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
                                  Text('Patient registered successfully!', style: GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.successGreen)),
                                  Text('QR card is ready. Print it and hand it to the patient.', style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.mutedText)),
                                ])),
                              ]),
                            ),
                            const SizedBox(height: 28),
                            // Card preview + actions side by side on wide
                            isWide
                                ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                    Expanded(flex: 3, child: _PhysicalCard(data: patientData)),
                                    const SizedBox(width: 24),
                                    Expanded(flex: 2, child: _CardActions(data: patientData)),
                                  ])
                                : Column(children: [
                                    _PhysicalCard(data: patientData),
                                    const SizedBox(height: 20),
                                    _CardActions(data: patientData),
                                  ]),
                            const SizedBox(height: 28),
                            _PatientInfoTable(data: patientData),
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
}

class _PhysicalCard extends StatelessWidget {
  final Map<String, dynamic> data;
  const _PhysicalCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final name = data['name'] ?? 'Patient Name';
    final id = data['patientId'] ?? 'AY000000';
    final username = data['username'] ?? id;
    final dob = data['dob'] ?? '—';
    final age = data['age'] ?? '—';
    final bloodGroup = data['bloodGroup'] ?? '—';
    final regDate = data['registrationDate'] ?? '—';
    final dept = data['department'] ?? '—';

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderColor),
        boxShadow: [BoxShadow(color: AppColors.cardShadow, blurRadius: 16, offset: const Offset(0, 4))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: [
            // Card header — green band
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              color: AppColors.primaryGreen,
              child: Row(children: [
                const Icon(Icons.local_hospital_rounded, color: AppColors.white, size: 20),
                const SizedBox(width: 8),
                Text('Arogya Health Card', style: GoogleFonts.playfairDisplay(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.white)),
                const Spacer(),
                Text(regDate, style: GoogleFonts.dmSans(fontSize: 11, color: AppColors.lightGreen)),
              ]),
            ),
            // Card body
            Container(
              color: AppColors.white,
              padding: const EdgeInsets.all(20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left: Photo placeholder + QR
                  Column(children: [
                    // Photo
                    Container(
                      width: 72, height: 80,
                      decoration: BoxDecoration(
                        color: AppColors.lightGreen.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.borderColor),
                      ),
                      child: const Icon(Icons.person_rounded, size: 36, color: AppColors.primaryGreen),
                    ),
                    const SizedBox(height: 10),
                    // QR code placeholder
                    Container(
                      width: 72, height: 72,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        border: Border.all(color: AppColors.darkText, width: 2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: _QrPattern(),
                    ),
                  ]),
                  const SizedBox(width: 18),
                  // Right: Details
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(name, style: GoogleFonts.playfairDisplay(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.darkText)),
                      const SizedBox(height: 2),
                      Text(dept, style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.mediumGreen, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 10),
                      const Divider(height: 1),
                      const SizedBox(height: 10),
                      _CardRow(label: 'Patient ID', value: id, bold: true),
                      _CardRow(label: 'Date of Birth', value: dob),
                      _CardRow(label: 'Age', value: '$age yrs'),
                      _CardRow(label: 'Blood Group', value: bloodGroup),
                      const SizedBox(height: 10),
                      const Divider(height: 1),
                      const SizedBox(height: 10),
                      // Credentials box
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceWhite,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.borderColor),
                        ),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text('App Login Credentials', style: GoogleFonts.dmSans(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.primaryGreen, letterSpacing: 0.3)),
                          const SizedBox(height: 6),
                          _CardRow(label: 'Username', value: username, mono: true),
                          _CardRow(label: 'Password', value: 'Date of Birth (DDMMYYYY)', mono: true),
                        ]),
                      ),
                    ]),
                  ),
                ],
              ),
            ),
            // Card footer
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              color: AppColors.surfaceWhite,
              child: Row(children: [
                const Icon(Icons.shield_outlined, size: 13, color: AppColors.mutedText),
                const SizedBox(width: 4),
                Text('This card is issued by the hospital. Keep it safe.', style: GoogleFonts.dmSans(fontSize: 10, color: AppColors.mutedText)),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

class _QrPattern extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Decorative QR-like grid pattern
    return GridView.count(
      crossAxisCount: 7,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: List.generate(49, (i) {
        final on = [0,1,2,3,4,5,6,7,14,21,28,35,42,43,44,45,46,47,48,8,15,12,13,20,27,34,41,24,25,32,33].contains(i);
        return Container(color: on ? AppColors.darkText : Colors.transparent, margin: const EdgeInsets.all(0.5));
      }),
    );
  }
}

class _CardRow extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;
  final bool mono;
  const _CardRow({required this.label, required this.value, this.bold = false, this.mono = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(children: [
        SizedBox(width: 90, child: Text(label, style: GoogleFonts.dmSans(fontSize: 11, color: AppColors.mutedText))),
        Expanded(child: Text(value,
          style: mono
              ? GoogleFonts.sourceCodePro(fontSize: 11, color: AppColors.darkText, fontWeight: FontWeight.w600)
              : GoogleFonts.dmSans(fontSize: 11, color: AppColors.darkText, fontWeight: bold ? FontWeight.w700 : FontWeight.w500))),
      ]),
    );
  }
}

class _CardActions extends StatelessWidget {
  final Map<String, dynamic> data;
  const _CardActions({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Text('Card actions', style: GoogleFonts.dmSans(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.darkText)),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.print_rounded, size: 18),
          label: const Text('Print QR Card'),
        ),
        const SizedBox(height: 10),
        OutlinedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.download_rounded, size: 18),
          label: const Text('Download as PDF'),
        ),
        const SizedBox(height: 10),
        OutlinedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.share_rounded, size: 18),
          label: const Text('Send to Patient'),
        ),
        const SizedBox(height: 20),
        const Divider(),
        const SizedBox(height: 14),
        // Credential reminder
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.lightGreen.withOpacity(0.25),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              const Icon(Icons.key_rounded, color: AppColors.primaryGreen, size: 16),
              const SizedBox(width: 6),
              Text('App credentials', style: GoogleFonts.dmSans(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primaryGreen)),
            ]),
            const SizedBox(height: 8),
            _CredRow(label: 'Username', value: data['username'] ?? data['patientId'] ?? '—'),
            _CredRow(label: 'Password', value: (data['dob'] ?? '').toString().replaceAll('/', '')),
            const SizedBox(height: 8),
            Text('Patient can log into the Arogya app using these credentials.',
                style: GoogleFonts.dmSans(fontSize: 11, color: AppColors.mutedText, height: 1.4)),
          ]),
        ),
        const SizedBox(height: 16),
        TextButton.icon(
          onPressed: () => Navigator.pushReplacementNamed(context, '/patient-register'),
          icon: const Icon(Icons.person_add_rounded, size: 16),
          label: const Text('Register another patient'),
        ),
      ]),
    );
  }
}

class _CredRow extends StatelessWidget {
  final String label;
  final String value;
  const _CredRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(children: [
        SizedBox(width: 70, child: Text(label, style: GoogleFonts.dmSans(fontSize: 11, color: AppColors.mutedText))),
        Text(value, style: GoogleFonts.sourceCodePro(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primaryGreen)),
      ]),
    );
  }
}

class _PatientInfoTable extends StatelessWidget {
  final Map<String, dynamic> data;
  const _PatientInfoTable({required this.data});

  @override
  Widget build(BuildContext context) {
    final rows = [
      ['Full Name', data['name'] ?? '—'],
      ['Patient ID', data['patientId'] ?? '—'],
      ['Date of Birth', data['dob'] ?? '—'],
      ['Age', '${data['age'] ?? '—'} years'],
      ['Gender', data['gender'] ?? '—'],
      ['Blood Group', data['bloodGroup'] ?? '—'],
      ['Aadhaar', '••••••••${(data['aadhar'] ?? '').toString().length > 4 ? (data['aadhar'] ?? '').toString().substring((data['aadhar'] ?? '').toString().length - 4) : '—'}'],
      ['Phone', data['phone'] ?? '—'],
      ['Address', '${data['address'] ?? '—'}, ${data['city'] ?? ''}'],
      ['Department', data['department'] ?? '—'],
      ['Assigned Doctor', data['doctor'] ?? '—'],
      ['Registration Date', data['registrationDate'] ?? '—'],
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          child: Text('Full patient record', style: GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.darkText)),
        ),
        const SizedBox(height: 12),
        ...rows.asMap().entries.map((entry) {
          final isEven = entry.key % 2 == 0;
          final row = entry.value;
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            color: isEven ? AppColors.surfaceWhite : AppColors.white,
            child: Row(children: [
              SizedBox(width: 160, child: Text(row[0], style: GoogleFonts.dmSans(fontSize: 13, color: AppColors.mutedText))),
              Expanded(child: Text(row[1], style: GoogleFonts.dmSans(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.darkText))),
            ]),
          );
        }),
        const SizedBox(height: 8),
      ]),
    );
  }
}
