import 'package:arogya/examples/widgets/shared_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/sidebar.dart';

class DepartmentsPage extends StatefulWidget {
  final String hospitalId;
  const DepartmentsPage({super.key, required this.hospitalId});

  @override
  State<DepartmentsPage> createState() => _DepartmentsPageState();
}

class _DepartmentsPageState extends State<DepartmentsPage> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  final List<Map<String, dynamic>> _departments = [
    {'id': 'd1', 'name': 'Cardiology', 'head': 'Dr. Ramesh Iyer', 'doctors': 8, 'patients': 34, 'icon': Icons.favorite_rounded},
    {'id': 'd2', 'name': 'Neurology', 'head': 'Dr. Priya Nair', 'doctors': 5, 'patients': 21, 'icon': Icons.psychology_rounded},
    {'id': 'd3', 'name': 'Orthopaedics', 'head': 'Dr. Suresh Menon', 'doctors': 6, 'patients': 18, 'icon': Icons.accessibility_new_rounded},
    {'id': 'd4', 'name': 'Paediatrics', 'head': 'Dr. Anitha Pillai', 'doctors': 7, 'patients': 42, 'icon': Icons.child_care_rounded},
    {'id': 'd5', 'name': 'General Medicine', 'head': 'Dr. Vinod Kumar', 'doctors': 10, 'patients': 56, 'icon': Icons.medical_services_rounded},
    {'id': 'd6', 'name': 'Dermatology', 'head': 'Dr. Rekha Das', 'doctors': 4, 'patients': 29, 'icon': Icons.spa_rounded},
  ];

  List<Map<String, dynamic>> get _filtered => _departments
      .where((d) =>
          d['name'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          d['head'].toLowerCase().contains(_searchQuery.toLowerCase()))
      .toList();

  int get _totalDoctors => _departments.fold(0, (s, d) => s + (d['doctors'] as int));
  int get _totalPatients => _departments.fold(0, (s, d) => s + (d['patients'] as int));

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
                  title: 'Departments',
                  subtitle: 'Manage hospital departments and their staff',
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Search + Add row
                        Row(children: [
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              onChanged: (v) => setState(() => _searchQuery = v),
                              decoration: InputDecoration(
                                hintText: 'Search by department or head doctor...',
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
                            onPressed: () => _showDepartmentDialog(context),
                            icon: const Icon(Icons.add_rounded, size: 18),
                            label: const Text('Add Department'),
                          ),
                        ]),
                        const SizedBox(height: 16),

                        // Summary chips
                        Wrap(
                          spacing: 10,
                          children: [
                            SummaryChip(label: '${_departments.length} Departments', icon: Icons.account_tree_rounded),
                            SummaryChip(label: '$_totalDoctors Doctors', icon: Icons.medical_services_rounded),
                            SummaryChip(label: '$_totalPatients Patients', icon: Icons.people_alt_rounded),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Grid or empty state
                        if (_filtered.isEmpty)
                          EmptyState(message: 'No departments match "$_searchQuery"')
                        else
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: isWide ? 3 : 1,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: isWide ? 1.35 : 3.2,
                            ),
                            itemCount: _filtered.length,
                            itemBuilder: (_, i) => _DepartmentCard(
                              dept: _filtered[i],
                              onTap: () => Navigator.pushNamed(
                                context,
                                '/doctors',
                                arguments: {
                                  'departmentId': _filtered[i]['id'],
                                  'departmentName': _filtered[i]['name'],
                                },
                              ),
                              onEdit: () => _showDepartmentDialog(context, dept: _filtered[i]),
                              onDelete: () => _confirmDelete(context, _filtered[i]),
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
  void _showDepartmentDialog(BuildContext context, {Map<String, dynamic>? dept}) {
    final isEdit = dept != null;
    final nameCtrl = TextEditingController(text: dept?['name'] ?? '');
    final headCtrl = TextEditingController(text: dept?['head'] ?? '');
    final formKey = GlobalKey<FormState>();

    final iconOptions = <IconData>[
      Icons.favorite_rounded, Icons.psychology_rounded,
      Icons.accessibility_new_rounded, Icons.child_care_rounded,
      Icons.medical_services_rounded, Icons.spa_rounded,
      Icons.biotech_rounded, Icons.visibility_rounded,
      Icons.hearing_rounded, Icons.local_pharmacy_rounded,
    ];
    IconData selectedIcon = dept?['icon'] ?? Icons.medical_services_rounded;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: AppColors.lightGreen.withOpacity(0.3), borderRadius: BorderRadius.circular(8)),
              child: Icon(Icons.account_tree_rounded, color: AppColors.primaryGreen, size: 20),
            ),
            const SizedBox(width: 10),
            Text(isEdit ? 'Edit Department' : 'Add Department',
                style: GoogleFonts.playfairDisplay(fontSize: 20, fontWeight: FontWeight.w700)),
          ]),
          content: SizedBox(
            width: 440,
            child: Form(
              key: formKey,
              child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                TextFormField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Department Name',
                    prefixIcon: Icon(Icons.account_tree_rounded, color: AppColors.mediumGreen, size: 20),
                  ),
                  validator: (v) => v == null || v.isEmpty ? 'Enter department name' : null,
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: headCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Department Head',
                    prefixIcon: Icon(Icons.person_rounded, color: AppColors.mediumGreen, size: 20),
                  ),
                  validator: (v) => v == null || v.isEmpty ? 'Enter head doctor name' : null,
                ),
                const SizedBox(height: 16),
                Text('Department Icon', style: GoogleFonts.dmSans(fontSize: 13, color: AppColors.mutedText)),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: iconOptions.map((icon) => GestureDetector(
                    onTap: () => setDState(() => selectedIcon = icon),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: selectedIcon == icon ? AppColors.primaryGreen : AppColors.surfaceWhite,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: selectedIcon == icon ? AppColors.primaryGreen : AppColors.borderColor),
                      ),
                      child: Icon(icon, size: 20, color: selectedIcon == icon ? AppColors.white : AppColors.mutedText),
                    ),
                  )).toList(),
                ),
              ]),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  setState(() {
                    if (isEdit) {
                      dept!['name'] = nameCtrl.text;
                      dept['head'] = headCtrl.text;
                      dept['icon'] = selectedIcon;
                    } else {
                      _departments.add({
                        'id': 'd${_departments.length + 1}',
                        'name': nameCtrl.text,
                        'head': headCtrl.text,
                        'doctors': 0,
                        'patients': 0,
                        'icon': selectedIcon,
                      });
                    }
                  });
                  Navigator.pop(ctx);
                }
              },
              child: Text(isEdit ? 'Save Changes' : 'Add Department'),
            ),
          ],
        ),
      ),
    );
  }

  // ── Delete confirm ────────────────────────────────────────────────────────
  void _confirmDelete(BuildContext context, Map<String, dynamic> dept) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Delete ${dept['name']}?',
            style: GoogleFonts.dmSans(fontSize: 17, fontWeight: FontWeight.w600, color: AppColors.darkText)),
        content: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('This will permanently remove the department and all its associated data.',
              style: GoogleFonts.dmSans(fontSize: 13, color: AppColors.mutedText, height: 1.5)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: AppColors.errorRed.withOpacity(0.07), borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.errorRed.withOpacity(0.2))),
            child: Row(children: [
              const Icon(Icons.warning_amber_rounded, color: AppColors.errorRed, size: 16),
              const SizedBox(width: 8),
              Expanded(child: Text('${dept['doctors']} doctors and ${dept['patients']} patients will be affected.',
                  style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.errorRed))),
            ]),
          ),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              setState(() => _departments.removeWhere((d) => d['id'] == dept['id']));
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.errorRed),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

