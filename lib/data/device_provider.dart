import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import '../data/models/device.dart';
import '../data/repositories/device_repository.dart';

class DeviceProvider extends ChangeNotifier {
  final DeviceRepository _repo;
  final FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;

  DeviceProvider(this._repo);

  final List<Device> _devices = [];
  bool _isLoading = false;
  String? _error;

  List<Device> get devices => List.unmodifiable(_devices);
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> load() async {
    _setLoading(true);
    try {
      final list = await _repo.fetchDevices();
      _devices
        ..clear()
        ..addAll(list);
      _error = null;
      print('✅ DeviceProvider: Loaded ${_devices.length} devices from repository.');
    } catch (e) {
      _error = '$e';
      print('❌ DeviceProvider: Error loading devices: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<Device?> addDevice(Device d) async {
    final deviceToAdd = d.copyWith(connected: false);
    try {
      final created = await _repo.addDevice(deviceToAdd);
      _devices.add(created);
      notifyListeners();
      print(
          '✅ DeviceProvider: Device added successfully: ${created.name} (ID: ${created.id})');
      return created;
    } catch (e) {
      _error = '$e';
      print('❌ DeviceProvider: Failed to add device: $e');
      notifyListeners();
      return null;
    }
  }

  Future<bool> updateDevice(Device d) async {
    try {
      final ok = await _repo.updateDevice(d);
      if (ok) {
        final idx = _devices.indexWhere((x) => x.id == d.id);
        if (idx != -1) {
          _devices[idx] = d;
          notifyListeners();
        }
        print('✅ DeviceProvider: Device updated successfully: ${d.name}');
      }
      return ok;
    } catch (e) {
      _error = '$e';
      print('❌ DeviceProvider: Failed to update device: $e');
      notifyListeners();
      return false;
    }
  }

  Future<bool> removeDevice(Device d) async {
    try {
      final ok = await _repo.deleteDeviceById(d.id ?? -1);
      if (ok) {
        _devices.removeWhere((x) => x.id == d.id);
        notifyListeners();
        print('✅ DeviceProvider: Device removed successfully: ${d.name}');
      }
      return ok;
    } catch (e) {
      _error = '$e';
      print('❌ DeviceProvider: Failed to remove device: $e');
      notifyListeners();
      return false;
    }
  }

  Future<void> clearAllDevices() async {
    try {
      await _repo.clearAll();
      _devices.clear();
      notifyListeners();
      print('✅ DeviceProvider: All devices cleared.');
    } catch (e) {
      _error = '$e';
      print('❌ DeviceProvider: Failed to clear all devices: $e');
      notifyListeners();
    }
  }

  Future<Device?> showDevicePicker(BuildContext context) async {
    final enabled = await _bluetooth.isEnabled ?? false;
    if (!enabled) await _bluetooth.requestEnable();

    final bondedDevices = await _bluetooth.getBondedDevices();
    if (bondedDevices.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('هیچ دستگاه بلوتوث جفت‌شده‌ای پیدا نشد')),
        );
      }
      return null;
    }

    final selected = await showDialog<BluetoothDevice>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('انتخاب دستگاه بلوتوث'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: bondedDevices.length,
            itemBuilder: (_, i) {
              final d = bondedDevices[i];
              return ListTile(
                leading: const Icon(Icons.bluetooth),
                title: Text(d.name ?? 'Unknown'),
                subtitle: Text(d.address),
                onTap: () => Navigator.pop(context, d),
              );
            },
          ),
        ),
      ),
    );

    if (selected != null) {
      final newDevice = Device(
        name: selected.name ?? 'Unknown',
        serial: selected.address,
        type: 'vivarium',
        bluetoothAddress: selected.address,
        connected: false,
        ph: null,
      );
      return addDevice(newDevice);
    }
    return null;
  }

  void _setLoading(bool v) {
    _isLoading = v;
    notifyListeners();
  }
}