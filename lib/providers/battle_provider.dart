import 'package:flutter/foundation.dart';
import '../models/battle_models.dart';
import '../models/mission.dart';

class BattleProvider extends ChangeNotifier {
  BattleState? _battle;

  BattleState? get battle => _battle;
  bool get hasBattle => _battle != null;

  // ── Setup ─────────────────────────────────────────────────────────────────

  void startNewBattle({
    required Mission mission,
    required String player1Name,
    required String player1Army,
    required int player1Points,
    required String player2Name,
    required String player2Army,
    required int player2Points,
  }) {
    _battle = BattleState(
      mission: mission,
      player1: PlayerState(
        name: player1Name,
        armyName: player1Army,
        pointsLimit: player1Points,
      ),
      player2: PlayerState(
        name: player2Name,
        armyName: player2Army,
        pointsLimit: player2Points,
      ),
      phase: BattlePhase.deployment,
      startTime: DateTime.now(),
    );
    notifyListeners();
  }

  void advanceToGameStart() {
    if (_battle == null) return;
    _battle = _battle!.copyWith(phase: BattlePhase.gameStart);
    notifyListeners();
  }

  void startBattle() {
    if (_battle == null) return;
    _battle = _battle!.copyWith(phase: BattlePhase.battle);
    _logEvent('Battle started! Round 1 begins.');
    notifyListeners();
  }

  // ── Turn Management ───────────────────────────────────────────────────────

  void endTurn() {
    if (_battle == null) return;
    final b = _battle!;

    if (!b.isPlayer1Turn) {
      // Both players have gone — advance to next round
      final nextRound = b.currentRound + 1;
      _battle = b.copyWith(
        currentRound: nextRound,
        isPlayer1Turn: true,
      );
      _logEvent('Round ${nextRound} begins — ${_battle!.player1.name}\'s turn.');
    } else {
      _battle = b.copyWith(isPlayer1Turn: false);
      _logEvent('${b.player2.name}\'s turn begins.');
    }
    notifyListeners();
  }

  // ── Casualty Tracking ─────────────────────────────────────────────────────

  void addUnit(bool isPlayer1, UnitCasualty unit) {
    if (_battle == null) return;
    final p1 = _battle!.player1;
    final p2 = _battle!.player2;
    if (isPlayer1) {
      final updated = List<UnitCasualty>.from(p1.units)..add(unit);
      _battle = _battle!.copyWith(
        player1: p1.copyWith(units: updated),
      );
    } else {
      final updated = List<UnitCasualty>.from(p2.units)..add(unit);
      _battle = _battle!.copyWith(
        player2: p2.copyWith(units: updated),
      );
    }
    notifyListeners();
  }

  void updateUnit(bool isPlayer1, String unitId, {int? destroyedModels, bool? platoonDestroyed}) {
    if (_battle == null) return;
    final player = isPlayer1 ? _battle!.player1 : _battle!.player2;
    final updatedUnits = player.units.map((u) {
      if (u.id == unitId) {
        final destroyed = platoonDestroyed ?? u.platoonDestroyed;
        final dm = destroyedModels ?? u.destroyedModels;
        if (destroyed && !u.platoonDestroyed) {
          _logEvent(
            '${player.name}: ${u.name} platoon destroyed!',
          );
        }
        return u.copyWith(
          destroyedModels: dm,
          platoonDestroyed: destroyed,
        );
      }
      return u;
    }).toList();

    final updatedPlayer = player.copyWith(units: updatedUnits);
    _battle = isPlayer1
        ? _battle!.copyWith(player1: updatedPlayer)
        : _battle!.copyWith(player2: updatedPlayer);
    notifyListeners();
  }

  void removeUnit(bool isPlayer1, String unitId) {
    if (_battle == null) return;
    final player = isPlayer1 ? _battle!.player1 : _battle!.player2;
    final updatedUnits = player.units.where((u) => u.id != unitId).toList();
    final updatedPlayer = player.copyWith(units: updatedUnits);
    _battle = isPlayer1
        ? _battle!.copyWith(player1: updatedPlayer)
        : _battle!.copyWith(player2: updatedPlayer);
    notifyListeners();
  }

