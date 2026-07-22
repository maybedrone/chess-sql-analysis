/*
BUSINESS QUESTION:
  Which openings favor White vs Black?

FINDINGS:
  • Win rate swings ~40 pts by opening — from Black 71% (King's Pawn
    Game) to White 70% (Zukertort: QG Invitation).
  • Opening choice dwarfs the flat 49.9% color edge from Query 2 —
    the overall average hides enormous per-opening variation.
  • Sicilian variants consistently favor Black (54-58%); many passive
    defenses favor White despite being "Black" openings.

CAVEAT:
  • "King's Pawn Game" shows Black 71% — likely a labeling artifact:
    the generic 1.e4 bucket may capture games where White erred early
    and the game never got a specific opening name. Not a real signal
    that 1.e4 favors Black.
  • Variations are granular (50-370 games each); robust family-level
    trends need the ECO join (Query 6).
*/



-- openings that favored white
SELECT opening_name, 
    COUNT(*) AS total_games,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM games),2) AS total_games_pct,
    ROUND(SUM(CASE WHEN winner = 'white' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1) AS white_win_pct,
    ROUND(SUM(CASE WHEN winner = 'black' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1) AS black_win_pct,
    ROUND(SUM(CASE WHEN winner = 'draw'  THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1) AS draw_pct
FROM games
GROUP BY opening_name
HAVING COUNT(*) >= 50
ORDER BY white_win_pct DESC;


-- openings that favored black
SELECT opening_name, 
    COUNT(*) AS total_games,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM games),2) AS total_games_pct,
    ROUND(SUM(CASE WHEN winner = 'white' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1) AS white_win_pct,
    ROUND(SUM(CASE WHEN winner = 'black' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1) AS black_win_pct,
    ROUND(SUM(CASE WHEN winner = 'draw'  THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1) AS draw_pct
FROM games
GROUP BY opening_name
HAVING COUNT(*) >= 50
ORDER BY black_win_pct DESC;