import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skin_sancer_setector/screen/result_screen.dart';
import '../model/prediction_response.dart';
import '../service/prediction_service.dart';
import '../widgets/analyze_button.dart';
import '../widgets/image_source_button.dart';

// ─── Theme Constants ────────────────────────────────────────────────
class _C {
  static const bg          = Color(0xFF060D1F);
  static const surface     = Color(0xFF0D1830);
  static const card        = Color(0xFF111D35);
  static const blue        = Color(0xFF0038E3);
  static const blueMid     = Color(0xFF2D6AFF);
  static const cyan        = Color(0xFF00C6FF);
  static const blueGlow    = Color(0xFF1A4FFF);
  static const textPrimary = Color(0xFFEAEEFF);
  static const textSub     = Color(0xFF6B7FA3);
  static const border      = Color(0xFF1E2D50);
}

// ─── Home Screen ────────────────────────────────────────────────────
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final ImagePicker _picker       = ImagePicker();
  final PredictionService _svc    = PredictionService();

  File? _selectedImage;
  bool  _isLoading = false;

  late AnimationController _scanController;
  late AnimationController _fadeController;
  late AnimationController _pulseController;
  late Animation<double>   _scanAnim;
  late Animation<double>   _fadeAnim;
  late Animation<double>   _pulseAnim;

  @override
  void initState() {
    super.initState();

    _scanController = AnimationController(
      vsync: this, duration: const Duration(seconds: 3),
    )..repeat();

    _fadeController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 700),
    )..forward();

    _pulseController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);

    _scanAnim  = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _scanController, curve: Curves.easeInOut));
    _fadeAnim  = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));
    _pulseAnim = Tween<double>(begin: 0.85, end: 1.0)
        .animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _scanController.dispose();
    _fadeController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? f = await _picker.pickImage(source: source, imageQuality: 90);
    if (f != null) {
      _fadeController
        ..reset()
        ..forward();
      setState(() => _selectedImage = File(f.path));
    }
  }

  Future<void> _predictImage() async {
    if (_selectedImage == null) return;
    setState(() => _isLoading = true);
    try {
      final PredictionResponse r = await _svc.predictImage(_selectedImage!);
      if (!mounted) return;
      Navigator.push(context, _slideRoute(
        ResultScreen(imageFile: _selectedImage!, response: r),
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Prediction failed: $e"),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  PageRoute _slideRoute(Widget page) => PageRouteBuilder(
    pageBuilder: (_, a, __) => page,
    transitionsBuilder: (_, a, __, child) => SlideTransition(
      position: Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero)
          .animate(CurvedAnimation(parent: a, curve: Curves.easeOutCubic)),
      child: FadeTransition(opacity: a, child: child),
    ),
    transitionDuration: const Duration(milliseconds: 420),
  );

  // ─── BUILD ──────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _C.bg,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildAppBar(),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildHeroText(),
                const SizedBox(height: 25),
                _buildScanCard(),
                const SizedBox(height: 25),
                _buildSourceButtons(),
                const SizedBox(height: 25),
                _buildAnalyzeButton(),
                const SizedBox(height:30),
                _buildStatsRow(),
                const SizedBox(height: 20),
                _buildDisclaimer(),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  // ─── APP BAR ────────────────────────────────────────────────────────
  Widget _buildAppBar() {
    return SliverAppBar(
      backgroundColor: _C.bg,
      expandedHeight: 0,
      floating: true,
      pinned: true,
      elevation: 0,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          color: _C.bg,
          border: Border(
            bottom: BorderSide(color: _C.border, width: 1),
          ),
        ),
      ),
      leading: Padding(
        padding: const EdgeInsets.only(left: 20, top: 8, bottom: 8),
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [_C.blue, _C.blueMid],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.biotech_rounded, color: Colors.white, size: 22),
        ),
      ),
      title: const Text(
        "DermScan",
        style: TextStyle(
          color: _C.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
      actions: [
        _buildAIBadge(),
        const SizedBox(width: 12),
        _buildNotifButton(),
        const SizedBox(width: 16),
      ],
    );
  }

  Widget _buildAIBadge() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (_, __) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _C.cyan.withOpacity(0.4 * _pulseAnim.value),
            width: 1,
          ),
          color: _C.cyan.withOpacity(0.08),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 6, height: 6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _C.cyan.withOpacity(_pulseAnim.value),
                boxShadow: [
                  BoxShadow(color: _C.cyan.withOpacity(0.6), blurRadius: 6),
                ],
              ),
            ),
            const SizedBox(width: 6),
            const Text(
              "AI Ready",
              style: TextStyle(
                color: _C.cyan, fontSize: 11,
                fontWeight: FontWeight.w600, letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotifButton() {
    return Container(
      width: 38, height: 38,
      decoration: BoxDecoration(
        color: _C.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _C.border),
      ),
      child: const Icon(Icons.notifications_none_rounded, color: _C.textSub, size: 20),
    );
  }

  // ─── HERO TEXT ──────────────────────────────────────────────────────
  Widget _buildHeroText() {
    return Padding(
      padding: const EdgeInsets.only(top: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Your Skin,",
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w800,
              color: _C.textPrimary,
              height: 1.1,
              letterSpacing: -1,
            ),
          ),
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [_C.blue, _C.cyan],
            ).createShader(bounds),
            child: const Text(
              "Understood.",
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                height: 1.1,
                letterSpacing: -1,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "AI-powered early skin cancer detection Upload dermoscopic images to improve diagnostic accuracy",
            softWrap: true,
            style: TextStyle(
              fontSize: 14,
              color: _C.textSub,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }

  // ─── SCAN CARD ──────────────────────────────────────────────────────
  Widget _buildScanCard() {
    return Container(
      height: 290,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: _C.border, width: 1.5),
        color: _C.card,
        boxShadow: [
          BoxShadow(
            color: _C.blue.withOpacity(0.12),
            blurRadius: 30,
            spreadRadius: -4,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: _selectedImage != null
            ? _buildImagePreview()
            : _buildEmptyState(),
      ),
    );
  }

  Widget _buildImagePreview() {
    return FadeTransition(
      opacity: _fadeAnim,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.file(_selectedImage!, fit: BoxFit.cover),
          // Dark overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.45),
                ],
              ),
            ),
          ),
          // Scan line animation
          AnimatedBuilder(
            animation: _scanAnim,
            builder: (_, __) => Positioned(
              top: _scanAnim.value * 250,
              left: 0, right: 0,
              child: Container(
                height: 2,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      _C.cyan.withOpacity(0.8),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Corner brackets
          ..._buildCornerBrackets(),
          // Bottom label
          Positioned(
            bottom: 14, left: 14,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.55),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.12)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6, height: 6,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _C.cyan,
                      boxShadow: [BoxShadow(color: _C.cyan.withOpacity(0.6), blurRadius: 4)],
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    "Image loaded · Ready to scan",
                    style: TextStyle(color: Colors.white70, fontSize: 11.5),
                  ),
                ],
              ),
            ),
          ),
          // Remove button
          Positioned(
            top: 12, right: 12,
            child: GestureDetector(
              onTap: () => setState(() => _selectedImage = null),
              child: Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withOpacity(0.15)),
                ),
                child: const Icon(Icons.close_rounded, color: Colors.white, size: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildCornerBrackets() {
    const color = _C.cyan;
    const size  = 22.0;
    const thick = 2.5;

    Widget bracket(AlignmentGeometry align, double rx, double ry) {
      return Positioned.fill(
        child: Align(
          alignment: align,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: SizedBox(
              width: size, height: size,
              child: CustomPaint(painter: _BracketPainter(rx, ry, color, thick)),
            ),
          ),
        ),
      );
    }

    return [
      bracket(Alignment.topLeft,     1, 1),
      bracket(Alignment.topRight,   -1, 1),
      bracket(Alignment.bottomLeft,  1,-1),
      bracket(Alignment.bottomRight,-1,-1),
    ];
  }

  Widget _buildEmptyState() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (_, __) => Stack(
        fit: StackFit.expand,
        children: [
          // Grid pattern
          CustomPaint(painter: _GridPainter()),
          // Center content
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Transform.scale(
                  scale: _pulseAnim.value,
                  child: Container(
                    width: 80, height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _C.blueMid.withOpacity(0.4), width: 1.5,
                      ),
                      color: _C.blue.withOpacity(0.08),
                    ),
                    child: Container(
                      margin: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [_C.blue, _C.blueMid],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: _C.blue.withOpacity(0.5),
                            blurRadius: 20,
                            spreadRadius: -2,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.add_photo_alternate_rounded,
                        color: Colors.white, size: 26,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  "Upload Skin Image",
                  style: TextStyle(
                    color: _C.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Camera or gallery · High res preferred",
                  style: TextStyle(
                    color: _C.textSub, fontSize: 12.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── SOURCE BUTTONS ─────────────────────────────────────────────────
  Widget _buildSourceButtons() {
    return Row(
      children: [
        Expanded(child: _SourceTile(
          label: "Camera",
          sub: "Take photo",
          icon: Icons.camera_alt_rounded,
          onTap: () => _pickImage(ImageSource.camera),
        )),
        const SizedBox(width: 12),
        Expanded(child: _SourceTile(
          label: "Gallery",
          sub: "Browse files",
          icon: Icons.photo_library_rounded,
          onTap: () => _pickImage(ImageSource.gallery),
        )),
      ],
    );
  }

  // ─── ANALYZE BUTTON ─────────────────────────────────────────────────
  Widget _buildAnalyzeButton() {
    return AnalyzeButton(isLoading: _isLoading, onPressed: _predictImage,isDisabled: _selectedImage == null, );
  }

  // ─── STATS ROW ──────────────────────────────────────────────────────
  Widget _buildStatsRow() {
    return Row(
      children: [
        _StatChip(icon: Icons.verified_rounded,   label: "94.7%", sub: "Accuracy"),
        const SizedBox(width: 10),
        _StatChip(icon: Icons.bolt_rounded,        label: "< 3s",  sub: "Analysis"),
        const SizedBox(width: 10),
        _StatChip(icon: Icons.category_rounded,    label: "7",      sub: "Conditions"),
      ],
    );
  }

  // ─── DISCLAIMER ─────────────────────────────────────────────────────
  Widget _buildDisclaimer() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.redAccent.withOpacity(0.07),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.redAccent.withOpacity(0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline_rounded, color: Colors.redAccent, size: 16),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              "For educational purposes only. Not a substitute for professional medical diagnosis.",
              style: TextStyle(
                color: Colors.redAccent,
                fontSize: 12,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Source Tile ────────────────────────────────────────────────────
class _SourceTile extends StatefulWidget {
  final String label, sub;
  final IconData icon;
  final VoidCallback onTap;

  const _SourceTile({
    required this.label, required this.sub,
    required this.icon,  required this.onTap,
  });

  @override
  State<_SourceTile> createState() => _SourceTileState();
}

class _SourceTileState extends State<_SourceTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl  = AnimationController(vsync: this, duration: const Duration(milliseconds: 140));
    _scale = Tween<double>(begin: 1, end: 0.95).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown:   (_) => _ctrl.forward(),
      onTapUp:     (_) { _ctrl.reverse(); widget.onTap(); },
      onTapCancel: ()  => _ctrl.reverse(),
      child: AnimatedBuilder(
        animation: _scale,
        builder: (_, __) => Transform.scale(
          scale: _scale.value,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
            decoration: BoxDecoration(
              color: _C.card,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _C.border, width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: _C.blue.withOpacity(0.08),
                  blurRadius: 16, offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 42, height: 42,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [_C.blue, _C.blueMid],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(13),
                    boxShadow: [
                      BoxShadow(
                        color: _C.blue.withOpacity(0.35),
                        blurRadius: 10, offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(widget.icon, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.label,
                        style: const TextStyle(
                          color: _C.textPrimary, fontSize: 14,
                          fontWeight: FontWeight.w600,
                        )),
                    const SizedBox(height: 2),
                    Text(widget.sub,
                        style: const TextStyle(
                          color: _C.textSub, fontSize: 11.5,
                        )),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Stat Chip ──────────────────────────────────────────────────────
class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label, sub;

  const _StatChip({required this.icon, required this.label, required this.sub});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: _C.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _C.border),
        ),
        child: Column(
          children: [
            Icon(icon, color: _C.blueMid, size: 18),
            const SizedBox(height: 6),
            Text(label, style: const TextStyle(
              color: _C.textPrimary, fontSize: 14, fontWeight: FontWeight.w700,
            )),
            const SizedBox(height: 2),
            Text(sub, style: const TextStyle(
              color: _C.textSub, fontSize: 10.5,
            )),
          ],
        ),
      ),
    );
  }
}

// ─── Corner Bracket Painter ─────────────────────────────────────────
class _BracketPainter extends CustomPainter {
  final double sx, sy;
  final Color color;
  final double thickness;

  const _BracketPainter(this.sx, this.sy, this.color, this.thickness);

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = color
      ..strokeWidth = thickness
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final w = size.width;
    final h = size.height;

    if (sx > 0 && sy > 0) {
      canvas.drawLine(Offset(0, h * 0.5), Offset(0, 0), p);
      canvas.drawLine(Offset(0, 0), Offset(w * 0.5, 0), p);
    } else if (sx < 0 && sy > 0) {
      canvas.drawLine(Offset(w * 0.5, 0), Offset(w, 0), p);
      canvas.drawLine(Offset(w, 0), Offset(w, h * 0.5), p);
    } else if (sx > 0 && sy < 0) {
      canvas.drawLine(Offset(0, h * 0.5), Offset(0, h), p);
      canvas.drawLine(Offset(0, h), Offset(w * 0.5, h), p);
    } else {
      canvas.drawLine(Offset(w * 0.5, h), Offset(w, h), p);
      canvas.drawLine(Offset(w, h), Offset(w, h * 0.5), p);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter _) => false;
}

// ─── Grid Painter ───────────────────────────────────────────────────
class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = const Color(0xFF1E2D50).withOpacity(0.6)
      ..strokeWidth = 0.5;

    const step = 28.0;
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