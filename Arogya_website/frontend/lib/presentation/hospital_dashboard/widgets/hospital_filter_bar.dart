// presentation/hospital_dashboard/widgets/hospital_filter_bar.dart
import 'package:flutter/material.dart';

class HospitalFilterBar extends StatelessWidget {
  final String searchQuery;
  final ValueChanged<String> onSearchChanged;
  final String activeTab;
  final ValueChanged<String> onTabChanged;
  final String selectedDepartment;
  final ValueChanged<String> onDepartmentChanged;
  final List<String> specializations;

  const HospitalFilterBar({
    super.key,
    required this.searchQuery,
    required this.onSearchChanged,
    required this.activeTab,
    required this.onTabChanged,
    required this.selectedDepartment,
    required this.onDepartmentChanged,
    required this.specializations,
  });

  @override
  Widget build(BuildContext context) {
    final dropdownValue =
        specializations.contains(selectedDepartment) ? selectedDepartment : specializations.first;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(color: Color(0x04000000), blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: TextField(
              onChanged: onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search hospital staff, licenses, departments...',
                hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                prefixIcon: const Icon(Icons.search, size: 20, color: Color(0xFF94A3B8)),
                filled: true,
                fillColor: const Color(0xFFF1F5F9),
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
              style: const TextStyle(fontSize: 13, color: Color(0xFF0F172A)),
            ),
          ),
          const SizedBox(width: 16),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              children: [
                _buildTab('all', 'All Staff'),
                _buildTab('active', 'Active Duty'),
                _buildTab('on_call', 'On Call'),
                _buildTab('pending', 'Provisioning'),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFCBD5E1)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: dropdownValue,
                icon: const Icon(Icons.keyboard_arrow_down, size: 18, color: Color(0xFF64748B)),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF334155),
                ),
                onChanged: (newVal) {
                  if (newVal != null) onDepartmentChanged(newVal);
                },
                items: specializations.map((dept) {
                  return DropdownMenuItem<String>(value: dept, child: Text(dept));
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String tabKey, String label) {
    final bool isSelected = activeTab == tabKey;
    return GestureDetector(
      onTap: () => onTabChanged(tabKey),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          boxShadow: isSelected
              ? [const BoxShadow(color: Color(0x0C000000), blurRadius: 4, offset: Offset(0, 1))]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? const Color(0xFF1D4ED8) : const Color(0xFF64748B),
          ),
        ),
      ),
    );
  }
}