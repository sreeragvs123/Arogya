part of 'qr_bloc.dart';

sealed class QrEvent extends Equatable {
  const QrEvent();

  @override
  List<Object?> get props => [];
}

class QrFlashToggled extends QrEvent {
  const QrFlashToggled();
}

class QrCameraSwitched extends QrEvent {
  const QrCameraSwitched();
}

/// Fired by manual entry ("Search Patient") or once a real scanner plugin
/// decodes a QR value — both resolve through the same lookup usecase.
class QrPatientLookupRequested extends QrEvent {
  final String identifier;
  const QrPatientLookupRequested(this.identifier);
  @override
  List<Object?> get props => [identifier];
}
