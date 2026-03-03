import 'package:flutter/material.dart';

class ArogyaAppBar extends StatelessWidget implements PreferredSizeWidget{
  const ArogyaAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
        toolbarHeight: 80,
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 196, 246, 253),
        title: Text("Arogya",
            style: TextStyle(
              color:Colors.black,
              fontWeight: FontWeight.w900,
              fontSize: 30,
            ),
        )
      );
  }
  
  @override
  Size get preferredSize => const Size.fromHeight(80);
}