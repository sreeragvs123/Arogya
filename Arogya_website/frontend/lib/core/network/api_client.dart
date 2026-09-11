import 'package:dio/dio.dart';
import 'package:frontend/core/network/api_routes.dart';
import 'package:frontend/core/network/api_config.dart';
import 'package:hive/hive.dart';
import 'package:dio/browser.dart';
class ApiClient {
  final Dio dio;

  ApiClient()
    : dio = Dio(
        BaseOptions(
          baseUrl: AppConfig.baseUrl,
          connectTimeout: AppConfig.connectTimeout,
          receiveTimeout: AppConfig.receiveTimeout,
        ),
      ) {
        (dio.httpClientAdapter as BrowserHttpClientAdapter).withCredentials = true;
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final accessToken = Hive.box('authBox').get("accessToken") as String?;
          if (accessToken != null) {
            options.headers["Authorization"] = "Bearer $accessToken";
          }
          handler.next(options);
        },
        // onError: (DioException error, handler) async {
        //   if (error.response?.statusCode != 401) {
        //     return handler.next(error);
        //   }
        //   try {
        //     // No manual cookie handling — browser attaches it automatically
        //     // because withCredentials is set above.
        //     final refreshResponse = await dio.post(ApiRoutes.getRefreshToken);
        //     final newAccessToken = refreshResponse.data['accessToken'] as String;
        //     await Hive.box('authBox').put('accessToken', newAccessToken);

        //     error.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';
        //     final retryResponse = await dio.fetch(error.requestOptions);
        //     return handler.resolve(retryResponse);
        //   } catch (_) {
        //     return handler.next(error);
        //   }
        // },
        onError: (DioException error, handler) async {
          final isRefreshCall =
              error.requestOptions.path == ApiRoutes.getRefreshToken;

          if (error.response?.statusCode != 401 || isRefreshCall) {
            // Either not an auth error, or the refresh call itself failed —
            // don't recurse. Propagate so the caller can handle it
            // (e.g. force logout / redirect to login).
            return handler.next(error);
          }

          try {
            final refreshResponse = await dio.post(ApiRoutes.getRefreshToken);
            final newAccessToken =
                refreshResponse.data['accessToken'] as String;
            await Hive.box('authBox').put('accessToken', newAccessToken);

            error.requestOptions.headers['Authorization'] =
                'Bearer $newAccessToken';
            final retryResponse = await dio.fetch(error.requestOptions);
            return handler.resolve(retryResponse);
          } catch (_) {
            return handler.next(error);
          }
        },
      ),
    );
  }
}
