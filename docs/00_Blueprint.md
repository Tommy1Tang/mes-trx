# MES 全局蓝图与路标 (API Routing)
## 1. 项目定位

本项目为 IVD 试剂生产的受控制造执行平台，核心目标：

- 把 SAP/PLM 下发的计划、物料、BOM、工艺和质量要求转化为车间可执行、可防错、可追溯的 MBR/EBR
- 对配液、称量、孵育、灌装、冻干、包装、清洗、冷链、环境和公用工程过程形成电子证据链
- 通过规则联锁、电子签名、审计追踪、异常偏差、批记录审核满足 GMP、ISO 13485、21 CFR Part 11 等受控生产要求
- 通过 Outbox、幂等、死信、对账补偿保护车间执行，不让外部系统故障反向阻塞生产

一句话口径：MES 管"受控执行、现场防错、批记录证据、质量闭环和系统集成缓冲"，不替代 ERP、PLM、WMS、SCADA、QMS 的系统边界。

---

## 2. 模块交叉依赖（L0-L10 架构分层）

```
┌─────────────────────────────────────────────────────────────────────┐
│                    L0 运行时韧性与架构支撑层                          │
│  (Outbox / 幂等 / 死信 / 对账补偿 / MBR执行上下文)                    │
└──────────────────────────┬──────────────────────────────────────────┘
                           │ 贯穿所有层
┌──────────────────────────▼──────────────────────────────────────────┐
│  L1 主数据      L2 工艺MBR模板      L3 执行规则联锁    L10 仿真优化   │
│  ┌─────────┐    ┌─────────────┐    ┌──────────────┐   ┌──────────┐ │
│  │工厂/车间 │    │BOM/Routing  │    │防错/联锁/ECN │   │工艺仿真  │ │
│  │产线/工作 │    │MBR/Phase    │    │版本发布/差异 │   │产能瓶颈  │ │
│  │中心/物料 │    │Step/参数    │    │对比/Safe Hold│   │质量风险  │ │
│  │设备/人员 │    │质控/流转规则│    └──────┬───────┘   └──────────┘ │
│  │班次/仓库 │    └──────┬──────┘           │                        │
│  └────┬────┘           │                  │                        │
└───────┼────────────────┼──────────────────┼────────────────────────┘
        │                │                  │
┌───────▼────────────────▼──────────────────▼────────────────────────┐
│  L4 计划订单与车间调度层                                             │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐                │
│  │ 生产订单     │──│ 排产计划     │──│ 派工单       │                │
│  └──────┬──────┘  └─────────────┘  └──────┬──────┘                │
└─────────┼─────────────────────────────────┼────────────────────────┘
          │                                 │
┌─────────▼─────────────────────────────────▼────────────────────────┐
│  L5 现场执行、称量与电子批记录层                                      │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐│
│  │工序执行  │ │报工/投料 │ │称量记录  │ │清场检查  │ │EBR批记录 ││
│  └────┬─────┘ └──────────┘ └──────────┘ └──────────┘ └──────────┘│
└───────┼────────────────────────────────────────────────────────────┘
        │
┌───────▼────────────────────────────────────────────────────────────┐
│  L6 质量异常与合规审计层     L8 追溯仓储与批次族谱层                   │
│  ┌──────────────┐           ┌──────────────────┐                   │
│  │异常/不良/检验│           │批次/序列号/WIP   │                   │
│  │电子签名/审计 │           │成品/族谱/追溯    │                   │
│  └──────────────┘           └──────────────────┘                   │
└────────────────────────────────────────────────────────────────────┘
        │
┌───────▼────────────────────────────────────────────────────────────┐
│  L7 OT/SCADA、环境公用与清洗冷链层                                   │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐│
│  │SCADA系统 │ │采集点位  │ │环境监测  │ │冷链监控  │ │CIP/SIP   ││
│  │设备映射  │ │告警/OEE  │ │纯化水    │ │报警通知  │ │清洗放行  ││
│  └──────────┘ └──────────┘ └──────────┘ └──────────┘ └──────────┘│
└────────────────────────────────────────────────────────────────────┘
        │
┌───────▼────────────────────────────────────────────────────────────┐
│  L9 企业集成与接口运营层                                             │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐│
│  │SAP参考表 │ │SAP映射表 │ │接口消息  │ │报工回传  │ │投料过账  ││
│  │SAP系统   │ │PLM集成   │ │WMS集成   │ │检验回传  │ │OA/UDI    ││
│  └──────────┘ └──────────┘ └──────────┘ └──────────┘ └──────────┘│
└────────────────────────────────────────────────────────────────────┘
```

