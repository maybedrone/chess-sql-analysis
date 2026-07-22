/*
BUSINESS QUESTION:
  How do time controls affect popularity and win/draw patterns?

FINDINGS:
  • Rapid 10+0 dominates : 38.5% of all games. Players heavily
    prefer longer formats. blitz/bullet are minority here.
  • White's edge is consistent across every time control
    (~49-51% white vs ~44-47% black) : first-move advantage
    holds regardless of speed.
  • Draw rates rise with slower formats: 8+0 draws 5.8% vs
    faster 5+8 at 3.4%. More thinking time = more draws,
    matching real chess theory.

TECHNIQUE:
  • Grouped conditional aggregation + a scalar subquery for
    share-of-total, filtered with HAVING to cut low-volume noise.
*/


-- 3a: Which time controls are most popular?
SELECT increment_code, COUNT(*) AS games_played
FROM games
GROUP BY increment_code
ORDER BY games_played DESC
LIMIT 10;

-- 3b: Do win/draw rates differ by time control?
SELECT increment_code, 
    COUNT(*) AS total_games,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM games),2) AS total_games_pct,
    ROUND(SUM(CASE WHEN winner = 'white' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1) AS white_win_pct,
    ROUND(SUM(CASE WHEN winner = 'black' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1) AS black_win_pct,
    ROUND(SUM(CASE WHEN winner = 'draw'  THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1) AS draw_pct
FROM games
GROUP BY increment_code
HAVING COUNT(*) >= 500;