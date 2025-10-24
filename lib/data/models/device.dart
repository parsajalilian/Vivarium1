// lib/data/models/device.dart
import 'package:flutter/foundation.dart';

/// کلاس اصلی Device (فقط برای Vivarium)
class Device {
  final int? id;
  final String name;
  final String type;
  final String? serial;
  final String? bluetoothAddress;
  final double? temperature;
  final double? humidity;
  final bool connected;
  final bool lightOn;
  final bool heaterOn;
  final bool filterOn;

  const Device({
    this.id,
    required this.name,
    required this.type,
    this.serial,
    this.bluetoothAddress,
    this.temperature,
    this.humidity,
    this.connected = false,
    this.lightOn = false,
    this.heaterOn = false,
    this.filterOn = false, required ph,
  });

  Device copyWith({
    int? id,
    String? name,
    String? type,
    String? serial,
    String? bluetoothAddress,
    double? temperature,
    double? humidity,
    bool? connected,
    bool? lightOn,
    bool? heaterOn,
    bool? filterOn,
  }) {
    return Device(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      serial: serial ?? this.serial,
      bluetoothAddress: bluetoothAddress ?? this.bluetoothAddress,
      temperature: temperature ?? this.temperature,
      humidity: humidity ?? this.humidity,
      connected: connected ?? this.connected,
      lightOn: lightOn ?? this.lightOn,
      heaterOn: heaterOn ?? this.heaterOn,
      filterOn: filterOn ?? this.filterOn, ph: null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'serial': serial,
      'bluetoothAddress': bluetoothAddress,
      'temperature': temperature,
      'humidity': humidity,
      'connected': connected ? 1 : 0,
      'lightOn': lightOn ? 1 : 0,
      'heaterOn': heaterOn ? 1 : 0,
      'filterOn': filterOn ? 1 : 0,
    };
  }

  factory Device.fromMap(Map<String, dynamic> map) {
    return Device(
      id: map['id'] as int?,
      name: map['name'] as String,
      type: map['type'] as String,
      serial: map['serial'] as String?,
      bluetoothAddress: map['bluetoothAddress'] as String?,
      temperature: map['temperature'] != null ? map['temperature'] as double : null,
      humidity: map['humidity'] != null ? map['humidity'] as double : null,
      connected: map['connected'] == 1,
      lightOn: map['lightOn'] == 1,
      heaterOn: map['heaterOn'] == 1,
      filterOn: map['filterOn'] == 1, ph: null,
    );
  }
}

/// --- VivariumData برای داده‌های زنده ---
class VivariumData {
  final double? temperature;
  final double? humidity;
  final bool fanOn;
  final bool lightOn;
  final bool mistOn;

  const VivariumData({
    this.temperature,
    this.humidity,
    this.fanOn = false,
    this.lightOn = false,
    this.mistOn = false,
  });

  /// ساخت از یک Device موجود
  factory VivariumData.fromDevice(Device device) {
    return VivariumData(
      temperature: device.temperature,
      humidity: device.humidity,
      fanOn: device.filterOn,
      lightOn: device.lightOn,
      mistOn: device.heaterOn,
    );
  }

  /// ساخت از خط داده‌ی بلوتوث ESP32 (امن)
  factory VivariumData.fromString(String line, {required VivariumData previous}) {
    try {
      final parts = line.replaceFirst('DATA:', '').split(',');

      double t = parts.isNotEmpty ? double.tryParse(parts[0]) ?? previous.temperature ?? 0 : previous.temperature ?? 0;
      double h = parts.length > 1 ? double.tryParse(parts[1]) ?? previous.humidity ?? 0 : previous.humidity ?? 0;
      bool fan = parts.length > 7 ? parts[7] == '1' : previous.fanOn;
      bool light = parts.length > 8 ? parts[8] == '1' : previous.lightOn;
      bool mist = parts.length > 9 ? parts[9] == '1' : previous.mistOn;

      return VivariumData(
        temperature: t,
        humidity: h,
        fanOn: fan,
        lightOn: light,
        mistOn: mist,
      );
    } catch (e) {
      debugPrint("Error parsing DATA line: $e");
      return previous;
    }
  }

  /// تبدیل به Device با پایه Device موجود
  Device toDevice({required Device baseDevice}) {
    return baseDevice.copyWith(
      temperature: temperature,
      humidity: humidity,
      lightOn: lightOn,
      heaterOn: mistOn,
      filterOn: fanOn,
    );
  }
}
