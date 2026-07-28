import "package:flutter/material.dart";
import "package:hive_flutter/hive_flutter.dart";

class AlarmDatabase{
  List<String> savedAlarms =[];
  List<bool> isOn = [];
  final _timeBox = Hive.box("alarmBox");

  void update(){
    _timeBox.put("Alarms",savedAlarms);
    _timeBox.put("isOn",isOn);
  }

  void load(){

    if(_timeBox.get('Alarms')==null)return;
    savedAlarms = _timeBox.get("Alarms");
    isOn = _timeBox.get("isOn");
  }

  void deleteAt(int index){
    savedAlarms.removeAt(index);
    isOn.removeAt(index);
  }

}

class FirebaseDatabase{
  static const _messageTokenKey = 'fcm_token';
  final _firebaseBox = Hive.box("firebaseBox");

  void addMessageToken(String? token) {
    _firebaseBox.put("fcm_token",token);
  }

  String? getMessageToken(){
    String? token = _firebaseBox.get("fcm_token");
    return token;
  }


}