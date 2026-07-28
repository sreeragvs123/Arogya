import 'package:frontend/core/network/api_manager/dio_client.dart';
import 'package:frontend/core/constants/api_constant.dart';
import 'package:frontend/data/models/firebase_model.dart';
import 'package:hive/hive.dart';

class MessageApi{
    Future<bool> sendTokenToBackend(MessageToken token) async {
    try {
      final response = await ApiClient.dio.post(ApiConstants.saveToken,data : token.toJson());
      return response.statusCode == 200;
    } catch (e) {
      return false; 
    }
  }


}