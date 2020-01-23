SELECT ''INDEX hit rate'' AS name,
                       (sum(idx_blks_hit)) / sum(idx_blks_hit + idx_blks_read) AS ratio
FROM pg_statio_user_indexes
UNION ALL
SELECT ''CACHE hit rate'' AS name,
                       sum(heap_blks_hit) / (sum(heap_blks_hit) + sum(heap_blks_read)) AS ratio
FROM pg_statio_user_tables;

'
\set index_size '
SELECT relname AS name,
       pg_size_pretty(sum(relpages*1024)) AS SIZE
FROM pg_class
WHERE reltype=0
GROUP BY relname
ORDER BY sum(relpages) DESC;

'
\set index_usage '
SELECT relname,
       CASE idx_scan
           WHEN 0 THEN ''Insufficient DATA''
           ELSE (100 * idx_scan / (seq_scan + idx_scan))::text
       END percent_of_times_index_used,
       n_live_tup rows_in_table
FROM pg_stat_user_tables
ORDER BY n_live_tup DESC;
