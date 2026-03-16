import 'package:flutter/material.dart';
import '../models/mission.dart';
import '../theme/app_theme.dart';

// ─── FoW Battlefield Diagram ──────────────────────────────────────────────────
// Bird's-eye view of the 6'×4' (72"×48") Flames of War table showing:
//   • Deployment zones (coloured, labelled with inch depths)
//   • Objective placement zones (gold highlight + markers)
//   • Key measurement annotations
// ─────────────────────────────────────────────────────────────────────────────

class BattlefieldDiagram extends StatelessWidget {
  final Mission mission;

  const BattlefieldDiagram({super.key, required this.mission});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.divider),
        borderRadius: BorderRadius.circular(6),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: AspectRatio(
          aspectRatio: 72 / 48, // Standard 6'×4' FoW table
          child: CustomPaint(
            painter: _BattlefieldPainter(mission),
          ),
        ),
      ),
    );
  }
}

class _BattlefieldPainter extends CustomPainter {
  final Mission mission;
  static const double _tw = 72.0; // table width in inches
  static const double _th = 48.0; // table height in inches

  _BattlefieldPainter(this.mission);

  // Inch → canvas coordinate helpers
  double _px(double i, double cw) => i / _tw * cw;
  double _py(double i, double ch) => i / _th * ch;
  Offset _pt(double xi, double yi, double cw, double ch) =>
      Offset(_px(xi, cw), _py(yi, ch));
  Rect _rc(double xi, double yi, double wi, double hi, double cw, double ch) =>
      Rect.fromLTWH(_px(xi, cw), _py(yi, ch), _px(wi, cw), _py(hi, ch));

  @override
  void paint(Canvas canvas, Size size) {
    final cw = size.width;
    final ch = size.height;

    // Background
    canvas.drawRect(Rect.fromLTWH(0, 0, cw, ch),
        Paint()..color = const Color(0xFF0F1A08));

    // Grid (6" squares)
    final grid = Paint()
      ..color = const Color(0xFF1C2612)
      ..strokeWidth = 0.5;
    for (var i = 0; i <= 72; i += 6) {
      canvas.drawLine(_pt(i.toDouble(), 0, cw, ch),
          _pt(i.toDouble(), 48, cw, ch), grid);
    }
    for (var i = 0; i <= 48; i += 6) {
      canvas.drawLine(_pt(0, i.toDouble(), cw, ch),
          _pt(72, i.toDouble(), cw, ch), grid);
    }

    // Mission layout
    switch (mission.id) {
      case 'free_for_all':
        _freeForAll(canvas, cw, ch);
      case 'annihilation':
        _annihilation(canvas, cw, ch);
      case 'encounter':
        _encounter(canvas, cw, ch);
      case 'dust_up':
        _dustUp(canvas, cw, ch);
      case 'no_retreat':
        _noRetreat(canvas, cw, ch);
      case 'hasty_attack':
        _hastyAttack(canvas, cw, ch);
      case 'contact':
        _contact(canvas, cw, ch);
      case 'counterattack':
        _counterattack(canvas, cw, ch);
      case 'bridgehead':
        _bridgehead(canvas, cw, ch);
      case 'breakthrough':
        _breakthrough(canvas, cw, ch);
      case 'rearguard':
        _rearguard(canvas, cw, ch);
      // ── Extended / Missions Pack missions ──────────────────────────────
      case 'probe':
        _probe(canvas, cw, ch);
      case 'scouts_out':
        _scoutsOut(canvas, cw, ch);
      case 'fighting_withdrawal':
        _fightingWithdrawal(canvas, cw, ch);
      case 'covering_force':
        _coveringForce(canvas, cw, ch);
      case 'spearpoint':
        _spearpoint(canvas, cw, ch);
      case 'bypass':
        _bypass(canvas, cw, ch);
      case 'encirclement':
        _encirclement(canvas, cw, ch);
      case 'hold_the_pocket':
        _holdThePocket(canvas, cw, ch);
      case 'escape':
        _escape(canvas, cw, ch);
      case 'dogfight':
        _dogfight(canvas, cw, ch);
      case 'gauntlet':
        _gauntlet(canvas, cw, ch);
      case 'killing_ground':
        _killingGround(canvas, cw, ch);
      case 'its_a_trap':
        _itsATrap(canvas, cw, ch);
      case 'outflanked':
        _outflanked(canvas, cw, ch);
      case 'outmanoeuvred':
        _outmanoeuvred(canvas, cw, ch);
      case 'valley_of_death':
        _valleyOfDeath(canvas, cw, ch);
      case 'vanguard':
        _vanguard(canvas, cw, ch);
      case 'cornered':
        _cornered(canvas, cw, ch);
      case 'counterstrike':
        _counterstrike(canvas, cw, ch);
      default:
        _freeForAll(canvas, cw, ch);
    }

    // Centre line
    canvas.drawLine(
      _pt(0, 24, cw, ch),
      _pt(72, 24, cw, ch),
      Paint()
        ..color = Colors.white.withValues(alpha: 0.15)
        ..strokeWidth = 0.8,
    );

    // Table border
    canvas.drawRect(
      Rect.fromLTWH(0, 0, cw, ch),
      Paint()
        ..color = AppColors.divider
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke,
    );
  }

  // ── Drawing helpers ────────────────────────────────────────────────────────

  /// Filled + outlined deployment zone with centred label
  void _zone(Canvas canvas, Rect r, Color c, String label, double cw, double ch) {
    canvas.drawRect(r, Paint()..color = c.withValues(alpha: 0.20));
    canvas.drawRect(r,
        Paint()
          ..color = c.withValues(alpha: 0.55)
          ..strokeWidth = 1
          ..style = PaintingStyle.stroke);
    _text(canvas, r.center, label, c, cw, ch, size: 7.5);
  }

  /// Gold-tinted objective placement zone with "OBJ" label
  void _objZone(Canvas canvas, Rect r, double cw, double ch) {
    canvas.drawRect(r,
        Paint()..color = AppColors.gold.withValues(alpha: 0.10));
    canvas.drawRect(r,
        Paint()
          ..color = AppColors.gold.withValues(alpha: 0.40)
          ..strokeWidth = 0.8
          ..style = PaintingStyle.stroke);
    _text(canvas, r.center, 'OBJ', AppColors.gold, cw, ch, size: 6.5);
  }

