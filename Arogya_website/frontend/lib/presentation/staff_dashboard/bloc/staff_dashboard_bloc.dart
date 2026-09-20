import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'staff_dashboard_event.dart';
part 'staff_dashboard_state.dart';

class StaffDashboardBloc extends Bloc<StaffDashboardEvent, StaffDashboardState> {
  StaffDashboardBloc() : super(StaffDashboardInitial()) {
    on<StaffDashboardEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
