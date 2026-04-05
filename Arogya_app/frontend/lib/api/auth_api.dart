import 'package:frontend/api_manager/dio_client.dart';
import 'package:hive/hive.dart';
import 'package:dio/dio.dart';
import 'package:frontend/constants/api_constant.dart';
import 'package:frontend/models/auth_model.dart';

class AuthApi{

  static Future<void> signOut(Box box) async {
      await box.put('isLoggedIn',false);
      await box.put('role',null);
      await box.delete('accessToken');
      await box.delete('refreshToken');
      await box.delete('email');
      await box.delete('name');
      await box.delete('place');
      await box.delete('userId');
  }

  static Future<void> signUp(SignUp request) async{
    try {
      await ApiClient.dio.post(ApiConstants.signUp, data: request.toJson());
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  static Future<LoginResponse> login(LoginRequest request) async{
    try{
      dynamic resp = await ApiClient.dio.post(ApiConstants.login,data : request.toJson());
      print('Status Code : ${resp.statusCode}');
      print('resp.data   : ${resp.data}');
      print('data type   : ${resp.data.runtimeType}');
      final loginResp = LoginResponse.fromJson(resp.data);
      return loginResp;
    }on DioException catch(e){
      throw _handleError(e);
    }
  }



  static Exception _handleError(DioException e) {
    final status = e.response?.statusCode;
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.connectionError) {
      return Exception('Cannot reach server. Check your network or server IP.');
    }
    if (status == 401 || status == 403) {
      return Exception('Invalid email or password');
    }
    if (status == 409) {
      return Exception('Email already registered');
    }
    final body = e.response?.data;
    if (body is Map) {
      final msg = body['message'] ?? body['error'] ?? body.toString();
      return Exception(msg.toString());
    }
    return Exception(e.message ?? 'Unknown error');
  }


}