  /// Individual objective marker (circle + mini flag)
  void _obj(Canvas canvas, Offset p, double cw, double ch) {
    final r = _px(1.6, cw);
    canvas.drawCircle(p, r + 1, Paint()..color = Colors.black54);
    canvas.drawCircle(p, r, Paint()..color = AppColors.gold);
    final pole = Paint()
      ..color = AppColors.gold
      ..strokeWidth = 0.8;
    canvas.drawLine(p, Offset(p.dx + r * 0.3, p.dy - r * 2.2), pole);
    canvas.drawRect(
      Rect.fromLTWH(p.dx + r * 0.3, p.dy - r * 2.2, r, r * 0.7),
      Paint()..color = AppColors.gold,
    );
  }

  /// Dashed measurement line with inch label at midpoint
  void _dim(Canvas canvas, Offset a, Offset b, String label, Color c,
      double cw, double ch) {
    final paint = Paint()
      ..color = c.withValues(alpha: 0.65)
      ..strokeWidth = 0.9;
    final dx = b.dx - a.dx;
    final dy = b.dy - a.dy;
    const steps = 14;
    for (var i = 0; i < steps; i++) {
      if (i % 2 == 0) {
        canvas.drawLine(
          Offset(a.dx + dx * i / steps, a.dy + dy * i / steps),
          Offset(a.dx + dx * (i + 0.75) / steps,
              a.dy + dy * (i + 0.75) / steps),
          paint,
        );
      }
    }
    _text(canvas, Offset((a.dx + b.dx) / 2, (a.dy + b.dy) / 2), label, c,
        cw, ch, size: 6.5, bg: true);
  }

  /// Vertical centreline (for rotated tables)
  void _vCentre(Canvas canvas, double cw, double ch) {
    canvas.drawLine(
      _pt(36, 0, cw, ch),
      _pt(36, 48, cw, ch),
      Paint()
        ..color = Colors.white.withValues(alpha: 0.15)
        ..strokeWidth = 0.8,
    );
  }

  /// Small text label, optionally with dark background pill
  void _text(Canvas canvas, Offset pos, String text, Color color,
      double cw, double ch,
      {double size = 7.0, bool bg = false}) {
    final scale = (cw / 320).clamp(0.7, 2.0);
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: size * scale,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.4,
          height: 1.2,
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    )..layout(maxWidth: cw * 0.35);

    final ox = pos.dx - tp.width / 2;
    final oy = pos.dy - tp.height / 2;

