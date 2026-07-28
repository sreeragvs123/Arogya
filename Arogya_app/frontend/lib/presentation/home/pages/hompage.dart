import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/common/medication_card.dart';
import 'package:frontend/presentation/home/bloc/home_bloc.dart';
import 'package:frontend/presentation/metric/bloodPressure/pages/blood_pressure_page.dart';
import 'package:frontend/presentation/metric/bloodSugar/pages/blood_sugar_page.dart';
import 'package:frontend/presentation/metric/weight/pages/weight_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String timeMessage = "Good Morning";
  final String nameMessage = "Sreerag";
  final String greetMessage =
      "Hope today is a good day for your health goals!";

  // Main Accent Theme Colors
  static const Color primaryGreen = Color(0xFF0D7A31);
  static const Color backgroundColor = Color(0xFFF7F9F8);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: BlocConsumer<HomeBloc, HomeState>(
          listener: (context, state) {},
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildGreetingCard(
                    timeText: timeMessage,
                    nameText: nameMessage,
                    greetingText: greetMessage,
                  ),
                  const SizedBox(height: 20),
                  const MedicationCard(),
                  const SizedBox(height: 24),
                  _buildSectionHeader(),
                  const SizedBox(height: 14),
                  _buildHealthMetricsGrid(context),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // --- 1. Top Greeting Card ---
  Widget _buildGreetingCard({
    required String timeText,
    required String nameText,
    required String greetingText,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    radius: 20,
                    backgroundColor: Color(0xFFE8F5E9),
                    child: Icon(Icons.person, color: primaryGreen),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "$timeText, 👋",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      Text(
                        nameText,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E1E1E),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F3F2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.calendar_today, size: 12, color: Colors.grey.shade700),
                    const SizedBox(width: 4),
                    Text(
                      "Today",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 16),
          Divider(height: 1, color: Colors.grey.shade200),
          const SizedBox(height: 12),
          Text(
            '"$greetingText"',
            style: TextStyle(
              fontSize: 14,
              fontStyle: FontStyle.italic,
              color: Colors.grey.shade600,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  // --- 2. Section Header ---
  Widget _buildSectionHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Health Snapshot",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E1E1E),
            letterSpacing: -0.3,
          ),
        ),
        TextButton.icon(
          onPressed: () {},
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          icon: const Text(
            "View Trends",
            style: TextStyle(
              color: primaryGreen,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          label: const Icon(
            Icons.arrow_forward_ios,
            size: 12,
            color: primaryGreen,
          ),
        ),
      ],
    );
  }

  // --- 3. Custom Health Metrics Grid ---
  Widget _buildHealthMetricsGrid(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 1.15,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      children: [
        _buildMetricItemCard(
          icon: Icons.water_drop_outlined,
          iconBgColor: const Color(0xFFE8F5E9),
          iconColor: const Color(0xFF2E7D32),
          title: 'Blood Sugar',
          value: '114',
          unit: 'mg/dL',
          statusText: 'STABLE',
          statusBgColor: const Color(0xFFE8F5E9),
          statusTextColor: const Color(0xFF2E7D32),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const BloodSugarPage()),
          ),
        ),
        _buildMetricItemCard(
          icon: Icons.favorite_border,
          iconBgColor: const Color(0xFFE3F2FD),
          iconColor: const Color(0xFF1565C0),
          title: 'Blood Pressure',
          value: '120/80',
          unit: 'mmHg',
          statusText: 'PERFECT',
          statusBgColor: const Color(0xFFE3F2FD),
          statusTextColor: const Color(0xFF1565C0),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const BloodPressurePage()),
          ),
        ),
        _buildMetricItemCard(
          icon: Icons.scale_outlined,
          iconBgColor: const Color(0xFFF5F5F5),
          iconColor: const Color(0xFF616161),
          title: 'Weight',
          value: '74.2',
          unit: 'kg',
          statusText: 'NO CHANGE',
          statusBgColor: const Color(0xFFEEEEEE),
          statusTextColor: const Color(0xFF616161),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const WeightPage()),
          ),
        ),
      ],
    );
  }

  // Individual Metric Card Widget
  Widget _buildMetricItemCard({
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String title,
    required String value,
    required String unit,
    required String statusText,
    required Color statusBgColor,
    required Color statusTextColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFEFEFEF)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusBgColor,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      statusText,
                      style: TextStyle(
                        color: statusTextColor,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        value,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E1E1E),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        unit,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}