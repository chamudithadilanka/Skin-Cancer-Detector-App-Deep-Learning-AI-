import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

// ─── Model ───────────────────────────────────────────────────────────────────
class Disease {
  final String   name;
  final String   risk;
  final String   description;
  final String   detail;
  final String   tag;
  final IconData icon;
  final String   imageAsset; // e.g. "assets/images/melanoma.jpg"
  final List<String> quickFacts;

  const Disease({
    required this.name,
    required this.risk,
    required this.description,
    required this.detail,
    required this.tag,
    required this.icon,
    required this.imageAsset,
    required this.quickFacts,
  });
}

final List<Disease> diseases = [
  Disease(
    name: "Melanoma",
    risk: "high",
    tag: "MOST DANGEROUS",
    icon: Icons.warning_amber_rounded,
    imageAsset: "lib/assets/melanoma.jpeg",
    description: "The most serious type of skin cancer, developing in melanocytes.",
    detail: "Melanoma develops in melanin-producing cells. Early detection is critical — survival rate drops from 99% to 23% when caught late. Can spread rapidly to lymph nodes and organs if untreated.",
    quickFacts: ["Accounts for 1% of skin cancers", "Causes most skin cancer deaths", "UV exposure is the #1 risk factor"],
  ),
  Disease(
    name: "Basal Cell Carcinoma",
    risk: "high",
    tag: "MOST COMMON",
    icon: Icons.health_and_safety_rounded,
    imageAsset: "lib/assets/basal_cel_carcinoma.jpg",
    description: "The most frequently occurring form of all cancers. Highly treatable when caught early.",
    detail: "BCC usually appears as a slightly transparent bump on sun-exposed skin. It grows slowly and rarely spreads to other parts of the body, but can cause significant local tissue damage if ignored.",
    quickFacts: ["3.6 million cases/year in US", "Rarely spreads to organs", "Sun-exposed areas at highest risk"],
  ),
  Disease(
    name: "Actinic Keratoses",
    risk: "medium",
    tag: "PRE-CANCEROUS",
    icon: Icons.thermostat_rounded,
    imageAsset: "lib/assets/actic_keretoses.jpg",
    description: "A rough, scaly patch caused by years of sun exposure. May progress to cancer.",
    detail: "Actinic keratosis is considered a precursor to squamous cell carcinoma. Without treatment, up to 10% can develop into cancer. Cryotherapy and topical treatments are highly effective.",
    quickFacts: ["Up to 10% can become cancerous", "Appears after age 40", "Easily treated if caught early"],
  ),
  Disease(
    name: "Benign Keratosis",
    risk: "low",
    tag: "NON-CANCEROUS",
    icon: Icons.check_circle_outline_rounded,
    imageAsset: "lib/assets/begin_caratosis.jpeg",
    description: "A harmless skin growth that often appears with aging. No treatment necessary.",
    detail: "Seborrheic keratoses are benign skin growths. They vary from light tan to black and have a waxy, scaly, 'stuck-on' appearance. They are completely harmless and do not require removal.",
    quickFacts: ["Very common after age 50", "No cancer risk", "Can be removed cosmetically"],
  ),
  Disease(
    name: "Dermatofibroma",
    risk: "low",
    tag: "BENIGN",
    icon: Icons.circle_outlined,
    imageAsset: "lib/assets/dermatofibroma.jpg",
    description: "Small, harmless nodule found mostly on the lower legs.",
    detail: "Dermatofibromas are benign fibrous nodules typically 0.5–1.5cm. They are firm and may dimple inward when pinched. Harmless and rarely require treatment unless cosmetically bothersome.",
    quickFacts: ["Common in young women", "Usually on lower legs", "Dimples when pinched"],
  ),
  Disease(
    name: "Melanocytic Nevi",
    risk: "low",
    tag: "COMMON MOLE",
    icon: Icons.remove_circle_outline_rounded,
    imageAsset: "lib/assets/Melanocytic Nevi.jpeg",
    description: "Common moles that are typically safe. Monitor for changes in shape or color.",
    detail: "Melanocytic nevi are benign proliferations of melanocytes. While usually harmless, use ABCDE criteria: Asymmetry, Border irregularity, Color variation, Diameter >6mm, Evolution over time.",
    quickFacts: ["Most adults have 10–40 moles", "Monitor with ABCDE rule", "Changes warrant dermatologist visit"],
  ),
  Disease(
    name: "Vascular Lesions",
    risk: "low",
    tag: "COSMETIC",
    icon: Icons.opacity_rounded,
    imageAsset: "lib/assets/vascular_lesions.jpeg",
    description: "Blood vessel-related skin marks ranging from birthmarks to spider veins.",
    detail: "Vascular lesions include hemangiomas, port-wine stains, and spider veins. Most are benign and primarily a cosmetic concern. Laser therapy is the gold standard for treatment.",
    quickFacts: ["Include spider veins & birthmarks", "Laser treatment is effective", "Mostly cosmetic concern"],
  ),
];

