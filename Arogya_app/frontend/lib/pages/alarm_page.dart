import 'package:flutter/material.dart';
import 'package:frontend/widgets/alarm_card.dart';
import "package:hive_flutter/hive_flutter.dart";
import "package:frontend/data/database.dart";
import 'package:frontend/widgets/dialog_box.dart';
import 'package:frontend/widgets/alarm_card.dart';


class AlarmPage extends StatefulWidget {
  
  const AlarmPage({super.key});
  @override
  State<AlarmPage> createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {

  final hourController = TextEditingController();
  final minuteController = TextEditingController();
  DataBase db = DataBase();

  @override
  void initState(){
    db.load();
    super.initState();
  }


  @override
  void dispose() {
    hourController.dispose();
    minuteController.dispose();
    super.dispose();
  }




  void createTime(){
    setState(() {
      String hour = hourController.text;
      String minute = minuteController.text;
      db.savedAlarms.add([hour,minute]);
      hourController.clear();
      minuteController.clear();
    });
    db.update();
    Navigator.pop(context);
  }

  
  void createAlarm(){
    showDialog(
      context: context,
      builder: (_){
        return DialogBox(hourController: hourController,minuteController: minuteController,onSave: createTime);
      });
  }

  void deleteAlarm(int index){
    setState((){
      db.deleteAt(index);
    });
    db.update();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: SizedBox(
          width: 60,
          height: 60,
          child: FloatingActionButton(
            onPressed: createAlarm,
            child: Icon(Icons.add, size: 30),
          ),
      ),
      body:Container(
        color: Colors.amberAccent,
        child: ListView.builder(
          itemCount: db.savedAlarms.length,
          itemBuilder: (context,index){
            return AlarmCard(index:index,hour: db.savedAlarms[index][0],minute:db.savedAlarms[index][1],onDelete: (context)=>deleteAlarm(index));
        }),
      )
    );
  }









}