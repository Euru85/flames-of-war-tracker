import 'dart:math';
import 'package:flutter/material.dart';
import '../models/mission.dart';
import '../theme/app_theme.dart';
import 'mission_detail_screen.dart';

// ── FoW v4 Battle Plan Mission Selection ────────────────────────────────────
//
// Each player secretly chooses: ATTACK · DEFEND · MANOEUVRE
// Reveal simultaneously — cross-reference the 3×3 table:
//
//              P2: ATTACK         P2: MANOEUVRE      P2: DEFEND
// P1: ATTACK   Roll (Pool A)      Roll (Pool A)      P1 Attacks (Pool B)
// P1: MANOE.   Roll (Pool A)      Roll (Pool A)      P1 Attacks (Pool C)
// P1: DEFEND   P2 Attacks (Pool B) P2 Attacks (Pool C) Roll (Pool D)
//
// ── Pool A — Attack vs Attack / Attack vs Manoeuvre / Manoeuvre vs Manoeuvre
//   Roll D6 to see who attacks, then play the mission:
//   1  Breakthrough   2  Counterattack   3  Dust Up
//   4  Encounter      5  Free for All    6  Free for All
//
// ── Pool B — Attack vs Defend (Attacker attacks, D6):
//   1  Breakthrough   2  Probe   3-4  Counterattack   5  Dust Up   6  Encounter
//
// ── Pool C — Manoeuvre vs Defend (Manoeuvre player attacks, D3):
//   1  Bridgehead   2  No Retreat   3  Fighting Withdrawal
//
// ── Pool D — Defend vs Defend (Roll D6 to see who attacks):
//   1  Breakthrough   2  Bridgehead   3  Probe
//   4-5  No Retreat   6  Fighting Withdrawal
// ─────────────────────────────────────────────────────────────────────────────

enum _Plan { attack, defend, manoeuvre, none }
enum _Pool { a, b, c, d, e }

// Outcome of comparing two plans
class _Outcome {
  final bool rollForAttacker; // true → both roll off; no fixed attacker
  final bool p1Attacks;       // only meaningful when !rollForAttacker
  final _Pool pool;
  const _Outcome({required this.rollForAttacker, required this.pool, this.p1Attacks = false});
}

_Outcome _resolve(_Plan p1, _Plan p2) {
  // Attack vs Defend → Attack player attacks, Pool B
  if (p1 == _Plan.attack && p2 == _Plan.defend) {
    return const _Outcome(rollForAttacker: false, p1Attacks: true,  pool: _Pool.b);
  }
  if (p1 == _Plan.defend && p2 == _Plan.attack) {
    return const _Outcome(rollForAttacker: false, p1Attacks: false, pool: _Pool.b);
  }
  // Manoeuvre vs Defend → Manoeuvre player attacks, Pool C
  if (p1 == _Plan.manoeuvre && p2 == _Plan.defend) {
    return const _Outcome(rollForAttacker: false, p1Attacks: true,  pool: _Pool.c);
  }
  if (p1 == _Plan.defend && p2 == _Plan.manoeuvre) {
    return const _Outcome(rollForAttacker: false, p1Attacks: false, pool: _Pool.c);
  }
  // Attack vs Manoeuvre → Attack player attacks, Pool E
  if (p1 == _Plan.attack && p2 == _Plan.manoeuvre) {
    return const _Outcome(rollForAttacker: false, p1Attacks: true,  pool: _Pool.e);
  }
  if (p1 == _Plan.manoeuvre && p2 == _Plan.attack) {
    return const _Outcome(rollForAttacker: false, p1Attacks: false, pool: _Pool.e);
  }
  // Defend vs Defend → roll who attacks, Pool D
  if (p1 == _Plan.defend && p2 == _Plan.defend) {
    return const _Outcome(rollForAttacker: true, pool: _Pool.d);
  }
  // Attack vs Attack / Manoeuvre vs Manoeuvre → roll, Pool A
  return const _Outcome(rollForAttacker: true, pool: _Pool.a);
}

// ── Standard Battle Plans mission pools ──────────────────────────────────────

// Pool A — AA / MM: roll D6 to determine who attacks, then play mission
const _poolA = [
  _MissionEntry(die: '1', id: 'breakthrough',  label: 'Breakthrough'),
  _MissionEntry(die: '2', id: 'counterattack', label: 'Counterattack'),
  _MissionEntry(die: '3', id: 'dust_up',       label: 'Dust Up'),
  _MissionEntry(die: '4', id: 'encounter',     label: 'Encounter'),
  _MissionEntry(die: '5', id: 'free_for_all',  label: 'Free for All'),
  _MissionEntry(die: '6', id: 'free_for_all',  label: 'Free for All'),
];

// Pool E — Attack vs Manoeuvre: Attack player attacks, D6
const _poolE = [
  _MissionEntry(die: '1', id: 'breakthrough',  label: 'Breakthrough'),
  _MissionEntry(die: '2', id: 'probe',         label: 'Probe'),
  _MissionEntry(die: '3', id: 'counterattack', label: 'Counterattack'),
  _MissionEntry(die: '4', id: 'counterattack', label: 'Counterattack'),
  _MissionEntry(die: '5', id: 'dust_up',       label: 'Dust Up'),
  _MissionEntry(die: '6', id: 'encounter',     label: 'Encounter'),
];

// Pool B — Attack vs Defend: Attack player attacks, roll D3 (1–2 / 3–4 / 5–6)
const _poolB = [
  _MissionEntry(die: '1', id: 'bridgehead',         label: 'Bridgehead (1–2)'),
  _MissionEntry(die: '2', id: 'no_retreat',          label: 'No Retreat (3–4)'),
  _MissionEntry(die: '3', id: 'fighting_withdrawal', label: 'Fighting Withdrawal (5–6)'),
];

// Pool C — Manoeuvre vs Defend: manoeuvre player attacks, roll D6
const _poolC = [
  _MissionEntry(die: '1', id: 'breakthrough',        label: 'Breakthrough'),
  _MissionEntry(die: '2', id: 'bridgehead',          label: 'Bridgehead'),
  _MissionEntry(die: '3', id: 'probe',               label: 'Probe'),
  _MissionEntry(die: '4', id: 'no_retreat',          label: 'No Retreat'),
  _MissionEntry(die: '5', id: 'no_retreat',          label: 'No Retreat'),
  _MissionEntry(die: '6', id: 'fighting_withdrawal', label: 'Fighting Withdrawal'),
];

