// lib/widgets/add_device_dialog.dart
import 'dart:ui';
import 'package:flutter/material.dart';

import '../../../data/models/device.dart';

Future<Device?> showAddDeviceDialog(BuildContext context) async {
  final nameCtrl = TextEditingController();
  final serialCtrl = TextEditingController();
  final addressCtrl = TextEditingController();
  String type = 'aquarium';

  final res = await showDialog<Device>(
    context: context,
    barrierDismissible: true,
    builder: (ctx) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: AlertDialog(
          backgroundColor: const Color(0xFF1B2535).withOpacity(0.95),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text(
            'Add New Device',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameCtrl,
                  style: const TextStyle(color: Colors.white),
                  decoration: _decoration('Device Name'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: serialCtrl,
                  style: const TextStyle(color: Colors.white),
                  decoration: _decoration('Serial (optional)'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: addressCtrl,
                  style: const TextStyle(color: Colors.white),
                  decoration: _decoration('Bluetooth Address (XX:XX:XX:XX:XX:XX)'),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: type,
                  dropdownColor: const Color(0xFF1B2535),
                  items: const [
                    DropdownMenuItem(
                      value: 'aquarium',
                      child: Text('Aquarium', style: TextStyle(color: Colors.white)),
                    ),
                    DropdownMenuItem(
                      value: 'vivarium',
                      child: Text('Vivarium', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                  onChanged: (v) => type = v ?? 'aquarium',
                  decoration: _decoration('Device Type'),
                ),
                const SizedBox(height: 6),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Stats will appear when the device is connected.\nUntil then, values show as "??".',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0E8AC0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                final name = nameCtrl.text.trim();
                final serial = serialCtrl.text.trim();
                final address = addressCtrl.text.trim();

                if (name.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter a device name'),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                  return;
                }

                Navigator.of(ctx).pop(Device(
                  name: name,
                  type: type,
                  serial: serial.isEmpty ? null : serial,
                  bluetoothAddress: address.isEmpty ? null : address,
                  temperature: null,
                  ph: null,
                  humidity: null,
                  connected: false,
                ));
              },
              child: const Text('Add Device'),
            ),
          ],
        ),
      );
    },
  );

  return res;
}

InputDecoration _decoration(String label) => InputDecoration(
  labelText: label,
  labelStyle: TextStyle(color: Colors.white.withOpacity(.75)),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white.withOpacity(.35)),
    borderRadius: BorderRadius.circular(10),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: const BorderSide(color: Colors.white),
    borderRadius: BorderRadius.circular(10),
  ),
);
