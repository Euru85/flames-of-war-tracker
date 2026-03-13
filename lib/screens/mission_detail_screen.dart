import 'package:flutter/material.dart';
import '../models/mission.dart';
import '../theme/app_theme.dart';
import '../widgets/battlefield_diagram.dart';
import 'battle_setup_screen.dart';

class MissionDetailScreen extends StatelessWidget {
  final Mission mission;
  final bool referenceOnly;

  const MissionDetailScreen({
    super.key,
    required this.mission,
    this.referenceOnly = false,
  });

  Color get _typeColor => mission.isManoeuvre
      ? AppColors.amber
      : AppColors.attackerBlue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(mission.name.toUpperCase()),
      ),
      body: Column(
        children: [
          // Mission type banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            color: _typeColor.withOpacity(0.15),
            child: Row(
              children: [
                Icon(
                  mission.isManoeuvre
                      ? Icons.swap_horiz
                      : Icons.arrow_forward,
                  color: _typeColor,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  mission.isManoeuvre
                      ? 'MEETING ENGAGEMENT'
                      : 'ATTACKER vs DEFENDER',
                  style: TextStyle(
                    color: _typeColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 2.0,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.darkCard,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Text(
                    '${mission.turnLimit} TURNS',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Battlefield Diagram
                  SectionHeader(
                    title: 'Battlefield Layout',
                    icon: Icons.map_outlined,
                    color: AppColors.khaki,
                  ),
                  const SizedBox(height: 8),
                  BattlefieldDiagram(mission: mission),
                  if (mission.hasReserves) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.olive.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: AppColors.olive.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.shield_outlined, color: AppColors.khaki, size: 13),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              mission.reserveNote,
                              style: const TextStyle(color: AppColors.khaki, fontSize: 11),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),

                  // Tagline
                  Text(
                    '"${mission.tagline}"',
                    style: const TextStyle(
                      color: AppColors.sand,
                      fontSize: 15,
                      fontStyle: FontStyle.italic,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Overview
                  Text(
                    mission.overview,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Objectives
                  const SectionHeader(
                    title: 'Objective Setup',
                    icon: Icons.flag,
                    color: AppColors.gold,
                  ),
                  ...mission.objectiveSetup.map(
                    (rule) => _BulletItem(text: rule, color: AppColors.gold),
                  ),

                  // Deployment
                  const SectionHeader(
                    title: 'Deployment',
                    icon: Icons.grid_on,
                    color: AppColors.khaki,
                  ),
                  ...mission.deploymentRules.map(
                    (rule) => InfoCard(
                      title: rule.title,
                      body: rule.description,
                      icon: Icons.place_outlined,
                      borderColor: AppColors.khaki,
                    ),
                  ),

                  // Starting Conditions
                  const SectionHeader(
                    title: 'Starting Conditions',
                    icon: Icons.play_circle_outline,
                    color: AppColors.lightOlive,
                  ),
                  ...mission.startingConditions.map(
                    (c) => _BulletItem(text: c, color: AppColors.lightOlive),
                  ),

                  // First Turn
                  const SectionHeader(
                    title: 'First Turn Notes',
                    icon: Icons.looks_one_outlined,
                    color: AppColors.amber,
                  ),
                  ...mission.firstTurnRules.map(
                    (r) => _BulletItem(text: r, color: AppColors.amber),
                  ),

                  // Victory Conditions
                  const SectionHeader(
                    title: 'Victory Conditions',
                    icon: Icons.military_tech,
                    color: AppColors.gold,
                  ),
                  ...mission.victoryConditions.map(
                    (vc) => InfoCard(
                      title: vc.title,
                      body: vc.description,
                      icon: Icons.check_circle_outline,
                      borderColor: AppColors.gold,
                    ),
                  ),

                  // Special Rules
                  if (mission.specialRules.isNotEmpty) ...[
                    const SectionHeader(
                      title: 'Special Rules',
                      icon: Icons.star_outline,
                      color: AppColors.lightOlive,
                    ),
                    ...mission.specialRules.map(
                      (r) => _BulletItem(text: r, color: AppColors.lightOlive),
                    ),
                  ],

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // Action button
          if (!referenceOnly)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: AppColors.darkCard,
                border: Border(
                  top: BorderSide(color: AppColors.divider),
                ),
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.olive,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  icon: const Icon(Icons.sports_esports),
                  label: const Text(
                    'PLAY THIS MISSION',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2.0,
                    ),
                  ),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BattleSetupScreen(mission: mission),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _BulletItem extends StatelessWidget {
  final String text;
  final Color color;

  const _BulletItem({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