    if (bg) {
      final pad = 2.0 * scale;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(ox - pad, oy - pad, tp.width + pad * 2, tp.height + pad * 2),
          const Radius.circular(2),
        ),
        Paint()..color = const Color(0xCC0A120A),
      );
    }
    tp.paint(canvas, Offset(ox, oy));
  }

  // ── Mission layouts ────────────────────────────────────────────────────────

  // Free for All: both within 12" of long edges, objectives within 8" of opp. edge
  void _freeForAll(Canvas canvas, double cw, double ch) {
    _zone(canvas, _rc(0, 36, 72, 12, cw, ch), AppColors.attackerBlue, 'P1\n12"', cw, ch);
    _zone(canvas, _rc(0, 0, 72, 12, cw, ch), AppColors.defenderBrown, 'P2\n12"', cw, ch);

    // Objective zones: within 8" of each long edge
    _objZone(canvas, _rc(0, 0, 72, 8, cw, ch), cw, ch);
    _objZone(canvas, _rc(0, 40, 72, 8, cw, ch), cw, ch);

    // Objectives
    _obj(canvas, _pt(20, 4, cw, ch), cw, ch);
    _obj(canvas, _pt(52, 4, cw, ch), cw, ch);
    _obj(canvas, _pt(20, 44, cw, ch), cw, ch);
    _obj(canvas, _pt(52, 44, cw, ch), cw, ch);

    // Measurements
    _dim(canvas, _pt(3, 36, cw, ch), _pt(3, 48, cw, ch), '12"',
        AppColors.attackerBlue, cw, ch);
    _dim(canvas, _pt(3, 0, cw, ch), _pt(3, 12, cw, ch), '12"',
        AppColors.defenderBrown, cw, ch);
    _dim(canvas, _pt(69, 0, cw, ch), _pt(69, 8, cw, ch), '8"',
        AppColors.gold, cw, ch);
  }

  // Annihilation: same deployment, no objectives
  void _annihilation(Canvas canvas, double cw, double ch) {
    _zone(canvas, _rc(0, 36, 72, 12, cw, ch), AppColors.attackerBlue, 'P1\n12"', cw, ch);
    _zone(canvas, _rc(0, 0, 72, 12, cw, ch), AppColors.defenderBrown, 'P2\n12"', cw, ch);

    _dim(canvas, _pt(3, 36, cw, ch), _pt(3, 48, cw, ch), '12"',
        AppColors.attackerBlue, cw, ch);
    _dim(canvas, _pt(3, 0, cw, ch), _pt(3, 12, cw, ch), '12"',
        AppColors.defenderBrown, cw, ch);

    // "No objectives" text in middle
    _text(canvas, _pt(36, 24, cw, ch), 'NO OBJECTIVES\nDestroy all enemy Formations',
        Colors.white54, cw, ch, size: 7.5);
  }

  // Encounter: same deployment as FFA, objectives within 8" of opp. edge
  void _encounter(Canvas canvas, double cw, double ch) {
    _zone(canvas, _rc(0, 36, 72, 12, cw, ch), AppColors.attackerBlue, 'P1\n12"', cw, ch);
    _zone(canvas, _rc(0, 0, 72, 12, cw, ch), AppColors.defenderBrown, 'P2\n12"', cw, ch);

    _objZone(canvas, _rc(0, 0, 72, 8, cw, ch), cw, ch);
    _objZone(canvas, _rc(0, 40, 72, 8, cw, ch), cw, ch);

    _obj(canvas, _pt(20, 4, cw, ch), cw, ch);
    _obj(canvas, _pt(52, 4, cw, ch), cw, ch);
    _obj(canvas, _pt(20, 44, cw, ch), cw, ch);
    _obj(canvas, _pt(52, 44, cw, ch), cw, ch);

    _dim(canvas, _pt(3, 36, cw, ch), _pt(3, 48, cw, ch), '12"',
        AppColors.attackerBlue, cw, ch);
    _dim(canvas, _pt(3, 0, cw, ch), _pt(3, 12, cw, ch), '12"',
        AppColors.defenderBrown, cw, ch);
    _dim(canvas, _pt(69, 0, cw, ch), _pt(69, 8, cw, ch), '8"',
        AppColors.gold, cw, ch);
    // 8" from short edges min
    _dim(canvas, _pt(0, 10, cw, ch), _pt(8, 10, cw, ch), '8"',
        AppColors.gold, cw, ch);
  }

  // Dust Up: diagonal 24"×24" corners, objectives in all 4 corners
  void _dustUp(Canvas canvas, double cw, double ch) {
    // Deployment corners
    _zone(canvas, _rc(0, 24, 24, 24, cw, ch), AppColors.attackerBlue,
        'P1\n24"×24"', cw, ch);
    _zone(canvas, _rc(48, 0, 24, 24, cw, ch), AppColors.defenderBrown,
        'P2\n24"×24"', cw, ch);

    // Objective zones — one per corner (8"+ from edges, 12"+ from centre)
    // P1 corner objective zone
    _objZone(canvas, _rc(4, 28, 16, 16, cw, ch), cw, ch);
    // P2 corner objective zone
    _objZone(canvas, _rc(52, 4, 16, 16, cw, ch), cw, ch);
    // P1 places one in P2's corner (attack objective)
    _objZone(canvas, _rc(52, 28, 16, 16, cw, ch), cw, ch);
    // P2 places one in P1's corner (attack objective)
    _objZone(canvas, _rc(4, 4, 16, 16, cw, ch), cw, ch);

    _obj(canvas, _pt(12, 36, cw, ch), cw, ch);
    _obj(canvas, _pt(60, 12, cw, ch), cw, ch);
    _obj(canvas, _pt(60, 36, cw, ch), cw, ch);
    _obj(canvas, _pt(12, 12, cw, ch), cw, ch);

    _vCentre(canvas, cw, ch);

    // Corner size
    _dim(canvas, _pt(0, 24, cw, ch), _pt(24, 24, cw, ch), '24"',
        AppColors.attackerBlue, cw, ch);
    _dim(canvas, _pt(48, 0, cw, ch), _pt(72, 0, cw, ch), '24"',
        AppColors.defenderBrown, cw, ch);
    // 12" from centre
    _dim(canvas, _pt(0, 24, cw, ch), _pt(0, 36, cw, ch), '12"',
        Colors.white38, cw, ch);
    // 8" from edge min for objectives
    _dim(canvas, _pt(0, 24, cw, ch), _pt(0, 28, cw, ch), '8"',
        AppColors.gold, cw, ch);
  }

  // No Retreat: SHORT table edges (rotated view)
  // Left = Attacker, Right = Defender
  void _noRetreat(Canvas canvas, double cw, double ch) {
    // Attacker: their half (left 36"), at least 16" from centre → 20" deep zone
    _zone(canvas, _rc(0, 0, 20, 48, cw, ch), AppColors.attackerBlue,
        'ATK\n≥16" from centre', cw, ch);
    // Defender: right half
    _zone(canvas, _rc(36, 0, 36, 48, cw, ch), AppColors.defenderBrown,
        'DEF\nhalf', cw, ch);

    // Objective zone: Defender's half, 8"+ from all edges
    _objZone(canvas, _rc(40, 8, 28, 32, cw, ch), cw, ch);
    _obj(canvas, _pt(48, 18, cw, ch), cw, ch);
    _obj(canvas, _pt(60, 30, cw, ch), cw, ch);

    _vCentre(canvas, cw, ch);

    // Gap between ATK zone and centre = 16"
    _dim(canvas, _pt(20, 3, cw, ch), _pt(36, 3, cw, ch), '16"',
        Colors.white54, cw, ch);
    // 8" from side edges (objectives)
    _dim(canvas, _pt(36, 3, cw, ch), _pt(44, 3, cw, ch), '8"',
        AppColors.gold, cw, ch);

    _text(canvas, _pt(4, 44, cw, ch), '← ATK edge', AppColors.attackerBlue, cw, ch, size: 6.5);
    _text(canvas, _pt(62, 44, cw, ch), 'DEF edge →', AppColors.defenderBrown, cw, ch, size: 6.5);
    _text(canvas, _pt(36, 44, cw, ch), 'SHORT EDGE MISSION', Colors.white38, cw, ch, size: 5.5);
  }

  // Hasty Attack: asymmetric, 3 objectives in Defender's half
  void _hastyAttack(Canvas canvas, double cw, double ch) {
    // ATK: within 12" of their long edge (bottom) → zone from 36" to 48"
    _zone(canvas, _rc(0, 36, 72, 12, cw, ch), AppColors.attackerBlue,
        'ATK  12"', cw, ch);
    // DEF: within 16" of their long edge (top) → zone from 0 to 16"
    _zone(canvas, _rc(0, 0, 72, 16, cw, ch), AppColors.defenderBrown,
        'DEF  16"', cw, ch);

    // Objective zone: Defender's half, 12"+ from centre, 8"+ from short edges
    _objZone(canvas, _rc(8, 16, 56, 8, cw, ch), cw, ch);
    _obj(canvas, _pt(20, 20, cw, ch), cw, ch);
    _obj(canvas, _pt(36, 20, cw, ch), cw, ch);
    _obj(canvas, _pt(52, 20, cw, ch), cw, ch);

    _dim(canvas, _pt(3, 36, cw, ch), _pt(3, 48, cw, ch), '12"',
        AppColors.attackerBlue, cw, ch);
    _dim(canvas, _pt(3, 0, cw, ch), _pt(3, 16, cw, ch), '16"',
        AppColors.defenderBrown, cw, ch);
    _dim(canvas, _pt(69, 16, cw, ch), _pt(69, 24, cw, ch), '8"',
        AppColors.gold, cw, ch);
    _dim(canvas, _pt(0, 20, cw, ch), _pt(8, 20, cw, ch), '8"',
        AppColors.gold, cw, ch);

    _text(canvas, _pt(36, 28, cw, ch), '3 objectives in DEF half',
        Colors.white38, cw, ch, size: 6.0);
  }

  // Contact: asymmetric, 4 objectives (2 each half)
  void _contact(Canvas canvas, double cw, double ch) {
    _zone(canvas, _rc(0, 36, 72, 12, cw, ch), AppColors.attackerBlue,
        'ATK  12"', cw, ch);
    _zone(canvas, _rc(0, 0, 72, 16, cw, ch), AppColors.defenderBrown,
        'DEF  16"', cw, ch);

    // Objective zones: 2 in DEF half (placed by ATK), 2 in ATK half (placed by DEF)
    _objZone(canvas, _rc(8, 16, 56, 8, cw, ch), cw, ch); // DEF half
    _objZone(canvas, _rc(8, 32, 56, 6, cw, ch), cw, ch); // ATK half

    _obj(canvas, _pt(22, 20, cw, ch), cw, ch);
    _obj(canvas, _pt(50, 20, cw, ch), cw, ch);
    _obj(canvas, _pt(22, 35, cw, ch), cw, ch);
    _obj(canvas, _pt(50, 35, cw, ch), cw, ch);

    _dim(canvas, _pt(3, 36, cw, ch), _pt(3, 48, cw, ch), '12"',
        AppColors.attackerBlue, cw, ch);
    _dim(canvas, _pt(3, 0, cw, ch), _pt(3, 16, cw, ch), '16"',
        AppColors.defenderBrown, cw, ch);
    _dim(canvas, _pt(69, 16, cw, ch), _pt(69, 24, cw, ch), '8"',
        AppColors.gold, cw, ch);
    _dim(canvas, _pt(0, 20, cw, ch), _pt(8, 20, cw, ch), '8"',
        AppColors.gold, cw, ch);
    _text(canvas, _pt(36, 29, cw, ch), '4 objectives — 2 per half',
        Colors.white38, cw, ch, size: 6.0);
  }

  // Counterattack: adjacent quarters (ATK bottom-left, DEF top-left)
  void _counterattack(Canvas canvas, double cw, double ch) {
    // ATK: bottom-left quarter, 8"+ from both centrelines
    _zone(canvas, _rc(0, 24, 36, 24, cw, ch), AppColors.attackerBlue,
        'ATK  8" from centrelines', cw, ch);
    // DEF: top-left quarter, 12"+ from centre
    _zone(canvas, _rc(0, 0, 36, 24, cw, ch), AppColors.defenderBrown,
        'DEF  12" from centre', cw, ch);

    _vCentre(canvas, cw, ch);

    // Objective zones: 1 in DEF quarter, 1 in far-right quarter
    _objZone(canvas, _rc(4, 4, 28, 16, cw, ch), cw, ch);          // in DEF quarter
    _objZone(canvas, _rc(40, 28, 28, 16, cw, ch), cw, ch);         // opposite quarter
    _obj(canvas, _pt(16, 12, cw, ch), cw, ch);
    _obj(canvas, _pt(56, 36, cw, ch), cw, ch);

    // Measurements
    _dim(canvas, _pt(0, 24, cw, ch), _pt(8, 24, cw, ch), '8"',
        AppColors.attackerBlue, cw, ch);
    _dim(canvas, _pt(3, 12, cw, ch), _pt(3, 24, cw, ch), '12"',
        AppColors.defenderBrown, cw, ch);
    _dim(canvas, _pt(0, 24, cw, ch), _pt(36, 24, cw, ch), '36"',
        Colors.white38, cw, ch);

    _text(canvas, _pt(54, 12, cw, ch), 'adjacent\nquarters', Colors.white38, cw, ch, size: 6.0);
  }

  // Bridgehead: long edges, ATK U-zone, DEF central band, objectives in DEF half
  void _bridgehead(Canvas canvas, double cw, double ch) {
    // ATK: bottom 8" strip OR within 8" of short edges (U-shape)
    _zone(canvas, _rc(0, 40, 72, 8, cw, ch), AppColors.attackerBlue, 'ATK  8"', cw, ch);
    _zone(canvas, _rc(0, 24, 8, 16, cw, ch), AppColors.attackerBlue, '', cw, ch);
    _zone(canvas, _rc(64, 24, 8, 16, cw, ch), AppColors.attackerBlue, '', cw, ch);

    // DEF: top half, 20"+ from short edges
    _zone(canvas, _rc(20, 0, 32, 24, cw, ch), AppColors.defenderBrown,
        'DEF  20" from sides', cw, ch);

    // Objective zone: DEF half, 8"+ from long edge, 8"+ from centre, 28"+ from short edges
    _objZone(canvas, _rc(28, 8, 16, 8, cw, ch), cw, ch);
    _obj(canvas, _pt(32, 10, cw, ch), cw, ch);
    _obj(canvas, _pt(40, 16, cw, ch), cw, ch);

    _dim(canvas, _pt(3, 40, cw, ch), _pt(3, 48, cw, ch), '8"',
        AppColors.attackerBlue, cw, ch);
    _dim(canvas, _pt(0, 26, cw, ch), _pt(8, 26, cw, ch), '8"',
        AppColors.attackerBlue, cw, ch);
    _dim(canvas, _pt(20, 2, cw, ch), _pt(0, 2, cw, ch), '20"',
        AppColors.defenderBrown, cw, ch);
    _dim(canvas, _pt(28, 2, cw, ch), _pt(0, 2, cw, ch), '28"',
        AppColors.gold, cw, ch);
    _text(canvas, _pt(36, 28, cw, ch), 'ATK zone: ≥16" from centre\nOR ≤8" from sides',
        AppColors.attackerBlue.withValues(alpha: 0.7), cw, ch, size: 5.5);
  }

  // Breakthrough: ATK bottom-left 24"×24" corner → objectives in top-right quarter
  void _breakthrough(Canvas canvas, double cw, double ch) {
    // ATK corner (bottom-left)
    _zone(canvas, _rc(0, 24, 24, 24, cw, ch), AppColors.attackerBlue,
        'ATK  8" from centrelines', cw, ch);
    // DEF covers both adjacent quarters
    _zone(canvas, _rc(0, 0, 24, 24, cw, ch), AppColors.defenderBrown, 'DEF', cw, ch);
    _zone(canvas, _rc(24, 24, 48, 24, cw, ch), AppColors.defenderBrown, 'DEF', cw, ch);

    _vCentre(canvas, cw, ch);

    // Objective zone: far (top-right) quarter, 8"+ from edges
    _objZone(canvas, _rc(48, 0, 24, 24, cw, ch), cw, ch);
    _obj(canvas, _pt(56, 8, cw, ch), cw, ch);
    _obj(canvas, _pt(64, 16, cw, ch), cw, ch);

    // 8" from centrelines (ATK deployment)
    _dim(canvas, _pt(0, 24, cw, ch), _pt(8, 24, cw, ch), '8"',
        AppColors.attackerBlue, cw, ch);
    _dim(canvas, _pt(24, 24, cw, ch), _pt(32, 24, cw, ch), '8"',
        AppColors.attackerBlue, cw, ch);
    // Corner size
    _dim(canvas, _pt(0, 48, cw, ch), _pt(24, 48, cw, ch), '24"',
        AppColors.attackerBlue, cw, ch);
    _dim(canvas, _pt(0, 48, cw, ch), _pt(0, 24, cw, ch), '24"',
        AppColors.attackerBlue, cw, ch);

    _text(canvas, _pt(60, 22, cw, ch), '← Obj zone', AppColors.gold, cw, ch, size: 6.0);
  }

  // Rearguard: ATK within 8", objectives within 16" of DEF edge / 16"+ from short edges
  void _rearguard(Canvas canvas, double cw, double ch) {
    _zone(canvas, _rc(0, 40, 72, 8, cw, ch), AppColors.attackerBlue,
        'ATK  8"', cw, ch);
    _zone(canvas, _rc(0, 0, 72, 24, cw, ch), AppColors.defenderBrown,
        'DEF  full half', cw, ch);

    // Objective zone: within 16" of DEF edge, at least 16" from short edges
    _objZone(canvas, _rc(16, 0, 40, 16, cw, ch), cw, ch);
    _obj(canvas, _pt(26, 9, cw, ch), cw, ch);
    _obj(canvas, _pt(46, 9, cw, ch), cw, ch);

    _dim(canvas, _pt(3, 40, cw, ch), _pt(3, 48, cw, ch), '8"',
        AppColors.attackerBlue, cw, ch);
    _dim(canvas, _pt(69, 0, cw, ch), _pt(69, 16, cw, ch), '16"',
        AppColors.gold, cw, ch);
    _dim(canvas, _pt(0, 18, cw, ch), _pt(16, 18, cw, ch), '16"',
        AppColors.gold, cw, ch);
    _dim(canvas, _pt(56, 18, cw, ch), _pt(72, 18, cw, ch), '16"',
        AppColors.gold, cw, ch);
  }

  // ── Extended / Missions Pack layouts ───────────────────────────────────────

  // Probe: both sides 12" long edges, 4 objectives (2 each half, 16"+ from centre)
  void _probe(Canvas canvas, double cw, double ch) {
    _zone(canvas, _rc(0, 36, 72, 12, cw, ch), AppColors.attackerBlue, 'ATK\n12"', cw, ch);
    _zone(canvas, _rc(0, 0, 72, 12, cw, ch), AppColors.defenderBrown, 'DEF\n12"', cw, ch);
    _objZone(canvas, _rc(8, 0, 56, 8, cw, ch), cw, ch);
    _objZone(canvas, _rc(8, 40, 56, 8, cw, ch), cw, ch);
    _obj(canvas, _pt(22, 4, cw, ch), cw, ch);
    _obj(canvas, _pt(50, 4, cw, ch), cw, ch);
    _obj(canvas, _pt(22, 44, cw, ch), cw, ch);
    _obj(canvas, _pt(50, 44, cw, ch), cw, ch);
    _dim(canvas, _pt(3, 36, cw, ch), _pt(3, 48, cw, ch), '12"', AppColors.attackerBlue, cw, ch);
    _dim(canvas, _pt(3, 0, cw, ch), _pt(3, 12, cw, ch), '12"', AppColors.defenderBrown, cw, ch);
    _text(canvas, _pt(36, 24, cw, ch), '4 objectives — 2 each half\n16"+ from centre',
        Colors.white38, cw, ch, size: 5.5);
  }

  // Scouts Out: FFA layout + Recce advance annotation
  void _scoutsOut(Canvas canvas, double cw, double ch) {
    _zone(canvas, _rc(0, 36, 72, 12, cw, ch), AppColors.attackerBlue, 'P1\n12"', cw, ch);
    _zone(canvas, _rc(0, 0, 72, 12, cw, ch), AppColors.defenderBrown, 'P2\n12"', cw, ch);
    _objZone(canvas, _rc(0, 0, 72, 8, cw, ch), cw, ch);
    _objZone(canvas, _rc(0, 40, 72, 8, cw, ch), cw, ch);
    _obj(canvas, _pt(20, 4, cw, ch), cw, ch);
    _obj(canvas, _pt(52, 4, cw, ch), cw, ch);
    _obj(canvas, _pt(20, 44, cw, ch), cw, ch);
    _obj(canvas, _pt(52, 44, cw, ch), cw, ch);
    _dim(canvas, _pt(3, 36, cw, ch), _pt(3, 48, cw, ch), '12"', AppColors.attackerBlue, cw, ch);
    _dim(canvas, _pt(3, 0, cw, ch), _pt(3, 12, cw, ch), '12"', AppColors.defenderBrown, cw, ch);
    _dim(canvas, _pt(69, 28, cw, ch), _pt(69, 36, cw, ch), '8"', Colors.white38, cw, ch);
    _text(canvas, _pt(36, 22, cw, ch), 'Recce advance 8" before deploy',
        Colors.white38, cw, ch, size: 6.0);
  }

  // Fighting Withdrawal: ATK 12", DEF full half, 3 objectives progressively withdrawn
  void _fightingWithdrawal(Canvas canvas, double cw, double ch) {
    _zone(canvas, _rc(0, 36, 72, 12, cw, ch), AppColors.attackerBlue, 'ATK\n12"', cw, ch);
    _zone(canvas, _rc(0, 0, 72, 24, cw, ch), AppColors.defenderBrown, 'DEF\nhalf', cw, ch);
    _obj(canvas, _pt(20, 4, cw, ch), cw, ch);
    _obj(canvas, _pt(36, 12, cw, ch), cw, ch);
    _obj(canvas, _pt(52, 20, cw, ch), cw, ch);
    _dim(canvas, _pt(3, 36, cw, ch), _pt(3, 48, cw, ch), '12"', AppColors.attackerBlue, cw, ch);
    _text(canvas, _pt(36, 29, cw, ch), '3 objectives withdrawn from Turn 2',
        Colors.white38, cw, ch, size: 5.5);
    _text(canvas, _pt(20, 8, cw, ch), 'last', AppColors.gold.withValues(alpha: 0.7), cw, ch, size: 5.5);
    _text(canvas, _pt(36, 16, cw, ch), '2nd', AppColors.gold.withValues(alpha: 0.7), cw, ch, size: 5.5);
    _text(canvas, _pt(52, 20, cw, ch), '1st', AppColors.gold.withValues(alpha: 0.7), cw, ch, size: 5.5);
  }

  // Covering Force: ATK 8", DEF full half, 2 objectives near DEF edge
  void _coveringForce(Canvas canvas, double cw, double ch) {
    _zone(canvas, _rc(0, 40, 72, 8, cw, ch), AppColors.attackerBlue, 'ATK\n8"', cw, ch);
    _zone(canvas, _rc(0, 0, 72, 24, cw, ch), AppColors.defenderBrown, 'DEF\nhalf', cw, ch);
    _objZone(canvas, _rc(16, 0, 40, 16, cw, ch), cw, ch);
    _obj(canvas, _pt(26, 9, cw, ch), cw, ch);
    _obj(canvas, _pt(46, 9, cw, ch), cw, ch);
    _dim(canvas, _pt(3, 40, cw, ch), _pt(3, 48, cw, ch), '8"', AppColors.attackerBlue, cw, ch);
    _dim(canvas, _pt(69, 0, cw, ch), _pt(69, 16, cw, ch), '16"', AppColors.gold, cw, ch);
    _dim(canvas, _pt(0, 18, cw, ch), _pt(16, 18, cw, ch), '16"', AppColors.gold, cw, ch);
    _text(canvas, _pt(36, 29, cw, ch), 'Covering Force — withdraw from Turn 2',
        Colors.white38, cw, ch, size: 5.5);
  }

  // Spearpoint: ATK narrow central corridor from short edge, DEF flanks
  // Short-edge orientation: ATK = left, DEF = right flanks
  void _spearpoint(Canvas canvas, double cw, double ch) {
    _zone(canvas, _rc(0, 12, 16, 24, cw, ch), AppColors.attackerBlue, 'ATK\nspearhead', cw, ch);
    _zone(canvas, _rc(36, 0, 36, 24, cw, ch), AppColors.defenderBrown, 'DEF\nflank', cw, ch);
    _zone(canvas, _rc(36, 24, 36, 24, cw, ch), AppColors.defenderBrown, 'DEF\nflank', cw, ch);
    _vCentre(canvas, cw, ch);
    _objZone(canvas, _rc(40, 12, 28, 24, cw, ch), cw, ch);
    _obj(canvas, _pt(52, 18, cw, ch), cw, ch);
    _obj(canvas, _pt(60, 30, cw, ch), cw, ch);
    _dim(canvas, _pt(0, 24, cw, ch), _pt(16, 24, cw, ch), '16"', AppColors.attackerBlue, cw, ch);
    _dim(canvas, _pt(0, 12, cw, ch), _pt(0, 36, cw, ch), '24"', AppColors.attackerBlue, cw, ch);
    _text(canvas, _pt(4, 44, cw, ch), '← ATK edge', AppColors.attackerBlue, cw, ch, size: 6.5);
    _text(canvas, _pt(36, 44, cw, ch), 'SHORT EDGE MISSION', Colors.white38, cw, ch, size: 5.5);
  }

  // Bypass: variant of Spearpoint — ATK outer flanks, DEF central band, objectives both ends
  void _bypass(Canvas canvas, double cw, double ch) {
    _zone(canvas, _rc(0, 0, 36, 12, cw, ch), AppColors.attackerBlue, 'ATK', cw, ch);
    _zone(canvas, _rc(0, 36, 36, 12, cw, ch), AppColors.attackerBlue, 'ATK', cw, ch);
    _zone(canvas, _rc(20, 12, 32, 24, cw, ch), AppColors.defenderBrown, 'DEF\ncentral', cw, ch);
    _vCentre(canvas, cw, ch);
    _objZone(canvas, _rc(0, 8, 8, 32, cw, ch), cw, ch);
    _objZone(canvas, _rc(64, 8, 8, 32, cw, ch), cw, ch);
    _obj(canvas, _pt(4, 20, cw, ch), cw, ch);
    _obj(canvas, _pt(4, 36, cw, ch), cw, ch);
    _obj(canvas, _pt(68, 20, cw, ch), cw, ch);
    _obj(canvas, _pt(68, 36, cw, ch), cw, ch);
    _text(canvas, _pt(4, 44, cw, ch), '← ATK', AppColors.attackerBlue, cw, ch, size: 6.5);
    _text(canvas, _pt(36, 44, cw, ch), 'SHORT EDGE MISSION', Colors.white38, cw, ch, size: 5.5);
    _text(canvas, _pt(36, 7, cw, ch), 'Win by Holding your own objectives (Turn 3+)',
        Colors.white38, cw, ch, size: 5.5);
  }

  // Encirclement: DEF in one quarter (bottom-left), ATK in three quarters
  void _encirclement(Canvas canvas, double cw, double ch) {
    _zone(canvas, _rc(0, 24, 36, 24, cw, ch), AppColors.defenderBrown, 'DEF\nquarter', cw, ch);
    _zone(canvas, _rc(0, 0, 36, 24, cw, ch), AppColors.attackerBlue, 'ATK', cw, ch);
    _zone(canvas, _rc(36, 0, 36, 24, cw, ch), AppColors.attackerBlue, 'ATK', cw, ch);
    _zone(canvas, _rc(36, 24, 36, 24, cw, ch), AppColors.attackerBlue, 'ATK', cw, ch);
    _vCentre(canvas, cw, ch);
    _objZone(canvas, _rc(4, 28, 28, 16, cw, ch), cw, ch);
    _obj(canvas, _pt(12, 32, cw, ch), cw, ch);
    _obj(canvas, _pt(24, 40, cw, ch), cw, ch);
    _dim(canvas, _pt(0, 24, cw, ch), _pt(36, 24, cw, ch), '36"', Colors.white38, cw, ch);
    _text(canvas, _pt(18, 28, cw, ch), 'DEF reserves\n← own edge only',
        AppColors.defenderBrown.withValues(alpha: 0.8), cw, ch, size: 5.5);
  }

  // Hold the Pocket: same quarter layout as Encirclement
  void _holdThePocket(Canvas canvas, double cw, double ch) {
    _encirclement(canvas, cw, ch);
    _text(canvas, _pt(54, 44, cw, ch), 'Hold the Pocket', Colors.white38, cw, ch, size: 6.0);
  }

  // Escape: DEF in one quarter, ATK in three, DEF breakout to far short edge
  void _escape(Canvas canvas, double cw, double ch) {
    _zone(canvas, _rc(0, 24, 36, 24, cw, ch), AppColors.defenderBrown, 'DEF\npocket', cw, ch);
    _zone(canvas, _rc(0, 0, 36, 24, cw, ch), AppColors.attackerBlue, 'ATK', cw, ch);
    _zone(canvas, _rc(36, 0, 36, 24, cw, ch), AppColors.attackerBlue, 'ATK', cw, ch);
    _zone(canvas, _rc(36, 24, 36, 24, cw, ch), AppColors.attackerBlue, 'ATK', cw, ch);
    _vCentre(canvas, cw, ch);
    final bp = Paint()
      ..color = AppColors.amber
      ..strokeWidth = 2.0;
    canvas.drawLine(_pt(36, 36, cw, ch), _pt(68, 36, cw, ch), bp);
    canvas.drawLine(_pt(68, 36, cw, ch), _pt(62, 32, cw, ch), bp);
    canvas.drawLine(_pt(68, 36, cw, ch), _pt(62, 40, cw, ch), bp);
    _text(canvas, _pt(52, 30, cw, ch), 'BREAKOUT →', AppColors.amber, cw, ch, size: 6.5);
    _text(canvas, _pt(18, 40, cw, ch), 'DEF moves first',
        AppColors.defenderBrown.withValues(alpha: 0.8), cw, ch, size: 5.5);
  }

  // Dogfight: ATK 12", DEF half 60%, 3 objectives (centre + 1 each half), aircraft priority
  void _dogfight(Canvas canvas, double cw, double ch) {
    _zone(canvas, _rc(0, 36, 72, 12, cw, ch), AppColors.attackerBlue, 'ATK\n12"', cw, ch);
    _zone(canvas, _rc(0, 0, 72, 24, cw, ch), AppColors.defenderBrown, 'DEF\nhalf (60%)', cw, ch);
    _obj(canvas, _pt(36, 24, cw, ch), cw, ch);
    _obj(canvas, _pt(22, 10, cw, ch), cw, ch);
    _obj(canvas, _pt(50, 38, cw, ch), cw, ch);
    _dim(canvas, _pt(3, 36, cw, ch), _pt(3, 48, cw, ch), '12"', AppColors.attackerBlue, cw, ch);
    _text(canvas, _pt(36, 29, cw, ch), '3 objectives — hold 2+ from Turn 6',
        Colors.white38, cw, ch, size: 5.5);
    _text(canvas, _pt(36, 33, cw, ch), 'Aircraft always available T1+',
        Colors.white38, cw, ch, size: 5.5);
  }

  // Gauntlet: ATK central corridor from short edge, DEF flanks, objectives near far edge
  void _gauntlet(Canvas canvas, double cw, double ch) {
    _zone(canvas, _rc(0, 16, 12, 16, cw, ch), AppColors.attackerBlue, 'ATK', cw, ch);
    _zone(canvas, _rc(36, 0, 36, 16, cw, ch), AppColors.defenderBrown, 'DEF\nflank', cw, ch);
    _zone(canvas, _rc(36, 32, 36, 16, cw, ch), AppColors.defenderBrown, 'DEF\nflank', cw, ch);
    _vCentre(canvas, cw, ch);
    _objZone(canvas, _rc(64, 14, 8, 20, cw, ch), cw, ch);
    _obj(canvas, _pt(68, 18, cw, ch), cw, ch);
    _obj(canvas, _pt(68, 30, cw, ch), cw, ch);
    _dim(canvas, _pt(0, 16, cw, ch), _pt(0, 32, cw, ch), '16"', AppColors.attackerBlue, cw, ch);
    _dim(canvas, _pt(0, 24, cw, ch), _pt(12, 24, cw, ch), '12"', AppColors.attackerBlue, cw, ch);
    _text(canvas, _pt(4, 44, cw, ch), '← ATK edge', AppColors.attackerBlue, cw, ch, size: 6.5);
    _text(canvas, _pt(36, 44, cw, ch), 'SHORT EDGE MISSION', Colors.white38, cw, ch, size: 5.5);
  }

  // Helper: draw X minefield markers in defender's half
  void _minefields(Canvas canvas, double cw, double ch) {
    final mp = Paint()
      ..color = const Color(0xFFCC4444)
      ..strokeWidth = 1.2;
    for (final p in [
      _pt(28, 16, cw, ch), _pt(36, 20, cw, ch),
      _pt(44, 16, cw, ch), _pt(52, 14, cw, ch),
    ]) {
      final r = _px(2.5, cw);
      canvas.drawLine(Offset(p.dx - r, p.dy - r), Offset(p.dx + r, p.dy + r), mp);
      canvas.drawLine(Offset(p.dx + r, p.dy - r), Offset(p.dx - r, p.dy + r), mp);
    }
  }

  // Killing Ground: ATK 12", DEF full half with minefields, 2 objectives 12"+ from centre
  void _killingGround(Canvas canvas, double cw, double ch) {
    _zone(canvas, _rc(0, 36, 72, 12, cw, ch), AppColors.attackerBlue, 'ATK\n12"', cw, ch);
    _zone(canvas, _rc(0, 0, 72, 24, cw, ch), AppColors.defenderBrown, 'DEF\nhalf', cw, ch);
    _objZone(canvas, _rc(8, 0, 56, 12, cw, ch), cw, ch);
    _obj(canvas, _pt(22, 6, cw, ch), cw, ch);
    _obj(canvas, _pt(50, 6, cw, ch), cw, ch);
    _minefields(canvas, cw, ch);
    _dim(canvas, _pt(3, 36, cw, ch), _pt(3, 48, cw, ch), '12"', AppColors.attackerBlue, cw, ch);
    _dim(canvas, _pt(69, 0, cw, ch), _pt(69, 12, cw, ch), '12"', AppColors.gold, cw, ch);
    _text(canvas, _pt(36, 30, cw, ch), 'DEF places Minefields (1 per 25 pts)',
        Colors.white38, cw, ch, size: 5.5);
  }

  // It's a Trap: Killing Ground layout but DEF has 60% + flanking delayed reserves
  void _itsATrap(Canvas canvas, double cw, double ch) {
    _zone(canvas, _rc(0, 36, 72, 12, cw, ch), AppColors.attackerBlue, 'ATK\n12"', cw, ch);
    _zone(canvas, _rc(0, 0, 72, 24, cw, ch), AppColors.defenderBrown, 'DEF\n60%', cw, ch);
    _objZone(canvas, _rc(8, 0, 56, 12, cw, ch), cw, ch);
    _obj(canvas, _pt(22, 6, cw, ch), cw, ch);
    _obj(canvas, _pt(50, 6, cw, ch), cw, ch);
    _minefields(canvas, cw, ch);
    final ap = Paint()
      ..color = AppColors.defenderBrown
      ..strokeWidth = 1.5;
    canvas.drawLine(_pt(0, 24, cw, ch), _pt(10, 18, cw, ch), ap);
    canvas.drawLine(_pt(72, 24, cw, ch), _pt(62, 18, cw, ch), ap);
    _text(canvas, _pt(36, 30, cw, ch), 'DEF flanks arrive from short edges (Turn 3)',
        Colors.white38, cw, ch, size: 5.5);
  }

  // Outflanked: ATK 60% long edge with flanking delayed reserves from short edges
  void _outflanked(Canvas canvas, double cw, double ch) {
    _zone(canvas, _rc(0, 36, 72, 12, cw, ch), AppColors.attackerBlue, 'ATK\n60%', cw, ch);
    _zone(canvas, _rc(0, 0, 72, 24, cw, ch), AppColors.defenderBrown, 'DEF\n60%', cw, ch);
    _objZone(canvas, _rc(8, 0, 56, 12, cw, ch), cw, ch);
    _obj(canvas, _pt(22, 6, cw, ch), cw, ch);
    _obj(canvas, _pt(50, 6, cw, ch), cw, ch);
    final ap = Paint()
      ..color = AppColors.attackerBlue
      ..strokeWidth = 1.5;
    canvas.drawLine(_pt(0, 30, cw, ch), _pt(10, 20, cw, ch), ap);
    canvas.drawLine(_pt(72, 30, cw, ch), _pt(62, 20, cw, ch), ap);
    _dim(canvas, _pt(3, 36, cw, ch), _pt(3, 48, cw, ch), '12"', AppColors.attackerBlue, cw, ch);
    _text(canvas, _pt(36, 29, cw, ch), 'ATK flanks arrive from short edges (Turn 3)',
        AppColors.attackerBlue.withValues(alpha: 0.8), cw, ch, size: 5.5);
  }

  // Outmanoeuvred: same as Outflanked but ATK flanks arrive Turn 1 (not Turn 3)
  void _outmanoeuvred(Canvas canvas, double cw, double ch) {
    _outflanked(canvas, cw, ch);
    _text(canvas, _pt(54, 44, cw, ch), 'ATK flanks T1+', AppColors.attackerBlue, cw, ch, size: 6.0);
  }

  // Valley of Death: ATK from short edge, DEF along both long edges, objects far quarter
  void _valleyOfDeath(Canvas canvas, double cw, double ch) {
    _zone(canvas, _rc(0, 0, 12, 48, cw, ch), AppColors.attackerBlue, 'ATK\n12"', cw, ch);
    _zone(canvas, _rc(12, 0, 48, 10, cw, ch), AppColors.defenderBrown, 'DEF\nN flank', cw, ch);
    _zone(canvas, _rc(12, 38, 48, 10, cw, ch), AppColors.defenderBrown, 'DEF\nS flank', cw, ch);
    _vCentre(canvas, cw, ch);
    _objZone(canvas, _rc(60, 10, 12, 28, cw, ch), cw, ch);
    _obj(canvas, _pt(66, 16, cw, ch), cw, ch);
    _obj(canvas, _pt(66, 32, cw, ch), cw, ch);
    _dim(canvas, _pt(0, 3, cw, ch), _pt(12, 3, cw, ch), '12"', AppColors.attackerBlue, cw, ch);
    _dim(canvas, _pt(12, 45, cw, ch), _pt(0, 45, cw, ch), '12"', AppColors.defenderBrown, cw, ch);
    _text(canvas, _pt(36, 24, cw, ch), 'valley (open ground)',
        Colors.white38, cw, ch, size: 6.0);
    _text(canvas, _pt(4, 44, cw, ch), '← ATK', AppColors.attackerBlue, cw, ch, size: 6.5);
    _text(canvas, _pt(36, 44, cw, ch), 'SHORT EDGE MISSION', Colors.white38, cw, ch, size: 5.0);
  }

  // Vanguard: ATK 60%, DEF 60%, 3 objectives (centre + 1 each half), win from Turn 1
  void _vanguard(Canvas canvas, double cw, double ch) {
    _zone(canvas, _rc(0, 36, 72, 12, cw, ch), AppColors.attackerBlue, 'ATK\n60%', cw, ch);
    _zone(canvas, _rc(0, 0, 72, 24, cw, ch), AppColors.defenderBrown, 'DEF\n60%', cw, ch);
    _obj(canvas, _pt(36, 24, cw, ch), cw, ch);
    _obj(canvas, _pt(22, 10, cw, ch), cw, ch);
    _obj(canvas, _pt(50, 38, cw, ch), cw, ch);
    _dim(canvas, _pt(3, 36, cw, ch), _pt(3, 48, cw, ch), '12"', AppColors.attackerBlue, cw, ch);
    _text(canvas, _pt(36, 29, cw, ch), '3 objectives — win from Turn 1',
        Colors.white38, cw, ch, size: 5.5);
  }

  // Cornered: DEF in one quarter, ATK in full opposite half + adjacent quarter
  void _cornered(Canvas canvas, double cw, double ch) {
    _zone(canvas, _rc(0, 24, 36, 24, cw, ch), AppColors.defenderBrown, 'DEF\ncorner', cw, ch);
    _zone(canvas, _rc(0, 0, 72, 24, cw, ch), AppColors.attackerBlue, 'ATK', cw, ch);
    _zone(canvas, _rc(36, 24, 36, 24, cw, ch), AppColors.attackerBlue, 'ATK', cw, ch);
    _vCentre(canvas, cw, ch);
    _objZone(canvas, _rc(4, 28, 28, 16, cw, ch), cw, ch);
    _obj(canvas, _pt(12, 32, cw, ch), cw, ch);
    _obj(canvas, _pt(24, 40, cw, ch), cw, ch);
    _dim(canvas, _pt(20, 25, cw, ch), _pt(36, 25, cw, ch), '16"',
        AppColors.attackerBlue, cw, ch);
    _text(canvas, _pt(52, 10, cw, ch), 'ATK deploys\n20"+ from\nshort centre',
        Colors.white38, cw, ch, size: 5.5);
  }

  // Counterstrike: same deployment as Counterattack, but Defender goes first
  void _counterstrike(Canvas canvas, double cw, double ch) {
    _counterattack(canvas, cw, ch);
    _text(canvas, _pt(52, 6, cw, ch), 'DEF goes first!', AppColors.amber, cw, ch, size: 6.5);
  }

  @override
  bool shouldRepaint(covariant _BattlefieldPainter old) =>
      old.mission.id != mission.id;
}
