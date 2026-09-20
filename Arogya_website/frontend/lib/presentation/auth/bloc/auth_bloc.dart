import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:frontend/core/session/session_bloc.dart';
import 'package:frontend/core/storage/session_storage.dart';
import 'package:frontend/domain/entities/auth/auth_session.dart';
import 'package:frontend/domain/usecases/auth/doctor_signin_usecase.dart';
import 'package:frontend/domain/usecases/auth/hospital_signin_usecase.dart';
import 'package:frontend/domain/usecases/auth/hosptial_create_usecase.dart';
import 'package:frontend/domain/usecases/auth/staff_signin_usecase.dart';
import 'package:frontend/presentation/auth/pages/auth_page.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  HosptialCreateUsecase hosptialCreateUsecase;
  HospitalSignInUsecase hosptialSignInUsecase;
  DoctorSignInUsecase doctorSignInUsecase;
  final SessionStorage sessionStorage;
  final SessionBloc sessionBloc;
  StaffSignInUsecase staffSignInUsecase;

  AuthBloc(
    this.hosptialCreateUsecase,
    this.hosptialSignInUsecase,
    this.doctorSignInUsecase,
    this.sessionStorage,
    this.sessionBloc,
    this.staffSignInUsecase,
  ) : super(const AuthInitial()) {
    on<AuthTabChangedEvent>(_onAuthTabChanged);
    on<DoctorSiginInEvent>(_onDoctorSignInSubmitted);
    on<HospitalSignInEvent>(_onHospitalSignInSubmitted);
    on<HospitalRegistrationEvent>(_onHospitalRegistrationSubmitted);
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthLoggedOut>(_onLoggedOut);
    on<StaffSignInEvent>(_onStaffSignInSubmitted);
  }


FutureOr<void> _onStaffSignInSubmitted(
  StaffSignInEvent event,
  Emitter<AuthState> emit,
) async {
  final currentTab = state.tab;
  emit(AuthLoadingState(currentTab));

  final params = StaffSignInParams(
    hospitalId: event.hospitalId,
    department: event.department,
    staffIdOrEmail: event.staffId,
    password: event.password,
  );

  try {
    final result = await staffSignInUsecase.call(params: params);
    await result.fold(
      (failure) async => emit(AuthFailureState(currentTab, failure.message)),
      (session) async {
        await sessionStorage.save(session);
        emit(AuthSuccessState(currentTab, "Sign In: Successful", session: session));
      },
    );
  } catch (e) {
    emit(AuthFailureState(currentTab, e.toString()));
  }
}

  FutureOr<void> _onAuthTabChanged(
    AuthTabChangedEvent event,
    Emitter<AuthState> emit,
  ) {
    emit(AuthTabChangedState(event.tab));
  }

  FutureOr<void> _onHospitalSignInSubmitted(
    HospitalSignInEvent event,
    Emitter<AuthState> emit,
  ) async {
    final currentTab = state.tab;
    emit(AuthLoadingState(currentTab));

    final params = HospitalSignInParams(
      identifierOrEmail: event.identifier,
      password: event.password,
    );

    try {
      final result = await hosptialSignInUsecase.call(params: params);
      await result.fold(
        (failure) async => emit(AuthFailureState(currentTab, failure.message)),
        (session) async {
          await sessionStorage.save(session);
          emit(AuthSuccessState(currentTab, "Sign In: Successful", session: session));
        },
      );
    } catch (e) {
      emit(AuthFailureState(currentTab, e.toString()));
    }
  }

  FutureOr<void> _onDoctorSignInSubmitted(
    DoctorSiginInEvent event,
    Emitter<AuthState> emit,
  ) async {
    final currentTab = state.tab;
    emit(AuthLoadingState(currentTab));

    final params = DoctorSignInParams(
      hospitalId: event.hospitalId,
      doctorIdOrEmail: event.doctorId,
      password: event.password,
    );
    try {
      final result = await doctorSignInUsecase(params: params);
      await result.fold(
        (failure) async => emit(AuthFailureState(currentTab, failure.message)),
        (success) async {
          await sessionStorage.save(success);
          if (success is DoctorSession) sessionBloc.add(SessionUpdated(success));
          emit(AuthSuccessState(currentTab, "Sign In : Successfull", session: success));
        },
      );
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
        (hospital) => emit(AuthSuccessState(currentTab, "Registration SuccessFull")),
      );
    } catch (e) {
      emit(AuthFailureState(currentTab, e.toString()));
    }
  }

 FutureOr<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    final session = await sessionStorage.read();
    if (session != null && !session.isExpired) {
      if (session is DoctorSession) sessionBloc.add(SessionUpdated(session));
      emit(AuthSuccessState(state.tab, "Session restored", session: session));
    } else if (session != null) {
      await sessionStorage.clear();
    }
  }

  FutureOr<void> _onLoggedOut(
    AuthLoggedOut event,
    Emitter<AuthState> emit,
  ) async {
    await sessionStorage.clear();
    sessionBloc.add(const SessionCleared());
    emit(const AuthInitial());
  }
}