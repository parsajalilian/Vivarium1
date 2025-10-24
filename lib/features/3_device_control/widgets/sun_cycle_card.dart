import 'dart:math';
import 'package:flutter/material.dart';

/// A pure-UI sunrise/sunset simulator card.
/// - Pass the device's current time (DateTime.now() from your platform layer later).
/// - Sun position updates every second (lightweight).
/// - If [interactive] is true, a slider appears so you can scrub the timeline in UI-only mode.
///
/// Example:
/// SunCycleCard(
///   sunrise: const TimeOfDay(hour: 6, minute: 30),
///   sunset:  const TimeOfDay(hour: 19, minute: 30),
///   now: DateTime.now(), // device time (you can inject)
/// )
class SunCycleCard extends StatefulWidget {
  const SunCycleCard({
    super.key,
    required this.sunrise,
    required this.sunset,
    required this.now,
    this.interactive = true,
  });

  final TimeOfDay sunrise;
  final TimeOfDay sunset;
  final DateTime now;
  final bool interactive;

  @override
  State<SunCycleCard> createState() => _SunCycleCardState();
}

class _SunCycleCardState extends State<SunCycleCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _tick;
  double? _scrubMinutes; // if user scrubs, override 'now' with this

  @override
  void initState() {
    super.initState();
    _tick = AnimationController(vsync: this, duration: const Duration(seconds: 1))
      ..addStatusListener((s) {
        if (s == AnimationStatus.completed) {
          _tick
            ..reset()
            ..forward();
        }
      })
      ..forward();
  }

  @override
  void dispose() {
    _tick.dispose();
    super.dispose();
  }

  // ---- helpers -------------------------------------------------------------

  double _toMin(TimeOfDay t) => t.hour * 60.0 + t.minute;
  double _norm(double x, double a, double b) => ((x - a) / (b - a)).clamp(0.0, 1.0);

  /// Returns the minutes since midnight to render (either real now or scrub value).
  double _currentMinutes() {
    if (_scrubMinutes != null) return _scrubMinutes!;
    final dt = widget.now;
    return dt.hour * 60.0 + dt.minute + dt.second / 60.0;
  }

  bool get _isInDay {
    final s = _toMin(widget.sunrise), e = _toMin(widget.sunset), nowM = _currentMinutes();
    return nowM >= s && nowM <= e;
  }

  /// Computes a 0..1 day progress mapped from sunrise..sunset (clamped).
  double _dayProgress() {
    final s = _toMin(widget.sunrise), e = _toMin(widget.sunset), nowM = _currentMinutes();
    return _norm(nowM, s, e);
  }

  @override
  Widget build(BuildContext context) {
    final sunriseStr = _fmt(widget.sunrise);
    final sunsetStr  = _fmt(widget.sunset);
    final nowStr     = _fmt(TimeOfDay(hour: (widget.now.hour), minute: widget.now.minute));

    // choose sky gradient by time
    final isDay = _isInDay;
    final colors = isDay
        ? const [Color(0xFF60A5FA), Color(0xFF2563EB)] // blue-400 -> blue-600
        : const [Color(0xFF0F172A), Color(0xFF1F2937)]; // slate night

    final minsInDay = _currentMinutes();
    final s = _toMin(widget.sunrise), e = _toMin(widget.sunset);
    final p = (minsInDay <= s)
        ? -_norm(s - minsInDay, 0, 120) // pre-dawn (up to 2h earlier) -> negative progress
        : (minsInDay >= e)
        ? 1 + _norm(minsInDay - e, 0, 120) // dusk tail -> >1
        : _dayProgress();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.07),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _Title(text: 'Sunrise/Sunset Simulator'),
          const SizedBox(height: 10),

          // Sky + sun path
          AspectRatio(
            aspectRatio: 16 / 7,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: AnimatedBuilder(
                animation: _tick,
                builder: (_, __) {
                  return CustomPaint(
                    painter: _SkyPainter(
                      gradient: colors,
                      progress: p,
                      isDay: isDay,
                    ),
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 12),
          Row(
            children: [
              _MiniLabel('Sunrise', sunriseStr),
              const Spacer(),
              _MiniLabel('Sunset', sunsetStr),
              const Spacer(),
              _MiniLabel('Current Time', nowStr),
            ],
          ),

          if (widget.interactive) ...[
            const SizedBox(height: 10),
            _Scrubber(
              sunrise: _toMin(widget.sunrise),
              sunset: _toMin(widget.sunset),
              value: _scrubMinutes ?? minsInDay,
              onChanged: (v) => setState(() => _scrubMinutes = v),
              onStop: () => setState(() => _scrubMinutes = null),
            ),
          ],
        ],
      ),
    );
  }

  String _fmt(TimeOfDay t) {
    final h = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final m = t.minute.toString().padLeft(2, '0');
    final ap = t.period == DayPeriod.am ? 'AM' : 'PM';
    return '$h:$m $ap';
  }
}

// ---------------- painters + small widgets -----------------------------------

class _SkyPainter extends CustomPainter {
  _SkyPainter({
    required this.gradient,
    required this.progress,
    required this.isDay,
  });

  final List<Color> gradient;
  final double progress; // can go <0 pre-dawn and >1 dusk tail
  final bool isDay;

  @override
  void paint(Canvas canvas, Size size) {
    final r = RRect.fromRectAndRadius(
      Offset.zero & size, const Radius.circular(14),
    );
    final bg = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: gradient,
      ).createShader(Offset.zero & size);
    canvas.drawRRect(r, bg);

    // Horizon line
    final horizonY = size.height * 0.75;
    final horizon = Paint()..color = Colors.white.withOpacity(.12)..strokeWidth = 2;
    canvas.drawLine(Offset(12, horizonY), Offset(size.width - 12, horizonY), horizon);

