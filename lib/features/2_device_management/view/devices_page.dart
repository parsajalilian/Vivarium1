// lib/features/2_device_management/view/devices_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../data/device_provider.dart';
import '../../../data/models/device.dart';
import '../../3_device_control/view/vivarium_detail_page.dart';
import '../../3_device_control/widgets/connect_button.dart';
import '../../3_device_control/bloc/device_control_bloc.dart';
import '../../3_device_control/bloc/device_control_event.dart';
import '../../3_device_control/bloc/device_control_state.dart';

class DevicesPage extends StatelessWidget {
  const DevicesPage({super.key});

  void _openDevice(BuildContext context, Device d) {
    final blocState = context.read<DeviceControlBloc>().state;
    final isThisDeviceConnected =
        blocState.isConnected && blocState.device?.id == d.id;

    if (d.type == 'vivarium') {
      if (isThisDeviceConnected) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => VivariumDetailPage(device: d),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${d.name} متصل نیست. لطفاً ابتدا دکمه "اتصال" را بزنید.',
              textDirection: TextDirection.rtl,
            ),
          ),
        );
      }
    }
  }

  Future<void> _addDevice(BuildContext context) async {
    final dp = context.read<DeviceProvider>();
    await dp.showDevicePicker(context);
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final devices = context.watch<DeviceProvider>().devices;
    final cs = Theme.of(context).colorScheme;

    return Column(
      children: [
        // ✅ هدر اصلاح شده (کپی شده از home_page.dart)
        _Header(title: loc.appTitle, subtitle: loc.appSubtitle),

        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Text(
            loc.devices,
            style: TextStyle(
              color: cs.onBackground,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),

        // لیست دستگاه‌ها یا پیام خالی بودن
        Expanded(
          child: devices.isEmpty
              ? Center(
            child: Text(
              loc.noDevices,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: cs.onBackground.withOpacity(.65),
                fontSize: 16,
              ),
            ),
          )
              : ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            itemCount: devices.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, i) => _DeviceCard(
              d: devices[i],
              onTap: () => _openDevice(context, devices[i]),
            ),
          ),
        ),

        // فقط دکمه پایین صفحه
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton.icon(
            onPressed: () => _addDevice(context),
            icon: const Icon(Icons.add),
            label: Text(loc.addDeviceTitle),
          ),
        ),
      ],
    );
  }
}

// ✅ ویجت هدر (کپی شده از home_page.dart برای اطمینان از یکسان بودن)
class _Header extends StatelessWidget {
  const _Header({required this.title, required this.subtitle});
  final String title, subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0E8AC0), Color(0xFF0F8F7A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _DeviceCard extends StatelessWidget {
  const _DeviceCard({required this.d, required this.onTap});
  final Device d;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final blocState = context.watch<DeviceControlBloc>().state;
    final connected = blocState.isConnected && blocState.device?.id == d.id;

    final isLight = theme.brightness == Brightness.light;
    final cardBg = isLight ? Colors.white : Colors.white.withOpacity(.07);

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(16),
          border:
          Border.all(color: theme.dividerColor.withOpacity(.2)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Row(
              children: [
                Expanded(
                  child: Text(
                    d.name ?? 'Unknown',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: cs.onSurface,
                    ),
                  ),
                ),
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF059669).withOpacity(.15),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                        color: const Color(0xFF059669).withOpacity(.45)),
                  ),
                  child: Text(
                    AppLocalizations.of(context)?.vivarium ?? 'Vivarium',
                    style: const TextStyle(
                      color: Color(0xFF059669),
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Serial
            Row(
              children: [
                Text(
                  '${AppLocalizations.of(context)?.serialLabel ?? 'Serial'}: ',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: cs.onSurface,
                  ),
                ),
                Text(
                  d.serial ?? '-',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: cs.onSurface.withOpacity(.7),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // ConnectButton
            Center(
              child: ConnectButton(
                connected: connected,
                onConnect: () =>
                    context.read<DeviceControlBloc>().add(ConnectDevice(d)),
                onDisconnect: () => context
                    .read<DeviceControlBloc>()
                    .add(const DisconnectDevice()),
                connectLabel:
                AppLocalizations.of(context)?.connect ?? 'Connect',
                connectedLabel:
                AppLocalizations.of(context)?.connected ?? 'Connected',
                disconnectingLabel:
                AppLocalizations.of(context)?.disconnecting ??
                    'Disconnecting',
              ),
            ),
          ],
        ),
      ),
    );
  }
}