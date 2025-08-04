WITH ordered_events AS (
  SELECT
    userid,
    event_type,
    event_time,
    LAG(event_time) OVER (PARTITION BY userid ORDER BY event_time) AS prev_event_time
  FROM
    events
),
session_flags AS (
  SELECT
    userid,
    event_type,
    event_time,
    -- Flag as new session if previous event is NULL or gap > 30 mins
    CASE 
      WHEN prev_event_time IS NULL 
        OR TIMESTAMPDIFF(MINUTE, prev_event_time, event_time) > 30 
      THEN 1 ELSE 0 END AS is_new_session
  FROM ordered_events
),
session_groups AS (
  SELECT
    userid,
    event_type,
    event_time,
    -- Session id increases with each new session (cumulative sum)
    SUM(is_new_session) OVER (PARTITION BY userid ORDER BY event_time) AS session_id
  FROM session_flags
)
SELECT
  userid,
  session_id,
  MIN(event_time) AS session_start_time,
  MAX(event_time) AS session_end_time,
  TIMESTAMPDIFF(MINUTE, MIN(event_time), MAX(event_time)) AS session_duration,
  COUNT(*) AS event_count
FROM session_groups
GROUP BY
  userid,
  session_id
ORDER BY
  userid,
  session_id;
