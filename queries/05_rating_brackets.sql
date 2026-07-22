/*
BUSINESS QUESTION:
  How are players distributed across skill brackets?

FINDINGS:
  • Data concentrates in the middle: Intermediate (9,242) and
    Advanced (7,415) = ~83% of games.
  • Beginner (1,594) and Expert (1,807) are thin by comparison.

CAVEAT:
  • Per-opening slices within Beginner/Expert will be noisier —
    fewer games once subdivided. Treat extreme-bracket findings
    with more caution than the fat middle.
*/


SELECT
    case
        when white_rating >= 2000 then 'Expert'
        when white_rating >= 1600 then 'Advanced'
        when white_rating >= 1200 then 'Intermediate'
        else 'Beginner'
    end as rating_bracket,
    COUNT(*) games_played,
    SUM(COUNT(*)) OVER () AS total_games,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 1) AS pct_of_all
FROM
    games
GROUP BY
    rating_bracket
ORDER BY
    min(white_rating);