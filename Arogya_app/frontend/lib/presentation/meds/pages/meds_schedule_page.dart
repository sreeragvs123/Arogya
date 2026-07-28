import "package:flutter/material.dart";

class MedsSchedulePage extends StatefulWidget {
  const MedsSchedulePage({super.key});

  @override
  State<MedsSchedulePage> createState() => _MedsSchedulePageState();
}

class _MedsSchedulePageState extends State<MedsSchedulePage> {
  Widget MedicationTimelineCard({
    required String time,
    required String medicine,
    required String dosage,
    required String purpose,
    required String status,
    required Color color,
    String? buttonText,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Time
          SizedBox(
            width: 75,
            child: Text(
              time,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),

          const SizedBox(width: 12),

          /// Timeline Indicator
          Column(
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              Container(
                width: 2,
                height: buttonText == null ? 70 : 110,
                color: Colors.grey.shade300,
              ),
            ],
          ),

          const SizedBox(width: 16),

          /// Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  medicine,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                Text(dosage, style: const TextStyle(color: Colors.grey)),

                const SizedBox(height: 10),

                Row(
                  children: [
                    const Icon(
                      Icons.favorite_border,
                      size: 18,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        purpose,
                        style: const TextStyle(color: Colors.black87),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: color.withOpacity(.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),

                    const Spacer(),

                    if (buttonText != null)
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: color,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: Text(buttonText),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _header() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          "Thursday, Oct 24, 2024",
          style: TextStyle(color: Colors.grey, fontSize: 13),
        ),

        SizedBox(height: 6),

        Text(
          "Medication Schedule",
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _supplyMonitoring() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _boxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Supply Monitoring",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),

          const SizedBox(height: 16),

          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text("Lisinopril"),
            subtitle: const Text("4 doses remaining"),
            trailing: ElevatedButton(
              onPressed: () {},
              child: const Text("Order Refill"),
            ),
          ),

          const Divider(),

          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text("Metformin ER"),
            subtitle: const Text("12 doses remaining"),
            trailing: OutlinedButton(
              onPressed: () {},
              child: const Text("View Details"),
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(.05),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  Widget _dailyProgress() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _boxDecoration(),
      child: Row(
        children: [
          SizedBox(
            width: 55,
            height: 55,
            child: Stack(
              alignment: Alignment.center,
              children: const [
                CircularProgressIndicator(value: .66, color: Colors.green),
                Text("2/6", style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),

          const SizedBox(width: 16),

          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Daily Progress",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                ),

                SizedBox(height: 4),

                Text(
                  "4 doses remaining for today",
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statCard(IconData icon, String title, String value, Color iconColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: iconColor.withOpacity(.12),
              child: Icon(icon, color: iconColor, size: 18),
            ),

            const SizedBox(height: 12),

            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),

            const SizedBox(height: 6),

            Text(
              value,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _quickStats() {
    return Row(
      children: [
        Expanded(
          child: _statCard(Icons.alarm, "Next Dose", "12:30 PM", Colors.green),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: _statCard(
            Icons.priority_high,
            "Missed Today",
            "01 Dose",
            Colors.red,
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: _statCard(
            Icons.check_circle,
            "Adherence",
            "94%",
            Colors.green,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _header(),

            const SizedBox(height: 16),

            _dailyProgress(),

            const SizedBox(height: 16),

            _quickStats(),

            const SizedBox(height: 20),

            const Text(
              "Timeline",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            MedicationTimelineCard(
              time: "04:00 PM",
              medicine: "Multivitamin",
              dosage: "1 Capsule",
              purpose: "Dietary Supplement",
              status: "Scheduled",
              color: Colors.grey,
            ),

            const SizedBox(height: 14),

            MedicationTimelineCard(
              time: "12:30 PM",
              medicine: "Atorvastatin",
              dosage: "20mg Tablet",
              purpose: "Cholesterol Control",
              status: "Upcoming",
              color: Colors.green,
              buttonText: "Mark as Taken",
            ),

            const SizedBox(height: 14),

            MedicationTimelineCard(
              time: "10:00 AM",
              medicine: "Metformin ER",
              dosage: "500mg Tablet",
              purpose: "Blood Sugar",
              status: "Missed",
              color: Colors.red,
              buttonText: "Reschedule",
            ),

            const SizedBox(height: 14),

            MedicationTimelineCard(
              time: "08:00 AM",
              medicine: "Lisinopril",
              dosage: "10mg Tablet",
              purpose: "Heart Health",
              status: "Taken",
              color: Colors.green,
              buttonText: null,
            ),

            const SizedBox(height: 20),

            _supplyMonitoring(),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
