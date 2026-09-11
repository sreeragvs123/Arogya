import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:frontend/domain/usecases/auth/hosptial_create_usecase.dart';
import 'package:frontend/presentation/auth/pages/auth_page.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  HosptialCreateUsecase hosptialCreateUsecase;
  AuthBloc(this.hosptialCreateUsecase) : super(const AuthInitial()) {
    on<AuthTabChangedEvent>(_onAuthTabChanged);
    on<DoctorSiginInEvent>(_onDoctorSignInSubmitted);
    on<HospitalSignInEvent>(_onHospitalSignInSubmitted);
    on<HospitalRegistrationEvent>(_onHospitalRegistrationSubmitted);
  }

  FutureOr<void> _onAuthTabChanged(
    AuthTabChangedEvent event,
    Emitter<AuthState> emit,
  ) {
    emit(AuthTabChangedState(event.tab));
  }

  FutureOr<void> _onDoctorSignInSubmitted(
    DoctorSiginInEvent event,
    Emitter<AuthState> emit,
  ) async {
    final currentTab = state.tab;
    emit(AuthLoadingState(currentTab));
    try {
      // TODO: await authRepository.doctorLogin(...)
      emit(AuthSuccessState(currentTab,"SigIn : SuccessFull"));
    } catch (e) {
      emit(AuthFailureState(currentTab, e.toString()));
    }
  }

  FutureOr<void> _onHospitalSignInSubmitted(
    HospitalSignInEvent event,
    Emitter<AuthState> emit,
  ) async {
    final currentTab = state.tab;
    emit(AuthLoadingState(currentTab));
    try {
      emit(AuthSuccessState(currentTab,"SigIn : SuccessFull"));
    } catch (e) {
      emit(AuthFailureState(currentTab, e.toString()));
    }
  }

  FutureOr<void> _onHospitalRegistrationSubmitted(
    HospitalRegistrationEvent event,
    Emitter<AuthState> emit,
  ) async {
    final currentTab = state.tab;
    emit(AuthLoadingState(currentTab));

    final params = HospitalCreateParams(
      hospitalName: event.hospitalName,
      facilityType: event.facilityType,
      clinicalLicenseNumber: event.license,
      adminName: event.directorName,
      officialEmail: event.email,
      contactPhone: event.phone,
      password: event.password,
    );


    try {
      final result = await hosptialCreateUsecase.call(params: params);
      result.fold(
        (failure) => emit(AuthFailureState(currentTab, failure.message)),
        (hospital) => emit(AuthSuccessState(currentTab,"Registration SuccessFull")),
      );
    } catch (e) {
      emit(AuthFailureState(currentTab, e.toString()));
    }
  }
}
