import 'package:flutter/material.dart';

class DeviceCard extends StatelessWidget {
  const DeviceCard({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final isLight = t.brightness == Brightness.light;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isLight ? t.colorScheme.surface : t.colorScheme.surface.withOpacity(.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isLight
              ? t.colorScheme.outlineVariant.withOpacity(.55)
              : Colors.white.withOpacity(.10),
        ),
        boxShadow: isLight
            ? [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 14,
            offset: const Offset(0, 6),
          )
        ]
            : null,
      ),
      child: child,
    );
  }
}

class SectionTitle extends StatelessWidget {
  const SectionTitle(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Text(
      text,
      style: t.textTheme.titleMedium?.copyWith(
        color: t.colorScheme.onSurface,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}

class Metric extends StatelessWidget {
  const Metric({
    super.key,
    required this.value,
    required this.label,
    required this.color,
  });
  final String value, label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Column(
      children: [
        Text(
          value,
          style: t.textTheme.headlineSmall?.copyWith(
            color: color,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: t.textTheme.bodySmall?.copyWith(
            color: t.colorScheme.onSurface.withOpacity(.7),
          ),
        ),
      ],
    );
  }
}

class StateRow extends StatelessWidget {
  const StateRow({
    super.key,
    required this.label,
    required this.on,
    required this.color,
    required this.onText,
    required this.offText,
  });

  final String label;
  final bool on;
  final Color color;
  final String onText;
  final String offText;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final isOn = on;
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: t.textTheme.bodyLarge?.copyWith(color: t.colorScheme.onSurface),
          ),
        ),
        Text(
          isOn ? onText : offText,
          style: t.textTheme.bodyLarge?.copyWith(
            color: isOn ? const Color(0xFF22C55E) : const Color(0xFFEF4444),
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}
class SwitchRow extends StatelessWidget {
  const SwitchRow({
    super.key,
    this.leading,           // <- optional leading widget
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final Widget? leading;     // new
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Row(
      children: [
        if (leading != null) ...[
          leading!,
          const SizedBox(width: 8),
        ],
        Expanded(
          child: Text(
            label,
            style: t.textTheme.bodyLarge?.copyWith(color: t.colorScheme.onSurface),
          ),
        ),
        Switch(value: value, onChanged: onChanged),
      ],
    );
  }
}

// class SwitchRow extends StatelessWidget {
//   const SwitchRow({
//     super.key,
//     required this.label,
//     required this.value,
//     required this.onChanged,
//   });
//   final String label;
//   final bool value;
//   final ValueChanged<bool> onChanged;
//
//   @override
//   Widget build(BuildContext context) {
//     final t = Theme.of(context);
//     return Row(
//       children: [
//         Expanded(
//           child: Text(
//             label,
//             style: t.textTheme.bodyLarge?.copyWith(color: t.colorScheme.onSurface),
//           ),
//         ),
//         Switch(value: value, onChanged: onChanged),
//       ],
//     );
//   }
// }

class SliderRow extends StatelessWidget {
  const SliderRow({
    super.key,
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.unit,
    required this.onChanged, required Null Function(dynamic val) onChangeEnd,
  });

  final String label;
  final double value, min, max;
  final String unit;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label  ${value.toStringAsFixed(0)}$unit',
          style: t.textTheme.bodyMedium?.copyWith(color: t.colorScheme.onSurface),
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class HintBox extends StatelessWidget {
  const HintBox({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final isLight = t.brightness == Brightness.light;
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isLight ? t.colorScheme.surfaceVariant : Colors.white.withOpacity(.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isLight ? t.colorScheme.outlineVariant.withOpacity(.6) : Colors.white24,
        ),
      ),
      child: Text(
        text,
        style: t.textTheme.bodyMedium?.copyWith(
          color: t.colorScheme.onSurface.withOpacity(.75),
        ),
      ),
    );
  }
}

class BackBtn extends StatelessWidget {
  const BackBtn({super.key, required this.onTap});
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: t.colorScheme.surface.withOpacity(.4),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white24),
        ),
        child: Icon(Icons.arrow_back, color: t.colorScheme.onSurface),
      ),
    );
  }
}

class ConnDot extends StatelessWidget {
  const ConnDot({
    super.key,
    required this.connected,
    required this.onlineText,
    required this.offlineText,
  });

  final bool connected;
  final String onlineText;
  final String offlineText;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: connected ? const Color(0xFF22C55E) : const Color(0xFFEF4444),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          connected ? onlineText : offlineText,
          style: t.textTheme.bodyMedium?.copyWith(
            color: t.colorScheme.onSurface.withOpacity(.75),
          ),
        ),
      ],
    );
  }
}