// Pool D — Defend vs Defend: roll D6 to determine who attacks
const _poolD = [
  _MissionEntry(die: '1', id: 'breakthrough',  label: 'Breakthrough'),
  _MissionEntry(die: '2', id: 'counterattack', label: 'Counterattack'),
  _MissionEntry(die: '3', id: 'dust_up',       label: 'Dust Up'),
  _MissionEntry(die: '4', id: 'encounter',     label: 'Encounter'),
  _MissionEntry(die: '5', id: 'free_for_all',  label: 'Free for All'),
  _MissionEntry(die: '6', id: 'free_for_all',  label: 'Free for All'),
];

// ── Extended Battle Plans (Missions Pack April 2023) ─────────────────────────
// Same-plan pools — roll D6, winner of a separate roll attacks
const _extBothAttackMissions = [
  _MissionEntry(die: '1', id: 'counterattack',  label: 'Counterattack / Counterstrike'),
  _MissionEntry(die: '2', id: 'dust_up',        label: 'Dust Up'),
  _MissionEntry(die: '3', id: 'encounter',      label: 'Encounter'),
  _MissionEntry(die: '4', id: 'free_for_all',   label: 'Free for All'),
  _MissionEntry(die: '5', id: 'probe',          label: 'Probe'),
  _MissionEntry(die: '6', id: 'scouts_out',     label: 'Scouts Out'),
];

const _extBothManoeuvreMissions = [
  _MissionEntry(die: '1', id: 'counterattack',  label: 'Counterattack / Counterstrike'),
  _MissionEntry(die: '2', id: 'dust_up',        label: 'Dust Up'),
  _MissionEntry(die: '3', id: 'encounter',      label: 'Encounter'),
  _MissionEntry(die: '4', id: 'outflanked',     label: 'Outflanked / Outmanoeuvred'),
  _MissionEntry(die: '5', id: 'probe',          label: 'Probe'),
  _MissionEntry(die: '6', id: 'scouts_out',     label: 'Scouts Out'),
];

const _extBothDefendMissions = [
  _MissionEntry(die: '1', id: 'breakthrough',   label: 'Breakthrough'),
  _MissionEntry(die: '2', id: 'dust_up',        label: 'Dust Up'),
  _MissionEntry(die: '3', id: 'encounter',      label: 'Encounter'),
  _MissionEntry(die: '4', id: 'free_for_all',   label: 'Free for All'),
  _MissionEntry(die: '5', id: 'probe',          label: 'Probe'),
  _MissionEntry(die: '6', id: 'scouts_out',     label: 'Scouts Out'),
];

// Attack vs Manoeuvre (AM / MA) — Attack player attacks
const _extAttackVsManoeuvreMissions = [
  _MissionEntry(die: '1', id: 'breakthrough',        label: 'Breakthrough'),
  _MissionEntry(die: '2', id: 'counterattack',       label: 'Counterattack / Counterstrike'),
  _MissionEntry(die: '3', id: 'escape',              label: 'Escape'),
  _MissionEntry(die: '4', id: 'fighting_withdrawal', label: 'Fighting Withdrawal / Covering Force'),
  _MissionEntry(die: '5', id: 'spearpoint',          label: 'Spearpoint / Bypass'),
  _MissionEntry(die: '6', id: 'valley_of_death',     label: 'Valley of Death'),
];

// Attack vs Defend (AD / DA) — Attack player attacks
const _extAttackVsDefendMissions = [
  _MissionEntry(die: '1', id: 'bridgehead',           label: 'Bridgehead'),
  _MissionEntry(die: '2', id: 'dogfight',             label: 'Dogfight'),
  _MissionEntry(die: '3', id: 'encirclement',         label: 'Encirclement / Hold the Pocket'),
  _MissionEntry(die: '4', id: 'fighting_withdrawal',  label: 'Fighting Withdrawal / Covering Force'),
  _MissionEntry(die: '5', id: 'killing_ground',       label: 'Killing Ground / It\'s a Trap'),
  _MissionEntry(die: '6', id: 'no_retreat',           label: 'No Retreat'),
];

// Manoeuvre vs Defend (MD / DM) — Manoeuvre player attacks
const _extManoeuvreVsDefendMissions = [
  _MissionEntry(die: '1', id: 'breakthrough',         label: 'Breakthrough'),
  _MissionEntry(die: '2', id: 'cornered',             label: 'Cornered'),
  _MissionEntry(die: '3', id: 'no_retreat',           label: 'No Retreat'),
  _MissionEntry(die: '4', id: 'outflanked',           label: 'Outflanked / Outmanoeuvred'),
  _MissionEntry(die: '5', id: 'spearpoint',           label: 'Spearpoint / Bypass'),
  _MissionEntry(die: '6', id: 'valley_of_death',      label: 'Valley of Death'),
];

class _MissionEntry {
  final String die;
  final String id;
  final String label;
  const _MissionEntry({required this.die, required this.id, required this.label});
}

// ─────────────────────────────────────────────────────────────────────────────

enum _Step { selectPlans, rollMission, choose, result }

class MissionRandomizerScreen extends StatefulWidget {
  const MissionRandomizerScreen({super.key});

  @override
  State<MissionRandomizerScreen> createState() => _MissionRandomizerScreenState();
}

