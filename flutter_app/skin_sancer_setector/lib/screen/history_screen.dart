import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../service/prediction_history_service.dart';
import '../model/recent_prediction.dart';

// ─── Theme ───────────────────────────────────────────────────────────────────
class _C {
  static const bg          = Color(0xFF060D1F);
  static const card        = Color(0xFF111D35);
  static const border      = Color(0xFF1E2D50);
  static const blue        = Color(0xFF0038E3);
  static const blueMid     = Color(0xFF2D6AFF);
  static const cyan        = Color(0xFF00C6FF);
  static const textPrimary = Color(0xFFEAEEFF);
  static const textSub     = Color(0xFF6B7FA3);
  static const red         = Color(0xFFFF4D6D);
  static const orange      = Color(0xFFFF8C42);
  static const green       = Color(0xFF00E5A0);
}

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen>
    with TickerProviderStateMixin {
  List<RecentPrediction> _history = [];
  bool _loading = true;

  late AnimationController _headerCtrl;
  late Animation<double>   _headerFade;

  @override
  void initState() {
    super.initState();
    _headerCtrl = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 700),
    )..forward();
    _headerFade = CurvedAnimation(parent: _headerCtrl, curve: Curves.easeOut);
    _load();
  }

  @override
  void dispose() {
    _headerCtrl.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final data = await PredictionHistoryService.getAll();
    if (mounted) setState(() { _history = data; _loading = false; });
  }

  Future<void> _delete(int index) async {
    HapticFeedback.mediumImpact();
    await PredictionHistoryService.delete(index);
    _load();
  }

  Future<void> _clearAll() async {
    HapticFeedback.heavyImpact();
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: _C.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56, height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _C.red.withOpacity(0.12),
                  border: Border.all(color: _C.red.withOpacity(0.3)),
                ),
                child: Icon(Icons.delete_sweep_rounded, color: _C.red, size: 26),
              ),
              const SizedBox(height: 16),
              const Text("Clear All History",
                  style: TextStyle(
                    color: _C.textPrimary, fontSize: 18, fontWeight: FontWeight.w800,
                  )),
              const SizedBox(height: 8),
              Text("This will permanently remove all scan records.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: _C.textSub, fontSize: 13.5, height: 1.5)),
              const SizedBox(height: 24),
              Row(children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context, false),
                    child: Container(
                      height: 46,
                      decoration: BoxDecoration(
                        color: _C.border,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Text("Cancel",
                            style: TextStyle(
                              color: _C.textSub, fontWeight: FontWeight.w600,
                            )),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context, true),
                    child: Container(
                      height: 46,
                      decoration: BoxDecoration(
                        color: _C.red.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: _C.red.withOpacity(0.4)),
                      ),
                      child: Center(
                        child: Text("Clear All",
                            style: TextStyle(
                              color: _C.red, fontWeight: FontWeight.w700,
                            )),
                      ),
                    ),
                  ),
                ),
              ]),
            ],
          ),
        ),
      ),
    );
    if (confirm == true) {
      await PredictionHistoryService.clearAll();
      _load();
    }
  }

  Color _riskColor(String label) {
    final l = label.toLowerCase();
    if (l.contains('melanoma') || l.contains('carcinoma') || l.contains('high'))
      return _C.red;
    if (l.contains('actinic') || l.contains('medium')) return _C.orange;
    return _C.green;
  }

  String _relativeTime(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1)  return "Just now";
    if (diff.inMinutes < 60) return "${diff.inMinutes}m ago";
    if (diff.inHours < 24)   return "${diff.inHours}h ago";
    if (diff.inDays < 7)     return "${diff.inDays}d ago";
    return "${dt.day}/${dt.month}/${dt.year}";
  }

  String _formatDate(DateTime dt) =>
      "${dt.day}/${dt.month}/${dt.year}  ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}";

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: _C.bg,
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            _buildAppBar(),
            if (!_loading && _history.isNotEmpty) _buildStatsBar(),
            _buildBody(),
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }

  // ─── App Bar ──────────────────────────────────────────────────────────────
  Widget _buildAppBar() {
    return SliverAppBar(
      pinned: true,
      backgroundColor: _C.bg,
      surfaceTintColor: Colors.transparent,
      expandedHeight: 130,
      automaticallyImplyLeading: false,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        background: FadeTransition(
          opacity: _headerFade,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [const Color(0xFF0D1F5C), _C.bg],
              ),
            ),
            child: Stack(
              children: [
                // Decorative glow
                Positioned(
                  top: -30, right: -20,
                  child: Container(
                    width: 140, height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _C.blue.withOpacity(0.1),
                    ),
                  ),
                ),
                // Content
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 56, 20, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text("Scan History",
                                style: const TextStyle(
                                  color: _C.textPrimary, fontSize: 28,
                                  fontWeight: FontWeight.w800, letterSpacing: -0.5,
                                )),
                            const SizedBox(height: 4),
                            Text(
                              _history.isEmpty
                                  ? "No records yet"
                                  : "${_history.length} scan${_history.length == 1 ? '' : 's'} recorded",
                              style: TextStyle(color: _C.textSub, fontSize: 13.5),
                            ),
                          ],
                        ),
                      ),
                      if (_history.isNotEmpty)
                        GestureDetector(
                          onTap: _clearAll,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: _C.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: _C.red.withOpacity(0.3)),
                            ),
                            child: Row(mainAxisSize: MainAxisSize.min, children: [
                              Icon(Icons.delete_sweep_rounded, color: _C.red, size: 16),
                              const SizedBox(width: 6),
                              Text("Clear",
                                  style: TextStyle(
                                    color: _C.red, fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  )),
                            ]),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        centerTitle: false,
        titlePadding: const EdgeInsets.only(left: 20, bottom: 14),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: _C.border),
      ),
    );
  }

  // ─── Stats Bar ────────────────────────────────────────────────────────────
  Widget _buildStatsBar() {
    final high   = _history.where((h) => _riskColor(h.predictionLabel) == _C.red).length;
    final medium = _history.where((h) => _riskColor(h.predictionLabel) == _C.orange).length;
    final low    = _history.where((h) => _riskColor(h.predictionLabel) == _C.green).length;

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: Row(children: [
          _StatPill(count: high,   label: "High",   color: _C.red),
          const SizedBox(width: 8),
          _StatPill(count: medium, label: "Medium", color: _C.orange),
          const SizedBox(width: 8),
          _StatPill(count: low,    label: "Low",    color: _C.green),
        ]),
      ),
    );
  }

  // ─── Body ─────────────────────────────────────────────────────────────────
  Widget _buildBody() {
    if (_loading) {
      return SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 36, height: 36,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation(_C.cyan),
                ),
              ),
              const SizedBox(height: 16),
              Text("Loading history...",
                  style: TextStyle(color: _C.textSub, fontSize: 13)),
            ],
          ),
        ),
      );
    }

    if (_history.isEmpty) {
      return SliverFillRemaining(child: _buildEmptyState());
    }

    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
              (context, index) => _HistoryCard(
            item:       _history[index],
            index:      index,
            riskColor:  _riskColor(_history[index].predictionLabel),
            relTime:    _relativeTime(_history[index].savedAt),
            fullDate:   _formatDate(_history[index].savedAt),
            onDelete:   () => _delete(index),
            entryDelay: Duration(milliseconds: index * 70),
          ),
          childCount: _history.length,
        ),
      ),
    );
  }

  // ─── Empty State ──────────────────────────────────────────────────────────
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 90, height: 90,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _C.card,
              border: Border.all(color: _C.border, width: 1.5),
            ),
            child: Icon(Icons.history_rounded, size: 40, color: _C.textSub),
          ),
          const SizedBox(height: 20),
          const Text("No Scans Yet",
              style: TextStyle(
                color: _C.textPrimary, fontSize: 20, fontWeight: FontWeight.w700,
              )),
          const SizedBox(height: 8),
          Text(
            "Your scan history will\nappear here after analysis",
            textAlign: TextAlign.center,
            style: TextStyle(color: _C.textSub, fontSize: 14, height: 1.6),
          ),
        ],
      ),
    );
  }
}

