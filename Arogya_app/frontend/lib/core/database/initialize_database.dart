import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Database{
  static void initialize() async{
    await Hive.initFlutter();
    await Hive.openBox("authBox");
    await Hive.openBox("alarmBox");
    await Hive.openBox("firebaseBox");
  }
}