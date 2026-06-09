# SQL 脚本规范

- 默认的数据库是 MySQL。
- 渤海石油（hscp-bhsy-v2） 的数据库 是PostgreSQL 。

## 三套数据库对象

| 逻辑名 | 库/schema | 说明 | 关键表 |
|--------|-----------|------|--------|
| hscp 业务 | `hscp` | 业务主库 | `sea_pipe`、`offshore_oil`、`t_camera`、`t_sea_pipe_org` |
| 报警 | `hscp_alarm_db` | 报警/区域 | `t_area`、`t_area_group`、`t_area_share` |
| 机构 | `landtool` | 机构主数据 | `mscode_sys_org` |

跨对象访问一律写全限定名 `schema.table`（如 `hscp.offshore_oil`、`hscp_alarm_db.t_area`），不要用 `USE db`。

## 语法红线

- **禁用 MySQL 反引号** `` `col` ``。标识符用双引号 `"col"`，或在无歧义时不加引号。
- 用 `COALESCE` 而非 MySQL 的 `IFNULL`。
- 当前时间用 `CURRENT_TIMESTAMP`，不要用 `NOW()` 的 MySQL 特性写法。
- `UPDATE ... FROM ...` 多表更新用 PG 写法（见下例），不要用 MySQL 的 `UPDATE a JOIN b` 语法。
- 加列：`ALTER TABLE "schema"."tbl" ADD COLUMN "col" varchar(255) DEFAULT NULL;`
- 列注释单独写：`COMMENT ON COLUMN "schema"."tbl"."col" IS '说明';`（PG/金仓不支持 MySQL 的 `COMMENT '...'` 内联在列定义里）

## 幂等写法（重要）

DML 脚本应可重复执行。插入用 `ON CONFLICT`：

```sql
INSERT INTO "hscp_alarm_db"."t_area_group" ("group_id", "group_name", "status", "create_time", "group_type")
VALUES (2001, '平台区域', '1', CURRENT_TIMESTAMP, 'area')
ON CONFLICT ("group_id") DO UPDATE SET
    "group_name" = EXCLUDED."group_name",
    "status"     = EXCLUDED."status",
    "group_type" = EXCLUDED."group_type";
```

多表关联更新（PG 写法）：

```sql
-- 通过平台表的 around_area_id 关联区域，回填 org_id
UPDATE hscp_alarm_db.t_area a
SET org_id = o.org_id
FROM hscp.offshore_oil o
WHERE a.area_type = 1001
  AND o.around_area_id = a.area_id;
```

## 文件命名与存放

脚本放在 `doc/sql/` 下，按年份/日期分目录（如 `doc/sql-cnooc/2025/`）。

文件名格式：**`日期_库名_类型.sql`**

- `2025-09-09_hscp_dml.sql`
- `2025-08-27_hscp_alarm_db_ddl.sql`
- `2025-08-15_landtool_ddl.sql`

`类型` 为 `ddl`（结构变更）或 `dml`（数据变更）。一个脚本只针对一套库；涉及多套库就拆成多个文件。日期用脚本编写当天。

## 脚本内注释

脚本开头写一行说明（日期 + 用途），关键步骤用 `--` 注释，并对步骤编号。示例：

```sql
-- 2025-08-15 平台区域更新脚本
-- 1. 新增"平台区域"分组
INSERT INTO ... ON CONFLICT ...;

-- 2. 将以"附近区域"结尾的区域名改为"平台区域"
UPDATE "hscp_alarm_db"."t_area"
SET "area_name" = REPLACE("area_name", '附近区域', '平台区域')
WHERE "area_name" LIKE '%附近区域%';
```

## 写脚本前确认

- 操作哪套库（hscp / hscp_alarm_db / landtool）？DDL 还是 DML？
- 涉及的表结构是否已知？不确定就先查现有 DDL 脚本或问用户，不要凭空写列名。
- DML 是否需要幂等？批量 UPDATE 是否有足够的 WHERE 条件，避免误伤全表？
