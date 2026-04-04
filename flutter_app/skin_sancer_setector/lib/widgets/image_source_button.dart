import 'package:flutter/material.dart';
import 'package:skin_sancer_setector/theme/themes.dart';

class ImageSourceButton extends StatefulWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const ImageSourceButton({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  State<ImageSourceButton> createState() => _ImageSourceButtonState();
}

class _ImageSourceButtonState extends State<ImageSourceButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  late Animation<double> _glowAnim;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.94).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _glowAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(_) {
    setState(() => _isPressed = true);
    _controller.forward();
  }

  void _onTapUp(_) {
    setState(() => _isPressed = false);
    _controller.reverse();
    widget.onTap();
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    const primaryBlue = Color(0xFF0038E3);
    const accentBlue = Color(0xFF4D7CFF);
    const softBlue = Color(0xFFEEF2FF);

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnim.value,
            child: Container(
              width: 130,
              height: 155,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: _isPressed
                      ? [primaryBlue, accentBlue]
                      : [Colors.white, softBlue],
                ),
                boxShadow: [
                  // Deep shadow
                  BoxShadow(
                    color: primaryBlue.withOpacity(0.18 + _glowAnim.value * 0.22),
                    blurRadius: 20 + _glowAnim.value * 12,
                    spreadRadius: _glowAnim.value * 2,
                    offset: const Offset(0, 8),
                  ),
                  // Soft ambient
                  BoxShadow(
                    color: Colors.white.withOpacity(0.9),
                    blurRadius: 6,
                    spreadRadius: -2,
                    offset: const Offset(-3, -3),
                  ),
                ],
                border: Border.all(
                  color: _isPressed
                      ? Colors.white.withOpacity(0.3)
                      : primaryBlue.withOpacity(0.12),
                  width: 1.5,
                ),
              ),
              child: Stack(
                children: [
                  // Decorative top-right circle
                  Positioned(
                    top: -18,
                    right: -18,
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _isPressed
                            ? Colors.white.withOpacity(0.12)
                            : primaryBlue.withOpacity(0.06),
                      ),
                    ),
                  ),

                  // Main content
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 14),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Icon container
                        Container(
                          width: 68,
                          height: 68,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            gradient: _isPressed
                                ? LinearGradient(
                              colors: [
                                Colors.white.withOpacity(0.25),
                                Colors.white.withOpacity(0.1),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                                : LinearGradient(
                              colors: [softBlue, Colors.white],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            border: Border.all(
                              color: _isPressed
                                  ? Colors.white.withOpacity(0.3)
                                  : primaryBlue.withOpacity(0.15),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: primaryBlue.withOpacity(0.12),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Icon(
                            widget.icon,
                            size: 32,
                            color: _isPressed ? Colors.white : primaryBlue,
                          ),
                        ),

                        const SizedBox(height: 14),

                        // Title
                        Text(
                          widget.title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.3,
                            color: _isPressed
                                ? Colors.white
                                : const Color(0xFF1A2352),
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}