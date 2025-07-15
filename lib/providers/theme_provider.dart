// lib/providers/theme_provider.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todoo_app/services/hive_service.dart';

class ThemeNotifier extends StateNotifier<ThemeMode> {
  final HiveService _hiveService;

  ThemeNotifier(this._hiveService) : super(ThemeMode.system) {
    _loadTheme();
  }

  static const String _themeKey = 'appThemeMode';

  // Method to load theme from Hive
  Future<void> _loadTheme() async {
    final savedThemeString = _hiveService.get<String>(_themeKey);
    if (savedThemeString != null) {
      state = ThemeMode.values.firstWhere(
        (e) => e.toString() == 'ThemeMode.$savedThemeString',
        orElse: () => ThemeMode.system,
      );
    } else {
      state = ThemeMode.system;
    }
  }

  // Method to toggle theme and save it
  void toggleTheme() {
    state = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    _hiveService.put(_themeKey, state.name);
  }
}

// The provider definition
final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  final hiveService = ref.read(hiveServiceProvider);
  return ThemeNotifier(hiveService);
});