    // Sun path: quadratic arc from left horizon to right horizon
    final left = Offset(18, horizonY);
    final right = Offset(size.width - 18, horizonY);
    final apex = Offset(size.width / 2, size.height * 0.18);

    // Draw a soft path hint
    final pathPaint = Paint()
      ..color = Colors.white.withOpacity(.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final path = Path()
      ..moveTo(left.dx, left.dy)
      ..quadraticBezierTo(apex.dx, apex.dy, right.dx, right.dy);
    canvas.drawPath(path, pathPaint);

    // Clamp progress to path range (0..1) for position, but keep opacity based on real progress
    final t = progress.clamp(0.0, 1.0);
    final pos = _quadBezier(left, apex, right, t);

    // Sun (or moon-ish)
    final double sunRadius = 12;
    final sunColor = isDay ? const Color(0xFFFFD54F) : Colors.white70;
    final glow = Paint()
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 16)
      ..color = sunColor.withOpacity(isDay ? 0.55 : 0.25);
    canvas.drawCircle(pos, sunRadius * 1.6, glow);

    final sun = Paint()..color = sunColor;
    canvas.drawCircle(pos, sunRadius, sun);

    // Dim the sky slightly outside day window (soft overlay)
    if (!isDay) {
      final night = Paint()..color = const Color(0xFF0B1020).withOpacity(.15);
      canvas.drawRRect(r, night);
      // tiny twinkles
      final rnd = Random(7);
      for (int i = 0; i < 18; i++) {
        final s = Offset(rnd.nextDouble() * size.width, rnd.nextDouble() * size.height * .55);
        final p = Paint()..color = Colors.white.withOpacity(rnd.nextDouble() * .6 + .2);
        canvas.drawCircle(s, rnd.nextDouble() * 1.2 + .3, p);
      }
    }
  }

  Offset _quadBezier(Offset p0, Offset p1, Offset p2, double t) {
    final u = 1 - t;
    return Offset(
      u * u * p0.dx + 2 * u * t * p1.dx + t * t * p2.dx,
      u * u * p0.dy + 2 * u * t * p1.dy + t * t * p2.dy,
    );
  }

  @override
  bool shouldRepaint(covariant _SkyPainter old) =>
      old.gradient != gradient || old.progress != progress || old.isDay != isDay;
}

class _Title extends StatelessWidget {
  const _Title({required this.text});
  final String text;
  @override
  Widget build(BuildContext context) => Text(
    text,
    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
  );
}

class _MiniLabel extends StatelessWidget {
  const _MiniLabel(this.title, this.value);
  final String title; final String value;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title, style: TextStyle(color: Colors.white.withOpacity(.75), fontSize: 12)),
      const SizedBox(height: 2),
      Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
    ],
  );
}

// class _Scrubber extends StatelessWidget {
//   const _Scrubber({
//     required this.sunrise,
//     required this.sunset,
//     required this.value,
//     required this.onChanged,
//     required this.onStop,
//   });
//
//   final double sunrise;
//   final double sunset;
//   final double value; // minutes since midnight
//   final ValueChanged<double> onChanged;
//   final VoidCallback onStop;
//
//   @override
//   Widget build(BuildContext context) {
    // Allow scrubbing an hour before sunrise to an hour after sunset.
//     final min = max(0.0, sunrise - 60);
//     final maxVal = min(24 * 60.0, sunset + 60);
//     return Column(
//       children: [
//         SliderTheme(
//           data: SliderTheme.of(context).copyWith(
//             inactiveTrackColor: Colors.white24,
//             activeTrackColor: const Color(0xFF0EA5E9),
//             thumbColor: const Color(0xFF0EA5E9),
//           ),
//           child: Slider(
//             min: min,
//             max: maxVal,
//             value: value.clamp(min, maxVal),
//             onChanged: onChanged,
//             onChangeEnd: (_) => onStop(),
//           ),
//         ),
//         Row(
//           children: [
//             Text('Scrub', style: TextStyle(color: Colors.white.withOpacity(.7))),
//             const Spacer(),
//             Text('${(value ~/ 60).toString().padLeft(2, '0')}:${(value % 60).round().toString().padLeft(2, '0')}',
//                 style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
//           ],
//         ),
//       ],
//     );
//   }
// }
class _Scrubber extends StatelessWidget {
  const _Scrubber({
    required this.sunrise,
    required this.sunset,
    required this.value,
    required this.onChanged,
    required this.onStop,
  });

  final double sunrise;
  final double sunset;
  final double value; // minutes since midnight
  final ValueChanged<double> onChanged;
  final VoidCallback onStop;

  @override
  Widget build(BuildContext context) {
    // Allow scrubbing an hour before sunrise to an hour after sunset.
    final minVal = max(0.0, sunrise - 60);
    final maxVal = min(24 * 60.0, sunset + 60);

    return Column(
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            inactiveTrackColor: Colors.white24,
            activeTrackColor: const Color(0xFF0EA5E9),
            thumbColor: const Color(0xFF0EA5E9),
          ),
          child: Slider(
            min: minVal,
            max: maxVal,
            value: value.clamp(minVal, maxVal).toDouble(),
            onChanged: onChanged,
            onChangeEnd: (_) => onStop(),
          ),
        ),
        Row(
          children: [
            Text('Scrub', style: TextStyle(color: Colors.white.withOpacity(.7))),
            const Spacer(),
            Text(
              '${(value ~/ 60).toString().padLeft(2, '0')}:${(value % 60).round().toString().padLeft(2, '0')}',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ],
    );
  }
}

