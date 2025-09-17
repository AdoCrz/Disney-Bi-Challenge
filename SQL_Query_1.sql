-- ============================================================
-- Question 1: How many unique accounts streamed in June 2021, 
-- how many total hours were streamed, and the average of hours 
-- streamed per account?
-- ============================================================

-- The first query provides a high-level overview:
-- number of unique accounts, total hours streamed, 
-- and the average of hours per account in June 2021.

WITH streams_june AS (
  SELECT account_id,
         watch_length_ms
  FROM TABLE_A
  WHERE is_stream = 1
    AND start_date_est >= DATE '2021-06-01'
    AND start_date_est <  DATE '2021-07-01'
    AND watch_length_ms IS NOT NULL
    AND watch_length_ms > 0
) 
SELECT
  COUNT(DISTINCT account_id) AS unique_accounts,
  ROUND(SUM(watch_length_ms) / 3600000.0, 2) AS total_hours_streamed,
  ROUND((SUM(watch_length_ms) / 3600000.0)/ NULLIF(COUNT(DISTINCT account_id), 0), 2)AS avg_hours_per_account
FROM streams_june;

-- ============================================================
-- Unlike the first query, this version adds a country breakdown,
-- which makes the analysis more valuable for comparing streaming behavior across different markets.

WITH streams_june AS (
  SELECT account_id,
         account_home_country,
         watch_length_ms
  FROM TABLE_A
  WHERE is_stream = 1
    AND start_date_est >= DATE '2021-06-01'
    AND start_date_est <  DATE '2021-07-01'
    AND watch_length_ms IS NOT NULL
    AND watch_length_ms > 0
)
SELECT
  account_home_country,
  COUNT(DISTINCT account_id) AS unique_accounts,
  ROUND(SUM(watch_length_ms) / 3600000.0, 2) AS total_hours_streamed,
  ROUND((SUM(watch_length_ms) / 3600000.0) / NULLIF(COUNT(DISTINCT account_id), 0), 2) AS avg_hours_per_account
FROM streams_june
GROUP BY account_home_country
ORDER BY total_hours_streamed DESC;

-- ============================================================
-- Finally, this variation shows the most detailed level of analysis.
-- It breaks down activity by account within each country, which is useful to identify heavy users in specific regions.

WITH streams_june AS (
  SELECT account_id,
         account_home_country,
         watch_length_ms
  FROM TABLE_A
  WHERE is_stream = 1
    AND start_date_est >= DATE '2021-06-01'
    AND start_date_est <  DATE '2021-07-01'
    AND watch_length_ms IS NOT NULL
    AND watch_length_ms > 0
)
SELECT
  account_home_country,
  account_id,
  ROUND(SUM(watch_length_ms) / 3600000.0, 2) AS total_hours_streamed,
  COUNT(*) AS streams_count
FROM streams_june
GROUP BY account_home_country, account_id
ORDER BY account_home_country, total_hours_streamed DESC;



