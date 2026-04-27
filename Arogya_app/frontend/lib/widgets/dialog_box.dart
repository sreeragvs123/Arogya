import "package:flutter/material.dart";


class DialogBox extends StatelessWidget{

  TextEditingController hourController;
  TextEditingController minuteController;
  VoidCallback onSave;

  DialogBox({super.key,required this.hourController,required this.minuteController,required this.onSave});

  

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      content: Container(
        height: 500,
        width:350,
        child:Column(
          children: [
            Text("Alarm",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30
              ),
            ),
            TextField(
              controller: hourController,
              keyboardType: TextInputType.number
              ),
            TextField(
              controller: minuteController,
              keyboardType: TextInputType.number,
            )
          ],
        )
      ),
      actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Close"),
          ),
          TextButton(
            onPressed:onSave,
            child:Text("Submit")
          )
      ]
    );
  }

}