// ─── Library Screen ───────────────────────────────────────────────────────────
class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen>
    with SingleTickerProviderStateMixin {
  String _filter = "all";
  late ScrollController   _scrollCtrl;
  late AnimationController _headerCtrl;
  late Animation<double>  _headerFade;

  final List<({String label, String value})> _filters = const [
    (label: "All",    value: "all"),
    (label: "High",   value: "high"),
    (label: "Medium", value: "medium"),
    (label: "Low",    value: "low"),
  ];

  List<Disease> get _filtered => _filter == "all"
      ? diseases
      : diseases.where((d) => d.risk == _filter).toList();

  @override
  void initState() {
    super.initState();
    _scrollCtrl = ScrollController();
    _headerCtrl = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 700),
    )..forward();
    _headerFade = CurvedAnimation(parent: _headerCtrl, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    _headerCtrl.dispose();
    super.dispose();
  }

  Color _riskColor(String risk) {
    if (risk == "high")   return _C.red;
    if (risk == "medium") return _C.orange;
    return _C.green;
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: _C.bg,
        body: CustomScrollView(
          controller: _scrollCtrl,
          physics: const BouncingScrollPhysics(),
          slivers: [
            _buildSliverHeader(),
            _buildFilterBar(),
            _buildDiseaseList(),
            const SliverToBoxAdapter(child: SizedBox(height: 110)),
          ],
        ),
      ),
    );
  }

  // ─── Sliver Header ─────────────────────────────────────────────────────────
  Widget _buildSliverHeader() {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      backgroundColor: _C.bg,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        background: FadeTransition(
          opacity: _headerFade,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF0D1F5C), Color(0xFF060D1F)],
                  ),
                ),
              ),
              Positioned(
                top: -40, right: -40,
                child: Container(
                  width: 200, height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _C.blue.withOpacity(0.12),
                  ),
                ),
              ),
              CustomPaint(painter: _GridPainter()),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 56, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: _C.blue.withOpacity(0.18),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: _C.blue.withOpacity(0.35)),
                      ),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        Icon(Icons.biotech_rounded, size: 12, color: _C.cyan),
                        const SizedBox(width: 6),
                        Text("AI-Powered Reference",
                            style: TextStyle(
                              color: _C.cyan, fontSize: 11,
                              fontWeight: FontWeight.w600, letterSpacing: 0.3,
                            )),
                      ]),
                    ),
                    const SizedBox(height: 10),
                    const Text("Types of Cancer",
                        style: TextStyle(
                          color: _C.textPrimary, fontSize: 30,
                          fontWeight: FontWeight.w800, letterSpacing: -0.5,
                        )),
                    const SizedBox(height: 4),
                    Text("",
                        style: TextStyle(color: _C.textSub, fontSize: 13)),
                  ],
                ),
              ),
              Positioned(
                bottom: 0, left: 0, right: 0,
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [_C.bg, _C.bg.withOpacity(0)],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        title: const Text("Disease Library",
            style: TextStyle(
              color: _C.textPrimary, fontSize: 17,
              fontWeight: FontWeight.w700, letterSpacing: -0.2,
            )),
        centerTitle: false,
        titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: _C.border),
      ),
    );
  }

  // ─── Filter Bar ────────────────────────────────────────────────────────────
  Widget _buildFilterBar() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _filters.map((f) {
              final isActive = _filter == f.value;
              final color = f.value == "high"   ? _C.red
                  : f.value == "medium" ? _C.orange
                  : f.value == "low"    ? _C.green
                  : _C.blueMid;
              return GestureDetector(
                onTap: () {
                  HapticFeedback.selectionClick();
                  setState(() => _filter = f.value);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                  decoration: BoxDecoration(
                    color: isActive ? color.withOpacity(0.15) : _C.card,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isActive ? color.withOpacity(0.5) : _C.border,
                      width: isActive ? 1.5 : 1,
                    ),
                  ),
                  child: Text(f.label,
                      style: TextStyle(
                        color: isActive ? color : _C.textSub,
                        fontSize: 12.5,
                        fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
                        letterSpacing: 0.2,
                      )),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  // ─── Disease List ──────────────────────────────────────────────────────────
  Widget _buildDiseaseList() {
    final list = _filtered;
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
              (context, index) => _DiseaseCard(
            disease:    list[index],
            riskColor:  _riskColor(list[index].risk),
            entryDelay: Duration(milliseconds: index * 90),
          ),
          childCount: list.length,
        ),
      ),
    );
  }
}

