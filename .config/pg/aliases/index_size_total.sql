SELECT pg_size_pretty(sum(relpages*1024)) AS SIZE
FROM pg_class
WHERE reltype=0;