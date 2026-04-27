
import 'package:flutter/material.dart';
import 'package:frontend/pages/alarm_page.dart';
import 'package:frontend/widgets/bottom_navigator.dart';
import 'package:frontend/widgets/appbar.dart';
import 'package:frontend/widgets/drawer.dart';
import 'package:frontend/pages/graph_page.dart';
import 'package:frontend/pages/homepage.dart';
import 'package:frontend/pages/profile_page.dart';
import 'package:frontend/pages/notification_page.dart';

class FrontPage extends StatefulWidget {
  const FrontPage({super.key});

  @override
  State<FrontPage> createState() => _FrontPageState();
}

class _FrontPageState extends State<FrontPage> {

  int _isSelectedIndex=0;

  final List<Widget> _pages = [
    HomePage(),
    GraphPage(),
    AlarmPage(),
    ProfilePage()
  ];

  final List<String> titles =[
    "Arogya",
    "Graph",
    "Alarm",
    "Profile"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ArogyaAppBar(title: titles[_isSelectedIndex],index:_isSelectedIndex),
      body: _pages[_isSelectedIndex],
      bottomNavigationBar: ArogyaBottomNavigatorBar(
        currIndex: _isSelectedIndex,
        onTap: (index){
          setState(() {
            _isSelectedIndex = index;
          });
        },
      ),
  );
    

  }
}
