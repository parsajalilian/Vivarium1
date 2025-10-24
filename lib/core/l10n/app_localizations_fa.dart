// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Persian (`fa`).
class AppLocalizationsFa extends AppLocalizations {
  AppLocalizationsFa([String locale = 'fa']) : super(locale);

  @override
  String get appTitle => 'کنترل AquaViva';

  @override
  String get appSubtitle => 'مدیریت هوشمند اکوسیستم';

  @override
  String get tagline => 'مدیریت هوشمند اکوسیستم';

  @override
  String get home => 'خانه';

  @override
  String get settings => 'تنظیمات';

  @override
  String get settingsTitle => 'تنظیمات';

  @override
  String get devices => 'دستگاه‌ها';

  @override
  String get allDevices => 'همه دستگاه‌ها';

  @override
  String get noDevices =>
      'هنوز دستگاهی اضافه نشده است.\nبرای شروع یکی اضافه کنید.';

  @override
  String get welcomeTitle => 'به آکواویوا خوش آمدید';

  @override
  String get welcomeBody =>
      'بیایید در چند مرحله تجربه اکوسیستم هوشمند شما را راه‌اندازی کنیم.';

  @override
  String get welcome => 'خوش آمدید';

  @override
  String get getStarted => 'شروع کنید';

  @override
  String get next => 'بعدی';

  @override
  String get back => 'قبلی';

  @override
  String get cancel => 'انصراف';

  @override
  String get add => 'افزودن';

  @override
  String get completeSetup => 'تکمیل راه‌اندازی';

  @override
  String get languageTitle => 'زبان';

  @override
  String get languageSubtitle => 'زبان مورد نظر خود را انتخاب کنید';

  @override
  String get languageEnglish => 'English';

  @override
  String get languagePersian => 'فارسی';

  @override
  String get languageArabic => 'العربية';

  @override
  String get themeTitle => 'پوسته';

  @override
  String get themeSubtitle => 'ظاهر مورد نظر خود را انتخاب کنید';

  @override
  String get themeDark => 'حالت تاریک';

  @override
  String get themeLight => 'حالت روشن';

  @override
  String get themeSystem => 'System Default';

  @override
  String get termsTitle => 'شرایط استفاده';

  @override
  String get termsSubtitle => 'لطفاً شرایط ما را بررسی و قبول کنید';

  @override
  String get termsHeader => 'شرایط خدمات آکواویوا';

  @override
  String get termsIntro =>
      'با استفاده از آکواویوا، شما با شرایط زیر موافقت می‌کنید:';

  @override
  String get termsUsage => '۱. استفاده';

  @override
  String get termsUsageDesc =>
      'با مسئولیت استفاده کنید و دستورالعمل‌های ایمنی را رعایت نمایید.';

  @override
  String get termsPrivacy => '۲. حریم خصوصی';

  @override
  String get termsPrivacyDesc =>
      'اطلاعات محلی ذخیره می‌شوند و فقط با رضایت شما به اشتراک گذاشته می‌شوند.';

  @override
  String get termsLiability => '۳. مسئولیت';

  @override
  String get termsLiabilityDesc => 'شما مسئول حیوانات و دستگاه‌های خود هستید.';

  @override
  String get termsUpdates => '۴. به‌روزرسانی‌ها';

  @override
  String get termsUpdatesDesc =>
      'شرایط ممکن است تغییر کند؛ استفاده مداوم به معنای پذیرش است.';

  @override
  String get termsCheckbox =>
      'من شرایط استفاده و سیاست حفظ حریم خصوصی را خوانده‌ام و قبول دارم';

  @override
  String get notificationsTitle => 'اعلان‌ها';

  @override
  String get notificationsSubtitle => 'هشدارها و به‌روزرسانی‌های دستگاه';

  @override
  String get syncTimeTitle => 'همگام‌سازی زمان با دستگاه';

  @override
  String get syncTimeSubtitle => 'زمان‌بندی دستگاه را همگام کنید';

  @override
  String get sync => 'همگام‌سازی';

  @override
  String get connectionStatusTitle => 'وضعیت اتصال';

