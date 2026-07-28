import 'package:arogya/examples/widgets/shared_widgets.dart';
import 'package:flutter/material.dart' hide FilterChip;
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/sidebar.dart';

class PatientsPage extends StatefulWidget {
  final String doctorId;
  final String doctorName;
  const PatientsPage({super.key, required this.doctorId, required this.doctorName});

  @override
  State<PatientsPage> createState() => _PatientsPageState();
}

class _PatientsPageState extends State<PatientsPage> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  String _statusFilter = 'All';

  final List<Map<String, dynamic>> _patients = [
    {
      'id': 'AY001234', 'name': 'Ravi Kumar', 'age': 45, 'gender': 'Male',
      'phone': '9876543210', 'diagnosis': 'Hypertension', 'status': 'Active',
      'admittedOn': '12 May 2025', 'lastVisit': '28 May 2025',
      'bloodGroup': 'O+', 'ward': 'General Ward 3',
    },
    {
      'id': 'AY001235', 'name': 'Leela Sharma', 'age': 62, 'gender': 'Female',
      'phone': '9876543211', 'diagnosis': 'Atrial Fibrillation', 'status': 'Critical',
      'admittedOn': '20 May 2025', 'lastVisit': '30 May 2025',
      'bloodGroup': 'A+', 'ward': 'ICU Ward 1',
    },
    {
      'id': 'AY001236', 'name': 'Anil Pillai', 'age': 38, 'gender': 'Male',
      'phone': '9876543212', 'diagnosis': 'Chest Pain - Under Observation', 'status': 'Stable',
      'admittedOn': '25 May 2025', 'lastVisit': '31 May 2025',
      'bloodGroup': 'B+', 'ward': 'General Ward 1',
    },
    {
      'id': 'AY001237', 'name': 'Meena Nair', 'age': 55, 'gender': 'Female',
      'phone': '9876543213', 'diagnosis': 'Post-cardiac surgery recovery', 'status': 'Recovering',
      'admittedOn': '10 May 2025', 'lastVisit': '29 May 2025',
      'bloodGroup': 'AB-', 'ward': 'Recovery Ward 2',
    },
  ];

  final List<String> _statusOptions = ['All', 'Active', 'Critical', 'Stable', 'Recovering'];

  List<Map<String, dynamic>> get _filtered => _patients.where((p) {
        final matchSearch = p['name'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
            p['id'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
            p['diagnosis'].toLowerCase().contains(_searchQuery.toLowerCase());
        final matchStatus = _statusFilter == 'All' || p['status'] == _statusFilter;
        return matchSearch && matchStatus;
      }).toList();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
                  title: widget.doctorName,
                  subtitle: 'Patients currently under treatment',
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Breadcrumb(items: ['Dashboard', 'Departments', 'Doctors', widget.doctorName]),
                        const SizedBox(height: 20),
                        // Search + Add
                        Row(children: [
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              onChanged: (v) => setState(() => _searchQuery = v),
                              decoration: InputDecoration(
                                hintText: 'Search by name, ID or diagnosis...',
                                prefixIcon: const Icon(Icons.search_rounded, color: AppColors.mediumGreen, size: 20),
                                suffixIcon: _searchQuery.isNotEmpty
                                    ? IconButton(icon: const Icon(Icons.close_rounded, size: 18), onPressed: () { _searchController.clear(); setState(() => _searchQuery = ''); })
                                    : null,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton.icon(
                            onPressed: () => Navigator.pushNamed(context, '/checkup-receipt', arguments: {'patientId': ''}),
                            icon: const Icon(Icons.receipt_long_rounded, size: 18),
                            label: const Text('New Receipt'),
                          ),
                        ]),
                        const SizedBox(height: 16),
                        // Status filter chips
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: _statusOptions.map((s) => Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: FilterChip(
                                label: s,
                                selected: _statusFilter == s,
                                onTap: () => setState(() => _statusFilter = s),
                              ),
                            )).toList(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Summary
                        Row(children: [
                          SummaryChip(label: '${_patients.length} Total', icon: Icons.people_alt_rounded),
                          const SizedBox(width: 10),
                          SummaryChip(label: '${_patients.where((p) => p['status'] == 'Critical').length} Critical', icon: Icons.warning_amber_rounded),
                        ]),
                        const SizedBox(height: 24),
                        if (_filtered.isEmpty)
                          EmptyState(message: 'No patients match the current filter')
                        else
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _filtered.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 12),
                            itemBuilder: (_, i) => _PatientCard(
                              patient: _filtered[i],
                              onViewReceipt: () => Navigator.pushNamed(context, '/checkup-receipt', arguments: {'patientId': _filtered[i]['id']}),
                            ),
                          ),
                      ],
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

