import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/entities/doctor_dashboard/consultation_entity.dart';

/// One row in the "Upcoming Consultations" list. Pulled into its own
/// widget since the same layout repeats for every patient.
class ConsultationCard extends StatelessWidget {
  final ConsultationEntity data;
  final bool isActionLoading;
  final VoidCallback onAction;
  final VoidCallback onOpenFile;

  const ConsultationCard({
    super.key,
    required this.data,
    required this.onAction,
    required this.onOpenFile,
    this.isActionLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final isJoinCall = data.action == ConsultationActionType.joinCall;
    final isCompleted = data.status == ConsultationLifecycleStatus.completed;
    final isInProgress = data.status == ConsultationLifecycleStatus.inProgress;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.softPanel,
                backgroundImage: data.avatarUrl != null ? NetworkImage(data.avatarUrl!) : null,
                child: data.avatarUrl == null
                    ? Text(data.initials,
                        style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.primary))
                    : null,
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: isInProgress ? AppColors.liveIndicator : AppColors.textMuted,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(data.patientName,
                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.softPanel,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text('ID: ${data.patientId}',
                          style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary)),
                    ),
                    if (isInProgress) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.emergencyBackground,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text('IN PROGRESS',
                            style: TextStyle(
                                fontSize: 10.5, fontWeight: FontWeight.w700, color: AppColors.primary)),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.access_time_rounded, size: 14, color: AppColors.textMuted),
                    const SizedBox(width: 4),
                    Text(data.time, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                    const SizedBox(width: 14),
                    const Icon(Icons.medical_information_outlined, size: 14, color: AppColors.textMuted),
                    const SizedBox(width: 4),
                    Text(data.reason, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onOpenFile,
            tooltip: 'Open patient chart',
            icon: const Icon(Icons.folder_open_outlined, color: AppColors.textSecondary),
          ),
          const SizedBox(width: 4),
          ElevatedButton(
            onPressed: (isActionLoading || isCompleted) ? null : onAction,
            style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14)),
            child: isActionLoading
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : Text(
                    isCompleted ? 'Completed' : (isJoinCall ? 'Join Call' : 'Start Visit'),
                    style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: Colors.white),
                  ),
          ),
        ],
      ),
    );
  }
}
