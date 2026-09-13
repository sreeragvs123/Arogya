import 'package:equatable/equatable.dart';

enum ConsultationActionType { startVisit, joinCall }

/// Local UI-only status used to reflect an in-flight/optimistic action
/// before the bloc's authoritative state (from a refetch) lands.
enum ConsultationLifecycleStatus { upcoming, inProgress, completed }

class ConsultationEntity extends Equatable {
  final String id;
  final String patientId;
  final String patientName;
  final String time;
  final String reason;
  final String initials;
  final String? avatarUrl;
  final ConsultationActionType action;
  final ConsultationLifecycleStatus status;

  const ConsultationEntity({
    required this.id,
    required this.patientId,
    required this.patientName,
    required this.time,
    required this.reason,
    required this.initials,
    this.avatarUrl,
    this.action = ConsultationActionType.startVisit,
    this.status = ConsultationLifecycleStatus.upcoming,
  });

  ConsultationEntity copyWith({ConsultationLifecycleStatus? status}) {
    return ConsultationEntity(
      id: id,
      patientId: patientId,
      patientName: patientName,
      time: time,
      reason: reason,
      initials: initials,
      avatarUrl: avatarUrl,
      action: action,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props =>
      [id, patientId, patientName, time, reason, initials, avatarUrl, action, status];
}
