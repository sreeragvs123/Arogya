import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/utils/service_locator.dart';
import 'package:frontend/presentation/auth/bloc/auth_bloc.dart';
import "package:hive_flutter/hive_flutter.dart";
import 'core/routing/app_routes.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();       
  await Hive.openBox('authBox');
  await initializeDependencies();
  runApp(const ArogyaApp());
}

class ArogyaApp extends StatelessWidget {
  const ArogyaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_)=>sl<AuthBloc>()),
      ],
      child: MaterialApp(
        title: 'Arogya Portal',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        initialRoute: AppRoutes.auth,
        onGenerateRoute: AppRouter.onGenerateRoute,
      ),
    );
  }
}
