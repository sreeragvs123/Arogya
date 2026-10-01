part of 'session_bloc.dart';

class SessionState extends Equatable {
  final AuthSession? session;

  const SessionState({this.session});

  bool get isLoggedIn => session != null;

  int? get doctorId {
    final s = session;
    return s is DoctorSession ? s.doctorId : null;
  }

  @override
  List<Object?> get props => [session];
}