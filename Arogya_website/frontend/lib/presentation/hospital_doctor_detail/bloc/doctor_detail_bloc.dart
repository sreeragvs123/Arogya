// doctor_detail_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:frontend/domain/entities/hosptial_dashboard/doctor_detail_entity.dart';
import 'package:frontend/domain/usecases/hospital_dashboard/get_doctor_detail_usecase.dart';

part 'doctor_detail_event.dart';
part 'doctor_detail_state.dart';

class DoctorDetailBloc extends Bloc<DoctorDetailEvent, DoctorDetailState> {
  final GetDoctorDetailUsecase getDoctorDetailUsecase;

  DoctorDetailBloc({required this.getDoctorDetailUsecase})
      : super(const DoctorDetailState()) {
    on<DoctorDetailStarted>(_onStarted);
  }

  Future<void> _onStarted(
    DoctorDetailStarted event,
    Emitter<DoctorDetailState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    final result = await getDoctorDetailUsecase.call(
      params: GetDoctorDetailParams(
        hospitalId: event.hospitalId,
        doctorId: event.doctorId,
      ),
    );
    result.fold(
      (failure) => emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (doctor) => emit(state.copyWith(isLoading: false, doctor: doctor)),
    );
  }
}