/*
BUSINESS QUESTION:
  Does White's first-move advantage show up in the data?

FINDINGS:
  • Yes — White wins 49.9% vs Black's 45.4%, a ~4.5 pt edge.
    First-move advantage is real but modest at this level.
  • Draws are rare (4.7%) — far below elite play (50%+).
    Confirms a casual/amateur player base where games stay decisive.

TECHNIQUE:
  • Conditional aggregation: SUM(CASE WHEN...) counts each outcome
    as a subset of the same rows in one pass — no JOIN, no GROUP BY.
*/


SELECT
    COUNT(*) AS total_games,
    ROUND(SUM(CASE WHEN winner = 'white' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1) AS white_win_pct,
    ROUND(SUM(CASE WHEN winner = 'black' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1) AS black_win_pct,
    ROUND(SUM(CASE WHEN winner = 'draw'  THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1) AS draw_pct
FROM games;