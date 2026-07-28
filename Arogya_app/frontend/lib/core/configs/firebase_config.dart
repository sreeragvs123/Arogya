
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:frontend/core/network/api/message_api.dart';
import 'package:frontend/core/database/database.dart';
import 'package:frontend/firebase_options.dart';
import 'package:frontend/data/models/firebase_model.dart';

class FireBase{
  FirebaseDatabase database = FirebaseDatabase();
  MessageApi api = MessageApi();

  static void initializeFireBase() async{
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

    Future<void> syncMessageToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission();
    if (settings.authorizationStatus != AuthorizationStatus.authorized) return;

    String? freshToken = await messaging.getToken();
    if (freshToken == null) return;
    

    String? cachedToken = database.getMessageToken();
    if(cachedToken == null){
      final success = await api.sendTokenToBackend(MessageToken(token: freshToken));
      if (success) {
        database.addMessageToken(freshToken);
      }
    }

    if (freshToken != cachedToken) {
      final success = await api.sendTokenToBackend(MessageToken(token: freshToken));
      if (success) {
        database.addMessageToken(freshToken);
      }
    }

    // Handle mid-session refresh
    messaging.onTokenRefresh.listen((newToken) async {
      final success = await api.sendTokenToBackend(MessageToken(token: newToken));
      if (success) {
        database.addMessageToken(freshToken);
      }
    });
  }

    // Call this on logout
  /*Future<void> clearToken() async {
    await _box.delete(_tokenKey); // REVISE : NEED to add it later
    await FirebaseMessaging.instance.deleteToken();
  }*/
}