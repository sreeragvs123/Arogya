import 'package:frontend/domain/entities/doctor_dashboard/consultation_entity.dart';

class ConsultationModel extends ConsultationEntity {
  const ConsultationModel({
    required super.id,
    required super.patientId,
    required super.patientName,
    required super.time,
    required super.reason,
    required super.initials,
    super.avatarUrl,
    super.action,
    super.status,
  });

  factory ConsultationModel.fromJson(Map<String, dynamic> json) {
    return ConsultationModel(
      id: json['id'].toString(),
      patientId: json['patientId'].toString(),
      patientName: json['patientName'] as String,
      time: json['time'] as String,
      reason: json['reason'] as String,
      initials: json['initials'] as String? ?? _initialsFrom(json['patientName'] as String),
      avatarUrl: json['avatarUrl'] as String?,
      action: (json['action'] as String?) == 'JOIN_CALL'
          ? ConsultationActionType.joinCall
          : ConsultationActionType.startVisit,
      status: _statusFromString(json['status'] as String?),
    );
  }

  static String _initialsFrom(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1)).toUpperCase();
  }

  static ConsultationLifecycleStatus _statusFromString(String? value) {
    switch (value) {
      case 'IN_PROGRESS':
        return ConsultationLifecycleStatus.inProgress;
      case 'COMPLETED':
        return ConsultationLifecycleStatus.completed;
      default:
        return ConsultationLifecycleStatus.upcoming;
    }
  }
}