// ── Department Card ───────────────────────────────────────────────────────────
class _DepartmentCard extends StatefulWidget {
  final Map<String, dynamic> dept;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _DepartmentCard({
    required this.dept,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<_DepartmentCard> createState() => _DepartmentCardState();
}

class _DepartmentCardState extends State<_DepartmentCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final d = widget.dept;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: _hovered ? AppColors.primaryGreen : AppColors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _hovered ? AppColors.primaryGreen : AppColors.borderColor),
            boxShadow: _hovered
                ? [BoxShadow(color: AppColors.cardShadow, blurRadius: 14, offset: const Offset(0, 4))]
                : [],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon + action buttons
              Row(children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: _hovered ? AppColors.white.withOpacity(0.2) : AppColors.lightGreen.withOpacity(0.35),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(d['icon'] as IconData,
                      color: _hovered ? AppColors.white : AppColors.primaryGreen, size: 22),
                ),
                const Spacer(),
                CardIconBtn(
                  icon: Icons.edit_outlined,
                  hovered: _hovered,
                  onTap: widget.onEdit,
                ),
                const SizedBox(width: 4),
                CardIconBtn(
                  icon: Icons.delete_outline_rounded,
                  hovered: _hovered,
                  onTap: widget.onDelete,
                ),
              ]),
              const SizedBox(height: 14),

              // Name + Head
              Text(d['name'],
                  style: GoogleFonts.dmSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: _hovered ? AppColors.white : AppColors.darkText)),
              const SizedBox(height: 4),
              Text(d['head'],
                  style: GoogleFonts.dmSans(
                      fontSize: 12,
                      color: _hovered ? AppColors.lightGreen : AppColors.mutedText)),
              const Spacer(),

              // Stats row
              Row(children: [
                MiniStat(
                  icon: Icons.medical_services_rounded,
                  value: '${d['doctors']}',
                  label: 'Doctors',
                  hovered: _hovered,
                ),
                const SizedBox(width: 16),
                MiniStat(
                  icon: Icons.people_alt_rounded,
                  value: '${d['patients']}',
                  label: 'Patients',
                  hovered: _hovered,
                ),
                const Spacer(),
                Icon(Icons.arrow_forward_ios_rounded,
                    size: 13,
                    color: _hovered ? AppColors.white.withOpacity(0.7) : AppColors.borderColor),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}

class CardIconBtn extends StatelessWidget {
  final IconData icon;
  final bool hovered;
  final VoidCallback onTap;
  const CardIconBtn({required this.icon, required this.hovered, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: hovered ? AppColors.white.withOpacity(0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon,
            size: 16,
            color: hovered ? AppColors.white.withOpacity(0.8) : AppColors.mutedText),
      ),
    );
  }
}

class MiniStat extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final bool hovered;
  const MiniStat({required this.icon, required this.value, required this.label, required this.hovered});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Icon(icon, size: 13, color: hovered ? AppColors.lightGreen : AppColors.mediumGreen),
      const SizedBox(width: 4),
      Text('$value $label',
          style: GoogleFonts.dmSans(
              fontSize: 11,
              color: hovered ? AppColors.lightGreen : AppColors.mutedText)),
    ]);
  }
}




