import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

const List<String> kSortOptions = ['Last Visited', 'Name (A-Z)', 'Recently Added'];
const List<String> kConditionOptions = [
  'All Conditions',
  'Hypertension',
  'Type 2 Diabetes',
  'Post-Op Follow-up',
  'General Checkup',
];

class PatientFilterBar extends StatefulWidget {
  final String initialQuery;
  final String sortBy;
  final String condition;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String> onSortChanged;
  final ValueChanged<String> onConditionChanged;
  final VoidCallback onApplyFilters;

  const PatientFilterBar({
    super.key,
    required this.initialQuery,
    required this.sortBy,
    required this.condition,
    required this.onSearchChanged,
    required this.onSortChanged,
    required this.onConditionChanged,
    required this.onApplyFilters,
  });

  @override
  State<PatientFilterBar> createState() => _PatientFilterBarState();
}

class _PatientFilterBarState extends State<PatientFilterBar> {
  late final TextEditingController _controller =
      TextEditingController(text: widget.initialQuery);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
          Expanded(
            child: TextField(
              controller: _controller,
              onChanged: widget.onSearchChanged,
              onSubmitted: (_) => widget.onApplyFilters(),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Search by name, patient ID, or diagnosis',
              ),
            ),
          ),
          _FilterDropdown(
            icon: Icons.filter_list_rounded,
            value: widget.sortBy,
            options: kSortOptions,
            onChanged: widget.onSortChanged,
          ),
          const SizedBox(width: 12),
          _FilterDropdown(
            icon: Icons.monitor_heart_outlined,
            value: widget.condition,
            options: kConditionOptions,
            onChanged: widget.onConditionChanged,
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: widget.onApplyFilters,
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
  final String value;
  final List<String> options;
  final ValueChanged<String> onChanged;

  const _FilterDropdown({
    required this.icon,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: AppColors.textSecondary),
        const SizedBox(width: 6),
        DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: value,
            items: options
                .map((o) => DropdownMenuItem(value: o, child: Text(o)))
                .toList(),
            onChanged: (v) {
              if (v != null) onChanged(v);
            },
            style: const TextStyle(fontWeight: FontWeight.w500, color: AppColors.textPrimary),
            icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textSecondary),
          ),
        ),
        const SizedBox(width: 4),
        Container(width: 1, height: 20, color: AppColors.divider),
        const SizedBox(width: 4),
      ],
    );
  }
}
