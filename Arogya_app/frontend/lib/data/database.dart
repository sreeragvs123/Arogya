import "package:hive_flutter/hive_flutter.dart";

class DataBase{
  List savedAlarms =[];
  final _timeBox = Hive.box("alarmBox");

  void update(){
    _timeBox.put("Alarms",savedAlarms);
  }

  void load(){
    if(_timeBox.get('Alarms')==null)return;
    savedAlarms = _timeBox.get("Alarms");
  }

  void deleteAt(int index){
    savedAlarms.removeAt(index);
  }

}