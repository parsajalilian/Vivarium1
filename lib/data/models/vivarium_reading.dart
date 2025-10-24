// lib/data/models/vivarium_reading.dart
class VivariumReading {
  final double? temperature;
  final double? humidity;
  final bool lightOn;
  final bool mistOn;
  final bool fanOn;

  VivariumReading({
    this.temperature,
    this.humidity,
    this.lightOn = false,
    this.mistOn = false,
    this.fanOn = false,
  });

  factory VivariumReading.fromDataLine(String line) {
    // فرض کنیم دیتا بصورت CSV از برد میاد:
    // DATA:temperature,humidity,light,mist,fan
    // مثال: DATA:25.8,47,1,0,1
    try {
      final parts = line.replaceFirst('DATA:', '').split(',');
      return VivariumReading(
        temperature: double.tryParse(parts[0]),
        humidity: double.tryParse(parts[1]),
        lightOn: parts[2] == '1',
        mistOn: parts[3] == '1',
        fanOn: parts[4] == '1',
      );
    } catch (_) {
      return VivariumReading();
    }
  }
}
