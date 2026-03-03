import 'package:flutter/material.dart';


class ArogyaBottomNavigatorBar extends StatelessWidget {
  const ArogyaBottomNavigatorBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        onTap:(index){
          if(index == 0){
            Navigator.pushReplacementNamed(context,'/graphPage');
          }
          else if(index == 1){
            Navigator.pushReplacementNamed(context,'/profilePage');
          }
        },
        items: [
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