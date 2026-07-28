import "package:flutter/material.dart";

class MedsDetailsPage extends StatefulWidget {
  const MedsDetailsPage({super.key});

  @override
  State<MedsDetailsPage> createState() => _MedsDetailsPageState();
}

class _MedsDetailsPageState extends State<MedsDetailsPage> {
  Widget _statusRow(
    IconData icon,
    Color color,
    String title,
    String time,
    String status,
  ) {
    return Row(
      children: [
        Icon(icon, color: color),
        const SizedBox(width: 12),
        Expanded(child: Text(title)),
        Text(time),
        const SizedBox(width: 12),
        Text(
          status,
          style: TextStyle(color: color, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _timeRow(String time) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 12,
            backgroundColor: Color(0xffE8F5E9),
            child: Icon(Icons.check, size: 15, color: Colors.green),
          ),
          const SizedBox(width: 12),
          Text(time, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Medicine"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
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
                children: [
                  Container(
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.medication,
                      color: Colors.green,
                      size: 35,
                    ),
                  ),

                  const SizedBox(width: 16),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.shade100,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            "ACTIVE",
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),

                        const Text(
                          "Amoxicillin",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),

                        const Text(
                          "Capsule",
                          style: TextStyle(color: Colors.grey),
                        ),

                        const SizedBox(height: 6),

                        const Text(
                          "500 mg",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Text(
                      "Mark as Taken",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // =======================
            // Today's Status
            // =======================
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.05),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Today's Status",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),

                  const SizedBox(height: 18),

                  _statusRow(
                    Icons.check_circle,
                    Colors.green,
                    "AM Dose",
                    "09:30 AM",
                    "Taken",
                  ),

                  const Divider(),

                  _statusRow(
                    Icons.calendar_today,
                    Colors.green,
                    "Lunch Dose",
                    "12:45 PM",
                    "Upcoming",
                  ),

                  const Divider(),

                  _statusRow(
                    Icons.schedule,
                    Colors.grey,
                    "PM Dose",
                    "09:00 PM",
                    "Scheduled",
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // =======================
            // Prescription
            // =======================
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.05),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Prescription",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),

                  const SizedBox(height: 20),

                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const CircleAvatar(child: Icon(Icons.person)),
                    title: const Text("Dr. Emma Rodriguez"),
                    subtitle: const Text("Primary Physician"),
                  ),

                  const Divider(),

                  const ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.calendar_month),
                    title: Text("Started Treatment"),
                    trailing: Text("May 5"),
                  ),

                  const Divider(),

                  const ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.refresh),
                    title: Text("Refills Remaining"),
                    trailing: Text("2"),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // =======================
            // Schedule
            // =======================
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.05),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Schedule & Instructions",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),

                  const SizedBox(height: 20),

                  _timeRow("08:30 AM"),
                  _timeRow("12:45 PM"),
                  _timeRow("09:30 PM"),

                  const Divider(),

                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.restaurant),
                    title: const Text("Take with Food"),
                  ),

                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.warning_amber, color: Colors.red),
                    title: const Text("Avoid Alcohol"),
                  ),

                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.water_drop),
                    title: const Text("Drink Plenty of Water"),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.05),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Adherence History (Last 7 Days)",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),

                  const SizedBox(height: 20),

                  LinearProgressIndicator(
                    value: .95,
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.green,
                  ),

                  const SizedBox(height: 12),

                  const Text(
                    "95% adherence",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
