part of 'patients_bloc.dart';

enum PatientsStatus { initial, loading, success, failure }

class PatientsState extends Equatable {
  final PatientsStatus status;
  final PatientsDirectorySummaryEntity? summary;
  final PatientSummaryEntity? activePatient;
  final List<PatientSummaryEntity> patients;
  final String searchQuery;
  final String sortBy;
  final String condition;
  final int currentPage;
  final int totalPages;
  final bool isListLoading;
  final String? errorMessage;

  const PatientsState({
    this.status = PatientsStatus.initial,
    this.summary,
    this.activePatient,
    this.patients = const [],
    this.searchQuery = '',
    this.sortBy = 'Last Visited',
    this.condition = 'All Conditions',
    this.currentPage = 0,
    this.totalPages = 1,
    this.isListLoading = false,
    this.errorMessage,
  });

  PatientsState copyWith({
    PatientsStatus? status,
    PatientsDirectorySummaryEntity? summary,
    PatientSummaryEntity? activePatient,
    bool clearActivePatient = false,
    List<PatientSummaryEntity>? patients,
    String? searchQuery,
    String? sortBy,
    String? condition,
    int? currentPage,
    int? totalPages,
    bool? isListLoading,
    String? errorMessage,
  }) {
    return PatientsState(
      status: status ?? this.status,
      summary: summary ?? this.summary,
      activePatient: clearActivePatient ? null : (activePatient ?? this.activePatient),
      patients: patients ?? this.patients,
      searchQuery: searchQuery ?? this.searchQuery,
      sortBy: sortBy ?? this.sortBy,
      condition: condition ?? this.condition,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      isListLoading: isListLoading ?? false,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        summary,
        activePatient,
        patients,
        searchQuery,
        sortBy,
        condition,
        currentPage,
        totalPages,
        isListLoading,
        errorMessage,
      ];
}
