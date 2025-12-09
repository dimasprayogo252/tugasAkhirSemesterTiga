import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth/login.dart';
import 'screens/homescreen.dart';
import 'providers/session_pro.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoggedIn = ref.watch(sessionProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: isLoggedIn ? const LoginScreen() : const HomeScreen(),
    );
  }
}
