
import 'package:flutter/material.dart';
import 'package:frontend/features/bottomNavigator.dart';
import 'package:frontend/features/appbar.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ArogyaAppBar(),
      drawer:Drawer(
        backgroundColor: const Color.fromARGB(255, 211, 227, 229),
        child:Column(
          children: [
            SizedBox(
              height: 150,
              child: DrawerHeader(
                child: Text(
                  "Arogya",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          
          ]
          )
          ),
      bottomNavigationBar: ArogyaBottomNavigatorBar(),
            
          
        );
    

  }
}