  // ── Objectives ───────────────────────────────────────────────────────────

  void setObjectivesHeld(bool isPlayer1, int count) {
    if (_battle == null) return;
    if (isPlayer1) {
      _battle = _battle!.copyWith(
        player1: _battle!.player1.copyWith(objectivesHeld: count),
      );
    } else {
      _battle = _battle!.copyWith(
        player2: _battle!.player2.copyWith(objectivesHeld: count),
      );
    }
    notifyListeners();
  }

  void removeObjective() {
    if (_battle == null) return;
    _battle = _battle!.copyWith(
      objectivesRemoved: _battle!.objectivesRemoved + 1,
    );
    _logEvent('Defender removes an objective! (${_battle!.objectivesRemoved} removed so far)');
    notifyListeners();
  }

  // ── Victory ───────────────────────────────────────────────────────────────

  void declareVictory(BattleResult result, String reason) {
    if (_battle == null) return;
    _logEvent('BATTLE ENDED: $reason');

    final p1 = _battle!.player1;
    final p2 = _battle!.player2;

    int p1vp = 0, p2vp = 0;
    switch (result) {
      case BattleResult.player1Wins:
        p1vp = _calcWinnerVP(p1, p2);
        p2vp = _calcLoserVP(p2, p1);
        break;
      case BattleResult.player2Wins:
        p2vp = _calcWinnerVP(p2, p1);
        p1vp = _calcLoserVP(p1, p2);
        break;
      case BattleResult.draw:
        // Both players treat their opponent as the winner — each gains Loser VP
        p1vp = _calcLoserVP(p1, p2);
        p2vp = _calcLoserVP(p2, p1);
        break;
      default:
        break;
    }

    _battle = _battle!.copyWith(
      result: result,
      phase: BattlePhase.summary,
      endTime: DateTime.now(),
      player1: p1.copyWith(victoryPoints: p1vp),
      player2: p2.copyWith(victoryPoints: p2vp),
    );
    notifyListeners();
  }

  // FoW More Missions VP scale (per PDF):
  //   Winner lost 0–1 Units → Winner 8 VP, Loser 1 VP
  //   Winner lost 2 Units   → Winner 7 VP, Loser 2 VP
  //   Winner lost 3+ Units  → Winner 6 VP, Loser 3 VP
  int _calcWinnerVP(PlayerState winner, PlayerState loser) {
    final lost = winner.destroyedPlatoons;
    if (lost <= 1) return 8;
    if (lost == 2) return 7;
    return 6;
  }

  int _calcLoserVP(PlayerState loser, PlayerState winner) {
    final winnerVP = _calcWinnerVP(winner, loser);
    if (winnerVP == 8) return 1;
    if (winnerVP == 7) return 2;
    return 3;
  }

  void endGameByTimeLimit() {
    if (_battle == null) return;
    final mission = _battle!.mission;
    BattleResult result;
    String reason;

    if (mission.type == MissionType.attackDefend) {
      // Defender wins on time
      result = BattleResult.player2Wins;
      reason = 'Time limit reached — Defender holds the position! ${_battle!.player2.name} wins.';
    } else {
      result = BattleResult.draw;
      reason = 'Time limit reached — neither side achieved a decisive victory. Draw!';
    }
    declareVictory(result, reason);
  }

  void resetBattle() {
    _battle = null;
    notifyListeners();
  }

  // ── Logging ───────────────────────────────────────────────────────────────

  void logCustomEvent(String description) {
    _logEvent(description);
    notifyListeners();
  }

  void _logEvent(String description) {
    if (_battle == null) return;
    final event = BattleRoundEvent(
      round: _battle!.currentRound,
      description: description,
      timestamp: DateTime.now(),
    );
    final updatedLog = List<BattleRoundEvent>.from(_battle!.eventLog)..add(event);
    _battle = _battle!.copyWith(eventLog: updatedLog);
  }
}
