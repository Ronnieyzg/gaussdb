-- 查找索引属于哪张表：
SELECT
  n.nspname     AS schema_name,
  t.relname     AS table_name,
  i.relname     AS index_name,
  a.attname     AS column_name
FROM
  pg_class i
  JOIN pg_index ix     ON i.oid = ix.indexrelid
  JOIN pg_class t      ON ix.indrelid = t.oid
  JOIN pg_namespace n  ON t.relnamespace = n.oid
  JOIN pg_attribute a  ON a.attrelid = t.oid AND a.attnum = ANY(ix.indkey)
WHERE
  i.relkind = 'i'
  AND i.relname = 'page_name_idx';