class _MissionRandomizerScreenState extends State<MissionRandomizerScreen>
    with SingleTickerProviderStateMixin {
  _Plan _p1Plan = _Plan.none;
  _Plan _p2Plan = _Plan.none;
  bool _revealed = false;
  _Outcome? _outcome;

  _Step _step = _Step.selectPlans;
  bool _isRolling = false;
  int _dieValue = 1;
  Mission? _selectedMission;
  bool _extendedMode = true;
  _MissionEntry? _pendingEntry;

  late AnimationController _rollAnim;
  final _rng = Random();

  @override
  void initState() {
    super.initState();
    _rollAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
  }

  @override
  void dispose() {
    _rollAnim.dispose();
    super.dispose();
  }

  bool get _bothChosen =>
      _p1Plan != _Plan.none && _p2Plan != _Plan.none;

  void _reveal() {
    setState(() {
      _revealed = true;
      _outcome = _resolve(_p1Plan, _p2Plan);
    });
  }

  void _reset() {
    setState(() {
      _p1Plan = _Plan.none;
      _p2Plan = _Plan.none;
      _revealed = false;
      _outcome = null;
      _step = _Step.selectPlans;
      _isRolling = false;
      _dieValue = 1;
      _selectedMission = null;
      _pendingEntry = null;
    });
  }

  Future<void> _roll() async {
    setState(() { _isRolling = true; _selectedMission = null; });
    _rollAnim.reset();

    final table = _currentTable();
    final faces = table.length; // 3 or 6
    // Spin animation
    for (int i = 0; i < 20; i++) {
      await Future.delayed(const Duration(milliseconds: 45));
      if (mounted) setState(() => _dieValue = _rng.nextInt(faces) + 1);
    }
    await _rollAnim.forward();
    final roll = _rng.nextInt(faces) + 1;
    setState(() { _dieValue = roll; _isRolling = false; });

    final entry = table[roll - 1];

    if (entry.label.contains(' / ')) {
      // Extended mode variant choice
      setState(() { _step = _Step.choose; _pendingEntry = entry; });
    } else {
      final mission = fowMissions.firstWhere((m) => m.id == entry.id, orElse: () => fowMissions.first);
      setState(() { _selectedMission = mission; _step = _Step.result; });
    }
  }

  void _chooseMission(String id) {
    final mission = fowMissions.firstWhere((m) => m.id == id, orElse: () => fowMissions.first);
    setState(() { _selectedMission = mission; _step = _Step.result; _pendingEntry = null; });
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RANDOM MISSION'),
        actions: [
          if (_step != _Step.selectPlans)
            IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: 'Start over',
              onPressed: _reset,
            ),
        ],
      ),
      body: Column(
        children: [
          _StepBar(step: _step),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: SingleChildScrollView(
                key: ValueKey(_step),
                padding: const EdgeInsets.all(16),
                child: _buildStep(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep() {
    switch (_step) {
      case _Step.selectPlans:   return _buildSelectPlans();
      case _Step.rollMission:   return _buildRoll();
      case _Step.choose:        return _buildChoose();
      case _Step.result:        return _buildResult();
    }
  }

  // ── Step 1 — Select Battle Plans ──────────────────────────────────────────

  Widget _buildSelectPlans() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // How it works
        // Two concepts explained
        const _TwoConceptsBox(),
        const SizedBox(height: 16),

        // 3×3 combination table
        const SectionHeader(title: 'Combination Table', icon: Icons.table_chart_outlined, color: AppColors.khaki),
        _CombinationTable(
          p1Plan: _revealed ? _p1Plan : _Plan.none,
          p2Plan: _revealed ? _p2Plan : _Plan.none,
          locked: !_revealed && (_p1Plan != _Plan.none || _p2Plan != _Plan.none),
          extendedMode: _extendedMode,
        ),
        const SizedBox(height: 20),

        // Mode toggle
        Container(
          decoration: BoxDecoration(
            color: AppColors.darkCard,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.divider),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _extendedMode ? 'EXTENDED BATTLE PLANS' : 'STANDARD BATTLE PLANS',
                    style: TextStyle(
                      color: _extendedMode ? AppColors.amber : AppColors.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _extendedMode ? 'Missions Pack (April 2023)' : 'More Missions (2017)',
                    style: const TextStyle(color: AppColors.textMuted, fontSize: 10),
                  ),
                ],
              ),
              Switch(
                value: _extendedMode,
                onChanged: (v) => setState(() { _extendedMode = v; }),
                activeColor: AppColors.amber,
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Player selectors
        const SectionHeader(title: 'Choose Your Battle Plan', icon: Icons.touch_app_outlined, color: AppColors.lightOlive),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _PlanSelector(
              label: 'PLAYER 1',
              color: AppColors.attackerBlue,
              selected: _p1Plan,
              revealed: _revealed,
              onPick: (p) { if (!_revealed) setState(() => _p1Plan = p); },
            )),
            const SizedBox(width: 10),
            Expanded(child: _PlanSelector(
              label: 'PLAYER 2',
              color: AppColors.defenderBrown,
              selected: _p2Plan,
              revealed: _revealed,
              onPick: (p) { if (!_revealed) setState(() => _p2Plan = p); },
            )),
          ],
        ),
        const SizedBox(height: 16),

        if (!_revealed) ...[
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: _bothChosen ? AppColors.olive : AppColors.darkCard,
                foregroundColor: _bothChosen ? AppColors.cream : AppColors.textMuted,
                padding: const EdgeInsets.symmetric(vertical: 14),
                side: _bothChosen ? null : const BorderSide(color: AppColors.divider),
              ),
              icon: const Icon(Icons.visibility),
              label: const Text('REVEAL BATTLE PLANS', style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 1.5)),
              onPressed: _bothChosen ? _reveal : null,
            ),
          ),
          if (!_bothChosen)
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Center(child: Text('Both players must choose before revealing',
                  style: TextStyle(color: AppColors.textMuted, fontSize: 11))),
            ),
        ] else ...[
          _OutcomeBanner(outcome: _outcome!, p1Name: 'Player 1', p2Name: 'Player 2', p1Plan: _p1Plan, p2Plan: _p2Plan),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.olive,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              icon: const Icon(Icons.casino_outlined),
              label: const Text('PROCEED TO DICE ROLL', style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 1.5)),
              onPressed: () => setState(() => _step = _Step.rollMission),
            ),
          ),
        ],
        const SizedBox(height: 24),
      ],
    );
  }

  // ── Step 2 — Roll ─────────────────────────────────────────────────────────

  // In Extended, only same-plan matchups roll for attacker.
  // Attack beats Manoeuvre and Defend; Manoeuvre beats Defend.
  bool get _effectiveRollForAttacker =>
      _extendedMode ? (_p1Plan == _p2Plan) : _outcome!.rollForAttacker;

  bool get _effectiveP1Attacks {
    if (!_extendedMode) return _outcome!.p1Attacks;
    // Extended: highest-aggression plan attacks
    if (_p1Plan == _Plan.attack)    return true;
    if (_p2Plan == _Plan.attack)    return false;
    if (_p1Plan == _Plan.manoeuvre) return true;
    return false; // P1=Defend, P2=Manoeuvre
  }

  List<_MissionEntry> _currentTable() {
    if (_extendedMode) {
      // Same plans → Roll to see who attacks
      if (_p1Plan == _p2Plan) {
        if (_p1Plan == _Plan.attack)    return _extBothAttackMissions;
        if (_p1Plan == _Plan.manoeuvre) return _extBothManoeuvreMissions;
        return _extBothDefendMissions;
      }
      // Attack vs Manoeuvre (either direction)
      if ((_p1Plan == _Plan.attack    && _p2Plan == _Plan.manoeuvre) ||
          (_p1Plan == _Plan.manoeuvre && _p2Plan == _Plan.attack)) {
        return _extAttackVsManoeuvreMissions;
      }
      // Attack vs Defend (either direction)
      if ((_p1Plan == _Plan.attack && _p2Plan == _Plan.defend) ||
          (_p1Plan == _Plan.defend && _p2Plan == _Plan.attack)) {
        return _extAttackVsDefendMissions;
      }
      // Manoeuvre vs Defend (either direction)
      return _extManoeuvreVsDefendMissions;
    }
    // Standard mode — use pool from outcome
    switch (_outcome!.pool) {
      case _Pool.a: return _poolA;
      case _Pool.b: return _poolB;
      case _Pool.c: return _poolC;
      case _Pool.d: return _poolD;
      case _Pool.e: return _poolE;
    }
  }

  Widget _buildRoll() {
    final rollForAttacker = _effectiveRollForAttacker;
    final pool = _outcome!.pool;
    final table = _currentTable();
    final faces = table.length;
    final accent = rollForAttacker ? AppColors.amber : AppColors.attackerBlue;

    String sectionTitle;
    if (_extendedMode) {
      sectionTitle = _p1Plan == _p2Plan
          ? 'Extended — Same Plan Pool — Roll 1D6'
          : 'Extended Battle Plans — Roll 1D6';
    } else {
      sectionTitle = 'Pool ${pool.name.toUpperCase()} — Roll 1D$faces';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _OutcomeBanner(outcome: _outcome!, p1Name: 'Player 1', p2Name: 'Player 2', p1Plan: _p1Plan, p2Plan: _p2Plan),
        const SizedBox(height: 20),

        SectionHeader(
          title: sectionTitle,
          icon: Icons.table_chart_outlined,
          color: accent,
        ),
        _MissionTable(entries: table, highlightDie: _isRolling ? _dieValue : null,
            accent: accent),
        const SizedBox(height: 24),

        // Dice
        Center(child: _DiceWidget(value: _dieValue, faces: faces, isRolling: _isRolling)),
        const SizedBox(height: 24),

        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: _isRolling ? AppColors.darkCard : AppColors.bloodRed,
              foregroundColor: _isRolling ? AppColors.textMuted : AppColors.cream,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            icon: AnimatedRotation(
              turns: _isRolling ? 2 : 0,
              duration: const Duration(milliseconds: 900),
              child: const Icon(Icons.casino, size: 24),
            ),
            label: Text(_isRolling ? 'ROLLING...' : 'ROLL THE DICE',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, letterSpacing: 2.5)),
            onPressed: _isRolling ? null : _roll,
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  // ── Step 3 — Choose (on D6 = 6, or extended variant) ────────────────────

  Widget _buildChoose() {
    // Extended mode: variant choice from _pendingEntry label (split at ' / ')
    if (_pendingEntry != null) {
      final parts = _pendingEntry!.label.split(' / ');
      // Build a list of _MissionEntry from the variant ids in the label.
      // The primary id is in _pendingEntry.id; we look up the variant by name.
      final primaryId = _pendingEntry!.id;
      // Find the variant id by matching name against fowMissions
      final variantName = parts.length > 1 ? parts[1].trim() : '';
      final variantMission = fowMissions.where(
        (m) => m.name.toLowerCase() == variantName.toLowerCase(),
      ).firstOrNull;
      final primaryMission = fowMissions.firstWhere(
        (m) => m.id == primaryId, orElse: () => fowMissions.first);

      final choiceEntries = <(Mission, String)>[
        (primaryMission, parts[0].trim()),
        if (variantMission != null) (variantMission, variantName),
      ];

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _OutcomeBanner(outcome: _outcome!, p1Name: 'Player 1', p2Name: 'Player 2', p1Plan: _p1Plan, p2Plan: _p2Plan),
          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.amber.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.amber.withValues(alpha: 0.4)),
            ),
            child: Row(children: [
              Container(
                width: 44, height: 44,
                decoration: BoxDecoration(
                  color: AppColors.amber.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppColors.amber),
                ),
                child: Center(child: Text('$_dieValue', style: const TextStyle(
                    color: AppColors.amber, fontSize: 22, fontWeight: FontWeight.w900))),
              ),
              const SizedBox(width: 14),
              const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('VARIANT RESULT', style: TextStyle(color: AppColors.amber, fontSize: 12,
                    fontWeight: FontWeight.w800, letterSpacing: 1.5)),
                SizedBox(height: 4),
                Text('Two variants are available. Choose which one to play.',
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 13, height: 1.4)),
              ])),
            ]),
          ),
          const SizedBox(height: 20),

          const SectionHeader(title: 'Choose Variant', icon: Icons.military_tech, color: AppColors.gold),

          ...choiceEntries.map((pair) {
            final (mission, _) = pair;
            return _ChoiceCard(
              mission: mission,
              onChoose: () => _chooseMission(mission.id),
            );
          }),
          const SizedBox(height: 24),
        ],
      );
    }

    // Fallback — should not be reached in standard mode
    return const SizedBox.shrink();
  }

  // ── Step 4 — Result ───────────────────────────────────────────────────────

  Widget _buildResult() {
    final mission = _selectedMission!;
    final rollForAttacker = _effectiveRollForAttacker;
    final typeColor = rollForAttacker ? AppColors.amber : AppColors.attackerBlue;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Big result card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
          decoration: BoxDecoration(
            color: typeColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: typeColor.withValues(alpha: 0.5), width: 2),
          ),
          child: Column(children: [
            Text('MISSION SELECTED', style: TextStyle(
                color: typeColor.withValues(alpha: 0.7), fontSize: 11,
                letterSpacing: 3.0, fontWeight: FontWeight.w700)),
            const SizedBox(height: 10),
            Text(mission.name.toUpperCase(), textAlign: TextAlign.center,
                style: TextStyle(color: typeColor, fontSize: 28,
                    fontWeight: FontWeight.w900, letterSpacing: 2.0)),
            const SizedBox(height: 6),
            Text('"${mission.tagline}"', textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textSecondary,
                    fontSize: 13, fontStyle: FontStyle.italic)),
            const SizedBox(height: 14),
            // Die result badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.darkCard,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: AppColors.divider),
              ),
              child: Text(
                'Rolled: $_dieValue',
                style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
              ),
            ),
          ]),
        ),
        const SizedBox(height: 16),

        // Attacker / Defender assignment (only when attacker is fixed)
        if (!rollForAttacker) ...[
          _AttackerBanner(
            attacker: _effectiveP1Attacks ? 'Player 1' : 'Player 2',
            defender: _effectiveP1Attacks ? 'Player 2' : 'Player 1',
            attackerPlan: _effectiveP1Attacks ? _p1Plan : _p2Plan,
            defenderPlan: _effectiveP1Attacks ? _p2Plan : _p1Plan,
          ),
          const SizedBox(height: 16),
        ],

        // Quick mission info
        InfoCard(
          title: 'Overview',
          body: mission.overview,
          borderColor: typeColor,
        ),
        InfoCard(
          title: 'Victory Conditions',
          body: mission.victoryConditions.map((v) => '• ${v.title}: ${v.description}').join('\n\n'),
          icon: Icons.military_tech_outlined,
          borderColor: AppColors.gold,
        ),
        const SizedBox(height: 16),

        // Actions
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.olive, padding: const EdgeInsets.symmetric(vertical: 16)),
            icon: const Icon(Icons.sports_esports),
            label: const Text('PLAY THIS MISSION',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, letterSpacing: 2.0)),
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => MissionDetailScreen(mission: mission))),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            icon: const Icon(Icons.menu_book_outlined),
            label: const Text('VIEW FULL MISSION RULES'),
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => MissionDetailScreen(mission: mission, referenceOnly: true))),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: TextButton.icon(
            icon: const Icon(Icons.refresh, color: AppColors.textMuted),
            label: const Text('ROLL AGAIN', style: TextStyle(color: AppColors.textMuted)),
            onPressed: _reset,
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

// ── Widgets ───────────────────────────────────────────────────────────────────

class _StepBar extends StatelessWidget {
  final _Step step;
  const _StepBar({required this.step});

  static const _labels = ['BATTLE PLANS', 'ROLL', 'RESULT'];

  @override
  Widget build(BuildContext context) {
    // Map choose step visually to "ROLL" dot
    final visualIndex = step == _Step.choose ? 1 : step.index > 2 ? 2 : step.index;
    return Container(
      color: AppColors.darkCard,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
      child: Row(
        children: List.generate(3, (i) {
          final done = visualIndex > i;
          final active = visualIndex == i;
          final color = active ? AppColors.khaki : done ? AppColors.lightOlive : AppColors.textMuted;
          return [
            Column(mainAxisSize: MainAxisSize.min, children: [
              Container(width: 10, height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: done || active ? color : Colors.transparent,
                  border: Border.all(color: color, width: 1.5),
                ),
                child: done ? const Icon(Icons.check, size: 6, color: AppColors.darkGrey) : null,
              ),
              const SizedBox(height: 4),
              Text(_labels[i], style: TextStyle(color: color, fontSize: 8,
                  fontWeight: active ? FontWeight.w800 : FontWeight.w500, letterSpacing: 1.0)),
            ]),
            if (i < 2)
              Expanded(child: Container(height: 1.5, margin: const EdgeInsets.only(bottom: 16, left: 4, right: 4),
                  color: done ? AppColors.lightOlive : AppColors.divider)),
          ];
        }).expand((e) => e).toList(),
      ),
    );
  }
}

