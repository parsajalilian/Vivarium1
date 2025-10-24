import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aquaviva/core/l10n/app_localizations.dart';

import '../../../core/l10n/app_localizations.dart';

class AppColors {
  static const ocean  = Color(0xFF0EA5E9);
  static const forest = Color(0xFF059669);
  static const sunset = Color(0xFFF59E0B);

  static const bgA = Color(0xFF0F172A);
  static const bgB = Color(0xFF1E3A8A);
  static const bgC = Color(0xFF1E293B);
}

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});
  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late final AnimationController _dotCtrl;
  final List<double> _phase = [0.00, 0.10, 0.20];

  @override
  void initState() {
    super.initState();
    _dotCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
    _navigateNext();
  }

  Future<void> _navigateNext() async {
    // Keep splash visible for a short, consistent time
    await Future.delayed(const Duration(seconds: 3));

    final prefs = await SharedPreferences.getInstance();
    final firstRun = prefs.getBool('first_run') ?? true;

    if (!mounted) return;
    if (firstRun) {
      Navigator.pushReplacementNamed(context, '/onboarding');
    } else {
      Navigator.pushReplacementNamed(context, '/main');
    }
  }

  @override
  void dispose() {
    _dotCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final shortest = min(size.width, size.height);

    // Responsive sizing
    final logoSize  = shortest.clamp(240, 420) * 0.28;
    final titleSize = shortest.clamp(240, 420) * 0.12;
    final dotSize   = max(8.0, shortest * 0.022);
    final dotGap    = max(8.0, shortest * 0.03);

    final t = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft, end: Alignment.bottomRight,
            colors: [AppColors.bgA, AppColors.bgB, AppColors.bgC],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // --- Logo (sample SVG to be replaced later) ---
                  Container(
                    width: logoSize,
                    height: logoSize,
                    decoration: BoxDecoration(
                      color: AppColors.ocean.withOpacity(0.08),
                      shape: BoxShape.circle,
                    ),
                    padding: EdgeInsets.all(logoSize * 0.18),
                    child: SvgPicture.asset(
                      'assets/icons/w_32.svg',
                      colorFilter: const ColorFilter.mode(
                        AppColors.ocean, BlendMode.srcIn,
                      ),
                      fit: BoxFit.contain,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // --- Title & Tagline (localized) ---
                  Text(
                    t.appTitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: max(20, titleSize * 0.42),
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: 0.4,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    t.tagline,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: max(12, titleSize * 0.22),
                      fontWeight: FontWeight.w500,
                      color: AppColors.ocean,
                    ),
                  ),

                  const SizedBox(height: 18),

                  // --- Bouncing dots ---
                  SizedBox(
                    height: dotSize * 2.2,
                    child: AnimatedBuilder(
                      animation: _dotCtrl,
                      builder: (context, _) {
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _Dot(
                              t: _dotCtrl.value,
                              phase: _phase[0],
                              size: dotSize,
                              color: AppColors.ocean,
                            ),
                            SizedBox(width: dotGap),
                            _Dot(
                              t: _dotCtrl.value,
                              phase: _phase[1],
                              size: dotSize,
                              color: AppColors.forest,
                            ),
                            SizedBox(width: dotGap),
                            _Dot(
                              t: _dotCtrl.value,
                              phase: _phase[2],
                              size: dotSize,
                              color: AppColors.sunset,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  final double t;       // controller value (0..1)
  final double phase;   // per-dot offset (0..1)
  final double size;
  final Color color;

  const _Dot({
    required this.t,
    required this.phase,
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    // Periodic bounce
    final d = ((t + phase) % 1.0);
    final bounce = sin(d * 2 * pi);   // -1..1
    final lift = (bounce + 1) / 2;    // 0..1
    final translateY = -lift * size * 0.8;
    final scale = 0.9 + lift * 0.1;   // 0.9..1.0

    return Transform.translate(
      offset: Offset(0, translateY),
      child: Transform.scale(
        scale: scale,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.5),
                blurRadius: size * 0.6,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