// ─── History Card ─────────────────────────────────────────────────────────────
class _HistoryCard extends StatefulWidget {
  final RecentPrediction item;
  final int              index;
  final Color            riskColor;
  final String           relTime;
  final String           fullDate;
  final VoidCallback     onDelete;
  final Duration         entryDelay;

  const _HistoryCard({
    required this.item,
    required this.index,
    required this.riskColor,
    required this.relTime,
    required this.fullDate,
    required this.onDelete,
    required this.entryDelay,
  });

  @override
  State<_HistoryCard> createState() => _HistoryCardState();
}

class _HistoryCardState extends State<_HistoryCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double>   _fade;
  late Animation<Offset>   _slide;
  bool _swiping = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 480),
    );
    _fade  = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(begin: const Offset(0.06, 0), end: Offset.zero)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));

    Future.delayed(widget.entryDelay, () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final item      = widget.item;
    final color     = widget.riskColor;
    final imgExists = File(item.imagePath).existsSync();
    final conf      = item.confidence > 1
        ? item.confidence
        : item.confidence * 100;

    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Dismissible(
            key: Key(item.savedAt.toString()),
            direction: DismissDirection.endToStart,
            onUpdate: (d) => setState(() => _swiping = d.reached),
            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 24),
              decoration: BoxDecoration(
                color: _C.red.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: _C.red.withOpacity(0.3)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.delete_rounded, color: _C.red, size: 24),
                  const SizedBox(height: 4),
                  Text("Delete",
                      style: TextStyle(
                        color: _C.red, fontSize: 11, fontWeight: FontWeight.w700,
                      )),
                ],
              ),
            ),
            confirmDismiss: (_) async {
              HapticFeedback.mediumImpact();
              return true;
            },
            onDismissed: (_) => widget.onDelete(),
            child: Container(
              decoration: BoxDecoration(
                color: _C.card,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _swiping ? _C.red.withOpacity(0.3) : _C.border,
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.07),
                    blurRadius: 16, offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // ── Left accent bar ─────────────────────────────────
                  Container(
                    width: 4,
                    height: 90,
                    margin: const EdgeInsets.only(left: 4),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(color: color.withOpacity(0.5), blurRadius: 8),
                      ],
                    ),
                  ),

                  const SizedBox(width: 12),

                  // ── Thumbnail ───────────────────────────────────────
                  Container(
                    width: 60, height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: color.withOpacity(0.25), width: 1.5),
                      color: _C.border,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(13),
                      child: imgExists
                          ? Image.file(
                        File(item.imagePath),
                        fit: BoxFit.cover,
                      )
                          : Icon(Icons.image_not_supported_rounded,
                          color: _C.textSub, size: 26),
                    ),
                  ),

                  const SizedBox(width: 14),

                  // ── Content ─────────────────────────────────────────
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Label
                          Text(
                            item.predictionLabel,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: _C.textPrimary, fontSize: 15,
                              fontWeight: FontWeight.w700, letterSpacing: -0.2,
                            ),
                          ),
                          const SizedBox(height: 5),

                          // Confidence bar
                          Row(children: [
                            Expanded(
                              child: Stack(children: [
                                Container(
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color: color.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                FractionallySizedBox(
                                  widthFactor: (conf / 100).clamp(0, 1),
                                  child: Container(
                                    height: 4,
                                    decoration: BoxDecoration(
                                      color: color,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: color.withOpacity(0.5),
                                          blurRadius: 6,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ]),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "${conf.toStringAsFixed(1)}%",
                              style: TextStyle(
                                color: color, fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ]),

                          const SizedBox(height: 7),

                          // Date row
                          Row(children: [
                            Icon(Icons.access_time_rounded,
                                size: 11, color: _C.textSub),
                            const SizedBox(width: 4),
                            Text(widget.relTime,
                                style: const TextStyle(
                                  color: _C.textSub, fontSize: 11.5,
                                )),
                            const SizedBox(width: 8),
                            Container(
                              width: 3, height: 3,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle, color: _C.border,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(widget.fullDate,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: _C.textSub, fontSize: 11,
                                  )),
                            ),
                          ]),
                        ],
                      ),
                    ),
                  ),

                  // ── Risk badge ──────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.only(right: 14),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: color.withOpacity(0.25)),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            color == _C.red
                                ? Icons.warning_rounded
                                : color == _C.orange
                                ? Icons.info_rounded
                                : Icons.check_circle_rounded,
                            color: color, size: 16,
                          ),
                          const SizedBox(height: 3),
                          Text(
                            color == _C.red
                                ? "HIGH"
                                : color == _C.orange ? "MED" : "LOW",
                            style: TextStyle(
                              color: color, fontSize: 8.5,
                              fontWeight: FontWeight.w800, letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
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

// ─── Stat Pill ────────────────────────────────────────────────────────────────
class _StatPill extends StatelessWidget {
  final int    count;
  final String label;
  final Color  color;

  const _StatPill({
    required this.count,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.07),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(children: [
          Text("$count",
              style: TextStyle(
                color: color, fontSize: 20, fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              )),
          const SizedBox(height: 2),
          Text(label,
              style: TextStyle(
                color: color.withOpacity(0.7), fontSize: 11,
                fontWeight: FontWeight.w500,
              )),
        ]),
      ),
    );
  }
}