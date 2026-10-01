import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:frontend/domain/entities/hospital_staff/staff_entities.dart';
import 'package:frontend/domain/usecases/hospital_staff/staff_usecases.dart';

part 'hospital_staff_event.dart';
part 'hospital_staff_state.dart';


class HospitalStaffBloc extends Bloc<HospitalStaffEvent, HospitalStaffState> {
  final GetStaffUsecase getStaffUsecase;
  final int _kPageSize = 10;

HospitalStaffBloc({required this.getStaffUsecase})
    : super(const HospitalStaffState()) {
  on<StaffStarted>(_onStarted);
  on<StaffPageChanged>(_onPageChanged, transformer: restartable());
}

Future<void> _onStarted(StaffStarted event, Emitter<HospitalStaffState> emit) async {
  emit(state.copyWith(currentPage: 0));
  await _fetch(emit);
}

Future<void> _onPageChanged(StaffPageChanged event, Emitter<HospitalStaffState> emit) async {
  emit(state.copyWith(currentPage: event.page));
  await _fetch(emit);
}

Future<void> _fetch(Emitter<HospitalStaffState> emit) async {
  emit(state.copyWith(isLoading: true, errorMessage: null));
  final res = await getStaffUsecase.call(
    params: GetStaffParams(page: state.currentPage, size: _kPageSize),
  );
  res.fold(
    (f) => emit(state.copyWith(isLoading: false, errorMessage: f.message)),
    (p) => emit(state.copyWith(
      isLoading: false,
      staff: p.content,
      totalPages: p.totalPages == 0 ? 1 : p.totalPages,
      totalElements: p.totalElements,
    )),
  );
}
}