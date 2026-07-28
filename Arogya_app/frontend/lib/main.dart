import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/configs/firebase_config.dart';
import 'package:frontend/core/database/initialize_database.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:frontend/presentation/app_model/bloc/app_model_bloc.dart';
import 'package:frontend/presentation/app_model/ui/model.dart';
import 'package:frontend/presentation/auth/pages/login_page.dart';
import 'package:frontend/presentation/auth/pages/signup_page.dart';
import 'package:frontend/presentation/home/bloc/home_bloc.dart';
import 'package:frontend/presentation/home/pages/hompage.dart';
import 'package:frontend/presentation/profile/bloc/theme_bloc/theme_bloc.dart';
import 'package:frontend/presentation/profile/pages/profile_edit_page.dart';

void main() async {
  WidgetsBinding Binding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: Binding);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    intialization();
  }

  Future<void> intialization() async {
    await Future.delayed(Duration(seconds: 3));
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeBloc>(create: (_)=>ThemeBloc()),
        BlocProvider<HomeBloc>(create:(_)=>HomeBloc()),
        BlocProvider<AppModelBloc>(create: (_)=>AppModelBloc()),
      ],
      child: MaterialApp(
        title: 'Arogya',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 96, 4, 255),
          ),
        ),
        home: LoginPage(),
        routes: {
          '/signup': (context) => SignUpPage(),
          '/loginpage': (context) => LoginPage(),
        },
      ),
    );
  }
}
