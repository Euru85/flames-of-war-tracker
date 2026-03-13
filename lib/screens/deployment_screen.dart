import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/battle_provider.dart';
import '../models/mission.dart';
import '../theme/app_theme.dart';
import 'game_start_screen.dart';

class DeploymentScreen extends StatefulWidget {
  const DeploymentScreen({super.key});

  @override
  State<DeploymentScreen> createState() => _DeploymentScreenState();
}

class _DeploymentScreenState extends State<DeploymentScreen> {
  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    final battle = context.watch<BattleProvider>().battle!;
    final mission = battle.mission;
    final steps = mission.deploymentRules;

    return Scaffold(
      appBar: AppBar(
        title: const Text('DEPLOYMENT PHASE'),
        leading: const Icon(Icons.grid_on, color: AppColors.khaki),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          // Phase banner
          _PhaseBanner(
            phase: 'PHASE 1 OF 3',
            label: 'DEPLOYMENT',
            color: AppColors.khaki,
          ),

          // Mission info
          Container(
            padding: const EdgeInsets.all(14),
            color: AppColors.darkCard,
            child: Row(
              children: [
                const Icon(Icons.map_outlined,
                    color: AppColors.textMuted, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Mission: ',
                          style: const TextStyle(
                              color: AppColors.textMuted, fontSize: 12),
                        ),
                        TextSpan(
                          text: mission.name,
                          style: const TextStyle(
                            color: AppColors.sand,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        TextSpan(
                          text:
                              '  •  ${battle.player1.name} vs ${battle.player2.name}',
                          style: const TextStyle(
                              color: AppColors.textMuted, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Objective setup
                  const SectionHeader(
                    title: 'Step 1 — Objective Setup',
                    icon: Icons.flag,
                    color: AppColors.gold,
                  ),
                  ...mission.objectiveSetup.asMap().entries.map(
                        (e) => _StepItem(
                          number: e.key + 1,
                          text: e.value,
                          color: AppColors.gold,
                        ),
                      ),
                  const SizedBox(height: 16),

                  // Deployment steps
                  const SectionHeader(
                    title: 'Step 2 — Deploy Forces',
                    icon: Icons.people_outline,
                    color: AppColors.khaki,
                  ),

                  // Interactive deployment checklist
                  ...steps.asMap().entries.map((e) {
                    final idx = e.key;
                    final rule = e.value;
                    return _DeploymentStepCard(
                      index: idx,
                      rule: rule,
                      isActive: _currentStep == idx,
                      isComplete: _currentStep > idx,
                      onComplete: () {
                        setState(() {
                          if (_currentStep == idx) {
                            _currentStep = idx + 1;
                          }
                        });
                      },
                    );
                  }),

                  const SizedBox(height: 16),

                  // Terrain note
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.darkCard,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: AppColors.divider),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.terrain,
                                color: AppColors.lightOlive, size: 16),
                            SizedBox(width: 8),
                            Text(
                              'TERRAIN NOTE',
                              style: TextStyle(
                                color: AppColors.lightOlive,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Place terrain before deploying forces. Terrain should provide interesting tactical choices — '
                          'enough cover to allow movement but open enough for fields of fire.',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // Bottom action
          _BottomAction(
            label: 'PROCEED TO GAME START',
            icon: Icons.arrow_forward,
            enabled: _currentStep >= steps.length,
            onTap: () {
              context.read<BattleProvider>().advanceToGameStart();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const GameStartScreen()),
              );
            },
            hint: _currentStep < steps.length
                ? 'Complete all deployment steps to continue'
                : null,
          ),
        ],
      ),
    );
  }
}

class _DeploymentStepCard extends StatelessWidget {
  final int index;
  final DeploymentRule rule;
  final bool isActive;
  final bool isComplete;
  final VoidCallback onComplete;

  const _DeploymentStepCard({
    required this.index,
    required this.rule,
    required this.isActive,
    required this.isComplete,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    final Color stateColor = isComplete
        ? AppColors.lightOlive
        : isActive
            ? AppColors.khaki
            : AppColors.textMuted;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isActive ? AppColors.khaki : AppColors.divider,
          width: isActive ? 1.5 : 1,
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Step number / check
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: stateColor.withOpacity(0.2),
                    border: Border.all(color: stateColor),
                  ),
                  child: Center(
                    child: isComplete
                        ? Icon(Icons.check, color: stateColor, size: 16)
                        : Text(
                            '${index + 1}',
                            style: TextStyle(
                              color: stateColor,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        rule.title,
                        style: TextStyle(
                          color: isComplete
                              ? AppColors.textMuted
                              : AppColors.sand,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          decoration: isComplete
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        rule.description,
                        style: TextStyle(
                          color: isComplete
                              ? AppColors.textMuted
                              : AppColors.textSecondary,
                          fontSize: 12,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (isActive)
            InkWell(
              onTap: onComplete,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: const BoxDecoration(
                  color: AppColors.olive,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(6),
                    bottomRight: Radius.circular(6),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle_outline,
                        color: AppColors.cream, size: 16),
                    SizedBox(width: 8),
                    Text(
                      'MARK AS DONE',
                      style: TextStyle(
                        color: AppColors.cream,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _StepItem extends StatelessWidget {
  final int number;
  final String text;
  final Color color;

  const _StepItem({
    required this.number,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 22,
            height: 22,
            margin: const EdgeInsets.only(top: 1),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(0.2),
              border: Border.all(color: color.withOpacity(0.6)),
            ),
            child: Center(
              child: Text(
                '$number',
                style: TextStyle(
                  color: color,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
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

class _BottomAction extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;
  final String? hint;

  const _BottomAction({
    required this.label,
    required this.icon,
    required this.enabled,
    required this.onTap,
    this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppColors.darkCard,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: Column(
        children: [
          if (hint != null) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.lock_outline,
                    color: AppColors.textMuted, size: 12),
                const SizedBox(width: 6),
                Text(
                  hint!,
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: enabled
                    ? AppColors.olive
                    : AppColors.darkCard,
                foregroundColor:
                    enabled ? AppColors.cream : AppColors.textMuted,
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: enabled
                    ? null
                    : const BorderSide(color: AppColors.divider),
              ),
              icon: Icon(icon),
              label: Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.5,
                ),
              ),
              onPressed: enabled ? onTap : null,
            ),
          ),
        ],
      ),
    );
  }
}
