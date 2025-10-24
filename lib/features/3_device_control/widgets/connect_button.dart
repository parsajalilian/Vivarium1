// lib/features/common/widgets/connect_button.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ConnectButton extends StatefulWidget {
  const ConnectButton({
    super.key,
    required this.connected,
    required this.onConnect,
    required this.onDisconnect,
    this.duration = const Duration(seconds: 3),
    this.height = 52,
    this.width, // null = full width
    this.connectLabel = 'Connect',
    this.connectedLabel = 'Connected',
    this.disconnectingLabel = 'Disconnecting…',
  });

  final bool connected;
  final VoidCallback onConnect;
  final VoidCallback onDisconnect;
  final Duration duration;
  final double height;
  final double? width;

  // ✅ لیبل‌ها پارامتری شدن؛ بعداً می‌تونی از AppLocalizations پاس بدی
  final String connectLabel;
  final String connectedLabel;
  final String disconnectingLabel;

  @override
  State<ConnectButton> createState() => _ConnectButtonState();
}

class _ConnectButtonState extends State<ConnectButton>
    with TickerProviderStateMixin {
  late final AnimationController _holdCtrl;   // برای نگه‌داشتن طولانی (disconnect)
  late final AnimationController _pulseCtrl;  // پالس وقتی connected
  bool _pressed = false;

  @override
  void initState() {
    super.initState();

    _holdCtrl = AnimationController(vsync: this, duration: widget.duration)
      ..addStatusListener((s) {
        if (s == AnimationStatus.completed) {
          HapticFeedback.mediumImpact();
          widget.onDisconnect();
          _holdCtrl.reset();
        }
      });

    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    if (widget.connected) _pulseCtrl.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(covariant ConnectButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.connected != widget.connected) {
      if (widget.connected) {
        _pulseCtrl.repeat(reverse: true);
      } else {
        _pulseCtrl.stop();
        _pulseCtrl.reset();
        _holdCtrl.reset();
      }
    }
  }

  @override
  void dispose() {
    _holdCtrl.dispose();
    _pulseCtrl.dispose();
    super.dispose();
  }

  void _onTap() {
    if (!widget.connected) {
      HapticFeedback.selectionClick();
      widget.onConnect();
    }
  }

  void _onTapDown(_) => setState(() => _pressed = true);
  void _onTapUp(_) => setState(() => _pressed = false);
  void _onTapCancel() => setState(() => _pressed = false);

  void _onLongPressStart(LongPressStartDetails _) {
    if (widget.connected) {
      HapticFeedback.lightImpact();
      _holdCtrl.forward(from: 0);
      setState(() => _pressed = true);
    }
  }

  void _onLongPressEnd(LongPressEndDetails _) {
    if (_holdCtrl.isAnimating) {
      _holdCtrl.reset();
    }
    setState(() => _pressed = false);
  }

  @override
  Widget build(BuildContext context) {
    final connected = widget.connected;

    // رنگ‌ها
    final bool disconnecting = _holdCtrl.isAnimating;
    final baseColor = !connected
        ? Colors.blue
        : (disconnecting ? Colors.orange : Colors.green);

    final borderColor = baseColor;
    final fillColor = baseColor;
    const labelColor = Colors.white;

    final pulse = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );

    return AnimatedScale(
      duration: const Duration(milliseconds: 120),
      scale: _pressed ? 0.98 : 1.0,
      child: SizedBox(
        width: widget.width ?? double.infinity,
        height: widget.height,
        child: GestureDetector(
          onTap: _onTap,
          onTapDown: _onTapDown,
          onTapUp: _onTapUp,
          onTapCancel: _onTapCancel,
          onLongPressStart: _onLongPressStart,
          onLongPressEnd: _onLongPressEnd,
          behavior: HitTestBehavior.opaque,
          child: AnimatedBuilder(
            animation: Listenable.merge([_holdCtrl, pulse]),
            builder: (_, __) {
              final t = Curves.easeInOutCubic.transform(_holdCtrl.value);
              final half = (t / 2).clamp(0.0, 0.5);

              final boxShadow = connected
                  ? [
                BoxShadow(
                  color: fillColor.withOpacity(0.28 * pulse.value),
                  blurRadius: 16 + 8 * pulse.value,
                  spreadRadius: 1 + 0.5 * pulse.value,
                ),
              ]
                  : const <BoxShadow>[];

              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(widget.height / 2),
                  border: Border.all(color: borderColor, width: 2),
                  boxShadow: boxShadow,
                ),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // پس‌زمینه‌ی ملایم
                    Positioned.fill(
                      child: Container(color: fillColor.withOpacity(.06)),
                    ),

                    // انیمیشن پر شدن از مرکز (disconnecting)
                    if (connected && half > 0)
                      Stack(
                        children: [
                          Align(
                            alignment: Alignment.centerRight,
                            child: FractionallySizedBox(
                              widthFactor: half,
                              heightFactor: 1,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.centerRight,
                                    end: Alignment.centerLeft,
                                    colors: [
                                      fillColor.withOpacity(.36),
                                      fillColor.withOpacity(.20),
                                      fillColor.withOpacity(.12),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: FractionallySizedBox(
                              widthFactor: half,
                              heightFactor: 1,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [
                                      fillColor.withOpacity(.36),
                                      fillColor.withOpacity(.20),
                                      fillColor.withOpacity(.12),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                    // متن
                    IgnorePointer(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 180),
                        child: Text(
                          connected
                              ? (disconnecting
                              ? widget.disconnectingLabel
                              : widget.connectedLabel)
                              : widget.connectLabel,
                          key: ValueKey('${connected}_$disconnecting'),
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            letterSpacing: .2,
                            color: labelColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