---

## 3. 前后端 API 握手寻址路标
**严禁在此处记录具体的 JSON 参数！仅提供前端探针的寻址方向。**

### 3.1 业务模块

| 模块 | 架构层 | 后端服务路径 | 前端接口前缀 | Controller地址 |
|------|--------|--------------|--------------|----------------|
| 主数据管理 | L1 | `com.ruoyi.production.master.service.*` | `/prod-api/master/` | `PlantController`、`WorkshopController`、`ProductionLineController`、`WorkCenterController`、`MaterialController`、`EquipmentController`、`PersonController`、`ShiftController`、`WarehouseController` |
| BOM管理 | L2 | `com.ruoyi.production.bom.service.*` | `/prod-api/bom/` | `BomHeaderController`、`BomItemController`、`BomSubstitutionController`、`BomCutoverController` |
| 工艺路线 | L2 | `com.ruoyi.production.routing.service.*` | `/prod-api/routing/` | `RoutingHeaderController`、`RoutingOperationController`、`OperationResourceController`、`OperationParameterController` |
| MBR模板 | L2 | `com.ruoyi.production.mbr.service.*` | `/prod-api/mbr/` | `MbrHeaderController`、`MbrVersionController`、`MbrPhaseController`、`MbrStepController`、`MbrStepParameterController`、`MbrStepMaterialController`、`MbrStepEquipmentController`、`MbrStepQualityController` |
| 执行规则与联锁 | L3 | `com.ruoyi.production.rule.service.*` | `/prod-api/rule/` | `ExecutionRuleController`、`InterlockRuleController`、`InterlockEventController`、`ErrorProofingController` |
| MBR变更控制 | L3 | `com.ruoyi.production.change.service.*` | `/prod-api/change/` | `MbrReleaseController`、`MbrChangeController`、`EcnOrderController`、`MbrVersionDiffController` |
| 生产订单 | L4 | `com.ruoyi.production.order.service.*` | `/prod-api/order/` | `ProductionOrderController`、`OrderComponentController`、`OrderOperationController` |
| 排产管理 | L4 | `com.ruoyi.production.schedule.service.*` | `/prod-api/schedule/` | `SchedulePlanController`、`ScheduleLogController` |
| 派工管理 | L4 | `com.ruoyi.production.dispatch.service.*` | `/prod-api/dispatch/` | `ShopFloorDispatchController` |
| 工序执行与报工 | L5 | `com.ruoyi.production.execution.service.*` | `/prod-api/execution/` | `OperationExecutionController`、`ProductionReportController`、`ReportLaborController`、`ReportEquipmentController`、`OperationTrackingController` |
| 投料与称量 | L5 | `com.ruoyi.production.weighing.service.*` | `/prod-api/weighing/` | `WeighingRecordController`、`ScaleDeviceCheckController`、`WeighingAuditLogController`、`OperationConsumptionController`、`OperationReturnController` |
| 电子批记录(EBR) | L5 | `com.ruoyi.production.ebr.service.*` | `/prod-api/ebr/` | `EbrHeaderController`、`EbrStepRecordController`、`EbrParamRecordController`、`BatchReviewController`、`LineClearanceController` |
| 过程监控 | L5 | `com.ruoyi.production.monitor.service.*` | `/prod-api/monitor/` | `ProcessMonitorSessionController`、`ProcessMonitorSummaryController` |
| 异常管理 | L6 | `com.ruoyi.production.exception.service.*` | `/prod-api/exception/` | `ExceptionRecordController`、`ExceptionCategoryController`、`ExceptionEscalationController` |
| 质量管理 | L6 | `com.ruoyi.production.quality.service.*` | `/prod-api/quality/` | `DefectCodeController`、`ProductionDefectController`、`InspectionResultController`、`NcHandlingController`、`InspectionPlanController`、`InspectionCharacteristicController` |
| 合规审计 | L6 | `com.ruoyi.production.compliance.service.*` | `/prod-api/compliance/` | `ESignatureController`、`AuditTrailController` |
| OT/SCADA集成 | L7 | `com.ruoyi.production.scada.service.*` | `/prod-api/scada/` | `ScadaSystemController`、`ScadaDeviceRefController`、`EquipmentScadaMapController`、`ScadaPointController`、`OperationDataCollectController`、`ScadaAlarmEventController` |
| 设备状态与OEE | L7 | `com.ruoyi.production.oee.service.*` | `/prod-api/oee/` | `EquipmentStateEventController`、`DowntimeReasonController`、`OeeSummaryController` |
| 环境监测 | L7 | `com.ruoyi.production.environment.service.*` | `/prod-api/environment/` | `EnvironmentAreaController`、`EnvironmentMonitorController`、`UtilitySystemController`、`WaterQualityController` |
| 冷链监控 | L7 | `com.ruoyi.production.coldchain.service.*` | `/prod-api/coldchain/` | `ColdChainMonitorController`、`ColdChainAlarmController` |
| 清洗灭菌 | L7 | `com.ruoyi.production.cleaning.service.*` | `/prod-api/cleaning/` | `CleaningCycleController`、`CleaningCycleParameterController`、`CleaningReleaseController` |
| 批次追溯 | L8 | `com.ruoyi.production.traceability.service.*` | `/prod-api/trace/` | `MaterialLotController`、`GoodsReceiptController`、`SerialNumberController`、`WipLotController`、`FinishedGoodLotController`、`LotGenealogyController`、`SerialGenealogyController` |
| SAP集成 | L9 | `com.ruoyi.production.integration.sap.service.*` | 内部调用不对外开放 | `SapSystemController`、`SapPlantRefController`、`SapMaterialRefController`、`SapBomRefController`、`SapRoutingRefController`、`SapProductionOrderRefController`、`SapMapController` |
| 接口运营 | L9 | `com.ruoyi.production.integration.operate.service.*` | `/prod-api/integration/` | `InterfaceMessageController`、`ReportConfirmationIfController`、`InspectionResultIfController`、`ConsumptionPostingIfController` |
| 运行时韧性 | L0 | `com.ruoyi.production.runtime.service.*` | 内部调用不对外开放 | `TransactionalOutboxController`、`IdempotencyController`、`DeadLetterController`、`IntegrationReconcileController`、`MbrExecutionContextController` |

