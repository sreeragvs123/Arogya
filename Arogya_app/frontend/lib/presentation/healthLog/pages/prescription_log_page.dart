import 'package:flutter/material.dart';

class PrescriptionLog extends StatefulWidget {
  const PrescriptionLog({super.key});

  @override
  State<PrescriptionLog> createState() => _PrescriptionLogState();
}

class _PrescriptionLogState extends State<PrescriptionLog> {
  Widget _prescriptionCard({
    required String department,
    required String doctor,
    required String date,
    required String diagnosis,
    required String status,
    required Color statusColor,
    required String buttonText,
    required Color buttonColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                department,
                style: TextStyle(
                  color: Colors.green.shade700,
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              ),

              const Spacer(),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Text(
            doctor,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
              const SizedBox(width: 8),
              Text(date, style: const TextStyle(color: Colors.grey)),
            ],
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              const Icon(
                Icons.medical_information_outlined,
                size: 16,
                color: Colors.grey,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  diagnosis,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),

          const SizedBox(height: 22),

          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {},
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "View Details",
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 6),
                  Icon(Icons.arrow_forward, color: Colors.green, size: 18),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterChip(String text, bool selected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      decoration: BoxDecoration(
        color: selected ? Colors.green.shade100 : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: selected ? Colors.green.shade800 : Colors.black54,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 10),

          const Text(
            "Digital Scripts",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 4),

          const Text(
            "Manage and view your active medical prescriptions.",
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),

          const SizedBox(height: 20),

          // Search Bar
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: const Row(
              children: [
                Icon(Icons.search, color: Colors.grey),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Search by doctor or diagnosis...",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _filterChip("All Hospitals", true),

                const SizedBox(width: 10),

                _filterChip("Recent", false),

                const SizedBox(width: 10),

                _filterChip("Chronic", false),
              ],
            ),
          ),

          const SizedBox(height: 25),

          const Row(
            children: [
              Icon(Icons.local_hospital, color: Colors.green, size: 20),
              SizedBox(width: 8),
              Text(
                "City General Hospital",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),

          const SizedBox(height: 18),

          _prescriptionCard(
            department: "CARDIOLOGY",
            doctor: "Dr. Elena Rodriguez",
            date: "October 24, 2023",
            diagnosis: "Hypertension Management",
            status: "ACTIVE",
            statusColor: Colors.green,
            buttonText: "View Details",
            buttonColor: Colors.green.shade100,
          ),

          const SizedBox(height: 16),

          _prescriptionCard(
            department: "ENDOCRINOLOGY",
            doctor: "Dr. Marcus Chen",
            date: "September 12, 2023",
            diagnosis: "Type 2 Diabetes Follow-up",
            status: "ACTIVE",
            statusColor: Colors.green,
            buttonText: "View Details",
            buttonColor: Colors.green.shade100,
          ),

          const SizedBox(height: 28),

          const Row(
            children: [
              Icon(Icons.local_hospital, color: Colors.green, size: 20),
              SizedBox(width: 8),
              Text(
                "St. Jude Wellness Center",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),

          const SizedBox(height: 18),

          _prescriptionCard(
            department: "DERMATOLOGY",
            doctor: "Dr. Sarah Jenkins",
            date: "August 05, 2023",
            diagnosis: "Acute Contact Dermatitis",
            status: "COMPLETED",
            statusColor: Colors.grey,
            buttonText: "View Details",
            buttonColor: Color(0xffF4F4F4),
          ),

          const SizedBox(height: 35),

          _uploadScriptCard(),

          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _uploadScriptCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.green.shade200,
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: Colors.green.shade100,
            child: const Icon(
              Icons.note_add_outlined,
              color: Colors.green,
              size: 34,
            ),
          ),

          const SizedBox(height: 18),

          const Text(
            "Upload a New Script?",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 12),

          const Text(
            "Have a physical prescription you'd like\n"
            "to digitize? Upload it to your Arogya\n"
            "health vault.",
            style: TextStyle(color: Colors.grey, height: 1.5),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 26),

          SizedBox(
            width: 170,
            height: 50,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                "Digitize Script",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
