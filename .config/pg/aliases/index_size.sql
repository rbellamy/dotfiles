SELECT relname AS name,
       pg_size_pretty(sum(relpages*1024)) AS SIZE
FROM pg_class
WHERE reltype=0
GROUP BY relname
ORDER BY sum(relpages) DESC;