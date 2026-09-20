part of 'session_bloc.dart';

sealed class SessionEvent extends Equatable {
  const SessionEvent();

  @override
  List<Object?> get props => [];
}

class SessionLoadRequested extends SessionEvent {
  const SessionLoadRequested();
}

class SessionUpdated extends SessionEvent {
  final DoctorSession session;

  const SessionUpdated(this.session);

  @override
  List<Object?> get props => [session];
}

class SessionCleared extends SessionEvent {
  const SessionCleared();
}