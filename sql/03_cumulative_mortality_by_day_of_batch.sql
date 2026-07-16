-- 03_cumulative_mortality_by_day_of_batch.sql
-- Builds on the cumulative mortality window function by adding DATEDIFF to
-- normalize each mortality event to "day of batch" (days since placement).
-- This makes mortality curves comparable across groups that started on
-- different placement dates.

SELECT	g.GroupKeyID,
		g.FarmName,
		m.HouseID,
		m.MortDate,
		m.HeadMort,
		DATEDIFF(day, g.PlacementDate, m.MortDate) AS DayOfBatch,
		SUM(m.HeadMort) OVER (PARTITION BY g.GroupKeyID ORDER BY m.MortDate) AS CumulativeMort
FROM Groups AS g
JOIN Mortality AS m
	ON g.GroupKeyID = m.GroupKeyID
WHERE m.HouseID = 'H003'
