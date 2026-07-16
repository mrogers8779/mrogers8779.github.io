-- 02_cumulative_mortality.sql
-- Running total of daily mortality per group, using a window function
-- (SUM ... OVER PARTITION BY ... ORDER BY) instead of a self-join or subquery.
-- Filtered to a single house for spot-checking the logic before scaling out.

SELECT	g.FarmName,
		m.HouseID,
		m.MortDate,
		m.HeadMort,
		SUM(m.HeadMort) OVER (PARTITION BY g.GroupKeyID ORDER BY m.MortDate) AS CumulativeMort
FROM Groups AS g
JOIN Mortality AS m
	ON g.GroupKeyID = m.GroupKeyID
WHERE m.HouseID = 'H022'
