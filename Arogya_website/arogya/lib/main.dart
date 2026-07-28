import 'package:arogya/examples/main_page.dart';
import 'package:arogya/examples/registration.dart';
import 'package:arogya/pages/Registration/registration_page.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(const ArogyaApp());
}



class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Arogya',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.light,
        ),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(color: const Color.fromARGB(255, 255, 255, 255)),
          fillColor: const Color.fromARGB(255, 255, 255, 255),
          filled: true,
          border: OutlineInputBorder(
            borderSide: const BorderSide(width:2,color: Color.fromARGB(255, 255, 255, 255)),
            borderRadius: BorderRadius.circular(12),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(width:2,color: Color.fromARGB(255, 255, 255, 255)),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(width:2,color: Colors.blue),
            borderRadius: BorderRadius.circular(12),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(width:2,color: Colors.red),
            borderRadius: BorderRadius.circular(12),
          ),
          contentPadding: EdgeInsets.all(20),
        ),
      ),
      home : HomeRegistration()//HospitalRegistrationApp()//
    );
  }
}

        