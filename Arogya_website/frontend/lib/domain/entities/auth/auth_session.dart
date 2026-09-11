import 'package:equatable/equatable.dart';


enum UserRole { doctor, hospitalAdmin }

class AuthSession extends Equatable{
  final String accessToken;
  final String? refreshToken;
  final DateTime expiresAt;
  final UserRole role;

  const AuthSession({required this.accessToken,this.refreshToken, required this.expiresAt, required this.role});

  bool get isExpired => DateTime.now().isAfter(expiresAt);

  @override
  List<Object?> get props => [accessToken,refreshToken,expiresAt,role];

}

