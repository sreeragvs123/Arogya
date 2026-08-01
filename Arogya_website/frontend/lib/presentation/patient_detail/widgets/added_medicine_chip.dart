import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class AddedMedicine {
  final String name;
  final String dosageSchedule; // e.g. "1-0-1 • After Food"

  const AddedMedicine({required this.name, required this.dosageSchedule});
}

class AddedMedicineChip extends StatelessWidget {
  final AddedMedicine medicine;
  final VoidCallback onRemove;

  const AddedMedicineChip({super.key, required this.medicine, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(medicine.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5)),
                const SizedBox(height: 2),
                Text(medicine.dosageSchedule,
                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
          ),
          InkWell(
            onTap: onRemove, // TODO: remove medicine from prescription draft
            child: const Icon(Icons.close_rounded, size: 18, color: Color(0xFFC24A2E)),
          ),
        ],
      ),
    );
  }
}
