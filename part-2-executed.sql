-- Project display name: dau dashboard for gaming
-- Project ID: dau-dashboard-design. Real source records are in gaming.sessions.
-- CSV columns: user_id INT64, session_start TIMESTAMP, session_end TIMESTAMP,
-- duration_seconds INT64, platform STRING, country STRING. Skip one header row.
-- Source: Open Play public dataset; Animal Crossing New Horizons subset.

CREATE OR REPLACE VIEW `dau-dashboard-design.gaming.daily_user_activity` AS
WITH daily_activity AS (
  SELECT DISTINCT
    activity_date,
    user_id,
    IF(country = 'UK', 'GB', country) AS country,
    platform
  FROM `dau-dashboard-design.gaming.sessions`,
  UNNEST(GENERATE_DATE_ARRAY(
    DATE(session_start),
    DATE(TIMESTAMP_SUB(session_end, INTERVAL 1 MICROSECOND))
  )) AS activity_date
  WHERE session_end > session_start
),
user_history AS (
  SELECT *,
    MIN(activity_date) OVER (PARTITION BY user_id) AS first_activity_date
  FROM daily_activity
)
SELECT *,
  activity_date = first_activity_date AS is_new_user,
  IF(activity_date = first_activity_date, user_id, NULL) AS new_user_id
FROM user_history;


-- Daily DAU
SELECT activity_date, COUNT(DISTINCT user_id) AS dau
FROM `dau-dashboard-design.gaming.daily_user_activity`
GROUP BY activity_date
ORDER BY activity_date;
