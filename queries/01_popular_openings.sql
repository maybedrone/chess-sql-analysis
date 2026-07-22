/*
BUSINESS QUESTION:
  Which chess openings are played most often?

FINDINGS:
  • No single opening dominates — the most popular (Van't Kruijs, 368)
    is under 2% of 20,005 games.
  • Top 10 are mostly mainstream: Sicilian, French, Scotch, Scandinavian.
  • Openings are highly fragmented — players spread across a wide variety,
    which fits a casual/varied online player base.

CAVEAT:
  • opening_name is very granular — "Sicilian Defense" and
    "Sicilian: Bowdler Attack" count separately. True opening-FAMILY
    popularity needs grouping by ECO volume (see Query 6).
*/

--1a: Top 10 most popular openings
SELECT opening_name, COUNT(*) AS games_played
FROM games
GROUP BY opening_name
ORDER BY games_played DESC
LIMIT 10;


--1b: Top openings with more than 100 games played
SELECT opening_name, COUNT(*) AS games_played
FROM games
GROUP BY opening_name
HAVING COUNT(*) > 100
ORDER BY games_played DESC;