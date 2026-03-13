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
];
