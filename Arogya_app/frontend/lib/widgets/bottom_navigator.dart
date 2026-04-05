import 'package:flutter/material.dart';


class ArogyaBottomNavigatorBar extends StatelessWidget {
  final int currIndex;
  final Function(int) onTap;

  const ArogyaBottomNavigatorBar({super.key,required this.currIndex,required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        currentIndex: currIndex,
        onTap:onTap,
        items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: "Home",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bar_chart),
          label:"Graph",
          ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: "Profile"
        ),
      ],
      );
  }
}