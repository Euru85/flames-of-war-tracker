import 'mission.dart';

enum BattlePhase {
  setup,
  deployment,
  gameStart,
  battle,
  summary,
}

enum BattleResult {
  none,
  player1Wins,
  player2Wins,
  draw,
}

class UnitCasualty {
  final String id;
  String name;
  String unitType;
  int totalModels;
  int destroyedModels;
  bool platoonDestroyed;

  UnitCasualty({
    required this.id,
    required this.name,
    required this.unitType,
    required this.totalModels,
    this.destroyedModels = 0,
    this.platoonDestroyed = false,
  });

  UnitCasualty copyWith({
    String? name,
    String? unitType,
    int? totalModels,
    int? destroyedModels,
    bool? platoonDestroyed,
  }) {
    return UnitCasualty(
      id: id,
      name: name ?? this.name,
      unitType: unitType ?? this.unitType,
      totalModels: totalModels ?? this.totalModels,
      destroyedModels: destroyedModels ?? this.destroyedModels,
      platoonDestroyed: platoonDestroyed ?? this.platoonDestroyed,
    );
  }
}

class PlayerState {
  final String name;
  final String armyName;
  final int pointsLimit;
  List<UnitCasualty> units;
  int objectivesHeld;
  bool isBroken;
  int victoryPoints;

  PlayerState({
    required this.name,
    required this.armyName,
    required this.pointsLimit,
    List<UnitCasualty>? units,
    this.objectivesHeld = 0,
    this.isBroken = false,
    this.victoryPoints = 0,
  }) : units = units ?? [];

  int get destroyedPlatoons =>
      units.where((u) => u.platoonDestroyed).length;

  int get totalPlatoons => units.length;

  bool get belowHalfStrength =>
      totalPlatoons > 0 && destroyedPlatoons >= (totalPlatoons / 2).ceil();

  PlayerState copyWith({
    String? name,
    String? armyName,
    int? pointsLimit,
    List<UnitCasualty>? units,
    int? objectivesHeld,
    bool? isBroken,
    int? victoryPoints,
  }) {
    return PlayerState(
      name: name ?? this.name,
      armyName: armyName ?? this.armyName,
      pointsLimit: pointsLimit ?? this.pointsLimit,
      units: units ?? this.units,
      objectivesHeld: objectivesHeld ?? this.objectivesHeld,
      isBroken: isBroken ?? this.isBroken,
      victoryPoints: victoryPoints ?? this.victoryPoints,
    );
  }
}

class BattleRoundEvent {
  final int round;
  final String description;
  final DateTime timestamp;

  BattleRoundEvent({
    required this.round,
    required this.description,
    required this.timestamp,
  });
}

class BattleState {
  final Mission mission;
  final PlayerState player1;
  final PlayerState player2;
  final int currentRound;
  final bool isPlayer1Turn;
  final BattlePhase phase;
  final BattleResult result;
  final List<BattleRoundEvent> eventLog;
  final DateTime startTime;
  final DateTime? endTime;
  final int objectivesRemoved; // For Fighting Withdrawal

  BattleState({
    required this.mission,
    required this.player1,
    required this.player2,
    this.currentRound = 1,
    this.isPlayer1Turn = true,
    this.phase = BattlePhase.setup,
    this.result = BattleResult.none,
    List<BattleRoundEvent>? eventLog,
    DateTime? startTime,
    this.endTime,
    this.objectivesRemoved = 0,
  })  : eventLog = eventLog ?? [],
        startTime = startTime ?? DateTime.now();

  PlayerState get currentPlayer => isPlayer1Turn ? player1 : player2;
  PlayerState get opponentPlayer => isPlayer1Turn ? player2 : player1;

  String get currentPlayerName =>
      isPlayer1Turn ? player1.name : player2.name;

  String get turnLabel => 'Turn $currentRound — ${currentPlayer.name}\'s Turn';

  Duration get battleDuration {
    final end = endTime ?? DateTime.now();
    return end.difference(startTime);
  }

  BattleState copyWith({
    Mission? mission,
    PlayerState? player1,
    PlayerState? player2,
    int? currentRound,
    bool? isPlayer1Turn,
    BattlePhase? phase,
    BattleResult? result,
    List<BattleRoundEvent>? eventLog,
    DateTime? startTime,
    DateTime? endTime,
    int? objectivesRemoved,
  }) {
    return BattleState(
      mission: mission ?? this.mission,
      player1: player1 ?? this.player1,
      player2: player2 ?? this.player2,
      currentRound: currentRound ?? this.currentRound,
      isPlayer1Turn: isPlayer1Turn ?? this.isPlayer1Turn,
      phase: phase ?? this.phase,
      result: result ?? this.result,
      eventLog: eventLog ?? this.eventLog,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      objectivesRemoved: objectivesRemoved ?? this.objectivesRemoved,
    );
  }
}