// ─── Disease Card ─────────────────────────────────────────────────────────────
class _DiseaseCard extends StatefulWidget {
  final Disease  disease;
  final Color    riskColor;
  final Duration entryDelay;

  const _DiseaseCard({
    required this.disease,
    required this.riskColor,
    required this.entryDelay,
  });

  @override
  State<_DiseaseCard> createState() => _DiseaseCardState();
}

class _DiseaseCardState extends State<_DiseaseCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double>   _fade;
  late Animation<Offset>   _slide;
  bool _expanded = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 520));
    _fade  = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    Future.delayed(widget.entryDelay, () { if (mounted) _ctrl.forward(); });
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final d     = widget.disease;
    final color = widget.riskColor;

    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            setState(() => _expanded = !_expanded);
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 22),
            decoration: BoxDecoration(
              color: _C.card,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: _C.border, width: 1),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.1),
                  blurRadius: 24, offset: const Offset(0, 10),
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 16, offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Image Hero Stack ─────────────────────────────────
                _buildImageHero(d, color),
                // ── Text Content ─────────────────────────────────────
                _buildTextContent(d, color),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─── Image Hero ───────────────────────────────────────────────────────────
  Widget _buildImageHero(Disease d, Color color) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: SizedBox(
        height: 200,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [

            // ── Layer 1: Actual image ──────────────────────────────
            Image.asset(
              d.imageAsset,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: _C.card,
                child: CustomPaint(painter: _HexPainter(color)),
              ),
            ),

            // ── Layer 2: Color tint overlay ────────────────────────
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    color.withOpacity(0.45),
                    color.withOpacity(0.1),
                    Colors.black.withOpacity(0.4),
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),

            // ── Layer 3: Hex pattern overlay ───────────────────────
            Opacity(
              opacity: 0.15,
              child: CustomPaint(painter: _HexPainter(Colors.white)),
            ),

            // ── Layer 4: Bottom fade into card ─────────────────────
            Positioned(
              bottom: 0, left: 0, right: 0,
              child: Container(
                height: 90,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      _C.card,
                      _C.card.withOpacity(0.7),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),
            ),

            // ── Layer 5: Top-left risk badge ───────────────────────
            Positioned(
              top: 14, left: 14,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: color.withOpacity(0.45), width: 1),
                  boxShadow: [
                    BoxShadow(color: color.withOpacity(0.3), blurRadius: 10),
                  ],
                ),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Container(
                    width: 5, height: 5,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle, color: color,
                      boxShadow: [BoxShadow(color: color, blurRadius: 4)],
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(d.tag,
                      style: TextStyle(
                        color: color, fontSize: 9.5,
                        fontWeight: FontWeight.w800, letterSpacing: 0.6,
                      )),
                ]),
              ),
            ),

            // ── Layer 6: Top-right icon badge ──────────────────────
            Positioned(
              top: 12, right: 12,
              child: Container(
                width: 38, height: 38,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black.withOpacity(0.4),
                  border: Border.all(color: color.withOpacity(0.4), width: 1.5),
                  boxShadow: [
                    BoxShadow(color: color.withOpacity(0.25), blurRadius: 12),
                  ],
                ),
                child: Icon(d.icon, color: color, size: 18),
              ),
            ),

            // ── Layer 7: Bottom-left disease name overlay ──────────
            Positioned(
              bottom: 14, left: 16, right: 16,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(d.name,
                            style: const TextStyle(
                              color: _C.textPrimary,
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.4,
                              height: 1.1,
                              shadows: [
                                Shadow(color: Colors.black54, blurRadius: 8),
                              ],
                            )),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: color.withOpacity(0.3)),
                          ),
                          child: Text("${d.risk.toUpperCase()} RISK",
                              style: TextStyle(
                                color: color, fontSize: 9,
                                fontWeight: FontWeight.w800, letterSpacing: 0.5,
                              )),
                        ),
                      ],
                    ),
                  ),
                  // Expand hint
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.45),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                    ),
                    child: Icon(
                      _expanded
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                      color: Colors.white70, size: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Text Content ─────────────────────────────────────────────────────────
  Widget _buildTextContent(Disease d, Color color) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // Description / expanded detail
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 280),
            crossFadeState: _expanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            firstChild: Text(d.description,
                style: const TextStyle(
                  color: _C.textSub, fontSize: 13.5, height: 1.6,
                )),
            secondChild: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(d.detail,
                    style: const TextStyle(
                      color: _C.textSub, fontSize: 13.5, height: 1.65,
                    )),
                // Quick facts
                if (d.quickFacts.isNotEmpty) ...[
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: color.withOpacity(0.18)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          Icon(Icons.lightbulb_outline_rounded, color: color, size: 13),
                          const SizedBox(width: 6),
                          Text("Quick Facts",
                              style: TextStyle(
                                color: color, fontSize: 11.5,
                                fontWeight: FontWeight.w700, letterSpacing: 0.3,
                              )),
                        ]),
                        const SizedBox(height: 8),
                        ...d.quickFacts.map((f) => Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 7),
                                width: 4, height: 4,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle, color: color,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(child: Text(f,
                                  style: TextStyle(
                                    color: _C.textSub, fontSize: 12.5, height: 1.5,
                                  ))),
                            ],
                          ),
                        )),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Divider
          Container(height: 1, color: _C.border),
          const SizedBox(height: 12),

          // Read insight / Show less + risk badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  setState(() => _expanded = !_expanded);
                },
                child: Row(children: [
                  ShaderMask(
                    shaderCallback: (b) => const LinearGradient(
                      colors: [Color(0xFF0038E3), Color(0xFF00C6FF)],
                    ).createShader(b),
                    child: Text(
                        _expanded ? "Show less" : "Read Insight",
                        style: const TextStyle(
                          color: Colors.white, fontSize: 13,
                          fontWeight: FontWeight.w700, letterSpacing: 0.1,
                        )),
                  ),
                  const SizedBox(width: 4),
                  ShaderMask(
                    shaderCallback: (b) => const LinearGradient(
                      colors: [Color(0xFF0038E3), Color(0xFF00C6FF)],
                    ).createShader(b),
                    child: Icon(
                      _expanded
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.arrow_forward_rounded,
                      color: Colors.white, size: 16,
                    ),
                  ),
                ]),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: color.withOpacity(0.25)),
                ),
                child: Text("${d.risk.toUpperCase()} RISK",
                    style: TextStyle(
                      color: color, fontSize: 10,
                      fontWeight: FontWeight.w700, letterSpacing: 0.4,
                    )),
              ),
            ],
          ),
          const SizedBox(height: 14),
        ],
      ),
    );
  }
}

