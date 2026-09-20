part of 'qr_bloc.dart';

enum QrLookupStatus { idle, loading, success, failure }

class QrState extends Equatable {
  final bool isFlashOn;
  final bool isFrontCamera;
  final QrLookupStatus lookupStatus;
  final PatientSummaryEntity? foundPatient;
  final String? errorMessage;
  final int lookupToken;

  const QrState({
    this.isFlashOn = false,
    this.isFrontCamera = false,
    this.lookupStatus = QrLookupStatus.idle,
    this.foundPatient,
    this.errorMessage,
    this.lookupToken = 0,
  });

  QrState copyWith({
    bool? isFlashOn,
    bool? isFrontCamera,
    QrLookupStatus? lookupStatus,
    PatientSummaryEntity? foundPatient,
    String? errorMessage,
    int? lookupToken,
  }) {
    return QrState(
      isFlashOn: isFlashOn ?? this.isFlashOn,
      isFrontCamera: isFrontCamera ?? this.isFrontCamera,
      lookupStatus: lookupStatus ?? this.lookupStatus,
      foundPatient: foundPatient ?? this.foundPatient,
      errorMessage: errorMessage,
      lookupToken: lookupToken ?? this.lookupToken,
    );
  }

  @override
  List<Object?> get props =>
      [isFlashOn, isFrontCamera, lookupStatus, foundPatient, errorMessage, lookupToken];
}
