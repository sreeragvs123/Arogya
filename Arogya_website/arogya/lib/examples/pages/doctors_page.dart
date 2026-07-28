import 'package:arogya/examples/widgets/shared_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/sidebar.dart';
import 'departments_page.dart' show PageHeader, EmptyState, SummaryChip;

class DoctorsPage extends StatefulWidget {
  final String departmentId;
  final String departmentName;
  const DoctorsPage({super.key, required this.departmentId, required this.departmentName});

  @override
  State<DoctorsPage> createState() => _DoctorsPageState();
}

class _DoctorsPageState extends State<DoctorsPage> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  String _availabilityFilter = 'All';

  final List<Map<String, dynamic>> _doctors = [
    {
      'id': 'doc1', 'name': 'Dr. Ramesh Iyer', 'specialisation': 'Cardiologist',
      'phone': '9876543210', 'email': 'ramesh@hospital.com',
      'patients': 12, 'experience': '14 yrs', 'available': true,
      'qualifications': 'MBBS, MD, DM Cardiology',
      'schedule': 'Mon – Fri, 9 AM – 5 PM',
    },
    {
      'id': 'doc2', 'name': 'Dr. Latha Suresh', 'specialisation': 'Cardiac Surgeon',
      'phone': '9876543211', 'email': 'latha@hospital.com',
      'patients': 8, 'experience': '9 yrs', 'available': true,
      'qualifications': 'MBBS, MS, MCh Cardiac Surgery',
      'schedule': 'Mon – Sat, 10 AM – 4 PM',
    },
    {
      'id': 'doc3', 'name': 'Dr. Arun Pillai', 'specialisation': 'Interventional Cardiologist',
      'phone': '9876543212', 'email': 'arun@hospital.com',
      'patients': 5, 'experience': '6 yrs', 'available': false,
      'qualifications': 'MBBS, MD, Fellowship Interventional Cardiology',
      'schedule': 'Tue – Sat, 11 AM – 6 PM',
    },
    {
      'id': 'doc4', 'name': 'Dr. Meena Varma', 'specialisation': 'Electrophysiologist',
      'phone': '9876543213', 'email': 'meena@hospital.com',
      'patients': 7, 'experience': '11 yrs', 'available': true,
      'qualifications': 'MBBS, MD, DM Electrophysiology',
      'schedule': 'Mon – Thu, 8 AM – 3 PM',
    },
  ];

  final List<String> _filterOptions = ['All', 'Available', 'Unavailable'];

  List<Map<String, dynamic>> get _filtered => _doctors.where((d) {
        final matchSearch =
            d['name'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
            d['specialisation'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
            d['email'].toLowerCase().contains(_searchQuery.toLowerCase());
        final matchAvail = _availabilityFilter == 'All'
            ? true
            : _availabilityFilter == 'Available'
                ? d['available'] == true
                : d['available'] == false;
        return matchSearch && matchAvail;
      }).toList();

  int get _availableCount => _doctors.where((d) => d['available'] == true).length;
  int get _totalPatients => _doctors.fold(0, (s, d) => s + (d['patients'] as int));

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
                  title: widget.departmentName,
                  subtitle: 'Doctors in this department',
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Breadcrumb
                        Breadcrumb(items: ['Dashboard', 'Departments', widget.departmentName]),
                        const SizedBox(height: 20),

                        // Search + Add
                        Row(children: [
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              onChanged: (v) => setState(() => _searchQuery = v),
                              decoration: InputDecoration(
                                hintText: 'Search by name, specialisation or email...',
                                prefixIcon: const Icon(Icons.search_rounded, color: AppColors.mediumGreen, size: 20),
                                suffixIcon: _searchQuery.isNotEmpty
                                    ? IconButton(
                                        icon: const Icon(Icons.close_rounded, size: 18),
                                        onPressed: () {
                                          _searchController.clear();
                                          setState(() => _searchQuery = '');
                                        },
                                      )
                                    : null,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton.icon(
                            onPressed: () => _showDoctorDialog(context),
                            icon: const Icon(Icons.person_add_rounded, size: 18),
                            label: const Text('Add Doctor'),
                          ),
                        ]),
                        const SizedBox(height: 16),

                        // Filter chips
                        Row(children: _filterOptions.map((f) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: _FilterChip(
                            label: f,
                            selected: _availabilityFilter == f,
                            onTap: () => setState(() => _availabilityFilter = f),
                          ),
                        )).toList()),
                        const SizedBox(height: 16),

                        // Summary chips
                        Wrap(spacing: 10, children: [
                          SummaryChip(label: '${_doctors.length} Doctors', icon: Icons.medical_services_rounded),
                          SummaryChip(label: '$_availableCount Available', icon: Icons.check_circle_rounded),
                          SummaryChip(label: '$_totalPatients Active Patients', icon: Icons.people_alt_rounded),
                        ]),
                        const SizedBox(height: 24),

                        // Doctor list
                        if (_filtered.isEmpty)
                          EmptyState(message: 'No doctors match "$_searchQuery"')
                        else
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _filtered.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 12),
                            itemBuilder: (_, i) => _DoctorCard(
                              doctor: _filtered[i],
                              onViewPatients: () => Navigator.pushNamed(
                                context,
                                '/patients',
                                arguments: {
                                  'doctorId': _filtered[i]['id'],
                                  'doctorName': _filtered[i]['name'],
                                },
                              ),
                              onEdit: () => _showDoctorDialog(context, doctor: _filtered[i]),
                              onDelete: () => _confirmDelete(context, _filtered[i]),
                              onToggleAvailability: () => setState(() =>
                                  _filtered[i]['available'] = !(_filtered[i]['available'] as bool)),
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

  // ── Add / Edit Dialog ─────────────────────────────────────────────────────
  void _showDoctorDialog(BuildContext context, {Map<String, dynamic>? doctor}) {
    final isEdit = doctor != null;
    final nameCtrl = TextEditingController(text: doctor?['name'] ?? '');
    final specCtrl = TextEditingController(text: doctor?['specialisation'] ?? '');
    final phoneCtrl = TextEditingController(text: doctor?['phone'] ?? '');
    final emailCtrl = TextEditingController(text: doctor?['email'] ?? '');
    final expCtrl = TextEditingController(text: doctor?['experience'] ?? '');
    final qualCtrl = TextEditingController(text: doctor?['qualifications'] ?? '');
    final scheduleCtrl = TextEditingController(text: doctor?['schedule'] ?? '');
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: AppColors.lightGreen.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8)),
            child: const Icon(Icons.medical_services_rounded, color: AppColors.primaryGreen, size: 20),
          ),
          const SizedBox(width: 10),
          Text(isEdit ? 'Edit Doctor' : 'Add Doctor',
              style: GoogleFonts.playfairDisplay(fontSize: 20, fontWeight: FontWeight.w700)),
        ]),
        content: SizedBox(
          width: 480,
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                TextFormField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    prefixIcon: Icon(Icons.person_rounded, color: AppColors.mediumGreen, size: 20),
                  ),
                  validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: specCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Specialisation',
                    prefixIcon: Icon(Icons.medical_services_rounded, color: AppColors.mediumGreen, size: 20),
                  ),
                  validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: qualCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Qualifications',
                    prefixIcon: Icon(Icons.school_rounded, color: AppColors.mediumGreen, size: 20),
                  ),
                ),
                const SizedBox(height: 12),
                Row(children: [
                  Expanded(child: TextFormField(
                    controller: phoneCtrl,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(labelText: 'Phone'),
                    validator: (v) => v == null || v.length < 10 ? 'Enter valid phone' : null,
                  )),
                  const SizedBox(width: 12),
                  Expanded(child: TextFormField(
                    controller: expCtrl,
                    decoration: const InputDecoration(labelText: 'Experience (e.g. 5 yrs)'),
                    validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                  )),
                ]),
                const SizedBox(height: 12),
                TextFormField(
                  controller: emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email_outlined, color: AppColors.mediumGreen, size: 20),
                  ),
                  validator: (v) => v == null || !v.contains('@') ? 'Enter valid email' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: scheduleCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Schedule (e.g. Mon–Fri, 9 AM–5 PM)',
                    prefixIcon: Icon(Icons.schedule_rounded, color: AppColors.mediumGreen, size: 20),
                  ),
                ),
              ]),
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                setState(() {
                  if (isEdit) {
                    doctor!['name'] = nameCtrl.text;
                    doctor['specialisation'] = specCtrl.text;
                    doctor['phone'] = phoneCtrl.text;
                    doctor['email'] = emailCtrl.text;
                    doctor['experience'] = expCtrl.text;
                    doctor['qualifications'] = qualCtrl.text;
                    doctor['schedule'] = scheduleCtrl.text;
                  } else {
                    _doctors.add({
                      'id': 'doc${_doctors.length + 1}',
                      'name': nameCtrl.text,
                      'specialisation': specCtrl.text,
                      'phone': phoneCtrl.text,
                      'email': emailCtrl.text,
                      'experience': expCtrl.text,
                      'qualifications': qualCtrl.text,
                      'schedule': scheduleCtrl.text,
                      'patients': 0,
                      'available': true,
                    });
                  }
                });
                Navigator.pop(context);
              }
            },
            child: Text(isEdit ? 'Save Changes' : 'Add Doctor'),
          ),
        ],
      ),
    );
  }

  // ── Delete confirm ────────────────────────────────────────────────────────
  void _confirmDelete(BuildContext context, Map<String, dynamic> doctor) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Remove ${doctor['name']}?',
            style: GoogleFonts.dmSans(fontSize: 17, fontWeight: FontWeight.w600)),
        content: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('This will remove the doctor from the department.',
              style: GoogleFonts.dmSans(fontSize: 13, color: AppColors.mutedText, height: 1.5)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: AppColors.errorRed.withOpacity(0.07),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.errorRed.withOpacity(0.2))),
            child: Row(children: [
              const Icon(Icons.warning_amber_rounded, color: AppColors.errorRed, size: 16),
              const SizedBox(width: 8),
              Expanded(child: Text(
                '${doctor['patients']} active patient records will need to be reassigned.',
                style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.errorRed),
              )),
            ]),
          ),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              setState(() => _doctors.removeWhere((d) => d['id'] == doctor['id']));
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.errorRed),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }
}

