import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class BluetoothFinderDialog extends StatefulWidget {
  final void Function(BluetoothDevice device) onDeviceSelected;

  const BluetoothFinderDialog({super.key, required this.onDeviceSelected});

  @override
  State<BluetoothFinderDialog> createState() => _BluetoothFinderDialogState();
}

class _BluetoothFinderDialogState extends State<BluetoothFinderDialog> {
  bool _isDiscovering = true;
  List<BluetoothDiscoveryResult> _results = [];
  Stream<BluetoothDiscoveryResult>? _stream;

  @override
  void initState() {
    super.initState();
    _startDiscovery();
  }

  void _startDiscovery() {
    setState(() => _isDiscovering = true);
    _results.clear();
    _stream = FlutterBluetoothSerial.instance.startDiscovery();
    _stream!.listen((r) {
      setState(() {
        final i = _results.indexWhere((x) => x.device.address == r.device.address);
        if (i >= 0) {
          _results[i] = r;
        } else {
          _results.add(r);
        }
      });
    }).onDone(() {
      setState(() => _isDiscovering = false);
    });
  }

  Future<void> _connectDevice(BluetoothDevice device) async {
    try {
      await FlutterBluetoothSerial.instance.connect(device);
      widget.onDeviceSelected(device);
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطا در اتصال به ${device.name ?? device.address}')),
      );
    }
  }

  @override
  void dispose() {
    FlutterBluetoothSerial.instance.cancelDiscovery();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isLight = Theme.of(context).brightness == Brightness.light;

    return Dialog(
      backgroundColor: isLight ? Colors.white : Colors.white.withOpacity(0.05),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360, maxHeight: 480),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              decoration: BoxDecoration(
                color: cs.primary.withOpacity(0.1),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.bluetooth_searching, color: Colors.blueAccent),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _isDiscovering ? 'در حال جستجو...' : 'انتخاب دستگاه بلوتوث',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: cs.onSurface,
                      ),
                    ),
                  ),
                  if (_isDiscovering)
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  else
                    IconButton(
                      tooltip: 'جستجو مجدد',
                      icon: const Icon(Icons.refresh, color: Colors.blueAccent),
                      onPressed: _startDiscovery,
                    ),
                ],
              ),
            ),

            // Device List
            Expanded(
              child: _results.isEmpty && !_isDiscovering
                  ? Center(
                child: Text(
                  'هیچ دستگاهی پیدا نشد.',
                  style: TextStyle(color: cs.onSurface.withOpacity(.7)),
                ),
              )
                  : ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 6),
                itemCount: _results.length,
                separatorBuilder: (_, __) => Divider(
                  height: 1,
                  color: cs.outline.withOpacity(.2),
                ),
                itemBuilder: (context, i) {
                  final r = _results[i];
                  final d = r.device;
                  return ListTile(
                    leading: Icon(
                      d.isConnected ? Icons.bluetooth_connected : Icons.bluetooth,
                      color: d.isConnected ? Colors.green : cs.primary,
                    ),
                    title: Text(d.name ?? 'Unknown'),
                    subtitle: Text(d.address),
                    trailing: ElevatedButton(
                      onPressed: () => _connectDevice(d),
                      child: const Text('اتصال'),
                    ),
                  );
                },
              ),
            ),

            // Close Button
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: cs.outline.withOpacity(.15))),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('بستن'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