class _PatientCard extends StatefulWidget {
  final Map<String, dynamic> patient;
  final VoidCallback onViewReceipt;
  const _PatientCard({required this.patient, required this.onViewReceipt});

  @override
  State<_PatientCard> createState() => _PatientCardState();
}

class _PatientCardState extends State<_PatientCard> {
  bool _expanded = false;
  bool _hovered = false;

  static const _statusColors = {
    'Active': AppColors.mediumGreen,
    'Critical': AppColors.errorRed,
    'Stable': Color(0xFF1976D2),
    'Recovering': Color(0xFFF57C00),
  };

  @override
  Widget build(BuildContext context) {
    final p = widget.patient;
    final statusColor = _statusColors[p['status']] ?? AppColors.mutedText;
    final isWide = MediaQuery.of(context).size.width > 700;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _hovered ? AppColors.mediumGreen : AppColors.borderColor),
          boxShadow: _hovered ? [BoxShadow(color: AppColors.cardShadow, blurRadius: 10, offset: const Offset(0, 3))] : [],
        ),
        child: Column(
          children: [
            // Main row
            Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                children: [
                  // Avatar
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: AppColors.lightGreen.withOpacity(0.35),
                    child: Text(
                      p['name'].toString().split(' ').take(2).map((w) => (w as String)[0]).join(),
                      style: GoogleFonts.playfairDisplay(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.primaryGreen),
                    ),
                  ),
                  const SizedBox(width: 14),
                  // Basic info
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(children: [
                        Text(p['name'], style: GoogleFonts.dmSans(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.darkText)),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(p['status'], style: GoogleFonts.dmSans(fontSize: 11, color: statusColor, fontWeight: FontWeight.w600)),
                        ),
                      ]),
                      const SizedBox(height: 2),
                      Text('ID: ${p['id']}  •  ${p['age']} yrs  •  ${p['gender']}  •  ${p['bloodGroup']}',
                          style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.mutedText)),
                      const SizedBox(height: 4),
                      Text(p['diagnosis'], style: GoogleFonts.dmSans(fontSize: 13, color: AppColors.darkText, fontWeight: FontWeight.w500)),
                    ]),
                  ),
                  const SizedBox(width: 12),
                  // Actions
                  if (isWide) ...[
                    ElevatedButton.icon(
                      onPressed: widget.onViewReceipt,
                      icon: const Icon(Icons.receipt_long_rounded, size: 15),
                      label: const Text('Checkup Receipt'),
                      style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10)),
                    ),
                    const SizedBox(width: 8),
                  ],
                  IconButton(
                    icon: AnimatedRotation(
                      turns: _expanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.mutedText),
                    ),
                    onPressed: () => setState(() => _expanded = !_expanded),
                  ),
                ],
              ),
            ),
            // Expanded details
            if (_expanded)
              Container(
                decoration: const BoxDecoration(
                  color: AppColors.surfaceWhite,
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16)),
                ),
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(),
                    const SizedBox(height: 10),
                    Wrap(spacing: 24, runSpacing: 10, children: [
                      _DetailItem(label: 'Ward', value: p['ward']),
                      _DetailItem(label: 'Phone', value: p['phone']),
                      _DetailItem(label: 'Admitted On', value: p['admittedOn']),
                      _DetailItem(label: 'Last Visit', value: p['lastVisit']),
                    ]),
                    if (!isWide) ...[
                      const SizedBox(height: 14),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: widget.onViewReceipt,
                          icon: const Icon(Icons.receipt_long_rounded, size: 15),
                          label: const Text('New Checkup Receipt'),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _DetailItem extends StatelessWidget {
  final String label;
  final String value;
  const _DetailItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: GoogleFonts.dmSans(fontSize: 11, color: AppColors.mutedText, fontWeight: FontWeight.w500)),
      Text(value, style: GoogleFonts.dmSans(fontSize: 13, color: AppColors.darkText, fontWeight: FontWeight.w600)),
    ]);
  }
}


