import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionNotifier extends StateNotifier<bool> {
  SessionNotifier() : super(false) {
    _checkSession();
  }

  Future<void> _checkSession() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getBool('isLoggedIn') ?? false;
  }

  Future<void> login(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();

    String? savedEmail = prefs.getString('email');
    String? savedPass = prefs.getString('password');

    if (email == savedEmail && password == savedPass) {
      await prefs.setBool('isLoggedIn', true);
      state = true;
    }
  }

  Future<void> register(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
    await prefs.setString('password', password);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    state = false;
  }
}

final sessionProvider =
StateNotifierProvider<SessionNotifier, bool>((ref) => SessionNotifier());