// ── Doctor Card ───────────────────────────────────────────────────────────────
class _DoctorCard extends StatefulWidget {
  final Map<String, dynamic> doctor;
  final VoidCallback onViewPatients;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onToggleAvailability;

  const _DoctorCard({
    required this.doctor,
    required this.onViewPatients,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleAvailability,
  });

  @override
  State<_DoctorCard> createState() => _DoctorCardState();
}

class _DoctorCardState extends State<_DoctorCard> {
  bool _hovered = false;
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final d = widget.doctor;
    final bool available = d['available'] as bool;
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
          boxShadow: _hovered
              ? [BoxShadow(color: AppColors.cardShadow, blurRadius: 10, offset: const Offset(0, 3))]
              : [],
        ),
        child: Column(
          children: [
            // Main row
            Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                children: [
                  // Avatar with initials
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: AppColors.lightGreen.withOpacity(0.4),
                    child: Text(
                      d['name'].toString().split(' ')
                          .where((w) => (w as String).isNotEmpty)
                          .take(2)
                          .map((w) => (w as String)[0])
                          .join(),
                      style: GoogleFonts.playfairDisplay(
                          fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.primaryGreen),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Info
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(children: [
                        Flexible(
                          child: Text(d['name'],
                              style: GoogleFonts.dmSans(
                                  fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.darkText)),
                        ),
                        const SizedBox(width: 8),
                        _AvailabilityBadge(available: available),
                      ]),
                      const SizedBox(height: 2),
                      Text(d['specialisation'],
                          style: GoogleFonts.dmSans(fontSize: 13, color: AppColors.mediumGreen, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 6),
                      Wrap(spacing: 12, children: [
                        _InfoChip(icon: Icons.people_alt_rounded, label: '${d['patients']} patients'),
                        _InfoChip(icon: Icons.access_time_rounded, label: d['experience']),
                        if (isWide && d['schedule'] != null)
                          _InfoChip(icon: Icons.schedule_rounded, label: d['schedule']),
                      ]),
                    ]),
                  ),
                  const SizedBox(width: 12),

                  // Actions
                  Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    ElevatedButton(
                      onPressed: widget.onViewPatients,
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10)),
                      child: Text('View Patients',
                          style: GoogleFonts.dmSans(fontSize: 12, fontWeight: FontWeight.w600)),
                    ),
                    const SizedBox(height: 6),
                    Row(mainAxisSize: MainAxisSize.min, children: [
                      _SmallIconBtn(icon: Icons.edit_outlined, tooltip: 'Edit', onTap: widget.onEdit),
                      _SmallIconBtn(
                        icon: available ? Icons.toggle_on_rounded : Icons.toggle_off_rounded,
                        tooltip: available ? 'Mark unavailable' : 'Mark available',
                        color: available ? AppColors.successGreen : AppColors.mutedText,
                        onTap: widget.onToggleAvailability,
                      ),
                      _SmallIconBtn(icon: Icons.delete_outline_rounded, tooltip: 'Remove', onTap: widget.onDelete),
                    ]),
                  ]),

                  // Expand toggle
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

            // Expanded details panel
            if (_expanded)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
                decoration: const BoxDecoration(
                  color: AppColors.surfaceWhite,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Divider(),
                  const SizedBox(height: 10),
                  Wrap(spacing: 32, runSpacing: 10, children: [
                    _DetailItem(label: 'Email', value: d['email'] ?? '—'),
                    _DetailItem(label: 'Phone', value: d['phone'] ?? '—'),
                    _DetailItem(label: 'Experience', value: d['experience'] ?? '—'),
                    _DetailItem(label: 'Schedule', value: d['schedule'] ?? '—'),
                    if (d['qualifications'] != null)
                      _DetailItem(label: 'Qualifications', value: d['qualifications']),
                  ]),
                ]),
              ),
          ],
        ),
      ),
    );
  }
}

