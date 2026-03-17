# Stats.rb Version 1.1.7a Processing:

## All sports
* Each player has a value ``unilu`` added where ``unilu`` is ``uni`` except for if ``uni`` is 0 or 00, ``unilu`` becomes 90 or 99, respectively.

## Basketball (default)
* Player data processing is based on ``personId``, team data is based on ``id``.  Duplicates will cause problems.  Missing personIds (often caused by players being added manually) are replaced with a random value (changes on each run) in order to maintain functionality.  
* Each player (``/bbgame/team/player``) has the following sorting orders added, based on their order in the team (highest to lowest, 0-indexed): 
  * ``tp_order`` based on ``tp`` (total points)
  * ``pf_order`` based on ``pf`` (personal fouls)
  * ``treb_order`` based on ``treb`` (total rebounds)
  * ``ast_order`` based on ``ast`` (assists)
  * ``to_order`` based on ``to`` (turnovers)
* Additionally, each player has the following sorting orders added based on their order amongst all players:
  * ``tp_tot_order`` based on ``tp`` (total points)
  * ``pf_tot_order`` based on ``pf`` (personal fouls)
  * ``treb_tot_order`` based on ``treb`` (total rebounds)
  * ``ast_tot_order`` based on ``ast`` (assists)
  * ``to_tot_order`` based on ``to`` (turnovers)
* Each team (``/bbgame/team``) has added the following 'combined' values:
  * ``fgraw`` is a combination of ``fgm-fga`` from ``totals/stats``
  * ``fg3raw`` is ``fgm3-fga3`` from ``totals/stats``
  * ``ftraw`` is ``ftm-fta`` from ``totals/stats``

## Soccer ('msoc' or 'wsoc')
* Player data processing is based on ``code``.  Duplicates will cause problems.  
* Each player (``/sogame/team/player``) has the following sorting orders added, based on their order in the team (highest to lowest, 0-indexed): 
  * ``g_order`` based on ``g`` (goals)
  * ``a_order`` based on ``a`` (assists)
* Additionally, each player has the following sorting orders added based on their order amongst all players:
  * ``g_tot_order`` based on ``g`` (goals)
  * ``a_tot_order`` based on ``a`` (assists)
* Each team (``/sogame/team``) has added the following summed linescore values (across periods):
  * ``corners`` (sum of each ``linescore/lineprd.corners``)
  * ``offsides`` (sum of each ``linescore/lineprd.offsides``)

## Lacrossse ('mlax' or 'wlax')
* Player data processing is based on ``code``, team data is based on ``id``.  Duplicates will cause problems.  
* Each player (``/lcgame/team/player``) has the following sorting orders added, based on their order in the team (highest to lowest, 0-indexed): 
  * ``g_order`` based on ``g`` (goals)
  * ``a_order`` based on ``a`` (assists)
  * ``gb_order`` based on ``gb`` (ground balls)
* Additionally, each player has the following sorting orders added based on their order amongst all players:
  * ``g_tot_order`` based on ``g`` (goals)
  * ``a_tot_order`` based on ``a`` (assists)
  * ``gb_tot_order`` based on ``gb`` (ground balls)
* Each team (``/lcgame/team``) has added the following summed values:
  * ``facetot`` (sum of ``facewon`` and ``facelost``)
* Each team (``/lcgame/team``) has added the following 'combined' values:
  * ``facewinratio`` is a combination of ``facewon/facetot`` from ``totals/misc``
  * ``ppratio`` is a combination of ``ppg-ppopp`` from ``totals/powerplay``

