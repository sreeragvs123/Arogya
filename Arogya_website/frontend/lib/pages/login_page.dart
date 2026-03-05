import "package:flutter/material.dart";


class ArogyaLoginPage extends StatefulWidget {
  const ArogyaLoginPage({super.key});

  @override
  State<ArogyaLoginPage> createState() => _ArogyaLoginPageState();
}

class _ArogyaLoginPageState extends State<ArogyaLoginPage> {

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Center(
      child:Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children:[
          Text(
            "AROGYA",
            style:TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w900,
            )
          ),
          SizedBox(height: 50),
          SizedBox(
            width: 300,
            child: TextField(
              controller: usernameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Username",
              ),
            ),
          ),
          SizedBox(height: 20),
          SizedBox(
            width: 300,
            child: TextField(
              controller: passwordController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Password",
              ),
            ),
          ),
          SizedBox(height: 20),
          InkWell(
              onTap: () {
                print("Navigate to signup page");
              },
              child: Text(
                "Don't have an account? Sign Up",
                style: TextStyle(
                  color: Colors.blue,
                ),
              ),
          )
        ]

      )
      )
      );


  }
}