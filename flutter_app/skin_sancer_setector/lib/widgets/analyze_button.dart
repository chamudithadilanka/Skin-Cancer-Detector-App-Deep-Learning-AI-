import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AnalyzeButton extends StatefulWidget {
  final bool isLoading;
  final bool isDisabled;          // ← NEW
  final VoidCallback onPressed;

  const AnalyzeButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
    this.isDisabled = false,       // ← default false so existing code won't break
  });

  @override
  State<AnalyzeButton> createState() => _AnalyzeButtonState();
}

class _AnalyzeButtonState extends State<AnalyzeButton>
    with TickerProviderStateMixin {

  late AnimationController _pulseController;
  late AnimationController _shimmerController;
  late AnimationController _shakeController;
  late Animation<double>   _pulseAnim;
  late Animation<double>   _shimmerAnim;
  late Animation<double>   _shakeAnim;

  // ── Colors ──────────────────────────────────────────────────────────
  static const _deepBlue   = Color(0xFF0038E3);
  static const _midBlue    = Color(0xFF2D6AFF);
  static const _cyan       = Color(0xFF00C6FF);
  static const _disabledBg = Color(0xFF111D35);
  static const _disabledBorder = Color(0xFF1E2D50);

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _shimmerController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 1600),
    )..repeat();

    _shakeController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 500),
    );

    _pulseAnim = Tween<double>(begin: 1.0, end: 1.03).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _shimmerAnim = Tween<double>(begin: -1.5, end: 2.5).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.linear),
    );

    // Shake: left → right oscillation
    _shakeAnim = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0,    end: -8),   weight: 1),
      TweenSequenceItem(tween: Tween(begin: -8,   end:  8),   weight: 2),
      TweenSequenceItem(tween: Tween(begin:  8,   end: -6),   weight: 2),
      TweenSequenceItem(tween: Tween(begin: -6,   end:  6),   weight: 2),
      TweenSequenceItem(tween: Tween(begin:  6,   end:  0),   weight: 1),
    ]).animate(CurvedAnimation(parent: _shakeController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _shimmerController.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (widget.isLoading) return;

    if (widget.isDisabled) {
      // Shake + haptic feedback to signal "you must select an image first"
      HapticFeedback.mediumImpact();
      _shakeController
        ..reset()
        ..forward();
      return;
    }

    HapticFeedback.lightImpact();
    widget.onPressed();
  }

  bool get _isActive => !widget.isLoading && !widget.isDisabled;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _pulseController,
        _shimmerController,
        _shakeController,
      ]),
      builder: (context, _) {
        return Transform.translate(
          // Shake horizontally when disabled tap
          offset: Offset(_shakeAnim.value, 0),
          child: Transform.scale(
            scale: _isActive ? _pulseAnim.value : 1.0,
            child: GestureDetector(
              onTap: _handleTap,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeInOut,
                width: double.infinity,
                height: 62,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),

                  // ── Background ──────────────────────────────────────
                  gradient: widget.isLoading
                      ? const LinearGradient(
                    colors: [Color(0xFF6B8CFF), Color(0xFF4D7CFF)],
                  )
                      : widget.isDisabled
                      ? null                          // solid color when disabled
                      : const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [_deepBlue, _midBlue, _cyan],
                    stops: [0.0, 0.55, 1.0],
                  ),

                  color: widget.isDisabled ? _disabledBg : null,

                  border: widget.isDisabled
                      ? Border.all(color: _disabledBorder, width: 1.5)
                      : null,

                  // ── Shadow ──────────────────────────────────────────
                  boxShadow: widget.isLoading || widget.isDisabled
                      ? []
                      : [
                    BoxShadow(
                      color: _deepBlue.withOpacity(0.45),
                      blurRadius: 22,
                      spreadRadius: -2,
                      offset: const Offset(0, 10),
                    ),
                    BoxShadow(
                      color: _cyan.withOpacity(0.2),
                      blurRadius: 30,
                      spreadRadius: -4,
                      offset: const Offset(0, 16),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [

                      // ── Shimmer (active idle only) ──────────────────
                      if (_isActive)
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
                                    Colors.white.withOpacity(0.12),
                                    Colors.white.withOpacity(0.0),
                                  ],
                                  stops: const [0.3, 0.5, 0.7],
                                ),
                              ),
                            ),
                          ),
                        ),

                      // ── Top highlight line ──────────────────────────
                      if (!widget.isDisabled)
                        Positioned(
                          top: 0, left: 24, right: 24,
                          child: Container(
                            height: 1,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.white.withOpacity(0.0),
                                  Colors.white.withOpacity(0.3),
                                  Colors.white.withOpacity(0.0),
                                ],
                              ),
                            ),
                          ),
                        ),

                      // ── Content ─────────────────────────────────────
                      widget.isLoading
                          ? _buildLoadingContent()
                          : widget.isDisabled
                          ? _buildDisabledContent()
                          : _buildIdleContent(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ── Idle ────────────────────────────────────────────────────────────
  Widget _buildIdleContent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.18),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.biotech_rounded, color: Colors.white, size: 18),
        ),
        const SizedBox(width: 12),
        const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Analyze Image",
                style: TextStyle(
                  color: Colors.white, fontSize: 16,
                  fontWeight: FontWeight.w700, letterSpacing: 0.4, height: 1,
                )),
            SizedBox(height: 3),
            Text("AI-powered skin cancer detection",
                style: TextStyle(
                  color: Colors.white60, fontSize: 10.5,
                  fontWeight: FontWeight.w400, letterSpacing: 0.2,
                )),
          ],
        ),
      ],
    );
  }

  // ── Loading ─────────────────────────────────────────────────────────
  Widget _buildLoadingContent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 20, height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(_cyan),
          ),
        ),
        const SizedBox(width: 14),
        const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Scanning...",
                style: TextStyle(
                  color: Colors.white, fontSize: 15,
                  fontWeight: FontWeight.w700, letterSpacing: 0.3, height: 1,
                )),
            SizedBox(height: 3),
            Text("Processing with AI model",
                style: TextStyle(
                  color: Colors.white60, fontSize: 10.5,
                  fontWeight: FontWeight.w400,
                )),
          ],
        ),
      ],
    );
  }

  // ── Disabled ────────────────────────────────────────────────────────
  Widget _buildDisabledContent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: const Color(0xFF1E2D50),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.add_photo_alternate_rounded,
            color: Color(0xFF4A5980),
            size: 18,
          ),
        ),
        const SizedBox(width: 12),
        const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("No Image Selected",
                style: TextStyle(
                  color: Color(0xFF4A5980), fontSize: 15,
                  fontWeight: FontWeight.w700, letterSpacing: 0.3, height: 1,
                )),
            SizedBox(height: 3),
            Text("Upload an image to enable scanning",
                style: TextStyle(
                  color: Color(0xFF2D3F5C), fontSize: 10.5,
                  fontWeight: FontWeight.w400,
                )),
          ],
        ),
      ],
    );
  }
}