// ── 3×3 Combination Table ─────────────────────────────────────────────────────

class _CombinationTable extends StatelessWidget {
  final _Plan p1Plan;
  final _Plan p2Plan;
  final bool locked;
  final bool extendedMode;
  const _CombinationTable({required this.p1Plan, required this.p2Plan, this.locked = false, this.extendedMode = false});

  static const _plans = [_Plan.attack, _Plan.manoeuvre, _Plan.defend];
  static const _planLabels = {
    _Plan.attack: 'ATTACK',
    _Plan.defend: 'DEFEND',
    _Plan.manoeuvre: 'MANOEUVRE',
  };
  static const _planIcons = {
    _Plan.attack: Icons.arrow_upward,
    _Plan.defend: Icons.shield_outlined,
    _Plan.manoeuvre: Icons.swap_horiz,
  };
  static const _planColors = {
    _Plan.attack: AppColors.red,
    _Plan.defend: AppColors.defenderBrown,
    _Plan.manoeuvre: AppColors.amber,
  };

  String _cellLabel(_Plan row, _Plan col) {
    final out = _resolve(row, col);
    if (out.rollForAttacker) return 'Roll for Attacker';
    return out.p1Attacks ? 'P1 Attacks' : 'P2 Attacks';
  }

  Color _cellColor(_Plan row, _Plan col) {
    final out = _resolve(row, col);
    if (out.rollForAttacker) return AppColors.amber;
    return out.p1Attacks ? AppColors.attackerBlue : AppColors.defenderBrown;
  }

