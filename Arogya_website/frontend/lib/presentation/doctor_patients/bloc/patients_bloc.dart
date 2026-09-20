import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:frontend/core/storage/session_storage.dart';
import 'package:frontend/core/usecases/usecase.dart';
import 'package:frontend/domain/entities/auth/auth_session.dart';
import 'package:frontend/domain/entities/patients/patient_summary_entity.dart';
import 'package:frontend/domain/usecases/patients/get_active_patient_usecase.dart';
import 'package:frontend/domain/usecases/patients/get_patients_directory_summary_usecase.dart';
import 'package:frontend/domain/usecases/patients/get_patients_usecase.dart';
import 'package:rxdart/rxdart.dart';

part 'patients_event.dart';
part 'patients_state.dart';

EventTransformer<T> _debounce<T>(Duration duration) {
  return (events, mapper) => events.debounceTime(duration).switchMap(mapper);
}

class PatientsBloc extends Bloc<PatientsEvent, PatientsState> {
  final GetPatientsDirectorySummaryUsecase getPatientsDirectorySummaryUsecase;
  final GetActivePatientUsecase getActivePatientUsecase;
  final GetPatientsUsecase getPatientsUsecase;

  static const int _pageSize = 10;

  PatientsBloc({
    required this.getPatientsDirectorySummaryUsecase,
    required this.getActivePatientUsecase,
    required this.getPatientsUsecase,
  }) : super(const PatientsState()) {
    on<PatientsStarted>(_onStarted);
    on<PatientsRefreshRequested>(_onRefreshRequested);
    on<PatientsSearchChanged>(
      _onSearchChanged,
      transformer: _debounce(const Duration(milliseconds: 400)),
    );
    on<PatientsSortChanged>(_onSortChanged);
    on<PatientsConditionChanged>(_onConditionChanged);
    on<PatientsApplyFiltersPressed>(
      _onApplyFilters,
      transformer: restartable(),
    );
    on<PatientsPageChanged>(_onPageChanged, transformer: restartable());
    on<_PatientsListRequested>(_onListRequested, transformer: restartable());
  }

  Future<void> _onStarted(
    PatientsStarted event,
    Emitter<PatientsState> emit,
  ) async {
    emit(state.copyWith(status: PatientsStatus.loading, errorMessage: null));

    final session = await SessionStorage()
        .read(); // or read(UserRole.doctor) if per-role

    if (session is! DoctorSession ||
        session.doctorId == null ||
        session.hospitalId == null) {
      emit(
        state.copyWith(
          status: PatientsStatus.failure,
          errorMessage: 'Not signed in.',
        ),
      );
      return;
    }

    final summaryResult = await getPatientsDirectorySummaryUsecase.call(
      params: DoctorHospitalParam(
        doctorId: session.doctorId!,
        hospitalId: session.hospitalId!,
      ),
    );
    final activePatientResult = await getActivePatientUsecase.call(
      params: NoParams(),
    );

    String? error;
    summaryResult.fold((failure) => error = failure.message, (_) {});
    activePatientResult.fold((failure) => error ??= failure.message, (_) {});

    emit(
      state.copyWith(
        status: error == null ? PatientsStatus.success : PatientsStatus.failure,
        summary: summaryResult.fold((_) => null, (value) => value),
        activePatient: activePatientResult.fold((_) => null, (value) => value),
        clearActivePatient: activePatientResult.fold(
          (_) => false,
          (value) => value == null,
        ),
        errorMessage: error,
      ),
    );

    add(const _PatientsListRequested());
  }

  Future<void> _onRefreshRequested(
    PatientsRefreshRequested event,
    Emitter<PatientsState> emit,
  ) async {
    add(const PatientsStarted());
  }

  Future<void> _onSearchChanged(
    PatientsSearchChanged event,
    Emitter<PatientsState> emit,
  ) async {
    emit(state.copyWith(searchQuery: event.query, currentPage: 0));
    add(const _PatientsListRequested());
  }

  void _onSortChanged(PatientsSortChanged event, Emitter<PatientsState> emit) {
    emit(state.copyWith(sortBy: event.sortBy));
  }


  void _onConditionChanged(
    PatientsConditionChanged event,
    Emitter<PatientsState> emit,
  ) {
    emit(state.copyWith(condition: event.condition));
  }




  Future<void> _onApplyFilters(
    PatientsApplyFiltersPressed event,
    Emitter<PatientsState> emit,
  ) async {
    emit(state.copyWith(currentPage: 0));
    add(const _PatientsListRequested());
  }

  Future<void> _onPageChanged(
    PatientsPageChanged event,
    Emitter<PatientsState> emit,
  ) async {
    emit(state.copyWith(currentPage: event.page));
    add(const _PatientsListRequested());
  }




  Future<void> _onListRequested(
    _PatientsListRequested event,
    Emitter<PatientsState> emit,
  ) async {
    emit(state.copyWith(isListLoading: true, errorMessage: null));

    final result = await getPatientsUsecase.call(
      params: GetPatientsParams(
        query: state.searchQuery.trim(),
        sortBy: state.sortBy,
        condition: state.condition,
        page: state.currentPage,
        size: _pageSize,
      ),
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(isListLoading: false, errorMessage: failure.message),
        );
      },
      (paginated) {
        emit(
          state.copyWith(
            isListLoading: false,
            patients: paginated.content,
            totalPages: paginated.totalPages < 1 ? 1 : paginated.totalPages,
          ),
        );
      },
    );
  }
}
