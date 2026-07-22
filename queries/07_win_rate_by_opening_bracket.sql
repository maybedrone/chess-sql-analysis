/*
BUSINESS QUESTION:
  How does each opening's win rate change across skill levels?

FINDINGS:
  • Sicilian Defense favors Black robustly — 59.4% at Intermediate
    over 192 games (large, trustworthy sample). The Black edge is real.
  • Beginners punish passive White play: Van't Kruijs loses 74% for
    White at Beginner (96 games). Offbeat = liability at low levels.
  • Some sharp White edges appear (Scandinavian: Mieses 62.7%, 142
    games) — well-sampled and worth trusting.

CAVEAT:
  • NO Expert rows survive the >=30 filter — the Expert bracket
    (1,807 games total) is too thin for any single opening to reach
    a reliable sample. Expert-level opening performance is not
    assessable with this dataset. (Chose rigor over forcing in
    low-sample rows.)
  • Reliable mainly for Intermediate/Advanced — thin Beginner/Expert
    brackets leave few openings above the 30-game floor.
  • Watch sample size: a 73% rate from 30 games (Russian: Damiano)
    is weaker evidence than 59% from 192 (Sicilian). Trust big N.
*/



SELECT
    CASE
        WHEN white_rating >= 2000 THEN 'Expert'
        WHEN white_rating >= 1600 THEN 'Advanced'
        WHEN white_rating >= 1200 THEN 'Intermediate'
        ELSE 'Beginner'
    END AS rating_bracket,
    opening_name,
    COUNT(*) AS total_games,
    ROUND(SUM(CASE WHEN winner = 'white' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1) AS white_win_pct,
    ROUND(SUM(CASE WHEN winner = 'black' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1) AS black_win_pct,
    ROUND(SUM(CASE WHEN winner = 'draw'  THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1) AS draw_pct
FROM games
GROUP BY rating_bracket, opening_name
HAVING COUNT(*) >= 30
ORDER BY MIN(white_rating), total_games DESC;