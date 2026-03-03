import 'package:flutter/material.dart';

class GraphPage extends StatelessWidget {
  const GraphPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      ),
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
      bottomNavigationBar: BottomNavigationBar(
        onTap:(index){
          if(index == 0){
            Navigator.pushNamed(context,'/graphPage');
          }
          else if(index == 1){
            Navigator.pushNamed(context,'/profilePage');
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
      ),
            
          
        );
  }
}