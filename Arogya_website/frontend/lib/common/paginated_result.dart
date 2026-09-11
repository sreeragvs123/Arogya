
class PaginatedResult<T> {
  final List<T> content;
  final int page;
  final int size;
  final int totalPages;
  final int totalElements;

  const PaginatedResult({
    required this.content,
    required this.page,
    required this.size,
    required this.totalPages,
    required this.totalElements,
  });
}