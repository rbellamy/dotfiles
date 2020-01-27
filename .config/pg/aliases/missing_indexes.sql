SELECT relname,
       seq_scan-idx_scan AS too_much_seq,
       CASE
           WHEN seq_scan-idx_scan > 0 THEN 'Missing INDEX?'
           ELSE 'OK'
       END,
       pg_relation_size(relname::regclass) AS rel_size,
       seq_scan,
       idx_scan
FROM pg_stat_all_tables
WHERE schemaname='PUBLIC'
  AND pg_relation_size(relname::regclass) > 80000
ORDER BY too_much_seq DESC;