  @override
  String connectedToDevices(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'متصل به $count دستگاه',
      one: 'متصل به یک دستگاه',
      zero: 'اتصال برقرار نیست',
    );
    return '$_temp0';
  }

  @override
  String get aboutTitle => 'درباره آکواویوا';

  @override
  String get aboutBody1 =>
      'مدیریت هوشمند اکوسیستم برای آکواریوم‌ها و ویواریوم‌ها.';

  @override
  String get aboutBody2 =>
      'محیط‌های آبی و زمینی خود را به راحتی کنترل و پایش کنید.';

  @override
  String version(String value) {
    return 'نسخه $value';
  }

  @override
  String copyright(String year) {
    return '© $year فناوری‌های آکواویوا';
  }

  @override
  String get aquarium => 'آکواریوم';

  @override
  String get vivarium => 'ویواریوم';

  @override
  String get aquariumsTab => 'آکواریوم‌ها';

  @override
  String get vivariumsTab => 'ویواریوم‌ها';

  @override
  String get noAquariumsTitle => 'هیچ آکواریومی نیست';

  @override
  String get noVivariumsTitle => 'هیچ ویواریومی نیست';

  @override
  String get addDeviceHint => 'آکواریوم یا ویواریوم خود را متصل کنید';

  @override
  String get addDeviceTitle => 'افزودن دستگاه جدید';

  @override
  String get deviceNameLabel => 'نام دستگاه';

  @override
  String get serialLabel => 'سریال';

  @override
  String get serialPrefix => 'سریال:';

  @override
  String get status => 'وضعیت';

  @override
  String get statusTitle => 'وضعیت';

  @override
  String get temperature => 'دما';

  @override
  String get humidity => 'رطوبت';

  @override
  String get online => 'آنلاین';

  @override
  String get offline => 'آفلاین';

  @override
  String get controlsTitle => 'کنترل‌ها';

  @override
  String get lighting => 'روشنایی';

  @override
  String get heater => 'بخاری';

  @override
  String get filter => 'فیلتر';

  @override
  String get light => 'نور';

  @override
  String get humidification => 'رطوبت‌ساز';

  @override
  String get ventilation => 'تهویه';

  @override
  String get on => 'روشن';

  @override
  String get off => 'خاموش';

  @override
  String get lightControl => 'کنترل نور';

  @override
  String get lightControlTitle => 'کنترل نور';

  @override
  String get lightPower => 'قدرت نور';

  @override
  String get lightHint => 'کنترل روشنایی دستگاه شما';

  @override
  String get toggleVivariumLight => 'روشن/خاموش کردن نور ویواریوم.';

  @override
  String get humidityControl => 'کنترل رطوبت';

  @override
  String get humidityControlTitle => 'کنترل رطوبت';

  @override
  String get humiditySystem => 'سیستم رطوبت';

  @override
  String get minutesUnit => 'دقیقه';

  @override
  String get ventilationControl => 'کنترل تهویه';

  @override
  String get ventilationControlTitle => 'کنترل تهویه';

  @override
  String get ventilationSystem => 'سیستم تهویه';

  @override
  String get fanPower => 'قدرت فن';

  @override
  String get fanHint => 'فن خارج از محدوده دما فعال می‌شود.';

  @override
  String get onDuration => 'مدت زمان روشن';

  @override
  String get totalCycle => 'کل چرخه';

  @override
  String get onDurationLabel => 'مدت زمان روشن';

  @override
  String get cycleDurationLabel => 'مدت چرخه';

  @override
  String get upperTempLimit => 'حداکثر دما';

  @override
  String get lowerTempLimit => 'حداقل دما';

  @override
  String humidityHint(Object cycleMinutes, Object onMinutes) {
    return 'سیستم به مدت $onMinutes دقیقه هر $cycleMinutes دقیقه فعال می‌شود.';
  }

  @override
  String get ventilationHint =>
      'فن بالاتر از حد بالا (و/یا پایین‌تر از حد پایین در صورت تنظیم) فعال می‌شود.';

  @override
  String get systemWillRun => 'system will run';

  @override
  String get every => 'every';

  @override
  String get sunriseSunsetTitle => 'شبیه‌ساز طلوع/غروب';

  @override
  String get sunriseLabel => 'طلوع';

  @override
  String get sunsetLabel => 'غروب';

  @override
  String get currentTimeLabel => 'زمان فعلی';

  @override
  String mistRunHint(Object cycle, Object on) {
    return 'به مدت $on دقیقه در هر $cycle دقیقه اجرا می‌شود';
  }

  @override
  String mistRunHintMinutes(Object minutes) {
    return '$minutes دقیقه';
  }

  @override
  String mistRunHintCycle(Object cycle) {
    return '$cycle دقیقه';
  }

  @override
  String get dangerZone => 'حذف دستگاه';

  @override
  String get deleteDeviceTitle => 'حذف دستگاه';

  @override
  String get deleteDeviceConfirmation =>
      'مطمئن هستید که می‌خواهید این دستگاه را حذف کنید؟';

  @override
  String get deleteDeviceHint =>
      'می‌توانید این دستگاه را برای همیشه از برنامه حذف کنید.';

  @override
  String get deviceDeleted => 'دستگاه حذف شد';

  @override
  String get delete => 'حذف';

  @override
  String get connect => 'اتصال';

  @override
  String get humidifier => 'رطوبت‌ساز';

  @override
  String get connected => 'متصل شد';

  @override
  String get disconnecting => 'در حال قطع اتصال';

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
  String get syncTime => 'همگام‌سازی زمان';

  @override
  String get saveSettings => 'ذخیره تنظیمات';

  @override
  String get mistCycleSettings => 'تنظیمات چرخه‌ی رطوبت‌ساز';

  @override
  String get deleteDevice => 'Delete device';

  @override
  String get renameDevice => 'Rename device';

  @override
  String get ok => 'OK';

  @override
  String get lightOnTime => 'ساعت روشن شدن';

  @override
  String get lightOffTime => 'ساعت خاموش شدن';

  @override
  String get ventilationSettings => 'تنظیمات تهویه';

  @override
  String get rename => 'تغییرنام';

  @override
  String get save => 'ذخیره';

  @override
  String get renameHint => 'نام جدید را وارد کنید';

  @override
  String get deleteConfirm =>
      'آیا مطمئن هستید که می‌خواهید این دستگاه را حذف کنید؟ این عمل غیرقابل بازگشت است.';

  @override
  String get lightTimer => 'زمان‌بندی نور';
}
