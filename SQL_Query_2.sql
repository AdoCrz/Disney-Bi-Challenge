-- ============================================================
-- Q2: How many accounts watched series in AR during the week Jun-28–Jul-04, 2021?
-- ============================================================

SELECT COUNT(DISTINCT account_id) AS accounts_who_watched_series
FROM TABLE_A
WHERE account_home_country = 'AR'
  AND is_stream = 1
  AND watch_length_ms > 0
  AND start_date_est >= DATE '2021-06-28'
  AND start_date_est <  DATE '2021-07-05'
  AND (program_type = 'episode' OR series_id IS NOT NULL);

-- This condition is added because program_type = 'episode' indicates series content; however, to prevent missing values, 
-- if a record also has a series_id, it means it belongs to a series.

-- ============================================================

-- This variation shows accounts in AR that watched series between  June 28 and July 4, 2021, with series and hours streamed


SELECT account_id, series_full_title,
  ROUND(SUM(watch_length_ms) / 3600000.0, 2) AS total_hours_streamed
FROM TABLE_A
WHERE account_home_country = 'AR'
  AND is_stream = 1
  AND watch_length_ms > 0
  AND start_date_est >= DATE '2021-06-28'
  AND start_date_est <  DATE '2021-07-05'
  AND (program_type = 'episode' OR series_id IS NOT NULL)
GROUP BY account_id, series_full_title
ORDER BY total_hours_streamed DESC;
