

import 'package:frontend/domain/entities/auth/hospital.dart';

class HospitalSearchModel extends Hospital {
  const HospitalSearchModel({required super.id, required super.name});

  factory HospitalSearchModel.fromJson(Map<String, dynamic> json) {
    return HospitalSearchModel(
      id: json['id'],
      name: json['hospitalName'],
    );
  }
}