import '../models/device.dart';
import '../database/app_database.dart';

class DeviceRepository {
  final AppDatabase db;

  DeviceRepository({AppDatabase? database}) : db = database ?? AppDatabase.instance;

  // READ
  Future<List<Device>> fetchDevices() => db.fetchDevices();
  Future<Device?> fetchDeviceById(int id) => db.fetchDeviceById(id);
  Future<Device?> fetchDeviceBySerial(String serial) => db.fetchDeviceBySerial(serial);

  // CREATE
  Future<Device> addDevice(Device d) => db.insertDevice(d);

  // UPDATE
  Future<bool> updateDevice(Device d) => db.updateDevice(d);

  // DELETE
  Future<bool> deleteDeviceById(int id) => db.deleteDeviceById(id);

  // CLEAR ALL
  Future<void> clearAll() => db.clearDevices();
}
