import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../data/device_provider.dart';
import '../../../data/services/vivarium_controller.dart';
import '../../../data/models/device.dart';
import '../model/Reading.dart';
import 'device_control_event.dart';
import 'device_control_state.dart';

class DeviceControlBloc extends Bloc<DeviceControlEvent, DeviceControlState> {
  final VivariumController controller;
  final DeviceProvider deviceProvider;
  StreamSubscription<String>? _rxSub;
  final FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;

  DeviceControlBloc({required this.controller, required this.deviceProvider})
      : super(const DeviceControlState()) {
    on<ConnectDevice>(_onConnectDevice);
    on<DisconnectDevice>(_onDisconnectDevice);
    on<DevicePowerOverrideRequested>(_onPowerOverride);
    on<DeviceSetLightTimerRequested>(_onSetLightTimer);
    on<DeviceSetThresholdsRequested>(_onSetThresholds);
    on<DeviceSetFanThresholdRequested>(_onSetFanThreshold);
    on<DeviceSetMistCycleRequested>(_onSetMistCycle);
    on<DeviceSyncTimeRequested>(_onSyncTime);
    on<DeviceSaveSettingsRequested>(_onSaveSettings);
    on<DeviceSetModeRequested>(_onSetMode);
    on<DeviceRenameRequested>(_onRenameRequested);
    on<DeviceDeleteRequested>(_onDeleteRequested);
    on<NewReadingEvent>(_onNewReading);
    on<StatusMessageEvent>((event, emit) {
      emit(state.copyWith(statusMessage: event.message));
    });
  }

