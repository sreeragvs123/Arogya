import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Small palette additions used only within the patients feature.
/// Move these into AppColors if you want them shared elsewhere.
class _PatientColors {
  static const statCardBackground = Color(0xFFEEF0FC);
  static const growthChipBackground = Color(0xFFDDF3E4);
  static const growthChipText = Color(0xFF1E8E4F);
}

class PatientsHeaderSection extends StatelessWidget {
  final int totalPatients;
  final String totalPatientsGrowth;
  final int newThisMonth;

  const PatientsHeaderSection({
    super.key,
    required this.totalPatients,
    required this.totalPatientsGrowth,
    required this.newThisMonth,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'MEDICAL RECORDS',
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.6,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Patient Directory',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Manage and monitor your patient panel. Access clinical '
                'workspaces, review longitudinal data, and coordinate '
                'follow-up care for $totalPatients active records.',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 20),
        Column(
          children: [
            Row(
              children: [
                _StatCard(
                  icon: Icons.groups_outlined,
                  value: '$totalPatients',
                  label: 'Total Patients',
                  growth: totalPatientsGrowth,
                ),
                const SizedBox(width: 16),
                _StatCard(
                  icon: Icons.person_add_alt_1_outlined,
                  value: '$newThisMonth',
                  label: 'New This Month',
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final String? growth;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    this.growth,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _PatientColors.statCardBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: AppColors.primary, size: 20),
              if (growth != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: _PatientColors.growthChipBackground,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    growth!,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: _PatientColors.growthChipText,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            value,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(fontSize: 12.5, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
