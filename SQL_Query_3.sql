-- ============================================================
-- Question 3: What other content watched those that streamed Loki?
-- ============================================================

-- Get all accounts that streamed Loki
WITH loki_viewers AS (
  SELECT DISTINCT account_id
  FROM table_a
  WHERE is_stream = 1
    AND watch_length_ms > 0
    AND UPPER(COALESCE(series_full_title, '')) = 'LOKI'
)
-- For those accounts, find all other content they watched
SELECT
  COALESCE(t_a.series_full_title, t_a.program_full_title) AS content_title,
  COUNT(DISTINCT t_a.account_id) AS viewers
FROM table_a AS t_a
JOIN loki_viewers AS lv USING (account_id)
WHERE t_a.is_stream = 1
  AND t_a.watch_length_ms > 0
  AND COALESCE(t_a.series_full_title, t_a.program_full_title) IS NOT NULL
  AND NOT (
    UPPER(COALESCE(t_a.series_full_title, '')) = 'LOKI'
    OR UPPER(COALESCE(t_a.program_full_title, '')) = 'LOKI'
  )
GROUP BY content_title
ORDER BY viewers DESC, content_title;

-- ============================================================
--  This variant: Include total hours streamed and stream count

WITH loki_viewers AS (
  SELECT DISTINCT account_id
  FROM table_a
  WHERE is_stream = 1
    AND watch_length_ms > 0
    AND UPPER(COALESCE(series_full_title, '')) = 'LOKI'
)
SELECT
  COALESCE(t_a.series_full_title, t_a.program_full_title) AS content_title,
  COUNT(DISTINCT t_a.account_id) AS viewers,
  ROUND(SUM(t_a.watch_length_ms) / 3600000.0, 2) AS hours_streamed,
  COUNT(*) AS streams_count
FROM TABLE_A AS t_a
JOIN loki_viewers AS lv USING (account_id)
WHERE t_a.is_stream = 1
  AND t_a.watch_length_ms > 0
  AND COALESCE(t_a.series_full_title, t_a.program_full_title) IS NOT NULL
  AND NOT (
    UPPER(COALESCE(t_a.series_full_title, '')) = 'LOKI'
    OR UPPER(COALESCE(t_a.program_full_title, '')) = 'LOKI'
  )
GROUP BY content_title
ORDER BY viewers DESC, hours_streamed DESC, content_title;