### 3.2 外部系统集成对象

| 外部系统 | 集成层 | MES接口口径 |
|---------|--------|------------|
| SAP ERP | L9 | 接收生产订单/物料/BOM/Routing/工厂/库存批次参考数据；回传报工/投料/检验结果 |
| PLM | L9 | 接收受控配方/文件/ECN/版本/适用范围；转化为MES可执行MBR |
| WMS | L9 | 接收可投料批次/库位/发料结果；回传生产领用/退料/成品入库请求 |
| ThingsBoard/SCADA | L7 | 保存设备映射/点位模型/关键采集结论/告警事件/过程摘要 |
| QMS/eQMS | L6 | 记录现场异常/偏差来源/批记录证据；必要时推送QMS建立正式质量流程 |

---

## 4. 文档索引（所有Agent必须严格遵守渐进式加载规则）
### 4.1 命名规范
所有文档统一存放于`/docs`目录，文件名采用`[两位数字序号]_[大驼峰文件名].md`格式
### 4.2 文档列表（按需读取）
| 序号 | 文件名 | 内容说明 | 读取场景 |
|------|--------|----------|----------|
| 00 | 00_Blueprint.md | 全局架构、API路标、文档索引 | Agent启动必看，仅加载1次 |
| 00 | 00_Agent_Collaboration_Rules.md | Agent协作规则、角色分工、产出物规范 | 所有Agent工作前必须阅读 |
| 00 | 00_Requirement_Index.md | 项目需求总索引、需求ID规则、需求状态跟踪 | 需求分析、开发前需求确认时读取 |
| 00 | 00_Progress_Snapshot.md | 项目进度快照、已完成工作、下一步计划 | 项目状态同步时读取 |
| 00 | 00_Task_Kanban.md | 任务看板、Agent异步消息总线 | 任务领取、交接时读取 |
| 00 | 00_Data_Dictionary.csv | 业务概念字典（dict_code/长度/是否必填） | 数据库开发、字段设计时读取 |
| 01 | 01_Interface_Specification.md | 内部接口/第三方接口/移动端接口完整规范 | 接口开发、联调时读取 |
| 02 | 02_Project_Plan.md | 项目里程碑、开发计划、人员分工、测试上线方案 | 项目管理、排期、上线时读取 |
| 03 | 03_Database_Design.md | 数据库规范、核心表结构、SQL脚本规则 | 数据库开发、表结构设计时读取 |
| 04 | 04_System_Architecture.md | 技术栈选型、系统集成方案、合规性设计 | 架构设计、技术评审时读取 |
| 05 | 05_Change_Log.md | 数据模型变更记录 | 变更评审、追溯时读取 |
| - | IVD_MES整体开发口径.md | IVD MES定位、系统边界、L0-L10分层、工艺口径、合规口径、集成口径、一期范围 | **所有Agent启动时必看** |
| - | MES系统基础表清单_按优先级.md | 147张表L0-L10分层清单、P0~P0++++开发优先级明细 | 数据库开发、架构设计时读取 |
| - | MES系统基础表逐字段数据字典_按优先级_pgsql.csv | PostgreSQL逐字段数据字典（2411行，147张表） | 生成DDL、代码生成时读取 |
| 10 | 10_主数据管理模块需求文档.md | L1层需求：工厂/车间/产线/工作中心/物料/设备/人员/班次/仓库 | 主数据模块开发时读取 |
| 11 | 11_BOM与工艺路线模块需求文档.md | L2层前半需求：BOM/明细/替代/切换/工艺路线/工序/资源/参数/检验 | BOM/工艺模块开发时读取 |
| 12 | 12_MBR模板管理模块需求文档.md | L2层后半需求：MBR头/版本/阶段/步骤/参数/物料/设备/质控/流转/返工/Hold | **MBR核心模块开发时读取** |
| 13 | 13_执行规则与联锁模块需求文档.md | L3层需求：执行规则/联锁/防错/设备指令/MBR发布/变更/ECN/版本差异 | 执行规则模块开发时读取 |
| 14 | 14_生产订单与排产模块需求文档.md | L4层需求：工单/组件/工序实例/排产/派工 | 订单排产模块开发时读取 |
| 15 | 15_派工与现场执行模块需求文档.md | L4+L5层需求：派工/工序执行/报工/人工设备/过程监控 | 现场执行模块开发时读取 |
| 16 | 16_称量与投料模块需求文档.md | L5层需求：投料/退料/称量/天平点检/称量审计（**一期MVP重点**） | 称量投料模块开发时读取 |
| 17 | 17_电子批记录模块需求文档.md | L5层需求：EBR头/步骤记录/参数记录/清场/批审核/放行/归档/收率（**一期MVP重点**） | EBR模块开发时读取 |
| 18 | 18_异常管理与合规审计模块需求文档.md | L6层需求：异常/不良/检验/不合格品/电子签名/审计追踪 | 异常合规模块开发时读取 |
| 19 | 19_批次追溯模块需求文档.md | L8层需求：物料批次/收货/序列号/WIP/成品/族谱/正向追踪/反向召回 | 追溯模块开发时读取 |
| 20 | 20_系统集成模块需求文档.md | L9层需求：SAP/PLM/WMS/OA/UDI/QMS集成+接口运营 | 集成模块开发时读取 |
| 21 | 21_OT_SCADA集成模块需求文档.md | L7层需求：SCADA系统/设备映射/采集点位/告警/OEE/环境/冷链/CIP-SIP | OT集成模块开发时读取 |
| 22 | 22_订单关闭管理模块需求文档.md | L4+L5收尾需求：关闭前置校验/收率/差异分析/归档 | 订单关闭模块开发时读取 |

