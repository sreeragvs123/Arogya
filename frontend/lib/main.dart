import 'package:flutter/material.dart';
import 'package:frontend/pages/graphdetail_page.dart';
import 'package:frontend/pages/myhome_page.dart';
import 'package:frontend/pages/profile_page.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Arogya',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: MyHomePage(),
      routes:{
        '/graphPage' : (context) => GraphPage(),
        '/profilePage' : (context) => ProfilePage(),
      }
    );
  }
}