  Future<bool> _requestBluetoothPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.bluetoothAdvertise,
    ].request();

    if (statuses[Permission.bluetoothScan]!.isGranted &&
        statuses[Permission.bluetoothConnect]!.isGranted &&
        statuses[Permission.bluetoothAdvertise]!.isGranted) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> _onConnectDevice(
      ConnectDevice event, Emitter<DeviceControlState> emit) async {
    if (state.isConnected) {
      await _onDisconnectDevice(const DisconnectDevice(), emit);
    }

    bool permissionsGranted = await _requestBluetoothPermissions();
    if (!permissionsGranted) {
      emit(DeviceControlState(
          device: event.device,
          isConnected: false,
          statusMessage: "Bluetooth permissions are required."));
      return;
    }

    if (!(await _bluetooth.isEnabled ?? false)) {
      await _bluetooth.requestEnable();
    }

    try {
      emit(DeviceControlState(
          device: event.device, isConnected: false, statusMessage: "Connecting..."));

      await controller.connect(event.device.serial ?? '');

      await deviceProvider.updateDevice(event.device.copyWith(connected: true));

      emit(state.copyWith(
          isConnected: true, statusMessage: "Connected. Syncing time..."));
      controller.syncTime();

      _rxSub?.cancel();
      _rxSub = controller.dataStream.listen((line) {
        if (line == "DISCONNECTED") {
          add(const DisconnectDevice());
          return;
        }

        if (line.startsWith('DATA:')) {
          final parts = line.replaceFirst('DATA:', '').split(',');

          if (parts.length < 13) {
            print("Incomplete DATA string received: $line");
            return;
          }

          add(NewReadingEvent(
            reading: Reading(
              temperature: double.tryParse(parts[0]),
              humidity: double.tryParse(parts[1]),
              tempLow: int.tryParse(parts[2]),
              tempHigh: int.tryParse(parts[3]),
              lightOnHour: int.tryParse(parts[4]),
              lightOffHour: int.tryParse(parts[5]),
              mistOnMinutes: int.tryParse(parts[6]),
              mistCycleMinutes: int.tryParse(parts[7]),
              coolingOn: (parts[8].trim() == '1'),
              mistOn: (parts[9].trim() == '1'),
              lightOverride: int.tryParse(parts[10]),
              mistOverride: int.tryParse(parts[11]),
              coolOverride: int.tryParse(parts[12]),
            ),
          ));
        } else if (line.startsWith('ACK_SET:') || line.startsWith('ERROR:')) {
          add(StatusMessageEvent(line));
        }
      });
    } catch (e) {
      emit(state.copyWith(
          isConnected: false, statusMessage: 'Connection failed: $e'));
      await deviceProvider.updateDevice(event.device.copyWith(connected: false));
    }
  }

  Future<void> _onDisconnectDevice(
      DisconnectDevice event, Emitter<DeviceControlState> emit) async {
    await _rxSub?.cancel();
    _rxSub = null;
    controller.disconnect();

    if (state.device != null) {
      await deviceProvider
          .updateDevice(state.device!.copyWith(connected: false));
    }

    emit(const DeviceControlState(statusMessage: "Disconnected"));
  }

  void _onNewReading(NewReadingEvent event, Emitter<DeviceControlState> emit) {
    final r = event.reading;
    final extras = Map<String, dynamic>.from(state.extras);

    extras['fanOn'] = r.coolingOn ?? extras['fanOn'] ?? false;
    extras['mistOn'] = r.mistOn ?? extras['mistOn'] ?? false;

    final int mistOn = r.mistOnMinutes ?? 5;
    final int mistCycle = r.mistCycleMinutes ?? 60;
    extras['mistOnCycle'] = mistOn;
    extras['mistCycleMinutes'] = mistCycle;
    extras['mistOffCycle'] = (mistCycle - mistOn > 0) ? (mistCycle - mistOn) : 60;

    final int lo = r.lightOverride ?? -1;
    final int mo = r.mistOverride ?? -1;
    final int co = r.coolOverride ?? -1;
    extras['lightOverride'] = lo;
    extras['mistOverride'] = mo;
    extras['coolOverride'] = co;
    extras['autoMode'] = (lo == -1 && mo == -1 && co == -1);

    bool inferredLightOn = false;
    if (r.lightOverride != null) {
      if (r.lightOverride == 1) {
        inferredLightOn = true;
      } else if (r.lightOverride == 0) {
        inferredLightOn = false;
      } else {
        if (r.lightOnHour != null && r.lightOffHour != null) {
          try {
            final hr = DateTime.now().hour;
            inferredLightOn = hr >= r.lightOnHour! && hr < r.lightOffHour!;
          } catch (_) {}
        }
      }
    }
    extras['lightOn'] = inferredLightOn;

    emit(state.copyWith(
      reading: r,
      lowerTemp: r.tempLow ?? state.lowerTemp,
      upperTemp: r.tempHigh ?? state.upperTemp,
      lightOnTime: (r.lightOnHour != null)
          ? TimeOfDay(hour: r.lightOnHour!, minute: 0)
          : state.lightOnTime,
      lightOffTime: (r.lightOffHour != null)
          ? TimeOfDay(hour: r.lightOffHour!, minute: 0)
          : state.lightOffTime,
      extras: extras,
    ));
  }

  void _onPowerOverride(
      DevicePowerOverrideRequested event, Emitter<DeviceControlState> emit) {
    final extras = Map<String, dynamic>.from(state.extras);
    int v = event.value;

    if (event.deviceId == 1) {
      controller.setLightOverride(v);
      extras['lightOverride'] = v;
      extras['lightOn'] = v == 1;
    } else if (event.deviceId == 2) {
      controller.setMistOverride(v);
      extras['mistOverride'] = v;
      extras['mistOn'] = v == 1;
    } else if (event.deviceId == 3) {
      controller.setCoolOverride(v);
      extras['coolOverride'] = v;
      extras['fanOn'] = v == 1;
    }
    extras['autoMode'] = (extras['lightOverride'] == -1 &&
        extras['mistOverride'] == -1 &&
        extras['coolOverride'] == -1);
    emit(state.copyWith(extras: extras));
  }

  void _onSetLightTimer(
      DeviceSetLightTimerRequested event, Emitter<DeviceControlState> emit) {
    controller.setLightTimer(event.onHour, event.offHour);
    emit(state.copyWith(
      lightOnTime: TimeOfDay(hour: event.onHour, minute: 0),
      lightOffTime: TimeOfDay(hour: event.offHour, minute: 0),
    ));
  }

  void _onSetThresholds(
      DeviceSetThresholdsRequested event, Emitter<DeviceControlState> emit) {
    controller.setTempLow(event.lowerTemp);
    controller.setTempHigh(event.upperTemp);
    emit(state.copyWith(
      lowerTemp: event.lowerTemp,
      upperTemp: event.upperTemp,
    ));
  }

  void _onSetFanThreshold(
      DeviceSetFanThresholdRequested event, Emitter<DeviceControlState> emit) {
    controller.setTempLow(event.lowerTemp);
    controller.setTempHigh(event.upperTemp);
    emit(state.copyWith(
      lowerTemp: event.lowerTemp,
      upperTemp: event.upperTemp,
    ));
  }

  void _onSetMistCycle(
      DeviceSetMistCycleRequested event, Emitter<DeviceControlState> emit) {
    int onMinutes = event.onMinutes;
    int totalCycleMinutes = event.onMinutes + event.offMinutes;

    controller.setMistOnMinutes(onMinutes);
    controller.setMistCycleMinutes(totalCycleMinutes);

    final extras = Map<String, dynamic>.from(state.extras);
    extras['mistOnCycle'] = onMinutes;
    extras['mistOffCycle'] = event.offMinutes;
    extras['mistCycleMinutes'] = totalCycleMinutes;
    emit(state.copyWith(extras: extras));
  }

  void _onSyncTime(
      DeviceSyncTimeRequested event, Emitter<DeviceControlState> emit) {
    controller.syncTime();
    add(const StatusMessageEvent("Time Synced"));
  }

  void _onSaveSettings(
      DeviceSaveSettingsRequested event, Emitter<DeviceControlState> emit) {
    controller.saveSettingsToEEPROM();
  }

  void _onSetMode(
      DeviceSetModeRequested event, Emitter<DeviceControlState> emit) {
    int overrideValue = event.autoMode ? -1 : 0;

    controller.setLightOverride(overrideValue);
    controller.setMistOverride(overrideValue);
    controller.setCoolOverride(overrideValue);

    final extras = Map<String, dynamic>.from(state.extras);
    extras['lightOverride'] = overrideValue;
    extras['mistOverride'] = overrideValue;
    extras['coolOverride'] = overrideValue;
    extras['autoMode'] = event.autoMode;
    emit(state.copyWith(extras: extras));
  }

  void _onRenameRequested(
      DeviceRenameRequested event, Emitter<DeviceControlState> emit) {
    add(const StatusMessageEvent("Error: Rename not supported by firmware."));
  }

  void _onDeleteRequested(
      DeviceDeleteRequested event, Emitter<DeviceControlState> emit) {
    add(const StatusMessageEvent("Error: Delete not supported by firmware."));
  }

  @override
  Future<void> close() {
    _rxSub?.cancel();
    controller.disconnect();
    controller.dispose();
    return super.close();
  }
}