import 'package:frontend/domain/entities/auth/hospital.dart';

class HospitalModel extends Hospital {
  const HospitalModel({
    required super.id,
    required super.name,
  });

  factory HospitalModel.fromJson(Map<String, dynamic> json) {
    return HospitalModel(
      id: json['hospitalId'] as int,
      name: json['hospitalName'] as String,
    );
  }
}