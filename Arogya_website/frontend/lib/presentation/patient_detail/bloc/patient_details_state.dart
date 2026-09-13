part of 'patient_details_bloc.dart';

enum PatientDetailsStatus { initial, loading, success, failure }

enum PatientDetailActionKind {
  none,
  vitalsUpdated,
  observationsSaved,
  prescriptionSaved,
  prescriptionDiscarded,
  reportGenerated,
  signatureAdded,
}

class PatientDetailActionFeedback extends Equatable {
  final int token;
  final PatientDetailActionKind kind;
  final bool succeeded;
  final String? message;

  const PatientDetailActionFeedback({
    this.token = 0,
    this.kind = PatientDetailActionKind.none,
    this.succeeded = false,
    this.message,
  });

  @override
  List<Object?> get props => [token, kind, succeeded, message];
}

class PatientDetailsState extends Equatable {
  final PatientDetailsStatus status;
  final PatientDetailEntity? patient;
  final VitalsEntity? vitals;
  final List<ObservationEntity> observations;
  final List<String> draftSymptoms;
  final List<PrescriptionItemEntity> prescriptionDraft;
  final ClinicalReportEntity? clinicalReport;
  final String? errorMessage;

  final bool isVitalsSaving;
  final bool isObservationsSaving;
  final bool isPrescriptionSaving;
  final bool isReportGenerating;

  final PatientDetailActionFeedback actionFeedback;

  const PatientDetailsState({
    this.status = PatientDetailsStatus.initial,
    this.patient,
    this.vitals,
    this.observations = const [],
    this.draftSymptoms = const [],
    this.prescriptionDraft = const [],
    this.clinicalReport,
    this.errorMessage,
    this.isVitalsSaving = false,
    this.isObservationsSaving = false,
    this.isPrescriptionSaving = false,
    this.isReportGenerating = false,
    this.actionFeedback = const PatientDetailActionFeedback(),
  });

  /// Builds the plain-text observations summary used by the Clinical
  /// Report tab, combining the server-reported base note with anything
  /// the doctor has tagged/typed in this session.
  String get observationsSummary {
    final buffer = StringBuffer();
    if (observations.isNotEmpty) {
      buffer.write(observations.first.note);
    }
    if (draftSymptoms.isNotEmpty) {
      if (buffer.isNotEmpty) buffer.write('\n\n');
      buffer.write('Reported Symptoms: ${draftSymptoms.join(', ')}');
    }
    return buffer.toString();
  }

  PatientDetailsState copyWith({
    PatientDetailsStatus? status,
    PatientDetailEntity? patient,
    VitalsEntity? vitals,
    List<ObservationEntity>? observations,
    List<String>? draftSymptoms,
    List<PrescriptionItemEntity>? prescriptionDraft,
    ClinicalReportEntity? clinicalReport,
    String? errorMessage,
    bool? isVitalsSaving,
    bool? isObservationsSaving,
    bool? isPrescriptionSaving,
    bool? isReportGenerating,
    PatientDetailActionFeedback? actionFeedback,
  }) {
    return PatientDetailsState(
      status: status ?? this.status,
      patient: patient ?? this.patient,
      vitals: vitals ?? this.vitals,
      observations: observations ?? this.observations,
      draftSymptoms: draftSymptoms ?? this.draftSymptoms,
      prescriptionDraft: prescriptionDraft ?? this.prescriptionDraft,
      clinicalReport: clinicalReport ?? this.clinicalReport,
      errorMessage: errorMessage,
      isVitalsSaving: isVitalsSaving ?? false,
      isObservationsSaving: isObservationsSaving ?? false,
      isPrescriptionSaving: isPrescriptionSaving ?? false,
      isReportGenerating: isReportGenerating ?? false,
      actionFeedback: actionFeedback ?? this.actionFeedback,
    );
  }

  @override
  List<Object?> get props => [
        status,
        patient,
        vitals,
        observations,
        draftSymptoms,
        prescriptionDraft,
        clinicalReport,
        errorMessage,
        isVitalsSaving,
        isObservationsSaving,
        isPrescriptionSaving,
        isReportGenerating,
        actionFeedback,
      ];
}
