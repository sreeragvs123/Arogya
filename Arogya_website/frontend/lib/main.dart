import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/session/session_bloc.dart';
import 'package:frontend/core/storage/session_storage.dart';
import 'package:frontend/core/utils/service_locator.dart';
import 'package:frontend/domain/entities/auth/auth_session.dart';
import 'package:frontend/presentation/auth/bloc/auth_bloc.dart';
import "package:hive_flutter/hive_flutter.dart";
import 'core/routing/app_routes.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('authBox');
  await initializeDependencies();
  final session = await sl<SessionStorage>().read();
  runApp(ArogyaApp(initialRoute: _routeFor(session)));
}

  String _routeFor(AuthSession? session) {
    if (session == null) return AppRoutes.auth;
    return switch (session) {
      DoctorSession() => AppRoutes.doctorDashboard,
      HospitalSession() => AppRoutes.hospitalDashboard,
      StaffSession() => AppRoutes.staffDashboard,
      _ => AppRoutes.auth,
    };
    }

class HospitalSession {
}
class ArogyaApp extends StatelessWidget {
final String initialRoute;
const ArogyaApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<AuthBloc>()),
        BlocProvider(
          create: (_) => sl<SessionBloc>()..add(const SessionLoadRequested()),
        ),
      ],
      child: MaterialApp(
        title: 'Arogya Portal',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        initialRoute: initialRoute,
        onGenerateRoute: AppRouter.onGenerateRoute,
      ),
    );
  }

}
