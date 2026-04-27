import 'package:flutter/material.dart';

class ArogyaAppBar extends StatelessWidget implements PreferredSizeWidget{
  final String title;
  final int index;
  const ArogyaAppBar({super.key,required this.title,required this.index});

  @override
  Widget build(BuildContext context) {
    return AppBar(
        toolbarHeight: 80,
        automaticallyImplyLeading: false,
        centerTitle: index == 0 ? true : false,
        backgroundColor: const Color.fromARGB(255, 196, 246, 253),
        title: Text(title,
            style: TextStyle(
              color:Colors.black,
              fontWeight: FontWeight.w900,
              fontSize: 30,
            ),
        ),
        actions: [
          IconButton(
            onPressed:(){
              Navigator.pushNamed(context,'/notificationpage');
            },
            icon:Icon(Icons.notifications)
          )
        ],
      );
  }
  
  @override
  Size get preferredSize => const Size.fromHeight(80);
}