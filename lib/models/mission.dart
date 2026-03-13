enum MissionType { manoeuvre, attackDefend }

class DeploymentRule {
  final String title;
  final String description;

  const DeploymentRule({required this.title, required this.description});
}

class VictoryCondition {
  final String title;
  final String description;

  const VictoryCondition({required this.title, required this.description});
}

class Mission {
  final String id;
  final String name;
  final MissionType type;
  final String tagline;
  final String overview;
  final String attackerRole;
  final String defenderRole;
  final List<String> objectiveSetup;
  final List<DeploymentRule> deploymentRules;
  final List<String> startingConditions;
  final List<String> firstTurnRules;
  final List<VictoryCondition> victoryConditions;
  final List<String> specialRules;
  final int turnLimit;
  // Reserve info
  final String reserveNote;
  final bool hasReserves;

  const Mission({
    required this.id,
    required this.name,
    required this.type,
    required this.tagline,
    required this.overview,
    this.attackerRole = 'Attacker',
    this.defenderRole = 'Defender',
    required this.objectiveSetup,
    required this.deploymentRules,
    required this.startingConditions,
    required this.firstTurnRules,
    required this.victoryConditions,
    required this.specialRules,
    this.turnLimit = 6,
    this.reserveNote = '',
    this.hasReserves = false,
  });

  bool get isManoeuvre => type == MissionType.manoeuvre;
}

// ─── ALL FLAMES OF WAR v4 STANDARD MISSIONS (More Missions 2017) ──────────────
// Reserve rule (applies where stated): You may not deploy more than 60% of
// agreed points on table. The rest must be held in Reserve (= 40% minimum
// in Reserve at 95 pts → 38 pts off-table, 57 pts on-table max).

