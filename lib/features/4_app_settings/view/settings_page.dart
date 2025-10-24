import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/theme_controller.dart'; // ThemeControllerScope
import '../../../main.dart' show LocaleControllerScope;

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late String _langCode;
  late ThemeMode _mode;
  bool _notifications = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _langCode = Localizations.localeOf(context).languageCode;
    _mode = ThemeControllerScope.of(context).mode;
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isLight = theme.brightness == Brightness.light;
    final textPrimary = theme.textTheme.bodyLarge?.color ??
        (isLight ? Colors.black87 : Colors.white);
    final textSecondary = textPrimary.withOpacity(isLight ? 0.7 : 0.75);

    BoxDecoration cardDecor() => BoxDecoration(
      color: isLight ? cs.surface : Colors.white.withOpacity(.07),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: isLight
            ? cs.outlineVariant.withOpacity(.5)
            : Colors.white.withOpacity(.10),
      ),
      boxShadow: [
        if (isLight)
          BoxShadow(
            color: Colors.black.withOpacity(.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
      ],
    );

    return Column(
      children: [
        // ✅ Green header like Home/Devices
        _Header(title: 'Vivarium', subtitle: loc.appSubtitle),

        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
            children: [
              Center(
                child: Text(
                  loc.settingsTitle,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: textPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // LANGUAGE
              Container(
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.all(14),
                decoration: cardDecor(),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/w_16.svg',
                      height: 22,
                      colorFilter:
                      const ColorFilter.mode(Color(0xFFA78BFA), BlendMode.srcIn),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(loc.languageTitle,
                              style: TextStyle(
                                  color: textPrimary,
                                  fontWeight: FontWeight.w700)),
                          const SizedBox(height: 4),
                          Text(loc.languageSubtitle,
                              style: TextStyle(
                                  color: textSecondary, fontSize: 13)),
                        ],
                      ),
                    ),
                    _PillDropdown<String>(
                      value: _langCode,
                      display: (code) => switch (code) {
                        'fa' => 'فارسی',
                        'ar' => 'العربية',
                        _ => 'English',
                      },
                      items: const ['en', 'fa', 'ar'],
                      onChanged: (code) {
                        if (code == null) return;
                        LocaleControllerScope.of(context)
                            .setLocale(Locale(code));
                        setState(() => _langCode = code);
                      },
                    ),
                  ],
                ),
              ),

              // THEME
              Container(
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.all(14),
                decoration: cardDecor(),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/w_16_1.svg',
                      height: 22,
                      colorFilter:
                      const ColorFilter.mode(Color(0xFFFACC15), BlendMode.srcIn),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(loc.themeTitle,
                              style: TextStyle(
                                  color: textPrimary,
                                  fontWeight: FontWeight.w700)),
                          const SizedBox(height: 4),
                          Text(loc.themeSubtitle,
                              style: TextStyle(
                                  color: textSecondary, fontSize: 13)),
                        ],
                      ),
                    ),
                    _PillDropdown<ThemeMode>(
                      value: _mode == ThemeMode.system
                          ? (Theme.of(context).brightness == Brightness.dark
                          ? ThemeMode.dark
                          : ThemeMode.light)
                          : _mode,
                      display: (m) =>
                      m == ThemeMode.dark ? loc.themeDark : loc.themeLight,
                      items: const [ThemeMode.dark, ThemeMode.light],
                      onChanged: (m) {
                        if (m == null) return;
                        ThemeControllerScope.of(context).setMode(m);
                        setState(() => _mode = m);
                      },
                    ),
                  ],
                ),
              ),

              // NOTIFICATIONS
              Container(
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.all(14),
                decoration: cardDecor(),
                child: Row(
                  children: [
                    const Icon(Icons.notifications, color: Color(0xFFF59E0B)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(loc.notificationsTitle,
                              style: TextStyle(
                                  color: textPrimary,
                                  fontWeight: FontWeight.w700)),
                          const SizedBox(height: 4),
                          Text(loc.notificationsSubtitle,
                              style: TextStyle(
                                  color: textSecondary, fontSize: 13)),
                        ],
                      ),
                    ),
                    Switch(
                      value: _notifications,
                      activeColor: Colors.white,
                      activeTrackColor: const Color(0xFFFFB74D),
                      onChanged: (v) => setState(() => _notifications = v),
                    ),
                  ],
                ),
              ),

              // ABOUT
              Container(
                margin: const EdgeInsets.only(top: 8),
                padding: const EdgeInsets.all(14),
                decoration: cardDecor(),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: isLight
                            ? cs.surfaceVariant
                            : Colors.white.withOpacity(.06),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isLight
                              ? cs.outlineVariant.withOpacity(.6)
                              : Colors.white24,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: SvgPicture.asset(
                        'assets/icons/w_6_6.svg',
                        width: 22,
                        height: 22,
                        colorFilter:
                        ColorFilter.mode(textPrimary, BlendMode.srcIn),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DefaultTextStyle(
                        style: TextStyle(color: textSecondary, height: 1.45),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(loc.aboutTitle,
                                style: TextStyle(
                                    color: textPrimary,
                                    fontWeight: FontWeight.w700)),
                            const SizedBox(height: 8),
                            Text(loc.aboutBody1),
                            const SizedBox(height: 10),
                            Text(loc.version('2.1.0')),
                            Text(loc.copyright('2025')),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
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

class _PillDropdown<T> extends StatefulWidget {
  const _PillDropdown({
    required this.value,
    required this.items,
    required this.display,
    required this.onChanged,
  });

  final T value;
  final List<T> items;
  final String Function(T value) display;
  final ValueChanged<T?> onChanged;

  @override
  State<_PillDropdown<T>> createState() => _PillDropdownState<T>();
}

class _PillDropdownState<T> extends State<_PillDropdown<T>> {
  final _key = GlobalKey();

  Future<void> _openMenu() async {
    final box = _key.currentContext!.findRenderObject() as RenderBox;
    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final target = RelativeRect.fromRect(
      Rect.fromPoints(
        box.localToGlobal(Offset.zero, ancestor: overlay),
        box.localToGlobal(box.size.bottomRight(Offset.zero), ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );

    final selected = await showMenu<T>(
      context: context,
      position: target,
      items: [
        for (final it in widget.items)
          PopupMenuItem<T>(
            value: it,
            child: Text(widget.display(it)),
          ),
      ],
    );
    if (selected != null) widget.onChanged(selected);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isLight = theme.brightness == Brightness.light;

    return InkWell(
      key: _key,
      onTap: _openMenu,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isLight ? cs.surfaceVariant : Colors.white.withOpacity(.06),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isLight ? cs.outlineVariant.withOpacity(.6) : Colors.white24,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.display(widget.value),
              style: TextStyle(
                color: theme.textTheme.bodyLarge?.color,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 6),
            Icon(
              Icons.keyboard_arrow_down,
              size: 20,
              color: theme.textTheme.bodyLarge?.color?.withOpacity(.8),
            ),
          ],
        ),
      ),
    );
  }
}

class _SyncPill extends StatelessWidget {
  const _SyncPill({required this.label, this.onTap});
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF16A34A),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            label,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }
}