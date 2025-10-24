import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends ChangeNotifier {
  ThemeController(this._mode);
  ThemeMode _mode;
  ThemeMode get mode => _mode;

  static const _key = 'theme_mode'; // 'light' | 'dark' | 'system'

  Future<void> setMode(ThemeMode mode) async {
    if (mode == _mode) return;
    _mode = mode;
    notifyListeners(); // triggers instant rebuild everywhere
    final p = await SharedPreferences.getInstance();
    await p.setString(_key, switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      _ => 'system',
    });
  }

  static Future<ThemeController> load() async {
    final p = await SharedPreferences.getInstance();
    final s = p.getString(_key) ?? 'dark';
    final mode = switch (s) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
    return ThemeController(mode);
  }
}

/// Lightweight provider without extra packages.
class ThemeControllerScope extends InheritedNotifier<ThemeController> {
  const ThemeControllerScope({
    super.key,
    required ThemeController controller,
    required Widget child,
  }) : super(notifier: controller, child: child);

  static ThemeController of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ThemeControllerScope>()!.notifier!;
}
