import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'app_model_event.dart';
part 'app_model_state.dart';

class AppModelBloc extends Bloc<AppModelEvent, AppModelState> {
  AppModelBloc() : super(AppModelInitial()) {
    on<AppModelEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
