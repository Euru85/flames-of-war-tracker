import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/battle_models.dart';
import '../providers/battle_provider.dart';
import '../theme/app_theme.dart';
import 'battle_tracker_screen.dart';

class GameStartScreen extends StatefulWidget {
  const GameStartScreen({super.key});

  @override
  State<GameStartScreen> createState() => _GameStartScreenState();
}

class _GameStartScreenState extends State<GameStartScreen> {
  final List<bool> _confirmed = [];
  bool _firstTurnConfirmed = false;

  @override
  Widget build(BuildContext context) {
    final battle = context.watch<BattleProvider>().battle!;
    final mission = battle.mission;

    // Initialise confirmed list
    if (_confirmed.length != mission.startingConditions.length) {
      _confirmed.clear();
      _confirmed.addAll(
          List.generate(mission.startingConditions.length, (_) => false));
    }

    final allConfirmed =
        _confirmed.every((c) => c) && _firstTurnConfirmed;

    return Scaffold(
      appBar: AppBar(
        title: const Text('GAME START'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          _PhaseBanner(
            phase: 'PHASE 2 OF 3',
            label: 'GAME START',
            color: AppColors.lightOlive,
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Players summary
                  _PlayersSummaryCard(battle: battle),
                  const SizedBox(height: 20),

                  // Starting conditions checklist
                  const SectionHeader(
                    title: 'Starting Conditions',
                    icon: Icons.play_circle_outline,
                    color: AppColors.lightOlive,
                  ),
                  const Text(
                    'Confirm each condition before battle begins:',
                    style: TextStyle(
                        color: AppColors.textMuted, fontSize: 12),
                  ),
                  const SizedBox(height: 10),
                  ...mission.startingConditions.asMap().entries.map(
                        (e) => _CheckItem(
                          text: e.value,
                          checked: e.key < _confirmed.length
                              ? _confirmed[e.key]
                              : false,
                          onChanged: (v) =>
                              setState(() => _confirmed[e.key] = v!),
                        ),
                      ),

                  const SizedBox(height: 20),

                  // First turn notes
                  const SectionHeader(
                    title: 'First Turn Rules',
                    icon: Icons.looks_one_outlined,
                    color: AppColors.amber,
                  ),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.darkCard,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: AppColors.amber.withOpacity(0.4)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...mission.firstTurnRules.map(
                          (r) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(top: 4),
                                  child: Icon(Icons.warning_amber_outlined,
                                      color: AppColors.amber, size: 14),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    r,
                                    style: const TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 13,
                                      height: 1.5,
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
                  const SizedBox(height: 12),
                  _CheckItem(
                    text:
                        'I have read and understood the First Turn rules for this mission.',
                    checked: _firstTurnConfirmed,
                    onChanged: (v) =>
                        setState(() => _firstTurnConfirmed = v!),
                    color: AppColors.amber,
                  ),

                  const SizedBox(height: 20),

                  // Victory conditions preview
                  const SectionHeader(
                    title: 'Victory Conditions',
                    icon: Icons.military_tech,
                    color: AppColors.gold,
                  ),
                  ...mission.victoryConditions.map(
                    (vc) => Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.darkCard,
                        borderRadius: BorderRadius.circular(6),
                        border: Border(
                          left: BorderSide(
                              color: AppColors.gold, width: 3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            vc.title,
                            style: const TextStyle(
                              color: AppColors.sand,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            vc.description,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // Start battle button
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: AppColors.darkCard,
              border: Border(top: BorderSide(color: AppColors.divider)),
            ),
            child: Column(
              children: [
                if (!allConfirmed) ...[
                  const Text(
                    'Confirm all conditions to begin the battle',
                    style: TextStyle(
                        color: AppColors.textMuted, fontSize: 11),
                  ),
                  const SizedBox(height: 8),
                ],
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: allConfirmed
                          ? AppColors.bloodRed
                          : AppColors.darkCard,
                      foregroundColor: allConfirmed
                          ? AppColors.cream
                          : AppColors.textMuted,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: allConfirmed
                          ? null
                          : const BorderSide(color: AppColors.divider),
                    ),
                    icon: const Icon(Icons.local_fire_department, size: 22),
                    label: const Text(
                      'BATTLE COMMENCES',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2.5,
                      ),
                    ),
                    onPressed: allConfirmed
                        ? () {
                            context.read<BattleProvider>().startBattle();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const BattleTrackerScreen(),
                              ),
                            );
                          }
                        : null,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PlayersSummaryCard extends StatelessWidget {
  final BattleState battle;

  const _PlayersSummaryCard({required this.battle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.people_outline,
                  color: AppColors.textMuted, size: 16),
              const SizedBox(width: 8),
              const Text(
                'COMMANDERS',
                style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 10,
                  letterSpacing: 2.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _PlayerInfo(
                  name: battle.player1.name,
                  army: battle.player1.armyName,
                  points: battle.player1.pointsLimit,
                  color: AppColors.attackerBlue,
                  label: battle.mission.attackerRole,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  children: [
                    const Text('VS',
                        style: TextStyle(
                          color: AppColors.red,
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        )),
                  ],
                ),
              ),
              Expanded(
                child: _PlayerInfo(
                  name: battle.player2.name,
                  army: battle.player2.armyName,
                  points: battle.player2.pointsLimit,
                  color: AppColors.defenderBrown,
                  label: battle.mission.defenderRole,
                  alignRight: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PlayerInfo extends StatelessWidget {
  final String name;
  final String army;
  final int points;
  final Color color;
  final String label;
  final bool alignRight;

  const _PlayerInfo({
    required this.name,
    required this.army,
    required this.points,
    required this.color,
    required this.label,
    this.alignRight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          alignRight ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: TextStyle(
            color: color,
            fontSize: 9,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          name,
          style: const TextStyle(
            color: AppColors.cream,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
          textAlign: alignRight ? TextAlign.right : TextAlign.left,
        ),
        Text(
          army,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 11,
          ),
          textAlign: alignRight ? TextAlign.right : TextAlign.left,
        ),
        Text(
          '$points pts',
          style: TextStyle(
            color: color,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _CheckItem extends StatelessWidget {
  final String text;
  final bool checked;
  final ValueChanged<bool?> onChanged;
  final Color color;

  const _CheckItem({
    required this.text,
    required this.checked,
    required this.onChanged,
    this.color = AppColors.lightOlive,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () => onChanged(!checked),
        borderRadius: BorderRadius.circular(6),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          decoration: BoxDecoration(
            color: checked ? color.withOpacity(0.1) : AppColors.darkCard,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: checked ? color.withOpacity(0.5) : AppColors.divider,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                checked ? Icons.check_box : Icons.check_box_outline_blank,
                color: checked ? color : AppColors.textMuted,
                size: 20,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(
                    color: checked
                        ? AppColors.textSecondary
                        : AppColors.textPrimary,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PhaseBanner extends StatelessWidget {
  final String phase;
  final String label;
  final Color color;

  const _PhaseBanner({
    required this.phase,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8),
      color: color.withOpacity(0.1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            phase,
            style: TextStyle(
              color: color.withOpacity(0.7),
              fontSize: 10,
              letterSpacing: 2.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 12),
          Container(width: 1, height: 12, color: color.withOpacity(0.4)),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              letterSpacing: 2.0,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