class _AvailabilityBadge extends StatelessWidget {
  final bool available;
  const _AvailabilityBadge({required this.available});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: available
            ? AppColors.successGreen.withOpacity(0.12)
            : Colors.grey.withOpacity(0.12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(Icons.circle, size: 6,
            color: available ? AppColors.successGreen : Colors.grey),
        const SizedBox(width: 4),
        Text(available ? 'Available' : 'Unavailable',
            style: GoogleFonts.dmSans(
                fontSize: 11,
                color: available ? AppColors.successGreen : Colors.grey,
                fontWeight: FontWeight.w500)),
      ]),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, size: 13, color: AppColors.mutedText),
      const SizedBox(width: 4),
      Text(label, style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.mutedText)),
    ]);
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

class _SmallIconBtn extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;
  final Color? color;
  const _SmallIconBtn({required this.icon, required this.tooltip, required this.onTap, this.color});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: IconButton(
        icon: Icon(icon, size: 18, color: color ?? AppColors.mutedText),
        onPressed: onTap,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(minWidth: 30, minHeight: 30),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _FilterChip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryGreen : AppColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? AppColors.primaryGreen : AppColors.borderColor),
        ),
        child: Text(label,
            style: GoogleFonts.dmSans(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: selected ? AppColors.white : AppColors.darkText)),
      ),
    );
  }
}

