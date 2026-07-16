-- 04_farm_mortality_pct_fanout_fix.sql
-- Farm/house-level overall mortality percentage.
--
-- Fan-out fix: mortality is pre-aggregated to one row per GroupKeyID in the
-- TotalMort CTE *before* joining to Groups. Joining Mortality directly to
-- Groups would multiply HeadPlaced by the number of Mortality rows per
-- group (fan-out), inflating TotalHead. Aggregating first avoids that.
--
-- NULLIF guards the percentage calc against a divide-by-zero if a
-- farm/house ever has zero head placed.

WITH TotalMort AS (
	SELECT
		GroupKeyID,
		SUM(HeadMort) AS TotalMort
	FROM Mortality
	GROUP BY GroupKeyID
)

SELECT 
	g.FarmName,
	g.HouseID,
	SUM(g.HeadPlaced) AS TotalHead,
	SUM(t.TotalMort) AS OverAllMort,
	CAST(SUM(t.TotalMort) * 100.0 / NULLIF(SUM(g.HeadPlaced), 0) AS DECIMAL(10,2)) AS MortalityPct
FROM Groups AS g
JOIN TotalMort AS t 
	ON g.GroupKeyID = t.GroupKeyID
GROUP BY 
	g.FarmName,
	g.HouseID
