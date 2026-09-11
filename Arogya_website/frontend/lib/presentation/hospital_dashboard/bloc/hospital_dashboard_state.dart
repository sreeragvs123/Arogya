// presentation/hospital_dashboard/bloc/hospital_dashboard_state.dart
part of 'hospital_dashboard_bloc.dart';

class HospitalDashboardState extends Equatable {
  final List<DoctorSummaryEntity> doctors;
  final HospitalMetricsEntity? metrics;
  final List<String> specializations;
  final String searchQuery;
  final String activeTab;
  final String selectedDepartment;
  final int currentPage;
  final int totalPages;
  final bool isLoading;
  final String? errorMessage;

  const HospitalDashboardState({
    this.doctors = const [],
    this.metrics,
    this.specializations = const ['All Specializations'],
    this.searchQuery = '',
    this.activeTab = 'all',
    this.selectedDepartment = 'All Specializations',
    this.currentPage = 0,
    this.totalPages = 1,
    this.isLoading = false,
    this.errorMessage,
  });

  HospitalDashboardState copyWith({
    List<DoctorSummaryEntity>? doctors,
    HospitalMetricsEntity? metrics,
    List<String>? specializations,
    String? searchQuery,
    String? activeTab,
    String? selectedDepartment,
    int? currentPage,
    int? totalPages,
    bool? isLoading,
    String? errorMessage,
  }) {
    return HospitalDashboardState(
      doctors: doctors ?? this.doctors,
      metrics: metrics ?? this.metrics,
      specializations: specializations ?? this.specializations,
      searchQuery: searchQuery ?? this.searchQuery,
      activeTab: activeTab ?? this.activeTab,
      selectedDepartment: selectedDepartment ?? this.selectedDepartment,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      isLoading: isLoading ?? false,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        doctors,
        metrics,
        specializations,
        searchQuery,
        activeTab,
        selectedDepartment,
        currentPage,
        totalPages,
        isLoading,
        errorMessage,
      ];
}