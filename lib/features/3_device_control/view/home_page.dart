import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/connect_button.dart';
import '../../../data/device_provider.dart';
import '../../../data/models/device.dart';
import '../../3_device_control/view/vivarium_detail_page.dart';
import '../../../core/l10n/app_localizations.dart';
import '../bloc/device_control_bloc.dart';
import '../bloc/device_control_event.dart';
import '../bloc/device_control_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return DefaultTabController(
      length: 1,
      child: Column(
        children: [
          _Header(title: loc.appTitle, subtitle: loc.appSubtitle),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
            child: _PillTabs(
              tabs: [
                (
                icon: 'assets/icons/vivarium_icon.svg',
                label: loc.vivariumsTab
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer<DeviceProvider>(
              builder: (context, dp, _) {
                final vivas =
                dp.devices.where((d) => d.type == 'vivarium').toList();

                return TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _DevicesList(
                      devices: vivas,
                      deviceType: 'vivarium',
                      emptyTitle: loc.noVivariumsTitle,
                      emptyHint: loc.addDeviceHint,
                    ),
                  ],
                );
              },
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}

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

class _PillTabs extends StatelessWidget {
  const _PillTabs({required this.tabs});
  final List<({String icon, String label})> tabs;

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final sel = Theme.of(context).colorScheme.primary;
    final bg = isLight ? const Color(0xFFE7EEF8) : Colors.white.withOpacity(.06);
    final border = isLight ? const Color(0xFFCFDAEC) : Colors.white24;

    return Container(
      height: 52,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border),
      ),
      child: TabBar(
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelPadding: EdgeInsets.zero,
        indicator: BoxDecoration(
          color: sel.withOpacity(isLight ? .15 : .20),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: sel),
        ),
        labelColor: Theme.of(context).colorScheme.onSurface,
        unselectedLabelColor:
        Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(.75),
        tabs: [
          for (final t in tabs)
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    t.icon,
                    height: 20,
                    colorFilter: ColorFilter.mode(
                        Theme.of(context).colorScheme.primary, BlendMode.srcIn),
                  ),
                  const SizedBox(width: 8),
                  Text(t.label,
                      style: const TextStyle(fontWeight: FontWeight.w700)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _DevicesList extends StatelessWidget {
  const _DevicesList({
    required this.devices,
    required this.deviceType,
    required this.emptyTitle,
    required this.emptyHint,
  });

  final List<Device> devices;
  final String deviceType;
  final String emptyTitle;
  final String emptyHint;

  void _open(BuildContext context, Device d) {
    final blocState = context.read<DeviceControlBloc>().state;
    final isThisDeviceConnected =
        blocState.isConnected && blocState.device?.id == d.id;

    if (isThisDeviceConnected) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => VivariumDetailPage(device: d)),
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

  Future<void> _addDevice(BuildContext context) async {
    final dp = context.read<DeviceProvider>();
    await dp.showDevicePicker(context);
  }

  @override
  Widget build(BuildContext context) {
    if (devices.isEmpty) {
      return ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        children: [
          const SizedBox(height: 6),
          _AddCard(
            title: emptyTitle,
            subtitle: emptyHint,
            onTap: () => _addDevice(context),
          ),
        ],
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      itemBuilder: (_, i) => _DeviceTile(
        d: devices[i],
        onTap: () => _open(context, devices[i]),
      ),
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemCount: devices.length,
    );
  }
}

class _DeviceTile extends StatelessWidget {
  const _DeviceTile({required this.d, required this.onTap});
  final Device d;
  final VoidCallback onTap;

  // ❌ حذف شد:
  // String get _tempText => '––';
  // String get _humText => '––';

  void _renameDevice(BuildContext context) async {
    final loc = AppLocalizations.of(context)!;
    final TextEditingController controller = TextEditingController(text: d.name);

    final newName = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(loc.rename),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(hintText: loc.renameHint ?? 'نام جدید'),
          onSubmitted: (value) => Navigator.pop(ctx, value),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(loc.cancel ?? 'لغو'),
          ),
          TextButton(
            onPressed: () {
              final name = controller.text.trim();
              if (name.isNotEmpty) {
                Navigator.pop(ctx, name);
              }
            },
            child: Text(loc.save ?? 'ذخیره'),
          ),
        ],
      ),
    );

    if (newName != null && newName.trim().isNotEmpty && newName != d.name) {
      final updatedDevice = d.copyWith(name: newName.trim());
      final dp = context.read<DeviceProvider>();
      final success = await dp.updateDevice(updatedDevice);

      if (context.mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('${d.name} به ${newName.trim()} تغییر نام یافت.')),
          );
        } else if (dp.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('خطا در تغییر نام: ${dp.error}')),
          );
        }
      }
    }
  }

  void _deleteDevice(BuildContext context) async {
    final loc = AppLocalizations.of(context)!;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('${loc.delete} ${d.name}'),
        content: Text(loc.deleteConfirm ??
            'آیا مطمئن هستید که می‌خواهید این دستگاه را حذف کنید؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(loc.cancel ?? 'لغو'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(loc.delete, style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    ) ??
        false;

    if (confirmed) {
      final dp = context.read<DeviceProvider>();
      final success = await dp.removeDevice(d);

      if (context.mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${d.name} با موفقیت حذف شد.')),
          );
        } else if (dp.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('خطا در حذف دستگاه: ${dp.error}')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final badgeColor = const Color(0xFF059669);
    final loc = AppLocalizations.of(context)!;

    final cardBg = Theme.of(context).brightness == Brightness.light
        ? Colors.white
        : Colors.white.withOpacity(.07);

    final blocState = context.watch<DeviceControlBloc>().state;
    final connected = blocState.isConnected && blocState.device?.id == d.id;

    // ✅ منطق جدید برای نمایش داده‌های زنده
    String tempText;
    String humText;

    if (connected && blocState.reading != null) {
      final reading = blocState.reading!;
      tempText = reading.temperature != null
          ? '${reading.temperature!.toStringAsFixed(1)} °C'
          : '––';
      humText = reading.humidity != null
          ? '${reading.humidity!.toStringAsFixed(0)} %'
          : '––';
    } else {
      tempText = '––';
      humText = '––';
    }
    // ✅ پایان منطق جدید

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(16),
          border:
          Border.all(color: Theme.of(context).dividerColor.withOpacity(.2)),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(.06),
                blurRadius: 10,
                offset: const Offset(0, 4))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    d.name,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontWeight: FontWeight.w800),
                  ),
                ),
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: badgeColor.withOpacity(.15),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: badgeColor.withOpacity(.45)),
                  ),
                  child: Text(
                    loc.vivarium,
                    style: TextStyle(
                        color: badgeColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 12),
                  ),
                ),
                const SizedBox(width: 8),
                PopupMenuButton<String>(
                  padding: EdgeInsets.zero,
                  onSelected: (value) {
                    if (value == 'rename') {
                      _renameDevice(context);
                    } else if (value == 'delete') {
                      _deleteDevice(context);
                    }
                  },
                  itemBuilder: (BuildContext context) =>
                  <PopupMenuEntry<String>>[
                    PopupMenuItem<String>(
                      value: 'rename',
                      child: Row(
                        children: [
                          const Icon(Icons.edit, size: 20),
                          const SizedBox(width: 8),
                          Text(loc.rename),
                        ],
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: 'delete',
                      child: Row(
                        children: [
                          const Icon(Icons.delete_forever,
                              color: Colors.red, size: 20),
                          const SizedBox(width: 8),
                          Text(loc.delete,
                              style: const TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                  icon: const Icon(Icons.more_vert, size: 24),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Text('${loc.serialLabel}: ',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontWeight: FontWeight.w600)),
                Text(d.serial ?? 'N/A',
                    style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.device_thermostat, color: Color(0xFFF59E0B)),
                const SizedBox(width: 6),
                Text(
                  tempText, // ✅ استفاده از متغیر داینامیک
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontWeight: FontWeight.w700),
                ),
                const Spacer(),
                const Icon(Icons.water_drop, color: Color(0xFF0EA5E9)),
                const SizedBox(width: 6),
                Text(
                  humText, // ✅ استفاده از متغیر داینامیک
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontWeight: FontWeight.w700),
                ),
              ],
            ),
            const SizedBox(height: 14),
            ConnectButton(
              connected: connected,
              onConnect: () =>
                  context.read<DeviceControlBloc>().add(ConnectDevice(d)),
              onDisconnect: () => context
                  .read<DeviceControlBloc>()
                  .add(const DisconnectDevice()),
              connectLabel: loc.connect,
              connectedLabel: loc.connected,
              disconnectingLabel: loc.disconnecting,
            ),
          ],
        ),
      ),
    );
  }
}

class _AddCard extends StatelessWidget {
  const _AddCard(
      {required this.title, required this.subtitle, required this.onTap});
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final cardBg = isLight ? Colors.white : Colors.white.withOpacity(.06);

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(16),
          border:
          Border.all(color: Theme.of(context).dividerColor.withOpacity(.2)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(.12),
                shape: BoxShape.circle,
                border: Border.all(
                    color:
                    Theme.of(context).colorScheme.primary.withOpacity(.35)),
              ),
              child: Icon(Icons.add,
                  color: Theme.of(context).colorScheme.primary, size: 30),
            ),
            const SizedBox(height: 12),
            Text(title,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 6),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .color!
                    .withOpacity(.75),
              ),
            ),
          ],
        ),
      ),
    );
  }
}