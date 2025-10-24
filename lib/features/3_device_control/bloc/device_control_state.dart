// lib/features/3_device_control/bloc/device_control_state.dart
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../../data/models/device.dart';
import '../model/Reading.dart';

class DeviceControlState extends Equatable {
  final Device? device;
  final bool isConnected;
  final Reading? reading;
  final String? statusMessage;

  final int lowerTemp;
  final int upperTemp;
  final TimeOfDay lightOnTime;
  final TimeOfDay lightOffTime;
  final Map<String, dynamic> extras;

  const DeviceControlState({
    this.device,
    this.isConnected = false,
    this.reading,
    this.statusMessage,
    this.lowerTemp = 22,
    this.upperTemp = 28,
    this.lightOnTime = const TimeOfDay(hour: 8, minute: 0),
    this.lightOffTime = const TimeOfDay(hour: 20, minute: 0),
    this.extras = const {
      'lightOn': false,
      'mistOn': false,
      'fanOn': false,
      'autoMode': true,
      'mistOnCycle': 5,
      'mistOffCycle': 60,
    },
  });

  DeviceControlState copyWith({
    Device? device,
    bool? isConnected,
    Reading? reading,
    String? statusMessage,
    int? lowerTemp,
    int? upperTemp,
    TimeOfDay? lightOnTime,
    TimeOfDay? lightOffTime,
    Map<String, dynamic>? extras,
    bool clearDevice = false, // پارامتر کمکی برای disconnect
  }) {
    return DeviceControlState(
      // ❗️✅ اصلاح: از '?? this.device' برای حفظ مقدار قبلی استفاده کنید
      device: clearDevice ? null : (device ?? this.device),
      isConnected: isConnected ?? this.isConnected,
      reading: reading ?? this.reading,
      statusMessage: statusMessage,
      lowerTemp: lowerTemp ?? this.lowerTemp,
      upperTemp: upperTemp ?? this.upperTemp,
      lightOnTime: lightOnTime ?? this.lightOnTime,
      lightOffTime: lightOffTime ?? this.lightOffTime,
      extras: extras ?? this.extras,
    );
  }

  @override
  List<Object?> get props => [
    device,
    isConnected,
    reading,
    statusMessage,
    lowerTemp,
    upperTemp,
    lightOnTime,
    lightOffTime,
    extras
  ];
}