  List<String> _cellMissions(_Plan row, _Plan col) {
    if (extendedMode) {
      if (row == col) {
        if (row == _Plan.attack)    return ['Counterattack/CS', 'Dust Up', 'Encounter', 'Free for All', 'Probe', 'Scouts Out'];
        if (row == _Plan.manoeuvre) return ['Counterattack/CS', 'Dust Up', 'Encounter', 'Outflanked', 'Probe', 'Scouts Out'];
        return                             ['Breakthrough', 'Dust Up', 'Encounter', 'Free for All', 'Probe', 'Scouts Out'];
      }
      final a = row == _Plan.attack   || col == _Plan.attack;
      final m = row == _Plan.manoeuvre || col == _Plan.manoeuvre;
      final d = row == _Plan.defend   || col == _Plan.defend;
      if (a && m) return ['Breakthrough', 'Counterattack/CS', 'Escape', 'Fighting Withdrawal', 'Spearpoint', 'Valley of Death'];
      if (a && d) return ['Bridgehead', 'Dogfight', 'Encirclement', 'Fighting Withdrawal', 'Killing Ground', 'No Retreat'];
      if (m && d) return ['Breakthrough', 'Cornered', 'No Retreat', 'Outflanked', 'Spearpoint', 'Valley of Death'];
    }
    final pool = _resolve(row, col).pool;
    switch (pool) {
      case _Pool.a: return ['Breakthrough', 'Counterattack', 'Dust Up', 'Encounter', 'Free for All'];
      case _Pool.e: return ['Breakthrough', 'Probe', 'Counterattack', 'Counterattack', 'Dust Up', 'Encounter'];
      case _Pool.b: return ['Bridgehead', 'No Retreat', 'Fighting Withdrawal'];
      case _Pool.c: return ['Breakthrough', 'Bridgehead', 'Probe', 'No Retreat', 'Fighting Withdrawal'];
      case _Pool.d: return ['Breakthrough', 'Counterattack', 'Dust Up', 'Encounter', 'Free for All'];
    }
  }

