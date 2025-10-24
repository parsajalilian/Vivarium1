// lib/data/services/vivarium_controller.dart

import 'dart:async';
import 'dart:convert';

import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

import 'package:flutter/foundation.dart';

class VivariumController {
  BluetoothConnection? _connection;
  final StreamController<String> _rxController = StreamController.broadcast();
  Stream<String> get dataStream => _rxController.stream;

  bool get isConnected => _connection != null && _connection!.isConnected;

  Future<void> connect(String address) async {
    try {
      _connection = await BluetoothConnection.toAddress(address);
      _connection!.input!
          .cast<Uint8List>()
          .map((data) => utf8.decode(data))
          .transform(const LineSplitter())
          .listen((line) {
        if (line.trim().isNotEmpty) _rxController.add(line.trim());
        if (kDebugMode) print("RX: $line");
      }, onDone: () {
        _connection = null;
        _rxController.add("DISCONNECTED");
      });
    } catch (e) {
      if (kDebugMode) print("Connection Error: $e");
      rethrow;
    }
  }

  void disconnect() {
    _connection?.finish();
    _connection = null;
  }

  void dispose() {
    _rxController.close();
    disconnect();
  }

  void _rawSend(String s) {
    if (_connection == null || !_connection!.isConnected) {
      if (kDebugMode) print("Cannot send command, not connected!");
      return;
    }
    try {
      final bytes = Uint8List.fromList(utf8.encode(s + '\n'));
      _connection!.output.add(bytes);
      if (kDebugMode) print("TX: $s");
    } catch (e) {
      if (kDebugMode) print("Send Error: $e");
      _connection = null;
      _rxController.add("DISCONNECTED");
    }
  }

  /// ======================================================
  /// /// دستورات هماهنگ شده با فریم‌ور C++ ESP32 ///
  /// ======================================================

  void sendSet(String target, String value) => _rawSend('SET:$target:$value');

  // --- Overrides ( -1=AUTO, 0=OFF, 1=ON ) ---
  void setLightOverride(int ov) => sendSet('LIGHT_OVR', ov.toString());
  void setMistOverride(int ov) => sendSet('MIST_OVR', ov.toString());
  void setCoolOverride(int ov) => sendSet('COOL_OVR', ov.toString());

  // --- Light Timer ---
  void setLightTimer(int onHour, int offHour) =>
      sendSet('LIGHTTIMER', '$onHour,$offHour');

  // --- Temperature Thresholds ---
  void setTempLow(int lowTemp) => sendSet('TEMP_LOW', lowTemp.toString());
  void setTempHigh(int highTemp) => sendSet('TEMP_HIGH', highTemp.toString());

  // --- Mist Cycle ---
  void setMistOnMinutes(int onMinutes) =>
      sendSet('MIST_ON', onMinutes.toString());
  void setMistCycleMinutes(int cycleMinutes) =>
      sendSet('MIST_CYCLE', cycleMinutes.toString());

  /// همگام‌سازی زمان با دستگاه (فرمت صحیح h:m:s)
  void syncTime() {
    final now = DateTime.now();
    // ESP32 منتظر "SET_TIME" و فرمت h:m:s است
    _rawSend('SET:SET_TIME:${now.hour}:${now.minute}:${now.second}');
  }

  /// ذخیره تنظیمات در EEPROM
  void saveSettingsToEEPROM() {
    _rawSend('SAVE_SETTINGS');
  }

  // دستورات زیر در ESP32 شما پیاده سازی نشده اند
  void renameDevice(String newName) {
    if (kDebugMode) print("WARN: Rename not implemented in firmware");
    // sendSet('NAME', newName);
  }

  void deleteDevice() {
    if (kDebugMode) print("WARN: Delete not implemented in firmware");
    // _rawSend('DELETE:DEVICE');
  }
}