const List<Mission> fowMissions = [

  // ── MEETING ENGAGEMENTS ──────────────────────────────────────────────────

  Mission(
    id: 'free_for_all',
    name: 'Free for All',
    type: MissionType.manoeuvre,
    tagline: 'Both sides advance to seize key ground.',
    overview:
        'In Free for All both sides are attacking. Both sides deploy their entire '
        'force on the table from the start — no reserves. '
        'The battle is a race to capture objectives in the enemy\'s side of the table.',
    attackerRole: 'Player 1',
    defenderRole: 'Player 2',
    objectiveSetup: [
      'Each player places two Objectives within 8"/20cm of the opponent\'s long table edge, '
          'at least 8"/20cm from the short table edges.',
      'Starting with the Attacker (P1), each player takes turns placing Objectives.',
    ],
    deploymentRules: [
      DeploymentRule(
        title: 'Deployment Zone',
        description:
            'Both players, starting with the Attacker (P1), take turns placing '
            'one Unit within 12"/30cm of their own long table edge.',
      ),
      DeploymentRule(
        title: 'Full Deployment — No Reserves',
        description:
            'Both players deploy their entire force. There are no reserves in Free for All.',
      ),
      DeploymentRule(
        title: 'Infantry & Guns in Foxholes',
        description: 'All Infantry and Gun Teams start the game in Foxholes.',
      ),
    ],
    startingConditions: [
      'Both players roll a die — the highest scoring player has the first turn.',
      'No Ranged In markers are placed (Meeting Engagement).',
      'All Infantry and Gun Teams start in Foxholes.',
    ],
    firstTurnRules: [
      'Meeting Engagement rules apply to the first player\'s first turn only:',
      '— Aircraft cannot arrive in their first turn.',
      '— All first player\'s Teams are treated as having moved when Shooting.',
      '— No Artillery Bombardments in the first Shooting Step.',
    ],
    victoryConditions: [
      VictoryCondition(
        title: 'Capture an Objective',
        description:
            'A player wins if they start their turn with a Tank, Infantry, or Gun team '
            'within 4"/10cm of an Objective on the opponent\'s side of the table, '
            'and end it with no opposing Tank, Infantry, or Gun teams within 4"/10cm of that Objective.',
      ),
    ],
    specialRules: [
      'Meeting Engagement (first player\'s first turn only).',
      'No reserves — full deployment from the start.',
      'Bailed Out tanks, Transports, and Independent Teams cannot Hold or Contest Objectives.',
      'Teams that Dashed cannot Hold or Contest Objectives.',
    ],
    hasReserves: false,
    reserveNote: 'No reserves — both sides deploy fully.',
    turnLimit: 6,
  ),

  Mission(
    id: 'dust_up',
    name: 'Dust Up',
    type: MissionType.manoeuvre,
    tagline: 'Flanking forces collide in a swirling diagonal engagement.',
    overview:
        'In Dust Up both sides attack from opposite corners, each leaving 40% of their '
        'force in Delayed Reserve. The battle is chaotic as forces arrive and fight '
        'for objectives in the opponent\'s corner zone.',
    attackerRole: 'Player 1',
    defenderRole: 'Player 2',
    objectiveSetup: [
      'Starting with the Attacker (P1), each player places one Objective in their own quarter.',
      'Then starting with the Attacker, each player places one Objective in the opponent\'s quarter.',
      'All 4 Objectives must be at least 8"/20cm from all table edges and 12"/30cm from the table centre.',
    ],
    deploymentRules: [
      DeploymentRule(
        title: 'Deployment Corners',
        description:
            'The Attacker (P1) picks a table quarter. The Defender (P2) takes the diagonally opposite quarter.',
      ),
      DeploymentRule(
        title: 'Delayed Reserves — 40% Off-Table',
        description:
            'Both players may deploy up to 60% of their force in their quarter, at least 12"/30cm from the table centre. '
            'The remaining 40% (minimum) are Delayed Reserves.',
      ),
      DeploymentRule(
        title: 'Reserve Arrival',
        description:
            'Roll for Reserves at the start of each player\'s turn from Turn 3: '
            'roll 1 die (Turn 3), 2 dice (Turn 4), add one die each turn. '
            'Each roll of 5+ = one unit arrives from the long table edge adjacent to your quarter.',
      ),
      DeploymentRule(
        title: 'Infantry & Guns in Foxholes',
        description: 'All Infantry and Gun Teams start the game in Foxholes.',
      ),
    ],
    startingConditions: [
      'Both players roll a die — the highest scoring player has the first turn.',
      'No Ranged In markers placed (Meeting Engagement).',
      'Delayed Reserves arrive from the long table edge adjacent to the owning player\'s quarter.',
    ],
    firstTurnRules: [
      'Meeting Engagement rules apply to the first player\'s first turn only.',
      '— Aircraft cannot arrive; first player\'s Teams count as having moved; no Bombardments.',
    ],
    victoryConditions: [
      VictoryCondition(
        title: 'Capture an Objective',
        description:
            'A player wins if they start their turn with a Tank, Infantry, or Gun team '
            'within 4"/10cm of an Objective in the opponent\'s quarter, '
            'and end it with no opposing Tank, Infantry, or Gun teams within 4"/10cm of that Objective.',
      ),
    ],
    specialRules: [
      'Meeting Engagement (first player\'s first turn only).',
      'Delayed Reserves: up to 60% on table, rest arrive from Turn 3 on a 5+.',
      'If 3 or more dice rolled but no 5+ scored, one unit automatically arrives.',
      'Reserves arrive from the long edge adjacent to the player\'s quarter.',
    ],
    hasReserves: true,
    reserveNote:
        'Both sides: max 60% on table (at 95 pts = 57 pts max on-table, 38 pts minimum in Reserve). '
        'Delayed Reserves arrive from Turn 3 on 5+.',
    turnLimit: 6,
  ),

  Mission(
    id: 'encounter',
    name: 'Encounter',
    type: MissionType.manoeuvre,
    tagline: 'Advance guards collide — the main bodies arrive in a rush.',
    overview:
        'In Encounter both forces are marching into contact. Each side leaves 40% in '
        'Scattered Delayed Reserve. Objectives are placed deep in the opponent\'s half. '
        'Forces arrive from scattered directions as the battle unfolds.',
    attackerRole: 'Player 1',
    defenderRole: 'Player 2',
    objectiveSetup: [
      'Starting with the Attacker (P1), each player places two Objectives within 8"/20cm '
          'of the opponent\'s long table edge, at least 8"/20cm from the side table edges.',
    ],
    deploymentRules: [
      DeploymentRule(
        title: 'Deployment Zone',
        description:
            'Both players, starting with the Attacker (P1), take turns placing one Unit '
            'within 12"/30cm of their own long table edge.',
      ),
      DeploymentRule(
        title: 'Scattered Delayed Reserves — 40% Off-Table',
        description:
            'Both players may deploy up to 60% of their force. '
            'The remaining 40% (minimum) are Scattered Delayed Reserves.',
      ),
      DeploymentRule(
        title: 'Reserve Arrival — Scattered',
        description:
            'Roll for Reserves from Turn 3: 1 die (Turn 3), 2 dice (Turn 4), +1 die each turn. '
            'Each 5+ = one unit arrives. Roll a die to determine which table edge or corner it arrives from.',
      ),
      DeploymentRule(
        title: 'Infantry & Guns in Foxholes',
        description: 'All Infantry and Gun Teams start the game in Foxholes.',
      ),
    ],
    startingConditions: [
      'Both players roll a die — the highest scoring player has the first turn.',
      'No Ranged In markers placed (Meeting Engagement).',
      'Scattered reserves: when each unit arrives, roll to determine its table edge (see mission map).',
      'If arriving from a corner, the unit must enter within 16"/40cm of that corner.',
    ],
    firstTurnRules: [
      'Meeting Engagement rules apply to the first player\'s first turn only.',
      '— Aircraft cannot arrive; first player\'s Teams count as having moved; no Bombardments.',
    ],
    victoryConditions: [
      VictoryCondition(
        title: 'Capture an Objective',
        description:
            'A player wins if they start their turn with a Tank, Infantry, or Gun team '
            'within 4"/10cm of an Objective on the opponent\'s side of the table, '
            'and end it with no opposing Tank, Infantry, or Gun teams within 4"/10cm of that Objective.',
      ),
    ],
    specialRules: [
      'Meeting Engagement (first player\'s first turn only).',
      'Scattered Delayed Reserves: arrive from Turn 3 on 5+, from a randomly determined table edge.',
      'If 3+ dice rolled but no 5+, one unit automatically arrives.',
      'Corner arrivals must enter within 16"/40cm of that corner.',
    ],
    hasReserves: true,
    reserveNote:
        'Both sides: max 60% on table (at 95 pts = 57 pts max, 38 pts minimum off-table). '
        'Scattered Delayed Reserves arrive from Turn 3 on 5+.',
    turnLimit: 6,
  ),

  Mission(
    id: 'annihilation',
    name: 'Annihilation',
    type: MissionType.manoeuvre,
    tagline: 'No ground to hold — only enemies to destroy.',
    overview:
        'In Annihilation there are no objectives. Both sides deploy fully and the sole '
        'victory condition is the destruction of the enemy force. A brutal battle of attrition.',
    attackerRole: 'Player 1',
    defenderRole: 'Player 2',
    objectiveSetup: [
      'No Objectives are placed in Annihilation.',
      'The sole victory condition is destroying all enemy Formations.',
    ],
    deploymentRules: [
      DeploymentRule(
        title: 'Deployment Zone',
        description:
            'Both players, starting with the Attacker (P1), take turns placing one Unit '
            'within 12"/30cm of their own long table edge.',
      ),
      DeploymentRule(
        title: 'Full Deployment — No Reserves',
        description: 'Both players deploy their entire force. There are no reserves in Annihilation.',
      ),
      DeploymentRule(
        title: 'Infantry & Guns in Foxholes',
        description: 'All Infantry and Gun Teams start the game in Foxholes.',
      ),
    ],
    startingConditions: [
      'Both players roll a die — the highest scoring player has the first turn.',
      'No Ranged In markers placed (Meeting Engagement).',
      'All Infantry and Gun Teams start in Foxholes.',
    ],
    firstTurnRules: [
      'Meeting Engagement rules apply to the first player\'s first turn only.',
      '— Aircraft cannot arrive; first player\'s Teams count as having moved; no Bombardments.',
    ],
    victoryConditions: [
      VictoryCondition(
        title: 'Annihilate the Enemy',
        description:
            'A player wins if their opponent has no Formations left on the table.',
      ),
    ],
    specialRules: [
      'Meeting Engagement (first player\'s first turn only).',
      'No Objectives — victory is by total destruction.',
      'No reserves — full deployment from the start.',
    ],
    hasReserves: false,
    reserveNote: 'No reserves — both sides deploy fully.',
    turnLimit: 0,
  ),

  // ── ATTACKER vs DEFENDER ─────────────────────────────────────────────────

  Mission(
    id: 'no_retreat',
    name: 'No Retreat',
    type: MissionType.attackDefend,
    tagline: 'Hold the line — there is nowhere to fall back to.',
    overview:
        'The Defender picks a short table edge and holds a position that must not fall. '
        'Dug-in troops with Deep Immediate Reserves make this a battle of nerve. '
        'The Attacker must overwhelm defences; the Defender wins by Turn 6.',
    attackerRole: 'Attacker',
    defenderRole: 'Defender',
    objectiveSetup: [
      'Starting with the Defender, each player places one Objective in the Defender\'s half.',
      'Each Objective must be at least 8"/20cm from the table centre line and all table edges.',
    ],
    deploymentRules: [
      DeploymentRule(
        title: 'Table Orientation',
        description:
            'The Defender picks a SHORT table edge to defend from. The Attacker attacks from the opposite short edge.',
      ),
      DeploymentRule(
        title: 'Defender — Deep Immediate Reserves',
        description:
            'Defender deploys up to 60% of their force in their half. '
            'Remainder are Deep Immediate Reserves. '
            'No more than one Tank Unit with Front armour 3+ or Aircraft Unit may deploy on table — '
            'all remaining Units of those types must be held in Reserve.',
      ),
      DeploymentRule(
        title: 'Attacker — Full Deployment',
        description:
            'Attacker deploys all Units in their half at least 16"/40cm from the table centre line.',
      ),
      DeploymentRule(
        title: 'Defender Reserve Arrival',
        description:
            'Roll at start of Defender\'s Turn 1: 1 die (5+ = arrives). '
            'Turn 2: 2 dice. Add one die each turn. 3+ dice but no 5+ = one unit automatically arrives. '
            'Reserves enter from the Defender\'s short table edge.',
      ),
      DeploymentRule(
        title: 'Ambush & Foxholes',
        description:
            'Defender may hold one Unit in Ambush. All Infantry and Gun Teams start in Foxholes.',
      ),
    ],
    startingConditions: [
      'The Attacker has the first turn.',
      'Defender starts Dug In (in Foxholes).',
      'Defender may use Ambush — Unit placed within 6"/15cm of Unit Leader, at least 16"/40cm from enemy in LoS and 4"/10cm from all enemy.',
      'Deep Immediate Reserves enter from the Defender\'s short table edge.',
    ],
    firstTurnRules: [
      'Defender may place Ambush unit at the start of their first turn.',
      'Defender Immediate Reserves begin rolling from Turn 1.',
    ],
    victoryConditions: [
      VictoryCondition(
        title: 'Attacker Captures an Objective',
        description:
            'Attacker wins if they start their turn with a Tank, Infantry, or Gun team '
            'within 4"/10cm of an Objective, and end it with no Defending Tank, '
            'Infantry, or Gun teams within 4"/10cm of that Objective.',
      ),
      VictoryCondition(
        title: 'Defender Holds the Line',
        description:
            'Defender wins if they end a turn on or after Turn 6 with no Attacking '
            'Tank, Infantry, or Gun teams within 8"/20cm of any Objective.',
      ),
    ],
    specialRules: [
      'Defender starts Dug In (Foxholes).',
      'Defender may use Ambush (one Unit).',
      'Deep Immediate Reserves: limited heavy tanks/aircraft on-table; rest must be in Reserve.',
      'Reserves arrive from Defender\'s short table edge from Turn 1 on 5+.',
    ],
    hasReserves: true,
    reserveNote:
        'Defender: max 60% on table (at 95 pts = 57 pts max on-table, 38 pts minimum in Reserve). '
        'Immediate Reserves roll from Turn 1 on 5+. Heavy armour must be kept in Reserve.',
    turnLimit: 6,
  ),

  Mission(
    id: 'hasty_attack',
    name: 'Hasty Attack',
    type: MissionType.attackDefend,
    tagline: 'Strike fast before the enemy can consolidate.',
    overview:
        'The Attacker launches an immediate assault before the Defender can dig in. '
        'Most of the Defender\'s force is still arriving as the Attacker surges forward.',
    attackerRole: 'Attacker',
    defenderRole: 'Defender',
    objectiveSetup: [
      'Defender places one Objective in their half (at least 12"/30cm from centre line, 8"/20cm from table edges).',
      'Defender places one Objective in the Attacker\'s half (at least 16"/40cm from centre, 8"/20cm from short edges).',
      'Attacker places two Objectives in the Defender\'s half (at least 12"/30cm from centre, 8"/20cm from short edges).',
      'The Attacker then removes one of the two Objectives they placed — leaving 3 Objectives total.',
    ],
    deploymentRules: [
      DeploymentRule(
        title: 'Defender — Scattered Delayed Reserves',
        description:
            'Defender deploys up to 60% of their force in their half at least 8"/20cm from the centre line. '
            'Remainder are Scattered Delayed Reserves (arrive from Turn 3 on 5+, from a random table edge).',
      ),
      DeploymentRule(
        title: 'Attacker — Immediate Reserves',
        description:
            'Attacker deploys up to 60% of their force in their half at least 12"/30cm from the centre line. '
            'Remainder are Immediate Reserves (arrive from Turn 1 on 5+) from the Attacker\'s long table edge.',
      ),
      DeploymentRule(
        title: 'Ambush & Foxholes',
        description:
            'Defender may hold one Unit in Ambush. All Infantry and Gun Teams start in Foxholes.',
      ),
    ],
    startingConditions: [
      'The Attacker has the first turn.',
      'Defender Scattered Delayed Reserves: roll from Turn 3, arrive at random table edge.',
      'Attacker Immediate Reserves: roll from Turn 1, arrive from Attacker\'s long table edge.',
    ],
    firstTurnRules: [
      'Defender may place Ambush unit at start of their first turn.',
      'Attacker begins rolling for Immediate Reserves from Turn 1.',
    ],
    victoryConditions: [
      VictoryCondition(
        title: 'Capture an Objective',
        description:
            'A player wins if they start their turn with a Tank, Infantry, or Gun team '
            'within 4"/10cm of an Objective on the opponent\'s side of the table, '
            'and end it with no opposing Tank, Infantry, or Gun teams within 4"/10cm of that Objective.',
      ),
    ],
    specialRules: [
      'Defender has Scattered Delayed Reserves (from Turn 3 on 5+, random table edge).',
      'Attacker has Immediate Reserves (from Turn 1 on 5+, own long edge).',
      'Defender may use Ambush (one Unit).',
      '3 Objectives total (4 placed, Attacker removes one of theirs).',
    ],
    hasReserves: true,
    reserveNote:
        'Both sides: max 60% on table (at 95 pts = 57 pts on-table max, 38 pts minimum in Reserve). '
        'Attacker Immediate Reserves from Turn 1; Defender Scattered Delayed from Turn 3.',
    turnLimit: 6,
  ),

  Mission(
    id: 'contact',
    name: 'Contact',
    type: MissionType.attackDefend,
    tagline: 'The front line is fluid — push through before they consolidate.',
    overview:
        'Both forces have 40% in Reserve. The Attacker\'s reserves are Immediate; '
        'the Defender\'s are Scattered Delayed. Four Objectives cover both halves of the table. '
        'Win by capturing an Objective in the opponent\'s half.',
    attackerRole: 'Attacker',
    defenderRole: 'Defender',
    objectiveSetup: [
      'Defender places two Objectives in the Attacker\'s half (at least 16"/40cm from centre, 8"/20cm from short edges).',
      'Attacker places two Objectives in the Defender\'s half (at least 12"/30cm from centre, 8"/20cm from short edges).',
    ],
    deploymentRules: [
      DeploymentRule(
        title: 'Attacker — Immediate Reserves',
        description:
            'Attacker deploys up to 60% of their force in their half at least 12"/30cm from the centre line. '
            'Remainder are Immediate Reserves from the Attacker\'s long table edge (roll from Turn 1 on 5+).',
      ),
      DeploymentRule(
        title: 'Defender — Scattered Delayed Reserves',
        description:
            'Defender deploys up to 60% of their force in their half at least 8"/20cm from the centre line. '
            'Remainder are Scattered Delayed Reserves (arrive from Turn 3 on 5+, from a random table edge).',
      ),
      DeploymentRule(
        title: 'Ambush & Foxholes',
        description:
            'Defender may hold one Unit in Ambush. All Infantry and Gun Teams start in Foxholes.',
      ),
    ],
    startingConditions: [
      'The Attacker has the first turn.',
      'Attacker Immediate Reserves arrive from Attacker\'s long table edge from Turn 1 on 5+.',
      'Defender Scattered Delayed Reserves arrive from a random table edge from Turn 3 on 5+.',
      'If 3+ dice but no 5+ scored, one unit automatically arrives.',
    ],
    firstTurnRules: [
      'Defender may place Ambush unit at start of their first turn.',
      'Attacker starts rolling for Immediate Reserves immediately from Turn 1.',
    ],
    victoryConditions: [
      VictoryCondition(
        title: 'Capture an Objective',
        description:
            'A player wins if they start their turn with a Tank, Infantry, or Gun team '
            'within 4"/10cm of an Objective on the opponent\'s side of the table, '
            'and end it with no opposing Tank, Infantry, or Gun teams within 4"/10cm of that Objective.',
      ),
    ],
    specialRules: [
      'Attacker: Immediate Reserves from Turn 1 on 5+ (own long edge).',
      'Defender: Scattered Delayed Reserves from Turn 3 on 5+ (random edge).',
      'Defender may use Ambush (one Unit).',
      '4 Objectives — 2 in each half.',
    ],
    hasReserves: true,
    reserveNote:
        'Both sides: max 60% on table (at 95 pts = 57 pts on-table max, 38 pts minimum in Reserve). '
        'Attacker Immediate from Turn 1; Defender Scattered Delayed from Turn 3.',
    turnLimit: 6,
  ),

  Mission(
    id: 'counterattack',
    name: 'Counterattack',
    type: MissionType.attackDefend,
    tagline: 'A bold thrust meets a furious counter-punch.',
    overview:
        'The Defender picks a table quarter and the Attacker takes an adjacent quarter. '
        'The Defender holds Immediate Reserves ready to seal the breach. '
        'Victory checks begin on Turn 6.',
    attackerRole: 'Attacker',
    defenderRole: 'Defender',
    objectiveSetup: [
      'Defender places one Objective in their own quarter (at least 8"/20cm from all table edges, 12"/30cm from table centre).',
      'Attacker places one Objective in the quarter opposite to their own (same distance requirements).',
    ],
    deploymentRules: [
      DeploymentRule(
        title: 'Deployment Quarters',
        description:
            'The Defender picks a table quarter. '
            'The Attacker picks an adjacent quarter (sharing either a long or short table edge).',
      ),
      DeploymentRule(
        title: 'Attacker — Full Deployment',
        description:
            'Attacker deploys all Units in their quarter at least 8"/20cm from both centrelines.',
      ),
      DeploymentRule(
        title: 'Defender — Immediate Reserves',
        description:
            'Defender deploys up to 60% of their force in their quarter at least 12"/30cm from the table centre. '
            'Remainder are Immediate Reserves, arriving within 16"/40cm of the corner opposite the Defender\'s quarter. '
            'Roll from Turn 1 on 5+.',
      ),
      DeploymentRule(
        title: 'Ambush & Foxholes',
        description:
            'Defender may hold one Unit in Ambush. All Infantry and Gun Teams start in Foxholes.',
      ),
    ],
    startingConditions: [
      'The Attacker has the first turn.',
      'Defender Immediate Reserves: roll from Turn 1 on 5+, arrive within 16"/40cm of opposite corner.',
    ],
    firstTurnRules: [
      'Defender may place Ambush unit at start of their first turn.',
      'Defender starts rolling for Immediate Reserves from Turn 1.',
    ],
    victoryConditions: [
      VictoryCondition(
        title: 'Attacker Captures an Objective (Turn 6+)',
        description:
            'Attacker wins if they start their turn on or after Turn 6 with a Tank, Infantry, or Gun team '
            'within 4"/10cm of an Objective, and end it with no Defending teams within 4"/10cm of that Objective.',
      ),
      VictoryCondition(
        title: 'Defender Holds (Turn 6+)',
        description:
            'Defender wins if they end a turn on or after Turn 6 with no Attacking Tank, '
            'Infantry, or Gun teams within 8"/20cm of any Objective.',
      ),
    ],
    specialRules: [
      'Victory conditions only check from Turn 6 onwards.',
      'Defender has Immediate Reserves from Turn 1 on 5+.',
      'Defender may use Ambush (one Unit).',
      'Adjacent quarter deployment — not diagonal.',
    ],
    hasReserves: true,
    reserveNote:
        'Defender: max 60% on table (at 95 pts = 57 pts on-table max, 38 pts minimum in Reserve). '
        'Immediate Reserves roll from Turn 1 on 5+, arrive near opposite corner.',
    turnLimit: 6,
  ),

  Mission(
    id: 'bridgehead',
    name: 'Bridgehead',
    type: MissionType.attackDefend,
    tagline: 'Cross the river and hold the far bank.',
    overview:
        'The Attacker must force a crossing and establish a bridgehead on the far bank. '
        'The Defender holds the far bank with Deep Scattered Immediate Reserves. '
        'Attacker wins any turn; Defender wins from Turn 6.',
    attackerRole: 'Attacker',
    defenderRole: 'Defender',
    objectiveSetup: [
      'The Attacker places two Objectives at least 8"/20cm from the table centre line, '
          'at least 8"/20cm from the long table edge, and at least 28"/70cm from the short table edges.',
    ],
    deploymentRules: [
      DeploymentRule(
        title: 'Defender — Deep Scattered Immediate Reserves',
        description:
            'Defender deploys up to 60% of their force in their half at least 20"/50cm from the side table edges. '
            'Remainder are Deep Scattered Immediate Reserves (roll from Turn 1 on 5+, arrive at a random table edge). '
            'No more than one Tank Unit with Front armour 3+ or Aircraft Unit on table.',
      ),
      DeploymentRule(
        title: 'Attacker — Full Deployment',
        description:
            'Attacker deploys all Units in their half at least 16"/40cm from the table centre line, '
            'OR within 8"/20cm of either side table edge.',
      ),
      DeploymentRule(
        title: 'Ambush & Foxholes',
        description:
            'Defender may hold one Unit in Ambush. All Infantry and Gun Teams start in Foxholes.',
      ),
    ],
    startingConditions: [
      'The Attacker has the first turn.',
      'Defender Deep Scattered Immediate Reserves: roll from Turn 1 on 5+, arrive at random table edge.',
      'Heavy armour must be kept in Reserve (same restriction as No Retreat).',
    ],
    firstTurnRules: [
      'Defender may place Ambush unit at start of their first turn.',
      'Defender starts rolling for Reserves from Turn 1.',
    ],
    victoryConditions: [
      VictoryCondition(
        title: 'Attacker Establishes Bridgehead',
        description:
            'Attacker wins if they start their turn with a Tank, Infantry, or Gun team '
            'within 4"/10cm of an Objective, and end it with no Defending teams within 4"/10cm of that Objective. '
            '(Can win any turn.)',
      ),
      VictoryCondition(
        title: 'Defender Repels the Crossing',
        description:
            'Defender wins if they end a turn on or after Turn 6 with no Attacking Tank, '
            'Infantry, or Gun teams within 8"/20cm of any Objective.',
      ),
    ],
    specialRules: [
      'Defender: Deep Scattered Immediate Reserves from Turn 1 on 5+, random table edge.',
      'Heavy armour must be kept in Reserve.',
      'Defender may use Ambush (one Unit).',
      'Attacker may win any turn; Defender win condition activates Turn 6+.',
    ],
    hasReserves: true,
    reserveNote:
        'Defender: max 60% on table (at 95 pts = 57 pts on-table max, 38 pts minimum in Reserve). '
        'Heavy armour must be in Reserve. Immediate Reserves roll from Turn 1 on 5+.',
    turnLimit: 6,
  ),

  Mission(
    id: 'breakthrough',
    name: 'Breakthrough',
    type: MissionType.attackDefend,
    tagline: 'Punch through the enemy line before the flanks close.',
    overview:
        'The Attacker deploys in one corner and must break through to capture '
        'Objectives in the far corner of the table. The Defender deploys across the middle '
        'with Flanking Delayed Reserves arriving from the far edges.',
    attackerRole: 'Attacker',
    defenderRole: 'Defender',
    objectiveSetup: [
      'The Attacker places two Objectives in the table quarter diagonally opposite their deployment corner.',
      'Objectives must be at least 8"/20cm from all table edges.',
    ],
    deploymentRules: [
      DeploymentRule(
        title: 'Defender — Immediate Reserves',
        description:
            'Defender deploys up to 60% of their force. Deployed Units go in the two table quarters '
            'adjacent to the Attacker\'s corner. Remainder are Immediate Reserves arriving within 16"/40cm '
            'of either of the Defender\'s deployment corners (roll from Turn 1 on 5+).',
      ),
      DeploymentRule(
        title: 'Attacker — Flanking Delayed Reserves',
        description:
            'Attacker deploys in one table quarter at least 8"/20cm from both centrelines. '
            'Must hold at least one Unit as Flanking Delayed Reserves, arriving within 16"/40cm '
            'of the Objective corner (roll from Turn 3 on 5+).',
      ),
      DeploymentRule(
        title: 'Ambush & Foxholes',
        description:
            'Defender may hold one Unit in Ambush. All Infantry and Gun Teams start in Foxholes.',
      ),
    ],
    startingConditions: [
      'The Attacker has the first turn.',
      'Defender Immediate Reserves: roll from Turn 1 on 5+, arrive at Defender\'s corners.',
      'Attacker Flanking Delayed Reserves: roll from Turn 3 on 5+, arrive near Objective corner.',
    ],
    firstTurnRules: [
      'Defender may place Ambush unit at start of their first turn.',
      'Victory conditions check from Turn 6 onwards.',
    ],
    victoryConditions: [
      VictoryCondition(
        title: 'Attacker Breaks Through (Turn 6+)',
        description:
            'Attacker wins if they start their turn on or after Turn 6 with a Tank, Infantry, or Gun team '
            'within 4"/10cm of an Objective, and end it with no Defending teams within 4"/10cm of that Objective.',
      ),
      VictoryCondition(
        title: 'Defender Seals the Breach (Turn 6+)',
        description:
            'Defender wins if they end a turn on or after Turn 6 with no Attacking Tank, '
            'Infantry, or Gun teams within 8"/20cm of any Objective.',
      ),
    ],
    specialRules: [
      'Victory conditions check from Turn 6 onwards.',
      'Defender: Immediate Reserves from Turn 1 on 5+ (own corners).',
      'Attacker: at least one Unit must be held as Flanking Delayed Reserve (from Turn 3 on 5+).',
      'Defender may use Ambush (one Unit).',
    ],
    hasReserves: true,
    reserveNote:
        'Defender: max 60% on table (at 95 pts = 57 pts max, 38 pts minimum in Reserve). '
        'Attacker: minimum 1 Unit as Flanking Reserve (arrives near Objective corner from Turn 3).',
    turnLimit: 6,
  ),

  Mission(
    id: 'rearguard',
    name: 'Rearguard',
    type: MissionType.attackDefend,
    tagline: 'Buy time for the army to escape.',
    overview:
        'The Defender fights a delaying action. Starting Turn 2, the Defender must '
        'use Strategic Withdrawal to remove Units from the table. '
        'The Defender wins at the start of their 9th turn.',
    attackerRole: 'Attacker',
    defenderRole: 'Defender',
    objectiveSetup: [
      'The Attacker places two Objectives within 16"/40cm of the Defender\'s long table edge, '
          'at least 16"/40cm from the side table edges.',
    ],
    deploymentRules: [
      DeploymentRule(
        title: 'Defender — Full Deployment',
        description: 'Defender deploys all Units in their table half.',
      ),
      DeploymentRule(
        title: 'Attacker — Full Deployment',
        description: 'Attacker deploys all Units within 8"/20cm of their own long table edge.',
      ),
      DeploymentRule(
        title: 'Ambush & Foxholes',
        description:
            'Defender may hold one Unit in Ambush. All Infantry and Gun Teams start in Foxholes.',
      ),
    ],
    startingConditions: [
      'The Attacker has the first turn.',
      'No reserves — both sides deploy fully.',
      'Strategic Withdrawal begins from Turn 2.',
    ],
    firstTurnRules: [
      'Defender may place Ambush unit at start of their first turn.',
      'From Turn 2 onwards: at the start of each turn, after checking Victory Conditions, '
          'count the Defender\'s Units + Delay Counters on table. '
          'If 6 or more: remove one Unit and its Attachments, clear all Delay Counters. '
          'If less than 6: gain a Delay Counter (no withdrawal).',
      'A Unit not in Good Spirits when withdrawn counts as Destroyed for VP purposes.',
    ],
    victoryConditions: [
      VictoryCondition(
        title: 'Attacker Captures an Objective',
        description:
            'Attacker wins if they start their turn with a Tank, Infantry, or Gun team '
            'within 4"/10cm of an Objective, and end it with no Defending teams within 4"/10cm of that Objective. '
            '(Can win any turn.)',
      ),
      VictoryCondition(
        title: 'Defender Withdraws Successfully',
        description:
            'Defender wins at the start of their 9th turn (after checking Formation Morale).',
      ),
    ],
    specialRules: [
      'Strategic Withdrawal from Turn 2: if 6+ Units/Delay Counters → withdraw 1 Unit; else gain a Delay Counter.',
      'Withdrawn Units in Good Spirits do NOT count as Destroyed for VP.',
      'Defender may use Ambush (one Unit).',
      'Defender wins at start of Turn 9.',
    ],
    hasReserves: false,
    reserveNote: 'No reserves — both sides deploy fully. Strategic Withdrawal removes units from Turn 2.',
    turnLimit: 9,
  ),

  // ── MISSIONS PACK (April 2023) — NEW & VARIANT MISSIONS ──────────────────

  Mission(
    id: 'probe',
    name: 'Probe',
    type: MissionType.attackDefend,
    tagline: 'Strike before the enemy knows you\'re there.',
    overview:
        'Both sides probe forward with advance guards and Immediate Reserves. '
        'Victory objectives are contested from the very first turn — '
        'a fast and furious engagement with no time to dig in.',
    attackerRole: 'Attacker',
    defenderRole: 'Defender',
    objectiveSetup: [
      'Defender places two Objectives in the Attacker\'s half at least 16"/40cm from the centre line and 8"/20cm from short table edges.',
      'Attacker places two Objectives in the Defender\'s half at least 16"/40cm from the centre line and 8"/20cm from short table edges.',
    ],
    deploymentRules: [
      DeploymentRule(
        title: 'Both Sides — Immediate Reserves',
        description:
            'Both players deploy up to 60% of their force in their own half. '
            'Remainder are Immediate Reserves arriving from their own long table edge (roll from Turn 1 on 5+).',
      ),
      DeploymentRule(
        title: 'Ambush (Defender)',
        description: 'Defender may hold one Unit in Ambush.',
      ),
      DeploymentRule(
        title: 'Infantry & Guns in Foxholes',
        description: 'All Infantry and Gun Teams start in Foxholes.',
      ),
    ],
    startingConditions: [
      'The Attacker has the first turn.',
      'Meeting Engagement applies to the Attacker\'s first turn.',
      'Both sides roll for Immediate Reserves from Turn 1.',
    ],
    firstTurnRules: [
      'Meeting Engagement applies to the Attacker\'s first turn only.',
      'Defender may place Ambush unit at start of their first turn.',
      'Both sides roll for Immediate Reserves from Turn 1.',
    ],
    victoryConditions: [
      VictoryCondition(
        title: 'Capture an Objective (from Turn 1)',
        description:
            'A player wins if they start any turn with a Tank, Infantry, or Gun team '
            'within 4"/10cm of an Objective on the opponent\'s side, '
            'and end it with no opposing teams within 4"/10cm of that Objective.',
      ),
    ],
    specialRules: [
      'Victory conditions active from Turn 1 — no waiting until Turn 6.',
      'Both sides: Immediate Reserves from Turn 1 on 5+.',
      'Meeting Engagement for Attacker\'s first turn only.',
      'Defender may use Ambush (one Unit).',
      '4 Objectives — 2 in each half.',
    ],
    hasReserves: true,
    reserveNote: 'Both sides: max 60% on table. Immediate Reserves from Turn 1 on 5+.',
    turnLimit: 6,
  ),

  Mission(
    id: 'scouts_out',
    name: 'Scouts Out',
    type: MissionType.manoeuvre,
    tagline: 'Recon units race ahead to seize key ground.',
    overview:
        'Both sides send their fastest scouts ahead before the main body deploys. '
        'With Recce teams already in the field, the main force follows up '
        'in a fluid Meeting Engagement over four objectives.',
    attackerRole: 'Player 1',
    defenderRole: 'Player 2',
    objectiveSetup: [
      'Starting with Player 1, each player places two Objectives in the opponent\'s half at least 8"/20cm from all table edges.',
    ],
    deploymentRules: [
      DeploymentRule(
        title: 'Recce Forward Deployment',
        description:
            'Before normal deployment, each player may move any Recce or Scout Units up to 8"/20cm forward from their deployment zone.',
      ),
      DeploymentRule(
        title: 'Deployment Zone',
        description:
            'Both players take turns placing Units within 12"/30cm of their own long table edge.',
      ),
      DeploymentRule(
        title: 'Full Deployment — No Reserves',
        description: 'Both sides deploy their entire force. No Reserves.',
      ),
      DeploymentRule(
        title: 'Infantry & Guns in Foxholes',
        description: 'All Infantry and Gun Teams start in Foxholes.',
      ),
    ],
    startingConditions: [
      'Both players roll — the highest scoring player has the first turn.',
      'Recce/Scout Units may advance up to 8"/20cm before deployment.',
      'Meeting Engagement applies to the first player\'s first turn.',
    ],
    firstTurnRules: [
      'Meeting Engagement applies to the first player\'s first turn only.',
    ],
    victoryConditions: [
      VictoryCondition(
        title: 'Capture an Objective',
        description:
            'A player wins if they start their turn with a Tank, Infantry, or Gun team '
            'within 4"/10cm of an Objective in the opponent\'s half, '
            'and end it with no opposing teams within 4"/10cm of that Objective.',
      ),
    ],
    specialRules: [
      'Recce/Scout Units may advance 8"/20cm before normal deployment.',
      'Meeting Engagement for first player\'s first turn.',
      'No Reserves — full deployment.',
    ],
    hasReserves: false,
    reserveNote: 'No reserves — both sides deploy fully.',
    turnLimit: 6,
  ),

  Mission(
    id: 'fighting_withdrawal',
    name: 'Fighting Withdrawal',
    type: MissionType.attackDefend,
    tagline: 'Hold as long as possible, then pull back.',
    overview:
        'The Defender holds three objectives but must progressively withdraw. '
        'Starting Turn 2, one objective is removed each turn as forces pull back. '
        'The Attacker must capture objectives before they disappear. '
        'Defender wins by surviving to Turn 6 with no objectives for the enemy to capture.',
    attackerRole: 'Attacker',
    defenderRole: 'Defender',
    objectiveSetup: [
      'The Attacker places three Objectives in the Defender\'s half: '
          'one within 8"/20cm of the Defender\'s table edge, one at the centre, '
          'and one between them. All at least 8"/20cm from the short table edges.',
    ],
    deploymentRules: [
      DeploymentRule(
        title: 'Defender — Full Deployment',
        description: 'Defender deploys all Units in their half.',
      ),
      DeploymentRule(
        title: 'Attacker — Full Deployment',
        description:
            'Attacker deploys all Units within 12"/30cm of their own long table edge.',
      ),
      DeploymentRule(
        title: 'Ambush (Defender)',
        description: 'Defender may hold one Unit in Ambush.',
      ),
      DeploymentRule(
        title: 'Infantry & Guns in Foxholes',
        description: 'All Infantry and Gun Teams start in Foxholes.',
      ),
    ],
    startingConditions: [
      'The Attacker has the first turn.',
      'Three Objectives in the Defender\'s half.',
      'From Turn 2, Defender removes one Objective at start of each Defender\'s turn until one remains. The last Objective cannot be removed.',
    ],
    firstTurnRules: [
      'Defender may place Ambush unit at start of their first turn.',
      'Starting Turn 2: Defender removes one Objective per turn (until 1 remains).',
    ],
    victoryConditions: [
      VictoryCondition(
        title: 'Attacker Captures an Objective',
        description:
            'Attacker wins if they start their turn Holding an Objective in the Defender\'s half.',
      ),
      VictoryCondition(
        title: 'Defender Completes Withdrawal',
        description:
            'Defender wins if they end Turn 6 with no Attacking teams within 8"/20cm of the last remaining Objective.',
      ),
    ],
    specialRules: [
      'Three Objectives placed in Defender\'s half.',
      'From Turn 2: Defender removes 1 Objective per turn (until 1 remains — final cannot be removed).',
      'Defender may use Ambush (one Unit).',
      'No Reserves — both sides deploy fully.',
    ],
    hasReserves: false,
    reserveNote: 'No reserves — both sides deploy fully.',
    turnLimit: 6,
  ),

  Mission(
    id: 'covering_force',
    name: 'Covering Force',
    type: MissionType.attackDefend,
    tagline: 'Buy time for the army to escape — then get out yourself.',
    overview:
        'A variant of Fighting Withdrawal. The Defender fights a delaying action '
        'with a Covering Force while the rest of the army escapes. '
        'The Covering Force must withdraw before being destroyed.',
    attackerRole: 'Attacker',
    defenderRole: 'Defender',
    objectiveSetup: [
      'The Attacker places two Objectives within 16"/40cm of the Defender\'s long table edge, '
          'at least 16"/40cm from the side table edges.',
    ],
    deploymentRules: [
      DeploymentRule(
        title: 'Defender — Full Deployment',
        description: 'Defender deploys all Units in their table half.',
      ),
      DeploymentRule(
        title: 'Attacker — Full Deployment',
        description: 'Attacker deploys all Units within 8"/20cm of their own long table edge.',
      ),
      DeploymentRule(
        title: 'Ambush (Defender)',
        description: 'Defender may hold one Unit in Ambush.',
      ),
      DeploymentRule(
        title: 'Covering Force Withdrawal',
        description:
            'From Turn 2, Defender may withdraw one Unit per turn off the Defender\'s table edge. '
            'A Unit not in Good Spirits when withdrawn counts as Destroyed for Victory Points.',
      ),
    ],
    startingConditions: [
      'The Attacker has the first turn.',
      'Strategic Withdrawal begins from Turn 2.',
    ],
    firstTurnRules: [
      'Defender may place Ambush unit at start of their first turn.',
      'From Turn 2: Defender may withdraw one Unit per turn off their table edge.',
    ],
    victoryConditions: [
      VictoryCondition(
        title: 'Attacker Captures an Objective',
        description:
            'Attacker wins if they start their turn Holding an Objective, '
            'with no Defending teams within 4"/10cm of it.',
      ),
      VictoryCondition(
        title: 'Defender Withdraws',
        description:
            'Defender wins at the start of their 9th turn (after checking Formation Morale).',
      ),
    ],
    specialRules: [
      'Strategic Withdrawal from Turn 2: Defender may remove one Unit per turn off their edge.',
      'Withdrawn Units in Good Spirits do NOT count as Destroyed.',
      'Defender may use Ambush (one Unit).',
      'Defender wins at start of Turn 9.',
    ],
    hasReserves: false,
    reserveNote: 'No reserves — both sides deploy fully.',
    turnLimit: 9,
  ),

  Mission(
    id: 'spearpoint',
    name: 'Spearpoint',
    type: MissionType.attackDefend,
    tagline: 'Drive a steel wedge through the enemy line.',
    overview:
        'The Attacker concentrates their force for a narrow spearhead assault '
        'down the centre of the table. The Defender holds both flanks and '
        'rushes reserves to seal the breach. '
        'Victory objectives lie deep in the Defender\'s zone.',
    attackerRole: 'Attacker',
    defenderRole: 'Defender',
    objectiveSetup: [
      'The Attacker places two Objectives in the Defender\'s half at least 8"/20cm from all table edges and at least 12"/30cm from the table centre.',
    ],
    deploymentRules: [
      DeploymentRule(
        title: 'Attacker — Spearhead Deployment',
        description:
            'Attacker deploys all Units within 12"/30cm of the long table centre line '
            'and within 16"/40cm of their own short table edge.',
      ),
      DeploymentRule(
        title: 'Defender — Flanking Deployment',
        description:
            'Defender deploys up to 60% of their force split between the two table quarters '
            'adjacent to the Attacker\'s short edge (i.e. NOT directly opposite the Attacker). '
            'Remainder are Immediate Reserves arriving from either of those corners.',
      ),
      DeploymentRule(
        title: 'Reserve Arrival (Defender)',
        description:
            'Roll from Turn 1 on 5+. Reserves arrive within 16"/40cm of either of the Defender\'s flank corners.',
      ),
      DeploymentRule(
        title: 'Ambush & Foxholes',
        description:
            'Defender may hold one Unit in Ambush. All Infantry and Gun Teams start in Foxholes.',
      ),
    ],
    startingConditions: [
      'The Attacker has the first turn.',
      'Defender\'s Immediate Reserves roll from Turn 1.',
    ],
    firstTurnRules: [
      'Defender may place Ambush at start of their first turn.',
      'Defender rolls for Immediate Reserves from Turn 1.',
    ],
    victoryConditions: [
      VictoryCondition(
        title: 'Attacker Breaks Through (Turn 6+)',
        description:
            'Attacker wins if they end their turn on or after Turn 6 Holding an Objective.',
      ),
      VictoryCondition(
        title: 'Defender Repels the Spearhead (Turn 6+)',
        description:
            'Defender wins if they end their turn on or after Turn 6 having Repelled the Attack.',
      ),
    ],
    specialRules: [
      'Attacker deploys in a narrow central corridor.',
      'Defender deploys on the flanks, NOT opposite the Attacker.',
      'Defender: Immediate Reserves from Turn 1 on 5+ (own flank corners).',
      'Defender may use Ambush (one Unit).',
      'Victory conditions from Turn 6.',
    ],
    hasReserves: true,
    reserveNote:
        'Defender: max 60% on table. Immediate Reserves roll from Turn 1 on 5+, arrive at flank corners.',
    turnLimit: 6,
  ),

  Mission(
    id: 'bypass',
    name: 'Bypass',
    type: MissionType.attackDefend,
    tagline: 'Cut around the flank and seize the rear.',
    overview:
        'A variant of Spearpoint. The Attacker bypasses the main defensive line '
        'via a flanking route. Objectives are placed near both players\' edges '
        'in a fast-moving race to hold ground deep in enemy territory. '
        'Victory from Turn 3.',
    attackerRole: 'Attacker',
    defenderRole: 'Defender',
    objectiveSetup: [
      'Defender places two Objectives up to 8"/20cm from the Attacker\'s table edge and more than 8"/20cm from the long table edges.',
      'Attacker places two Objectives up to 16"/40cm from the opposite short table edge, at least 8"/20cm from the long table edges.',
    ],
    deploymentRules: [
      DeploymentRule(
        title: 'Defender Deployment',
        description:
            'Defender\'s Deployment Area runs between their long table edge and the centre, '
            '12"/30cm wide either side of the table centre. '
            'Defender deploys up to 60% of their force there. No Spearhead.',
      ),
      DeploymentRule(
        title: 'Attacker Deployment',
        description:
            'Attacker deploys up to 60% of their force in their half at least 24"/60cm from the long centre line. '
            'No Spearhead. Immediate Reserves arrive from the Attacker\'s short table edge.',
      ),
      DeploymentRule(
        title: 'Immediate Reserves (Attacker)',
        description: 'Attacker rolls from Turn 1 on 5+ for Immediate Reserves, arriving from their short table edge.',
      ),
      DeploymentRule(
        title: 'Scattered Delayed Reserves (Defender)',
        description:
            'Defender\'s remaining 40% are Scattered Delayed Reserves, rolling from Turn 3 on 5+. '
            'Arrive within 16"/40cm of indicated corners or along Defender deployment edge.',
      ),
      DeploymentRule(
        title: 'Ambush & Foxholes',
        description:
            'Defender may hold one Unit in Ambush. All Infantry and Gun Teams start in Foxholes.',
      ),
    ],
    startingConditions: [
      'The Attacker has the first turn (Meeting Engagement — Attacker counts as having moved).',
      'Neither player may use the Spearhead rule.',
      'Attacker rolls for Immediate Reserves from Turn 1.',
      'Defender rolls for Scattered Delayed Reserves from Turn 3.',
    ],
    firstTurnRules: [
      'Meeting Engagement (Attacker): counts as moved, no Bombardments or Aircraft on Turn 1.',
      'Defender may place Ambush at start of their first turn.',
    ],
    victoryConditions: [
      VictoryCondition(
        title: 'Hold Your Own Objective (from Turn 3)',
        description:
            'A player wins if they end their turn on or after Turn 3 Holding an Objective they placed.',
      ),
    ],
    specialRules: [
      'No Spearhead for either player.',
      'Meeting Engagement for Attacker\'s first turn.',
      'Victory condition active from Turn 3.',
      'Attacker: Immediate Reserves from Turn 1 on 5+ (own short edge).',
      'Defender: Scattered Delayed Reserves from Turn 3 on 5+ (random corner/edge).',
      'Defender may use Ambush (one Unit).',
    ],
    hasReserves: true,
    reserveNote:
        'Both sides: max 60% on table. Attacker Immediate from Turn 1; Defender Scattered Delayed from Turn 3.',
    turnLimit: 6,
  ),

  Mission(
    id: 'encirclement',
    name: 'Encirclement',
    type: MissionType.attackDefend,
    tagline: 'The enemy is surrounded — close the ring.',
    overview:
        'The Defender is caught in a pocket with Attackers closing in from three sides. '
        'The Defender must hold two objectives in their zone while the Attacker '
        'tightens the noose. Defender reserves may only arrive from their one open flank.',
    attackerRole: 'Attacker',
    defenderRole: 'Defender',
    objectiveSetup: [
      'The Defender places two Objectives in their table quarter at least 8"/20cm from all table edges.',
    ],
    deploymentRules: [
      DeploymentRule(
        title: 'Defender — Pocket Deployment',
        description:
            'Defender deploys up to 60% of their force in one table quarter. '
            'Remainder are Immediate Reserves arriving only from the Defender\'s long table edge.',
      ),
      DeploymentRule(
        title: 'Attacker — Three-Sided Deployment',
        description:
            'Attacker deploys up to 60% of their force split across the three remaining quarters. '
            'Remainder are Immediate Reserves arriving from the Attacker\'s deployment edges.',
      ),
      DeploymentRule(
        title: 'Reserve Arrival',
        description:
            'Defender rolls from Turn 1 on 5+, arriving only from the Defender\'s long table edge. '
            'Attacker rolls from Turn 1 on 5+, arriving from any of the three Attacker deployment edges.',
      ),
      DeploymentRule(
        title: 'Ambush & Foxholes',
        description:
            'Defender may hold one Unit in Ambush. All Infantry and Gun Teams start in Foxholes.',
      ),
    ],
    startingConditions: [
      'The Attacker has the first turn.',
      'Defender restricted to one escape route (own long table edge).',
    ],
    firstTurnRules: [
      'Defender may place Ambush at start of their first turn.',
      'Both sides roll for Immediate Reserves from Turn 1.',
    ],
    victoryConditions: [
      VictoryCondition(
        title: 'Attacker Captures the Pocket (Turn 6+)',
        description:
            'Attacker wins if they end their turn on or after Turn 6 Holding both Objectives.',
      ),
      VictoryCondition(
        title: 'Defender Holds the Pocket (Turn 6+)',
        description:
            'Defender wins if they end their turn on or after Turn 6 having Repelled the Attack.',
      ),
    ],
    specialRules: [
      'Attacker deploys across three table quarters.',
      'Defender confined to one table quarter, reserves arrive from own long edge only.',
      'Both sides: Immediate Reserves from Turn 1 on 5+.',
      'Defender may use Ambush (one Unit).',
      'Victory from Turn 6.',
    ],
    hasReserves: true,
    reserveNote:
        'Both sides: max 60% on table. Immediate Reserves from Turn 1 on 5+. Defender arrives from own long edge only.',
    turnLimit: 6,
  ),

  Mission(
    id: 'hold_the_pocket',
    name: 'Hold the Pocket',
    type: MissionType.attackDefend,
    tagline: 'Hold your ground — every man counts.',
    overview:
        'A variant of Encirclement. The Defender holds a pocket with a critical resupply '
        'corridor still open. The Attacker must seal all exits and capture both objectives '
        'before the Defender can be relieved.',
    attackerRole: 'Attacker',
    defenderRole: 'Defender',
    objectiveSetup: [
      'The Defender places two Objectives in their table quarter at least 8"/20cm from all table edges.',
    ],
    deploymentRules: [
      DeploymentRule(
        title: 'Defender — Pocket Deployment',
        description:
            'Defender deploys up to 60% of their force in one table quarter. '
            'Remainder are Immediate Reserves, arriving from the Defender\'s long table edge or short corner.',
      ),
      DeploymentRule(
        title: 'Attacker — Three-Sided Deployment',
        description:
            'Attacker deploys up to 60% across the three remaining table quarters. '
            'Remainder are Immediate Reserves from any of their deployment edges.',
      ),
      DeploymentRule(
        title: 'Ambush & Foxholes',
        description:
            'Defender may hold one Unit in Ambush. All Infantry and Gun Teams start in Foxholes.',
      ),
    ],
    startingConditions: [
      'The Attacker has the first turn.',
      'Both sides roll for Immediate Reserves from Turn 1.',
    ],
    firstTurnRules: [
      'Defender may place Ambush at start of their first turn.',
    ],
    victoryConditions: [
      VictoryCondition(
        title: 'Attacker Seals the Pocket (Turn 6+)',
        description:
            'Attacker wins if they end their turn on or after Turn 6 Holding both Objectives.',
      ),
      VictoryCondition(
        title: 'Defender Holds Out (Turn 6+)',
        description:
            'Defender wins if they end their turn on or after Turn 6 having Repelled the Attack.',
      ),
    ],
    specialRules: [
      'Variant of Encirclement — Defender has slightly more flexible reserve arrival.',
      'Attacker across three quarters; Defender confined to one.',
      'Both sides: Immediate Reserves from Turn 1 on 5+.',
      'Defender may use Ambush (one Unit).',
      'Victory from Turn 6.',
    ],
    hasReserves: true,
    reserveNote: 'Both sides: max 60% on table. Immediate Reserves from Turn 1 on 5+.',
    turnLimit: 6,
  ),

  Mission(
    id: 'escape',
    name: 'Escape',
    type: MissionType.attackDefend,
    tagline: 'Break through — or be destroyed.',
    overview:
        'The Defender\'s force is surrounded and must break out. '
        'The Attacker deploys across three sides and tries to destroy them before they escape. '
        'The Defender wins by getting enough Units off the breakout table edge.',
    attackerRole: 'Attacker',
    defenderRole: 'Escaping Force',
    objectiveSetup: [
      'No Objectives — victory is determined by Units escaping or being destroyed.',
    ],
    deploymentRules: [
      DeploymentRule(
        title: 'Escaping Force Deployment',
        description:
            'Defender deploys their entire force in one table quarter.',
      ),
      DeploymentRule(
        title: 'Attacker — Three-Sided Deployment',
        description:
            'Attacker deploys up to 60% of their force across the three remaining table quarters. '
            'Remainder are Immediate Reserves from any of their deployment edges (roll from Turn 1 on 5+).',
      ),
      DeploymentRule(
        title: 'Breakout Direction',
        description:
            'The Defender designates the short table edge opposite their deployment corner '
            'as the Breakout Edge. Defender Units that exit off this edge are Escaped (not Destroyed).',
      ),
    ],
    startingConditions: [
      'The Defender has the first turn (they are trying to escape).',
      'Attacker rolls for Immediate Reserves from Turn 1.',
    ],
    firstTurnRules: [
      'Defender moves first — toward the Breakout Edge.',
    ],
    victoryConditions: [
      VictoryCondition(
        title: 'Escaping Force Breaks Out',
        description:
            'Defender wins if they exit at least half their starting Units off the Breakout Edge.',
      ),
      VictoryCondition(
        title: 'Attacker Destroys the Pocket',
        description:
            'Attacker wins if fewer than half the Defender\'s starting Units escape.',
      ),
    ],
    specialRules: [
      'No Objectives — Units escaping off the Breakout Edge count as Escaped.',
      'Defender moves first.',
      'Attacker Immediate Reserves from Turn 1 on 5+.',
      'Escaped Units do not count as Destroyed for Victory Points.',
    ],
    hasReserves: true,
    reserveNote:
        'Attacker: max 60% on table. Immediate Reserves from Turn 1 on 5+.',
    turnLimit: 6,
  ),

  Mission(
    id: 'dogfight',
    name: 'Dogfight',
    type: MissionType.attackDefend,
    tagline: 'Air superiority decides the ground battle.',
    overview:
        'Both sides contest the skies while fighting on the ground. '
        'Aircraft play a major role and each side has air support units '
        'that can directly influence the battle. A single Objective in the centre must be held.',
    attackerRole: 'Attacker',
    defenderRole: 'Defender',
    objectiveSetup: [
      'Place one Objective in the centre of the table.',
      'The Attacker places one Objective in the Defender\'s half at least 12"/30cm from the centre and 8"/20cm from all table edges.',
      'The Defender places one Objective in the Attacker\'s half with the same constraints.',
    ],
    deploymentRules: [
      DeploymentRule(
        title: 'Defender Deployment',
        description:
            'Defender deploys up to 60% of their force in their half. '
            'Remainder are Immediate Reserves rolling from Turn 1 on 5+.',
      ),
      DeploymentRule(
        title: 'Attacker Deployment',
        description:
            'Attacker deploys all Units in their half within 12"/30cm of their long table edge.',
      ),
      DeploymentRule(
        title: 'Aircraft Priority',
        description:
            'Aircraft Units are always available regardless of reserve rolls. '
            'Aircraft may arrive on any turn from Turn 1 even on a Meeting Engagement turn.',
      ),
      DeploymentRule(
        title: 'Ambush & Foxholes',
        description:
            'Defender may hold one Unit in Ambush. All Infantry and Gun Teams start in Foxholes.',
      ),
    ],
    startingConditions: [
      'The Attacker has the first turn.',
      'Aircraft are always available from Turn 1.',
    ],
    firstTurnRules: [
      'Defender may place Ambush at start of their first turn.',
      'Defender rolls for Immediate Reserves from Turn 1.',
    ],
    victoryConditions: [
      VictoryCondition(
        title: 'Hold the Objectives',
        description:
            'A player wins if they end any turn on or after Turn 6 Holding two or more Objectives.',
      ),
    ],
    specialRules: [
      'Aircraft are always available from Turn 1 — no Meeting Engagement restriction on Aircraft.',
      'Defender: Immediate Reserves from Turn 1 on 5+.',
      'Defender may use Ambush (one Unit).',
      'Victory from Turn 6 — hold 2+ Objectives.',
    ],
    hasReserves: true,
    reserveNote: 'Defender: max 60% on table. Immediate Reserves from Turn 1 on 5+.',
    turnLimit: 6,
  ),

  Mission(
    id: 'gauntlet',
    name: 'Gauntlet',
    type: MissionType.attackDefend,
    tagline: 'Drive through the killing zone.',
    overview:
        'The Attacker must push through a corridor of Defenders on both flanks. '
        'Two objectives lie at the far end of the table. '
        'The Defender has reserves arriving from both sides to close the trap.',
    attackerRole: 'Attacker',
    defenderRole: 'Defender',
    objectiveSetup: [
      'The Attacker places two Objectives in the Defender\'s half at least 8"/20cm from all table edges '
          'and within 8"/20cm of the short table edge opposite the Attacker.',
    ],
    deploymentRules: [
      DeploymentRule(
        title: 'Attacker — Central Corridor',
        description:
            'Attacker deploys all Units within 16"/40cm of the long table centre line '
            'and within 12"/30cm of their own short table edge.',
      ),
      DeploymentRule(
        title: 'Defender — Flanking Positions',
        description:
            'Defender deploys up to 60% of their force outside the central 16"/40cm corridor, '
            'in their own half. Remainder are Immediate Reserves arriving from either short table edge.',
      ),
      DeploymentRule(
        title: 'Reserve Arrival',
        description:
            'Defender rolls from Turn 1 on 5+. Reserves arrive within 16"/40cm of either short table edge corner in the Defender\'s half.',
      ),
      DeploymentRule(
        title: 'Ambush & Foxholes',
        description:
            'Defender may hold one Unit in Ambush. All Infantry and Gun Teams start in Foxholes.',
      ),
    ],
    startingConditions: [
      'The Attacker has the first turn.',
      'Defender rolls for Immediate Reserves from Turn 1.',
    ],
    firstTurnRules: [
      'Defender may place Ambush at start of their first turn.',
    ],
    victoryConditions: [
      VictoryCondition(
        title: 'Attacker Breaks Through (Turn 6+)',
        description:
            'Attacker wins if they end their turn on or after Turn 6 Holding an Objective.',
      ),
      VictoryCondition(
        title: 'Defender Closes the Trap (Turn 6+)',
        description:
            'Defender wins if they end their turn on or after Turn 6 having Repelled the Attack.',
      ),
    ],
    specialRules: [
      'Attacker confined to central 16"/40cm corridor.',
      'Defender on both flanks with reserves arriving from short edges.',
      'Defender: Immediate Reserves from Turn 1 on 5+.',
      'Defender may use Ambush (one Unit).',
      'Victory from Turn 6.',
    ],
    hasReserves: true,
    reserveNote:
        'Defender: max 60% on table. Immediate Reserves from Turn 1 on 5+, arriving from short table edge corners.',
    turnLimit: 6,
  ),

  Mission(
    id: 'killing_ground',
    name: 'Killing Ground',
    type: MissionType.attackDefend,
    tagline: 'Advance into the prepared kill zone.',
    overview:
        'The Defender has prepared a devastating kill zone with minefields and '
        'carefully positioned units. The Attacker must advance through this and '
        'capture objectives deep in the defensive position.',
    attackerRole: 'Attacker',
    defenderRole: 'Defender',
    objectiveSetup: [
      'The Attacker places two Objectives in the Defender\'s half at least 12"/30cm from the centre line and 8"/20cm from the short table edges.',
    ],
    deploymentRules: [
      DeploymentRule(
        title: 'Defender — Full Deployment with Minefields',
        description:
            'Defender deploys all Units in their table half. '
            'Defender places one Minefield for each 25 points in their force, '
            'anywhere outside the Attacker\'s deployment area.',
      ),
      DeploymentRule(
        title: 'Attacker — Full Deployment',
        description:
            'Attacker deploys all Units within 12"/30cm of their own long table edge.',
      ),
      DeploymentRule(
        title: 'Ambush (Defender)',
        description: 'Defender may hold one Unit in Ambush.',
      ),
      DeploymentRule(
        title: 'Infantry & Guns in Foxholes',
        description: 'All Infantry and Gun Teams start in Foxholes.',
      ),
    ],
    startingConditions: [
      'The Attacker has the first turn.',
      'Defender places Minefields before Attacker deploys.',
    ],
    firstTurnRules: [
      'Defender may place Ambush at start of their first turn.',
    ],
    victoryConditions: [
      VictoryCondition(
        title: 'Attacker Captures an Objective',
        description:
            'Attacker wins if they start their turn Holding an Objective.',
      ),
      VictoryCondition(
        title: 'Defender Holds the Kill Zone (Turn 6+)',
        description:
            'Defender wins if they end their turn on or after Turn 6 having Repelled the Attack.',
      ),
    ],
    specialRules: [
      'Defender places Minefields: one per 25 pts outside Attacker\'s zone.',
      'No Reserves — both sides deploy fully.',
      'Defender may use Ambush (one Unit).',
      'Attacker may win any turn; Defender win condition activates Turn 6.',
    ],
    hasReserves: false,
    reserveNote: 'No reserves — both sides deploy fully.',
    turnLimit: 6,
  ),

  Mission(
    id: 'its_a_trap',
    name: 'It\'s a Trap',
    type: MissionType.attackDefend,
    tagline: 'The kill zone was bait — now the jaws close.',
    overview:
        'A variant of Killing Ground. The Defender lures the Attacker forward '
        'before springing a flanking ambush. Additional flanking reserves '
        'arrive once the Attacker is fully committed.',
    attackerRole: 'Attacker',
    defenderRole: 'Defender',
    objectiveSetup: [
      'The Attacker places two Objectives in the Defender\'s half at least 12"/30cm from the centre line and 8"/20cm from the short table edges.',
    ],
    deploymentRules: [
      DeploymentRule(
        title: 'Defender — Minefields + Flanking Reserves',
        description:
            'Defender deploys up to 60% in their half. '
            'One Minefield per 25 pts placed outside Attacker\'s deployment area. '
            'Remainder are Flanking Delayed Reserves arriving from the short table edges (roll from Turn 3 on 5+).',
      ),
      DeploymentRule(
        title: 'Attacker — Full Deployment',
        description:
            'Attacker deploys all Units within 12"/30cm of their own long table edge.',
      ),
      DeploymentRule(
        title: 'Ambush (Defender)',
        description: 'Defender may hold one Unit in Ambush.',
      ),
      DeploymentRule(
        title: 'Infantry & Guns in Foxholes',
        description: 'All Infantry and Gun Teams start in Foxholes.',
      ),
    ],
    startingConditions: [
      'The Attacker has the first turn.',
      'Defender Flanking Reserves roll from Turn 3.',
    ],
    firstTurnRules: [
      'Defender may place Ambush at start of their first turn.',
      'Defender Flanking Delayed Reserves roll from Turn 3 on 5+.',
    ],
    victoryConditions: [
      VictoryCondition(
        title: 'Attacker Breaks Through',
        description:
            'Attacker wins if they start their turn Holding an Objective.',
      ),
      VictoryCondition(
        title: 'Defender Closes the Trap (Turn 6+)',
        description:
            'Defender wins if they end their turn on or after Turn 6 having Repelled the Attack.',
      ),
    ],
    specialRules: [
      'Variant of Killing Ground — Defender has Flanking Reserves instead of full deployment.',
      'Minefields: one per 25 pts outside Attacker\'s zone.',
      'Defender: Flanking Delayed Reserves from Turn 3 on 5+, arriving from short table edges.',
      'Defender may use Ambush (one Unit).',
    ],
    hasReserves: true,
    reserveNote:
        'Defender: max 60% on table. Flanking Delayed Reserves from Turn 3 on 5+, arriving from short table edges.',
    turnLimit: 6,
  ),

  Mission(
    id: 'outflanked',
    name: 'Outflanked',
    type: MissionType.attackDefend,
    tagline: 'The flanks are turning — hold the centre.',
    overview:
        'The Attacker drives at the centre while holding flanking reserves '
        'to sweep around the defensive flanks. Objectives are placed in the Defender\'s half. '
        'Flanking reserves arrive from the sides to cut off retreat.',
    attackerRole: 'Attacker',
    defenderRole: 'Defender',
    objectiveSetup: [
      'The Attacker places two Objectives in the Defender\'s half at least 8"/20cm from all table edges '
          'and at least 12"/30cm from the table centre.',
    ],
    deploymentRules: [
      DeploymentRule(
        title: 'Attacker — Flanking Delayed Reserves',
        description:
            'Attacker deploys up to 60% of their force in their half at least 12"/30cm from centre. '
            'Remainder are Flanking Delayed Reserves arriving from either short table edge (roll from Turn 3 on 5+).',
      ),
      DeploymentRule(
        title: 'Defender — Immediate Reserves',
        description:
            'Defender deploys up to 60% in their half. '
            'Remainder are Immediate Reserves arriving from their long table edge (roll from Turn 1 on 5+).',
      ),
      DeploymentRule(
        title: 'Ambush & Foxholes',
        description:
            'Defender may hold one Unit in Ambush. All Infantry and Gun Teams start in Foxholes.',
      ),
    ],
    startingConditions: [
      'The Attacker has the first turn.',
      'Attacker Flanking Delayed Reserves from Turn 3; Defender Immediate Reserves from Turn 1.',
    ],
    firstTurnRules: [
      'Defender may place Ambush at start of their first turn.',
      'Defender rolls for Immediate Reserves from Turn 1.',
    ],
    victoryConditions: [
      VictoryCondition(
        title: 'Attacker Outflanks (Turn 6+)',
        description:
            'Attacker wins if they end their turn on or after Turn 6 Holding an Objective.',
      ),
      VictoryCondition(
        title: 'Defender Holds the Line (Turn 6+)',
        description:
            'Defender wins if they end their turn on or after Turn 6 having Repelled the Attack.',
      ),
    ],
    specialRules: [
      'Attacker holds Flanking Delayed Reserves (from Turn 3 on 5+, own short table edges).',
      'Defender: Immediate Reserves from Turn 1 on 5+ (own long edge).',
      'Defender may use Ambush (one Unit).',
      'Victory from Turn 6.',
    ],
    hasReserves: true,
    reserveNote:
        'Both sides: max 60% on table. Attacker Flanking Delayed from Turn 3; Defender Immediate from Turn 1.',
    turnLimit: 6,
  ),

  Mission(
    id: 'outmanoeuvred',
    name: 'Outmanoeuvred',
    type: MissionType.attackDefend,
    tagline: 'Speed and cunning beat brute force.',
    overview:
        'A variant of Outflanked. The Attacker uses superior mobility to outmanoeuvre '
        'the defence. Both sides have Immediate Reserves, but the Attacker\'s '
        'flanking force arrives earlier to exploit the gap.',
    attackerRole: 'Attacker',
    defenderRole: 'Defender',
    objectiveSetup: [
      'The Attacker places two Objectives in the Defender\'s half at least 8"/20cm from all table edges '
          'and at least 12"/30cm from the table centre.',
    ],
    deploymentRules: [
      DeploymentRule(
        title: 'Attacker — Immediate Flanking Reserves',
        description:
            'Attacker deploys up to 60% in their half at least 12"/30cm from centre. '
            'Remainder are Immediate Flanking Reserves arriving from either short table edge (roll from Turn 1 on 5+).',
      ),
      DeploymentRule(
        title: 'Defender — Immediate Reserves',
        description:
            'Defender deploys up to 60% in their half. '
            'Remainder are Immediate Reserves from their long table edge (roll from Turn 1 on 5+).',
      ),
      DeploymentRule(
        title: 'Ambush & Foxholes',
        description:
            'Defender may hold one Unit in Ambush. All Infantry and Gun Teams start in Foxholes.',
      ),
    ],
    startingConditions: [
      'The Attacker has the first turn.',
      'Both sides roll for Immediate Reserves from Turn 1.',
    ],
    firstTurnRules: [
      'Defender may place Ambush at start of their first turn.',
      'Both sides roll for Immediate Reserves from Turn 1.',
    ],
    victoryConditions: [
      VictoryCondition(
        title: 'Attacker Outmanoeuvres (Turn 6+)',
        description:
            'Attacker wins if they end their turn on or after Turn 6 Holding an Objective.',
      ),
      VictoryCondition(
        title: 'Defender Holds (Turn 6+)',
        description:
            'Defender wins if they end their turn on or after Turn 6 having Repelled the Attack.',
      ),
    ],
    specialRules: [
      'Variant of Outflanked — Attacker\'s flanking reserves arrive from Turn 1 (not Turn 3).',
      'Both sides: Immediate Reserves from Turn 1 on 5+.',
      'Attacker flanking reserves from own short table edges.',
      'Defender may use Ambush (one Unit).',
      'Victory from Turn 6.',
    ],
    hasReserves: true,
    reserveNote: 'Both sides: max 60% on table. Immediate Reserves from Turn 1 on 5+.',
    turnLimit: 6,
  ),

  Mission(
    id: 'valley_of_death',
    name: 'Valley of Death',
    type: MissionType.attackDefend,
    tagline: 'Cross the open ground — or die trying.',
    overview:
        'The Attacker must cross a deadly open valley while the Defender commands '
        'the high ground on both flanks. Two objectives lie at the far end. '
        'The Defender has Scattered Delayed Reserves arriving from the flanks to seal the valley exit.',
    attackerRole: 'Attacker',
    defenderRole: 'Defender',
    objectiveSetup: [
      'The Attacker places two Objectives in the Defender\'s quarter of the table (far short edge), '
          'at least 8"/20cm from all table edges.',
    ],
    deploymentRules: [
      DeploymentRule(
        title: 'Attacker — Valley Entry',
        description:
            'Attacker deploys all Units within 12"/30cm of their own short table edge.',
      ),
      DeploymentRule(
        title: 'Defender — Flank Command',
        description:
            'Defender deploys up to 60% of their force split across both long table edges '
            'at least 12"/30cm from the short table edges. '
            'Remainder are Scattered Delayed Reserves (roll from Turn 3 on 5+).',
      ),
      DeploymentRule(
        title: 'Ambush & Foxholes',
        description:
            'Defender may hold one Unit in Ambush. All Infantry and Gun Teams start in Foxholes.',
      ),
    ],
    startingConditions: [
      'The Attacker has the first turn.',
      'Defender deploys along both long table edges — Attacker must cross the open centre.',
    ],
    firstTurnRules: [
      'Defender may place Ambush at start of their first turn.',
      'Defender Scattered Delayed Reserves roll from Turn 3.',
    ],
    victoryConditions: [
      VictoryCondition(
        title: 'Attacker Exits the Valley (Turn 6+)',
        description:
            'Attacker wins if they end their turn on or after Turn 6 Holding an Objective.',
      ),
      VictoryCondition(
        title: 'Defender Controls the Valley (Turn 6+)',
        description:
            'Defender wins if they end their turn on or after Turn 6 having Repelled the Attack.',
      ),
    ],
    specialRules: [
      'Defender deploys along BOTH long table edges (flanking the valley).',
      'Attacker deploys from short edge and must cross open ground.',
      'Defender: Scattered Delayed Reserves from Turn 3 on 5+ (random long edge arrival).',
      'Defender may use Ambush (one Unit).',
      'Victory from Turn 6.',
    ],
    hasReserves: true,
    reserveNote:
        'Defender: max 60% on table. Scattered Delayed Reserves from Turn 3 on 5+.',
    turnLimit: 6,
  ),

  Mission(
    id: 'vanguard',
    name: 'Vanguard',
    type: MissionType.attackDefend,
    tagline: 'Lead element — push through before they react.',
    overview:
        'The Attacker pushes a fast vanguard force forward to seize objectives '
        'before the Defender can consolidate. Both sides have Scattered Delayed Reserves '
        'that arrive as the battle develops. Victory is possible from Turn 1.',
    attackerRole: 'Attacker',
    defenderRole: 'Defender',
    objectiveSetup: [
      'Defender places one Objective in their half at least 12"/30cm from centre and 8"/20cm from short edges.',
      'Attacker places one Objective in the Defender\'s half (same constraints).',
      'Place one Objective in the exact centre of the table.',
    ],
    deploymentRules: [
      DeploymentRule(
        title: 'Attacker — Vanguard Force',
        description:
            'Attacker deploys up to 60% in their half at least 12"/30cm from centre. '
            'Remainder are Immediate Reserves from Attacker\'s long edge (roll from Turn 1 on 5+).',
      ),
      DeploymentRule(
        title: 'Defender — Scattered Delayed Reserves',
        description:
            'Defender deploys up to 60% in their half. '
            'Remainder are Scattered Delayed Reserves arriving from random table edges (roll from Turn 3 on 5+).',
      ),
      DeploymentRule(
        title: 'Ambush & Foxholes',
        description:
            'Defender may hold one Unit in Ambush. All Infantry and Gun Teams start in Foxholes.',
      ),
    ],
    startingConditions: [
      'The Attacker has the first turn.',
      'Victory objectives can be contested from Turn 1.',
    ],
    firstTurnRules: [
      'Defender may place Ambush at start of their first turn.',
      'Attacker rolls for Immediate Reserves from Turn 1.',
      'Defender rolls for Scattered Delayed Reserves from Turn 3.',
    ],
    victoryConditions: [
      VictoryCondition(
        title: 'Capture an Objective (from Turn 1)',
        description:
            'A player wins if they start any turn Holding an Objective, '
            'with no opposing teams within 4"/10cm of it.',
      ),
    ],
    specialRules: [
      'Victory condition active from Turn 1.',
      '3 Objectives: 1 in each half + 1 in centre.',
      'Attacker: Immediate Reserves from Turn 1 on 5+ (own long edge).',
      'Defender: Scattered Delayed Reserves from Turn 3 on 5+ (random edge).',
      'Defender may use Ambush (one Unit).',
    ],
    hasReserves: true,
    reserveNote:
        'Both sides: max 60% on table. Attacker Immediate from Turn 1; Defender Scattered Delayed from Turn 3.',
    turnLimit: 6,
  ),

  Mission(
    id: 'cornered',
    name: 'Cornered',
    type: MissionType.attackDefend,
    tagline: 'Nowhere to run — fight to the last.',
    overview:
        'The Defender is pushed into a table quarter with their back to the corner. '
        'The Attacker strikes from the opposite short table edge with two objectives '
        'placed in the Defender\'s corner. A brutal close-quarters engagement.',
    attackerRole: 'Attacker',
    defenderRole: 'Defender',
    objectiveSetup: [
      'The Attacker places two Objectives in the Defender\'s table quarter at least 4"/10cm from both centre lines and 12"/30cm from all table edges.',
    ],
    deploymentRules: [
      DeploymentRule(
        title: 'Defender — Corner Deployment',
        description:
            'Defender deploys up to 60% in their table quarter or up to 4"/10cm into the Attacker\'s half. '
            'Remainder are Immediate Reserves arriving within 16"/40cm of the Defender\'s corner.',
      ),
      DeploymentRule(
        title: 'Attacker — Full Deployment',
        description:
            'Attacker deploys all Units in their half at least 20"/50cm from the short centre line.',
      ),
      DeploymentRule(
        title: 'Defender Minefields',
        description:
            'Defender may place one Minefield for each 25 points in their force, '
            'anywhere outside the Attacker\'s deployment area.',
      ),
      DeploymentRule(
        title: 'Ambush & Foxholes',
        description:
            'Defender may hold one Unit in Ambush. All Infantry and Gun Teams start in Foxholes.',
      ),
    ],
    startingConditions: [
      'The Attacker has the first turn.',
      'Defender Immediate Reserves roll from Turn 1, arriving within 16"/40cm of their corner.',
    ],
    firstTurnRules: [
      'Defender may place Ambush at start of their first turn.',
      'Defender rolls for Immediate Reserves from Turn 1.',
    ],
    victoryConditions: [
      VictoryCondition(
        title: 'Attacker Captures an Objective (Turn 6+)',
        description:
            'Attacker wins if they end their turn on or after Turn 6 Holding an Objective.',
      ),
      VictoryCondition(
        title: 'Defender Holds the Corner (Turn 6+)',
        description:
            'Defender wins if they end their turn on or after Turn 6 having Repelled the Attack.',
      ),
    ],
    specialRules: [
      'Defender confined to one table quarter.',
      'Defender Minefields: one per 25 pts outside Attacker\'s zone.',
      'Defender: Immediate Reserves from Turn 1 on 5+ (own corner, within 16"/40cm).',
      'Defender may use Ambush (one Unit).',
      'Victory from Turn 6.',
    ],
    hasReserves: true,
    reserveNote:
        'Defender: max 60% on table. Immediate Reserves from Turn 1 on 5+, within 16"/40cm of Defender\'s corner.',
    turnLimit: 6,
  ),

  Mission(
    id: 'counterstrike',
    name: 'Counterstrike',
    type: MissionType.attackDefend,
    tagline: 'The defence erupts into sudden offensive action.',
    overview:
        'A variant of Counterattack. The Defender strikes first in a Meeting Engagement, '
        'catching the Attacker off-guard before they can consolidate. '
        'Same quarter deployment — but the Defender moves first.',
    attackerRole: 'Attacker',
    defenderRole: 'Defender',
    objectiveSetup: [
      'Defender places one Objective in their table quarter at least 8"/20cm from all table edges and 12"/30cm from table centre.',
      'Attacker places one Objective in the quarter opposite to their own (same constraints).',
    ],
    deploymentRules: [
      DeploymentRule(
        title: 'Deployment Quarters',
        description:
            'The Defender picks a table quarter. '
            'The Attacker picks an adjacent quarter (sharing either a long or short table edge).',
      ),
      DeploymentRule(
        title: 'Attacker — Full Deployment',
        description:
            'Attacker deploys all Units in their table quarter at least 8"/20cm from both centre lines.',
      ),
      DeploymentRule(
        title: 'Defender — Immediate Reserves',
        description:
            'Defender deploys up to 60% of their force in their quarter at least 12"/30cm from table centre. '
            'Remainder are Immediate Reserves arriving within 16"/40cm of the opposite corner '
            '(roll from Turn 1 on 5+).',
      ),
      DeploymentRule(
        title: 'Ambush & Foxholes',
        description:
            'Defender may hold one Unit in Ambush. All Infantry and Gun Teams start in Foxholes.',
      ),
    ],
    startingConditions: [
      'The DEFENDER has the first turn (Meeting Engagement — Defender counts as having moved).',
      'Defender Immediate Reserves roll from Turn 1.',
    ],
    firstTurnRules: [
      'Meeting Engagement applies to the DEFENDER\'s first turn (not the Attacker\'s).',
      'Defender may place Ambush at start of their first turn.',
      'Defender rolls for Immediate Reserves from Turn 1.',
    ],
    victoryConditions: [
      VictoryCondition(
        title: 'Attacker Captures an Objective (Turn 6+)',
        description:
            'Attacker wins if they end their turn on or after Turn 6 Holding an Objective.',
      ),
      VictoryCondition(
        title: 'Defender Counterstrike Succeeds (Turn 6+)',
        description:
            'Defender wins if they end their turn on or after Turn 6 having Repelled the Attack.',
      ),
    ],
    specialRules: [
      'DEFENDER goes first — Meeting Engagement applies to Defender\'s first turn.',
      'Adjacent quarter deployment (same as Counterattack).',
      'Defender: Immediate Reserves from Turn 1 on 5+ (opposite corner, within 16"/40cm).',
      'Defender may use Ambush (one Unit).',
      'Victory from Turn 6.',
    ],
    hasReserves: true,
    reserveNote:
        'Defender: max 60% on table. Immediate Reserves from Turn 1 on 5+, within 16"/40cm of opposite corner.',
    turnLimit: 6,
  ),
];
