import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../models/battle_models.dart';
import '../providers/battle_provider.dart';
import 'mission_select_screen.dart';
import 'mission_randomizer_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final battle = context.watch<BattleProvider>().battle;

    return Scaffold(
      body: Stack(
        children: [
          // Background pattern
          Positioned.fill(
            child: CustomPaint(painter: _GridPainter()),
          ),
          SafeArea(
            child: Column(
              children: [
                // ── Header ──────────────────────────────────────────────
                const SizedBox(height: 48),
                _buildHeader(),
                const SizedBox(height: 60),

                // ── Menu ────────────────────────────────────────────────
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _MenuButton(
                          icon: Icons.add_circle_outline,
                          label: 'New Battle',
                          sublabel: 'Select mission and begin',
                          color: AppColors.olive,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const MissionSelectScreen(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (battle != null) ...[
                          _MenuButton(
                            icon: Icons.play_arrow_rounded,
                            label: 'Continue Battle',
                            sublabel:
                                '${battle.mission.name} — Round ${battle.currentRound}',
                            color: AppColors.amber,
                            onTap: () =>
                                _resumeBattle(context, battle),
                          ),
                          const SizedBox(height: 16),
                          _MenuButton(
                            icon: Icons.delete_outline,
                            label: 'Abandon Battle',
                            sublabel: 'Reset current battle',
                            color: AppColors.bloodRed,
                            onTap: () => _confirmAbandon(context),
                          ),
                          const SizedBox(height: 16),
                        ],
                        _MenuButton(
                          icon: Icons.casino_outlined,
                          label: 'Random Mission',
                          sublabel: 'Roll to determine scenario',
                          color: AppColors.gold,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const MissionRandomizerScreen(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        _MenuButton(
                          icon: Icons.menu_book_outlined,
                          label: 'Mission Reference',
                          sublabel: 'Browse all scenarios',
                          color: AppColors.khaki,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const MissionSelectScreen(referenceOnly: true),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // ── Footer ──────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Text(
                    'FLAMES OF WAR v4 • BATTLE TRACKER',
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 10,
                      letterSpacing: 2.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        // Tactical cross icon
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.darkCard,
            border: Border.all(color: AppColors.khaki, width: 2),
          ),
          child: const Icon(
            Icons.gps_fixed,
            color: AppColors.khaki,
            size: 40,
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'FLAMES OF WAR',
          style: TextStyle(
            color: AppColors.cream,
            fontSize: 28,
            fontWeight: FontWeight.w900,
            letterSpacing: 4.0,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'BATTLE TRACKER',
          style: TextStyle(
            color: AppColors.khaki,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 6.0,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 120,
          height: 2,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.transparent, AppColors.khaki, Colors.transparent],
            ),
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'VERSION 4 RULES',
          style: TextStyle(
            color: AppColors.textMuted,
            fontSize: 10,
            letterSpacing: 3.0,
          ),
        ),
      ],
    );
  }

  void _resumeBattle(BuildContext context, battle) {
    // Navigate to the appropriate screen based on current phase
    _navigateToCurrentPhase(context);
  }

  void _navigateToCurrentPhase(BuildContext context) {
    final provider = context.read<BattleProvider>();
    final battle = provider.battle;
    if (battle == null) return;

    switch (battle.phase) {
      case BattlePhase.deployment:
        Navigator.pushNamed(context, '/deployment');
        break;
      case BattlePhase.gameStart:
        Navigator.pushNamed(context, '/game-start');
        break;
      case BattlePhase.battle:
        Navigator.pushNamed(context, '/battle');
        break;
      case BattlePhase.summary:
        Navigator.pushNamed(context, '/summary');
        break;
      default:
        break;
    }
  }

  void _confirmAbandon(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardBg,
        title: const Text(
          'ABANDON BATTLE?',
          style: TextStyle(
            color: AppColors.red,
            letterSpacing: 1.5,
            fontSize: 16,
          ),
        ),
        content: const Text(
          'This will reset the current battle. All progress will be lost.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel',
                style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.bloodRed),
            onPressed: () {
              ctx.read<BattleProvider>().resetBattle();
              Navigator.pop(ctx);
            },
            child: const Text('Abandon'),
          ),
        ],
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String sublabel;
  final Color color;
  final VoidCallback onTap;

  const _MenuButton({
    required this.icon,
    required this.label,
    required this.sublabel,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          decoration: BoxDecoration(
            color: AppColors.darkCard,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: color.withOpacity(0.5), width: 1.5),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label.toUpperCase(),
                      style: TextStyle(
                        color: color,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      sublabel,
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: color.withOpacity(0.6)),
            ],
          ),
        ),
      ),
    );
  }
}

// Tactical grid background painter
class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.divider.withOpacity(0.3)
      ..strokeWidth = 0.5;

    const spacing = 40.0;
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_GridPainter oldDelegate) => false;
}
