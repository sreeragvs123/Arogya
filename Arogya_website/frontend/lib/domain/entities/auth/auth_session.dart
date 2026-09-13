import 'package:equatable/equatable.dart';

enum UserRole { doctor, hospitalAdmin }

class AuthSession extends Equatable {
  final String accessToken;
  final String? refreshToken;
  final DateTime expiresAt;
  final UserRole role;
  final int? hospitalId;
  final String? hospitalName;
  final String? hospitalCode;
  final String? adminName;
  final String? adminDesignation;

  const AuthSession({
    required this.accessToken,
    this.refreshToken,
    required this.expiresAt,
    required this.role,
    this.hospitalId,
    this.hospitalName,
    this.hospitalCode,
    this.adminName,
    this.adminDesignation,
  });

  bool get isExpired => DateTime.now().isAfter(expiresAt);

  @override
  List<Object?> get props => [
        accessToken,
        refreshToken,
        expiresAt,
        role,
        hospitalId,
        hospitalName,
        hospitalCode,
        adminName,
        adminDesignation,
      ];
}