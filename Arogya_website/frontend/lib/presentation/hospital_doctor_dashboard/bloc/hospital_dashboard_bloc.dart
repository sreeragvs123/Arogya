// presentation/hospital_dashboard/bloc/hospital_dashboard_bloc.dart
import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:frontend/domain/entities/hosptial_dashboard/doctor_staff_section.dart';
import 'package:frontend/domain/entities/hosptial_dashboard/doctor_summary_entity.dart';
import 'package:frontend/domain/entities/hosptial_dashboard/hospital_metrics_entity.dart';
import 'package:frontend/domain/usecases/hospital_dashboard/filter_doctors_by_specialization_usecase.dart';
import 'package:frontend/domain/usecases/hospital_dashboard/get_doctors_by_section_usecase.dart';
import 'package:frontend/domain/usecases/hospital_dashboard/get_hospital_metrics_usecase.dart';
import 'package:frontend/domain/usecases/hospital_dashboard/get_specializations_usecase.dart';
import 'package:frontend/domain/usecases/hospital_dashboard/search_doctors_usecase.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';


part 'hospital_dashboard_event.dart';
part 'hospital_dashboard_state.dart';

const int _kPageSize = 10;

EventTransformer<T> _debounce<T>(Duration duration) {
  return (events, mapper) => events.debounceTime(duration).switchMap(mapper);
}

class HospitalDashboardBloc extends Bloc<HospitalDashboardEvent, HospitalDashboardState> {
  final GetDoctorsBySectionUsecase getDoctorsBySectionUsecase;
  final SearchDoctorsUsecase searchDoctorsUsecase;
  final FilterDoctorsBySpecializationUsecase filterDoctorsBySpecializationUsecase;
  final GetSpecializationsUsecase getSpecializationsUsecase;
  final GetHospitalMetricsUsecase getHospitalMetricsUsecase;

  late int _hospitalId;

  HospitalDashboardBloc({
    required this.getDoctorsBySectionUsecase,
    required this.searchDoctorsUsecase,
    required this.filterDoctorsBySpecializationUsecase,
    required this.getSpecializationsUsecase,
    required this.getHospitalMetricsUsecase,
  }) : super(const HospitalDashboardState()) {
    on<HospitalDashboardStarted>(_onStarted);
    on<HospitalDashboardSearchChanged>(
      _onSearchChanged,
      transformer: _debounce(const Duration(milliseconds: 400)),
    );
    on<HospitalDashboardTabChanged>(
      _onTabChanged,
      transformer: restartable(),
    );
    on<HospitalDashboardDepartmentChanged>(
      _onDepartmentChanged,
      transformer: restartable(),
    );
    on<HospitalDashboardPageChanged>(
      _onPageChanged,
      transformer: restartable(),
    );
    on<_HospitalDashboardDoctorsRequested>(
      _onDoctorsRequested,
      transformer: restartable(),
    );
  }

  Future<void> _onStarted(
    HospitalDashboardStarted event,
    Emitter<HospitalDashboardState> emit,
  ) async {
    _hospitalId = event.hospitalId;
    emit(state.copyWith(isLoading: true));

    final metricsResult = await getHospitalMetricsUsecase.call(
      params: GetHospitalMetricsParams(hospitalId: _hospitalId),
    );
    final specsResult = await getSpecializationsUsecase.call(
      params: GetSpecializationsParams(hospitalId: _hospitalId),
    );

    HospitalMetricsEntity? metrics;
    List<String> specializations = const ['All Specializations'];
    metricsResult.fold((_) {}, (m) => metrics = m);
    specsResult.fold((_) {}, (s) => specializations = ['All Specializations', ...s]);

    emit(state.copyWith(metrics: metrics, specializations: specializations, isLoading: false));
    add(const _HospitalDashboardDoctorsRequested());
  }

  Future<void> _onSearchChanged(
    HospitalDashboardSearchChanged event,
    Emitter<HospitalDashboardState> emit,
  ) async {
    emit(state.copyWith(searchQuery: event.query, currentPage: 0));
    await _fetchDoctors(emit);
  }

  Future<void> _onTabChanged(
    HospitalDashboardTabChanged event,
    Emitter<HospitalDashboardState> emit,
  ) async {
    emit(state.copyWith(activeTab: event.tabKey, currentPage: 0));
    await _fetchDoctors(emit);
  }

  Future<void> _onDepartmentChanged(
    HospitalDashboardDepartmentChanged event,
    Emitter<HospitalDashboardState> emit,
  ) async {
    emit(state.copyWith(selectedDepartment: event.department, currentPage: 0));
    await _fetchDoctors(emit);
  }

  Future<void> _onPageChanged(
    HospitalDashboardPageChanged event,
    Emitter<HospitalDashboardState> emit,
  ) async {
    emit(state.copyWith(currentPage: event.page));
    await _fetchDoctors(emit);
  }

  // kept so external callers / the internal `add()` calls above still work,
  // but the actual fetch logic now lives in _fetchDoctors so debounced and
  // non-debounced paths share one implementation.
  Future<void> _onDoctorsRequested(
    _HospitalDashboardDoctorsRequested event,
    Emitter<HospitalDashboardState> emit,
  ) async {
    await _fetchDoctors(emit);
  }

  Future<void> _fetchDoctors(Emitter<HospitalDashboardState> emit) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    final section = DoctorStaffSectionX.fromTabKey(state.activeTab);
    final hasQuery = state.searchQuery.trim().isNotEmpty;
    final hasDepartmentFilter = state.selectedDepartment != 'All Specializations';

    final result = hasQuery
        ? await searchDoctorsUsecase.call(
            params: SearchDoctorsParams(
              hospitalId: _hospitalId,
              section: section,
              query: state.searchQuery.trim(),
              page: state.currentPage,
              size: _kPageSize,
            ),
          )
        : hasDepartmentFilter
            ? await filterDoctorsBySpecializationUsecase.call(
                params: FilterDoctorsBySpecializationParams(
                  hospitalId: _hospitalId,
                  section: section,
                  specialization: state.selectedDepartment,
                  page: state.currentPage,
                  size: _kPageSize,
                ),
              )
            : await getDoctorsBySectionUsecase.call(
                params: GetDoctorsBySectionParams(
                  hospitalId: _hospitalId,
                  section: section,
                  page: state.currentPage,
                  size: _kPageSize,
                ),
              );

    result.fold(
      (failure) => emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (paginated) => emit(state.copyWith(
        isLoading: false,
        doctors: paginated.content,
        totalPages: paginated.totalPages == 0 ? 1 : paginated.totalPages,
      )),
    );
  }
}