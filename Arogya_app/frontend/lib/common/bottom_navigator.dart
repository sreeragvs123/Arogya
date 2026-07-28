import 'package:flutter/material.dart';


class ArogyaBottomNavigatorBar extends StatelessWidget {
  final int currIndex;
  final Function(int) onTap;

  const ArogyaBottomNavigatorBar({super.key,required this.currIndex,required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height:60,
      child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor:Colors.white,
          currentIndex: currIndex,
          onTap:onTap,
          items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: "Home",
            tooltip: "home"
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_outlined ),
            label:"Health Log",
            tooltip: "health log"
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.medication_outlined ),
            label:"Meds",
            tooltip: "meds"
          ),
                    BottomNavigationBarItem(
            icon: Icon(Icons.person_2_outlined ),
            label:"Profile",
            tooltip: "profile"
          ),
        ],
        ),
    );
  }
}