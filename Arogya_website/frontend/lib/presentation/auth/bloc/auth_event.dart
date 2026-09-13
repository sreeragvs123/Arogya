part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object> get props => [];
}


class AuthTabChangedEvent extends AuthEvent{
  final AuthTab tab;
  const AuthTabChangedEvent(this.tab);
  @override
  List<Object> get props => [tab];
}

class DoctorSiginInEvent extends AuthEvent{
  final int hospitalId;
  final String doctorId;
  final String password;

  const DoctorSiginInEvent({required this.hospitalId, required this.doctorId, required this.password});
  @override
  List<Object> get props => [hospitalId,doctorId,password];
  
}

class HospitalSignInEvent extends AuthEvent{
  final String identifier;
  final String password;
  final String department;

  const HospitalSignInEvent({required this.identifier, required this.password, required this.department});

  @override
  List<Object> get props => [identifier,department,password];

}

class HospitalRegistrationEvent extends AuthEvent{
  final String hospitalName;
  final String license;
  final String facilityType;
  final String directorName;
  final String email;
  final String password;
  final String phone;

  const HospitalRegistrationEvent({required this.hospitalName, required this.facilityType,required this.license, required this.directorName, required this.email, required this.password, required this.phone});

  @override
  List<Object> get props => [hospitalName,license,email,password,directorName,phone,facilityType];
  
}



