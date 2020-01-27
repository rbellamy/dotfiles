SELECT pid,
       application_name AS SOURCE,
       age(now(), query_start) AS running_for,
       wait_event_type,
       client_hostname,
       client_addr,
       query AS query
FROM pg_stat_activity
WHERE query <> '<insufficient privilege>'
  AND state <> 'idle'
  AND pid <> pg_backend_pid()
ORDER BY 3 DESC;