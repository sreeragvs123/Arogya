import 'package:equatable/equatable.dart';

class ActivityEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final String timeAgo;
  final bool isHighlighted;

  const ActivityEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.timeAgo,
    this.isHighlighted = false,
  });

  @override
  List<Object?> get props => [id, title, description, timeAgo, isHighlighted];
}
