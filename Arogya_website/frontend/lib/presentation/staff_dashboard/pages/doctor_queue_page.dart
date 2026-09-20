
import 'package:flutter/material.dart';
import '../widgets/doctor_card.dart';

class DoctorQueuePage extends StatelessWidget {
  final DoctorProfile doctor;
  const DoctorQueuePage({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    final patients = [
      ('#REG-0941', 'Rameshwar Prasad', 'Male, 54 yrs', 'Chest heaviness on exertion; referred for urgent stress ECG evaluation.', '11:30 AM'),
      ('#REG-0948', 'Anitha Deshmukh', 'Female, 42 yrs', 'Post-angioplasty 3-month review; intermittent dizziness on standing.', '11:45 AM'),
      ('#REG-0952', 'Vikram Malhotra', 'Male, 61 yrs', 'Recurrent palpitations and premature ventricular contractions.', '12:00 PM'),
      ('#REG-0960', 'Sunita Iyer', 'Male, 48 yrs', 'Routine BP monitoring and prescription continuation.', '12:15 PM'),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Back to Department Doctors'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(children: [
          _doctorHeader(),
          const SizedBox(height: 16),
          _tabs(),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.separated(
              itemCount: patients.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, index) => _patientCard(index + 1, patients[index]),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _doctorHeader() => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
        child: Row(children: [
          const CircleAvatar(radius: 30, child: Icon(Icons.person, size: 32)),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(doctor.name, style: const TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
            Text('${doctor.role} • ${doctor.specialty}'),
            const SizedBox(height: 6),
            Text('▦ Room ${doctor.cabin}, Block B, Floor 4   •   Ext: 4402   •   09:00 AM - 04:00 PM',
                style: const TextStyle(fontSize: 12)),
          ])),
          Container(
            padding: const EdgeInsets.all(12),
            color: const Color(0xFFDFF7ED),
            child: const Text('● IN CLINIC CONSULTATIONS\nCurrently Seeing: Token #08',
                style: TextStyle(fontSize: 12, color: Color(0xFF00695C))),
          ),
        ]),
      );

  Widget _tabs() => Container(
        padding: const EdgeInsets.all(8),
        color: Colors.white,
        child: const Row(children: [
          Chip(label: Text('Pending   4')),
          SizedBox(width: 12),
          Chip(label: Text('Confirmed   14')),
          SizedBox(width: 12),
          Chip(label: Text('Finished   8')),
          SizedBox(width: 12),
          Chip(label: Text('Cancelled   2')),
          Spacer(),
          Text('Queue Sequence: Priority & Time', style: TextStyle(fontSize: 11)),
        ]),
      );

  Widget _patientCard(int token, (String, String, String, String, String) p) => Card(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Chip(label: Text('#$token Queue')),
              const SizedBox(width: 8),
              Text('${p.$1}  Registered: 08:${10 + token * 9} AM',
                  style: const TextStyle(fontSize: 12)),
              const Spacer(),
              Chip(label: Text(p.$5)),
            ]),
            Text(p.$2, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            Text(p.$3),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              color: const Color(0xFFF7F8FC),
              child: Text('Chief Complaint: ${p.$4}', style: const TextStyle(fontSize: 12)),
            ),
            const SizedBox(height: 8),
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              OutlinedButton(onPressed: () {}, child: const Text('Reject / Re-route')),
              const SizedBox(width: 8),
              ElevatedButton(onPressed: () {}, child: const Text('✓ Accept & Assign Token')),
            ]),
          ]),
        ),
      );
}