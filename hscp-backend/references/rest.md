# REST 接口规范

HSCP 用 Spring Boot 3.3 + Spring MVC。升级到 Spring Boot 3 后**已弃用 Swagger 2 的 `@Api`/`@ApiOperation` 注解**（现有代码里这些注解都被注释掉了），接口说明改用 **Javadoc 注释**。

## Controller 骨架

```java
package cn.com.highlander.hscp.fishery.controller;

import cn.com.highlander.hscp.common.core.util.R;
import cn.com.highlander.hscp.fishery.entity.FishingVesselInfo;
import cn.com.highlander.hscp.fishery.service.FishingVesselInfoService;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/fishingVessel")
public class FishingVesselInfoController {

    @Autowired
    private FishingVesselInfoService fishingVesselInfoService;

    /**
     * 渔船信息列表（分页）
     *
     * @param reqFishingVessel 查询条件，含分页参数
     * @return 分页后的渔船信息
     */
    @PostMapping("/queryFishingVesselInfo")
    public R<PageInfo<FishingVesselInfo>> queryFishingVesselInfo(@RequestBody ReqFishingVessel reqFishingVessel) {
        PageInfo<FishingVesselInfo> pageInfo = fishingVesselInfoService.queryFishingVesselInfo(reqFishingVessel);
        return R.ok(pageInfo);
    }
}
```

## 硬性约定

1. **统一返回 `R<T>`**：`cn.com.highlander.hscp.common.core.util.R`
   - 有数据：`return R.ok(data);`
   - 无数据：`return R.ok();`
   - 错误通过抛 `BusinessException`（`cn.com.highlander.hscp.common.core.exception.BusinessException`）交全局异常处理，**不要**在 Controller 里手动拼错误码。

2. **类注解**：`@RestController` + `@RequestMapping("/资源名")`，路径用小驼峰资源名（如 `/fishingVessel`）。

3. **方法映射**：
   - 查询列表 / 复杂条件：`@PostMapping` + `@RequestBody`（条件多时用 DTO 接收）
   - 简单查询、删除：`@GetMapping` + `@RequestParam`
   - 新增：`@PostMapping("/add")`；编辑：`@PostMapping("/edit")`；删除：`@GetMapping("/del")`（参照现有命名习惯）

4. **分页**：用 PageHelper 的 `PageInfo<T>` 作为返回，**不是** MyBatis-Plus 的 `IPage`。

5. **接口说明用 Javadoc**：每个对外方法上写 Javadoc，说明用途、`@param`、`@return`。不要再加 `@Api`/`@ApiOperation`（已弃用）。

6. **依赖注入**：现有代码用字段 `@Autowired`，沿用即可，不要擅自改成构造器注入。

## 命名与分层

- **包**：`cn.com.highlander.hscp.[模块].controller`（个别模块前缀为 `cn.com.hlx.hscp.*`，改前看同模块）。
- **DTO**：请求参数对象放 `dto` 包，常以 `Req` 开头（如 `ReqFishingVessel`）。
- **VO**：返回视图对象放 `vo` 包，以 `Vo` 结尾（如 `FishingTypeStatisticsVo`）。
- **实体**：放 `entity` 包。
- **Controller 不写业务逻辑**，只做参数接收 + 调用 service + 包装返回。

## Feign 内部接口

服务间调用的 Controller 通常单独放 `controller/feignController/` 子包，类名以 `Feign` 开头（如 `FeignAlarmFollowController`）。新增内部接口按此惯例归类。

## 鉴权取用户信息

需要当前登录用户时，用 `AuthUtil`（hscp-common-core）：

- `AuthUtil.getUserId()` / `getUsername()` / `getUserOrgId()` / `getTenantCode()`
- `AuthUtil.getUserRoleCodeList()`

不要自己从 request 解析 token。

## 写接口前确认

- 放进哪个已有 Controller，还是新建？资源路径叫什么？
- 入参用 `@RequestParam` 还是 DTO（`@RequestBody`）？返回的数据结构是什么？
- 对外接口还是 Feign 内部接口？
