part of 'auth_bloc.dart';

class AuthState extends Equatable {
  final AuthTab tab;
  const AuthState(this.tab);
  @override
  List<Object?> get props => [tab];

}


final class AuthInitial extends AuthState {
  const AuthInitial():super(AuthTab.doctorSignIn);
}

final class AuthTabChangedState extends AuthState{
  const AuthTabChangedState(super.tab);
}

final class AuthLoadingState extends AuthState{
  const AuthLoadingState(super.tab);
}

final class AuthSuccessState extends AuthState{
  final String message;
  const AuthSuccessState(super.tab,this.message);
}

final class AuthFailureState extends AuthState{
  final String message;
  const AuthFailureState(super.tab,this.message);
  @override
  List<Object?> get props => [message,tab];
}