  bool _isHighlighted(_Plan row, _Plan col) =>
      p1Plan != _Plan.none && p2Plan != _Plan.none && row == p1Plan && col == p2Plan;

  @override
  Widget build(BuildContext context) {
    const headerStyle = TextStyle(color: AppColors.textMuted, fontSize: 9,
        fontWeight: FontWeight.w700, letterSpacing: 1.2);

    final table = Container(
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(children: [
        // Column headers (P2's choices)
        Container(
          decoration: const BoxDecoration(
            color: AppColors.darkOlive,
            borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
          ),
          child: Row(children: [
            const SizedBox(width: 90), // corner gap
            ..._plans.map((p) => Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(children: [
                  Icon(_planIcons[p], color: _planColors[p], size: 12),
                  const SizedBox(height: 2),
                  Text(_planLabels[p]!, style: headerStyle.copyWith(color: _planColors[p])),
                  const Text('P2', style: TextStyle(color: AppColors.textMuted, fontSize: 7, letterSpacing: 1.0)),
                ]),
              ),
            )),
          ]),
        ),

        // Rows (P1's choices)
        ..._plans.map((row) => Column(children: [
          Container(
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(
                  color: row == _plans.last ? Colors.transparent : AppColors.divider)),
            ),
            child: IntrinsicHeight(child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              // Row header
              Container(
                width: 90,
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                decoration: const BoxDecoration(
                  border: Border(right: BorderSide(color: AppColors.divider)),
                ),
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(_planIcons[row], color: _planColors[row], size: 12),
                  const SizedBox(height: 2),
                  Text(_planLabels[row]!, style: headerStyle.copyWith(color: _planColors[row])),
                  const Text('P1', style: TextStyle(color: AppColors.textMuted, fontSize: 7, letterSpacing: 1.0)),
                ]),
              ),
              // Cells
              ..._plans.map((col) {
                final highlighted = _isHighlighted(row, col);
                final cellColor = _cellColor(row, col);
                return Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                    decoration: BoxDecoration(
                      color: highlighted ? cellColor.withValues(alpha: 0.18) : Colors.transparent,
                      border: Border(
                        left: const BorderSide(color: AppColors.divider),
                        right: highlighted ? BorderSide(color: cellColor, width: 2) : BorderSide.none,
                      ),
                    ),
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      if (highlighted)
                        Icon(Icons.arrow_back, color: cellColor, size: 10),
                      Text(
                        _cellLabel(row, col),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: highlighted ? cellColor : cellColor.withValues(alpha: 0.7),
                          fontSize: 9,
                          fontWeight: highlighted ? FontWeight.w800 : FontWeight.w500,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 4),
                      ..._cellMissions(row, col).map((m) => Text(
                        m,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.textMuted.withValues(alpha: highlighted ? 0.9 : 0.6),
                          fontSize: 7,
                          height: 1.4,
                        ),
                      )),
                    ]),
                  ),
                );
              }),
            ])),
          ),
        ])),
      ]),
    );

    if (!locked) return table;

    return Stack(
      children: [
        table,
        Positioned.fill(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              color: AppColors.darkCard.withValues(alpha: 0.82),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.lock_outline, color: AppColors.lightOlive, size: 28),
                  SizedBox(height: 8),
                  Text('PLANS CHOSEN', style: TextStyle(
                      color: AppColors.lightOlive, fontSize: 11,
                      fontWeight: FontWeight.w800, letterSpacing: 1.5)),
                  SizedBox(height: 4),
                  Text('Waiting for reveal', style: TextStyle(
                      color: AppColors.textMuted, fontSize: 10)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Plan Selector ─────────────────────────────────────────────────────────────

class _PlanSelector extends StatelessWidget {
  final String label;
  final Color color;
  final _Plan selected;
  final bool revealed;
  final ValueChanged<_Plan> onPick;

  const _PlanSelector({
    required this.label,
    required this.color,
    required this.selected,
    required this.revealed,
    required this.onPick,
  });

  static const _options = [
    ('ATTACK',     Icons.arrow_upward,    _Plan.attack,    AppColors.red),
    ('MANOEUVRE',  Icons.swap_horiz,      _Plan.manoeuvre, AppColors.amber),
    ('DEFEND',     Icons.shield_outlined, _Plan.defend,    AppColors.defenderBrown),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: selected != _Plan.none ? color : AppColors.divider,
          width: selected != _Plan.none ? 1.5 : 1.0,
        ),
      ),
      child: Column(children: [
        Text(label, style: TextStyle(color: color, fontSize: 11,
            fontWeight: FontWeight.w800, letterSpacing: 1.5)),
        const SizedBox(height: 10),
        if (revealed && selected != _Plan.none)
          _RevealedPlan(plan: selected)
        else if (!revealed && selected != _Plan.none)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              color: AppColors.darkGrey,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: AppColors.lightOlive.withValues(alpha: 0.5)),
            ),
            child: Column(children: [
              Icon(Icons.lock_outline, color: AppColors.lightOlive, size: 24),
              const SizedBox(height: 8),
              const Text('PLAN CHOSEN', style: TextStyle(
                  color: AppColors.lightOlive, fontSize: 10,
                  fontWeight: FontWeight.w800, letterSpacing: 1.5)),
              const SizedBox(height: 4),
              const Text('waiting for reveal', style: TextStyle(
                  color: AppColors.textMuted, fontSize: 9)),
            ]),
          )
        else
          Column(children: _options.map((opt) {
            final (lbl, icon, plan, optColor) = opt;
            final isSel = selected == plan;
            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: GestureDetector(
                onTap: () => onPick(plan),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: isSel ? optColor.withValues(alpha: 0.18) : AppColors.darkGrey,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: isSel ? optColor : AppColors.divider,
                      width: isSel ? 1.5 : 1,
                    ),
                  ),
                  child: Column(children: [
                    Icon(icon, color: isSel ? optColor : AppColors.textMuted, size: 16),
                    const SizedBox(height: 4),
                    Text(lbl, style: TextStyle(
                        color: isSel ? optColor : AppColors.textMuted,
                        fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: 1.2)),
                  ]),
                ),
              ),
            );
          }).toList()),
      ]),
    );
  }
}

class _RevealedPlan extends StatelessWidget {
  final _Plan plan;
  const _RevealedPlan({required this.plan});

