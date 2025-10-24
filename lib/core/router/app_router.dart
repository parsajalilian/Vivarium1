// lib/core/router/app_router.dart
import 'package:flutter/material.dart';

// Setup / shell
import 'package:aquaviva/features/1_setup/view/splash_screen.dart';
import 'package:aquaviva/features/1_setup/view/onboarding_flow_page.dart';
import 'package:aquaviva/features/0_shell/view/main_shell.dart';

// Device details
import 'package:aquaviva/features/3_device_control/view/vivarium_detail_page.dart';

// Device model
import 'package:aquaviva/data/models/device.dart' as models;

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
      case '/splash':
        return MaterialPageRoute(builder: (_) => const SplashPage());

      case '/onboarding':
        return MaterialPageRoute(builder: (_) => const OnboardingFlowPage());

      case '/main':
        return MaterialPageRoute(builder: (_) => const MainShell());

    // ---------- Device detail route ----------
      case '/vivarium': {
        final args = settings.arguments;
        if (args is Map && args['device'] is models.Device) {
          final d = args['device'] as models.Device;
          return MaterialPageRoute(builder: (_) => VivariumDetailPage(device: d));
        }
        return _errorPage('Invalid arguments for /vivarium');
      }

      default:
        return MaterialPageRoute(builder: (_) => const SplashPage());
    }
  }

  static MaterialPageRoute _errorPage(String message) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Route Error')),
        body: Center(child: Text(message)),
      ),
    );
  }
}
