import 'package:equatable/equatable.dart';

class Doctor extends Equatable {
  final String id;
  final String name;
  final String hospitalId;
  final String? specialization;
  final String? profileImageUrl;

  const Doctor({
    required this.id,
    required this.name,
    required this.hospitalId,
    this.specialization,
    this.profileImageUrl,
  });

  @override
  List<Object?> get props => [id, name, hospitalId, specialization, profileImageUrl];
}