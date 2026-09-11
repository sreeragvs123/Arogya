import 'package:flutter/material.dart';

class HospitalMetricsRow extends StatelessWidget {
  final int affiliatedDoctors;
  final int activeDutyToday;
  final int credentialReviewCount;
  final int clinicalSpecialtiesCount;

  const HospitalMetricsRow({
    super.key,
    required this.affiliatedDoctors,
    required this.activeDutyToday,
    required this.credentialReviewCount,
    required this.clinicalSpecialtiesCount,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double itemWidth = (constraints.maxWidth - (3 * 16)) / 4;

        return Row(
          children: [
            _buildMetricCard(
              width: itemWidth,
              title: 'TOTAL HOSPITAL STAFF',
              value: '$affiliatedDoctors',
              footnote: 'Across all wards',
              icon: Icons.local_hospital_rounded,
              iconColor: const Color(0xFF2563EB),
            ),
            const SizedBox(width: 16),
            _buildMetricCard(
              width: itemWidth,
              title: 'ACTIVE ON DUTY',
              value: '$activeDutyToday',
              footnote: 'Assigned to OPD & wards',
              icon: Icons.medical_services_outlined,
              iconColor: const Color(0xFF0284C7),
            ),
            const SizedBox(width: 16),
            _buildMetricCard(
              width: itemWidth,
              title: 'PENDING REVIEWS',
              value: credentialReviewCount < 10 ? '0$credentialReviewCount' : '$credentialReviewCount',
              footnote: 'Hospital credential renewals',
              icon: Icons.verified_user_outlined,
              iconColor: const Color(0xFFD97706),
            ),
            const SizedBox(width: 16),
            _buildMetricCard(
              width: itemWidth,
              title: 'HOSPITAL SPECIALTIES',
              value: '$clinicalSpecialtiesCount',
              footnote: 'Departments & Wings',
              icon: Icons.apartment_outlined,
              iconColor: const Color(0xFF0F766E),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMetricCard({
    required double width,
    required String title,
    required String value,
    required String footnote,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x05000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                  color: Color(0xFF94A3B8),
                ),
              ),
              Icon(icon, size: 18, color: iconColor),
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
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(width: 10),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            footnote,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }
}
