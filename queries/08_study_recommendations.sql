/*
BUSINESS QUESTION:
  For a player at a given skill level, which openings win most —
  ranked within each bracket, among openings played enough to trust?

TECHNIQUE:
  • Two CTEs: compute per-bracket-opening win rates (>=30 games),
    then DENSE_RANK() partitioned by bracket, ordered by white_win_pct.
  • Window function can't go in WHERE, so the rank is computed in a
    CTE and filtered (white_rank <= 5) in the outer query.

FINDINGS:
  • Opening choice matters MORE as skill rises. At Advanced, clear
    high-win-rate openings emerge with solid samples — Philidor
    Defense #3 (White 76.1%, 67 games) and Queen's Pawn (75.4%) top
    the list. Here opening choice genuinely drives results.
  • At Beginner, even White's top-5 openings all win under 40% — but
    this is NOT about openings (see the major caveat below).
  • Intermediate #1 (Russian: Damiano, 73.3%) sits right at the
    30-game floor — suggestive, but thinner evidence than Advanced.

CAVEAT — MAJOR (this is a finding in itself):
  • Brackets are defined by WHITE's rating only, which confounds skill
    with matchmaking. In "beginner" games (White <1200), Black averages
    1296 vs White's 1093 — a ~200-point disadvantage for White. That
    opponent gap, not opening choice, drives White's low win rate at
    this level. "Beginner bracket" means "White is a beginner," NOT
    "a beginner-level game." A cleaner definition would bracket on both
    players (average rating, or both in the same band). Verified by
    comparing AVG(white_rating) vs AVG(black_rating) per bracket.

CAVEAT — sample size:
  • Ranks only openings with >=30 games per bracket — small-sample
    flukes excluded by design (100% from 3 games is not a signal).
  • No Expert rows: the Expert bracket (1,807 games total) is too thin
    for any single opening to reach the 30-game floor. Study
    recommendations are reliable only for Beginner/Intermediate/Advanced.

CAVEAT — reading direction:
  • Ranking is by WHITE's win rate. For Black defenses, a high
    white_win_pct means that defense is FAILING at that level; read
    black_win_pct for openings you'd play as Black.
================================================================
*/

WITH opening_stats AS (
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
        ROUND(SUM(CASE WHEN winner = 'black' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1) AS black_win_pct
    FROM games
    GROUP BY rating_bracket, opening_name
    HAVING COUNT(*) >= 30
),
ranked AS (
    SELECT
        *,
        DENSE_RANK() OVER (PARTITION BY rating_bracket ORDER BY white_win_pct DESC) AS white_rank
    FROM opening_stats
)
SELECT
    rating_bracket,
    opening_name,
    total_games,
    white_win_pct,
    black_win_pct,
    white_rank
FROM ranked
WHERE white_rank <= 5
ORDER BY
    CASE rating_bracket
        WHEN 'Beginner'     THEN 1
        WHEN 'Intermediate' THEN 2
        WHEN 'Advanced'     THEN 3
    END,
    white_rank;