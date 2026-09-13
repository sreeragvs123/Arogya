import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:frontend/domain/entities/patient_detail/patient_detail_entity.dart';
import 'package:frontend/domain/repositories/patient_detail/patient_detail_repository.dart';
import 'package:frontend/domain/usecases/patient_detail/generate_clinical_report_usecase.dart';
import 'package:frontend/domain/usecases/patient_detail/get_patient_detail_usecase.dart';
import 'package:frontend/domain/usecases/patient_detail/get_prescription_draft_usecase.dart';
import 'package:frontend/domain/usecases/patient_detail/get_recent_observations_usecase.dart';
import 'package:frontend/domain/usecases/patient_detail/get_vitals_usecase.dart';
import 'package:frontend/domain/usecases/patient_detail/save_observations_usecase.dart';
import 'package:frontend/domain/usecases/patient_detail/save_prescription_usecase.dart';
import 'package:frontend/domain/usecases/patient_detail/update_vitals_usecase.dart';

part 'patient_details_event.dart';
part 'patient_details_state.dart';

class PatientDetailsBloc extends Bloc<PatientDetailsEvent, PatientDetailsState> {
  final GetPatientDetailUsecase getPatientDetailUsecase;
  final GetVitalsUsecase getVitalsUsecase;
  final GetRecentObservationsUsecase getRecentObservationsUsecase;
  final UpdateVitalsUsecase updateVitalsUsecase;
  final SaveObservationsUsecase saveObservationsUsecase;
  final GetPrescriptionDraftUsecase getPrescriptionDraftUsecase;
  final SavePrescriptionUsecase savePrescriptionUsecase;
  final GenerateClinicalReportUsecase generateClinicalReportUsecase;

  late String _patientId;
  int _actionToken = 0;
  int _tempIdCounter = 0;

  PatientDetailsBloc({
    required this.getPatientDetailUsecase,
    required this.getVitalsUsecase,
    required this.getRecentObservationsUsecase,
    required this.updateVitalsUsecase,
    required this.saveObservationsUsecase,
    required this.getPrescriptionDraftUsecase,
    required this.savePrescriptionUsecase,
    required this.generateClinicalReportUsecase,
  }) : super(const PatientDetailsState()) {
    on<PatientDetailsStarted>(_onStarted);
    on<PatientDetailsRefreshRequested>((event, emit) => _loadAll(emit));
    on<VitalsUpdateSubmitted>(_onVitalsUpdateSubmitted);
    on<SymptomAdded>(_onSymptomAdded);
    on<SymptomRemoved>(_onSymptomRemoved);
    on<ObservationsSaveRequested>(_onObservationsSaveRequested);
    on<PrescriptionItemAdded>(_onPrescriptionItemAdded);
    on<PrescriptionItemRemoved>(_onPrescriptionItemRemoved);
    on<PrescriptionDiscardRequested>(_onPrescriptionDiscardRequested);
    on<PrescriptionSaveRequested>(_onPrescriptionSaveRequested);
    on<ClinicalReportGenerateRequested>(_onClinicalReportGenerateRequested);
    on<ClinicalReportSignatureAdded>(_onClinicalReportSignatureAdded);
  }

  Future<void> _onStarted(
    PatientDetailsStarted event,
    Emitter<PatientDetailsState> emit,
  ) async {
    _patientId = event.patientId;
    await _loadAll(emit);
  }

  Future<void> _loadAll(Emitter<PatientDetailsState> emit) async {
    emit(state.copyWith(status: PatientDetailsStatus.loading, errorMessage: null));

    final patientResult =
        await getPatientDetailUsecase.call(params: PatientIdParams(patientId: _patientId));
    final vitalsResult =
        await getVitalsUsecase.call(params: PatientIdParams(patientId: _patientId));
    final observationsResult =
        await getRecentObservationsUsecase.call(params: PatientIdParams(patientId: _patientId));
    final prescriptionResult =
        await getPrescriptionDraftUsecase.call(params: PatientIdParams(patientId: _patientId));

    String? error;
    PatientDetailEntity? patient;
    VitalsEntity? vitals;
    List<ObservationEntity> observations = const [];
    List<PrescriptionItemEntity> prescriptionDraft = const [];

    patientResult.fold((f) => error = f.message, (v) => patient = v);
    vitalsResult.fold((f) => error ??= f.message, (v) => vitals = v);
    observationsResult.fold((f) => error ??= f.message, (v) => observations = v);
    prescriptionResult.fold((f) => error ??= f.message, (v) => prescriptionDraft = v);

    emit(state.copyWith(
      status: error == null ? PatientDetailsStatus.success : PatientDetailsStatus.failure,
      patient: patient,
      vitals: vitals,
      observations: observations,
      prescriptionDraft: prescriptionDraft,
      errorMessage: error,
    ));
  }

  Future<void> _onVitalsUpdateSubmitted(
    VitalsUpdateSubmitted event,
    Emitter<PatientDetailsState> emit,
  ) async {
    emit(state.copyWith(isVitalsSaving: true));
    final result = await updateVitalsUsecase.call(
      params: UpdateVitalsParams(patientId: _patientId, input: event.input),
    );
    _actionToken++;
    result.fold(
      (failure) => emit(state.copyWith(
        actionFeedback: PatientDetailActionFeedback(
          token: _actionToken,
          kind: PatientDetailActionKind.vitalsUpdated,
          succeeded: false,
          message: failure.message,
        ),
      )),
      (vitals) => emit(state.copyWith(
        vitals: vitals,
        actionFeedback: PatientDetailActionFeedback(
          token: _actionToken,
          kind: PatientDetailActionKind.vitalsUpdated,
          succeeded: true,
          message: 'Vitals updated.',
        ),
      )),
    );
  }

