import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:frontend/core/storage/session_storage.dart';
import 'package:frontend/domain/entities/auth/auth_session.dart';

part 'session_event.dart';
part 'session_state.dart';

class SessionBloc extends Bloc<SessionEvent, SessionState> {
  final SessionStorage sessionStorage;

  SessionBloc(this.sessionStorage) : super(const SessionState()) {
    on<SessionLoadRequested>(_onSessionLoadRequested);
    on<SessionUpdated>(_onSessionUpdated);
    on<SessionCleared>(_onSessionCleared);
  }

  FutureOr<void> _onSessionLoadRequested(
    SessionLoadRequested event,
    Emitter<SessionState> emit,
  ) async {
    final session = await sessionStorage.read();
    if (session is DoctorSession) {
      emit(SessionState(doctorSession: session));
    }
  }

  FutureOr<void> _onSessionUpdated(
    SessionUpdated event,
    Emitter<SessionState> emit,
  ) {
    emit(SessionState(doctorSession: event.session));
  }

  FutureOr<void> _onSessionCleared(
    SessionCleared event,
    Emitter<SessionState> emit,
  ) {
    emit(const SessionState());
  }
}