  static const _data = {
    _Plan.attack:    ('ATTACK',    Icons.arrow_upward,    AppColors.red),
    _Plan.defend:    ('DEFEND',    Icons.shield_outlined, AppColors.defenderBrown),
    _Plan.manoeuvre: ('MANOEUVRE', Icons.swap_horiz,      AppColors.amber),
  };

  @override
  Widget build(BuildContext context) {
    final (lbl, icon, color) = _data[plan]!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.6)),
      ),
      child: Column(children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 6),
        Text(lbl, style: TextStyle(color: color, fontSize: 14,
            fontWeight: FontWeight.w900, letterSpacing: 1.5)),
      ]),
    );
  }
}

// ── Outcome Banner ────────────────────────────────────────────────────────────

class _OutcomeBanner extends StatelessWidget {
  final _Outcome outcome;
  final String p1Name;
  final String p2Name;
  final _Plan p1Plan;
  final _Plan p2Plan;

  const _OutcomeBanner({
    required this.outcome,
    required this.p1Name,
    required this.p2Name,
    required this.p1Plan,
    required this.p2Plan,
  });

  @override
  Widget build(BuildContext context) {
    final color = outcome.rollForAttacker ? AppColors.amber : AppColors.attackerBlue;
    final poolName = outcome.pool.name.toUpperCase();
    final dieSize = outcome.pool == _Pool.b ? 3 : 6;
    final poolLabel = outcome.rollForAttacker
        ? 'POOL $poolName — Roll D$dieSize (also roll to determine who attacks)'
        : 'POOL $poolName — Roll D$dieSize';
    final String detail;
    if (outcome.rollForAttacker) {
      detail = 'Both players roll off — higher roll is the Attacker';
    } else {
      final attacker = outcome.p1Attacks ? p1Name : p2Name;
      final defender = outcome.p1Attacks ? p2Name : p1Name;
      detail = '$attacker attacks • $defender defends';
    }

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Row(children: [
        Icon(outcome.rollForAttacker ? Icons.casino_outlined : Icons.arrow_forward, color: color, size: 20),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(poolLabel, style: TextStyle(color: color, fontSize: 11,
              fontWeight: FontWeight.w800, letterSpacing: 1.5)),
          const SizedBox(height: 3),
          Text(detail, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
        ])),
      ]),
    );
  }
}

// ── Attacker / Defender assignment banner ────────────────────────────────────

class _AttackerBanner extends StatelessWidget {
  final String attacker;
  final String defender;
  final _Plan attackerPlan;
  final _Plan defenderPlan;

  const _AttackerBanner({
    required this.attacker,
    required this.defender,
    required this.attackerPlan,
    required this.defenderPlan,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(children: [
        Expanded(child: _RoleChip(name: attacker, role: 'ATTACKER',
            plan: attackerPlan, color: AppColors.attackerBlue)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(children: [
            Container(width: 1, height: 36, color: AppColors.divider),
          ]),
        ),
        Expanded(child: _RoleChip(name: defender, role: 'DEFENDER',
            plan: defenderPlan, color: AppColors.defenderBrown, alignRight: true)),
      ]),
    );
  }
}

class _RoleChip extends StatelessWidget {
  final String name;
  final String role;
  final _Plan plan;
  final Color color;
  final bool alignRight;

  const _RoleChip({required this.name, required this.role, required this.plan,
      required this.color, this.alignRight = false});

  static const _planLabels = {
    _Plan.attack: 'Attack', _Plan.defend: 'Defend', _Plan.manoeuvre: 'Manoeuvre',
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignRight ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(role, style: TextStyle(color: color.withValues(alpha: 0.7), fontSize: 9,
            letterSpacing: 1.5, fontWeight: FontWeight.w700)),
        Text(name, style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.w800)),
        Text('Battle Plan: ${_planLabels[plan] ?? ''}',
            style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
      ],
    );
  }
}

// ── Mission Roll Table ────────────────────────────────────────────────────────

class _MissionTable extends StatelessWidget {
  final List<_MissionEntry> entries;
  final int? highlightDie;
  final Color accent;

  const _MissionTable({required this.entries, this.highlightDie, required this.accent});

  bool _isHighlighted(_MissionEntry e) {
    if (highlightDie == null) return false;
    return int.tryParse(e.die) == highlightDie;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: const BoxDecoration(color: AppColors.darkOlive,
              borderRadius: BorderRadius.vertical(top: Radius.circular(8))),
          child: const Row(children: [
            SizedBox(width: 44, child: Text('ROLL', style: TextStyle(color: AppColors.textMuted,
                fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: 1.5))),
            Expanded(child: Text('MISSION', style: TextStyle(color: AppColors.textMuted,
                fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: 1.5))),
          ]),
        ),
        ...entries.asMap().entries.map((kv) {
          final i = kv.key;
          final e = kv.value;
          final last = i == entries.length - 1;
          final hi = _isHighlighted(e);
          return Container(
            decoration: BoxDecoration(
              color: hi ? accent.withValues(alpha: 0.12) : Colors.transparent,
              border: Border(
                bottom: last ? BorderSide.none : const BorderSide(color: AppColors.divider),
                left: hi ? BorderSide(color: accent, width: 3) : BorderSide.none,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
            child: Row(children: [
              SizedBox(
                width: 44,
                child: Container(
                  width: 28, height: 28,
                  decoration: BoxDecoration(
                    color: hi ? accent.withValues(alpha: 0.3) : AppColors.darkGrey,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: hi ? accent : AppColors.divider,
                        width: hi ? 1.5 : 1),
                  ),
                  child: Center(child: Text(e.die, style: TextStyle(
                      color: hi ? accent : AppColors.textMuted,
                      fontSize: 13, fontWeight: FontWeight.w800))),
                ),
              ),
              Expanded(child: Text(e.label, style: TextStyle(
                  color: hi ? AppColors.cream : AppColors.textPrimary,
                  fontSize: 13,
                  fontWeight: hi ? FontWeight.w700 : FontWeight.w400))),
              if (hi) Icon(Icons.chevron_left, color: accent, size: 16),
            ]),
          );
        }),
      ]),
    );
  }
}

// ── Choice Card ───────────────────────────────────────────────────────────────

class _ChoiceCard extends StatelessWidget {
  final Mission mission;
  final VoidCallback onChoose;

