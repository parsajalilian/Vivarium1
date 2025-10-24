import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../../data/models/device.dart';
import '../model/Reading.dart';

abstract class DeviceControlEvent extends Equatable {
  const DeviceControlEvent();
  @override
  List<Object?> get props => [];
}

class ConnectDevice extends DeviceControlEvent {
  final Device device;
  const ConnectDevice(this.device);
  @override
  List<Object?> get props => [device];
}

class DisconnectDevice extends DeviceControlEvent {
  const DisconnectDevice();
}

class NewReadingEvent extends DeviceControlEvent {
  final Reading reading;
  const NewReadingEvent({required this.reading});
  @override
  List<Object?> get props => [reading];
}

class StatusMessageEvent extends DeviceControlEvent {
  final String message;
  const StatusMessageEvent(this.message);
  @override
  List<Object?> get props => [message];
}

class DevicePowerOverrideRequested extends DeviceControlEvent {
  final int deviceId;
  final int value;
  const DevicePowerOverrideRequested({required this.deviceId, required this.value});
  @override
  List<Object?> get props => [deviceId, value];
}

class DeviceSetLightTimerRequested extends DeviceControlEvent {
  final int onHour;
  final int offHour;
  const DeviceSetLightTimerRequested({required this.onHour, required this.offHour});
  @override
  List<Object?> get props => [onHour, offHour];
}

class DeviceSetThresholdsRequested extends DeviceControlEvent {
  final int lowerTemp;
  final int upperTemp;
  final int lowerHumidity;
  final int upperHumidity;

  const DeviceSetThresholdsRequested({
    required this.lowerTemp,
    required this.upperTemp,
    required this.lowerHumidity,
    required this.upperHumidity,
  });
}

class DeviceSetFanThresholdRequested extends DeviceControlEvent {
  final int lowerTemp;
  final int upperTemp;
  const DeviceSetFanThresholdRequested(
      {required this.lowerTemp, required this.upperTemp});
}

class DeviceSetMistCycleRequested extends DeviceControlEvent {
  final int onMinutes;
  final int offMinutes;
  const DeviceSetMistCycleRequested(
      {required this.onMinutes, required this.offMinutes});
}

class DeviceSyncTimeRequested extends DeviceControlEvent {
  const DeviceSyncTimeRequested();
}

class DeviceSaveSettingsRequested extends DeviceControlEvent {
  const DeviceSaveSettingsRequested();
}

class DeviceSetModeRequested extends DeviceControlEvent {
  final bool autoMode;
  const DeviceSetModeRequested({required this.autoMode});
}

class DeviceRenameRequested extends DeviceControlEvent {
  final String newName;
  const DeviceRenameRequested(this.newName);
}

class DeviceDeleteRequested extends DeviceControlEvent {
  final Device device;
  const DeviceDeleteRequested(this.device);
}