-- Daily unique active players for the time-series chart.
SELECT activity_date, COUNT(DISTINCT user_id) AS dau
FROM `dau-dashboard-design.gaming.daily_user_activity`
GROUP BY activity_date
ORDER BY activity_date;

-- Platform comparison: edit dates, add country = 'US' or platform = 'Windows' to filter.
SELECT platform,
 COUNT(DISTINCT user_id) AS active_users,
 COUNT(*) / COUNT(DISTINCT activity_date) AS avg_dau,
 COUNT(DISTINCT new_user_id) AS new_users,
 COUNT(DISTINCT IF(NOT is_new_user, user_id, NULL)) AS returning_users
FROM `dau-dashboard-design.gaming.daily_user_activity`
WHERE activity_date BETWEEN '2025-04-02' AND '2025-08-31'
GROUP BY platform
ORDER BY platform;