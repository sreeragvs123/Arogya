import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/domain/entities/auth/hospital.dart';
import 'package:frontend/domain/usecases/hospital/search_hospital_usecase.dart';
import 'package:rxdart/rxdart.dart';


part 'hospital_search_event.dart';
part 'hospital_search_state.dart';

EventTransformer<T> debounce<T>(Duration duration) {
  return (events, mapper) => events.debounceTime(duration).switchMap(mapper);
}

class HospitalSearchBloc extends Bloc<HospitalSearchEvent, HospitalSearchState> {
  final SearchHospitalUsecase searchHospitalUsecase;   // <-- this field

  HospitalSearchBloc(this.searchHospitalUsecase) : super(const HospitalSearchState()) {
    on<HospitalQueryChanged>(_onQueryChanged, transformer: debounce(const Duration(milliseconds: 400)));
  }

Future<void> _onQueryChanged(
  HospitalQueryChanged event,
  Emitter<HospitalSearchState> emit,
) async {
  final query = event.query.trim();
  print("query changed");

  if (query.isEmpty) {
    emit(state.copyWith(results: [], showResults: false));
    return;
  }

  emit(state.copyWith(isLoading: true));

  final result = await searchHospitalUsecase.call(
    params: SearchHospitalParams(query: query),
  );

  result.fold(
    (failure) {
  print("SEARCH FAILED: ${failure.message}");
  emit(state.copyWith(isLoading: false, error: failure.message));
},
    (hospitals) => emit(state.copyWith(
      isLoading: false,
      results: hospitals,
      showResults: true,
    )),
  );
}
}