import 'package:flutter/material.dart';
import '../models/mission.dart';
import '../theme/app_theme.dart';
import 'mission_detail_screen.dart';

class MissionSelectScreen extends StatefulWidget {
  final bool referenceOnly;

  const MissionSelectScreen({super.key, this.referenceOnly = false});

  @override
  State<MissionSelectScreen> createState() => _MissionSelectScreenState();
}

class _MissionSelectScreenState extends State<MissionSelectScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  MissionType? _filter;

  List<Mission> get filteredMissions {
    if (_filter == null) return fowMissions;
    return fowMissions.where((m) => m.type == _filter).toList();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        switch (_tabController.index) {
          case 0:
            _filter = null;
            break;
          case 1:
            _filter = MissionType.manoeuvre;
            break;
          case 2:
            _filter = MissionType.attackDefend;
            break;
        }
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.referenceOnly
            ? 'MISSION REFERENCE'
            : 'SELECT MISSION'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.khaki,
          labelColor: AppColors.khaki,
          unselectedLabelColor: AppColors.textMuted,
          labelStyle: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
          tabs: const [
            Tab(text: 'ALL'),
            Tab(text: 'MEETING'),
            Tab(text: 'ATT/DEF'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Info bar
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: AppColors.darkCard,
            child: Row(
              children: [
                const Icon(Icons.info_outline,
                    color: AppColors.textMuted, size: 14),
                const SizedBox(width: 8),
                Text(
                  widget.referenceOnly
                      ? 'Tap any mission to view full rules'
                      : 'Tap a mission to view details and start battle',
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          // Mission list
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: filteredMissions.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final mission = filteredMissions[index];
                return _MissionCard(
                  mission: mission,
                  referenceOnly: widget.referenceOnly,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _MissionCard extends StatelessWidget {
  final Mission mission;
  final bool referenceOnly;

  const _MissionCard({required this.mission, required this.referenceOnly});

  Color get _typeColor => mission.isManoeuvre
      ? AppColors.amber
      : AppColors.attackerBlue;

  String get _typeLabel =>
      mission.isManoeuvre ? 'Meeting Engagement' : 'Attacker vs Defender';

  IconData get _typeIcon =>
      mission.isManoeuvre ? Icons.swap_horiz : Icons.arrow_forward;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(6),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MissionDetailScreen(
              mission: mission,
              referenceOnly: referenceOnly,
            ),
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.darkCard,
            borderRadius: BorderRadius.circular(6),
            border: Border(
              left: BorderSide(color: _typeColor, width: 4),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      mission.name.toUpperCase(),
                      style: const TextStyle(
                        color: AppColors.cream,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: _typeColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(_typeIcon, color: _typeColor, size: 12),
                        const SizedBox(width: 4),
                        Text(
                          _typeLabel.toUpperCase(),
                          style: TextStyle(
                            color: _typeColor,
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                mission.tagline,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  _InfoChip(
                    icon: Icons.flag_outlined,
                    label: '${mission.victoryConditions.length} victory conditions',
                  ),
                  const SizedBox(width: 8),
                  _InfoChip(
                    icon: Icons.military_tech_outlined,
                    label: '${mission.turnLimit} turn limit',
                  ),
                  const Spacer(),
                  Icon(
                    Icons.chevron_right,
                    color: AppColors.textMuted,
                    size: 18,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: AppColors.textMuted, size: 12),
        const SizedBox(width: 3),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textMuted,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}
