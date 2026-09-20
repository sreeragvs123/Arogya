import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/entities/patient_detail/patient_detail_entity.dart';

class AddedMedicineChip extends StatelessWidget {
  final PrescriptionItemEntity medicine;
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
                Text(medicine.displayName,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5)),
                const SizedBox(height: 2),
                Text(medicine.displaySchedule,
                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
          ),
          InkWell(
            onTap: onRemove,
            child: const Icon(Icons.close_rounded, size: 18, color: Color(0xFFC24A2E)),
          ),
        ],
      ),
    );
  }
}
