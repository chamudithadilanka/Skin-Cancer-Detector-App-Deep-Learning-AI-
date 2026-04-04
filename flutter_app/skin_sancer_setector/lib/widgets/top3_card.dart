import 'package:flutter/material.dart';
import '../model/prediction_response.dart';

class Top3Card extends StatefulWidget {
  final List<TopPrediction> top3;
  const Top3Card({super.key, required this.top3});

  @override
  State<Top3Card> createState() => _Top3CardState();
}

class _Top3CardState extends State<Top3Card>
    with TickerProviderStateMixin {

  late List<AnimationController> _controllers;
  late List<Animation<double>> _fillAnims;
  late List<Animation<double>> _fadeAnims;

  // ─── Theme ─────────────────────────────────────────
  static const _card    = Color(0xFF111D35);
  static const _border  = Color(0xFF1E2D50);
  static const _textPri = Color(0xFFEAEEFF);
  static const _textSub = Color(0xFF6B7FA3);

  // ✅ NEW: Clear UX Colors
  static const _rankColors = [
    Color(0xFF00E676), // 🟢 1st
    Color(0xFFFFA726), // 🟠 2nd
    Color(0xFFFF5252), // 🔴 3rd
  ];

  static const _rankLabels = ["1st", "2nd", "3rd"];

  @override
  void initState() {
    super.initState();

    _controllers = List.generate(
      widget.top3.length,
          (i) => AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 800 + i * 160),
      ),
    );

    final maxConf = widget.top3
        .map((e) => e.confidence)
        .reduce((a, b) => a > b ? a : b);

    _fillAnims = List.generate(
      widget.top3.length,
          (i) => Tween<double>(
        begin: 0,
        end: widget.top3[i].confidence / maxConf,
      ).animate(
        CurvedAnimation(
          parent: _controllers[i],
          curve: Curves.easeOutCubic,
        ),
      ),
    );

    _fadeAnims = List.generate(
      widget.top3.length,
          (i) => Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _controllers[i],
          curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
        ),
      ),
    );

    // Stagger animation
    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 120), () {
        if (mounted) _controllers[i].forward();
      });
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(widget.top3.length, (i) {
        final item = widget.top3[i];
        final color = _rankColors[i];
        final isTop = i == 0;

        return AnimatedBuilder(
          animation: _controllers[i],
          builder: (_, __) => FadeTransition(
            opacity: _fadeAnims[i],
            child: Transform.translate(
              offset: Offset(0, 12 * (1 - _fadeAnims[i].value)),
              child: _buildBar(
                item: item,
                color: color,
                fill: _fillAnims[i].value,
                rank: _rankLabels[i],
                isTop: isTop,
                counter: _fillAnims[i].value * item.confidence,
                index: i,
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildBar({
    required TopPrediction item,
    required Color color,
    required double fill,
    required String rank,
    required bool isTop,
    required double counter,
    required int index,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isTop ? color.withOpacity(0.08) : _card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isTop ? color.withOpacity(0.4) : _border,
          width: isTop ? 1.5 : 1,
        ),
        boxShadow: isTop
            ? [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 18,
            offset: const Offset(0, 6),
          )
        ]
            : [],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ── Top Row ───────────────────────────────
          Row(
            children: [

              // 🏆 Rank Icon
              Icon(
                index == 0
                    ? Icons.emoji_events
                    : index == 1
                    ? Icons.trending_up
                    : Icons.warning_rounded,
                color: color,
                size: 18,
              ),

              const SizedBox(width: 8),

              // Rank badge
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  rank,
                  style: TextStyle(
                    color: color,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),

              const SizedBox(width: 10),

              // Name
              Expanded(
                child: Text(
                  item.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isTop ? _textPri : _textSub,
                    fontSize: isTop ? 14 : 13,
                    fontWeight:
                    isTop ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),

              const SizedBox(width: 8),

              // Percentage
              Text(
                "${counter.toStringAsFixed(1)}%",
                style: TextStyle(
                  color: color,
                  fontSize: isTop ? 18 : 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // ── Progress Bar ─────────────────────────
          Stack(
            children: [
              // Track
              Container(
                height: isTop ? 10 : 7,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),

              // Fill
              FractionallySizedBox(
                widthFactor: fill.clamp(0.0, 1.0),
                child: Container(
                  height: isTop ? 10 : 7,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),

                    // ✅ Gradient FIXED
                    gradient: LinearGradient(
                      colors: index == 0
                          ? [Color(0xFF00E676), Color(0xFF00C853)]
                          : index == 1
                          ? [Color(0xFFFFA726), Color(0xFFFF6F00)]
                          : [Color(0xFFFF5252), Color(0xFFD50000)],
                    ),

                    boxShadow: isTop
                        ? [
                      BoxShadow(
                        color: color.withOpacity(0.5),
                        blurRadius: 8,
                      )
                    ]
                        : [],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}