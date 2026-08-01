part of 'qr_bloc.dart';

sealed class QrState extends Equatable {
  const QrState();
  
  @override
  List<Object> get props => [];
}

final class QrInitial extends QrState {}
