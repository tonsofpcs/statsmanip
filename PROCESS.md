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

## Baseball and Softball ('baseball' or 'softball')
* Player data processing is based on ``name``, team data is based on ``name``.  Duplicates will cause problems.  
* Each player (``/bsgame/team/player``) has the following sorting orders added, based on their order in the team (highest to lowest, 0-indexed): 
  * ``s_h_order`` based on ``hitseason.h`` (season hits)
  * ``s_r_order`` based on ``hitseason.r`` (season runs)
  * ``s_rbi_order`` based on ``hitseason.rbi`` (season RBI)
  * ``s_so_order`` based on ``pchseason.so`` (season strikeouts)
  * ``s_era_order`` based on ``pchseason.rbi`` (season ERA)
* Additionally, each player has the following sorting orders added based on their order amongst all players:
  * ``s_h_tot_order`` based on ``hitseason.h`` (season hits)
  * ``s_r_tot_order`` based on ``hitseason.r`` (season runs)
  * ``s_rbi_tot_order`` based on ``hitseason.rbi`` (season RBI)
  * ``s_so_tot_order`` based on ``pchseason.so`` (season strikeouts)
  * ``s_era_tot_order`` based on ``pchseason.rbi`` (season ERA)
* Each player has added the following summed values:
  * ``pa`` (sum of ``ab``, ``bb``, and ``hbp`` in ``hitseason``)
  * ``obp_numerator`` (sum of ``h``, ``bb``, and ``hbp`` in ``hitseason``)
  * ``whip_numerator`` (sum of ``h``, ``bb``, and ``hbp`` in ``pchseason``)
* Each player has added the following calculated values:
  * ``obp`` in ``hitseason`` is ``obp_numerator`` divided by ``pa``
  * ``whip`` in ``pchseason`` is ``whip_numerator`` divided by ``ip``
* The root (``/bsgame``) has the following data added for the current pitchers (initial ``h`` is for home, replace with ``v`` for visitor):
  * ``hpitcher`` from ``name``
  * ``hpitceruni`` from ``uni``
  * ``hera`` from ``pchseason/era``
  * ``hvsl`` from ``pchseason/vsleft``
  * ``hvsr`` from ``pchseason/vsright``
  * ``hwin`` from ``pchseason/winn``
  * ``hloss`` from ``pchseason/loss``
  * ``hbb`` from ``pitching/bb``
  * ``hso`` from ``pitching/so``
  * ``hpitches`` from ``pitching/pitches``
  * ``hip`` from ``pitching/ip``
  * ``hh`` from ``pitching/h``
  * ``her`` from ``pitching/er``
* Each team (``/bsgame/team``) has added the following 'combined' values:
  * ``hab`` is a combination of ``h-ab`` from ``hitting``
