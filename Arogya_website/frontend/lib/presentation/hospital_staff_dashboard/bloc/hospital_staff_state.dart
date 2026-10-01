part of 'hospital_staff_bloc.dart';

class HospitalStaffState extends Equatable {
  final List<StaffSummaryEntity> staff;
  final int currentPage;
  final int totalPages;
  final int totalElements;
  final bool isLoading;
  final String? errorMessage;

  const HospitalStaffState({
    this.staff = const [],
    this.currentPage = 0,
    this.totalPages = 1,
    this.totalElements = 0,
    this.isLoading = false,
    this.errorMessage,
  });

  HospitalStaffState copyWith({
    List<StaffSummaryEntity>? staff,
    int? currentPage,
    int? totalPages,
    int? totalElements,
    bool? isLoading,
    String? errorMessage,
  }) {
    return HospitalStaffState(
      staff: staff ?? this.staff,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      totalElements: totalElements ?? this.totalElements,
      isLoading: isLoading ?? false,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props =>
      [staff, currentPage, totalPages, totalElements, isLoading, errorMessage];
}