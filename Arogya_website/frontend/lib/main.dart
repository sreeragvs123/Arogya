import 'package:flutter/material.dart';
import 'package:frontend/pages/login_page.dart';

void main() {
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Arogya',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: const ArogyaLoginPage(),
    );
  }
}