  const _ChoiceCard({required this.mission, required this.onChoose});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.4)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(mission.name.toUpperCase(), style: const TextStyle(color: AppColors.cream,
                fontSize: 16, fontWeight: FontWeight.w800, letterSpacing: 1.5)),
            const SizedBox(height: 4),
            Text('"${mission.tagline}"', style: const TextStyle(
                color: AppColors.textSecondary, fontSize: 12, fontStyle: FontStyle.italic)),
            const SizedBox(height: 8),
            Text(mission.victoryConditions.first.title,
                style: const TextStyle(color: AppColors.gold, fontSize: 12, fontWeight: FontWeight.w600)),
          ]),
        ),
        InkWell(
          onTap: onChoose,
          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(8)),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: const BoxDecoration(
              color: AppColors.olive,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(8)),
            ),
            child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.check_circle_outline, color: AppColors.cream, size: 16),
              SizedBox(width: 8),
              Text('CHOOSE THIS MISSION', style: TextStyle(color: AppColors.cream,
                  fontSize: 12, fontWeight: FontWeight.w800, letterSpacing: 1.5)),
            ]),
          ),
        ),
      ]),
    );
  }
}

// ── Dice Widget ───────────────────────────────────────────────────────────────

class _DiceWidget extends StatelessWidget {
  final int value;
  final int faces;
  final bool isRolling;

  const _DiceWidget({required this.value, required this.faces, required this.isRolling});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      AnimatedContainer(
        duration: const Duration(milliseconds: 80),
        width: 90, height: 90,
        decoration: BoxDecoration(
          color: isRolling ? AppColors.darkCard : AppColors.olive.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: isRolling ? AppColors.textMuted : AppColors.khaki, width: 2),
          boxShadow: isRolling ? [] : [
            BoxShadow(color: AppColors.khaki.withValues(alpha: 0.3), blurRadius: 14, spreadRadius: 2),
          ],
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text('$value', style: TextStyle(
              color: isRolling ? AppColors.textMuted : AppColors.cream,
              fontSize: 40, fontWeight: FontWeight.w900, height: 1.0)),
          Text('D$faces', style: const TextStyle(color: AppColors.textMuted,
              fontSize: 11, letterSpacing: 1.0)),
        ]),
      ),
      const SizedBox(height: 8),
      Text(isRolling ? 'Rolling...' : 'Rolled: $value',
          style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
    ]);
  }
}

// ── Two Concepts explanation box ─────────────────────────────────────────────

class _TwoConceptsBox extends StatelessWidget {
  const _TwoConceptsBox();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: const BoxDecoration(
            color: AppColors.darkOlive,
            borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
          ),
          child: const Row(children: [
            Icon(Icons.info_outline, color: AppColors.khaki, size: 14),
            SizedBox(width: 8),
            Text('HOW MISSION SELECTION WORKS',
                style: TextStyle(color: AppColors.khaki, fontSize: 11,
                    fontWeight: FontWeight.w700, letterSpacing: 1.5)),
          ]),
        ),
        // Concept 1 — Battle Plan
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 0),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              margin: const EdgeInsets.only(top: 2),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.olive.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(3),
                border: Border.all(color: AppColors.khaki.withValues(alpha: 0.6)),
              ),
              child: const Text('STEP 1', style: TextStyle(color: AppColors.khaki,
                  fontSize: 9, fontWeight: FontWeight.w800, letterSpacing: 1.2)),
            ),
            const SizedBox(width: 10),
            const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Choose a Battle Plan secretly', style: TextStyle(color: AppColors.cream,
                  fontSize: 13, fontWeight: FontWeight.w700)),
              SizedBox(height: 4),
              Text(
                'Each player secretly picks one of three Battle Plans — '
                'your choice is locked and hidden until both players have chosen, '
                'then both plans are revealed simultaneously.\n\n'
                '  • Attack — you intend to assault the enemy\n'
                '  • Manoeuvre — flexible, neither purely attacking nor defending\n'
                '  • Defend — you intend to hold your ground',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 12, height: 1.5),
              ),
            ])),
          ]),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Divider(height: 1),
        ),
        // Concept 2 — Mission Type
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              margin: const EdgeInsets.only(top: 2),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.olive.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(3),
                border: Border.all(color: AppColors.khaki.withValues(alpha: 0.6)),
              ),
              child: const Text('STEP 2', style: TextStyle(color: AppColors.khaki,
                  fontSize: 9, fontWeight: FontWeight.w800, letterSpacing: 1.2)),
            ),
            const SizedBox(width: 10),
            const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Mission pool is determined by plan combination', style: TextStyle(color: AppColors.cream,
                  fontSize: 13, fontWeight: FontWeight.w700)),
              SizedBox(height: 4),
              Text(
                'Cross-reference both plans to find the pool, then roll for mission:',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 12, height: 1.5),
              ),
              SizedBox(height: 8),
              _MissionTypeBadgeRow(
                color: AppColors.amber,
                label: 'Pool A — D6',
                desc: 'Same plan (AA / MM) or Attack vs Manoeuvre — roll to determine attacker',
              ),
              SizedBox(height: 6),
              _MissionTypeBadgeRow(
                color: AppColors.attackerBlue,
                label: 'Pool B — D3',
                desc: 'Attack vs Defend — Attack player attacks',
              ),
              SizedBox(height: 6),
              _MissionTypeBadgeRow(
                color: AppColors.lightOlive,
                label: 'Pool C — D6',
                desc: 'Manoeuvre vs Defend — Manoeuvre player attacks',
              ),
              SizedBox(height: 6),
              _MissionTypeBadgeRow(
                color: AppColors.defenderBrown,
                label: 'Pool D — D6',
                desc: 'Defend vs Defend — roll to determine attacker',
              ),
            ])),
          ]),
        ),
      ]),
    );
  }
}

class _MissionTypeBadgeRow extends StatelessWidget {
  final Color color;
  final String label;
  final String desc;
  const _MissionTypeBadgeRow({required this.color, required this.label, required this.desc});

  @override
  Widget build(BuildContext context) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.18),
          borderRadius: BorderRadius.circular(3),
          border: Border.all(color: color.withValues(alpha: 0.5)),
        ),
        child: Text(label, style: TextStyle(color: color, fontSize: 10,
            fontWeight: FontWeight.w700, letterSpacing: 0.8)),
      ),
      const SizedBox(width: 8),
      Expanded(child: Padding(
        padding: const EdgeInsets.only(top: 3),
        child: Text(desc, style: const TextStyle(color: AppColors.textMuted,
            fontSize: 11, height: 1.4)),
      )),
    ]);
  }
}

