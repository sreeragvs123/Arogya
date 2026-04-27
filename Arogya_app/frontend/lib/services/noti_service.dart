import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';

class NotiService{

  final notificationPlugins = FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  //Initialize
  Future<void> initNotification() async{
    if(_isInitialized)return;//to prevent re-initialization

    //initialize the timezone
    tz.initializeTimeZones();
    final TimezoneInfo currentTimeZone = await FlutterTimezone.getLocalTimezone();
    final String tzId = currentTimeZone.toString()
    .replaceFirst('TimezoneInfo(', '')
    .split(',')[0];
    tz.setLocalLocation(tz.getLocation(tzId));



    //android init settings
    const initAndroidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

    //ios init settings
    const initIosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true
    );

    //init settings by grouping both
    const initSettings = InitializationSettings(
      android: initAndroidSettings,
      iOS : initIosSettings
    );

    //finally Initialize the plugin
    await notificationPlugins.initialize(settings: initSettings);

      final androidPlugin = notificationPlugins
    .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();


      await androidPlugin?.requestNotificationsPermission(); // Android 13+
      await androidPlugin?.requestExactAlarmsPermission();   // Android 12+
      // ---- END ----

      _isInitialized = true;
  }

  //Notification Details
  NotificationDetails notificationDetails(){
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'daily_channel_id',
        'Daily_Notification',
        channelDescription: 'Daily Notification Channel',
        importance: Importance.max,
        priority: Priority.high
        ),
      iOS: DarwinNotificationDetails()
    );
  }

  //Show Notification
  Future<void> showNotification({int id = 0, String? title,String? body}) async{
    return notificationPlugins.show(id: id,title: title,body: body,notificationDetails: notificationDetails());
  }

  ///Schedule notification
  Future<void> scheduleNotification({
    int id =10,
    required String title,
    required String body,
    required int hour,
    required int minute,
  })async{
    //Getting current time in local device
    final now = tz.TZDateTime.now(tz.local);

    //Scheduling a date/time for today at the specified hour/min
    var scheduledDate  = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute
    );

    await notificationPlugins.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: scheduledDate, 
      notificationDetails:  notificationDetails(),
      androidScheduleMode: AndroidScheduleMode.alarmClock,
      matchDateTimeComponents: DateTimeComponents.time
      );
    print("notificaiton scheduled");
    print("=== NOTIFICATION DEBUG ===");
    print("Current TZ: ${tz.local.name}");
    print("Now: $now");
    print("Scheduled for: $scheduledDate");
    print("Is in future: ${scheduledDate.isAfter(now)}");

  }

  //To Cancel all the notification
  Future<void> cancelAllNotification() async{
    await notificationPlugins.cancelAll();
  }  

}