// ─── Hex Painter ──────────────────────────────────────────────────────────────
class _HexPainter extends CustomPainter {
  final Color color;
  const _HexPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = color.withOpacity(0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    const r = 20.0;
    const h = r * 1.732;

    for (double y = -h; y < size.height + h; y += h) {
      for (double x = -r * 1.5; x < size.width + r * 2; x += r * 3) {
        final offset = (((y / h).round()) % 2 == 0) ? 0.0 : r * 1.5;
        _hex(canvas, p, Offset(x + offset, y), r);
      }
    }
  }

  void _hex(Canvas canvas, Paint p, Offset c, double r) {
    final path = Path();
    for (int i = 0; i < 6; i++) {
      final a = (i * 60 - 30) * math.pi / 180;
      final pt = Offset(c.dx + r * math.cos(a), c.dy + r * math.sin(a));
      i == 0 ? path.moveTo(pt.dx, pt.dy) : path.lineTo(pt.dx, pt.dy);
    }
    path.close();
    canvas.drawPath(path, p);
  }

  @override
  bool shouldRepaint(covariant CustomPainter _) => false;
}

// ─── Grid Painter ─────────────────────────────────────────────────────────────
class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = const Color(0xFF1E2D50).withOpacity(0.4)
      ..strokeWidth = 0.5;
    const step = 32.0;
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