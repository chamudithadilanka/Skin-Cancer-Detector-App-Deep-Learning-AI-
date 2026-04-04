import 'dart:io';
import 'package:flutter/material.dart';
import 'package:skin_sancer_setector/theme/themes.dart';
import 'package:skin_sancer_setector/widgets/animated_ring.dart';
import '../model/prediction_response.dart';
import '../model/recent_prediction.dart';
import '../service/prediction_history_service.dart';
import '../widgets/prediction_card.dart';
import '../widgets/section_card.dart';
import '../widgets/top3_card.dart';

const double _kConfidenceThreshold = 50.0;

// ─── Theme Constants ──────────────────────────────────────────────────────────
class _C {
  static const bg = Color(0xFF060D1F);
  static const surface = Color(0xFF0D1830);
  static const card = Color(0xFF111D35);
  static const border = Color(0xFF1E2D50);
  static const blue = Color(0xFF0038E3);
  static const blueMid = Color(0xFF2D6AFF);
  static const cyan = Color(0xFF00C6FF);
  static const textPrimary = Color(0xFFEAEEFF);
  static const textSub = Color(0xFF6B7FA3);
  static const orange = Color(0xFFFF8C42);
  static const red = Color(0xFFFF4D6D);
  static const green = Color(0xFF00E5A0);
}

class ResultScreen extends StatefulWidget {
  final File? imageFile;
  final PredictionResponse? response;

  const ResultScreen({super.key, this.imageFile, this.response});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen>
    with TickerProviderStateMixin {
  bool _saved = false;

  late AnimationController _fadeCtrl;
  late AnimationController _slideCtrl;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  bool get _isUnknown {
    if (widget.response == null) return false;
    return widget.response!.prediction.confidence < _kConfidenceThreshold;
  }

  @override
  void initState() {
    super.initState();

    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();

    _slideCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..forward();

    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideCtrl, curve: Curves.easeOutCubic));

