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
      'Both players, starting with the Attacker (P1), place two Objectives within 8"/20cm of the opponent\'s long table edge, '
          'at least 8"/20cm from the side table edges.',
    ],
    deploymentRules: [
      DeploymentRule(
        title: 'Deployment Zone',
        description:
            'Both players, starting with the Attacker (P1), take turns placing '
            'one Unit within 12"/30cm of their own long table edge until all are deployed.',
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
            'A player wins if they end their turn Holding an Objective on the opponent\'s side of the table '
            '(no opposing Tank, Infantry, or Gun teams within 4"/10cm of that Objective at end of turn).',
      ),
    ],
    specialRules: [
      'Meeting Engagement (first player\'s first turn only).',
      'No reserves — full deployment from the start.',
      'Victory Points: count Units Destroyed (including HQ Units, not Independent Teams; core Units and Attachments count separately).',
      'Winner lost 0–1 Units: Winner 8 VP, Loser 1 VP.',
      'Winner lost 2 Units: Winner 7 VP, Loser 2 VP.',
      'Winner lost 3+ Units: Winner 6 VP, Loser 3 VP.',
      'If neither player wins, both treat their opponent as the winner and gain VP as the Loser.',
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
            'within 12"/30cm of their own long table edge until all are deployed.',
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
      'Victory Points: count Units Destroyed (including HQ Units, not Independent Teams; core Units and Attachments count separately).',
      'Winner lost 0–1 Units: Winner 8 VP, Loser 1 VP.',
      'Winner lost 2 Units: Winner 7 VP, Loser 2 VP.',
      'Winner lost 3+ Units: Winner 6 VP, Loser 3 VP.',
      'If neither player wins, both treat their opponent as the winner and gain VP as the Loser.',
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
        'The Defender picks two diagonally opposite table quarters to defend. '
        'The Attacker deploys in one of the remaining quarters. '
        'Objectives are placed in the fourth (empty) quarter. '
        'The Attacker must break through to capture them before the flanking reserves seal the breach.',
    attackerRole: 'Attacker',
    defenderRole: 'Defender',
    objectiveSetup: [
      'The Defender picks two diagonally opposite table quarters to defend.',
      'The Attacker picks one of the remaining table quarters to attack from.',
      'The Attacker places two Objectives in the remaining (fourth) table quarter, '
          'at least 8"/20cm from all table edges.',
    ],
    deploymentRules: [
      DeploymentRule(
        title: 'Defender — Immediate Reserves',
        description:
            'Defender deploys up to 60% of their force and holds the rest in Immediate Reserve. '
            'Deployed Units are placed in either of their two table quarters. '
            'Reserves arrive within 16"/40cm of either of the Defender\'s table corners (roll from Turn 1 on 5+).',
      ),
      DeploymentRule(
        title: 'Attacker — Flanking Delayed Reserves',
        description:
            'Attacker deploys in their table quarter at least 8"/20cm from both centre lines. '
            'Must hold at least one Unit in Delayed Reserve. '
            'Reserves arrive within 16"/40cm of the Objective table corner (roll from Turn 3 on 5+).',
      ),
      DeploymentRule(
        title: 'Ambush & Foxholes',
        description:
            'Defender may hold one Unit in Ambush. All Infantry and Gun Teams start in Foxholes.',
      ),
    ],
    startingConditions: [
      'The Attacker has the first turn.',
      'Defender Immediate Reserves: roll from Turn 1 on 5+, arrive within 16"/40cm of either Defender corner.',
      'Attacker Flanking Delayed Reserves: roll from Turn 3 on 5+, arrive within 16"/40cm of Objective corner.',
    ],
    firstTurnRules: [
      'Defender may place Ambush unit at start of their first turn.',
      'Defender rolls for Immediate Reserves from Turn 1.',
      'Attacker Flanking Delayed Reserves begin rolling from Turn 3.',
    ],
    victoryConditions: [
      VictoryCondition(
        title: 'Attacker Breaks Through (Turn 6+)',
        description:
            'Attacker wins if they end their turn on or after Turn 6 Holding an Objective.',
      ),
      VictoryCondition(
        title: 'Defender Seals the Breach (Turn 6+)',
        description:
            'Defender wins if they end their turn on or after Turn 6 having Repelled the Attack '
            '(no Attacking Tank, Infantry, or Gun teams within 8"/20cm of any Objective).',
      ),
    ],
    specialRules: [
      'Defender occupies two DIAGONALLY OPPOSITE quarters; Attacker deploys in a third; Objectives in the fourth.',
      'Defender: Immediate Reserves from Turn 1 on 5+, arriving within 16"/40cm of either Defender corner.',
      'Attacker: at least one Unit must be held as Flanking Delayed Reserve (from Turn 3 on 5+), arriving near Objective corner.',
      'Defender may use Ambush (one Unit).',
      'Victory conditions check from Turn 6 onwards.',
    ],
    hasReserves: true,
    reserveNote:
        'Defender: max 60% on table. Immediate Reserves from Turn 1 on 5+, arrive at Defender corners. '
        'Attacker: minimum 1 Unit as Flanking Delayed Reserve, arrives near Objective corner from Turn 3.',
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
        'The Defender picks a long table edge. Each player places one Objective in their own half '
        'and one in the opponent\'s half. Both sides have Scattered Reserves. '
        'The Attacker goes first (Meeting Engagement). A player wins by Holding an Objective in the opponent\'s half.',
    attackerRole: 'Attacker',
    defenderRole: 'Defender',
    objectiveSetup: [
      'The Defender picks a long table edge to defend. The Attacker attacks from the opposite edge.',
      'Both players, starting with the Attacker, place one Objective in their own table half. '
          'Then, again starting with the Attacker, both players place one Objective in the opponent\'s table half.',
      'Objectives in the Attacker\'s table half: at least 8"/20cm from the long centre line and all table edges.',
      'Objectives in the Defender\'s table half: at least 16"/40cm from the long centre line and 8"/20cm from short table edges.',
    ],
    deploymentRules: [
      DeploymentRule(
        title: 'Attacker — Scattered Immediate Reserves',
        description:
            'Attacker deploys up to 60% of their force in their own table half, at least 12"/30cm from the long centre line. '
            'Holds the rest in Scattered Immediate Reserve (roll from Turn 1 on 5+). '
            'When each unit arrives, the Attacker rolls to determine which table edge or corner it arrives from.',
      ),
      DeploymentRule(
        title: 'Defender — Scattered Delayed Reserves',
        description:
            'Defender deploys up to 60% of their force in their own table half, at least 12"/30cm from the long centre line. '
            'Holds the rest in Scattered Delayed Reserve (roll from Turn 3 on 5+). '
            'When each unit arrives, the Defender rolls to determine which table edge or corner it arrives from. '
            'Defender may hold one Unit in Ambush.',
      ),
      DeploymentRule(
        title: 'Infantry & Guns in Foxholes',
        description: 'All Infantry and Gun Teams start the game in Foxholes.',
      ),
    ],
    startingConditions: [
      'The Attacker has the first turn. As this is a Meeting Engagement, the Attacker shoots as if they moved, '
          'cannot use Artillery Bombardments, and has no Aircraft on their first turn.',
      'Attacker Scattered Immediate Reserves: roll from Turn 1 on 5+; roll to determine arrival edge/corner.',
      'Defender Scattered Delayed Reserves: roll from Turn 3 on 5+; roll to determine arrival edge/corner.',
    ],
    firstTurnRules: [
      'Meeting Engagement applies to the Attacker\'s first turn only.',
      'Defender may place Ambush unit at start of their first turn.',
      'Attacker begins rolling for Scattered Immediate Reserves from Turn 1.',
      'Defender begins rolling for Scattered Delayed Reserves from Turn 3.',
    ],
    victoryConditions: [
      VictoryCondition(
        title: 'Capture an Objective',
        description:
            'A player wins if they end their turn Holding an Objective on the opponent\'s side of the table '
            '(no opposing Tank, Infantry, or Gun teams within 4"/10cm of it at end of turn).',
      ),
    ],
    specialRules: [
      'Long edge orientation — Defender picks a long table edge.',
      'Each player places 1 Objective in own half AND 1 in opponent\'s half (4 total).',
      'Deploy at least 12"/30cm from long centre line.',
      'Attacker goes first — Meeting Engagement applies to Attacker\'s first turn.',
      'Attacker: Scattered Immediate Reserves from Turn 1 on 5+ (random edge/corner).',
      'Defender: Scattered Delayed Reserves from Turn 3 on 5+ (random edge/corner).',
      'Defender may use Ambush (one Unit).',
      'If 3+ dice but no 5+, one unit automatically arrives.',
    ],
    hasReserves: true,
    reserveNote:
        'Both sides: max 60% on table. Attacker Scattered Immediate from Turn 1 on 5+; Defender Scattered Delayed from Turn 3 on 5+.',
    turnLimit: 6,
  ),

  Mission(
    id: 'scouts_out',
    name: 'Scouts Out',
    type: MissionType.manoeuvre,
    tagline: 'Recon units race ahead to seize key ground.',
    overview:
        'Diagonal quarter deployment. Each player places two Objectives in the opponent\'s quarter: '
        'one near the long centre, one near the long table edge. '
        'Both sides have Delayed Reserves from Turn 3. Victory goes to whoever Holds the Objective they placed.',
    attackerRole: 'Player 1',
    defenderRole: 'Player 2',
    objectiveSetup: [
      'Both players roll a die. The highest-scoring player is the Attacker. '
          'The Attacker picks a table quarter to attack from. The Defender takes the diagonally opposite quarter.',
      'Both players, starting with the Attacker, place one Objective in the opponent\'s table quarter, '
          'at least 16"/40cm from the short centre line and within 8"/20cm of the long centre line.',
      'Both players, again starting with the Attacker, place one Objective within 8"/20cm of the long table edge '
          'in the opponent\'s table quarter, more than 8"/20cm from the short centre line.',
    ],
    deploymentRules: [
      DeploymentRule(
        title: 'Deployment Quarters',
        description:
            'Both players, starting with the Attacker, take turns placing deployed Units in their own quarter, '
            'at least 8"/20cm from the long centre line until all are deployed.',
      ),
      DeploymentRule(
        title: 'Delayed Reserves (Both Players)',
        description:
            'Both players deploy up to 60% of their force in their own quarter. '
            'Holds the rest in Delayed Reserve (roll from Turn 3 on 5+). '
            'Reserves arrive from the long table edge adjacent to the player\'s quarter.',
      ),
      DeploymentRule(
        title: 'Infantry & Guns in Foxholes',
        description: 'All Infantry and Gun Teams start the game in Foxholes.',
      ),
    ],
    startingConditions: [
      'Both players roll — the highest scoring player has the first turn.',
      'Meeting Engagement applies to the first player\'s first turn.',
      'No Ranged In markers placed (Meeting Engagement).',
      'Delayed Reserves: both sides roll from Turn 3 on 5+, arrive from the long table edge adjacent to their quarter.',
    ],
    firstTurnRules: [
      'Meeting Engagement applies to the first player\'s first turn only.',
      '— Aircraft cannot arrive; first player\'s Teams count as having moved; no Bombardments.',
      'Both sides begin rolling for Delayed Reserves from Turn 3.',
    ],
    victoryConditions: [
      VictoryCondition(
        title: 'Hold the Objective You Placed',
        description:
            'A player wins if they end a turn Holding an Objective that they placed '
            '(no opposing Tank, Infantry, or Gun teams within 4"/10cm of it at end of turn).',
      ),
    ],
    specialRules: [
      'Diagonal quarter deployment — Attacker and Defender take diagonally opposite quarters.',
      'Each player places Objectives in opponent\'s quarter: one within 8"/20cm of long centre, one within 8"/20cm of long table edge.',
      'Meeting Engagement for first player\'s first turn.',
      'Both sides: Delayed Reserves from Turn 3 on 5+, arrive from long edge adjacent to own quarter.',
      'If 3+ dice but no 5+, one unit automatically arrives.',
      'Victory = Holding the Objective YOU PLACED.',
    ],
    hasReserves: true,
    reserveNote:
        'Both sides: max 60% on table. Delayed Reserves from Turn 3 on 5+, arrive from long edge adjacent to own quarter.',
    turnLimit: 6,
  ),

  Mission(
    id: 'fighting_withdrawal',
    name: 'Fighting Withdrawal',
    type: MissionType.attackDefend,
    tagline: 'Hold as long as possible, then pull back.',
    overview:
        'The Defender fights a delaying action with Strategic Withdrawal beginning from Turn 2. '
        'The Attacker must capture an Objective before the Defender withdraws successfully. '
        'The Defender wins at the start of their 8th turn.',
    attackerRole: 'Attacker',
    defenderRole: 'Defender',
    objectiveSetup: [
      'The Attacker places two Objectives within 16"/40cm of the Defender\'s long table edge, '
          'at least 16"/40cm from the side table edges.',
      'The Defender places one Minefield for each 25 points or part thereof in their force, '
          'anywhere outside the opponent\'s deployment area.',
    ],
    deploymentRules: [
      DeploymentRule(
        title: 'Defender — Full Deployment',
        description: 'Defender deploys all Units in their table half. Defender may hold one Unit in Ambush.',
      ),
      DeploymentRule(
        title: 'Attacker — Full Deployment',
        description: 'Attacker deploys all Units within 8"/20cm of their own long table edge.',
      ),
      DeploymentRule(
        title: 'Infantry & Guns in Foxholes',
        description: 'All Infantry and Gun Teams start the game in Foxholes.',
      ),
    ],
    startingConditions: [
      'The Attacker has the first turn.',
      'The Defender must remove Units from the table starting on Turn 2 using the Strategic Withdrawal rule.',
    ],
    firstTurnRules: [
      'Defender may place Ambush unit at start of their first turn.',
      'From Turn 2 onwards: at the start of each turn, after checking Victory Conditions, '
          'the Defender counts their Units (not Attachments or Independent Teams) and Delay Counters on table. '
          'If total is six or more: Withdraw one Unit (and its Attachments), remove all Delay Counters. '
          'If less than six: gain a Delay Counter (no withdrawal).',
      'A Unit not in Good Spirits when withdrawn counts as Destroyed for Victory Points.',
    ],
    victoryConditions: [
      VictoryCondition(
        title: 'Attacker Captures an Objective',
        description:
            'Attacker wins if they end their turn Holding an Objective '
            '(no Defending Tank, Infantry, or Gun teams within 4"/10cm of it).',
      ),
      VictoryCondition(
        title: 'Defender Withdraws Successfully',
        description:
            'Defender wins at the start of their 8th turn (after checking Force Morale).',
      ),
    ],
    specialRules: [
      'Long edge orientation — Defender picks a long table edge.',
      'Defender places Minefields: one per 25 pts, outside Attacker\'s deployment area.',
      'Defender may use Ambush (one Unit).',
      'Strategic Withdrawal from Turn 2: if 6+ Units/Delay Counters → withdraw 1 Unit; else gain a Delay Counter.',
      'Withdrawn Units in Good Spirits do NOT count as Destroyed for Victory Points.',
      'Defender wins at start of their Turn 8.',
    ],
    hasReserves: false,
    reserveNote: 'No reserves — both sides deploy fully. Strategic Withdrawal removes units from Turn 2.',
    turnLimit: 8,
  ),

  Mission(
    id: 'covering_force',
    name: 'Covering Force',
    type: MissionType.attackDefend,
    tagline: 'Buy time for the army to escape — then get out yourself.',
    overview:
        'The Defender fights a delaying action using Strategic Withdrawal to remove Units from Turn 3. '
        'Minefields slow the Attacker. The Defender wins at the start of their 8th turn '
        'if the Attacker has not captured an Objective.',
    attackerRole: 'Attacker',
    defenderRole: 'Defender',
    objectiveSetup: [
      'The Attacker places two Objectives within 16"/40cm of the Defender\'s long table edge, '
          'at least 16"/40cm from the side table edges.',
      'The Defender places one Minefield for each 25 points or part thereof in their force, '
          'anywhere outside the opponent\'s deployment area.',
    ],
    deploymentRules: [
      DeploymentRule(
        title: 'Defender — Full Deployment',
        description: 'Defender deploys all Units in their table half. Defender may hold one Unit in Ambush.',
      ),
      DeploymentRule(
        title: 'Attacker — Full Deployment',
        description: 'Attacker deploys all Units within 8"/20cm of their own long table edge.',
      ),
      DeploymentRule(
        title: 'Infantry & Guns in Foxholes',
        description: 'All Infantry and Gun Teams start the game in Foxholes.',
      ),
    ],
    startingConditions: [
      'The Attacker has the first turn.',
      'The Defender must remove Units from the table starting on Turn 3 using the Strategic Withdrawal rule.',
    ],
    firstTurnRules: [
      'Defender may place Ambush unit at start of their first turn.',
      'From Turn 3 onwards: at the start of each turn, after checking Victory Conditions, '
          'the Defender counts their Units (not Attachments or Independent Teams) and Delay Counters on table. '
          'If total is six or more: Withdraw one Unit (and its Attachments), remove all Delay Counters. '
          'If less than six: gain a Delay Counter (no withdrawal).',
      'A Unit not in Good Spirits when withdrawn counts as Destroyed for Victory Points.',
    ],
    victoryConditions: [
      VictoryCondition(
        title: 'Attacker Captures an Objective',
        description:
            'Attacker wins if they end their turn Holding an Objective '
            '(no Defending Tank, Infantry, or Gun teams within 4"/10cm of it).',
      ),
      VictoryCondition(
        title: 'Defender Withdraws Successfully',
        description:
            'Defender wins at the start of their 8th turn (after checking Force Morale).',
      ),
    ],
    specialRules: [
      'Defender places Minefields: one per 25 pts, outside Attacker\'s deployment area.',
      'Defender may use Ambush (one Unit).',
      'Strategic Withdrawal from Turn 3: if 6+ Units/Delay Counters → withdraw 1 Unit; else gain a Delay Counter.',
      'Withdrawn Units in Good Spirits do NOT count as Destroyed for Victory Points.',
      'Defender wins at start of their Turn 8.',
    ],
    hasReserves: false,
    reserveNote: 'No reserves — both sides deploy fully. Strategic Withdrawal removes units from Turn 3.',
    turnLimit: 8,
  ),

  Mission(
    id: 'spearpoint',
    name: 'Spearpoint',
    type: MissionType.manoeuvre,
    tagline: 'Drive a steel wedge through the enemy line.',
    overview:
        'The Defender picks a long table edge and deploys in a central corridor. '
        'The Attacker drives from a short edge. The Defender goes first (Meeting Engagement). '
        'Objectives are placed near the Attacker\'s short edge and in the Defender\'s corridor. '
        'A player wins by Holding an Objective they placed.',
    attackerRole: 'Attacker',
    defenderRole: 'Defender',
    objectiveSetup: [
      'The Defender picks a long table edge. Their Deployment Area is the corridor between their long table edge '
          'and the centre of the table, 12"/30cm wide on either side of the table centre.',
      'The Attacker then chooses a short table edge to attack from.',
      'The Defender places two Objectives up to 8"/20cm from the Attacker\'s table edge '
          'and more than 8"/20cm from the long table edges.',
      'The Attacker places one Objective in the Defender\'s Deployment Area '
          'at least 8"/20cm from the edge of the Deployment Area.',
      'The Attacker places another Objective up to 16"/40cm from their own short table edge, '
          'at least 8"/20cm from the long table edges.',
    ],
    deploymentRules: [
      DeploymentRule(
        title: 'Defender — Scattered Delayed Reserves (No Spearhead)',
        description:
            'Defender deploys up to 60% of their force in their Deployment Area (corridor 12"/30cm either side of table centre). '
            'Holds the rest in Scattered Delayed Reserve (roll from Turn 3 on 5+). '
            'Reserves arrive within 16"/40cm of indicated corners or along the Defender\'s Deployment Area edge. '
            'Defender may hold one Unit in Ambush. The Defender may not use the Spearhead rule.',
      ),
      DeploymentRule(
        title: 'Attacker — Immediate Reserves (No Spearhead)',
        description:
            'Attacker deploys up to 60% of their force in their table half at least 24"/60cm from the long centre line. '
            'Holds the rest in Immediate Reserve, arriving from their short table edge (roll from Turn 1 on 5+). '
            'The Attacker may not use the Spearhead rule.',
      ),
      DeploymentRule(
        title: 'Infantry & Guns in Foxholes',
        description: 'All Infantry and Gun Teams start the game in Foxholes.',
      ),
    ],
    startingConditions: [
      'The Defender has the first turn. As the game is a Meeting Engagement, the Defender shoots as if they moved '
          'and cannot use Artillery Bombardments or Aircraft on their first turn.',
      'Attacker Immediate Reserves: roll from Turn 1 on 5+, arrive from the Attacker\'s short table edge.',
      'Defender Scattered Delayed Reserves: roll from Turn 3 on 5+; '
          'arrive within 16"/40cm of indicated corners or along Defender\'s Deployment Area edge.',
    ],
    firstTurnRules: [
      'Meeting Engagement applies to the Defender\'s first turn only.',
      'Defender may place Ambush unit at start of their first turn.',
      'Attacker begins rolling for Immediate Reserves from Turn 1.',
      'Defender begins rolling for Scattered Delayed Reserves from Turn 3.',
    ],
    victoryConditions: [
      VictoryCondition(
        title: 'Hold the Objective You Placed',
        description:
            'A player wins if they end their turn Holding an Objective that they placed '
            '(no opposing Tank, Infantry, or Gun teams within 4"/10cm of it at end of turn).',
      ),
    ],
    specialRules: [
      'Defender picks LONG edge; deploys in central corridor 12"/30cm either side of table centre.',
      'Attacker attacks from SHORT edge.',
      'DEFENDER goes first — Meeting Engagement applies to Defender\'s first turn.',
      'No Spearhead for BOTH players.',
      'Attacker places 2 Objectives: one in Defender\'s corridor AND one near own short edge.',
      'Defender places 2 Objectives near Attacker\'s short edge.',
      'Victory = Holding the Objective YOU PLACED.',
      'Attacker: Immediate Reserves from Turn 1 on 5+ (own short edge).',
      'Defender: Scattered Delayed Reserves from Turn 3 on 5+ (corners/deployment edge).',
      'Defender may use Ambush (one Unit).',
    ],
    hasReserves: true,
    reserveNote:
        'Attacker: max 60% on table. Immediate Reserves from Turn 1 on 5+, arrive from own short edge. '
        'Defender: max 60% on table. Scattered Delayed Reserves from Turn 3 on 5+.',
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
        'The Defender picks a long table edge. The Attacker places two Objectives in the Defender\'s half. '
        'The Attacker splits their force between two corners of their half. '
        'The Defender holds their half with Scattered Immediate Reserves. Minefields slow the advance.',
    attackerRole: 'Attacker',
    defenderRole: 'Defender',
    objectiveSetup: [
      'The Defender picks a long table edge to defend from. The Attacker attacks from the opposite side.',
      'The Attacker places two Objectives in the Defender\'s table half. '
          'Objectives must be either at least 16"/40cm from the long centre line and 12"/30cm from the short table edges, '
          'or within 4"/10cm of the short centre line.',
      'The Defender may place one Minefield for each 50 points or part thereof in their force, '
          'anywhere outside the Attacker\'s deployment area.',
    ],
    deploymentRules: [
      DeploymentRule(
        title: 'Defender — Scattered Immediate Reserves',
        description:
            'Defender deploys up to 60% of their force in their table half, '
            'at least 8"/20cm from the long centre line, or within 8"/20cm of the short centre line '
            'and no more than 4"/10cm into the Attacker\'s table half. '
            'Remainder are Scattered Immediate Reserves (roll from Turn 1 on 5+). '
            'When each unit arrives, the Defender rolls to determine from which table edge or corner it arrives. '
            'Defender may hold one Unit in Ambush.',
      ),
      DeploymentRule(
        title: 'Attacker — Split Corner Deployment',
        description:
            'Attacker deploys between 40% and 60% of their force within 16"/40cm of both table edges '
            'at one corner of their table half. '
            'The Attacker deploys the rest of their force within 16"/40cm of both table edges '
            'at the other corner of their table half.',
      ),
      DeploymentRule(
        title: 'Infantry & Guns in Foxholes',
        description: 'All Infantry and Gun Teams start the game in Foxholes.',
      ),
    ],
    startingConditions: [
      'The Attacker has the first turn.',
      'Defender Scattered Immediate Reserves: roll from Turn 1 on 5+; roll to determine arrival edge/corner.',
      'Attacker splits force between two corners of their table half.',
    ],
    firstTurnRules: [
      'Defender may place Ambush unit at start of their first turn.',
      'Defender begins rolling for Scattered Immediate Reserves from Turn 1.',
    ],
    victoryConditions: [
      VictoryCondition(
        title: 'Attacker Holds an Objective',
        description:
            'Attacker wins if they end their turn Holding an Objective '
            '(no Defending Tank, Infantry, or Gun teams within 4"/10cm of it).',
      ),
      VictoryCondition(
        title: 'Defender Repels the Attack (Turn 6+)',
        description:
            'Defender wins if they end their turn on or after Turn 6 having Repelled the Attack '
            '(no Attacking Tank, Infantry, or Gun teams within 8"/20cm of any Objective).',
      ),
    ],
    specialRules: [
      'Long edge orientation — Defender picks a long table edge.',
      'Attacker places Objectives: at least 16"/40cm from long centre AND 12"/30cm from short edges, OR within 4"/10cm of short centre line.',
      'Attacker deploys split across two corners of their half (40–60% at one corner, rest at the other).',
      'Defender deploys in their half: at least 8"/20cm from long centre OR within 8"/20cm of short centre (max 4"/10cm into Attacker\'s half).',
      'Defender: Scattered Immediate Reserves from Turn 1 on 5+ (random edge/corner).',
      'Defender places Minefields: one per 50 pts, outside Attacker\'s deployment area.',
      'Defender may use Ambush (one Unit).',
    ],
    hasReserves: true,
    reserveNote:
        'Defender: max 60% on table. Scattered Immediate Reserves from Turn 1 on 5+, arrive at random table edge/corner.',
    turnLimit: 6,
  ),

  Mission(
    id: 'hold_the_pocket',
    name: 'Hold the Pocket',
    type: MissionType.attackDefend,
    tagline: 'Hold your ground — every man counts.',
    overview:
        'Long edge orientation. The Attacker places two Objectives near the short centre line in the Defender\'s half. '
        'The Defender holds the centre with Deep Immediate Reserves. '
        'The Attacker deploys at either short table edge.',
    attackerRole: 'Attacker',
    defenderRole: 'Defender',
    objectiveSetup: [
      'The Defender picks a long table edge to defend from. The Attacker attacks from the opposite side.',
      'The Attacker places two Objectives within 4"/10cm of the short centre line, '
          'in the Defender\'s table half, at least 8"/20cm from the long table edge.',
      'The Defender may place one Minefield for each 25 points or part thereof in their force, '
          'anywhere outside the Attacker\'s deployment area.',
    ],
    deploymentRules: [
      DeploymentRule(
        title: 'Defender — Deep Immediate Reserves',
        description:
            'Defender deploys up to 60% of their force within 12"/30cm of the short centre line, '
            'either in their table half or within 4"/10cm of the long centre line. '
            'Holds the rest in Deep Immediate Reserve. '
            'No more than one Battle Tank Unit or Aircraft Unit may be deployed on table; '
            'all remaining Units of those types must be held in Reserve. '
            'Reserves arrive along the Defender\'s long table edge, not within 16"/40cm of the short table edges (roll from Turn 1 on 5+). '
            'Defender may hold one Unit in Ambush.',
      ),
      DeploymentRule(
        title: 'Attacker — Short Edge Deployment',
        description:
            'Attacker deploys all Units within 8"/20cm of either short table edge. '
            'May split force between both short edges.',
      ),
      DeploymentRule(
        title: 'Infantry & Guns in Foxholes',
        description: 'All Infantry and Gun Teams start the game in Foxholes.',
      ),
    ],
    startingConditions: [
      'The Attacker has the first turn.',
      'Defender Deep Immediate Reserves: roll from Turn 1 on 5+; arrive along Defender\'s long table edge '
          '(not within 16"/40cm of short table edges).',
      'No more than one Battle Tank Unit or Aircraft Unit on table for Defender at start.',
    ],
    firstTurnRules: [
      'Defender may place Ambush unit at start of their first turn.',
      'Defender begins rolling for Deep Immediate Reserves from Turn 1.',
    ],
    victoryConditions: [
      VictoryCondition(
        title: 'Attacker Holds an Objective',
        description:
            'Attacker wins if they end their turn Holding an Objective '
            '(no Defending Tank, Infantry, or Gun teams within 4"/10cm of it).',
      ),
      VictoryCondition(
        title: 'Defender Repels the Attack (Turn 6+)',
        description:
            'Defender wins if they end their turn on or after Turn 6 having Repelled the Attack '
            '(no Attacking Tank, Infantry, or Gun teams within 8"/20cm of any Objective).',
      ),
    ],
    specialRules: [
      'Long edge orientation — Defender picks a long table edge.',
      'Attacker places Objectives within 4"/10cm of short centre line, in Defender\'s half, at least 8"/20cm from long edge.',
      'Attacker deploys within 8"/20cm of EITHER short table edge (may split between both ends).',
      'Defender deploys within 12"/30cm of short centre line (own half or within 4"/10cm of long centre).',
      'Defender: Deep Immediate Reserves from Turn 1 on 5+; arrive along Defender\'s long edge (not within 16"/40cm of short edges).',
      'Defender: no more than one Battle Tank Unit or Aircraft Unit on table at start.',
      'Defender places Minefields: one per 25 pts, outside Attacker\'s deployment area.',
      'Defender may use Ambush (one Unit).',
      'Attacker may win any turn; Defender win condition activates Turn 6+.',
    ],
    hasReserves: true,
    reserveNote:
        'Defender: max 60% on table (heavy armour/aircraft restricted). Deep Immediate Reserves from Turn 1 on 5+, arrive along Defender\'s long edge.',
    turnLimit: 6,
  ),

  Mission(
    id: 'escape',
    name: 'Escape',
    type: MissionType.attackDefend,
    tagline: 'Break through — or be destroyed.',
    overview:
        'The Defender picks a short table edge and goes first. Both players place one Objective '
        'in the Defender\'s half. The Defender holds Immediate Reserves arriving from the Attacker\'s '
        'short table edge. The Defender wins by holding out from Turn 6.',
    attackerRole: 'Attacker',
    defenderRole: 'Defender',
    objectiveSetup: [
      'The Defender picks a short table edge to defend from. The Attacker attacks from the opposite end.',
      'Both players, starting with the Defender, place one Objective in the Defender\'s table half, '
          'at least 16"/40cm from the short centre line and 8"/20cm from all table edges.',
    ],
    deploymentRules: [
      DeploymentRule(
        title: 'Defender — Immediate Reserves',
        description:
            'Defender deploys up to 60% of their force in their table half at least 8"/20cm from the short centre line. '
            'Holds the rest in Immediate Reserve. '
            'Reserves arrive from the Attacking player\'s short table edge (roll from Turn 1 on 5+). '
            'Defender may hold one Unit in Ambush.',
      ),
      DeploymentRule(
        title: 'Attacker — Full Deployment',
        description:
            'Attacker deploys all Units in their table half at least 8"/20cm from the short centre line '
            'and at least 12"/30cm from their own short table edge.',
      ),
      DeploymentRule(
        title: 'Infantry & Guns in Foxholes',
        description: 'All Infantry and Gun Teams start the game in Foxholes.',
      ),
    ],
    startingConditions: [
      'The Defender has the first turn.',
      'Defender Immediate Reserves: roll from Turn 1 on 5+, arrive from the Attacker\'s short table edge.',
    ],
    firstTurnRules: [
      'Defender may place Ambush unit at start of their first turn.',
      'Defender begins rolling for Immediate Reserves from Turn 1.',
    ],
    victoryConditions: [
      VictoryCondition(
        title: 'Attacker Holds an Objective',
        description:
            'Attacker wins if they end their turn Holding an Objective '
            '(no Defending Tank, Infantry, or Gun teams within 4"/10cm of it).',
      ),
      VictoryCondition(
        title: 'Defender Repels the Attack (Turn 6+)',
        description:
            'Defender wins if they end their turn on or after Turn 6 having Repelled the Attack '
            '(no Attacking Tank, Infantry, or Gun teams within 8"/20cm of any Objective).',
      ),
    ],
    specialRules: [
      'Short edge orientation — Defender picks a short table edge.',
      'Defender goes FIRST.',
      'Both Objectives placed in Defender\'s half.',
      'Defender Immediate Reserves arrive from the ATTACKER\'S short table edge (from Turn 1 on 5+).',
      'Defender may use Ambush (one Unit).',
      'Attacker may win any turn; Defender win condition activates Turn 6+.',
    ],
    hasReserves: true,
    reserveNote:
        'Defender: max 60% on table. Immediate Reserves from Turn 1 on 5+, arriving from the Attacker\'s short table edge.',
    turnLimit: 6,
  ),

  Mission(
    id: 'dogfight',
    name: 'Dogfight',
    type: MissionType.attackDefend,
    tagline: 'Drive through the prepared defence — the Defender has nowhere to hide.',
    overview:
        'The Defender picks a short table edge. Both players place one Objective each in the Defender\'s half. '
        'The Attacker deploys in their half at least 16"/40cm from the short centre line. '
        'The Defender has Deep Scattered Delayed Reserves. The Attacker strikes first.',
    attackerRole: 'Attacker',
    defenderRole: 'Defender',
    objectiveSetup: [
      'The Defender picks a short table edge to defend from. The Attacker attacks from the opposite edge.',
      'Both players, starting with the Defender, place one Objective in the Defender\'s table half, '
          'at least 8"/20cm from the short centre line and all table edges.',
      'The Defender places one Minefield for each 25 points or part thereof in their force, '
          'anywhere outside the opponent\'s deployment area.',
    ],
    deploymentRules: [
      DeploymentRule(
        title: 'Defender — Deep Scattered Delayed Reserves',
        description:
            'Defender deploys up to 60% of their force in their table half. '
            'Holds the rest in Deep Scattered Delayed Reserve (rolls from Turn 3 on 5+). '
            'No more than one Battle Tank Unit or Aircraft Unit may be deployed on table; '
            'all remaining Units of those types must be held in Reserve. '
            'The Defender rolls to determine from which table edge each Reserve Unit arrives, '
            'entering the table anywhere along that edge in the Defender\'s table half. '
            'Defender may hold one Unit in Ambush.',
      ),
      DeploymentRule(
        title: 'Attacker — Full Deployment',
        description:
            'Attacker deploys all Units in their table half at least 16"/40cm from the short centre line.',
      ),
      DeploymentRule(
        title: 'Infantry & Guns in Foxholes',
        description: 'All Infantry and Gun Teams start the game in Foxholes.',
      ),
    ],
    startingConditions: [
      'The Attacker has the first turn.',
      'Defender Deep Scattered Delayed Reserves: roll from Turn 3 on 5+; arrive at random table edge in Defender\'s half.',
      'No more than one Battle Tank Unit or Aircraft Unit on table for Defender at start.',
    ],
    firstTurnRules: [
      'Defender may place Ambush unit at start of their first turn.',
      'Defender begins rolling for Deep Scattered Delayed Reserves from Turn 3.',
    ],
    victoryConditions: [
      VictoryCondition(
        title: 'Attacker Holds an Objective',
        description:
            'Attacker wins if they end their turn Holding an Objective '
            '(no Defending Tank, Infantry, or Gun teams within 4"/10cm of it).',
      ),
      VictoryCondition(
        title: 'Defender Repels the Attack (Turn 6+)',
        description:
            'Defender wins if they end their turn on or after Turn 6 having Repelled the Attack '
            '(no Attacking Tank, Infantry, or Gun teams within 8"/20cm of any Objective).',
      ),
    ],
    specialRules: [
      'Short edge orientation — Defender picks a short table edge.',
      'Both Objectives placed in Defender\'s half.',
      'Defender: Deep Scattered Delayed Reserves from Turn 3 on 5+ (random table edge, Defender\'s half only).',
      'Defender: no more than one Battle Tank Unit or Aircraft Unit on table at start.',
      'Defender places Minefields: one per 25 pts, outside Attacker\'s deployment area.',
      'Defender may use Ambush (one Unit).',
      'Attacker may win any turn; Defender win condition activates Turn 6+.',
    ],
    hasReserves: true,
    reserveNote:
        'Defender: max 60% on table (heavy armour/aircraft restricted). Deep Scattered Delayed Reserves from Turn 3 on 5+.',
    turnLimit: 6,
  ),

  Mission(
    id: 'gauntlet',
    name: 'Gauntlet',
    type: MissionType.manoeuvre,
    tagline: 'Drive through the killing zone.',
    overview:
        'The Defender picks a long table edge and deploys within 12"/30cm of either short table edge. '
        'The Attacker deploys in the central zone at least 28"/70cm from the short edges. '
        'The Attacker has the first turn (Meeting Engagement) and Immediate Reserves from their short edge. '
        'Objectives lie in the middle of the table.',
    attackerRole: 'Attacker',
    defenderRole: 'Defender',
    objectiveSetup: [
      'The Defender picks a long table edge to defend from. The Attacker attacks from the opposite side.',
      'The Attacker places two Objectives in the Defender\'s table half. '
          'Objectives must be at least 8"/20cm from the long centre line and the long table edge, '
          'and at least 24"/60cm from the short table edges.',
    ],
    deploymentRules: [
      DeploymentRule(
        title: 'Defender — Scattered Delayed Reserves',
        description:
            'Defender deploys up to 60% of their force within 12"/30cm of either short table edge, '
            'at least 8"/20cm from the Attacker\'s long table edge. '
            'May split force between both ends of the table. '
            'Remainder are Scattered Delayed Reserves (roll from Turn 3 on 5+). '
            'When each unit arrives, Defender rolls to determine which short table edge it arrives from.',
      ),
      DeploymentRule(
        title: 'Attacker — Immediate Reserves',
        description:
            'Attacker deploys up to 60% of their force in their own table half, '
            'at least 28"/70cm from the short table edges and 8"/20cm from the long centre line. '
            'Remainder are Immediate Reserves arriving from the Attacker\'s long table edge (roll from Turn 1 on 5+).',
      ),
      DeploymentRule(
        title: 'Infantry & Guns in Foxholes',
        description: 'All Infantry and Gun Teams start the game in Foxholes.',
      ),
    ],
    startingConditions: [
      'The Attacker has the first turn. As this is a Meeting Engagement, the Attacker shoots as if they moved, '
          'cannot use Artillery Bombardments, and has no Aircraft on their first turn.',
      'Defender Scattered Delayed Reserves: roll from Turn 3 on 5+; roll to determine which short edge Unit arrives from.',
      'Attacker Immediate Reserves: roll from Turn 1 on 5+; arrive from Attacker\'s long table edge.',
    ],
    firstTurnRules: [
      'Meeting Engagement applies to the Attacker\'s first turn only.',
      'Attacker begins rolling for Immediate Reserves from Turn 1.',
      'Defender begins rolling for Scattered Delayed Reserves from Turn 3.',
    ],
    victoryConditions: [
      VictoryCondition(
        title: 'Attacker Breaks Through (Turn 6+)',
        description:
            'Attacker wins if they end their turn on or after Turn 6 Holding an Objective.',
      ),
      VictoryCondition(
        title: 'Defender Repels the Attack (Turn 6+)',
        description:
            'Defender wins if they end their turn on or after Turn 6 having Repelled the Attack '
            '(no Attacking Tank, Infantry, or Gun teams within 8"/20cm of any Objective).',
      ),
    ],
    specialRules: [
      'Long edge orientation — Defender picks a long table edge.',
      'Defender deploys within 12"/30cm of EITHER short table edge (may split between both ends).',
      'Attacker deploys in own half at least 28"/70cm from short edges and 8"/20cm from long centre.',
      'Attacker has first turn — Meeting Engagement applies to Attacker\'s first turn.',
      'Objectives: at least 24"/60cm from short edges, 8"/20cm from long centre and long table edge.',
      'Attacker Immediate Reserves from Turn 1 on 5+ (own long table edge).',
      'Defender Scattered Delayed Reserves from Turn 3 on 5+ (random short table edge).',
      'Victory conditions check from Turn 6 onwards.',
    ],
    hasReserves: true,
    reserveNote:
        'Attacker: max 60% on table. Immediate Reserves from Turn 1 on 5+, arrive from Attacker\'s long edge. '
        'Defender: max 60% on table. Scattered Delayed Reserves from Turn 3 on 5+, arrive from random short edge.',
    turnLimit: 6,
  ),

  Mission(
    id: 'killing_ground',
    name: 'Killing Ground',
    type: MissionType.attackDefend,
    tagline: 'Advance into the prepared kill zone.',
    overview:
        'The Defender has prepared a devastating kill zone. Objectives are at least 16"/40cm from the long centre line. '
        'The Attacker must advance through minefields and carefully positioned units '
        'with Deep Scattered Immediate Reserves threatening from the flanks.',
    attackerRole: 'Attacker',
    defenderRole: 'Defender',
    objectiveSetup: [
      'The Defender picks a long table edge to defend from. The Attacker attacks from the opposite edge.',
      'The Attacker places two Objectives in the Defender\'s half of the table, '
          'at least 16"/40cm from the long centre line and at least 8"/20cm from the short table edges.',
      'The Defender places one Minefield for each 25 points or part thereof in their force, '
          'anywhere outside the opponent\'s deployment area.',
    ],
    deploymentRules: [
      DeploymentRule(
        title: 'Defender — Deep Scattered Immediate Reserves',
        description:
            'Defender deploys up to 60% of their force in their table half at least 8"/20cm from the long centre line, '
            'or in the Attacker\'s table half within 8"/20cm of the short table edges. '
            'Holds the rest in Deep Scattered Immediate Reserve (roll from Turn 1 on 5+). '
            'No more than one Battle Tank Unit or Aircraft Unit may be deployed on table. '
            'The Defender rolls to determine from which table edge each Reserve Unit arrives. '
            'Defender may hold one Unit in Ambush.',
      ),
      DeploymentRule(
        title: 'Attacker — Full Deployment',
        description:
            'Attacker deploys all Units in their table half at least 8"/20cm from the long centre line '
            'and 20"/50cm from the short table edges.',
      ),
      DeploymentRule(
        title: 'Infantry & Guns in Foxholes',
        description: 'All Infantry and Gun Teams start the game in Foxholes.',
      ),
    ],
    startingConditions: [
      'The Attacker has the first turn.',
      'Defender Deep Scattered Immediate Reserves: roll from Turn 1 on 5+; roll to determine arrival table edge.',
      'No more than one Battle Tank Unit or Aircraft Unit on table for Defender at start.',
    ],
    firstTurnRules: [
      'Defender may place Ambush unit at start of their first turn.',
      'Defender begins rolling for Deep Scattered Immediate Reserves from Turn 1.',
    ],
    victoryConditions: [
      VictoryCondition(
        title: 'Attacker Holds an Objective',
        description:
            'Attacker wins if they end their turn Holding an Objective '
            '(no Defending Tank, Infantry, or Gun teams within 4"/10cm of it).',
      ),
      VictoryCondition(
        title: 'Defender Holds the Kill Zone (Turn 6+)',
        description:
            'Defender wins if they end their turn on or after Turn 6 having Repelled the Attack '
            '(no Attacking Tank, Infantry, or Gun teams within 8"/20cm of any Objective).',
      ),
    ],
    specialRules: [
      'Long edge orientation — Defender picks a long table edge.',
      'Objectives at least 16"/40cm from long centre line (in Defender\'s half).',
      'Attacker deploys at least 8"/20cm from long centre AND 20"/50cm from short edges.',
      'Defender deploys in their half at least 8"/20cm from long centre, '
          'OR in Attacker\'s half within 8"/20cm of short edges.',
      'Defender: Deep Scattered Immediate Reserves from Turn 1 on 5+ (random table edge).',
      'Defender: no more than one Battle Tank Unit or Aircraft Unit on table at start.',
      'Defender places Minefields: one per 25 pts, outside Attacker\'s deployment area.',
      'Defender may use Ambush (one Unit).',
      'Attacker may win any turn; Defender win condition activates Turn 6+.',
    ],
    hasReserves: true,
    reserveNote:
        'Defender: max 60% on table (heavy armour/aircraft restricted). Deep Scattered Immediate Reserves from Turn 1 on 5+.',
    turnLimit: 6,
  ),

  Mission(
    id: 'its_a_trap',
    name: 'It\'s a Trap',
    type: MissionType.attackDefend,
    tagline: 'The kill zone was bait — now the jaws close.',
    overview:
        'The Defender lures the Attacker into a prepared kill zone. '
        'Objectives are placed at least 16"/40cm from the long centre line. '
        'The Defender has Deep Scattered Delayed Reserves arriving from Turn 3.',
    attackerRole: 'Attacker',
    defenderRole: 'Defender',
    objectiveSetup: [
      'The Defender picks a long table edge to defend from. The Attacker attacks from the opposite edge.',
      'The Attacker places two Objectives in the Defender\'s half of the table, '
          'at least 16"/40cm from the long centre line and at least 8"/20cm from the short table edges.',
      'The Defender places one Minefield for each 25 points or part thereof in their force, '
          'anywhere outside the opponent\'s deployment area.',
    ],
    deploymentRules: [
      DeploymentRule(
        title: 'Defender — Deep Scattered Delayed Reserves',
        description:
            'Defender deploys up to 60% of their force in their table half, '
            'at least 8"/20cm from the long centre line, '
            'or in the Attacker\'s table half within 8"/20cm of the short table edges. '
            'Holds the rest in Deep Scattered Delayed Reserve (roll from Turn 3 on 5+). '
            'No more than one Battle Tank Unit or Aircraft Unit may be deployed on table. '
            'The Defender rolls to determine from which table edge each Reserve Unit arrives. '
            'Defender may hold one Unit in Ambush.',
      ),
      DeploymentRule(
        title: 'Attacker — Full Deployment',
        description:
            'Attacker deploys all Units in their table half at least 8"/20cm from the long centre line '
            'and 20"/50cm from the short table edges.',
      ),
      DeploymentRule(
        title: 'Infantry & Guns in Foxholes',
        description: 'All Infantry and Gun Teams start the game in Foxholes.',
      ),
    ],
    startingConditions: [
      'The Attacker has the first turn.',
      'Defender Deep Scattered Delayed Reserves: roll from Turn 3 on 5+; roll to determine arrival table edge.',
      'No more than one Battle Tank Unit or Aircraft Unit on table for Defender at start.',
    ],
    firstTurnRules: [
      'Defender may place Ambush unit at start of their first turn.',
      'Defender begins rolling for Deep Scattered Delayed Reserves from Turn 3.',
    ],
    victoryConditions: [
      VictoryCondition(
        title: 'Attacker Holds an Objective',
        description:
            'Attacker wins if they end their turn Holding an Objective '
            '(no Defending Tank, Infantry, or Gun teams within 4"/10cm of it).',
      ),
      VictoryCondition(
        title: 'Defender Repels the Attack (Turn 6+)',
        description:
            'Defender wins if they end their turn on or after Turn 6 having Repelled the Attack '
            '(no Attacking Tank, Infantry, or Gun teams within 8"/20cm of any Objective).',
      ),
    ],
    specialRules: [
      'Long edge orientation — Defender picks a long table edge.',
      'Objectives at least 16"/40cm from long centre line (in Defender\'s half).',
      'Attacker deploys at least 8"/20cm from long centre AND 20"/50cm from short edges.',
      'Defender deploys at least 8"/20cm from long centre (OR in Attacker\'s half within 8"/20cm of short edges).',
      'Defender: Deep Scattered Delayed Reserves from Turn 3 on 5+ (random table edge).',
      'Defender: no more than one Battle Tank Unit or Aircraft Unit on table at start.',
      'Defender places Minefields: one per 25 pts, outside Attacker\'s deployment area.',
      'Defender may use Ambush (one Unit).',
      'Attacker may win any turn; Defender win condition activates Turn 6+.',
    ],
    hasReserves: true,
    reserveNote:
        'Defender: max 60% on table (heavy armour/aircraft restricted). Deep Scattered Delayed Reserves from Turn 3 on 5+.',
    turnLimit: 6,
  ),

  Mission(
    id: 'outflanked',
    name: 'Outflanked',
    type: MissionType.attackDefend,
    tagline: 'The flanks are turning — hold the centre.',
    overview:
        'The Defender picks a table quarter. The Attacker attacks from the opposite long table edge. '
        'The No-Man\'s Land quarter is diagonally opposite the Defender. '
        'Objectives lie in the Defender\'s or No-Man\'s Land quarter. '
        'The Defender has Immediate Reserves but may not use Spearhead.',
    attackerRole: 'Attacker',
    defenderRole: 'Defender',
    objectiveSetup: [
      'The Defender picks a table quarter to defend.',
      'The Attacker attacks from the opposite long table edge.',
      'The Attacker places two Objectives in the Defender\'s table quarter or in the No-Man\'s Land table quarter '
          '(the quarter diagonally opposite the Defender\'s quarter). '
          'Objectives must be at least 8"/20cm from the long centre line and all table edges, '
          'and at least 32"/80cm from the short table edge in the No-Man\'s Land quarter.',
    ],
    deploymentRules: [
      DeploymentRule(
        title: 'Defender — Immediate Reserves (No Spearhead)',
        description:
            'Defender deploys up to 60% of their force in their table quarter or in the No-Man\'s Land table quarter, '
            'at least 32"/80cm from the short table edge. '
            'Holds the rest in Immediate Reserve, arriving within 16"/40cm of the Defender\'s table corner (roll from Turn 1 on 5+). '
            'The Defending player may not use the Spearhead rule. '
            'Defender may hold one Unit in Ambush.',
      ),
      DeploymentRule(
        title: 'Attacker — Full Deployment',
        description:
            'Attacker deploys all Units in their table half at least 16"/40cm from the long centre line, '
            'or within 8"/20cm of the short table edge opposite the Defender\'s table quarter.',
      ),
      DeploymentRule(
        title: 'Infantry & Guns in Foxholes',
        description: 'All Infantry and Gun Teams start the game in Foxholes.',
      ),
    ],
    startingConditions: [
      'The Attacker has the first turn.',
      'Defender Immediate Reserves: roll from Turn 1 on 5+, arrive within 16"/40cm of Defender\'s table corner.',
      'No-Man\'s Land is the quarter diagonally opposite the Defender\'s quarter.',
    ],
    firstTurnRules: [
      'Defender may place Ambush unit at start of their first turn.',
      'Defender begins rolling for Immediate Reserves from Turn 1.',
    ],
    victoryConditions: [
      VictoryCondition(
        title: 'Attacker Holds an Objective (Turn 6+)',
        description:
            'Attacker wins if they end their turn on or after Turn 6 Holding an Objective '
            '(no Defending Tank, Infantry, or Gun teams within 4"/10cm of it).',
      ),
      VictoryCondition(
        title: 'Defender Repels the Attack (Turn 6+)',
        description:
            'Defender wins if they end their turn on or after Turn 6 having Repelled the Attack '
            '(no Attacking Tank, Infantry, or Gun teams within 8"/20cm of any Objective).',
      ),
    ],
    specialRules: [
      'Quarter deployment — Defender picks a table quarter; Attacker attacks from opposite LONG edge.',
      'No-Man\'s Land = the quarter diagonally opposite the Defender\'s quarter.',
      'Objectives in Defender\'s OR No-Man\'s Land quarter, at least 32"/80cm from the short table edge in No-Man\'s Land.',
      'Defender deploys in own quarter OR No-Man\'s Land quarter (at least 32"/80cm from short edge).',
      'Defender Immediate Reserves from Turn 1 on 5+ (within 16"/40cm of Defender\'s corner).',
      'No Spearhead for Defender only.',
      'Defender may use Ambush (one Unit).',
      'Victory conditions check from Turn 6 onwards.',
    ],
    hasReserves: true,
    reserveNote:
        'Defender: max 60% on table. Immediate Reserves from Turn 1 on 5+, arrive within 16"/40cm of Defender\'s corner.',
    turnLimit: 6,
  ),

  Mission(
    id: 'outmanoeuvred',
    name: 'Outmanoeuvred',
    type: MissionType.manoeuvre,
    tagline: 'Speed and cunning beat brute force.',
    overview:
        'Same deployment as Outflanked, but the Defender goes first (Meeting Engagement). '
        'The Defender has Immediate Reserves and may not use Spearhead. '
        'The Attacker deploys their entire force with no reserves.',
    attackerRole: 'Attacker',
    defenderRole: 'Defender',
    objectiveSetup: [
      'The Defender picks a table quarter to defend.',
      'The Attacker attacks from the opposite long table edge.',
      'The Attacker places two Objectives in the Defender\'s table quarter or in the No-Man\'s Land table quarter '
          '(the quarter diagonally opposite the Defender\'s quarter). '
          'Objectives must be at least 8"/20cm from the long centre line and all table edges, '
          'and at least 32"/80cm from the short table edge in the No-Man\'s Land quarter.',
    ],
    deploymentRules: [
      DeploymentRule(
        title: 'Defender — Immediate Reserves (No Spearhead)',
        description:
            'Defender deploys up to 60% of their force in their table quarter or in the No-Man\'s Land table quarter, '
            'at least 32"/80cm from the short table edge. '
            'Holds the rest in Immediate Reserve, arriving within 16"/40cm of the Defender\'s table corner (roll from Turn 1 on 5+). '
            'The Defending player may not use the Spearhead rule. '
            'Defender may hold one Unit in Ambush.',
      ),
      DeploymentRule(
        title: 'Attacker — Full Deployment (No Reserves)',
        description:
            'Attacker deploys all Units in their table half at least 16"/40cm from the long centre line, '
            'or within 8"/20cm of the short table edge opposite the Defender\'s table quarter. '
            'Attacker deploys their entire force — no reserves.',
      ),
      DeploymentRule(
        title: 'Infantry & Guns in Foxholes',
        description: 'All Infantry and Gun Teams start the game in Foxholes.',
      ),
    ],
    startingConditions: [
      'The Defender has the first turn. As the game is a Meeting Engagement, the Defender shoots as if they moved '
          'and cannot use Artillery Bombardments or Aircraft on their first turn.',
      'Defender Immediate Reserves: roll from Turn 1 on 5+, arrive within 16"/40cm of Defender\'s table corner.',
      'No-Man\'s Land is the quarter diagonally opposite the Defender\'s quarter.',
    ],
    firstTurnRules: [
      'Meeting Engagement applies to the Defender\'s first turn only.',
      'Defender may place Ambush unit at start of their first turn.',
      'Defender begins rolling for Immediate Reserves from Turn 1.',
    ],
    victoryConditions: [
      VictoryCondition(
        title: 'Attacker Holds an Objective (Turn 6+)',
        description:
            'Attacker wins if they end their turn on or after Turn 6 Holding an Objective '
            '(no Defending Tank, Infantry, or Gun teams within 4"/10cm of it).',
      ),
      VictoryCondition(
        title: 'Defender Repels the Attack (Turn 6+)',
        description:
            'Defender wins if they end their turn on or after Turn 6 having Repelled the Attack '
            '(no Attacking Tank, Infantry, or Gun teams within 8"/20cm of any Objective).',
      ),
    ],
    specialRules: [
      'Same deployment as Outflanked, but the DEFENDER goes first.',
      'Meeting Engagement applies to the Defender\'s first turn.',
      'Attacker deploys FULLY — no reserves.',
      'No Spearhead for Defender only.',
      'Defender Immediate Reserves from Turn 1 on 5+ (within 16"/40cm of Defender\'s corner).',
      'Defender may use Ambush (one Unit).',
      'Victory conditions check from Turn 6 onwards.',
    ],
    hasReserves: true,
    reserveNote:
        'Defender: max 60% on table. Immediate Reserves from Turn 1 on 5+, arrive within 16"/40cm of Defender\'s corner. Attacker: no reserves.',
    turnLimit: 6,
  ),

  Mission(
    id: 'valley_of_death',
    name: 'Valley of Death',
    type: MissionType.manoeuvre,
    tagline: 'Cross the open ground — or die trying.',
    overview:
        'Short edge orientation. The Defender deploys within 8"/20cm of either long table edge. '
        'The Attacker deploys in the central zone at least 12"/30cm from the long edges and 16"/40cm from the short centre. '
        'The Attacker goes first (Meeting Engagement). Objectives are at least 16"/40cm from long centre and long edge.',
    attackerRole: 'Attacker',
    defenderRole: 'Defender',
    objectiveSetup: [
      'The Defender picks a short table edge to defend from. The Attacker attacks from the opposite end.',
      'The Attacker places two Objectives in the Defender\'s table half. '
          'Objectives must be at least 16"/40cm from the long centre line and the long table edge, '
          'and at least 8"/20cm from the short table edges.',
    ],
    deploymentRules: [
      DeploymentRule(
        title: 'Defender — Scattered Delayed Reserves',
        description:
            'Defender deploys up to 60% of their force in their table half within 8"/20cm of either long table edge. '
            'May split force between both sides of the table. '
            'Holds the rest in Scattered Delayed Reserve (roll from Turn 3 on 5+). '
            'When each unit arrives, the Defender rolls to determine from which long table edge (in their table half) it arrives.',
      ),
      DeploymentRule(
        title: 'Attacker — Immediate Reserves',
        description:
            'Attacker deploys up to 60% of their force in their own table half, '
            'at least 12"/30cm from the long table edges and 16"/40cm from the short centre line. '
            'Holds the rest in Immediate Reserve, arriving from their short table edge (roll from Turn 1 on 5+).',
      ),
      DeploymentRule(
        title: 'Infantry & Guns in Foxholes',
        description: 'All Infantry and Gun Teams start the game in Foxholes.',
      ),
    ],
    startingConditions: [
      'The Attacker has the first turn. As this is a Meeting Engagement, the Attacker shoots as if they moved, '
          'cannot use Artillery Bombardments, and has no Aircraft on their first turn.',
      'Attacker Immediate Reserves: roll from Turn 1 on 5+, arrive from Attacker\'s short table edge.',
      'Defender Scattered Delayed Reserves: roll from Turn 3 on 5+; roll to determine which long table edge Unit arrives from.',
    ],
    firstTurnRules: [
      'Meeting Engagement applies to the Attacker\'s first turn only.',
      'Attacker begins rolling for Immediate Reserves from Turn 1.',
      'Defender begins rolling for Scattered Delayed Reserves from Turn 3.',
    ],
    victoryConditions: [
      VictoryCondition(
        title: 'Attacker Holds an Objective (Turn 6+)',
        description:
            'Attacker wins if they end their turn on or after Turn 6 Holding an Objective '
            '(no Defending Tank, Infantry, or Gun teams within 4"/10cm of it).',
      ),
      VictoryCondition(
        title: 'Defender Repels the Attack (Turn 6+)',
        description:
            'Defender wins if they end their turn on or after Turn 6 having Repelled the Attack '
            '(no Attacking Tank, Infantry, or Gun teams within 8"/20cm of any Objective).',
      ),
    ],
    specialRules: [
      'Short edge orientation — Defender picks a short table edge.',
      'Defender deploys within 8"/20cm of EITHER long table edge (flanking positions, may split).',
      'Attacker deploys at least 12"/30cm from long edges AND 16"/40cm from short centre line.',
      'Objectives: at least 16"/40cm from long centre line AND long table edge.',
      'Attacker goes first — Meeting Engagement applies to Attacker\'s first turn.',
      'Attacker Immediate Reserves from Turn 1 on 5+ (own short edge).',
      'Defender Scattered Delayed Reserves from Turn 3 on 5+ (random long edge, in Defender\'s half).',
      'Victory conditions check from Turn 6 onwards.',
    ],
    hasReserves: true,
    reserveNote:
        'Attacker: max 60% on table. Immediate Reserves from Turn 1 on 5+, arrive from own short edge. '
        'Defender: max 60% on table. Scattered Delayed Reserves from Turn 3 on 5+.',
    turnLimit: 6,
  ),

  Mission(
    id: 'vanguard',
    name: 'Vanguard',
    type: MissionType.manoeuvre,
    tagline: 'Lead elements race to seize ground before the main forces arrive.',
    overview:
        'Diagonal quarter deployment. Forces are divided into three tiers: Scouting Force (up to 15%, on table), '
        'Vanguard Force (combined with Scouting up to 50%, arrives Turn 3), and Main Force (rest, arrives Turn 5). '
        'Victory is by Cumulative Victory Points — score 1 VP each turn you have Teams near an opponent\'s Objective. '
        'The game ends when a player reaches 8 VP or the combined total reaches 9.',
    attackerRole: 'Player 1',
    defenderRole: 'Player 2',
    objectiveSetup: [
      'Both players roll a die. The highest-scoring player is the Attacker. '
          'The Attacker picks a corner. The Defender picks a corner on the opposite short table edge. '
          'Deployment Area is a square 12"/30cm on a side in each player\'s corner.',
      'Both players, starting with the Attacker, place one Objective in their own table half, '
          'at least 16"/40cm from their Deployment Area, at least 4"/10cm from the short centre line, '
          'and at least 8"/20cm from all table edges.',
      'Both players, again starting with the Attacker, place one Objective in their opponent\'s table half '
          'with the same constraints.',
    ],
    deploymentRules: [
      DeploymentRule(
        title: 'Scouting Force (Both Players — On Table)',
        description:
            'Each player may deploy up to 15% of their agreed points total as their Scouting Force. '
            'This force may only include Battle Tank Units if there are only Battle Tank or Aircraft Units left in the rest of the force. '
            'Scouting Force is placed in their Deployment Area (12"/30cm corner square).',
      ),
      DeploymentRule(
        title: 'Vanguard Force (Both Players — Arrives Turn 3)',
        description:
            'Each player selects their Vanguard Force so that their Scouting Force and Vanguard Force combined '
            'are no more than 50% of their agreed points total. '
            'The Vanguard Force arrives from Reserve on Turn 3 (not rolled — automatic). '
            'Reserves move on from a table edge within 16"/40cm of the player\'s corner.',
      ),
      DeploymentRule(
        title: 'Main Force (Both Players — Arrives Turn 5)',
        description:
            'The rest of each player\'s force is their Main Force. '
            'The Main Force arrives from Reserve on Turn 5 (not rolled — automatic). '
            'Reserves move on from a table edge within 16"/40cm of the player\'s corner.',
      ),
      DeploymentRule(
        title: 'Infantry & Guns in Foxholes',
        description: 'All Infantry and Gun Teams start the game in Foxholes.',
      ),
    ],
    startingConditions: [
      'Both players roll — the highest scoring player has the first turn.',
      'Meeting Engagement applies to the first player\'s first turn.',
      'No Ranged In markers placed (Meeting Engagement).',
      'Vanguard Forces arrive automatically on each player\'s Turn 3 (no roll required).',
      'Main Forces arrive automatically on each player\'s Turn 5 (no roll required).',
      'Reserves enter within 16"/40cm of the player\'s corner at the start of their Movement Step.',
    ],
    firstTurnRules: [
      'Meeting Engagement applies to the first player\'s first turn only.',
      '— Aircraft cannot arrive; first player\'s Teams count as having moved; no Bombardments.',
    ],
    victoryConditions: [
      VictoryCondition(
        title: 'Cumulative Victory Points',
        description:
            'A player scores 1 Victory Point at the end of each of their turns for each Objective in the opponent\'s table half '
            'that has one or more of their Teams within 4"/10cm (ignore Gone to Ground, Dashing, Bailed Out, Aircraft, Transports, and Independent Teams). '
            'It does not matter if there are enemy Teams within 4"/10cm — you still score the VP. '
            'The game ends when a player reaches 8 VP, or when the combined total of both players\' VP reaches 9 or more. '
            'The player with the most VP wins. '
            'If a player has no Formation in Good Spirits (other than an Allied Formation), they lose; '
            'their opponent gains enough VP to bring the combined total to 9 (max 8 for the winner).',
      ),
    ],
    specialRules: [
      'Diagonal quarter deployment — Attacker and Defender take corners on opposite short table edges.',
      'Three-tier force structure: Scouting Force (≤15%, on table), Vanguard Force (combined ≤50%, arrives Turn 3), Main Force (rest, arrives Turn 5).',
      'Meeting Engagement for first player\'s first turn.',
      'Cumulative VP scoring: score 1 VP per Objective in opponent\'s half with your Team within 4"/10cm at end of each turn.',
      'Game ends when one player reaches 8 VP or combined total reaches 9+.',
    ],
    hasReserves: true,
    reserveNote:
        'Vanguard Force arrives Turn 3; Main Force arrives Turn 5. Both enter within 16"/40cm of player\'s corner.',
    turnLimit: 0,
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
