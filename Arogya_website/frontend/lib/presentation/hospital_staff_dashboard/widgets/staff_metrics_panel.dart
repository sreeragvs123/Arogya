import 'package:flutter/material.dart';


class StaffMetricsPanel extends StatelessWidget {
final int total;
const StaffMetricsPanel({super.key, required this.total});

  @override
  Widget build(BuildContext context) {


    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          width: 260,
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              colors: [Color(0xFF0F766E), Color(0xFF14B8A6)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.groups_2_rounded, color: Colors.white70, size: 26),
              const SizedBox(height: 18),
              Text('$total',
                  style: const TextStyle(fontSize: 44, fontWeight: FontWeight.w800, color: Colors.white)),
              const Text('Support staff on roster',
                  style: TextStyle(color: Colors.white70, fontSize: 13)),
              const SizedBox(height: 6),
const Text('Registered in this hospital',
    style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        const SizedBox(width: 16),

      ],
    );
  }
}