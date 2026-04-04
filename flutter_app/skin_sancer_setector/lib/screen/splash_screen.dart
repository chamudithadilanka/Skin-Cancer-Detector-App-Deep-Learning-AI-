import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:skin_sancer_setector/screen/main_screen_with_navigation.dart';

// ─── Theme ───────────────────────────────────────────────────────────────────
class _C {
  static const bg       = Color(0xFF060D1F);
  static const card     = Color(0xFF111D35);
  static const border   = Color(0xFF1E2D50);
  static const blue     = Color(0xFF0038E3);
  static const blueMid  = Color(0xFF2D6AFF);
  static const cyan     = Color(0xFF00C6FF);
  static const textPri  = Color(0xFFEAEEFF);
  static const textSub  = Color(0xFF6B7FA3);
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {

  // ── Controllers ────────────────────────────────────────────────────
  late AnimationController _orbitCtrl;    // spinning ring
  late AnimationController _pulseCtrl;    // logo glow pulse
  late AnimationController _revealCtrl;   // staggered content reveal
  late AnimationController _buttonCtrl;   // button bounce-in
  late AnimationController _particleCtrl; // floating particles
  late AnimationController _scanCtrl;     // scan line

  // ── Animations ─────────────────────────────────────────────────────
  late Animation<double> _orbitAnim;
  late Animation<double> _pulseAnim;
  late Animation<double> _logoFade;
  late Animation<double> _logoScale;
  late Animation<double> _tagFade;
  late Animation<Offset>  _tagSlide;
  late Animation<double> _titleFade;
  late Animation<Offset>  _titleSlide;
  late Animation<double> _subFade;
  late Animation<double> _dividerWidth;
  late Animation<double> _buttonFade;
  late Animation<double> _buttonScale;
  late Animation<double> _particleAnim;
  late Animation<double> _scanAnim;
  late Animation<double> _featureFade;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    _orbitCtrl    = AnimationController(vsync: this, duration: const Duration(seconds: 8))..repeat();
    _pulseCtrl    = AnimationController(vsync: this, duration: const Duration(milliseconds: 2000))..repeat(reverse: true);
    _revealCtrl   = AnimationController(vsync: this, duration: const Duration(milliseconds: 2200));
    _buttonCtrl   = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    _particleCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 6))..repeat();
    _scanCtrl     = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat();

    _orbitAnim    = Tween<double>(begin: 0, end: 2 * math.pi).animate(_orbitCtrl);
    _pulseAnim    = Tween<double>(begin: 0.7, end: 1.0).animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));
    _particleAnim = Tween<double>(begin: 0, end: 1).animate(_particleCtrl);
    _scanAnim     = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _scanCtrl, curve: Curves.easeInOut));

    // Staggered reveal
    _logoFade   = _interval(_revealCtrl, 0.0, 0.25);
    _logoScale  = Tween<double>(begin: 0.5, end: 1.0).animate(CurvedAnimation(parent: _revealCtrl, curve: const Interval(0.0, 0.3, curve: Curves.easeOutBack)));
    _tagFade    = _interval(_revealCtrl, 0.2, 0.4);
    _tagSlide   = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(CurvedAnimation(parent: _revealCtrl, curve: const Interval(0.2, 0.4, curve: Curves.easeOut)));
    _titleFade  = _interval(_revealCtrl, 0.3, 0.55);
    _titleSlide = Tween<Offset>(begin: const Offset(0, 0.4), end: Offset.zero).animate(CurvedAnimation(parent: _revealCtrl, curve: const Interval(0.3, 0.55, curve: Curves.easeOut)));
    _subFade    = _interval(_revealCtrl, 0.45, 0.65);
    _dividerWidth = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _revealCtrl, curve: const Interval(0.5, 0.7, curve: Curves.easeOut)));
    _featureFade  = _interval(_revealCtrl, 0.6, 0.8);
    _buttonFade = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _buttonCtrl, curve: Curves.easeOut));
    _buttonScale= Tween<double>(begin: 0.7, end: 1.0).animate(CurvedAnimation(parent: _buttonCtrl, curve: Curves.easeOutBack));

    // Start sequence
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _revealCtrl.forward().then((_) {
        Future.delayed(const Duration(milliseconds: 200), () {
          if (mounted) _buttonCtrl.forward();
        });
      });
    });
  }

  Animation<double> _interval(AnimationController ctrl, double begin, double end) {
    return Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: ctrl, curve: Interval(begin, end, curve: Curves.easeOut)),
    );
  }

  @override
  void dispose() {
    _orbitCtrl.dispose();
    _pulseCtrl.dispose();
    _revealCtrl.dispose();
    _buttonCtrl.dispose();
    _particleCtrl.dispose();
    _scanCtrl.dispose();
    super.dispose();
  }

  void _onStart() {
    HapticFeedback.heavyImpact();
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, a, __) => const MainScreenWithNavigation(),
        transitionsBuilder: (_, a, __, child) {
          return FadeTransition(
            opacity: CurvedAnimation(parent: a, curve: Curves.easeOut),
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.06),
                end: Offset.zero,
              ).animate(CurvedAnimation(parent: a, curve: Curves.easeOutCubic)),
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 600),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: _C.bg,
        body: AnimatedBuilder(
          animation: Listenable.merge([
            _orbitCtrl, _pulseCtrl, _revealCtrl,
            _buttonCtrl, _particleCtrl, _scanCtrl,
          ]),
          builder: (context, _) {
            return Stack(
              fit: StackFit.expand,
              children: [
                // ── Layer 1: Background ─────────────────────────────
                _buildBackground(size),

                // ── Layer 2: Floating particles ─────────────────────
                ..._buildParticles(size),

                // ── Layer 3: Main content ───────────────────────────
                SafeArea(
                  child: Column(
                    children: [
                      const Spacer(flex: 2),
                      _buildLogoSection(size),
                      const SizedBox(height: 36),
                      _buildTitleSection(),
                      const SizedBox(height: 32),
                      _buildDivider(),
                      const SizedBox(height: 28),
                      _buildFeatures(),
                      const Spacer(flex: 3),
                      _buildStartButton(size),
                      const SizedBox(height: 20),
                      _buildFooter(),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // ─── Background ──────────────────────────────────────────────────────
  Widget _buildBackground(Size size) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Radial glow top-center
        Positioned(
          top: -size.height * 0.15,
          left: size.width * 0.5 - 200,
          child: Container(
            width: 400, height: 400,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  _C.blue.withOpacity(0.25),
                  _C.blue.withOpacity(0.0),
                ],
              ),
            ),
          ),
        ),
        // Bottom cyan glow
        Positioned(
          bottom: -100,
          left: size.width * 0.5 - 180,
          child: Container(
            width: 360, height: 360,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  _C.cyan.withOpacity(0.1),
                  _C.cyan.withOpacity(0.0),
                ],
              ),
            ),
          ),
        ),
        // Grid overlay
        CustomPaint(
          painter: _GridPainter(),
          size: size,
        ),
      ],
    );
  }

  // ─── Particles ───────────────────────────────────────────────────────
  List<Widget> _buildParticles(Size size) {
    final rng = math.Random(42);
    return List.generate(18, (i) {
      final x = rng.nextDouble() * size.width;
      final y = rng.nextDouble() * size.height;
      final phase = rng.nextDouble();
      final sz = 1.5 + rng.nextDouble() * 3;
      final t = (_particleAnim.value + phase) % 1.0;
      final opacity = (math.sin(t * 2 * math.pi) * 0.5 + 0.5) * 0.6;
      final isBlue = i % 3 != 0;

      return Positioned(
        left: x,
        top: y - t * 80,
        child: Container(
          width: sz, height: sz,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: (isBlue ? _C.cyan : _C.blueMid).withOpacity(opacity),
            boxShadow: [
              BoxShadow(
                color: (isBlue ? _C.cyan : _C.blueMid).withOpacity(opacity * 0.8),
                blurRadius: 6,
              ),
            ],
          ),
        ),
      );
    });
  }

  // ─── Logo Section ────────────────────────────────────────────────────
  Widget _buildLogoSection(Size size) {
    return FadeTransition(
      opacity: _logoFade,
      child: Transform.scale(
        scale: _logoScale.value,
        child: SizedBox(
          width: 160, height: 160,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Outer orbit ring
              Transform.rotate(
                angle: _orbitAnim.value,
                child: CustomPaint(
                  size: const Size(160, 160),
                  painter: _OrbitPainter(),
                ),
              ),

              // Pulse glow ring
              Container(
                width: 110, height: 110,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: _C.blue.withOpacity(0.4 * _pulseAnim.value),
                      blurRadius: 40 * _pulseAnim.value,
                      spreadRadius: 4,
                    ),
                    BoxShadow(
                      color: _C.cyan.withOpacity(0.2 * _pulseAnim.value),
                      blurRadius: 60 * _pulseAnim.value,
                      spreadRadius: -4,
                    ),
                  ],
                ),
              ),

              // Main logo circle
              Container(
                width: 100, height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [_C.blue, _C.blueMid, _C.cyan],
                    stops: [0.0, 0.5, 1.0],
                  ),
                  border: Border.all(
                    color: _C.cyan.withOpacity(0.3), width: 1.5,
                  ),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Scan line over icon
                    Positioned(
                      top: _scanAnim.value * 80,
                      left: 10, right: 10,
                      child: Container(
                        height: 1.5,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              Colors.white.withOpacity(0.6),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.biotech_rounded,
                      color: Colors.white,
                      size: 44,
                    ),
                  ],
                ),
              ),

              // Orbit dot
              Transform.rotate(
                angle: _orbitAnim.value,
                child: Transform.translate(
                  offset: const Offset(0, -80),
                  child: Container(
                    width: 10, height: 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _C.cyan,
                      boxShadow: [
                        BoxShadow(
                          color: _C.cyan.withOpacity(0.8),
                          blurRadius: 12, spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Second orbit dot (opposite)
              Transform.rotate(
                angle: _orbitAnim.value + math.pi,
                child: Transform.translate(
                  offset: const Offset(0, -80),
                  child: Container(
                    width: 6, height: 6,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _C.blueMid.withOpacity(0.8),
                      boxShadow: [
                        BoxShadow(
                          color: _C.blueMid.withOpacity(0.6),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Title Section ───────────────────────────────────────────────────
  Widget _buildTitleSection() {
    return Column(
      children: [
        // App tag
        FadeTransition(
          opacity: _tagFade,
          child: SlideTransition(
            position: _tagSlide,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: _C.cyan.withOpacity(0.08),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: _C.cyan.withOpacity(0.25)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6, height: 6,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _C.cyan,
                      boxShadow: [BoxShadow(color: _C.cyan.withOpacity(0.8), blurRadius: 6)],
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text("AI-Powered Dermatology",
                      style: TextStyle(
                        color: _C.cyan, fontSize: 12,
                        fontWeight: FontWeight.w600, letterSpacing: 0.5,
                      )),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(height: 18),

        // App name
        FadeTransition(
          opacity: _titleFade,
          child: SlideTransition(
            position: _titleSlide,
            child: ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [_C.textPri, _C.cyan],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds),
              child: const Text(
                "DermScan",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 52,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -2,
                  height: 1,
                ),
              ),
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Subtitle
        FadeTransition(
          opacity: _subFade,
          child: const Text(
            "Early skin cancer detection\npowered by deep learning",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _C.textSub,
              fontSize: 15,
              height: 1.6,
              letterSpacing: 0.1,
            ),
          ),
        ),
      ],
    );
  }

  // ─── Divider ─────────────────────────────────────────────────────────
  Widget _buildDivider() {
    return FractionallySizedBox(
      widthFactor: _dividerWidth.value,
      child: Container(
        height: 1,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.transparent,
              _C.border,
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }

  // ─── Feature Pills ────────────────────────────────────────────────────
  Widget _buildFeatures() {
    final items = [
      (Icons.verified_rounded,         "94.7% Accuracy"),
      (Icons.flash_on_rounded,          "< 3s Results"),
      (Icons.category_rounded,          "7 Conditions"),
    ];

    return FadeTransition(
      opacity: _featureFade,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: items.asMap().entries.map((e) {
          final i    = e.key;
          final item = e.value;
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (i > 0)
                Container(
                  width: 1, height: 20,
                  color: _C.border,
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(item.$1, color: _C.cyan, size: 14),
                  const SizedBox(width: 6),
                  Text(item.$2,
                      style: const TextStyle(
                        color: _C.textSub, fontSize: 12,
                        fontWeight: FontWeight.w500,
                      )),
                ],
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  // ─── Start Button ─────────────────────────────────────────────────────
  Widget _buildStartButton(Size size) {
    return FadeTransition(
      opacity: _buttonFade,
      child: Transform.scale(
        scale: _buttonScale.value,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: _StartButton(onTap: _onStart),
        ),
      ),
    );
  }

  // ─── Footer ───────────────────────────────────────────────────────────
  Widget _buildFooter() {
    return FadeTransition(
      opacity: _buttonFade,
      child: Text(
        "For educational purposes only · Not medical advice",
        style: TextStyle(
          color: _C.textSub.withOpacity(0.5),
          fontSize: 10.5,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

// ─── Start Button ─────────────────────────────────────────────────────────────
class _StartButton extends StatefulWidget {
  final VoidCallback onTap;
  const _StartButton({required this.onTap});

  @override
  State<_StartButton> createState() => _StartButtonState();
}

class _StartButtonState extends State<_StartButton>
    with TickerProviderStateMixin {
  late AnimationController _pressCtrl;
  late AnimationController _shimmerCtrl;
  late AnimationController _pulseCtrl;
  late Animation<double> _scaleAnim;
  late Animation<double> _shimmerAnim;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _pressCtrl  = AnimationController(vsync: this, duration: const Duration(milliseconds: 150));
    _shimmerCtrl= AnimationController(vsync: this, duration: const Duration(milliseconds: 1800))..repeat();
    _pulseCtrl  = AnimationController(vsync: this, duration: const Duration(milliseconds: 2000))..repeat(reverse: true);

    _scaleAnim  = Tween<double>(begin: 1.0, end: 0.96).animate(CurvedAnimation(parent: _pressCtrl, curve: Curves.easeInOut));
    _shimmerAnim= Tween<double>(begin: -1.5, end: 2.5).animate(CurvedAnimation(parent: _shimmerCtrl, curve: Curves.linear));
    _pulseAnim  = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _pressCtrl.dispose();
    _shimmerCtrl.dispose();
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_pressCtrl, _shimmerCtrl, _pulseCtrl]),
      builder: (_, __) {
        return GestureDetector(
          onTapDown: (_) => _pressCtrl.forward(),
          onTapUp:   (_) { _pressCtrl.reverse(); widget.onTap(); },
          onTapCancel: () => _pressCtrl.reverse(),
          child: Transform.scale(
            scale: _scaleAnim.value,
            child: Container(
              width: double.infinity,
              height: 64,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF0038E3), Color(0xFF2D6AFF), Color(0xFF00C6FF)],
                  stops: [0.0, 0.55, 1.0],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0038E3).withOpacity(0.5),
                    blurRadius: 28 + _pulseAnim.value * 12,
                    spreadRadius: -2,
                    offset: const Offset(0, 10),
                  ),
                  BoxShadow(
                    color: const Color(0xFF00C6FF).withOpacity(0.2 + _pulseAnim.value * 0.1),
                    blurRadius: 40,
                    spreadRadius: -6,
                    offset: const Offset(0, 18),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Shimmer sweep
                    Positioned.fill(
                      child: Transform.translate(
                        offset: Offset(
                          _shimmerAnim.value * MediaQuery.of(context).size.width,
                          0,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.white.withOpacity(0.0),
                                Colors.white.withOpacity(0.18),
                                Colors.white.withOpacity(0.0),
                              ],
                              stops: const [0.3, 0.5, 0.7],
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Top glint
                    Positioned(
                      top: 0, left: 30, right: 30,
                      child: Container(
                        height: 1,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.white.withOpacity(0),
                              Colors.white.withOpacity(0.4),
                              Colors.white.withOpacity(0),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Label
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.18),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.arrow_forward_rounded,
                            color: Colors.white, size: 20,
                          ),
                        ),
                        const SizedBox(width: 14),
                        const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Get Started",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.3,
                                  height: 1,
                                )),
                            SizedBox(height: 3),
                            Text("Begin your skin analysis",
                                style: TextStyle(
                                  color: Colors.white60,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 0.1,
                                )),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// ─── Orbit Ring Painter ───────────────────────────────────────────────────────
class _OrbitPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 4;

    // Dashed orbit ring
    final paint = Paint()
      ..color = const Color(0xFF1E2D50)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    // Draw dashed circle
    const dashCount = 32;
    const dashAngle = 2 * math.pi / dashCount;
    for (int i = 0; i < dashCount; i++) {
      if (i % 2 == 0) continue;
      final startAngle = i * dashAngle;
      final endAngle   = startAngle + dashAngle * 0.6;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle, endAngle - startAngle, false, paint,
      );
    }

    // Glowing arc segment
    final glowPaint = Paint()
      ..shader = SweepGradient(
        colors: [
          const Color(0xFF00C6FF).withOpacity(0),
          const Color(0xFF00C6FF).withOpacity(0.8),
          const Color(0xFF00C6FF).withOpacity(0),
        ],
        stops: const [0.0, 0.15, 0.35],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2, math.pi * 0.7, false, glowPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter _) => true;
}

// ─── Grid Painter ─────────────────────────────────────────────────────────────
class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = const Color(0xFF1E2D50).withOpacity(0.35)
      ..strokeWidth = 0.5;

    const step = 36.0;
    for (double x = 0; x <= size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), p);
    }
    for (double y = 0; y <= size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), p);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter _) => false;
}