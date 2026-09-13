import 'package:dio/dio.dart';
import 'package:frontend/core/network/api_routes.dart';
import 'package:frontend/data/models/auth/auth_session_model.dart';
import 'package:frontend/data/models/auth/hospital_model.dart';
import 'package:frontend/data/models/auth/hospital_sign_in_response_model.dart';
import 'package:frontend/domain/entities/auth/auth_session.dart';
import 'package:frontend/domain/usecases/auth/hosptial_create_usecase.dart';

abstract class AuthRemoteDataSource {
  Future<AuthSessionModel> doctorSignIn({
    required String hospitalId,
    required String doctorIdOrEmail,
    required String password,
  });

  Future<AuthSession> hospitalSignIn({
    // widened to AuthSession
    required String identifierOrEmail,
    required String password,
  });
  Future<HospitalModel> createHospital({required HospitalCreateParams params});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;
  AuthRemoteDataSourceImpl({required this.dio});

  @override
  Future<AuthSession> hospitalSignIn({
    required String identifierOrEmail,
    required String password,
  }) async {
    final response = await dio.post(
      ApiRoutes.hospitalSignIn,
      data: {'identifierOrEmail': identifierOrEmail, 'password': password},
    );
    final envelope = response.data as Map<String, dynamic>;
    if (envelope['error'] != null) {
      final error = envelope['error'] as Map<String, dynamic>;
      throw Exception(error['message'] as String? ?? 'Request failed');
    }
    print(envelope);
    print(envelope["data"]);
    final data = envelope['data'] as Map<String, dynamic>;
    return HospitalSignInResponseModel.fromJson(data);
  }

  @override
  Future<AuthSessionModel> doctorSignIn({
    required String hospitalId,
    required String doctorIdOrEmail,
    required String password,
  }) async {
    final response = await dio.post(
      ApiRoutes.doctorSignIn,
      data: {
        'hospitalId': hospitalId,
        'doctorIdOrEmail': doctorIdOrEmail,
        'password': password,
      },
    );
    return AuthSessionModel.fromJson(
      response.data["data"] as Map<String, dynamic>,
    );
  }

  @override
  Future<HospitalModel> createHospital({
    required HospitalCreateParams params,
  }) async {
    final response = await dio.post(
      ApiRoutes.createHospital,
      data: params.toJson(),
    );
    print(response.data);
    return HospitalModel.fromJson(
      response.data["data"] as Map<String, dynamic>,
    );
  }
}
