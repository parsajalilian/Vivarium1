import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fa.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('fa'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Vivarium'**
  String get appTitle;

  /// No description provided for @appSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Control your devices'**
  String get appSubtitle;

  /// No description provided for @tagline.
  ///
  /// In en, this message translates to:
  /// **'Smart Ecosystem Management'**
  String get tagline;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @devices.
  ///
  /// In en, this message translates to:
  /// **'Devices'**
  String get devices;

  /// No description provided for @allDevices.
  ///
  /// In en, this message translates to:
  /// **'All Devices'**
  String get allDevices;

  /// No description provided for @noDevices.
  ///
  /// In en, this message translates to:
  /// **'No devices yet.\nAdd one to get started.'**
  String get noDevices;

  /// No description provided for @welcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to AquaViva'**
  String get welcomeTitle;

  /// No description provided for @welcomeBody.
  ///
  /// In en, this message translates to:
  /// **'Let\'s set up your smart ecosystem experience in a few steps.'**
  String get welcomeBody;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @completeSetup.
  ///
  /// In en, this message translates to:
  /// **'Complete Setup'**
  String get completeSetup;

  /// No description provided for @languageTitle.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageTitle;

  /// No description provided for @languageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose your preferred language'**
  String get languageSubtitle;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languagePersian.
  ///
  /// In en, this message translates to:
  /// **'فارسی'**
  String get languagePersian;

  /// No description provided for @languageArabic.
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get languageArabic;

  /// No description provided for @themeTitle.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get themeTitle;

  /// No description provided for @themeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose your preferred appearance'**
  String get themeSubtitle;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get themeDark;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get themeLight;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get themeSystem;

  /// No description provided for @termsTitle.
  ///
  /// In en, this message translates to:
  /// **'Terms of Use'**
  String get termsTitle;

  /// No description provided for @termsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Please review and accept our terms'**
  String get termsSubtitle;

  /// No description provided for @termsHeader.
  ///
  /// In en, this message translates to:
  /// **'AquaViva Terms of Service'**
  String get termsHeader;

  /// No description provided for @termsIntro.
  ///
  /// In en, this message translates to:
  /// **'By using AquaViva, you agree to the following terms and conditions:'**
  String get termsIntro;

  /// No description provided for @termsUsage.
  ///
  /// In en, this message translates to:
  /// **'1. Usage'**
  String get termsUsage;

  /// No description provided for @termsUsageDesc.
  ///
  /// In en, this message translates to:
  /// **'Use responsibly and follow all safety guidelines.'**
  String get termsUsageDesc;

  /// No description provided for @termsPrivacy.
  ///
  /// In en, this message translates to:
  /// **'2. Privacy'**
  String get termsPrivacy;

  /// No description provided for @termsPrivacyDesc.
  ///
  /// In en, this message translates to:
  /// **'We store data locally and only share with your consent.'**
  String get termsPrivacyDesc;

  /// No description provided for @termsLiability.
  ///
  /// In en, this message translates to:
  /// **'3. Liability'**
  String get termsLiability;

  /// No description provided for @termsLiabilityDesc.
  ///
  /// In en, this message translates to:
  /// **'You are responsible for your animals and devices.'**
  String get termsLiabilityDesc;

  /// No description provided for @termsUpdates.
  ///
  /// In en, this message translates to:
  /// **'4. Updates'**
  String get termsUpdates;

  /// No description provided for @termsUpdatesDesc.
  ///
  /// In en, this message translates to:
  /// **'Terms may change; continued use is acceptance.'**
  String get termsUpdatesDesc;

  /// No description provided for @termsCheckbox.
  ///
  /// In en, this message translates to:
  /// **'I have read and agree to the Terms of Use and Privacy Policy'**
  String get termsCheckbox;

  /// No description provided for @notificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsTitle;

  /// No description provided for @notificationsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Device alerts and updates'**
  String get notificationsSubtitle;

  /// No description provided for @syncTimeTitle.
  ///
  /// In en, this message translates to:
  /// **'Sync Time With Device'**
  String get syncTimeTitle;

  /// No description provided for @syncTimeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Synchronize device schedules'**
  String get syncTimeSubtitle;

  /// No description provided for @sync.
  ///
  /// In en, this message translates to:
  /// **'Sync'**
  String get sync;

  /// No description provided for @connectionStatusTitle.
  ///
  /// In en, this message translates to:
  /// **'Connection Status'**
  String get connectionStatusTitle;

  /// No description provided for @connectedToDevices.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0 {Not connected} =1 {Connected to 1 device} other {Connected to {count} devices}}'**
  String connectedToDevices(int count);

  /// No description provided for @aboutTitle.
  ///
  /// In en, this message translates to:
  /// **'About AquaViva'**
  String get aboutTitle;

  /// No description provided for @aboutBody1.
  ///
  /// In en, this message translates to:
  /// **'Smart ecosystem management for aquariums and vivariums.'**
  String get aboutBody1;

  /// No description provided for @aboutBody2.
  ///
  /// In en, this message translates to:
  /// **'Monitor and control your aquatic and terrestrial environments with ease.'**
  String get aboutBody2;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version {value}'**
  String version(String value);

  /// No description provided for @copyright.
  ///
  /// In en, this message translates to:
  /// **'© {year} AquaViva Technologies'**
  String copyright(String year);

  /// No description provided for @aquarium.
  ///
  /// In en, this message translates to:
  /// **'Aquarium'**
  String get aquarium;

  /// No description provided for @vivarium.
  ///
  /// In en, this message translates to:
  /// **'Vivarium'**
  String get vivarium;

  /// No description provided for @aquariumsTab.
  ///
  /// In en, this message translates to:
  /// **'Aquariums'**
  String get aquariumsTab;

  /// No description provided for @vivariumsTab.
  ///
  /// In en, this message translates to:
  /// **'Vivariums'**
  String get vivariumsTab;

  /// No description provided for @noAquariumsTitle.
  ///
  /// In en, this message translates to:
  /// **'No aquariums yet'**
  String get noAquariumsTitle;

  /// No description provided for @noVivariumsTitle.
  ///
  /// In en, this message translates to:
  /// **'No vivariums yet'**
  String get noVivariumsTitle;

  /// No description provided for @addDeviceHint.
  ///
  /// In en, this message translates to:
  /// **'Connect your aquarium or vivarium'**
  String get addDeviceHint;

  /// No description provided for @addDeviceTitle.
  ///
  /// In en, this message translates to:
  /// **'Add New Device'**
  String get addDeviceTitle;

  /// No description provided for @deviceNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Device Name'**
  String get deviceNameLabel;

  /// No description provided for @serialLabel.
  ///
  /// In en, this message translates to:
  /// **'Serial'**
  String get serialLabel;

  /// No description provided for @serialPrefix.
  ///
  /// In en, this message translates to:
  /// **'Serial:'**
  String get serialPrefix;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @statusTitle.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get statusTitle;

  /// No description provided for @temperature.
  ///
  /// In en, this message translates to:
  /// **'Temperature'**
  String get temperature;

  /// No description provided for @humidity.
  ///
  /// In en, this message translates to:
  /// **'Humidity'**
  String get humidity;

  /// No description provided for @online.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get online;

  /// No description provided for @offline.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get offline;

  /// No description provided for @controlsTitle.
  ///
  /// In en, this message translates to:
  /// **'Controls'**
  String get controlsTitle;

  /// No description provided for @lighting.
  ///
  /// In en, this message translates to:
  /// **'Lighting'**
  String get lighting;

  /// No description provided for @heater.
  ///
  /// In en, this message translates to:
  /// **'Heater'**
  String get heater;

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @humidification.
  ///
  /// In en, this message translates to:
  /// **'Humidification'**
  String get humidification;

  /// No description provided for @ventilation.
  ///
  /// In en, this message translates to:
  /// **'Ventilation'**
  String get ventilation;

  /// No description provided for @on.
  ///
  /// In en, this message translates to:
  /// **'On'**
  String get on;

  /// No description provided for @off.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get off;

  /// No description provided for @lightControl.
  ///
  /// In en, this message translates to:
  /// **'Light Control'**
  String get lightControl;

  /// No description provided for @lightControlTitle.
  ///
  /// In en, this message translates to:
  /// **'Light Control'**
  String get lightControlTitle;

  /// No description provided for @lightPower.
  ///
  /// In en, this message translates to:
  /// **'Light Power'**
  String get lightPower;

  /// No description provided for @lightHint.
  ///
  /// In en, this message translates to:
  /// **'Control your device lighting'**
  String get lightHint;

  /// No description provided for @toggleVivariumLight.
  ///
  /// In en, this message translates to:
  /// **'Toggle vivarium lighting.'**
  String get toggleVivariumLight;

  /// No description provided for @humidityControl.
  ///
  /// In en, this message translates to:
  /// **'Humidity Control'**
  String get humidityControl;

  /// No description provided for @humidityControlTitle.
  ///
  /// In en, this message translates to:
  /// **'Humidity Control'**
  String get humidityControlTitle;

  /// No description provided for @humiditySystem.
  ///
  /// In en, this message translates to:
  /// **'Humidity system'**
  String get humiditySystem;

  /// No description provided for @minutesUnit.
  ///
  /// In en, this message translates to:
  /// **'minutes'**
  String get minutesUnit;

  /// No description provided for @ventilationControl.
  ///
  /// In en, this message translates to:
  /// **'Ventilation Control'**
  String get ventilationControl;

  /// No description provided for @ventilationControlTitle.
  ///
  /// In en, this message translates to:
  /// **'Ventilation Control'**
  String get ventilationControlTitle;

  /// No description provided for @ventilationSystem.
  ///
  /// In en, this message translates to:
  /// **'Ventilation system'**
  String get ventilationSystem;

  /// No description provided for @fanPower.
  ///
  /// In en, this message translates to:
  /// **'Fan Power'**
  String get fanPower;

  /// No description provided for @fanHint.
  ///
  /// In en, this message translates to:
  /// **'Fan activates outside set temperature range.'**
  String get fanHint;

  /// No description provided for @onDuration.
  ///
  /// In en, this message translates to:
  /// **'On Duration'**
  String get onDuration;

  /// No description provided for @totalCycle.
  ///
  /// In en, this message translates to:
  /// **'Total Cycle'**
  String get totalCycle;

  /// No description provided for @onDurationLabel.
  ///
  /// In en, this message translates to:
  /// **'On Duration'**
  String get onDurationLabel;

  /// No description provided for @cycleDurationLabel.
  ///
  /// In en, this message translates to:
  /// **'Cycle Duration'**
  String get cycleDurationLabel;

  /// No description provided for @upperTempLimit.
  ///
  /// In en, this message translates to:
  /// **'Upper Temperature Limit'**
  String get upperTempLimit;

  /// No description provided for @lowerTempLimit.
  ///
  /// In en, this message translates to:
  /// **'Lower Temperature Limit'**
  String get lowerTempLimit;

  /// No description provided for @humidityHint.
  ///
  /// In en, this message translates to:
  /// **'System runs for {onMinutes}m every {cycleMinutes}m when enabled.'**
  String humidityHint(Object cycleMinutes, Object onMinutes);

  /// No description provided for @ventilationHint.
  ///
  /// In en, this message translates to:
  /// **'Fan activates above the upper limit (and/or below the lower limit if set).'**
  String get ventilationHint;

  /// No description provided for @systemWillRun.
  ///
  /// In en, this message translates to:
  /// **'system will run'**
  String get systemWillRun;

  /// No description provided for @every.
  ///
  /// In en, this message translates to:
  /// **'every'**
  String get every;

  /// No description provided for @sunriseSunsetTitle.
  ///
  /// In en, this message translates to:
  /// **'Sunrise/Sunset Simulator'**
  String get sunriseSunsetTitle;

  /// No description provided for @sunriseLabel.
  ///
  /// In en, this message translates to:
  /// **'Sunrise'**
  String get sunriseLabel;

  /// No description provided for @sunsetLabel.
  ///
  /// In en, this message translates to:
  /// **'Sunset'**
  String get sunsetLabel;

  /// No description provided for @currentTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Current Time'**
  String get currentTimeLabel;

  /// No description provided for @mistRunHint.
  ///
  /// In en, this message translates to:
  /// **'Runs for {on} min every {cycle} min'**
  String mistRunHint(Object cycle, Object on);

  /// No description provided for @mistRunHintMinutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes} minutes'**
  String mistRunHintMinutes(Object minutes);

  /// No description provided for @mistRunHintCycle.
  ///
  /// In en, this message translates to:
  /// **'{cycle} minutes'**
  String mistRunHintCycle(Object cycle);

  /// No description provided for @dangerZone.
  ///
  /// In en, this message translates to:
  /// **'Delete Device'**
  String get dangerZone;

  /// No description provided for @deleteDeviceTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete device'**
  String get deleteDeviceTitle;

  /// No description provided for @deleteDeviceConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove this device?'**
  String get deleteDeviceConfirmation;

  /// No description provided for @deleteDeviceHint.
  ///
  /// In en, this message translates to:
  /// **'You can permanently remove this device from the app.'**
  String get deleteDeviceHint;

  /// No description provided for @deviceDeleted.
  ///
  /// In en, this message translates to:
  /// **'Device deleted'**
  String get deviceDeleted;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @connect.
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get connect;

  /// No description provided for @humidifier.
  ///
  /// In en, this message translates to:
  /// **'Humidifier'**
  String get humidifier;

  /// No description provided for @connected.
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get connected;

  /// No description provided for @disconnecting.
  ///
  /// In en, this message translates to:
  /// **'Disconnecting'**
  String get disconnecting;

  /// No description provided for @lowerHumidityLimit.
  ///
  /// In en, this message translates to:
  /// **'Lower Humidity Limit'**
  String get lowerHumidityLimit;

  /// No description provided for @upperHumidityLimit.
  ///
  /// In en, this message translates to:
  /// **'Upper Humidity Limit'**
  String get upperHumidityLimit;

  /// No description provided for @mode.
  ///
  /// In en, this message translates to:
  /// **'Mode'**
  String get mode;

  /// No description provided for @autoMode.
  ///
  /// In en, this message translates to:
  /// **'Automatic'**
  String get autoMode;

  /// No description provided for @manualMode.
  ///
  /// In en, this message translates to:
  /// **'Manual'**
  String get manualMode;

  /// No description provided for @mistOnCycle.
  ///
  /// In en, this message translates to:
  /// **'On duration'**
  String get mistOnCycle;

  /// No description provided for @mistCycleTitle.
  ///
  /// In en, this message translates to:
  /// **'Mist cycle'**
  String get mistCycleTitle;

  /// No description provided for @mistOffCycle.
  ///
  /// In en, this message translates to:
  /// **'Off duration'**
  String get mistOffCycle;

  /// No description provided for @syncTime.
  ///
  /// In en, this message translates to:
  /// **'Sync Time'**
  String get syncTime;

  /// No description provided for @saveSettings.
  ///
  /// In en, this message translates to:
  /// **'Save Settings'**
  String get saveSettings;

  /// No description provided for @mistCycleSettings.
  ///
  /// In en, this message translates to:
  /// **'Misting Cycle Settings'**
  String get mistCycleSettings;

  /// No description provided for @deleteDevice.
  ///
  /// In en, this message translates to:
  /// **'Delete device'**
  String get deleteDevice;

  /// No description provided for @renameDevice.
  ///
  /// In en, this message translates to:
  /// **'Rename device'**
  String get renameDevice;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @lightOnTime.
  ///
  /// In en, this message translates to:
  /// **'Light ON Time'**
  String get lightOnTime;

  /// No description provided for @lightOffTime.
  ///
  /// In en, this message translates to:
  /// **'Light OFF Time'**
  String get lightOffTime;

  /// No description provided for @ventilationSettings.
  ///
  /// In en, this message translates to:
  /// **'Ventilation Settings'**
  String get ventilationSettings;

  /// No description provided for @rename.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get rename;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @renameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter new name'**
  String get renameHint;

  /// No description provided for @deleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this device? This action cannot be undone.'**
  String get deleteConfirm;

  /// No description provided for @lightTimer.
  ///
  /// In en, this message translates to:
  /// **'Light Timer'**
  String get lightTimer;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en', 'fa'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'fa':
      return AppLocalizationsFa();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
