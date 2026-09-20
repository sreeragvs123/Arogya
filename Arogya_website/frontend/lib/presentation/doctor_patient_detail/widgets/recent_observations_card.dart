import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class ObservationData {
  final String date;
  final String note;

  const ObservationData({required this.date, required this.note});
}

class RecentObservationsCard extends StatelessWidget {
  final List<ObservationData> observations;

  const RecentObservationsCard({super.key, required this.observations});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('RECENT OBSERVATIONS',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 0.6, color: AppColors.textSecondary)),
          const SizedBox(height: 18),
          for (final obs in observations)
            Padding(
              padding: const EdgeInsets.only(bottom: 18),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 3,
                    height: 46,
                    margin: const EdgeInsets.only(top: 2),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(obs.date,
                            style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: AppColors.primary)),
                        const SizedBox(height: 4),
                        Text(obs.note,
                            style: const TextStyle(fontSize: 13.5, color: AppColors.textSecondary, height: 1.45)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
