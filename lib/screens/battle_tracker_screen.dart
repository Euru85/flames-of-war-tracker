import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/battle_provider.dart';
import '../models/battle_models.dart';
import '../theme/app_theme.dart';
import 'casualty_tracker_screen.dart';
import 'summary_screen.dart';

class BattleTrackerScreen extends StatefulWidget {
  const BattleTrackerScreen({super.key});

  @override
  State<BattleTrackerScreen> createState() => _BattleTrackerScreenState();
}

class _BattleTrackerScreenState extends State<BattleTrackerScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BattleProvider>();
    final battle = provider.battle!;

    return Scaffold(
      appBar: AppBar(
        title: Text('ROUND ${battle.currentRound}  —  ${battle.currentPlayer.name.toUpperCase()}'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () => _showOptionsMenu(context),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.khaki,
          labelColor: AppColors.khaki,
          unselectedLabelColor: AppColors.textMuted,
          labelStyle: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
          tabs: const [
            Tab(icon: Icon(Icons.sports_esports, size: 16), text: 'BATTLE'),
            Tab(icon: Icon(Icons.flag_outlined, size: 16), text: 'OBJECTIVES'),
            Tab(icon: Icon(Icons.book_outlined, size: 16), text: 'MISSION'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _BattleTab(battle: battle),
          _ObjectivesTab(battle: battle),
          _MissionTab(battle: battle),
        ],
      ),
    );
  }

  void _showOptionsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => _OptionsSheet(battleContext: context),
    );
  }
}

// ── Battle Tab ───────────────────────────────────────────────────────────────

class _BattleTab extends StatelessWidget {
  final BattleState battle;

  const _BattleTab({required this.battle});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<BattleProvider>();
    final p1 = battle.player1;
    final p2 = battle.player2;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Turn indicator
          _TurnIndicator(battle: battle),
          const SizedBox(height: 16),

          // Round tracker
          _RoundTracker(
            currentRound: battle.currentRound,
            turnLimit: battle.mission.turnLimit,
          ),
          const SizedBox(height: 16),

          // Players status side-by-side
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _PlayerStatusCard(
                  player: p1,
                  color: AppColors.attackerBlue,
                  role: battle.mission.attackerRole,
                  isCurrentTurn: battle.isPlayer1Turn,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _PlayerStatusCard(
                  player: p2,
                  color: AppColors.defenderBrown,
                  role: battle.mission.defenderRole,
                  isCurrentTurn: !battle.isPlayer1Turn,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Action buttons
          const SectionHeader(
            title: 'Actions',
            icon: Icons.touch_app_outlined,
            color: AppColors.khaki,
          ),
          Row(
            children: [
              Expanded(
                child: _ActionButton(
                  icon: Icons.person_remove_outlined,
                  label: '${p1.name}\nCasualties',
                  color: AppColors.attackerBlue,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const CasualtyTrackerScreen(isPlayer1: true),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _ActionButton(
                  icon: Icons.person_remove_outlined,
                  label: '${p2.name}\nCasualties',
                  color: AppColors.defenderBrown,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const CasualtyTrackerScreen(isPlayer1: false),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Fighting withdrawal objective removal
          if (battle.mission.id == 'fighting_withdrawal') ...[
            _FightingWithdrawalCard(battle: battle),
            const SizedBox(height: 10),
          ],

          // Victory declaration
          _VictoryDeclarationCard(battle: battle),
          const SizedBox(height: 16),

          // End turn / End round button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.olive,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              icon: const Icon(Icons.arrow_forward),
              label: Text(
                battle.isPlayer1Turn
                    ? '${p2.name.toUpperCase()}\'S TURN'
                    : 'END ROUND ${battle.currentRound}',
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.5,
                ),
              ),
              onPressed: () {
                provider.endTurn();
                _checkBrokenStatus(context);
              },
            ),
          ),
          const SizedBox(height: 8),

          // Time limit end game
          if (battle.currentRound > battle.mission.turnLimit)
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.amber,
                side: const BorderSide(color: AppColors.amber),
              ),
              icon: const Icon(Icons.timer_off_outlined),
              label: const Text('END BY TIME LIMIT'),
              onPressed: () => _endByTimeLimit(context),
            ),

          // Battle log
          const SizedBox(height: 16),
          _BattleLog(events: battle.eventLog),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  void _checkBrokenStatus(BuildContext context) {
    final battle = context.read<BattleProvider>().battle!;
    if (battle.player1.belowHalfStrength || battle.player2.belowHalfStrength) {
      _showBrokenAlert(context, battle);
    }
  }

  void _showBrokenAlert(BuildContext context, BattleState battle) {
    String msg = '';
    if (battle.player1.belowHalfStrength && battle.player2.belowHalfStrength) {
      msg = 'BOTH forces are below half strength!';
    } else if (battle.player1.belowHalfStrength) {
      msg = '${battle.player1.name} is Below Half Strength!';
    } else {
      msg = '${battle.player2.name} is Below Half Strength!';
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.bloodRed,
        content: Row(
          children: [
            const Icon(Icons.warning_amber, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                msg,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void _endByTimeLimit(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardBg,
        title: const Text('END BY TIME LIMIT?',
            style: TextStyle(color: AppColors.amber, letterSpacing: 1.2)),
        content: const Text(
          'The turn limit has been reached. End the game now?',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel',
                style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.amber),
            onPressed: () {
              Navigator.pop(ctx);
              ctx.read<BattleProvider>().endGameByTimeLimit();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const SummaryScreen()),
              );
            },
            child: const Text('End Game'),
          ),
        ],
      ),
    );
  }
}

// ── Objectives Tab ────────────────────────────────────────────────────────────

class _ObjectivesTab extends StatelessWidget {
  final BattleState battle;

