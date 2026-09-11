import 'package:dio/dio.dart';
import 'package:frontend/core/network/api_routes.dart';
import 'package:frontend/data/models/hospital/hospital_search_model.dart';

abstract class HospitalRemoteDataSource {
    Future<List<HospitalSearchModel>> searchHospitals(String query);
}

  class HospitalRemoteDatasourceImpl implements HospitalRemoteDataSource{
    final Dio dio;
    HospitalRemoteDatasourceImpl({required this.dio});

  @override
  Future<List<HospitalSearchModel>> searchHospitals(String query) async {
    print("Hospital search api call is going to happen");
    final response = await dio.get(
      ApiRoutes.hospitalSearch,
      queryParameters: {'query': query},
    );
    print("The response is obtained");
    print(response.data["data"]);

    return (response.data['data']  as List)
        .map((e) => HospitalSearchModel.fromJson(e))
        .toList();
  }


  

  }

  