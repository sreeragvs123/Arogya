part of 'hospital_search_bloc.dart';

class HospitalSearchState extends Equatable{
  final bool isLoading;
  final List<Hospital> results;
  final bool showResults;
  final String? error;

  const HospitalSearchState({
    this.isLoading = false,
    this.results = const [],
    this.showResults = false,
    this.error,
  });

  HospitalSearchState copyWith({
    bool? isLoading,
    List<Hospital>? results,
    bool? showResults,
    String? error,
  }) {
    return HospitalSearchState(
      isLoading: isLoading ?? this.isLoading,
      results: results ?? this.results,
      showResults: showResults ?? this.showResults,
      error: error,
    );
  }

  @override
  List<Object?> get props => [isLoading,results,showResults,error];
}

final class HospitalSearchInitial extends HospitalSearchState {}
