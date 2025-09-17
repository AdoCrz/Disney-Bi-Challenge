-- ============================================================
-- Question 5: 5. Indicate  for those who streamed Avengers Infinity War,
-- how many days past since last stream and which was the last streamed content prior to Infinity War.
-- ============================================================

WITH infinity_war_watchers AS (
  SELECT
    account_id,
    start_date_est AS infinity_war_date
  FROM TABLE_A
  WHERE is_stream = 1 AND watch_length_ms > 0 AND UPPER(program_full_title) LIKE '%INFINITY WAR%'
),

-- If an account streamed Infinity War multiple times, keep only the first occurrence.
first_watch AS (
  SELECT account_id, infinity_war_date
  FROM (
    SELECT account_id, infinity_war_date,
      ROW_NUMBER() OVER (PARTITION BY account_id ORDER BY infinity_war_date) AS rn
    FROM infinity_war_watchers
  ) AS ranked
  WHERE rn = 1
),
-- Finding the last stream before Infinity War for each account
previous_stream AS (
  SELECT
    f.account_id,f.infinity_war_date,
    p.program_full_title AS last_title,
    p.start_date_est AS last_date
  FROM first_watch AS f
  LEFT JOIN LATERAL (
    SELECT
      t.program_full_title, t.start_date_est
    FROM TABLE_A AS t
    WHERE t.account_id = f.account_id
      AND t.is_stream = 1
      AND t.watch_length_ms > 0
      AND t.start_date_est < f.infinity_war_date
    ORDER BY t.start_date_est DESC
    LIMIT 1
  ) AS p ON TRUE
)
SELECT
  account_id, infinity_war_date, last_title, last_date,
  (infinity_war_date::date - last_date::date) AS days_since_last_stream
FROM previous_stream
ORDER BY infinity_war_date, account_id;
