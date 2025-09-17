-- ============================================================
-- Question 4: 4. Considering paid accounts only, evaluate duplication, 
-- interseccion and exclusivity for Luca, Raya and the Last dragon, and Soul films.
-- ============================================================

WITH paid_streams AS (
  SELECT DISTINCT
         a.account_id,
         a.program_full_title
  FROM TABLE_A AS a
  JOIN TABLE_B AS b USING (account_id)
  WHERE a.is_stream = 1
    AND a.watch_length_ms > 0
    AND b.subscription_state = 'paid'
    AND UPPER(a.program_full_title) IN ('LUCA','RAYA AND THE LAST DRAGON','SOUL')
),
flags AS (
  SELECT
    account_id,
    MAX(CASE WHEN UPPER(program_full_title) = 'LUCA' THEN 1 ELSE 0 END) AS watched_luca,
    MAX(CASE WHEN UPPER(program_full_title) = 'RAYA AND THE LAST DRAGON' THEN 1 ELSE 0 END) AS watched_raya,
    MAX(CASE WHEN UPPER(program_full_title) = 'SOUL' THEN 1 ELSE 0 END) AS watched_soul
  FROM paid_streams
  GROUP BY account_id
)
-- Exclusivity (only that film)
SELECT
  SUM(CASE WHEN watched_luca = 1 AND watched_raya = 0 AND watched_soul = 0 THEN 1 ELSE 0 END) AS only_luca,
  SUM(CASE WHEN watched_luca = 0 AND watched_raya = 1 AND watched_soul = 0 THEN 1 ELSE 0 END) AS only_raya,
  SUM(CASE WHEN watched_luca = 0 AND watched_raya = 0 AND watched_soul = 1 THEN 1 ELSE 0 END) AS only_soul,

  -- Intersection: accounts who watched exactly two films
  
  SUM(CASE WHEN watched_luca + watched_raya + watched_soul = 2 THEN 1 ELSE 0 END) AS intersection_two,

  -- Intersection: accounts who watched all three films
  SUM(CASE WHEN watched_luca + watched_raya + watched_soul = 3 THEN 1 ELSE 0 END) AS intersection_three
FROM flags;
