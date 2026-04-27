import "package:flutter/material.dart";
import "package:frontend/services/noti_service.dart";
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {

  final NotiService _notiService = NotiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed:(){
                print("show");
                _notiService.showNotification(
                  title: "Medication",
                  body:"This is a prescrpiton",
                );
                print("showed");
              }
            , child: const Text('Show Notification')
            ),
            ElevatedButton(
              onPressed:(){
                print("Schedule");
                _notiService.scheduleNotification(
                  title: "Medication",
                  body:"This is a prescrpiton",
                  hour:8,
                  minute:5
                );
                print("scheduled");
              }
            , child: const Text('Schedule Notification')
            ),
            ElevatedButton(
                  onPressed: () async {
                    // Schedule 1 minute from now
                    final now = tz.TZDateTime.now(tz.local);
                    final scheduledDate = now.add(const Duration(minutes: 1));

                    await _notiService.notificationPlugins.zonedSchedule(
                      id: 99,
                      title: "Test",
                      body: "Did it fire?",
                      scheduledDate: scheduledDate,
                      notificationDetails: _notiService.notificationDetails(),
                      androidScheduleMode: AndroidScheduleMode.alarmClock,
                    );

                    print("Scheduled for: $scheduledDate");
                    print("Current time:  $now");
                  },
                  child: const Text("Test 1 min notification"),
            ),
          ],
        )
      ),
    );
  }
}