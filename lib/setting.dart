import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import './providers/session_pro.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        automaticallyImplyLeading: true,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            ref.read(sessionProvider.notifier).logout();
          },
          child: const Text("LOGOUT"),
        ),
      ),
    );
  }
}
