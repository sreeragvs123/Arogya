
import 'package:flutter/material.dart';
import 'package:frontend/design/bottomnavigator.dart';
import 'package:frontend/design/appbar.dart';
import 'package:frontend/design/drawer.dart';
import 'package:frontend/pages/graph_page.dart';
import 'package:frontend/pages/homepage.dart';
import 'package:frontend/pages/profile_page.dart';

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
    ProfilePage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ArogyaAppBar(),
      body: _pages[_isSelectedIndex],
      bottomNavigationBar: ArogyaBottomNavigatorBar(
        currIndex: _isSelectedIndex,
        onTap: (index){
          setState(() {
            _isSelectedIndex = index;
          });
        },
      ),
      drawer:ArogyaDrawer(),
    );
    

  }
}
