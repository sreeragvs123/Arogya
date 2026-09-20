  // core/storage/session_storage.dart
  import 'dart:convert';
  import 'package:shared_preferences/shared_preferences.dart';
  import 'package:frontend/domain/entities/auth/auth_session.dart';

  class SessionStorage {
    static const _authSessionKey = 'auth_session';

    Future<void> save(AuthSession session) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_authSessionKey, jsonEncode(session.toJson()));
    }

    Future<AuthSession?> read() async {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_authSessionKey);
      if (raw == null) return null;

      try {
        return AuthSession.fromJson(jsonDecode(raw) as Map<String, dynamic>);
      } catch (_) {
        await prefs.remove(_authSessionKey); 
        return null;
      }
    }

    Future<void> clear() async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_authSessionKey);
    }
  }
