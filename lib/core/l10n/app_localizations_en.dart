// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Vivarium';

  @override
  String get appSubtitle => 'Control your devices';

  @override
  String get tagline => 'Smart Ecosystem Management';

  @override
  String get home => 'Home';

  @override
  String get settings => 'Settings';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get devices => 'Devices';

  @override
  String get allDevices => 'All Devices';

  @override
  String get noDevices => 'No devices yet.\nAdd one to get started.';

  @override
  String get welcomeTitle => 'Welcome to AquaViva';

  @override
  String get welcomeBody =>
      'Let\'s set up your smart ecosystem experience in a few steps.';

  @override
  String get welcome => 'Welcome';

  @override
  String get getStarted => 'Get Started';

  @override
  String get next => 'Next';

  @override
  String get back => 'Back';

  @override
  String get cancel => 'Cancel';

  @override
  String get add => 'Add';

  @override
  String get completeSetup => 'Complete Setup';

  @override
  String get languageTitle => 'Language';

  @override
  String get languageSubtitle => 'Choose your preferred language';

  @override
  String get languageEnglish => 'English';

  @override
  String get languagePersian => 'فارسی';

  @override
  String get languageArabic => 'العربية';

  @override
  String get themeTitle => 'Theme';

  @override
  String get themeSubtitle => 'Choose your preferred appearance';

  @override
  String get themeDark => 'Dark Mode';

  @override
  String get themeLight => 'Light Mode';

  @override
  String get themeSystem => 'System Default';

  @override
  String get termsTitle => 'Terms of Use';

  @override
  String get termsSubtitle => 'Please review and accept our terms';

  @override
  String get termsHeader => 'AquaViva Terms of Service';

  @override
  String get termsIntro =>
      'By using AquaViva, you agree to the following terms and conditions:';

  @override
  String get termsUsage => '1. Usage';

  @override
  String get termsUsageDesc =>
      'Use responsibly and follow all safety guidelines.';

  @override
  String get termsPrivacy => '2. Privacy';

  @override
  String get termsPrivacyDesc =>
      'We store data locally and only share with your consent.';

  @override
  String get termsLiability => '3. Liability';

  @override
  String get termsLiabilityDesc =>
      'You are responsible for your animals and devices.';

  @override
  String get termsUpdates => '4. Updates';

  @override
  String get termsUpdatesDesc =>
      'Terms may change; continued use is acceptance.';

  @override
  String get termsCheckbox =>
      'I have read and agree to the Terms of Use and Privacy Policy';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get notificationsSubtitle => 'Device alerts and updates';

  @override
  String get syncTimeTitle => 'Sync Time With Device';

  @override
  String get syncTimeSubtitle => 'Synchronize device schedules';

  @override
  String get sync => 'Sync';

  @override
  String get connectionStatusTitle => 'Connection Status';

  @override
  String connectedToDevices(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Connected to $count devices',
      one: 'Connected to 1 device',
      zero: 'Not connected',
    );
    return '$_temp0';
  }

  @override
  String get aboutTitle => 'About AquaViva';

  @override
  String get aboutBody1 =>
      'Smart ecosystem management for aquariums and vivariums.';

  @override
  String get aboutBody2 =>
      'Monitor and control your aquatic and terrestrial environments with ease.';

  @override
  String version(String value) {
    return 'Version $value';
  }

  @override
  String copyright(String year) {
    return '© $year AquaViva Technologies';
  }

  @override
  String get aquarium => 'Aquarium';

  @override
  String get vivarium => 'Vivarium';

  @override
  String get aquariumsTab => 'Aquariums';

  @override
  String get vivariumsTab => 'Vivariums';

  @override
  String get noAquariumsTitle => 'No aquariums yet';

  @override
  String get noVivariumsTitle => 'No vivariums yet';

  @override
  String get addDeviceHint => 'Connect your aquarium or vivarium';

  @override
  String get addDeviceTitle => 'Add New Device';

  @override
  String get deviceNameLabel => 'Device Name';

  @override
  String get serialLabel => 'Serial';

  @override
  String get serialPrefix => 'Serial:';

  @override
  String get status => 'Status';

  @override
  String get statusTitle => 'Status';

  @override
  String get temperature => 'Temperature';

  @override
  String get humidity => 'Humidity';

  @override
  String get online => 'Online';

  @override
  String get offline => 'Offline';

  @override
  String get controlsTitle => 'Controls';

  @override
  String get lighting => 'Lighting';

  @override
  String get heater => 'Heater';

  @override
  String get filter => 'Filter';

  @override
  String get light => 'Light';

  @override
  String get humidification => 'Humidification';

  @override
  String get ventilation => 'Ventilation';

  @override
  String get on => 'On';

  @override
  String get off => 'Off';

  @override
  String get lightControl => 'Light Control';

  @override
  String get lightControlTitle => 'Light Control';

  @override
  String get lightPower => 'Light Power';

  @override
  String get lightHint => 'Control your device lighting';

  @override
  String get toggleVivariumLight => 'Toggle vivarium lighting.';

  @override
  String get humidityControl => 'Humidity Control';

  @override
  String get humidityControlTitle => 'Humidity Control';

  @override
  String get humiditySystem => 'Humidity system';

  @override
  String get minutesUnit => 'minutes';

  @override
  String get ventilationControl => 'Ventilation Control';

  @override
  String get ventilationControlTitle => 'Ventilation Control';

  @override
  String get ventilationSystem => 'Ventilation system';

  @override
  String get fanPower => 'Fan Power';

  @override
  String get fanHint => 'Fan activates outside set temperature range.';

  @override
  String get onDuration => 'On Duration';

  @override
  String get totalCycle => 'Total Cycle';

  @override
  String get onDurationLabel => 'On Duration';

  @override
  String get cycleDurationLabel => 'Cycle Duration';

  @override
  String get upperTempLimit => 'Upper Temperature Limit';

  @override
  String get lowerTempLimit => 'Lower Temperature Limit';

  @override
  String humidityHint(Object cycleMinutes, Object onMinutes) {
    return 'System runs for ${onMinutes}m every ${cycleMinutes}m when enabled.';
  }

  @override
  String get ventilationHint =>
      'Fan activates above the upper limit (and/or below the lower limit if set).';

  @override
  String get systemWillRun => 'system will run';

  @override
  String get every => 'every';

  @override
  String get sunriseSunsetTitle => 'Sunrise/Sunset Simulator';

  @override
  String get sunriseLabel => 'Sunrise';

  @override
  String get sunsetLabel => 'Sunset';

  @override
  String get currentTimeLabel => 'Current Time';

  @override
  String mistRunHint(Object cycle, Object on) {
    return 'Runs for $on min every $cycle min';
  }

  @override
  String mistRunHintMinutes(Object minutes) {
    return '$minutes minutes';
  }

  @override
  String mistRunHintCycle(Object cycle) {
    return '$cycle minutes';
  }

  @override
  String get dangerZone => 'Delete Device';

  @override
  String get deleteDeviceTitle => 'Delete device';

  @override
  String get deleteDeviceConfirmation =>
      'Are you sure you want to remove this device?';

  @override
  String get deleteDeviceHint =>
      'You can permanently remove this device from the app.';

  @override
  String get deviceDeleted => 'Device deleted';

  @override
  String get delete => 'Delete';

  @override
  String get connect => 'Connect';

  @override
  String get humidifier => 'Humidifier';

  @override
  String get connected => 'Connected';

  @override
  String get disconnecting => 'Disconnecting';

  @override
  String get lowerHumidityLimit => 'Lower Humidity Limit';

  @override
  String get upperHumidityLimit => 'Upper Humidity Limit';

  @override
  String get mode => 'Mode';

  @override
  String get autoMode => 'Automatic';

  @override
  String get manualMode => 'Manual';

  @override
  String get mistOnCycle => 'On duration';

  @override
  String get mistCycleTitle => 'Mist cycle';

  @override
  String get mistOffCycle => 'Off duration';

  @override
  String get syncTime => 'Sync Time';

  @override
  String get saveSettings => 'Save Settings';

  @override
  String get mistCycleSettings => 'Misting Cycle Settings';

  @override
  String get deleteDevice => 'Delete device';

  @override
  String get renameDevice => 'Rename device';

  @override
  String get ok => 'OK';

  @override
  String get lightOnTime => 'Light ON Time';

  @override
  String get lightOffTime => 'Light OFF Time';

  @override
  String get ventilationSettings => 'Ventilation Settings';

  @override
  String get rename => 'Rename';

  @override
  String get save => 'Save';

  @override
  String get renameHint => 'Enter new name';

  @override
  String get deleteConfirm =>
      'Are you sure you want to delete this device? This action cannot be undone.';

  @override
  String get lightTimer => 'Light Timer';
}
