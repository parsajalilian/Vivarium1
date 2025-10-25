import 'package:flutter/material.dart';

class AppTheme {
  static const _primary = Color(0xFF0EA5E9);
  static const _accent  = Color(0xFF02C39A);

  /// Headers (Home/Devices/Settings top bar)
  static const headerGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0E8AC0), Color(0xFF0F8F7A)],
  );

  /// Use transparent scaffold so pages can paint the nice gradient behind.
  static ThemeData get light {
    final base = ThemeData.light(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: Colors.transparent,
      colorScheme: base.colorScheme.copyWith(
        primary: _primary,
        secondary: _accent,
      ),
      bottomAppBarTheme: const BottomAppBarTheme(
        color: Color(0xFF1F2937),
        elevation: 0,
      ),
      switchTheme: const SwitchThemeData(
        thumbColor: WidgetStatePropertyAll(Colors.white),
      ),
      textTheme: base.textTheme.apply(
        bodyColor: const Color(0xFF0F172A),
        displayColor: const Color(0xFF0F172A),
      ),
    );
  }

  static ThemeData get dark {
    final base = ThemeData.dark(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: Colors.transparent,
      colorScheme: base.colorScheme.copyWith(
        primary: _primary,
        secondary: _accent,
      ),
      bottomAppBarTheme: const BottomAppBarTheme(
        color: Color(0xFF1F2937),
        elevation: 0,
      ),
      textTheme: base.textTheme.apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
    );
  }
}

/// Page backgrounds + header decoration
class AppDecor {
  /// New **light** gradient to match your screenshot, and the existing dark one.
  static BoxDecoration background(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    return BoxDecoration(
      gradient: isLight
          ? const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFFF7FBFF), // very pale blue
          Color(0xFFF1F6FF),
          Color(0xFFEAF2FF),
        ],
      )
          : const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF0F172A), // bgA
          Color(0xFF1E3A8A), // bgB
          Color(0xFF1E2A44), // bgC
        ],
      ),
    );
  }

  static const header = BoxDecoration(gradient: AppTheme.headerGradient);
}
