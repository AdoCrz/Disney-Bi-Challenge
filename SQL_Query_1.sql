

WITH streams_june AS (
  SELECT account_id,
         watch_length_ms
  FROM table_a
  WHERE is_stream = 1
    AND start_date_est >= DATE '2021-06-01'
    AND start_date_est <  DATE '2021-07-01'
    AND watch_length_ms IS NOT NULL
    AND watch_length_ms > 0
)
SELECT
  COUNT(DISTINCT account_id) AS unique_accounts,
  ROUND(SUM(watch_length_ms) / 3600000.0, 2)AS total_hours_streamed,
  ROUND((SUM(watch_length_ms) / 3600000.0)/ NULLIF(COUNT(DISTINCT account_id), 0), 2)AS avg_hours_per_account
FROM streams_june;
