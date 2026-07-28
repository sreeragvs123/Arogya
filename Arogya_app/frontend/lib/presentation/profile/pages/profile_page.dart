import "package:flutter/material.dart";
import "package:frontend/presentation/profile/pages/profile_edit_page.dart";

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final profileImage = const AssetImage("assets/images/sreerag.jpg");
  final patientName = "Arjun Vardhan";
  final userName = "@arjun_v_health";
  final age = 34;
  final gender = "Male";
  final bloodGroup = "O+";

  // Accent Colors matching the design
  static const Color primaryGreen = Color(0xFF0D7A31);
  static const Color cardBg = Colors.white;
  static const Color pageBg = Color(0xFFF7F9F8);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pageBg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileCard(),
              const SizedBox(height: 24),
              _buildMetricsHeader(),
              const SizedBox(height: 12),
              _buildHealthMetricCard(
                icon: Icons.water_drop_outlined,
                iconBgColor: const Color(0xFFE8F5E9),
                iconColor: const Color(0xFF2E7D32),
                value: "98",
                unit: "mg/dL",
                label: "Sugar Level",
                statusText: "Normal",
                statusBgColor: const Color(0xFFE8F5E9),
                statusTextColor: const Color(0xFF2E7D32),
                lastUpdated: "2 hrs ago",
              ),
              _buildHealthMetricCard(
                icon: Icons.favorite_border,
                iconBgColor: const Color(0xFFFFEBEE),
                iconColor: const Color(0xFFC62828),
                value: "138/92",
                unit: "mmHg",
                label: "Blood Pressure",
                statusText: "High",
                statusBgColor: const Color(0xFFFFEBEE),
                statusTextColor: const Color(0xFFC62828),
                lastUpdated: "4 hrs ago",
              ),
              _buildHealthMetricCard(
                icon: Icons.scale_outlined,
                iconBgColor: const Color(0xFFE8F5E9),
                iconColor: const Color(0xFF2E7D32),
                value: "74.5",
                unit: "kg",
                label: "Weight",
                lastUpdated: "Yesterday",
              ),
              _buildHealthMetricCard(
                icon: Icons.height,
                iconBgColor: const Color(0xFFE8F5E9),
                iconColor: const Color(0xFF2E7D32),
                value: "178",
                unit: "cm",
                label: "Height",
                lastUpdated: "Jan 12, 2024",
              ),
              _buildHealthMetricCard(
                icon: Icons.science_outlined,
                iconBgColor: const Color(0xFFFFF3E0),
                iconColor: const Color(0xFFEF6C00),
                value: "205",
                unit: "mg/dL",
                label: "Cholesterol",
                statusText: "Borderline",
                statusBgColor: const Color(0xFFFFF3E0),
                statusTextColor: const Color(0xFFEF6C00),
                lastUpdated: "1 week ago",
              ),
              const SizedBox(height: 8),
              _buildLogNewMetricTile(),
              const SizedBox(height: 16),
              _buildTrendSummaryCard(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // --- Profile Card ---
  Widget _buildProfileCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: primaryGreen.withOpacity(0.15),
                  blurRadius: 16,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 46,
              backgroundColor: const Color(0xFFEFEFEF),
              backgroundImage: profileImage,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            patientName,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: Color(0xFF1E1E1E),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            userName,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _metricSquare(type: "Age", value: "$age"),
              const SizedBox(width: 12),
              _metricSquare(type: "Blood Group", value: bloodGroup),
            ],
          ),
          const SizedBox(height: 10),
          _metricSquare(
            type: "Gender",
            value: gender,
            valueColor: primaryGreen,
            width: 110,
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileEditPage()),
              );
            },
            icon: const Icon(Icons.edit, size: 16, color: Colors.white),
            label: const Text(
              "Edit Profile",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryGreen,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _metricSquare({
    required String type,
    required String value,
    Color? valueColor,
    double width = 90,
  }) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F3F2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            type,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: valueColor ?? Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  // --- Section Header ---
  Widget _buildMetricsHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                border: Border.all(color: primaryGreen, width: 1.5),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(Icons.check, size: 12, color: primaryGreen),
            ),
            const SizedBox(width: 8),
            const Text(
              "Health Metrics",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E1E1E),
              ),
            ),
          ],
        ),
        TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(padding: EdgeInsets.zero),
          child: const Text(
            "View History",
            style: TextStyle(
              color: primaryGreen,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  // --- Health Metric Cards ---
  Widget _buildHealthMetricCard({
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String value,
    required String unit,
    required String label,
    String? statusText,
    Color? statusBgColor,
    Color? statusTextColor,
    required String lastUpdated,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              if (statusText != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusBgColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    statusText,
                    style: TextStyle(
                      color: statusTextColor,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E1E1E),
                ),
              ),
              const SizedBox(width: 4),
              Text(
                unit,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2C2C2C),
            ),
          ),
          const SizedBox(height: 12),
          Divider(height: 1, color: Colors.grey.shade200),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.access_time, size: 14, color: Colors.grey.shade500),
              const SizedBox(width: 4),
              Text(
                "Last updated: $lastUpdated",
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- Log New Metric Tile ---
  Widget _buildLogNewMetricTile() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: const Color(0xFFECF5EE),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFC8E6C9), width: 1),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: primaryGreen,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.add, color: Colors.white, size: 24),
          ),
          const SizedBox(height: 10),
          const Text(
            "Log New Metric",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: primaryGreen,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Keep your health tracking up to date",
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  // --- Health Trend Summary Chart ---
  Widget _buildTrendSummaryCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Health Trend Summary",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E1E1E),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "A 30-day overview of your metabolic indicators",
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Avg. Sugar",
                    style: TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                  SizedBox(height: 2),
                  Text(
                    "102 mg/dL",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: primaryGreen,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 32),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Avg. Weight",
                    style: TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                  SizedBox(height: 2),
                  Text(
                    "74.2 kg",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: primaryGreen,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 120,
            width: double.infinity,
            child: CustomPaint(
              painter: SmoothLineChartPainter(),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text("Jan 01", style: TextStyle(fontSize: 10, color: Colors.grey)),
              Text("Jan 08", style: TextStyle(fontSize: 10, color: Colors.grey)),
              Text("Jan 15", style: TextStyle(fontSize: 10, color: Colors.grey)),
              Text("Jan 22", style: TextStyle(fontSize: 10, color: Colors.grey)),
              Text("Jan 30", style: TextStyle(fontSize: 10, color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }
}

// Custom Painter for rendering the smooth gradient line chart
class SmoothLineChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Path path = Path();
    final width = size.width;
    final height = size.height;

    path.moveTo(0, height * 0.7);
    path.cubicTo(
      width * 0.15, height * 0.4,
      width * 0.2, height * 0.9,
      width * 0.35, height * 0.8,
    );
    path.cubicTo(
      width * 0.5, height * 0.2,
      width * 0.6, height * 1.0,
      width * 0.7, height * 0.9,
    );
    path.cubicTo(
      width * 0.8, height * 0.1,
      width * 0.9, height * 0.1,
      width, height * 0.8,
    );

    final Path fillPath = Path.from(path)
      ..lineTo(width, height)
      ..lineTo(0, height)
      ..close();

    final Paint fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFF0D7A31).withOpacity(0.25),
          const Color(0xFF0D7A31).withOpacity(0.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, width, height));

    canvas.drawPath(fillPath, fillPaint);

    final Paint strokePaint = Paint()
      ..color = const Color(0xFF0D7A31)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    canvas.drawPath(path, strokePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}