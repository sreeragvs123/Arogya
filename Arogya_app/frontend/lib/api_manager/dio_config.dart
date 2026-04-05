import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:frontend/constants/api_constant.dart';
import 'package:frontend/api/auth_api.dart';

class Config{

  static BaseOptions baseConfig(){
    return BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: Duration(seconds: 10),
      receiveTimeout: Duration(seconds:10),
      headers: {'Content-Type' : 'application/json'}
    );
  }


  static InterceptorsWrapper wrapper(){

    return InterceptorsWrapper(
        
        onRequest: (options, handler) {
          final token = Hive.box('authBox').get('accessToken') as String?;
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },

        onError: (DioException error, handler) async {
          if (error.response?.statusCode != 401) {
            return handler.next(error);
          }
          final box = Hive.box('authBox');
          final refreshToken = box.get('refreshToken') as String?;
          if (refreshToken == null || refreshToken.isEmpty) {
            await AuthApi.signOut(box);
            return handler.next(error);
          }

          try{
            final refreshResponse = await Dio().post(
              '${ApiConstants.baseUrl}/auth/refresh',
              data:    {'refreshToken': refreshToken},
              options: Options(headers: {'Content-Type': 'application/json'}),
            );
            final newAccessToken = refreshResponse.data['accessToken'] as String?;
            final newRefreshToken = refreshResponse.data['refreshToken'] as String?;
            if (newAccessToken == null) {
              await AuthApi.signOut(box);
              return handler.next(error);
            }
            await box.put('accessToken',  newAccessToken);
            if (newRefreshToken != null) {
              await box.put('refreshToken', newRefreshToken);
            }
            final retryOptions = error.requestOptions;
            retryOptions.headers['Authorization'] = 'Bearer $newAccessToken';
            final retryResponse = await Dio().fetch(retryOptions);
            return handler.resolve(retryResponse);
          }
          catch (_) {
            await AuthApi.signOut(box);
            return handler.next(error);
          }

        }
      );






  }
}