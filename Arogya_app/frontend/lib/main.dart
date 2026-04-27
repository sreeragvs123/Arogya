import 'package:flutter/material.dart';
import 'package:frontend/pages/front_page.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:frontend/pages/homepage.dart';
import 'package:frontend/pages/login_page.dart';
import 'package:frontend/pages/signup_page.dart';
import 'package:frontend/services/noti_service.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:frontend/pages/notification_page.dart';




void main() async {
  WidgetsBinding Binding = WidgetsFlutterBinding.ensureInitialized();
  //initialize notification
  await NotiService().initNotification();//here the funtion is called on a object of the NotiService class
  FlutterNativeSplash.preserve(widgetsBinding:Binding);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState(){
    super.initState();
    intialization();
  }

  Future<void> intialization() async{


    await Hive.initFlutter();
    await Hive.openBox("authBox");
    await Hive.openBox("alarmBox");


    await Future.delayed(Duration(seconds:3));
    FlutterNativeSplash.remove();
  }

  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Arogya',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 96, 4, 255)),
      ),
      home: LoginPage(),
      routes:{
        '/signup' : (context)=>SignUpPage(),
        '/frontpage': (context)=>FrontPage(),
        '/homepage' :(context)=>HomePage(),
        '/loginpage' :(context)=>LoginPage(),
        '/notificationpage' : (context)=>NotificationPage(),
      }
    );
  }
}


