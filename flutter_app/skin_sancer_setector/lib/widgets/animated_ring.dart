import 'package:flutter/material.dart';

class AnimatedRing extends StatefulWidget {
  final double confidence; // can be 0–100 OR 0–1
  final Color color;

  const AnimatedRing({
    super.key,
    required this.confidence,
    required this.color,
  });

  @override
  State<AnimatedRing> createState() => _AnimatedRingState();
}

class _AnimatedRingState extends State<AnimatedRing>
    with TickerProviderStateMixin {
  late AnimationController _fillCtrl;
  late AnimationController _pulseCtrl;

  late Animation<double> _fillAnim;
  late Animation<double> _pulseAnim;
  late Animation<double> _glowAnim;

  double get normalizedValue {
    // ✅ Handles both 0–1 and 0–100
    if (widget.confidence > 1) {
      return (widget.confidence / 100).clamp(0.0, 1.0);
    }
    return widget.confidence.clamp(0.0, 1.0);
  }

  @override
  void initState() {
    super.initState();

    // ── Fill Animation ─────────────────────────
    _fillCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fillAnim = Tween<double>(
      begin: 0,
      end: normalizedValue,
    ).animate(
      CurvedAnimation(
        parent: _fillCtrl,
        curve: Curves.easeOutCubic,
      ),
    );

    // ── Pulse Animation ────────────────────────
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);

    _pulseAnim = Tween<double>(begin: 0.92, end: 1.08).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );

    _glowAnim = Tween<double>(begin: 6, end: 18).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );

    // ✅ Start animation AFTER build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _fillCtrl.forward();
    });
  }

  // ✅ VERY IMPORTANT (fix for rebuild issue)
  @override
  void didUpdateWidget(covariant AnimatedRing oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.confidence != widget.confidence) {
      _fillCtrl.reset();

      _fillAnim = Tween<double>(
        begin: 0,
        end: normalizedValue,
      ).animate(
        CurvedAnimation(
          parent: _fillCtrl,
          curve: Curves.easeOutCubic,
        ),
      );

      _fillCtrl.forward();
    }
  }

  @override
  void dispose() {
    _fillCtrl.dispose();
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_fillAnim, _pulseAnim, _glowAnim]),
      builder: (_, __) {
        return Transform.scale(
          scale: _pulseAnim.value,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // 🔥 Glow Effect
              Container(
                width: 74,
                height: 74,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: widget.color.withOpacity(0.35),
                      blurRadius: _glowAnim.value,
                    ),
                  ],
                ),
              ),

              // ── Background Ring ─────────────────
              SizedBox(
                width: 64,
                height: 64,
                child: CircularProgressIndicator(
                  value: 1,
                  strokeWidth: 5,
                  valueColor: AlwaysStoppedAnimation(
                    widget.color.withOpacity(0.12),
                  ),
                ),
              ),

              // ── Animated Progress ───────────────
              SizedBox(
                width: 64,
                height: 64,
                child: CircularProgressIndicator(
                  value: _fillAnim.value,
                  strokeWidth: 5,
                  strokeCap: StrokeCap.round,
                  valueColor: AlwaysStoppedAnimation(widget.color),
                ),
              ),

              // ── Center Text ─────────────────────
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "${(_fillAnim.value * 100).toStringAsFixed(0)}%",
                    style: TextStyle(
                      color: widget.color,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    "conf.",
                    style: TextStyle(
                      color: Color(0xFF6B7FA3),
                      fontSize: 8,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}