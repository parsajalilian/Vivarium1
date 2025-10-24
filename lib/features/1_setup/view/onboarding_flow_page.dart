import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/theme/app_theme.dart';                // AppDecor.background
import '../../../core/theme/theme_controller.dart';         // ThemeControllerScope
import '../../../main.dart' show LocaleControllerScope;     // LocaleControllerScope
import '../../../core/l10n/app_localizations.dart';

enum _Step { welcome, language, theme, terms }

class OnboardingFlowPage extends StatefulWidget {
  const OnboardingFlowPage({super.key});
  @override
  State<OnboardingFlowPage> createState() => _OnboardingFlowPageState();
}

class _OnboardingFlowPageState extends State<OnboardingFlowPage> {
  final _page = PageController();
  _Step current = _Step.welcome;

  String? selectedLang;   // 'en'|'fa'|'ar'
  String? selectedTheme;  // 'dark'|'light'
  bool acceptedTerms = false;

  void _goNext() {
    switch (current) {
      case _Step.welcome:
        setState(() => current = _Step.language);
        _page.nextPage(duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
        break;
      case _Step.language:
        if (selectedLang != null) {
          setState(() => current = _Step.theme);
          _page.nextPage(duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
        }
        break;
      case _Step.theme:
        if (selectedTheme != null) {
          setState(() => current = _Step.terms);
          _page.nextPage(duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
        }
        break;
      case _Step.terms:
        _completeSetup();
        break;
    }
  }

  void _goBack() {
    switch (current) {
      case _Step.welcome:
        break;
      case _Step.language:
        setState(() => current = _Step.welcome);
        _page.previousPage(duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
        break;
      case _Step.theme:
        setState(() => current = _Step.language);
        _page.previousPage(duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
        break;
      case _Step.terms:
        setState(() => current = _Step.theme);
        _page.previousPage(duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
        break;
    }
  }

  bool get _primaryEnabled {
    switch (current) {
      case _Step.welcome:
        return true;
      case _Step.language:
        return selectedLang != null;
      case _Step.theme:
        return selectedTheme != null;
      case _Step.terms:
        return acceptedTerms;
    }
  }

  Future<void> _completeSetup() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('first_run', false);
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/main');
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final size = MediaQuery.sizeOf(context);
    final shortest = min(size.width, size.height);

    final cs = Theme.of(context).colorScheme;
    final textPrimary = cs.onSurface.withOpacity(0.95);
    final textSecondary = cs.onSurface.withOpacity(0.75);

    return Scaffold(
      body: Container(
        decoration: AppDecor.background(context),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView(
                  controller: _page,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _WelcomeStep(
                      shortest: shortest,
                      title: loc.welcomeTitle,
                      body: loc.welcomeBody,
                      primaryLabel: loc.getStarted,
                      onPrimary: _goNext,
                    ),
                    _LanguageStep(
                      title: loc.languageTitle,
                      subtitle: loc.languageSubtitle,
                      en: loc.languageEnglish,
                      fa: loc.languagePersian,
                      ar: loc.languageArabic,
                      selected: selectedLang,
                      onChanged: (code) {
                        LocaleControllerScope.of(context).setLocale(Locale(code));
                        setState(() => selectedLang = code);
                      },
                      textPrimary: textPrimary,
                      textSecondary: textSecondary,
                    ),
                    _ThemeStep(
                      title: loc.themeTitle,
                      subtitle: loc.themeSubtitle,
                      darkLabel: loc.themeDark,
                      lightLabel: loc.themeLight,
                      selected: selectedTheme,
                      onChanged: (mode) {
                        ThemeControllerScope.of(context)
                            .setMode(mode == 'dark' ? ThemeMode.dark : ThemeMode.light);
                        setState(() => selectedTheme = mode);
                      },
                      textPrimary: textPrimary,
                      textSecondary: textSecondary,
                    ),
                    _TermsStep(
                      title: loc.termsTitle,
                      subtitle: loc.termsSubtitle,
                      header: loc.termsHeader,
                      intro: loc.termsIntro,
                      usage: loc.termsUsage,
                      usageDesc: loc.termsUsageDesc,
                      privacy: loc.termsPrivacy,
                      privacyDesc: loc.termsPrivacyDesc,
                      liability: loc.termsLiability,
                      liabilityDesc: loc.termsLiabilityDesc,
                      updates: loc.termsUpdates,
                      updatesDesc: loc.termsUpdatesDesc,
                      checkboxLabel: loc.termsCheckbox,
                      accepted: acceptedTerms,
                      onToggle: (v) => setState(() => acceptedTerms = v),
                      textPrimary: textPrimary,
                      textSecondary: textSecondary,
                    ),
                  ],
                ),
              ),

              // Bottom actions:
              //  • Welcome step shows its *own* centered CTA, so keep space consistent here.
              //  • Other steps show Back / Next row (order fixed via LTR Directionality).
              if (current != _Step.welcome)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: Directionality(
                    textDirection: TextDirection.ltr, // keep button order in RTL
                    child: Row(
                      children: [
                        Expanded(
                          child: _ActionButton(
                            label: AppLocalizations.of(context)!.back,
                            enabled: current != _Step.welcome,
                            color: cs.surfaceVariant,
                            labelColor: cs.onSurface,
                            onPressed: _goBack,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _ActionButton(
                            label: switch (current) {
                              _Step.language => loc.next,
                              _Step.theme => loc.next,
                              _Step.terms => loc.completeSetup,
                              _ => loc.next,
                            },
                            enabled: _primaryEnabled,
                            color: current == _Step.terms ? const Color(0xFF16A34A) : const Color(0xFF0F6DB2),
                            labelColor: Colors.white,
                            onPressed: _primaryEnabled ? _goNext : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ─────────────────  STEP WELCOME  ─────────────────
class _WelcomeStep extends StatelessWidget {
  const _WelcomeStep({
    required this.shortest,
    required this.title,
    required this.body,
    required this.primaryLabel,
    required this.onPrimary,
  });

  final double shortest;
  final String title;
  final String body;
  final String primaryLabel;
  final VoidCallback onPrimary;

  @override
  Widget build(BuildContext context) {
    final titleSize = max(22.0, shortest * 0.055);
    final bodySize  = max(12.0, shortest * 0.022);
    final logoSize  = shortest * 0.18;
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Spacer(),
          Center(
            child: Container(
              width: logoSize,
              height: logoSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF0EA5E9), width: 3),
              ),
              alignment: Alignment.center,
              child: SvgPicture.asset(
                'assets/icons/w_24.svg',
                width: logoSize * 0.55,
                colorFilter: const ColorFilter.mode(Color(0xFF0EA5E9), BlendMode.srcIn),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: cs.onSurface, fontWeight: FontWeight.w800, fontSize: titleSize,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            body,
            textAlign: TextAlign.center,
            style: TextStyle(color: cs.onSurface.withOpacity(.85), fontSize: bodySize),
          ),
          const Spacer(),

          // Single centered CTA at bottom
          _ActionButton(
            label: primaryLabel,
            color: const Color(0xFF0EA5E9),
            labelColor: Colors.white,
            enabled: true,
            onPressed: onPrimary,
          ),
        ],
      ),
    );
  }
}

/// ─────────────────  STEP LANGUAGE  ─────────────────
class _LanguageStep extends StatelessWidget {
  const _LanguageStep({
    required this.title,
    required this.subtitle,
    required this.en,
    required this.fa,
    required this.ar,
    required this.selected,
    required this.onChanged,
    required this.textPrimary,
    required this.textSecondary,
  });

  final String title, subtitle, en, fa, ar;
  final String? selected;
  final ValueChanged<String> onChanged;
  final Color textPrimary, textSecondary;

  @override
  Widget build(BuildContext context) {
    Widget radio(String code, String label, String value) {
      final sel = selected == value;
      return _OutlineTile(
        selected: sel,
        onTap: () => onChanged(value),
        child: Row(
          children: [
            _Flag(code: code),
            const SizedBox(width: 12),
            Expanded(
              child: Text(label,
                  style: TextStyle(color: textPrimary, fontSize: 16, fontWeight: FontWeight.w600)),
            ),
            _RadioMark(selected: sel),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Column(
        children: [
          SvgPicture.asset('assets/icons/w_16.svg', height: 56,
              colorFilter: const ColorFilter.mode(Color(0xFFA78BFA), BlendMode.srcIn)),
          const SizedBox(height: 12),
          Text(title,
              style: TextStyle(color: textPrimary, fontSize: 26, fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          Text(subtitle, style: TextStyle(color: textSecondary)),
          const SizedBox(height: 24),
          radio('US', en, 'en'),
          const SizedBox(height: 12),
          radio('IR', fa, 'fa'),
          const SizedBox(height: 12),
          radio('SA', ar, 'ar'),
        ],
      ),
    );
  }
}

/// ─────────────────  STEP THEME  ─────────────────
class _ThemeStep extends StatelessWidget {
  const _ThemeStep({
    required this.title,
    required this.subtitle,
    required this.darkLabel,
    required this.lightLabel,
    required this.selected,
    required this.onChanged,
    required this.textPrimary,
    required this.textSecondary,
  });

  final String title, subtitle, darkLabel, lightLabel;
  final String? selected;
  final ValueChanged<String> onChanged; // 'dark' | 'light'
  final Color textPrimary, textSecondary;

  @override
  Widget build(BuildContext context) {
    Widget preview({required String title, required String value, required Widget child}) {
      final sel = selected == value;
      return _OutlineTile(
        selected: sel,
        padding: const EdgeInsets.all(12),
        onTap: () => onChanged(value),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(color: textPrimary, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Container(
              height: 96,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
              child: Stack(
                children: [
                  Positioned.fill(child: child),
                  Positioned(right: 12, top: 12, child: _RadioMark(selected: sel)),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Column(
        children: [
          SvgPicture.asset('assets/icons/ic_theme.svg', height: 56,
              colorFilter: const ColorFilter.mode(Color(0xFFFACC15), BlendMode.srcIn)),
          const SizedBox(height: 12),
          Text(title,
              style: TextStyle(color: textPrimary, fontSize: 26, fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          Text(subtitle, style: TextStyle(color: textSecondary)),
          const SizedBox(height: 24),
          preview(title: darkLabel, value: 'dark', child: const _DarkPreview()),
          const SizedBox(height: 16),
          preview(title: lightLabel, value: 'light', child: const _LightPreview()),
        ],
      ),
    );
  }
}

/// ─────────────────  STEP TERMS  ─────────────────
class _TermsStep extends StatelessWidget {
  const _TermsStep({
    required this.title,
    required this.subtitle,
    required this.header,
    required this.intro,
    required this.usage,
    required this.usageDesc,
    required this.privacy,
    required this.privacyDesc,
    required this.liability,
    required this.liabilityDesc,
    required this.updates,
    required this.updatesDesc,
    required this.checkboxLabel,
    required this.accepted,
    required this.onToggle,
    required this.textPrimary,
    required this.textSecondary,
  });

  final String title, subtitle, header, intro;
  final String usage, usageDesc, privacy, privacyDesc, liability, liabilityDesc, updates, updatesDesc;
  final String checkboxLabel;
  final bool accepted;
  final ValueChanged<bool> onToggle;
  final Color textPrimary, textSecondary;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Column(
        children: [
          SvgPicture.asset('assets/icons/ic_doc.svg', height: 56,
              colorFilter: const ColorFilter.mode(Color(0xFF22C55E), BlendMode.srcIn)),
          const SizedBox(height: 12),
          Text(title,
              style: TextStyle(color: textPrimary, fontSize: 26, fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          Text(subtitle, style: TextStyle(color: textSecondary)),

          const SizedBox(height: 16),
          Container(
            height: 260,
            decoration: BoxDecoration(
              color: cs.surface.withOpacity(0.06),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: cs.outline.withOpacity(.4)),
            ),
            padding: const EdgeInsets.all(12),
            child: Scrollbar(
              child: SingleChildScrollView(
                child: DefaultTextStyle(
                  style: TextStyle(color: textSecondary, height: 1.45),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(header, style: TextStyle(color: textPrimary, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 10),
                      Text(intro),
                      const SizedBox(height: 12),
                      Text(usage, style: TextStyle(color: textPrimary, fontWeight: FontWeight.w600)),
                      Text(usageDesc),
                      const SizedBox(height: 8),
                      Text(privacy, style: TextStyle(color: textPrimary, fontWeight: FontWeight.w600)),
                      Text(privacyDesc),
                      const SizedBox(height: 8),
                      Text(liability, style: TextStyle(color: textPrimary, fontWeight: FontWeight.w600)),
                      Text(liabilityDesc),
                      const SizedBox(height: 8),
                      Text(updates, style: TextStyle(color: textPrimary, fontWeight: FontWeight.w600)),
                      Text(updatesDesc),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () => onToggle(!accepted),
            child: Row(
              children: [
                Container(
                  width: 22, height: 22,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: const Color(0xFF0EA5E9), width: 2),
                    color: accepted ? const Color(0xFF0EA5E9) : Colors.transparent,
                  ),
                  child: accepted ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(checkboxLabel, style: TextStyle(color: textPrimary)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// ──────────── shared bits ────────────
class _OutlineTile extends StatelessWidget {
  const _OutlineTile({
    required this.child,
    this.onTap,
    this.padding,
    this.selected = false,
  });
  final Widget child;
  final EdgeInsets? padding;
  final VoidCallback? onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final borderColor = selected ? const Color(0xFFF59E0B) : cs.outline.withOpacity(.4);
    final bg = selected ? const Color(0xFFFFF7E6).withOpacity(0.12) : cs.surface.withOpacity(.06);

    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: borderColor, width: selected ? 2 : 1),
            boxShadow: selected
                ? [BoxShadow(color: const Color(0xFFF59E0B).withOpacity(.25), blurRadius: 10)]
                : null,
          ),
          child: child,
        ),
      ),
    );
  }
}

class _RadioMark extends StatelessWidget {
  const _RadioMark({required this.selected});
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final border = Theme.of(context).colorScheme.onSurface.withOpacity(.70);
    return Container(
      width: 22, height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: border, width: 2),
        color: selected ? const Color(0xFFF59E0B) : Colors.transparent,
      ),
      child: selected ? const Icon(Icons.circle, size: 10, color: Colors.white) : null,
    );
  }
}

class _Flag extends StatelessWidget {
  const _Flag({required this.code});
  final String code;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: 42, height: 42,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(
          begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: [cs.surfaceVariant.withOpacity(.6), cs.surfaceVariant],
        ),
        border: Border.all(color: cs.outline.withOpacity(.5)),
      ),
      child: Text(code,
          style: TextStyle(color: cs.onSurface, fontWeight: FontWeight.w700)),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.color,
    required this.enabled,
    required this.labelColor,
    this.onPressed,
  });

  final String label;
  final Color color;
  final Color labelColor;
  final bool enabled;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final bg = enabled ? color : color.withOpacity(.55);
    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: enabled ? onPressed : null,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          alignment: Alignment.center,
          child: Text(
            label,
            textAlign: TextAlign.center, // keep centered in RTL too
            style: TextStyle(color: labelColor, fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }
}

class _DarkPreview extends StatelessWidget {
  const _DarkPreview();
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [const Color(0xFF0F172A), const Color(0xFF1E3A8A), const Color(0xFF1E2A44)],
                  begin: Alignment.topLeft, end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 32, height: 32,
              decoration: const BoxDecoration(color: Color(0xFF0EA5E9), shape: BoxShape.circle),
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(color: cs.outline.withOpacity(.5)),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LightPreview extends StatelessWidget {
  const _LightPreview();
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFEFF6FF), Color(0xFFDBEAFE)],
                  begin: Alignment.topLeft, end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 32, height: 32,
              decoration: const BoxDecoration(color: Color(0xFF3B82F6), shape: BoxShape.circle),
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFBFDBFE)),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
