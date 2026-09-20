// presentation/doctor_dashboard/widgets/doctor_card.dart
import 'package:flutter/material.dart';

class DoctorProfile {
  final String name, role, specialty, cabin, wait;
  final int pending;
  final bool inClinic, emergency;

  const DoctorProfile({
    required this.name,
    required this.role,
    required this.specialty,
    required this.cabin,
    required this.wait,
    required this.pending,
    this.inClinic = true,
    this.emergency = false,
  });
}

class DoctorCard extends StatelessWidget {
  final DoctorProfile doctor;
  final VoidCallback onTap;

  const DoctorCard({super.key, required this.doctor, required this.onTap});

  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF00796B);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: green, width: 5)),
          ),
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                const CircleAvatar(
                  radius: 21,
                  child: Icon(Icons.person_outline),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(doctor.name,
                          style: const TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 16)),
                      Text(doctor.role,
                          style: const TextStyle(
                              color: Colors.blueGrey, fontSize: 12)),
                      Text(doctor.specialty,
                          style: const TextStyle(color: green, fontSize: 12)),
                    ],
                  ),
                ),
              ]),
              const SizedBox(height: 14),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                color: const Color(0xFFF0F3FF),
                child: Row(children: [
                  const Icon(Icons.door_front_door_outlined, size: 16),
                  const SizedBox(width: 5),
                  Text('Cabin ${doctor.cabin}',
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  const Spacer(),
                  const Text('Floor 4 • Wing B', style: TextStyle(fontSize: 11)),
                ]),
              ),
              const SizedBox(height: 10),
              Row(children: [
                _status(doctor.emergency
                    ? 'Emergency OT'
                    : doctor.inClinic
                        ? 'In Clinic'
                        : 'In Rounds'),
                const Spacer(),
                Text('${doctor.pending} Pending',
                    style: const TextStyle(color: Colors.red, fontSize: 12)),
              ]),
              const Divider(height: 22),
              Row(children: [
                Text('◷ Avg ${doctor.wait}',
                    style: const TextStyle(fontSize: 12, color: Colors.blueGrey)),
                const Spacer(),
                const Text('Open Queue  →',
                    style: TextStyle(color: green, fontWeight: FontWeight.bold)),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _status(String value) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFFDFF7ED),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text('● $value',
            style: const TextStyle(
                color: Color(0xFF00796B), fontSize: 11, fontWeight: FontWeight.w600)),
      );
}