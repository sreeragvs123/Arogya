import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class PatientFilterBar extends StatelessWidget {
  final VoidCallback onApplyFilters;

  const PatientFilterBar({super.key, required this.onApplyFilters});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: AppColors.textSecondary, size: 20),
          const SizedBox(width: 10),
          const Expanded(
            child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Search by name, patient ID, or diagnosis',
              ),
            ),
          ),
          _FilterDropdown(icon: Icons.filter_list_rounded, label: 'Last Visited'),
          const SizedBox(width: 12),
          _FilterDropdown(icon: Icons.monitor_heart_outlined, label: 'All Conditions'),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: onApplyFilters,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Apply Filters'),
          ),
        ],
      ),
    );
  }
}

class _FilterDropdown extends StatelessWidget {
  final IconData icon;
  final String label;

  const _FilterDropdown({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: AppColors.textSecondary),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textSecondary),
        const SizedBox(width: 4),
        Container(width: 1, height: 20, color: AppColors.divider),
        const SizedBox(width: 4),
      ],
    );
  }
}