-- 查看当前所有的库及其兼容性模式
SELECT datname,  datcompatibility FROM pg_database;

-- 查看当前库的兼容性模式：
show sql_compatibility;

