import 'package:equatable/equatable.dart';

class Hospital extends Equatable {
  final int id;
  final String name;

  const Hospital({required this.id, required this.name});

  @override
  List<Object?> get props => [id, name];
}

