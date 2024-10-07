import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../provider/theme_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text('Settings'),
      ),
      body: SwitchListTile(
        title: const Text('Dark Mode'),
        value: themeMode == ThemeMode.dark,
        onChanged: (value) {
          ref.read(themeProvider.notifier).toggleTheme();
        },
      ),
    );
  }
}
