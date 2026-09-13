import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:frontend/domain/entities/patients/patient_summary_entity.dart';
import 'package:frontend/domain/usecases/patients/lookup_patient_usecase.dart';

part 'qr_event.dart';
part 'qr_state.dart';

class QrBloc extends Bloc<QrEvent, QrState> {
  final LookupPatientUsecase lookupPatientUsecase;
  int _lookupToken = 0;

  QrBloc({required this.lookupPatientUsecase}) : super(const QrState()) {
    on<QrFlashToggled>((event, emit) => emit(state.copyWith(isFlashOn: !state.isFlashOn)));
    on<QrCameraSwitched>(
        (event, emit) => emit(state.copyWith(isFrontCamera: !state.isFrontCamera)));
    on<QrPatientLookupRequested>(_onLookupRequested);
  }

  Future<void> _onLookupRequested(
    QrPatientLookupRequested event,
    Emitter<QrState> emit,
  ) async {
    final identifier = event.identifier.trim();
    if (identifier.isEmpty) {
      _lookupToken++;
      emit(state.copyWith(
        lookupStatus: QrLookupStatus.failure,
        errorMessage: 'Enter a Patient ID before searching.',
        lookupToken: _lookupToken,
      ));
      return;
    }

    emit(state.copyWith(lookupStatus: QrLookupStatus.loading, errorMessage: null));

    final result =
        await lookupPatientUsecase.call(params: LookupPatientParams(identifier: identifier));

    _lookupToken++;
    result.fold(
      (failure) => emit(state.copyWith(
        lookupStatus: QrLookupStatus.failure,
        errorMessage: failure.message,
        lookupToken: _lookupToken,
      )),
      (patient) => emit(state.copyWith(
        lookupStatus: QrLookupStatus.success,
        foundPatient: patient,
        lookupToken: _lookupToken,
      )),
    );
  }
}
