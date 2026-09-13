import 'package:frontend/domain/entities/doctor_dashboard/activity_entity.dart';

class ActivityModel extends ActivityEntity {
  const ActivityModel({
    required super.id,
    required super.title,
    required super.description,
    required super.timeAgo,
    super.isHighlighted,
  });

  factory ActivityModel.fromJson(Map<String, dynamic> json) {
    return ActivityModel(
      id: json['id'].toString(),
      title: json['title'] as String,
      description: json['description'] as String,
      timeAgo: json['timeAgo'] as String,
      isHighlighted: json['isHighlighted'] as bool? ?? false,
    );
  }
}