  void _onSymptomAdded(SymptomAdded event, Emitter<PatientDetailsState> emit) {
    if (state.draftSymptoms.contains(event.symptom)) return;
    emit(state.copyWith(draftSymptoms: [...state.draftSymptoms, event.symptom]));
  }

  void _onSymptomRemoved(SymptomRemoved event, Emitter<PatientDetailsState> emit) {
    emit(state.copyWith(
      draftSymptoms: state.draftSymptoms.where((s) => s != event.symptom).toList(),
    ));
  }

  Future<void> _onObservationsSaveRequested(
    ObservationsSaveRequested event,
    Emitter<PatientDetailsState> emit,
  ) async {
    emit(state.copyWith(isObservationsSaving: true));
    final result = await saveObservationsUsecase.call(
      params: SaveObservationsParams(
        patientId: _patientId,
        symptoms: state.draftSymptoms,
        clinicalNote: event.clinicalNote,
      ),
    );
    _actionToken++;
    result.fold(
      (failure) => emit(state.copyWith(
        actionFeedback: PatientDetailActionFeedback(
          token: _actionToken,
          kind: PatientDetailActionKind.observationsSaved,
          succeeded: false,
          message: failure.message,
        ),
      )),
      (_) => emit(state.copyWith(
        actionFeedback: PatientDetailActionFeedback(
          token: _actionToken,
          kind: PatientDetailActionKind.observationsSaved,
          succeeded: true,
          message: 'Note saved to clinical report.',
        ),
      )),
    );
  }

  void _onPrescriptionItemAdded(
    PrescriptionItemAdded event,
    Emitter<PatientDetailsState> emit,
  ) {
    if (event.name.trim().isEmpty) return;
    _tempIdCounter++;
    final item = PrescriptionItemEntity(
      id: 'draft-$_tempIdCounter',
      name: event.name.trim(),
      dosage: event.dosage.trim(),
      frequency: event.frequency.trim(),
      timing: event.timing.trim(),
    );
    emit(state.copyWith(prescriptionDraft: [...state.prescriptionDraft, item]));
  }

  void _onPrescriptionItemRemoved(
    PrescriptionItemRemoved event,
    Emitter<PatientDetailsState> emit,
  ) {
    emit(state.copyWith(
      prescriptionDraft:
          state.prescriptionDraft.where((item) => item.id != event.itemId).toList(),
    ));
  }

  void _onPrescriptionDiscardRequested(
    PrescriptionDiscardRequested event,
    Emitter<PatientDetailsState> emit,
  ) {
    _actionToken++;
    emit(state.copyWith(
      prescriptionDraft: const [],
      actionFeedback: PatientDetailActionFeedback(
        token: _actionToken,
        kind: PatientDetailActionKind.prescriptionDiscarded,
        succeeded: true,
        message: 'Prescription draft discarded.',
      ),
    ));
  }

  Future<void> _onPrescriptionSaveRequested(
    PrescriptionSaveRequested event,
    Emitter<PatientDetailsState> emit,
  ) async {
    emit(state.copyWith(isPrescriptionSaving: true));
    final result = await savePrescriptionUsecase.call(
      params: SavePrescriptionParams(patientId: _patientId, items: state.prescriptionDraft),
    );
    _actionToken++;
    result.fold(
      (failure) => emit(state.copyWith(
        actionFeedback: PatientDetailActionFeedback(
          token: _actionToken,
          kind: PatientDetailActionKind.prescriptionSaved,
          succeeded: false,
          message: failure.message,
        ),
      )),
      (_) => emit(state.copyWith(
        actionFeedback: PatientDetailActionFeedback(
          token: _actionToken,
          kind: PatientDetailActionKind.prescriptionSaved,
          succeeded: true,
          message: 'Prescription saved.',
        ),
      )),
    );
  }

  Future<void> _onClinicalReportGenerateRequested(
    ClinicalReportGenerateRequested event,
    Emitter<PatientDetailsState> emit,
  ) async {
    emit(state.copyWith(isReportGenerating: true));
    final result = await generateClinicalReportUsecase.call(
      params: PatientIdParams(patientId: _patientId),
    );
    _actionToken++;
    result.fold(
      (failure) => emit(state.copyWith(
        actionFeedback: PatientDetailActionFeedback(
          token: _actionToken,
          kind: PatientDetailActionKind.reportGenerated,
          succeeded: false,
          message: failure.message,
        ),
      )),
      (report) => emit(state.copyWith(
        clinicalReport: report,
        actionFeedback: PatientDetailActionFeedback(
          token: _actionToken,
          kind: PatientDetailActionKind.reportGenerated,
          succeeded: true,
          message: 'Report generated and sent to the Hospital ERP & patient app.',
        ),
      )),
    );
  }

  void _onClinicalReportSignatureAdded(
    ClinicalReportSignatureAdded event,
    Emitter<PatientDetailsState> emit,
  ) {
    _actionToken++;
    final report = state.clinicalReport;
    emit(state.copyWith(
      clinicalReport: report?.copyWith(signaturePending: false),
      actionFeedback: PatientDetailActionFeedback(
        token: _actionToken,
        kind: PatientDetailActionKind.signatureAdded,
        succeeded: true,
        message: 'Digital signature added.',
      ),
    ));
  }
}
