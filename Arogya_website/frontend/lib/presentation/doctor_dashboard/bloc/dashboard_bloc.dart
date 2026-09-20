import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:frontend/core/usecases/usecase.dart';
import 'package:frontend/domain/entities/doctor_dashboard/activity_entity.dart';
import 'package:frontend/domain/entities/doctor_dashboard/consultation_entity.dart';
import 'package:frontend/domain/entities/doctor_dashboard/dashboard_summary_entity.dart';
import 'package:frontend/domain/usecases/doctor_dashboard/get_dashboard_summary_usecase.dart';
import 'package:frontend/domain/usecases/doctor_dashboard/get_recent_activity_usecase.dart';
import 'package:frontend/domain/usecases/doctor_dashboard/get_upcoming_consultations_usecase.dart';
import 'package:frontend/domain/usecases/doctor_dashboard/join_consultation_call_usecase.dart';
import 'package:frontend/domain/usecases/doctor_dashboard/start_consultation_usecase.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final GetDashboardSummaryUsecase getDashboardSummaryUsecase;
  final GetUpcomingConsultationsUsecase getUpcomingConsultationsUsecase;
  final GetRecentActivityUsecase getRecentActivityUsecase;
  final StartConsultationUsecase startConsultationUsecase;
  final JoinConsultationCallUsecase joinConsultationCallUsecase;

  int _actionToken = 0;

  DashboardBloc({
    required this.getDashboardSummaryUsecase,
    required this.getUpcomingConsultationsUsecase,
    required this.getRecentActivityUsecase,
    required this.startConsultationUsecase,
    required this.joinConsultationCallUsecase,
  }) : super(const DashboardState()) {
    on<DashboardStarted>(_onStarted);
    on<DashboardRefreshRequested>(_onRefreshRequested);
    on<DashboardConsultationActionPressed>(_onConsultationActionPressed);
  }

  Future<void> _onStarted(
    DashboardStarted event,
    Emitter<DashboardState> emit,
  ) async {
    int doctorId = event.doctorid;
    await _loadAll(doctorId, emit);
  }

  Future<void> _onRefreshRequested(
    DashboardRefreshRequested event,
    Emitter<DashboardState> emit,
  ) async {
    int doctorId = event.doctorid;
    await _loadAll(doctorId, emit);
  }

  Future<void> _loadAll(int doctorId, Emitter<DashboardState> emit) async {
    emit(state.copyWith(status: DashboardStatus.loading, errorMessage: null));
    print("Loading State is emitted and call is ready to go out");

    DoctorIdParam param = DoctorIdParam(doctorId: doctorId);

    final summaryResult = await getDashboardSummaryUsecase.call(params: param);
    print("Got back the result $summaryResult");

    DashboardSummaryEntity? summary;
    String? error;

    summaryResult.fold(
      (failure) => error = failure.message,
      (value) => summary = value,
    );

    print("ready to emit data");
    emit(
      state.copyWith(
        status: error == null
            ? DashboardStatus.success
            : DashboardStatus.failure,
        summary: summary,
        errorMessage: error,
      ),
    );
  }

  Future<void> _onConsultationActionPressed(
    DashboardConsultationActionPressed event,
    Emitter<DashboardState> emit,
  ) async {
    final consultation = event.consultation;
    emit(state.copyWith(actionInProgressConsultationId: consultation.id));

    final isJoinCall = consultation.action == ConsultationActionType.joinCall;
    final result = isJoinCall
        ? await joinConsultationCallUsecase.call(
            params: JoinConsultationCallParams(consultationId: consultation.id),
          )
        : await startConsultationUsecase.call(
            params: StartConsultationParams(consultationId: consultation.id),
          );

    _actionToken++;

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            clearActionInProgress: true,
            actionResult: ConsultationActionResult(
              actionToken: _actionToken,
              consultation: consultation,
              succeeded: false,
              errorMessage: failure.message,
            ),
          ),
        );
      },
      (_) {
        final updatedConsultations = state.consultations
            .map(
              (c) => c.id == consultation.id
                  ? c.copyWith(status: ConsultationLifecycleStatus.inProgress)
                  : c,
            )
            .toList();
        emit(
          state.copyWith(
            clearActionInProgress: true,
            consultations: updatedConsultations,
            actionResult: ConsultationActionResult(
              actionToken: _actionToken,
              consultation: consultation,
              succeeded: true,
            ),
          ),
        );
      },
    );
  }
}
