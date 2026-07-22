/*
BUSINESS QUESTION:
  Do players at different skill levels prefer different openings?

FINDINGS:
  • Opening choice is a fingerprint of skill. Van't Kruijs: 96 beginner
    games vs just 2 expert — offbeat openings are a beginner marker.
  • Scandinavian Defense skews low (58 beginner / 3 expert); simple,
    direct defenses fade as players improve.
  • "Studied" defenses skew higher — Caro-Kann has 73 advanced games
    but only 10 beginner: you learn it, you don't stumble into it.

CAVEAT:
  • Filtered to openings with >=100 total games (40 rows; full data
    has 1477, mostly noise).
  • Intermediate/Advanced columns run largest partly because those
    brackets hold the most games overall (see Q5). Extremes (e.g.
    Van't Kruijs 2 vs 96) show the pattern most clearly.
*/



SELECT 
    opening_name,
    COUNT(CASE WHEN white_rating >= 2000 THEN 1 END) AS expert_games,
    COUNT(CASE WHEN white_rating >= 1600 AND white_rating < 2000 THEN 1 END) AS advanced_games,
    COUNT(CASE WHEN white_rating >= 1200 AND white_rating < 1600 THEN 1 END) AS intermediate_games,
    COUNT(CASE WHEN white_rating < 1200 THEN 1 END) AS beginner_games,
    COUNT(*) AS total_games
FROM games
GROUP BY opening_name
HAVING COUNT(*) >= 100
ORDER BY total_games DESC;