import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/battle_provider.dart';
import '../models/battle_models.dart';
import '../theme/app_theme.dart';

class SummaryScreen extends StatelessWidget {
  const SummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final battle = context.watch<BattleProvider>().battle!;
    final p1 = battle.player1;
    final p2 = battle.player2;
    final result = battle.result;

    final winner = result == BattleResult.player1Wins
        ? p1
        : result == BattleResult.player2Wins
            ? p2
            : null;

    final duration = battle.battleDuration;
    final durationStr =
        '${duration.inHours > 0 ? '${duration.inHours}h ' : ''}${duration.inMinutes.remainder(60)}m';

    return Scaffold(
      appBar: AppBar(
        title: const Text('BATTLE SUMMARY'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Result banner
                  _ResultBanner(result: result, winner: winner, battle: battle),
                  const SizedBox(height: 20),

                  // VP tally
                  _VictoryPointsCard(p1: p1, p2: p2, result: result),
                  const SizedBox(height: 20),

                  // Battle stats
                  const SectionHeader(
                    title: 'Battle Statistics',
                    icon: Icons.bar_chart,
                    color: AppColors.khaki,
                  ),
                  _BattleStatsGrid(battle: battle, durationStr: durationStr),
                  const SizedBox(height: 20),

                  // Casualties breakdown
                  const SectionHeader(
                    title: 'Casualties',
                    icon: Icons.person_remove_outlined,
                    color: AppColors.red,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _CasualtySummary(
                          player: p1,
                          color: AppColors.attackerBlue,
                          role: battle.mission.attackerRole,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _CasualtySummary(
                          player: p2,
                          color: AppColors.defenderBrown,
                          role: battle.mission.defenderRole,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Event log
                  const SectionHeader(
                    title: 'Battle Log',
                    icon: Icons.history,
                    color: AppColors.textMuted,
                  ),
                  _FullBattleLog(events: battle.eventLog),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // Footer actions
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: AppColors.darkCard,
              border: Border(top: BorderSide(color: AppColors.divider)),
            ),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.olive,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    icon: const Icon(Icons.add_circle_outline),
                    label: const Text(
                      'NEW BATTLE',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.5,
                      ),
                    ),
                    onPressed: () {
                      context.read<BattleProvider>().resetBattle();
                      Navigator.popUntil(context, (route) => route.isFirst);
                    },
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.home_outlined),
                    label: const Text('RETURN TO HOME'),
                    onPressed: () =>
                        Navigator.popUntil(context, (route) => route.isFirst),
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

class _ResultBanner extends StatelessWidget {
  final BattleResult result;
  final PlayerState? winner;
  final BattleState battle;

  const _ResultBanner({
    required this.result,
    required this.winner,
    required this.battle,
  });

  @override
  Widget build(BuildContext context) {
    final Color bannerColor;
    final String headline;
    final String subtext;
    final IconData icon;

    switch (result) {
      case BattleResult.player1Wins:
        bannerColor = AppColors.attackerBlue;
        headline = '${battle.player1.name} VICTORIOUS';
        subtext = battle.player1.armyName;
        icon = Icons.military_tech;
        break;
      case BattleResult.player2Wins:
        bannerColor = AppColors.defenderBrown;
        headline = '${battle.player2.name} VICTORIOUS';
        subtext = battle.player2.armyName;
        icon = Icons.military_tech;
        break;
      case BattleResult.draw:
        bannerColor = AppColors.khaki;
        headline = 'DRAW';
        subtext = 'Neither side achieved a decisive victory';
        icon = Icons.balance;
        break;
      default:
        bannerColor = AppColors.textMuted;
        headline = 'BATTLE ENDED';
        subtext = '';
        icon = Icons.flag;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: bannerColor.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: bannerColor.withOpacity(0.5), width: 2),
      ),
      child: Column(
        children: [
          Icon(icon, color: bannerColor, size: 48),
          const SizedBox(height: 12),
          Text(
            headline,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: bannerColor,
              fontSize: 24,
              fontWeight: FontWeight.w900,
              letterSpacing: 2.0,
            ),
          ),
          if (subtext.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              subtext,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
            ),
          ],
          const SizedBox(height: 12),
          // Mission name
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.darkCard,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: AppColors.divider),
            ),
            child: Text(
              battle.mission.name.toUpperCase(),
              style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 11,
                letterSpacing: 2.0,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _VictoryPointsCard extends StatelessWidget {
  final PlayerState p1;
  final PlayerState p2;
  final BattleResult result;

  const _VictoryPointsCard({
    required this.p1,
    required this.p2,
    required this.result,
  });

  String get _resultLabel {
    switch (result) {
      case BattleResult.player1Wins:
        if (p1.victoryPoints >= 8) return 'Decisive Victory';
        if (p1.victoryPoints >= 7) return 'Victory';
        return 'Marginal Victory';
      case BattleResult.player2Wins:
        if (p2.victoryPoints >= 8) return 'Decisive Victory';
        if (p2.victoryPoints >= 7) return 'Victory';
        return 'Marginal Victory';
      case BattleResult.draw:
        return 'Draw';
      default:
        return 'Incomplete';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gold.withOpacity(0.4)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.emoji_events, color: AppColors.gold, size: 18),
              const SizedBox(width: 8),
              const Text(
                'VICTORY POINTS',
                style: TextStyle(
                  color: AppColors.gold,
                  fontSize: 12,
                  letterSpacing: 2.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.gold.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: AppColors.gold.withOpacity(0.4)),
                ),
                child: Text(
                  _resultLabel.toUpperCase(),
                  style: const TextStyle(
                    color: AppColors.gold,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _VPDisplay(
                  playerName: p1.name,
                  vp: p1.victoryPoints,
                  color: AppColors.attackerBlue,
                  isWinner: result == BattleResult.player1Wins,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  ':',
                  style: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Expanded(
                child: _VPDisplay(
                  playerName: p2.name,
                  vp: p2.victoryPoints,
                  color: AppColors.defenderBrown,
                  isWinner: result == BattleResult.player2Wins,
                  alignRight: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // VP explanation
          const Divider(),
          const SizedBox(height: 8),
          const Text(
            '8:1 Decisive Victory  •  7:2 Victory  •  6:3 Marginal Victory  •  Draw: both score as Loser',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 10,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _VPDisplay extends StatelessWidget {
  final String playerName;
  final int vp;
  final Color color;
  final bool isWinner;
  final bool alignRight;

  const _VPDisplay({
    required this.playerName,
    required this.vp,
    required this.color,
    required this.isWinner,
    this.alignRight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          alignRight ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          playerName,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '$vp',
          style: TextStyle(
            color: isWinner ? color : AppColors.textMuted,
            fontSize: 56,
            fontWeight: FontWeight.w900,
            height: 1.0,
          ),
          textAlign: alignRight ? TextAlign.right : TextAlign.left,
        ),
        Text(
          'VP',
          style: TextStyle(
            color: color.withOpacity(0.6),
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
        if (isWinner)
          Container(
            margin: const EdgeInsets.only(top: 6),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              'WINNER',
              style: TextStyle(
                color: color,
                fontSize: 9,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.5,
              ),
            ),
          ),
      ],
    );
  }
}

class _BattleStatsGrid extends StatelessWidget {
  final BattleState battle;
  final String durationStr;

  const _BattleStatsGrid({required this.battle, required this.durationStr});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      childAspectRatio: 1.2,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      children: [
        _StatCell(
          label: 'Rounds Played',
          value: '${battle.currentRound}',
          icon: Icons.repeat,
        ),
        _StatCell(
          label: 'Duration',
          value: durationStr,
          icon: Icons.timer_outlined,
        ),
        _StatCell(
          label: 'Turn Limit',
          value: '${battle.mission.turnLimit}',
          icon: Icons.flag_outlined,
        ),
        _StatCell(
          label: '${battle.player1.name}\nDestroyed',
          value: '${battle.player1.destroyedPlatoons}',
          icon: Icons.remove_circle_outline,
          color: AppColors.attackerBlue,
        ),
        _StatCell(
          label: '${battle.player2.name}\nDestroyed',
          value: '${battle.player2.destroyedPlatoons}',
          icon: Icons.remove_circle_outline,
          color: AppColors.defenderBrown,
        ),
        _StatCell(
          label: 'Events\nLogged',
          value: '${battle.eventLog.length}',
          icon: Icons.history,
        ),
      ],
    );
  }
}

class _StatCell extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCell({
    required this.label,
    required this.value,
    required this.icon,
    this.color = AppColors.khaki,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 20,
              fontWeight: FontWeight.w900,
              height: 1.0,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 9,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}

class _CasualtySummary extends StatelessWidget {
  final PlayerState player;
  final Color color;
  final String role;

  const _CasualtySummary({
    required this.player,
    required this.color,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(8),
        border: Border(left: BorderSide(color: color, width: 3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            role.toUpperCase(),
            style: TextStyle(
              color: color.withOpacity(0.7),
              fontSize: 9,
              letterSpacing: 1.5,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            player.name,
            style: TextStyle(
              color: color,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          _SummaryRow(
            label: 'Total Platoons',
            value: '${player.totalPlatoons}',
          ),
          _SummaryRow(
            label: 'Destroyed',
            value: '${player.destroyedPlatoons}',
            valueColor: player.destroyedPlatoons > 0 ? AppColors.red : null,
          ),
          _SummaryRow(
            label: 'Surviving',
            value:
                '${player.totalPlatoons - player.destroyedPlatoons}',
            valueColor: AppColors.lightOlive,
          ),
          const SizedBox(height: 8),
          // Survival bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: player.totalPlatoons > 0
                  ? (player.totalPlatoons - player.destroyedPlatoons) /
                      player.totalPlatoons
                  : 1.0,
              backgroundColor: AppColors.bloodRed.withOpacity(0.3),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 6,
            ),
          ),
          if (player.totalPlatoons > 0) ...[
            const SizedBox(height: 4),
            Text(
              '${((player.totalPlatoons - player.destroyedPlatoons) / player.totalPlatoons * 100).round()}% surviving',
              style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 10,
              ),
            ),
          ],
          if (player.belowHalfStrength) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.bloodRed.withOpacity(0.2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'BELOW HALF STRENGTH',
                style: TextStyle(
                  color: AppColors.red,
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.0,
                ),
              ),
            ),
          ],

          // Destroyed unit list
          if (player.units.any((u) => u.platoonDestroyed)) ...[
            const SizedBox(height: 10),
            const Text(
              'DESTROYED UNITS',
              style: TextStyle(
                color: AppColors.textMuted,
                fontSize: 9,
                letterSpacing: 1.5,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            ...player.units
                .where((u) => u.platoonDestroyed)
                .map(
                  (u) => Padding(
                    padding: const EdgeInsets.only(bottom: 3),
                    child: Row(
                      children: [
                        const Icon(Icons.close,
                            color: AppColors.red, size: 12),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            u.name,
                            style: const TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 11,
                              decoration: TextDecoration.lineThrough,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
          ],
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
                color: AppColors.textMuted, fontSize: 11),
          ),
          Text(
            value,
            style: TextStyle(
              color: valueColor ?? AppColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _FullBattleLog extends StatelessWidget {
  final List<BattleRoundEvent> events;

  const _FullBattleLog({required this.events});

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          'No events logged during this battle.',
          style: TextStyle(color: AppColors.textMuted, fontSize: 13),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        children: events.reversed.map((e) {
          return Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 14, vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
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
                  ],
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
                Text(
                  '${e.timestamp.hour.toString().padLeft(2, '0')}:${e.timestamp.minute.toString().padLeft(2, '0')}',
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
