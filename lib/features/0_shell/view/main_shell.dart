import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../3_device_control/view/home_page.dart';
import '../../2_device_management/view/devices_page.dart';
import '../../4_app_settings/view/settings_page.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 1;

  final _pages = const [DevicesPage(), HomePage(), SettingsPage()];

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      body: Container(
        decoration: AppDecor.background(context),
        child: SafeArea(
          child: IndexedStack(index: _index, children: _pages),
        ),
      ),
      bottomNavigationBar: _BottomBar(
        index: _index,
        labels: (devices: loc.devices, home: loc.home, settings: loc.settings),
        onChanged: (i) async {
          if (i == _index) return;
          await HapticFeedback.selectionClick();
          setState(() => _index = i);
        },
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({
    required this.index,
    required this.onChanged,
    required this.labels,
  });

  final int index;
  final ValueChanged<int> onChanged;
  final ({String devices, String home, String settings}) labels;

  @override
  Widget build(BuildContext context) {
    final bg = Theme.of(context).bottomAppBarTheme.color ?? const Color(0xFF1F2937);
    final active = Theme.of(context).colorScheme.secondary;

    // Force LTR **inside** the bar so order never flips in RTL.
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        decoration: BoxDecoration(color: bg, boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, -2)),
        ]),
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            _Item(
              label: labels.devices,
              asset: 'assets/icons/w_6_7.svg',
              selected: index == 0,
              active: active,
              onTap: () => onChanged(0),
            ),
            _Item(
              label: labels.home,
              asset: 'assets/icons/home.svg',
              selected: index == 1,
              active: active,
              onTap: () => onChanged(1),
            ),
            _Item(
              label: labels.settings,
              asset: 'assets/icons/w_6_9.svg',
              selected: index == 2,
              active: active,
              onTap: () => onChanged(2),
            ),
          ],
        ),
      ),
    );
  }
}

class _Item extends StatelessWidget {
  const _Item({
    required this.label,
    required this.asset,
    required this.selected,
    required this.active,
    required this.onTap,
  });

  final String label, asset;
  final bool selected;
  final Color active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? active : Colors.white70;

    // Keep label/icon centered; label respects app language, but
    // we lock the **button order** via Directionality wrapper above.
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                asset,
                height: 22,
                colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