### 4.3 读取规则
- 首次加载仅读取`00_Blueprint.md`、`00_Agent_Collaboration_Rules.md`和`IVD_MES整体开发口径.md`
- 后续工作根据场景按需读取对应子文档，禁止加载无关内容
- 涉及数据库开发时，按L层加载对应的表清单和字段字典CSV，禁止一次加载全部147张表
- 新增文档必须先更新本索引，其他Agent才能识别读取

### 4.4 一期开发范围（MVP）

一期围绕"一个受控产品 + 一条典型产线 + 一个完整批记录闭环"建设最小合规闭环：

**一期包含：**
- 主数据：工厂、车间、产线、工作中心、人员、设备、物料、班次、仓库（L1）
- 工艺建模：BOM、Routing、MBR Header/Version/Phase/Step/Parameter/Material/Equipment/Quality（L2）
- 工单执行：生产订单、组件、工序实例、派工、工序执行、报工、投料（L4、L5）
- 配液称量：电子天平点检、称量记录、防错校验、称量审计（L5）
- EBR：批记录头、步骤记录、参数记录、批记录审核（L5）
- 合规：电子签名、审计追踪、异常记录（L6）
- 集成：SAP 订单/BOM/物料/工艺参考数据同步，报工/投料异步回传（L9）
- OT：ThingsBoard 设备映射、点位、关键采集值、告警事件、过程摘要（L7）
- 运行时：Outbox、幂等、死信、对账补偿、MBR 执行上下文（L0）

**一期暂缓：**
- 深度仿真优化（L10）
- 全量 OEE 高级分析
- 全厂冷链矩阵
- 全量 CIP/SIP 自动放行
- 完整委外工艺
- 多产品复杂替代工艺全覆盖
