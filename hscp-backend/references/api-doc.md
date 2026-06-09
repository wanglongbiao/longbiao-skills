# 独立 API 规范文档

为前端对接或 GJB 验收交付编写的《开放接口 API 规范》文档。这是**独立于代码**的接口说明，不是代码内 Javadoc。

## 文档来源：从代码反向生成

通常的流程是：读取目标 Controller → 提取每个接口的方法、路径、入参、返回类型 → 按下面的模板整理成表格。

提取要点：
- **请求方法 + 路径**：`@GetMapping`/`@PostMapping` + 类上的 `@RequestMapping`，拼成完整路径（如 `/fishingVessel/queryFishingVesselInfo`）。
- **入参**：`@RequestBody` 的 DTO（要展开 DTO 字段）或 `@RequestParam`（逐个列出）。展开 DTO 时需读取该 DTO 类的字段。
- **返回**：`R<T>` 中的 `T`，若是 `PageInfo<X>` 或 `List<X>` 要说明是分页/列表，并展开 X 的字段。
- **接口用途**：取方法上的 Javadoc 或方法名语义。

## 统一响应结构

所有接口都包在 `R<T>` 里，文档开头统一说明一次，后续接口只描述 `data` 部分：

```json
{
  "code": 200,
  "msg": "success",
  "data": {}
}
```

- `code`：200 成功，其它为失败
- `msg`：提示信息，成功为 "success"，失败为错误描述
- `data`：业务数据，类型见各接口

## 单个接口模板

每个接口按以下结构写：

---

### 渔船信息列表（分页）

| 项 | 内容 |
|----|------|
| 接口路径 | `/fishingVessel/queryFishingVesselInfo` |
| 请求方法 | POST |
| 请求格式 | application/json |
| 接口说明 | 按条件分页查询渔船信息 |

**请求参数**（Body，`ReqFishingVessel`）：

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| tenantCode | String | 是 | 租户编码 |
| pageNum | int | 否 | 页码，默认 1 |
| pageSize | int | 否 | 每页条数，默认 10 |
| ... | ... | ... | ... |

**响应数据**（`data` = `PageInfo<FishingVesselInfo>`）：

| 字段 | 类型 | 说明 |
|------|------|------|
| total | long | 总条数 |
| list | Array<FishingVesselInfo> | 渔船信息列表 |
| list[].id | String | 主键 |
| list[].mmsi | String | MMSI |
| ... | ... | ... |

**请求示例**：

```json
{
  "tenantCode": "90002",
  "pageNum": 1,
  "pageSize": 10
}
```

**响应示例**：

```json
{
  "code": 200,
  "msg": "success",
  "data": {
    "total": 1,
    "list": [
      { "id": "xxx", "mmsi": "412xxxxxx" }
    ]
  }
}
```

---

GET + `@RequestParam` 接口的"请求参数"改为 Query 参数表（字段 / 类型 / 必填 / 说明），其余结构相同。

## 文档组织

- 一个模块（或一组相关接口）一份文档，开头写：模块名、版本号、统一响应结构说明、鉴权说明（如需 token）。
- 接口按 Controller 分组，每组下列出各接口。
- 输出格式默认 **Markdown**。若用户需要交付 `.docx`（GJB 验收用），先产出 Markdown 再转换，或直接告知用户用 Markdown 内容贴入 Word 模板。
- 命名参照仓库 `doc/GJB/` 下的《...开放接口 API 规范.目标V1.1》风格：`<系统名>开放接口API规范.<子系统>V<版本>`。

## 写文档前确认

- 给哪个模块 / 哪些 Controller 出文档？
- 是否需要展开所有 DTO/VO 字段（字段多时确认范围）？
- 交付格式：Markdown 还是需要 Word（.docx）？版本号是多少？
- 是否包含鉴权说明、错误码表？
