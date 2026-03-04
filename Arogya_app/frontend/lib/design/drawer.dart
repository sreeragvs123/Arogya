import "package:flutter/material.dart";



class ArogyaDrawer extends StatelessWidget {
  const ArogyaDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        backgroundColor: const Color.fromARGB(255, 213, 236, 255),
        child: Padding(
          padding: const EdgeInsets.only(top: 20, left: 20),
          child: Column(
            children: [
              DrawerHeader(
                child: Icon(
                  Icons.settings_accessibility,
                  size: 37,
                ),
              ),
              SizedBox(height:50),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text("S E T T I N G S"),
              ),
              SizedBox(height: 15),

              ListTile(
                leading: Icon(Icons.person),
                title: Text("P R O F I L E"),
              ),
              SizedBox(height: 15),

              ListTile(
                leading: Icon(Icons.account_box),
                title: Text("A C C O U N T"),
              ),
              SizedBox(height: 15),


              ListTile(
                leading: Icon(Icons.search),
                title: Text("S E A R C H"),
              ),

              Spacer(),

              ListTile(
                leading: Icon(Icons.person_2,size:30),
                title: Padding(
                      padding:EdgeInsetsGeometry.only(left:20),
                      child :Text("SREERAG . V .S"),
                ),
                contentPadding: EdgeInsets.all(20),
              ),
            ],
          ),
        ),
);

  }
}