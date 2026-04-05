import 'package:dio/dio.dart';
import 'package:frontend/api_manager/dio_config.dart';

class ApiClient {

  static final Dio dio = build();

  static Dio build(){
    final d  = Dio(Config.baseConfig());
    d.interceptors.add(Config.wrapper());
    return d;
  }

}