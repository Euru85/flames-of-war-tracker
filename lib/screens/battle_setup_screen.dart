import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/mission.dart';
import '../providers/battle_provider.dart';
import '../theme/app_theme.dart';
import 'deployment_screen.dart';

class BattleSetupScreen extends StatefulWidget {
  final Mission mission;

  const BattleSetupScreen({super.key, required this.mission});

  @override
  State<BattleSetupScreen> createState() => _BattleSetupScreenState();
}

class _BattleSetupScreenState extends State<BattleSetupScreen> {
  final _formKey = GlobalKey<FormState>();

  // Player 1
  final _p1NameCtrl = TextEditingController(text: 'Player 1');
  final _p1ArmyCtrl = TextEditingController();
  final _p1PointsCtrl = TextEditingController(text: '95');

  // Player 2
  final _p2NameCtrl = TextEditingController(text: 'Player 2');
  final _p2ArmyCtrl = TextEditingController();
  final _p2PointsCtrl = TextEditingController(text: '95');

  @override
  void dispose() {
    _p1NameCtrl.dispose();
    _p1ArmyCtrl.dispose();
    _p1PointsCtrl.dispose();
    _p2NameCtrl.dispose();
    _p2ArmyCtrl.dispose();
    _p2PointsCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final m = widget.mission;
    final isAttackDefend = m.type == MissionType.attackDefend;

    return Scaffold(
      appBar: AppBar(title: const Text('BATTLE SETUP')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Mission summary chip
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.darkCard,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.divider),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.olive.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(Icons.map_outlined,
                        color: AppColors.khaki, size: 26),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          m.name.toUpperCase(),
                          style: const TextStyle(
                            color: AppColors.cream,
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          isAttackDefend
                              ? 'Attacker vs Defender'
                              : 'Meeting Engagement',
                          style: const TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Player 1
            _PlayerSetupSection(
              playerLabel: isAttackDefend
                  ? m.attackerRole.toUpperCase()
                  : 'PLAYER 1',
              role: isAttackDefend ? '(Attacker)' : '(Goes First)',
              color: AppColors.attackerBlue,
              nameController: _p1NameCtrl,
              armyController: _p1ArmyCtrl,
              pointsController: _p1PointsCtrl,
              namePlaceholder: isAttackDefend ? 'Attacker name' : 'Player 1 name',
              armyPlaceholder: 'e.g. Fallschirmjäger Kompanie',
            ),
            const SizedBox(height: 24),

            // Player 2
            _PlayerSetupSection(
              playerLabel: isAttackDefend
                  ? m.defenderRole.toUpperCase()
                  : 'PLAYER 2',
              role: isAttackDefend ? '(Defender)' : '(Goes Second)',
              color: AppColors.defenderBrown,
              nameController: _p2NameCtrl,
              armyController: _p2ArmyCtrl,
              pointsController: _p2PointsCtrl,
              namePlaceholder: isAttackDefend ? 'Defender name' : 'Player 2 name',
              armyPlaceholder: 'e.g. British Armoured Squadron',
            ),
            const SizedBox(height: 32),

            // Start button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  backgroundColor: AppColors.olive,
                ),
                icon: const Icon(Icons.military_tech, size: 22),
                label: const Text(
                  'COMMENCE DEPLOYMENT',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 2.0,
                  ),
                ),
                onPressed: _startBattle,
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _startBattle() {
    if (!_formKey.currentState!.validate()) return;

    context.read<BattleProvider>().startNewBattle(
          mission: widget.mission,
          player1Name: _p1NameCtrl.text.trim(),
          player1Army: _p1ArmyCtrl.text.trim().isEmpty
              ? 'Unknown Force'
              : _p1ArmyCtrl.text.trim(),
          player1Points: int.tryParse(_p1PointsCtrl.text) ?? 100,
          player2Name: _p2NameCtrl.text.trim(),
          player2Army: _p2ArmyCtrl.text.trim().isEmpty
              ? 'Unknown Force'
              : _p2ArmyCtrl.text.trim(),
          player2Points: int.tryParse(_p2PointsCtrl.text) ?? 100,
        );

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const DeploymentScreen()),
      (route) => route.isFirst,
    );
  }
}

class _PlayerSetupSection extends StatelessWidget {
  final String playerLabel;
  final String role;
  final Color color;
  final TextEditingController nameController;
  final TextEditingController armyController;
  final TextEditingController pointsController;
  final String namePlaceholder;
  final String armyPlaceholder;

  const _PlayerSetupSection({
    required this.playerLabel,
    required this.role,
    required this.color,
    required this.nameController,
    required this.armyController,
    required this.pointsController,
    required this.namePlaceholder,
    required this.armyPlaceholder,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(8),
        border: Border(left: BorderSide(color: color, width: 4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                playerLabel,
                style: TextStyle(
                  color: color,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                role,
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          _FieldLabel('Commander Name'),
          const SizedBox(height: 6),
          TextFormField(
            controller: nameController,
            decoration: InputDecoration(
              hintText: namePlaceholder,
              prefixIcon: const Icon(Icons.person_outline,
                  color: AppColors.textMuted, size: 18),
            ),
            validator: (v) =>
                v == null || v.trim().isEmpty ? 'Enter a name' : null,
            style: const TextStyle(color: AppColors.textPrimary),
          ),
          const SizedBox(height: 12),

          _FieldLabel('Army / Formation'),
          const SizedBox(height: 6),
          TextFormField(
            controller: armyController,
            decoration: InputDecoration(
              hintText: armyPlaceholder,
              prefixIcon: const Icon(Icons.shield_outlined,
                  color: AppColors.textMuted, size: 18),
            ),
            style: const TextStyle(color: AppColors.textPrimary),
          ),
          const SizedBox(height: 12),

          _FieldLabel('Points Limit'),
          const SizedBox(height: 6),
          TextFormField(
            controller: pointsController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: '95',
              prefixIcon: Icon(Icons.money_outlined,
                  color: AppColors.textMuted, size: 18),
              suffixText: 'pts',
              suffixStyle: TextStyle(color: AppColors.textMuted),
            ),
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Enter points';
              if (int.tryParse(v) == null) return 'Must be a number';
              return null;
            },
            style: const TextStyle(color: AppColors.textPrimary),
          ),
          const SizedBox(height: 6),
          _ReserveHint(controller: pointsController),
        ],
      ),
    );
  }
}

// Shows reserve calculation: 40% of points must be off-table in missions that use reserves
class _ReserveHint extends StatefulWidget {
  final TextEditingController controller;
  const _ReserveHint({required this.controller});

  @override
  State<_ReserveHint> createState() => _ReserveHintState();
}

class _ReserveHintState extends State<_ReserveHint> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_rebuild);
  }

  void _rebuild() => setState(() {});

  @override
  void dispose() {
    widget.controller.removeListener(_rebuild);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pts = int.tryParse(widget.controller.text) ?? 0;
    if (pts <= 0) return const SizedBox.shrink();
    final reserve = (pts * 0.4).ceil();
    final onTable = pts - reserve;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.olive.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.olive.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: AppColors.khaki, size: 13),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              'Missions with Reserves: max $onTable pts on-table · min $reserve pts in Reserve (40%)',
              style: const TextStyle(
                color: AppColors.khaki,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;

  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: const TextStyle(
        color: AppColors.textMuted,
        fontSize: 10,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.5,
      ),
    );
  }
}
