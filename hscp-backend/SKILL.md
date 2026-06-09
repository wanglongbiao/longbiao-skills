---
name: hscp-backend
description: HSCP 系列后端 Java 项目（项目名含 hscp）的开发规范助手，覆盖 SQL 脚本、REST 接口、独立 API 文档三类工作。当用户在 hscp 项目中编写/修改 SQL 脚本（DDL/DML）、新增或改动 REST Controller 接口、或编写独立的接口 API 规范文档时使用；用户也可通过 /hscp-backend 手动调用。
---

# HSCP 后端开发规范

为 HSCP（Highlander Spring Cloud Project，项目名一般含 `hscp`）系列后端 Java 项目提供统一的编码与文档规范。Spring Boot 3.3 + MyBatis Plus + SA-Token，数据库以 **PostgreSQL / 人大金仓 KingbaseES** 为主。

## 何时使用

满足以下任一情况时启用本技能：

- **写 SQL 脚本**：新增/修改建表（DDL）、数据变更（DML）、迁移脚本 → 见 `references/sql.md`
- **写 / 改 REST 接口**：新增 Controller、增删改查接口、Feign 接口 → 见 `references/rest.md`
- **写独立 API 文档**：给前端或验收用的《开放接口 API 规范》文档 → 见 `references/api-doc.md`

按工作类型读取对应的 reference 文件，不要一次性全读。一个需求常跨多类（建表 → 写接口 → 出文档），按顺序处理即可。

## 跨领域通用约定（必须遵守）

这些约定适用于所有三类工作，**优先级高于任何习惯写法**：

1. **包结构**：`cn.com.highlander.hscp.[模块].[层级]`，层级为 `controller / service / mapper / entity / dto / vo / config / constant / util`。注意个别模块用 `cn.com.hlx.hscp.*`（如 cctv-base、doris-base、system-log），改动前先看同模块现有类的包名。

2. **数据库默认 PostgreSQL / 金仓**，不是 MySQL：
   - 标识符用**双引号**或不加引号，**禁用 MySQL 反引号** `` ` ``
   - 跨对象访问写 `schema.table`（如 `hscp.t_camera`），禁用 `USE db`
   - 三套对象：`hscp`(业务) / `hscp_alarm_db`(报警) / `landtool`(机构)；MySQL 环境下是三个 database，PG/金仓下是同一实例的三个 schema

3. **统一返回**：接口一律返回 `R<T>`（`cn.com.highlander.hscp.common.core.util.R`），成功用 `R.ok(data)`，无数据用 `R.ok()`。

4. **始终用中文**回复和写注释。改动遵循最小化原则：只动需求涉及的部分，不顺手"优化"无关代码。

## 工作前先对齐

动手前确认（信息不足时直接问，不要假设）：

- **目标模块**：改哪个 `hscp-xxx` 模块？是 `-api`（接口/DTO）还是 `-server`（实现）？
- **SQL 作用对象**：脚本操作哪套库/schema（hscp / hscp_alarm_db / landtool）？是 DDL 还是 DML？
- **接口归属**：新接口放进哪个已有 Controller，还是新建？对外接口还是 Feign 内部接口？

参考文件按需读取：

| 工作类型 | 读取 |
|---------|------|
| SQL 脚本（DDL/DML/迁移） | `references/sql.md` |
| REST 接口 / Controller | `references/rest.md` |
| 独立 API 规范文档 | `references/api-doc.md` |
