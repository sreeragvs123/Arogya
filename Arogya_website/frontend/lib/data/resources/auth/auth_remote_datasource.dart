import 'package:dio/dio.dart';
import 'package:frontend/core/network/api_routes.dart';
import 'package:frontend/data/models/auth/doctor_sigin_in_response_model.dart';
import 'package:frontend/data/models/auth/hospital_model.dart';
import 'package:frontend/data/models/auth/hospital_sign_in_response_model.dart';
import 'package:frontend/data/models/auth/staff_signin_response_model.dart';
import 'package:frontend/domain/entities/auth/auth_session.dart';
import 'package:frontend/domain/usecases/auth/hosptial_create_usecase.dart';

abstract class AuthRemoteDataSource {
  Future<DoctorSignInResponseModel> doctorSignIn({
    required int hospitalId,
    required String doctorIdOrEmail,
    required String password,
  });

  Future<HospitalSignInResponseModel> hospitalSignIn({
    required String identifierOrEmail,
    required String password,
  });
  Future<HospitalModel> createHospital({required HospitalCreateParams params});

    Future<StaffSignInResponseModel> staffSignIn({
    required int hospitalId,
    required String department,
    required String staffIdOrEmail,
    required String password,
  });
}




class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;
  AuthRemoteDataSourceImpl({required this.dio});

  @override
Future<StaffSignInResponseModel> staffSignIn({
  required int hospitalId,
  required String department,
  required String staffIdOrEmail,
  required String password,
}) async {
  final response = await dio.post(
    ApiRoutes.staffSignIn,
    data: {
      'hospitalId': hospitalId,
      'department': department,
      'username': staffIdOrEmail,
      'password': password,
      'role': UserRole.staff,
    },
  );
  return StaffSignInResponseModel.fromJson(
    response.data['data'] as Map<String, dynamic>,
  );
}




  @override
  Future<HospitalSignInResponseModel> hospitalSignIn({
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
  Future<DoctorSignInResponseModel> doctorSignIn({
    required int hospitalId,
    required String doctorIdOrEmail,
    required String password,
  }) async {
    final response = await dio.post(
      ApiRoutes.doctorSignIn,
      data: {
        'hospitalId': hospitalId,
        'username': doctorIdOrEmail,
        'password': password,
        'role' : UserRole.doctor
      },
    );
    return DoctorSignInResponseModel.fromJson(
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
