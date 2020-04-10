SELECT pid,
       application_name,
       client_addr,
       now() - pg_stat_activity.query_start AS duration,
       query AS query
FROM pg_stat_activity
WHERE pg_stat_activity.query <> ''::text
  AND now() - pg_stat_activity.query_start > interval '5 minutes'
  AND pg_stat_activity.state <> 'idle'
ORDER BY now() - pg_stat_activity.query_start DESC;
