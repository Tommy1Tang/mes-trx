-- 修复 sys_role 表中 menu_check_strictly / dept_check_strictly 字段类型
-- 原因：MySQL tinyint(1) 迁移到 PostgreSQL 时被错误转为 smallint，应为 boolean
-- 执行环境：PostgreSQL

-- 1. 先去掉旧默认值（smallint 默认值无法自动转为 boolean）
ALTER TABLE sys_role ALTER COLUMN menu_check_strictly DROP DEFAULT;
ALTER TABLE sys_role ALTER COLUMN dept_check_strictly DROP DEFAULT;

-- 2. 转换字段类型
ALTER TABLE sys_role
ALTER COLUMN menu_check_strictly TYPE boolean
USING CASE
    WHEN menu_check_strictly IS NULL THEN NULL
    WHEN menu_check_strictly = 1 THEN true
    ELSE false
END;

ALTER TABLE sys_role
ALTER COLUMN dept_check_strictly TYPE boolean
USING CASE
    WHEN dept_check_strictly IS NULL THEN NULL
    WHEN dept_check_strictly = 1 THEN true
    ELSE false
END;

-- 3. 设置新的默认值
ALTER TABLE sys_role ALTER COLUMN menu_check_strictly SET DEFAULT true;
ALTER TABLE sys_role ALTER COLUMN dept_check_strictly SET DEFAULT true;

-- 3. 验证
SELECT column_name, data_type, column_default, is_nullable
FROM information_schema.columns
WHERE table_name = 'sys_role'
  AND column_name IN ('menu_check_strictly', 'dept_check_strictly');
