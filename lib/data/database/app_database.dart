import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/device.dart';

class AppDatabase {
  static final AppDatabase instance = AppDatabase._init();
  static Database? _db;

  AppDatabase._init();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB('aquaviva.db');
    print('✅ AppDatabase: Database initialized and opened.'); // 💡 DEBUG
    return _db!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    print('📂 AppDatabase: Database path is $path'); // 💡 DEBUG

    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    print('🆕 AppDatabase: Creating table "devices"...'); // 💡 DEBUG
    await db.execute('''
      CREATE TABLE devices(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        type TEXT NOT NULL,
        serial TEXT,
        bluetoothAddress TEXT,
        temperature REAL,
        ph REAL,
        humidity REAL,
        connected INTEGER DEFAULT 0,
        lightOn INTEGER DEFAULT 0,
        heaterOn INTEGER DEFAULT 0,
        filterOn INTEGER DEFAULT 0
      )
    ''');
    print('✅ AppDatabase: Table "devices" created successfully.'); // 💡 DEBUG
  }

  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    print('🔄 AppDatabase: Upgrading database from $oldVersion to $newVersion...'); // 💡 DEBUG
    final columns = await db.rawQuery("PRAGMA table_info(devices)");
    final existingColumns = columns.map((c) => c['name']).toSet();

    if (!existingColumns.contains('lightOn')) {
      await db.execute('ALTER TABLE devices ADD COLUMN lightOn INTEGER DEFAULT 0');
    }
    if (!existingColumns.contains('heaterOn')) {
      await db.execute('ALTER TABLE devices ADD COLUMN heaterOn INTEGER DEFAULT 0');
    }
    if (!existingColumns.contains('filterOn')) {
      await db.execute('ALTER TABLE devices ADD COLUMN filterOn INTEGER DEFAULT 0');
    }
    if (!existingColumns.contains('bluetoothAddress')) {
      await db.execute('ALTER TABLE devices ADD COLUMN bluetoothAddress TEXT');
    }
    if (!existingColumns.contains('temperature')) {
      await db.execute('ALTER TABLE devices ADD COLUMN temperature REAL');
    }
    if (!existingColumns.contains('ph')) {
      await db.execute('ALTER TABLE devices ADD COLUMN ph REAL');
    }
    if (!existingColumns.contains('humidity')) {
      await db.execute('ALTER TABLE devices ADD COLUMN humidity REAL');
    }
    if (!existingColumns.contains('connected')) {
      await db.execute('ALTER TABLE devices ADD COLUMN connected INTEGER DEFAULT 0');
    }
    print('✅ AppDatabase: Upgrade complete.'); // 💡 DEBUG
  }

  // -------- CRUD --------
  Future<Device> insertDevice(Device d) async {
    final db = await database;
    final id = await db.insert('devices', d.toMap());
    print('➕ AppDatabase: Device "${d.name}" inserted with ID $id.'); // 💡 DEBUG
    return d.copyWith(id: id);
  }

  Future<List<Device>> fetchDevices() async {
    final db = await database;
    final maps = await db.query('devices', orderBy: 'id DESC');
    final devices = maps.map(Device.fromMap).toList();
    print('🔍 AppDatabase: Fetched ${devices.length} devices.'); // 💡 DEBUG
    return devices;
  }

  Future<Device?> fetchDeviceById(int id) async {
    final db = await database;
    final maps = await db.query('devices', where: 'id=?', whereArgs: [id], limit: 1);
    if (maps.isEmpty) return null;
    return Device.fromMap(maps.first);
  }

  Future<Device?> fetchDeviceBySerial(String serial) async {
    final db = await database;
    final maps = await db.query('devices', where: 'serial=?', whereArgs: [serial], limit: 1);
    if (maps.isEmpty) return null;
    return Device.fromMap(maps.first);
  }

  Future<bool> updateDevice(Device d) async {
    if (d.id == null) return false;
    final db = await database;
    final count = await db.update(
      'devices',
      d.toMap(),
      where: 'id=?',
      whereArgs: [d.id],
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
    print('✏️ AppDatabase: Device "${d.name}" (ID: ${d.id}) updated. Rows affected: $count'); // 💡 DEBUG
    return count > 0;
  }

  Future<bool> deleteDeviceById(int id) async {
    final db = await database;
    final count = await db.delete('devices', where: 'id=?', whereArgs: [id]);
    print('🗑️ AppDatabase: Device with ID $id deleted. Rows affected: $count'); // 💡 DEBUG
    return count > 0;
  }

  Future<void> clearDevices() async {
    final db = await database;
    await db.delete('devices');
    print('🔥 AppDatabase: All devices cleared.'); // 💡 DEBUG
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}