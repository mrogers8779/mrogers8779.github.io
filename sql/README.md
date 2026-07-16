# Swine Mortality Analysis — SQL

Full SQL scripts behind the [swine production mortality portfolio project](https://mrogers8779.github.io) (Power BI dashboard + writeup on the main site). All queries run against a synthetic dataset of 297 production groups (~11,750 rows) across 10 farms, in SQL Server via SSMS.

## Scripts

| File | Purpose |
|---|---|
| `01_data_preview.sql` | Initial preview of the `Groups` and `Mortality` tables to confirm schema/connection. |
| `02_cumulative_mortality.sql` | Running total of daily mortality per group using a window function (`SUM() OVER (PARTITION BY ... ORDER BY ...)`), spot-checked on a single house. |
| `03_cumulative_mortality_by_day_of_batch.sql` | Extends the cumulative mortality query with `DATEDIFF` to normalize each event to "day of batch," making mortality curves comparable across groups placed on different dates. |
| `04_farm_mortality_pct_fanout_fix.sql` | Farm/house-level overall mortality percentage. Aggregates mortality in a CTE *before* joining to `Groups` to avoid a fan-out bug that would otherwise inflate total head count, plus a `NULLIF` guard against divide-by-zero. |

## Fan-out bug, briefly

Joining `Mortality` directly to `Groups` and summing `HeadPlaced` produces one row per mortality event per group — so `HeadPlaced` gets counted once for every mortality row instead of once per group, silently inflating `TotalHead`. The fix (`04_farm_mortality_pct_fanout_fix.sql`) pre-aggregates mortality to one row per `GroupKeyID` in a CTE first, so the join to `Groups` is 1:1 and the totals are accurate.

## Related

- Live dashboard & writeup: [mrogers8779.github.io](https://mrogers8779.github.io)
- Built in SSMS against SQL Server Express, visualized in Power BI Desktop
