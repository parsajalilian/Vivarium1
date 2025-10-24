import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'core/l10n/app_localizations.dart';
import 'data/device_provider.dart';
import 'data/repositories/device_repository.dart';
import 'data/services/vivarium_controller.dart';
import 'features/3_device_control/bloc/device_control_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final themeController = await ThemeController.load();
  final localeController = await LocaleController.load();
  final deviceRepository = DeviceRepository();

  final deviceProvider = DeviceProvider(deviceRepository);
  await deviceProvider.load();
  print('✅ Main: DeviceProvider load() completed. App is starting...');

  runApp(
    ThemeControllerScope(
      controller: themeController,
      child: LocaleControllerScope(
        controller: localeController,
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider<DeviceProvider>.value(
              value: deviceProvider,
            ),
            BlocProvider<DeviceControlBloc>(
              create: (context) => DeviceControlBloc(
                controller: VivariumController(),
                deviceProvider: deviceProvider,
              ),
              lazy: false,
            ),
          ],
          child: AquaVivaApp(
            themeController: themeController,
            localeController: localeController,
          ),
        ),
      ),
    ),
  );
}

class AquaVivaApp extends StatelessWidget {
  const AquaVivaApp({
    super.key,
    required this.themeController,
    required this.localeController,
  });

  final ThemeController themeController;
  final LocaleController localeController;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([themeController, localeController]),
      builder: (_, __) {
        return MaterialApp(
          title: 'AquaViva',
          debugShowCheckedModeBanner: false,
          locale: localeController.locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          onGenerateRoute: AppRouter.onGenerateRoute,
          initialRoute: '/splash',
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: themeController.mode,
        );
      },
    );
  }
}

class LocaleController extends ChangeNotifier {
  LocaleController(this._locale);
  Locale _locale;
  Locale get locale => _locale;

  static const _prefKey = 'app_language';

  static Future<LocaleController> load() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_prefKey) ?? 'en';
    return LocaleController(Locale(code));
  }

  Future<void> setLocale(Locale locale) async {
    if (_locale == locale) return;
    _locale = locale;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefKey, locale.languageCode);
  }
}

class LocaleControllerScope extends InheritedNotifier<LocaleController> {
  const LocaleControllerScope({
    super.key,
    required LocaleController controller,
    required Widget child,
  }) : super(notifier: controller, child: child);

  static LocaleController of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<LocaleControllerScope>()!.notifier!;
}