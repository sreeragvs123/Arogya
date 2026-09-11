import 'package:frontend/common/paginated_result.dart';

class PaginatedResultModel<T> extends PaginatedResult<T> {
  const PaginatedResultModel({
    required super.content,
    required super.page,
    required super.size,
    required super.totalPages,
    required super.totalElements,
  });

  factory PaginatedResultModel.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) itemFromJson,
  ) {
    return PaginatedResultModel(
      content: (json['content'] as List)
          .map((e) => itemFromJson(e as Map<String, dynamic>))
          .toList(),
      page: json['number'] as int,
      size: json['size'] as int,
      totalPages: json['totalPages'] as int,
      totalElements: json['totalElements'] as int,
    );
  }
}