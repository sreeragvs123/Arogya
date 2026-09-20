import 'package:flutter/material.dart';
import 'package:frontend/domain/entities/auth/auth_session.dart';
import '../widgets/doctor_card.dart';
import 'doctor_queue_page.dart';

class DepartmentDoctorsPage extends StatefulWidget {
  final StaffSession session;

  const DepartmentDoctorsPage({super.key, required this.session});

  static const doctors = [
    DoctorProfile(name: 'Dr. Rajesh Koothrappali', role: 'MD, DM • Senior Consultant', specialty: 'Interventional Cardiology', cabin: '402', wait: '12m', pending: 7),
    DoctorProfile(name: 'Dr. Sunita Varma', role: 'DM (Card) • Senior Specialist', specialty: 'Electrophysiology & Arrhythmia', cabin: '405', wait: '15m', pending: 4),
    DoctorProfile(name: 'Dr. Arvind Seshadri', role: 'MD, FACC • Director', specialty: 'Heart Failure & Transplant', cabin: '401', wait: '20m', pending: 5, inClinic: false),
    DoctorProfile(name: 'Dr. Meenakshi Sundaram', role: 'DNB (Cardiology) • Specialist', specialty: 'Preventive & Non-Invasive', cabin: '406', wait: '10m', pending: 2),
    DoctorProfile(name: 'Dr. Siddharth Mukherjee', role: 'MD, MCh • Attending Surgeon', specialty: 'Cardiothoracic Liaison', cabin: '408', wait: '—', pending: 0, emergency: true),
    DoctorProfile(name: 'Dr. Priya Deshmukh', role: 'MD (Peds), FNB • Associate', specialty: 'Pediatric Cardiology', cabin: '403', wait: '18m', pending: 3),
  ];

  @override
  State<DepartmentDoctorsPage> createState() => _DepartmentDoctorsPageState();
}

class _DepartmentDoctorsPageState extends State<DepartmentDoctorsPage> {
  final _searchController = TextEditingController();

  String _specialtyFilter = 'All Specialties';
  String _statusFilter = 'All Statuses';

  static const _specialties = [
    'All Specialties',
    'Interventional Cardiology',
    'Electrophysiology & Arrhythmia',
    'Heart Failure & Transplant',
    'Preventive & Non-Invasive',
    'Cardiothoracic Liaison',
    'Pediatric Cardiology',
  ];

  static const _statuses = ['All Statuses', 'In Clinic', 'Away'];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<DoctorProfile> get _filteredDoctors {
    final query = _searchController.text.trim().toLowerCase();
    return DepartmentDoctorsPage.doctors.where((doctor) {
      final matchesQuery = query.isEmpty ||
          doctor.name.toLowerCase().contains(query) ||
          doctor.role.toLowerCase().contains(query) ||
          doctor.cabin.toLowerCase().contains(query);

      final matchesSpecialty =
          _specialtyFilter == 'All Specialties' || doctor.specialty == _specialtyFilter;

      final matchesStatus = _statusFilter == 'All Statuses' ||
          (_statusFilter == 'In Clinic' && doctor.inClinic) ||
          (_statusFilter == 'Away' && !doctor.inClinic);

      return matchesQuery && matchesSpecialty && matchesStatus;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredDoctors;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      appBar: AppBar(
        title: Text('${widget.session.department} - Medical Staff'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _departmentHeader(),
              const SizedBox(height: 18),
              Row(children: [
                Expanded(
                  flex: 3,
                  child: TextField(
                    controller: _searchController,
                    onChanged: (_) => setState(() {}),
                    decoration: const InputDecoration(
                      hintText: 'Search by doctor name, qualification, or OPD Cabin',
                      prefixIcon: Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(borderSide: BorderSide.none),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                _filter(
                  value: _specialtyFilter,
                  options: _specialties,
                  onChanged: (value) => setState(() => _specialtyFilter = value!),
                ),
                const SizedBox(width: 12),
                _filter(
                  value: _statusFilter,
                  options: _statuses,
                  onChanged: (value) => setState(() => _statusFilter = value!),
                ),
              ]),
              const SizedBox(height: 18),
              Expanded(
                child: filtered.isEmpty
                    ? const Center(child: Text('No doctors match your filters'))
                    : GridView.builder(
                        itemCount: filtered.length,
                        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 390,
                          mainAxisExtent: 168,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemBuilder: (_, index) => DoctorCard(
                          doctor: filtered[index],
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DoctorQueuePage(doctor: filtered[index]),
                            ),
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _departmentHeader() => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${widget.session.department} – Medical Staff On-Duty',
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '● Signed in as ${widget.session.staffName}',
              style: const TextStyle(color: Color(0xFF00796B), fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text('▦ ${widget.session.department}   •   Hospital ID: ${widget.session.hospitalId ?? '—'}'),
          ],
        ),
      );

  Widget _filter({
    required String value,
    required List<String> options,
    required ValueChanged<String?> onChanged,
  }) =>
      Expanded(
        child: DropdownButtonFormField<String>(
          value: value,
          items: options.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: onChanged,
          decoration: const InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderSide: BorderSide.none),
          ),
        ),
      );
}