  const _ObjectivesTab({required this.battle});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<BattleProvider>();
    final p1 = battle.player1;
    final p2 = battle.player2;
    final totalObjectives = battle.mission.id == 'fighting_withdrawal' ? 6 : 4;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Objective tracking explanation
          InfoCard(
            title: 'Objective Rules',
            body: battle.mission.victoryConditions
                .map((vc) => '• ${vc.title}: ${vc.description}')
                .join('\n\n'),
            icon: Icons.info_outline,
            borderColor: AppColors.gold,
          ),
          const SizedBox(height: 8),

          if (battle.mission.id == 'fighting_withdrawal') ...[
            const SectionHeader(
              title: 'Objectives Remaining',
              icon: Icons.flag,
              color: AppColors.red,
            ),
            _ObjectivesRemainingCard(
              total: totalObjectives,
              removed: battle.objectivesRemoved,
              onRemove: () => provider.removeObjective(),
            ),
            const SizedBox(height: 16),
          ],

          // Objectives held per player
          const SectionHeader(
            title: 'Objectives Held',
            icon: Icons.flag,
            color: AppColors.gold,
          ),
          Row(
            children: [
              Expanded(
                child: _ObjectiveCounter(
                  playerName: p1.name,
                  held: p1.objectivesHeld,
                  color: AppColors.attackerBlue,
                  max: totalObjectives,
                  onChanged: (val) =>
                      provider.setObjectivesHeld(true, val),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _ObjectiveCounter(
                  playerName: p2.name,
                  held: p2.objectivesHeld,
                  color: AppColors.defenderBrown,
                  max: totalObjectives,
                  onChanged: (val) =>
                      provider.setObjectivesHeld(false, val),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Victory conditions quick ref
          const SectionHeader(
            title: 'Win Conditions',
            icon: Icons.military_tech,
            color: AppColors.gold,
          ),
          ...battle.mission.victoryConditions.map(
            (vc) => Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.darkCard,
                borderRadius: BorderRadius.circular(6),
                border: Border(left: BorderSide(color: AppColors.gold, width: 3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    vc.title,
                    style: const TextStyle(
                      color: AppColors.sand,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    vc.description,
                    style: const TextStyle(
                        color: AppColors.textSecondary, fontSize: 12, height: 1.5),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ── Mission Tab ───────────────────────────────────────────────────────────────

class _MissionTab extends StatelessWidget {
  final BattleState battle;

  const _MissionTab({required this.battle});

  @override
  Widget build(BuildContext context) {
    final m = battle.mission;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.darkCard,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.divider),
            ),
            child: Text(
              m.overview,
              style: const TextStyle(
                  color: AppColors.textSecondary, fontSize: 13, height: 1.6),
            ),
          ),
          const SizedBox(height: 16),

          const SectionHeader(
            title: 'Special Rules Reminder',
            icon: Icons.star_outline,
            color: AppColors.lightOlive,
          ),
          ...m.specialRules.map(
            (r) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.darkCard,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: AppColors.divider),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.chevron_right,
                      color: AppColors.lightOlive, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      r,
                      style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                          height: 1.5),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ── Widget components ─────────────────────────────────────────────────────────

class _TurnIndicator extends StatelessWidget {
  final BattleState battle;

  const _TurnIndicator({required this.battle});

  @override
  Widget build(BuildContext context) {
    final color =
        battle.isPlayer1Turn ? AppColors.attackerBlue : AppColors.defenderBrown;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.5), width: 1.5),
      ),
      child: Row(
        children: [
          Icon(Icons.person, color: color, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ACTIVE PLAYER',
                  style: TextStyle(
                    color: color.withOpacity(0.7),
                    fontSize: 9,
                    letterSpacing: 2.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  battle.currentPlayer.name,
                  style: TextStyle(
                    color: color,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.0,
                  ),
                ),
              ],
            ),
          ),
          Text(
            battle.currentPlayer.armyName,
            style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

class _RoundTracker extends StatelessWidget {
  final int currentRound;
  final int turnLimit;

  const _RoundTracker({required this.currentRound, required this.turnLimit});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          const Text(
            'ROUND',
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 11,
              letterSpacing: 2.0,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Row(
              children: List.generate(turnLimit, (i) {
                final round = i + 1;
                final isPast = round < currentRound;
                final isCurrent = round == currentRound;
                return Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    height: 28,
                    decoration: BoxDecoration(
                      color: isCurrent
                          ? AppColors.olive
                          : isPast
                              ? AppColors.darkCard
                              : AppColors.darkGrey,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: isCurrent
                            ? AppColors.khaki
                            : isPast
                                ? AppColors.divider
                                : AppColors.divider,
                        width: isCurrent ? 1.5 : 1,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '$round',
                        style: TextStyle(
                          color: isCurrent
                              ? AppColors.cream
                              : isPast
                                  ? AppColors.textMuted
                                  : AppColors.textMuted,
                          fontSize: 12,
                          fontWeight: isCurrent
                              ? FontWeight.w800
                              : FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            currentRound > turnLimit ? 'OVERTIME' : '$currentRound/$turnLimit',
            style: TextStyle(
              color: currentRound > turnLimit
                  ? AppColors.red
                  : AppColors.textMuted,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _PlayerStatusCard extends StatelessWidget {
  final PlayerState player;
  final Color color;
  final String role;
  final bool isCurrentTurn;

  const _PlayerStatusCard({
    required this.player,
    required this.color,
    required this.role,
    required this.isCurrentTurn,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isCurrentTurn ? color : AppColors.divider,
          width: isCurrentTurn ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (isCurrentTurn)
                Container(
                  width: 6,
                  height: 6,
                  margin: const EdgeInsets.only(right: 6),
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
              Expanded(
                child: Text(
                  player.name,
                  style: TextStyle(
                    color: isCurrentTurn ? color : AppColors.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            role,
            style: const TextStyle(color: AppColors.textMuted, fontSize: 10),
          ),
          const Divider(height: 14),
          _StatusRow(
            label: 'Platoons',
            value: '${player.totalPlatoons - player.destroyedPlatoons}/${player.totalPlatoons}',
            color: player.belowHalfStrength ? AppColors.red : AppColors.textSecondary,
          ),
          const SizedBox(height: 4),
          _StatusRow(
            label: 'Destroyed',
            value: '${player.destroyedPlatoons}',
            color: player.destroyedPlatoons > 0 ? AppColors.red : AppColors.textMuted,
          ),
          if (player.belowHalfStrength) ...[
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.bloodRed.withOpacity(0.3),
                borderRadius: BorderRadius.circular(3),
                border: Border.all(color: AppColors.bloodRed.withOpacity(0.6)),
              ),
              child: const Text(
                'BELOW HALF',
                style: TextStyle(
                  color: AppColors.red,
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _StatusRow extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatusRow({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
        ),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
          decoration: BoxDecoration(
            color: AppColors.darkCard,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color.withOpacity(0.4)),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(height: 6),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: color,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FightingWithdrawalCard extends StatelessWidget {
  final BattleState battle;

  const _FightingWithdrawalCard({required this.battle});

  @override
  Widget build(BuildContext context) {
    final remaining = 6 - battle.objectivesRemoved;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.bloodRed.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.bloodRed.withOpacity(0.4)),
      ),
      child: Row(
        children: [
          Icon(Icons.flag, color: AppColors.red, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'FIGHTING WITHDRAWAL',
                  style: TextStyle(
                    color: AppColors.red,
                    fontSize: 10,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$remaining objectives remaining on table',
                  style: const TextStyle(
                      color: AppColors.textSecondary, fontSize: 12),
                ),
              ],
            ),
          ),
          if (battle.currentRound >= 3)
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.bloodRed,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              onPressed: remaining > 0
                  ? () => context.read<BattleProvider>().removeObjective()
                  : null,
              child: const Text('Remove',
                  style: TextStyle(fontSize: 12)),
            )
          else
            const Text(
              'Available\nTurn 3+',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textMuted, fontSize: 10),
            ),
        ],
      ),
    );
  }
}

class _VictoryDeclarationCard extends StatelessWidget {
  final BattleState battle;

  const _VictoryDeclarationCard({required this.battle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.gold.withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.military_tech, color: AppColors.gold, size: 16),
              SizedBox(width: 8),
              Text(
                'DECLARE VICTORY',
                style: TextStyle(
                  color: AppColors.gold,
                  fontSize: 11,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.attackerBlue,
                    side: const BorderSide(color: AppColors.attackerBlue),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () =>
                      _declareWin(context, BattleResult.player1Wins,
                          '${battle.player1.name} wins!'),
                  child: Text(
                    battle.player1.name,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text('WINS',
                    style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 11,
                        fontWeight: FontWeight.w700)),
              ),
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.defenderBrown,
                    side: const BorderSide(color: AppColors.defenderBrown),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () =>
                      _declareWin(context, BattleResult.player2Wins,
                          '${battle.player2.name} wins!'),
                  child: Text(
                    battle.player2.name,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _declareWin(BuildContext context, BattleResult result, String reason) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardBg,
        title: const Text('CONFIRM VICTORY',
            style: TextStyle(
                color: AppColors.gold,
                letterSpacing: 1.5,
                fontSize: 15)),
        content: Text(
          reason,
          style: const TextStyle(
              color: AppColors.textSecondary, fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel',
                style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.gold),
            onPressed: () {
              Navigator.pop(ctx);
              context.read<BattleProvider>().declareVictory(result, reason);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const SummaryScreen()),
              );
            },
            child: const Text('Confirm Victory'),
          ),
        ],
      ),
    );
  }
}

class _BattleLog extends StatelessWidget {
  final List<BattleRoundEvent> events;

  const _BattleLog({required this.events});

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: 'Battle Log',
          icon: Icons.history,
          color: AppColors.textMuted,
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.darkCard,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.divider),
          ),
          child: Column(
            children: events.reversed.take(10).map((e) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.darkGrey,
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: Text(
                        'T${e.round}',
                        style: const TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        e.description,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _ObjectiveCounter extends StatelessWidget {
  final String playerName;
  final int held;
  final Color color;
  final int max;
  final ValueChanged<int> onChanged;

  const _ObjectiveCounter({
    required this.playerName,
    required this.held,
    required this.color,
    required this.max,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: held > 0 ? color.withOpacity(0.5) : AppColors.divider,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            playerName,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              IconButton(
                onPressed: held > 0 ? () => onChanged(held - 1) : null,
                icon: const Icon(Icons.remove_circle_outline),
                color: color,
                iconSize: 22,
                constraints:
                    const BoxConstraints(minWidth: 32, minHeight: 32),
                padding: EdgeInsets.zero,
              ),
              Expanded(
                child: Text(
                  '$held',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: held > 0 ? color : AppColors.textMuted,
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              IconButton(
                onPressed:
                    held < max ? () => onChanged(held + 1) : null,
                icon: const Icon(Icons.add_circle_outline),
                color: color,
                iconSize: 22,
                constraints:
                    const BoxConstraints(minWidth: 32, minHeight: 32),
                padding: EdgeInsets.zero,
              ),
            ],
          ),
          const Center(
            child: Text(
              'objectives',
              style: TextStyle(color: AppColors.textMuted, fontSize: 10),
            ),
          ),
        ],
      ),
    );
  }
}

class _ObjectivesRemainingCard extends StatelessWidget {
  final int total;
  final int removed;
  final VoidCallback onRemove;

  const _ObjectivesRemainingCard({
    required this.total,
    required this.removed,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final remaining = total - removed;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.red.withOpacity(0.4)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$remaining / $total objectives on table',
                style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600),
              ),
              Text(
                '$removed removed',
                style: const TextStyle(
                    color: AppColors.red, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: List.generate(total, (i) {
              final isRemoved = i < removed;
              return Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  height: 24,
                  decoration: BoxDecoration(
                    color: isRemoved
                        ? AppColors.bloodRed.withOpacity(0.3)
                        : AppColors.gold.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: isRemoved
                          ? AppColors.red.withOpacity(0.5)
                          : AppColors.gold.withOpacity(0.5),
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      isRemoved ? Icons.close : Icons.flag,
                      size: 12,
                      color: isRemoved ? AppColors.red : AppColors.gold,
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

// ── Options Sheet ─────────────────────────────────────────────────────────────

class _OptionsSheet extends StatelessWidget {
  final BuildContext battleContext;

  const _OptionsSheet({required this.battleContext});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 8),
        Container(
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: AppColors.divider,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(height: 16),
        _SheetOption(
          icon: Icons.note_add_outlined,
          label: 'Add Battle Note',
          onTap: () {
            Navigator.pop(context);
            _addNote(battleContext);
          },
        ),
        _SheetOption(
          icon: Icons.military_tech_outlined,
          label: 'End Battle — Declare Draw',
          onTap: () {
            Navigator.pop(context);
            battleContext.read<BattleProvider>().declareVictory(
                BattleResult.draw, 'Battle ended in a draw.');
            Navigator.pushReplacement(
              battleContext,
              MaterialPageRoute(builder: (_) => const SummaryScreen()),
            );
          },
        ),
        _SheetOption(
          icon: Icons.home_outlined,
          label: 'Return to Home',
          onTap: () {
            Navigator.pop(context);
            Navigator.popUntil(battleContext, (route) => route.isFirst);
          },
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  void _addNote(BuildContext context) {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardBg,
        title: const Text('ADD BATTLE NOTE',
            style: TextStyle(
                color: AppColors.khaki,
                fontSize: 14,
                letterSpacing: 1.2)),
        content: TextField(
          controller: ctrl,
          style: const TextStyle(color: AppColors.textPrimary),
          decoration: const InputDecoration(
            hintText: 'e.g. Tiger destroyed by flank shot...',
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel',
                style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              if (ctrl.text.trim().isNotEmpty) {
                context
                    .read<BattleProvider>()
                    .logCustomEvent(ctrl.text.trim());
              }
              Navigator.pop(ctx);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}

class _SheetOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SheetOption({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.khaki),
      title: Text(label,
          style: const TextStyle(color: AppColors.textPrimary, fontSize: 14)),
      onTap: onTap,
    );
  }
}
