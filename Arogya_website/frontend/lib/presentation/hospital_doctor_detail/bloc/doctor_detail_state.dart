// doctor_detail_state.dart
part of 'doctor_detail_bloc.dart';

class DoctorDetailState extends Equatable {
  final DoctorDetailEntity? doctor;
  final bool isLoading;
  final String? errorMessage;

  const DoctorDetailState({this.doctor, this.isLoading = false, this.errorMessage});

  DoctorDetailState copyWith({
    DoctorDetailEntity? doctor,
    bool? isLoading,
    String? errorMessage,
  }) {
    return DoctorDetailState(
      doctor: doctor ?? this.doctor,
      isLoading: isLoading ?? false,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [doctor, isLoading, errorMessage];
}