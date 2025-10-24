// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'حوض';

  @override
  String get appSubtitle => 'التحكم في الأجهزة';

  @override
  String get tagline => 'إدارة النظام البيئي الذكي';

  @override
  String get home => 'الرئيسية';

  @override
  String get settings => 'الإعدادات';

  @override
  String get settingsTitle => 'الإعدادات';

  @override
  String get devices => 'الأجهزة';

  @override
  String get allDevices => 'كل الأجهزة';

  @override
  String get noDevices => 'لا توجد أجهزة بعد.\nأضف جهازاً للبدء.';

  @override
  String get welcomeTitle => 'مرحباً بك في أكوافيڤا';

  @override
  String get welcomeBody => 'لنقم بإعداد تجربتك الذكية في بضع خطوات.';

  @override
  String get welcome => 'مرحباً';

  @override
  String get getStarted => 'ابدأ';

  @override
  String get next => 'التالي';

  @override
  String get back => 'السابق';

  @override
  String get cancel => 'إلغاء';

  @override
  String get add => 'إضافة';

  @override
  String get completeSetup => 'إكمال الإعداد';

  @override
  String get languageTitle => 'اللغة';

  @override
  String get languageSubtitle => 'اختر لغتك المفضلة';

  @override
  String get languageEnglish => 'English';

  @override
  String get languagePersian => 'فارسی';

  @override
  String get languageArabic => 'العربية';

  @override
  String get themeTitle => 'السمة';

  @override
  String get themeSubtitle => 'اختر المظهر المفضل لديك';

  @override
  String get themeDark => 'الوضع الداكن';

  @override
  String get themeLight => 'الوضع الفاتح';

  @override
  String get themeSystem => 'System Default';

  @override
  String get termsTitle => 'شروط الاستخدام';

  @override
  String get termsSubtitle => 'يرجى مراجعة شروطنا والموافقة عليها';

  @override
  String get termsHeader => 'شروط خدمة أكوافيڤا';

  @override
  String get termsIntro =>
      'باستخدام أكوافيڤا، فإنك توافق على الشروط والأحكام التالية:';

  @override
  String get termsUsage => '١. الاستخدام';

  @override
  String get termsUsageDesc =>
      'استخدم التطبيق بمسؤولية واتبع جميع إرشادات السلامة.';

  @override
  String get termsPrivacy => '٢. الخصوصية';

  @override
  String get termsPrivacyDesc =>
      'نخزن البيانات محلياً ولا نشاركها إلا بموافقتك.';

  @override
  String get termsLiability => '٣. المسؤولية';

  @override
  String get termsLiabilityDesc => 'أنت مسؤول عن حيواناتك وأجهزتك.';

  @override
  String get termsUpdates => '٤. التحديثات';

  @override
  String get termsUpdatesDesc =>
      'قد تتغير الشروط؛ الاستمرار في الاستخدام يعني الموافقة.';

  @override
  String get termsCheckbox =>
      'لقد قرأت وأوافق على شروط الاستخدام وسياسة الخصوصية';

  @override
  String get notificationsTitle => 'الإشعارات';

  @override
  String get notificationsSubtitle => 'تنبيهات وتحديثات الجهاز';

  @override
  String get syncTimeTitle => 'مزامنة الوقت مع الجهاز';

  @override
  String get syncTimeSubtitle => 'مزامنة جداول الجهاز';

  @override
  String get sync => 'مزامنة';

  @override
  String get connectionStatusTitle => 'حالة الاتصال';

  @override
  String connectedToDevices(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'متصل بـ $count أجهزة',
      one: 'متصل بجهاز واحد',
      zero: 'غير متصل',
    );
    return '$_temp0';
  }

  @override
  String get aboutTitle => 'حول أكوافيڤا';

  @override
  String get aboutBody1 => 'إدارة ذكية للأنظمة البيئية للأحواض والڤيڤاريومات.';

  @override
  String get aboutBody2 => 'راقب وتحكم في بيئاتك المائية والبرية بسهولة.';

  @override
  String version(String value) {
    return 'الإصدار $value';
  }

  @override
  String copyright(String year) {
    return '© $year تقنيات أكوافيڤا';
  }

  @override
  String get aquarium => 'حوض أسماك';

  @override
  String get vivarium => 'ڤيڤاريوم';

  @override
  String get aquariumsTab => 'الأحواض';

  @override
  String get vivariumsTab => 'الڤيڤاريومات';

  @override
  String get noAquariumsTitle => 'لا توجد أحواض بعد';

  @override
  String get noVivariumsTitle => 'لا توجد ڤيڤاريومات بعد';

  @override
  String get addDeviceHint => 'قم بتوصيل حوضك أو ڤيڤاريومك';

  @override
  String get addDeviceTitle => 'إضافة جهاز جديد';

  @override
  String get deviceNameLabel => 'اسم الجهاز';

  @override
  String get serialLabel => 'الرقم التسلسلي';

  @override
  String get serialPrefix => 'الرقم التسلسلي:';

  @override
  String get status => 'الحالة';

  @override
  String get statusTitle => 'الحالة';

  @override
  String get temperature => 'درجة الحرارة';

  @override
  String get humidity => 'الرطوبة';

  @override
  String get online => 'متصل';

  @override
  String get offline => 'غير متصل';

  @override
  String get controlsTitle => 'التحكمات';

  @override
  String get lighting => 'الإضاءة';

  @override
  String get heater => 'سخان';

  @override
  String get filter => 'فلتر';

  @override
  String get light => 'اللمبة';

  @override
  String get humidification => 'ترطيب';

  @override
  String get ventilation => 'التهوية';

  @override
  String get on => 'شغّال';

  @override
  String get off => 'مطفأ';

  @override
  String get lightControl => 'التحكم في الضوء';

  @override
  String get lightControlTitle => 'التحكم في الضوء';

  @override
  String get lightPower => 'شدة الضوء';

  @override
  String get lightHint => 'تحكم في إضاءة جهازك';

  @override
  String get toggleVivariumLight => 'تبديل إضاءة الڤيڤاريوم.';

  @override
  String get humidityControl => 'التحكم في الرطوبة';

  @override
  String get humidityControlTitle => 'التحكم في الرطوبة';

  @override
  String get humiditySystem => 'نظام الرطوبة';

  @override
  String get minutesUnit => 'دقائق';

  @override
  String get ventilationControl => 'التحكم في التهوية';

  @override
  String get ventilationControlTitle => 'التحكم في التهوية';

  @override
  String get ventilationSystem => 'نظام التهوية';

  @override
  String get fanPower => 'قوة المروحة';

  @override
  String get fanHint => 'تعمل المروحة خارج نطاق درجة الحرارة المحدد.';

  @override
  String get onDuration => 'مدة التشغيل';

  @override
  String get totalCycle => 'الدورة الكاملة';

  @override
  String get onDurationLabel => 'مدة التشغيل';

  @override
  String get cycleDurationLabel => 'مدة الدورة';

  @override
  String get upperTempLimit => 'الحد الأعلى للحرارة';

  @override
  String get lowerTempLimit => 'الحد الأدنى للحرارة';

  @override
  String humidityHint(Object cycleMinutes, Object onMinutes) {
    return 'يعمل النظام لمدة $onMinutes دقيقة كل $cycleMinutes دقيقة عند التفعيل.';
  }

  @override
  String get ventilationHint =>
      'تعمل المروحة عند تجاوز الحد الأعلى (و/أو النزول عن الحد الأدنى إذا تم ضبطه).';

  @override
  String get systemWillRun => 'system will run';

  @override
  String get every => 'every';

  @override
  String get sunriseSunsetTitle => 'محاكاة الشروق/الغروب';

  @override
  String get sunriseLabel => 'شروق';

  @override
  String get sunsetLabel => 'غروب';

  @override
  String get currentTimeLabel => 'الوقت الحالي';

  @override
  String mistRunHint(Object cycle, Object on) {
    return 'يعمل لمدة $on دقيقة كل $cycle دقيقة';
  }

  @override
  String mistRunHintMinutes(Object minutes) {
    return '$minutes دقيقة';
  }

  @override
  String mistRunHintCycle(Object cycle) {
    return '$cycle دقيقة';
  }

  @override
  String get dangerZone => 'حذف الجهاز';

  @override
  String get deleteDeviceTitle => 'حذف الجهاز';

  @override
  String get deleteDeviceConfirmation =>
      'هل أنت متأكد أنك تريد إزالة هذا الجهاز؟';

  @override
  String get deleteDeviceHint => 'يمكنك إزالة هذا الجهاز نهائيًا من التطبيق.';

  @override
  String get deviceDeleted => 'تم حذف الجهاز';

  @override
  String get delete => 'حذف';

  @override
  String get connect => 'اتصال';

  @override
  String get humidifier => 'جهاز الرطوبة';

  @override
  String get connected => 'متصل';

  @override
  String get disconnecting => 'يتم فصل الاتصال';

  @override
  String get lowerHumidityLimit => 'Lower Humidity Limit';

  @override
  String get upperHumidityLimit => 'Upper Humidity Limit';

  @override
  String get mode => 'الوضع';

  @override
  String get autoMode => 'تلقائي';

  @override
  String get manualMode => 'يدوي';

  @override
  String get mistOnCycle => 'مدة التشغيل';

  @override
  String get mistCycleTitle => 'دورة الرذاذ';

  @override
  String get mistOffCycle => 'مدة الإيقاف';

  @override
  String get syncTime => 'مزامنة الوقت';

  @override
  String get saveSettings => 'حفظ الإعدادات';

  @override
  String get mistCycleSettings => 'إعدادات دورة الرذاذ';

  @override
  String get deleteDevice => 'حذف الجهاز';

  @override
  String get renameDevice => 'إعادة تسمية الجهاز';

  @override
  String get ok => 'موافق';

  @override
  String get lightOnTime => 'وقت تشغيل الإضاءة';

  @override
  String get lightOffTime => 'وقت إطفاء الإضاءة';

  @override
  String get ventilationSettings => 'إعدادات التهوية';

  @override
  String get rename => 'إعادة تسمية';

  @override
  String get save => 'حفظ';

  @override
  String get renameHint => 'أدخل اسماً جديداً';

  @override
  String get deleteConfirm =>
      'هل أنت متأكد أنك تريد حذف هذا الجهاز؟ هذا الإجراء لا يمكن التراجع عنه.';

  @override
  String get lightTimer => 'توقيت الإضاءة';
}
