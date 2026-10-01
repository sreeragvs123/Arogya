  // core/storage/session_storage.dart
  import 'dart:convert';
  import 'package:hive/hive.dart';
  import 'package:shared_preferences/shared_preferences.dart';
  import 'package:frontend/domain/entities/auth/auth_session.dart';

  class SessionStorage {
    static const _authSessionKey = 'auth_session';

    Future<void> save(AuthSession session) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_authSessionKey, jsonEncode(session.toJson()));
      await Hive.box('authBox').put('accessToken', session.accessToken);
    }

    Future<AuthSession?> read() async {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_authSessionKey);
      if (raw == null) return null;

      try {
        final session = AuthSession.fromJson(jsonDecode(raw) as Map<String, dynamic>);
        await Hive.box('authBox').put('accessToken', session.accessToken);
        return session;
      } catch (_) {
        await prefs.remove(_authSessionKey); 
        await Hive.box('authBox').delete('accessToken');
        return null;
      }
    }

    Future<void> clear() async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_authSessionKey);
      await Hive.box('authBox').delete('accessToken');
    }
  }
 