    if (!_isUnknown) _autoSave();
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    _slideCtrl.dispose();
    super.dispose();
  }

  Future<void> _autoSave() async {
    if (widget.response == null || widget.imageFile == null) return;
    final p = widget.response!.prediction;
    await PredictionHistoryService.save(
      RecentPrediction(
        imagePath: widget.imageFile!.path,
        predictionLabel: p.riskLabel,
        confidence: p.confidence,
        savedAt: DateTime.now(),
      ),
    );
    if (mounted) setState(() => _saved = true);
  }

  // ─── Helpers ──────────────────────────────────────────────────────────────
  Widget _bullet(String text, {Color color = _C.textSub}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 7),
            width: 5,
            height: 5,
            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 13.5, color: color, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionCard({
    required String title,
    required Widget child,
    Color? accentColor,
    IconData? icon,
  }) {
    final accent = accentColor ?? _C.blueMid;
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: _C.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _C.border, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: accent.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: _C.border, width: 1)),
            ),
            child: Row(
              children: [
                if (icon != null) ...[
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: accent.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(icon, color: accent, size: 15),
                  ),
                  const SizedBox(width: 10),
                ],
                Text(
                  title,
                  style: TextStyle(
                    color: accent,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          // Body
          Padding(padding: const EdgeInsets.all(16), child: child),
        ],
      ),
    );
  }

  // ─── Image Hero ────────────────────────────────────────────────────────────
  Widget _buildImageHero() {
    final prediction = widget.response!.prediction;

    Color riskColor(String riskLabel) {
      final r = riskLabel.toLowerCase();
      if (r.contains('high') || r.contains('malignant') || r.contains('urgent'))
        return _C.red;
      if (r.contains('medium') || r.contains('moderate') || r.contains('monitor'))
        return _C.orange;
      return _C.green;
    }

    final rColor = riskColor(prediction.riskLabel);
    final rIcon  = rColor == _C.red
        ? Icons.warning_rounded
        : rColor == _C.orange
        ? Icons.info_rounded
        : Icons.check_circle_rounded;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // ── Main image ──────────────────────────────────────────────────
        Container(
          height: 360,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: _C.border, width: 1.5),
            color: _C.card,
            boxShadow: [
              BoxShadow(
                color: rColor.withOpacity(0.18),
                blurRadius: 30, spreadRadius: -4,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: widget.imageFile != null
                ? Image.file(widget.imageFile!, fit: BoxFit.cover)
                : const Icon(Icons.image_not_supported, size: 60, color: _C.textSub),
          ),
        ),

        // ── Top fade ────────────────────────────────────────────────────
        Positioned(
          top: 0, left: 0, right: 0,
          child: Container(
            height: 80,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [_C.bg.withOpacity(0.7), Colors.transparent],
              ),
            ),
          ),
        ),

        // ── Bottom fade ─────────────────────────────────────────────────
        Positioned(
          bottom: 0, left: 0, right: 0,
          child: Container(
            height: 170,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  _C.bg.withOpacity(0.97),
                  _C.bg.withOpacity(0.6),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),

        // ── Saved badge ─────────────────────────────────────────────────
        if (_saved && !_isUnknown)
          Positioned(
            top: 14, right: 14,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _C.green.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: _C.green.withOpacity(0.4)),
                boxShadow: [
                  BoxShadow(color: _C.green.withOpacity(0.2), blurRadius: 10),
                ],
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.check_circle_rounded, color: _C.green, size: 14),
                const SizedBox(width: 6),
                Text("Saved", style: TextStyle(
                  color: _C.green, fontSize: 12, fontWeight: FontWeight.w600,
                )),
              ]),
            ),
          ),

        // ── Floating info card ──────────────────────────────────────────
        Positioned(
          bottom: 16, left: 16, right: 16,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _C.card.withOpacity(0.9),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: rColor.withOpacity(0.35), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: rColor.withOpacity(0.15),
                  blurRadius: 20, offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                // ── Left: name + chip ─────────────────────────────────
                Expanded(                                   // ← FIX: Expanded prevents overflow
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Disease name — clipped with ellipsis if too long
                      Text(
                        prediction.name,
                        maxLines: 2,                        // ← FIX: allow wrap, not overflow
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 18,
                          color: _C.textPrimary,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.3,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Risk chip — intrinsic width, won't push layout
                      IntrinsicWidth(                        // ← FIX: chip only as wide as it needs
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: rColor.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: rColor.withOpacity(0.3)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min, // ← FIX: don't expand row
                            children: [
                              Icon(rIcon, size: 11, color: rColor),
                              const SizedBox(width: 5),
                              Flexible(                     // ← FIX: chip text wraps gracefully
                                child: Text(
                                  prediction.riskLabel,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: rColor,
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 14),

                // ── Right: animated confidence ring ───────────────────
                AnimatedRing(
                  confidence: prediction.confidence,
                  color: rColor,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ─── Unknown Body ──────────────────────────────────────────────────────────
  Widget _buildUnknownBody() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
      child: Column(
        children: [

          // ❌ REMOVED HERO SECTION HERE

          const SizedBox(height: 10),

          // Unknown state card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: _C.card,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: _C.orange.withOpacity(0.3), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: _C.orange.withOpacity(0.1),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _C.orange.withOpacity(0.1),
                    border: Border.all(
                      color: _C.orange.withOpacity(0.3),
                      width: 1.5,
                    ),
                  ),
                  child: const Icon(
                    Icons.help_outline_rounded,
                    size: 38,
                    color: _C.orange,
                  ),
                ),
                const SizedBox(height: 18),

                const Text(
                  "Image Not Recognised",
                  style: TextStyle(
                    color: _C.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 10),

                if (widget.response != null)
                  Text(
                    "Confidence: ${widget.response!.prediction.confidence.toStringAsFixed(1)}%",
                    style: TextStyle(
                      color: _C.orange,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                const SizedBox(height: 14),

                Text(
                  "Please try again with a clearer skin image.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _C.textSub,
                    fontSize: 13.5,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          _buildPrimaryButton(
            label: "Try Again",
            icon: Icons.camera_alt_rounded,
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  // ─── Result Body ───────────────────────────────────────────────────────────
  Widget _buildResultBody() {
    final prediction = widget.response!.prediction;
    final doctorAdvice = widget.response!.doctorAdvice;
    final diseaseInfo = widget.response!.diseaseInfo;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
      child: Column(
        children: [
          _buildImageHero(),
          const SizedBox(height: 20),

          // Prediction card (keep your existing widget, themed via ThemeData)
          // PredictionCard(prediction: prediction),
          const SizedBox(height: 14),

          // Top 3
          if (widget.response!.top3.isNotEmpty)
            _sectionCard(
              title: "TOP 3 PREDICTIONS",
              icon: Icons.bar_chart_rounded,
              accentColor: _C.blueMid,
              child: Top3Card(top3: widget.response!.top3),
            ),

          // What is it
          if (diseaseInfo != null && diseaseInfo.whatIsIt.isNotEmpty)
            _sectionCard(
              title: "WHAT IS IT?",
              icon: Icons.info_outline_rounded,
              accentColor: _C.cyan,
              child: Text(
                diseaseInfo.whatIsIt,
                style: const TextStyle(
                  color: _C.textSub,
                  fontSize: 13.5,
                  height: 1.65,
                ),
              ),
            ),

          // Symptoms
          if (diseaseInfo != null && diseaseInfo.symptoms.isNotEmpty)
            _sectionCard(
              title: "SYMPTOMS",
              icon: Icons.monitor_heart_rounded,
              accentColor: _C.orange,
              child: Column(
                children:
                    diseaseInfo.symptoms
                        .map((s) => _bullet(s, color: _C.textSub))
                        .toList(),
              ),
            ),

          // Home care
          if (diseaseInfo != null && diseaseInfo.homeCare.isNotEmpty)
            _sectionCard(
              title: "HOME CARE",
              icon: Icons.home_outlined,
              accentColor: _C.green,
              child: Column(
                children:
                    diseaseInfo.homeCare
                        .map((s) => _bullet(s, color: _C.textSub))
                        .toList(),
              ),
            ),

          // Doctor advice
          if (doctorAdvice != null)
            _sectionCard(
              title: "DOCTOR ADVICE",
              icon: Icons.local_hospital_rounded,
              accentColor: _C.blueMid,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (doctorAdvice.specialist.isNotEmpty)
                    _infoRow(
                      Icons.person_outline_rounded,
                      "Specialist",
                      doctorAdvice.specialist,
                    ),
                  if (doctorAdvice.urgency.isNotEmpty)
                    _infoRow(
                      Icons.timer_outlined,
                      "Urgency",
                      doctorAdvice.urgency,
                      valueColor: _urgencyColor(doctorAdvice.urgency),
                    ),
                  if (doctorAdvice.whatToSay.isNotEmpty)
                    _infoRow(
                      Icons.chat_bubble_outline_rounded,
                      "What to say",
                      doctorAdvice.whatToSay,
                    ),
                ],
              ),
            ),

          if (doctorAdvice != null && doctorAdvice.testsExpect.isNotEmpty)
            _sectionCard(
              title: "EXPECTED TESTS",
              icon: Icons.science_outlined,
              accentColor: _C.cyan,
              child: Column(
                children:
                    doctorAdvice.testsExpect.map((s) => _bullet(s)).toList(),
              ),
            ),

          if (doctorAdvice != null && doctorAdvice.questionsToAsk.isNotEmpty)
            _sectionCard(
              title: "QUESTIONS TO ASK",
              icon: Icons.quiz_outlined,
              accentColor: _C.cyan,
              child: Column(
                children:
                    doctorAdvice.questionsToAsk.map((s) => _bullet(s)).toList(),
              ),
            ),

          // Emergency signs
          if (widget.response!.emergencySigns.isNotEmpty)
            _sectionCard(
              title: "EMERGENCY SIGNS",
              icon: Icons.emergency_rounded,
              accentColor: _C.red,
              child: Column(
                children:
                    widget.response!.emergencySigns
                        .map((s) => _bullet(s, color: _C.red.withOpacity(0.85)))
                        .toList(),
              ),
            ),

          // Disclaimer
          if (widget.response!.disclaimer.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(bottom: 14),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: _C.red.withOpacity(0.07),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _C.red.withOpacity(0.2)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline_rounded, color: _C.red, size: 16),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      widget.response!.disclaimer,
                      style: TextStyle(
                        color: _C.red.withOpacity(0.85),
                        fontSize: 12,
                        height: 1.55,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          _buildPrimaryButton(
            label: "Scan Another Image",
            icon: Icons.camera_alt_rounded,
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  // ─── Shared Widgets ────────────────────────────────────────────────────────
  Widget _infoRow(
    IconData icon,
    String label,
    String value, {
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: _C.textSub),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: _C.textSub,
                    fontSize: 11,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: TextStyle(
                    color: valueColor ?? _C.textPrimary,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _urgencyColor(String urgency) {
    final u = urgency.toLowerCase();
    if (u.contains('high') || u.contains('urgent') || u.contains('immediate'))
      return _C.red;
    if (u.contains('medium') || u.contains('moderate')) return _C.orange;
    return _C.green;
  }

  Widget _buildPrimaryButton({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 58,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: const LinearGradient(
            colors: [_C.blue, _C.blueMid, _C.cyan],
            stops: [0.0, 0.55, 1.0],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: _C.blue.withOpacity(0.4),
              blurRadius: 20,
              spreadRadius: -2,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── AppBar ────────────────────────────────────────────────────────────────
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: _C.bg,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      leading: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: _C.card,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _C.border),
          ),
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: _C.textPrimary,
            size: 16,
          ),
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Scan Result",
            style: TextStyle(
              color: _C.textPrimary,
              fontSize: 17,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.2,
            ),
          ),
          Text(
            _isUnknown ? "Low confidence" : "AI analysis complete",
            style: const TextStyle(color: _C.textSub, fontSize: 11.5),
          ),
        ],
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: _C.border),
      ),
    );
  }

  // ─── BUILD ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    if (widget.response == null) {
      return Scaffold(
        backgroundColor: _C.bg,
        appBar: _buildAppBar(),
        body: Center(
          child: Text(
            "No prediction data available.",
            style: TextStyle(fontSize: 16, color: _C.textSub),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: _C.bg,
      appBar: _buildAppBar(),
      body: FadeTransition(
        opacity: _fadeAnim,
        child: SlideTransition(
          position: _slideAnim,
          child: _isUnknown ? _buildUnknownBody() : _buildResultBody(),
        ),
      ),
    );
  }
}
