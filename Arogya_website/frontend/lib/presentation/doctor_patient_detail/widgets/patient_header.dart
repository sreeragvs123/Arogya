import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class PatientHeader extends StatelessWidget {
  final String name;
  final String patientId;
  final String age;
  final String gender;
  final String bloodGroup;
  final String height;
  final String weight;
  final String? photoUrl;

  const PatientHeader({
    super.key,
    required this.name,
    required this.patientId,
    required this.age,
    required this.gender,
    required this.bloodGroup,
    required this.height,
    required this.weight,
    this.photoUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: photoUrl != null
                    ? DecorationImage(image: NetworkImage(photoUrl!), fit: BoxFit.cover)
                    : null,
                color: AppColors.softPanel,
              ),
              child: photoUrl == null
                  ? const Icon(Icons.person, size: 36, color: AppColors.textMuted)
                  : null,
            ),
            Positioned(
              right: -4,
              bottom: -4,
              child: Container(
                width: 26,
                height: 26,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Icon(Icons.verified_user_rounded, size: 13, color: Colors.white),
              ),
            ),
          ],
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.softPanel,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text('ID: $patientId',
                        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(name,
                  style: const TextStyle(fontFamily: 'Georgia', fontSize: 30, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.person_outline, size: 16, color: AppColors.textSecondary),
                  const SizedBox(width: 6),
                  Text('$age Years, $gender', style: const TextStyle(fontSize: 14, color: AppColors.textSecondary)),
                  const SizedBox(width: 20),
                  const Icon(Icons.water_drop_outlined, size: 16, color: Color(0xFFC24A2E)),
                  const SizedBox(width: 6),
                  Text(bloodGroup, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFFC24A2E))),
                  const SizedBox(width: 20),
                  const Icon(Icons.height_rounded, size: 16, color: AppColors.textSecondary),
                  const SizedBox(width: 6),
                  Text('$height / $weight', style: const TextStyle(fontSize: 14, color: AppColors.textSecondary)),
                ],
              ),
            ],
          ),
        ),

      ],
    );
  }
}
