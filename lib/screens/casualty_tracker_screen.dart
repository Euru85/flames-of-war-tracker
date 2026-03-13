import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/battle_provider.dart';
import '../models/battle_models.dart';
import '../theme/app_theme.dart';

class CasualtyTrackerScreen extends StatefulWidget {
  final bool isPlayer1;

  const CasualtyTrackerScreen({super.key, required this.isPlayer1});

  @override
  State<CasualtyTrackerScreen> createState() => _CasualtyTrackerScreenState();
}

class _CasualtyTrackerScreenState extends State<CasualtyTrackerScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BattleProvider>();
    final battle = provider.battle!;
    final player =
        widget.isPlayer1 ? battle.player1 : battle.player2;
    final color = widget.isPlayer1
        ? AppColors.attackerBlue
        : AppColors.defenderBrown;

    return Scaffold(
      appBar: AppBar(
        title: Text('${player.name.toUpperCase()} — CASUALTIES'),
      ),
      body: Column(
        children: [
          // Player header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            color: color.withOpacity(0.1),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(Icons.shield_outlined, color: color),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        player.name,
                        style: TextStyle(
                          color: color,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        player.armyName,
                        style: const TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${player.totalPlatoons - player.destroyedPlatoons}',
                      style: const TextStyle(
                        color: AppColors.cream,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const Text(
                      'active platoons',
                      style: TextStyle(
                          color: AppColors.textMuted, fontSize: 10),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Status bar
          if (player.belowHalfStrength)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              color: AppColors.bloodRed.withOpacity(0.3),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.warning_amber, color: AppColors.red, size: 14),
                  SizedBox(width: 8),
                  Text(
                    'FORCE IS BELOW HALF STRENGTH',
                    style: TextStyle(
                      color: AppColors.red,
                      fontSize: 11,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),

          // Platoon list
          Expanded(
            child: player.units.isEmpty
                ? _EmptyState(
                    color: color,
                    onAdd: () => _showAddUnitDialog(context),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: player.units.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final unit = player.units[index];
                      return _UnitCard(
                        unit: unit,
                        color: color,
                        onUpdate: (destroyed, platoonDestroyed) {
                          provider.updateUnit(
                            widget.isPlayer1,
                            unit.id,
                            destroyedModels: destroyed,
                            platoonDestroyed: platoonDestroyed,
                          );
                        },
                        onDelete: () =>
                            provider.removeUnit(widget.isPlayer1, unit.id),
                      );
                    },
                  ),
          ),

          // Add platoon button
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: AppColors.darkCard,
              border: Border(top: BorderSide(color: AppColors.divider)),
            ),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: color,
                  side: BorderSide(color: color),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                icon: const Icon(Icons.add),
                label: const Text(
                  'ADD PLATOON / UNIT',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
                onPressed: () => _showAddUnitDialog(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddUnitDialog(BuildContext context) {
    final nameCtrl = TextEditingController();
    final typeCtrl = TextEditingController();
    final modelsCtrl = TextEditingController(text: '1');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardBg,
        title: const Text(
          'ADD PLATOON',
          style: TextStyle(
            color: AppColors.khaki,
            fontSize: 15,
            letterSpacing: 1.5,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'PLATOON NAME',
              style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 10,
                  letterSpacing: 1.5),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: nameCtrl,
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: const InputDecoration(
                hintText: 'e.g. 1st Infantry Platoon',
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'UNIT TYPE',
              style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 10,
                  letterSpacing: 1.5),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: typeCtrl,
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: const InputDecoration(
                hintText: 'e.g. Infantry, Tank, Artillery...',
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'NUMBER OF TEAMS/STANDS',
              style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 10,
                  letterSpacing: 1.5),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: modelsCtrl,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: const InputDecoration(hintText: '1'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel',
                style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameCtrl.text.trim().isEmpty) return;
              final unit = UnitCasualty(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                name: nameCtrl.text.trim(),
                unitType: typeCtrl.text.trim().isEmpty
                    ? 'Unknown'
                    : typeCtrl.text.trim(),
                totalModels: int.tryParse(modelsCtrl.text) ?? 1,
              );
              context
                  .read<BattleProvider>()
                  .addUnit(widget.isPlayer1, unit);
              Navigator.pop(ctx);
            },
            child: const Text('Add Platoon'),
          ),
        ],
      ),
    );
  }
}

class _UnitCard extends StatelessWidget {
  final UnitCasualty unit;
  final Color color;
  final void Function(int destroyed, bool platoonDestroyed) onUpdate;
  final VoidCallback onDelete;

  const _UnitCard({
    required this.unit,
    required this.color,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: unit.platoonDestroyed
              ? AppColors.bloodRed.withOpacity(0.6)
              : AppColors.divider,
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            unit.name,
                            style: TextStyle(
                              color: unit.platoonDestroyed
                                  ? AppColors.textMuted
                                  : AppColors.cream,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              decoration: unit.platoonDestroyed
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            unit.unitType,
                            style: const TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (unit.platoonDestroyed)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.bloodRed.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                              color: AppColors.bloodRed.withOpacity(0.6)),
                        ),
                        child: const Text(
                          'DESTROYED',
                          style: TextStyle(
                            color: AppColors.red,
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.delete_outline,
                          color: AppColors.textMuted, size: 18),
                      onPressed: onDelete,
                      constraints:
                          const BoxConstraints(minWidth: 32, minHeight: 32),
                      padding: EdgeInsets.zero,
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Teams/stands counter
                Row(
                  children: [
                    const Text(
                      'TEAMS DESTROYED:',
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 10,
                        letterSpacing: 1.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      color: AppColors.red,
                      iconSize: 22,
                      onPressed: unit.destroyedModels > 0
                          ? () => onUpdate(
                                unit.destroyedModels - 1,
                                unit.platoonDestroyed,
                              )
                          : null,
                      constraints:
                          const BoxConstraints(minWidth: 32, minHeight: 32),
                      padding: EdgeInsets.zero,
                    ),
                    Text(
                      '${unit.destroyedModels} / ${unit.totalModels}',
                      style: TextStyle(
                        color: unit.destroyedModels > 0
                            ? AppColors.red
                            : AppColors.textSecondary,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      color: AppColors.red,
                      iconSize: 22,
                      onPressed: unit.destroyedModels < unit.totalModels
                          ? () => onUpdate(
                                unit.destroyedModels + 1,
                                unit.platoonDestroyed,
                              )
                          : null,
                      constraints:
                          const BoxConstraints(minWidth: 32, minHeight: 32),
                      padding: EdgeInsets.zero,
                    ),
                    const Spacer(),
                    // Model loss indicator dots
                    ...List.generate(unit.totalModels, (i) {
                      final isLost = i < unit.destroyedModels;
                      return Container(
                        width: 12,
                        height: 12,
                        margin: const EdgeInsets.only(left: 3),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isLost
                              ? AppColors.bloodRed
                              : color.withOpacity(0.4),
                          border: Border.all(
                            color: isLost
                                ? AppColors.red
                                : color.withOpacity(0.6),
                          ),
                        ),
                      );
                    }).take(10).toList(),
                    if (unit.totalModels > 10)
                      Text(
                        '+${unit.totalModels - 10}',
                        style: const TextStyle(
                            color: AppColors.textMuted, fontSize: 10),
                      ),
                  ],
                ),
              ],
            ),
          ),

          // Platoon destroyed toggle
          InkWell(
            onTap: () => onUpdate(
              unit.platoonDestroyed
                  ? unit.destroyedModels
                  : unit.totalModels,
              !unit.platoonDestroyed,
            ),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: unit.platoonDestroyed
                    ? AppColors.bloodRed.withOpacity(0.2)
                    : AppColors.darkGrey,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
                border: Border(
                  top: BorderSide(color: AppColors.divider),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    unit.platoonDestroyed
                        ? Icons.check_box
                        : Icons.check_box_outline_blank,
                    color: unit.platoonDestroyed
                        ? AppColors.red
                        : AppColors.textMuted,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    unit.platoonDestroyed
                        ? 'PLATOON DESTROYED'
                        : 'MARK PLATOON AS DESTROYED',
                    style: TextStyle(
                      color: unit.platoonDestroyed
                          ? AppColors.red
                          : AppColors.textMuted,
                      fontSize: 11,
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

class _EmptyState extends StatelessWidget {
  final Color color;
  final VoidCallback onAdd;

  const _EmptyState({required this.color, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people_outline, color: color.withOpacity(0.4), size: 64),
            const SizedBox(height: 16),
            const Text(
              'No platoons tracked yet',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Add platoons to track casualties and determine if the force falls Below Half Strength.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textMuted,
                fontSize: 13,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: color,
                side: BorderSide(color: color),
              ),
              icon: const Icon(Icons.add),
              label: const Text('Add First Platoon'),
              onPressed: onAdd,
            ),
          ],
        ),
      ),
    );
  }
}
