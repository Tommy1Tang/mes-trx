# MES 全局蓝图与路标 (API Routing)
## 1. 模块交叉依赖
```
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│   排产管理模块   │────▶│  生产订单模块   │────▶│  派工单管理模块   │
│ (Schedule)      │     │ (Order)         │     │ (Dispatch)      │
└─────────────────┘     └─────────────────┘     └─────────────────┘
          │                       │                       │
          ▼                       ▼                       ▼
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│  产能评估模块   │     │   物料管理模块   │     │  电子批记录模块   │
│ (Capacity)      │     │ (Material)      │     │ (BatchRecord)   │
└─────────────────┘     └─────────────────┘     └─────────────────┘
          │                       │                       │
          ▼                       ▼                       ▼
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│  现场报工模块   │     │  异常管理模块   │     │  SAP集成模块     │
│ (Reporting)     │     │ (Exception)     │     │ (SAPIntegration)│
└─────────────────┘     └─────────────────┘     └─────────────────┘
```

---
## 2. 前后端 API 握手寻址路标
**严禁在此处记录具体的 JSON 参数！仅提供前端探针的寻址方向。**

| 模块 | 后端服务路径 | 前端接口前缀 | Controller地址 |
|------|--------------|--------------|----------------|
| 排产管理 | `com.ruoyi.schedule.service.*` | `/prod-api/schedule/` | `SchedulePlanController`、`CapacityEvaluationController`、`ScheduleGanttController` |
| 生产订单 | `com.ruoyi.production.order.service.*` | `/prod-api/order/` | `ProOrderController`、`BatchGenerateController`、`SopAssociateController` |
| 物料管理 | `com.ruoyi.production.material.service.*` | `/prod-api/material/` | `MaterialPickingController`、`MaterialReturnController`、`MaterialValidationController`、`MaterialPostingController` |
| 派工单管理 | `com.ruoyi.production.dispatch.service.*` | `/prod-api/dispatch/` | `DispatchOrderController`、`DispatchTemplateController`、`DispatchStatusSyncController` |
| 现场报工 | `com.ruoyi.production.reporting.service.*` | `/prod-api/report/` | `WorkReportController`、`WorkHourController`、`ProcessActualController`、`MobileReportController` |
| 电子批记录 | `com.ruoyi.production.batchrecord.service.*` | `/prod-api/batch/` | `BatchRecordController`、`BatchTraceController`、`BatchComplianceController` |
| 异常管理 | `com.ruoyi.production.exception.service.*` | `/prod-api/exception/` | `ProductionExceptionController`、`ExceptionMonitorController`、`ExceptionKnowledgeBaseController` |
| SAP集成 | `com.ruoyi.integration.sap.service.*` | 内部调用不对外开放 | - |

---
## 3. 文档索引（所有Agent必须严格遵守渐进式加载规则）
### 3.1 命名规范
所有文档统一存放于`/docs`目录，文件名采用`[两位数字序号]_[大驼峰文件名].md`格式
### 3.2 文档列表（按需读取）
| 序号 | 文件名 | 内容说明 | 读取场景 |
|------|--------|----------|----------|
| 00 | 00_Blueprint.md | 全局架构、API路标、文档索引 | Agent启动必看，仅加载1次 |
| 00 | 00_Agent_Collaboration_Rules.md | Agent协作规则、角色分工、产出物规范 | 所有Agent工作前必须阅读 |
| 00 | 00_Requirement_Index.md | 项目需求总索引、需求ID规则、需求状态跟踪 | 需求分析、开发前需求确认时读取 |
| 01 | 01_Interface_Specification.md | 内部接口/第三方接口/移动端接口完整规范 | 接口开发、联调时读取 |
| 02 | 02_Project_Plan.md | 项目里程碑、开发计划、人员分工、测试上线方案 | 项目管理、排期、上线时读取 |
| 03 | 03_Database_Design.md | 数据库规范、核心表结构、SQL脚本规则 | 数据库开发、表结构设计时读取 |
| 04 | 04_System_Architecture.md | 技术栈选型、系统集成方案、合规性设计 | 架构设计、技术评审时读取 |

### 3.3 读取规则
- 首次加载仅读取`00_Blueprint.md`和`00_Agent_Collaboration_Rules.md`
- 后续工作根据场景按需读取对应子文档，禁止加载无关内容
- 新增文档必须先更新本索引，其他Agent才能识别读取
