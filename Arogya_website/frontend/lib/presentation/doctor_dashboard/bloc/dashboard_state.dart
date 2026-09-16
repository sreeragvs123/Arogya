part of 'dashboard_bloc.dart';

enum DashboardStatus { initial, loading, success, failure }

class ConsultationActionResult extends Equatable {
  final int actionToken;
  final ConsultationEntity? consultation;
  final bool succeeded;
  final String? errorMessage;

  const ConsultationActionResult({
    this.actionToken = 0,
    this.consultation,
    this.succeeded = false,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [actionToken, consultation, succeeded, errorMessage];
}

class DashboardState extends Equatable {
  final DashboardStatus status;
  final DashboardSummaryEntity? summary;
  final List<ConsultationEntity> consultations;
  final List<ActivityEntity> activities;
  final String? errorMessage;
  final String? actionInProgressConsultationId;
  final ConsultationActionResult actionResult;

  const DashboardState({
    this.status = DashboardStatus.initial,
    this.summary,
    this.consultations = const [],
    this.activities = const [],
    this.errorMessage,
    this.actionInProgressConsultationId,
    this.actionResult = const ConsultationActionResult(),
  });

  DashboardState copyWith({
    DashboardStatus? status,
    DashboardSummaryEntity? summary,
    List<ConsultationEntity>? consultations,
    List<ActivityEntity>? activities,
    String? errorMessage,
    String? actionInProgressConsultationId,
    bool clearActionInProgress = false,
    ConsultationActionResult? actionResult,
  }) {
    return DashboardState(
      status: status ?? this.status,
      summary: summary ?? this.summary,
      consultations: consultations ?? this.consultations,
      activities: activities ?? this.activities,
      errorMessage: errorMessage,
      actionInProgressConsultationId: clearActionInProgress
          ? null
          : (actionInProgressConsultationId ?? this.actionInProgressConsultationId),
      actionResult: actionResult ?? this.actionResult,
    );
  }



  @override
  List<Object?> get props => [
        status,
        summary,
        consultations,
        activities,
        errorMessage,
        actionInProgressConsultationId,
        actionResult,
      ];
}
