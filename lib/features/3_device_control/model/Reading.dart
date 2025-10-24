// lib/features/3_device_control/model/Reading.dart

class Reading {
  final double? temperature;
  final double? humidity;
  final int? tempLow;
  final int? tempHigh;
  final int? lightOnHour;
  final int? lightOffHour;
  final int? mistOnMinutes;
  final int? mistCycleMinutes;
  final bool? coolingOn;
  final bool? mistOn;
  final String? timeStr; // این فیلد دیگر استفاده نمی‌شود اما برای سازگاری باقی می‌ماند
  final int? lightOverride;  // -1:Auto, 0:Off, 1:On
  final int? mistOverride;   // -1:Auto, 0:Off, 1:On
  final int? coolOverride;   // ✅ اضافه شد: -1:Auto, 0:Off, 1:On

  Reading({
    this.temperature,
    this.humidity,
    this.tempLow,
    this.tempHigh,
    this.lightOnHour,
    this.lightOffHour,
    this.mistOnMinutes,
    this.mistCycleMinutes,
    this.coolingOn,
    this.mistOn,
    this.timeStr,
    this.lightOverride,
    this.mistOverride,
    this.coolOverride, // ✅ اضافه شد
  });
}