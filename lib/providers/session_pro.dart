import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:projek_one/models/report_model.dart';

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

class ReportListNotifier extends StateNotifier<List<ReportModel>> {
  ReportListNotifier() : super([]);

  //Insert
  Future<void> addReport(ReportModel newReport) async {
    await Future.delayed(const Duration(seconds: 1));
    state = [...state, newReport];
    print('Laporan berhasil disimpan: ${newReport.title}');
  }
}

final reportListProvider = StateNotifierProvider<ReportListNotifier, List<ReportModel>>((ref) {
  return ReportListNotifier();
});