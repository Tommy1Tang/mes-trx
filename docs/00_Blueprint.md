# MES 全局蓝图与路标 (API Routing)
## 1. 项目定位

本项目为 IVD 试剂生产的受控制造执行平台，核心目标：

- 把 SAP/PLM/文控系统下发的计划、物料、BOM、工艺、文件和质量要求转化为车间可执行、可防错、可追溯的 MBR/EBR/DHR
- 对配液、称量、线边仓、领退料、孵育、灌装、冻干、包装、清洗、冷链、环境和公用工程过程形成电子证据链
- 通过规则联锁、电子签名、审计追踪、异常偏差、批记录审核满足 GMP、ISO 13485、21 CFR Part 11 等受控生产要求
- 通过 Outbox、幂等、死信、对账补偿保护车间执行，不让外部系统故障反向阻塞生产

一句话口径：MES 管"受控执行、现场防错、线边仓执行、批记录证据、质量闭环和系统集成缓冲"，不替代 ERP、PLM/文控、WMS、SCADA、QMS、SAP PM、培训系统的系统边界。

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
│  │工序执行  │ │报工/投料 │ │称量/线边仓│ │电子表单  │ │EBR/DHR   ││
│  └────┬─────┘ └──────────┘ └──────────┘ └──────────┘ └──────────┘│
└───────┼────────────────────────────────────────────────────────────┘
        │
┌───────▼────────────────────────────────────────────────────────────┐
│  L6 质量异常、物料平衡与合规审计层     L8 追溯仓储与批次族谱层           │
│  ┌──────────────┐           ┌──────────────────┐                   │
│  │异常/不良/检验│           │线边仓/批次/WIP   │                   │
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
│  │SAP系统   │ │PLM/文控  │ │WMS/线边仓│ │SAP PM/培训│ │OA/UDI    ││
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
| MBR模板 | L2 | `com.ruoyi.production.mbr.service.*` | `/prod-api/mbr/` | `MbrHeaderController`、`MbrVersionController`、`MbrPhaseController`、`MbrStepController`、`MbrStepParameterController`、`MbrStepMaterialController`、`MbrStepEquipmentController`、`MbrStepQualityController`、`MbrImportController`、`MbrSourceMapController`、`MbrExecutionContextController` |
| 执行规则与联锁 | L3 | `com.ruoyi.production.rule.service.*` | `/prod-api/rule/` | `ExecutionRuleController`、`InterlockRuleController`、`InterlockEventController`、`ErrorProofingController` |
| MBR变更控制 | L3 | `com.ruoyi.production.change.service.*` | `/prod-api/change/` | `MbrReleaseController`、`MbrChangeController`、`EcnOrderController`、`MbrVersionDiffController` |
| 生产订单 | L4 | `com.ruoyi.production.order.service.*` | `/prod-api/order/` | `ProductionOrderController`、`OrderComponentController`、`OrderOperationController` |
| 排产管理 | L4 | `com.ruoyi.production.schedule.service.*` | `/prod-api/schedule/` | `SchedulePlanController`、`ScheduleLogController` |
| 派工管理 | L4 | `com.ruoyi.production.dispatch.service.*` | `/prod-api/dispatch/` | `ShopFloorDispatchController` |
| 工序执行与报工 | L5 | `com.ruoyi.production.execution.service.*` | `/prod-api/execution/` | `OperationExecutionController`、`ProductionReportController`、`ReportLaborController`、`ReportEquipmentController`、`OperationTrackingController` |
| 投料与称量 | L5 | `com.ruoyi.production.weighing.service.*` | `/prod-api/weighing/` | `WeighingRecordController`、`ScaleDeviceCheckController`、`WeighingAuditLogController`、`OperationConsumptionController`、`OperationReturnController` |
| 线边仓与领退料 | L5/L8/L9 | `com.ruoyi.production.lineside.service.*` | `/prod-api/lineside/`、`/prod-api/material/requisition/` | `LineSideInventoryController`、`LineSideTxnController`、`MaterialRequisitionController`、`ProductionReturnController`、`LineSideStocktakeController` |
| 电子批记录(EBR) | L5 | `com.ruoyi.production.ebr.service.*` | `/prod-api/ebr/` | `EbrHeaderController`、`EbrStepRecordController`、`EbrParamRecordController`、`BatchReviewController`、`LineClearanceController` |
| 电子表单 | L5/L6 | `com.ruoyi.production.form.service.*` | `/prod-api/form/` | `FormTemplateController`、`FormInstanceController`、`FormReviewController` |
| DHR模板 | L5/L6 | `com.ruoyi.production.dhr.service.*` | `/prod-api/dhr/` | `DhrTemplateController`、`DhrAssemblyController`、`DhrExportController` |
| 流程与编码 | L0/L6 | `com.ruoyi.production.workflow.service.*`、`com.ruoyi.production.code.service.*` | `/prod-api/workflow/`、`/prod-api/code/` | `WorkflowDefinitionController`、`WorkflowTaskController`、`CodeRuleController` |
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
| SAP ERP | L9 | 接收生产订单/物料/BOM/Routing/工厂/库存批次参考数据；MES可创建半成品生产订单并接收SAP订单号；回传报工/投料/检验结果；必要时触发单物料MRP重算 |
| PLM/文控系统 | L9 | 管理SOP拆解、MBR设计、版本审批、生效、冻结、ECN、生产文件和适用范围；MES接收已批准MBR镜像、文档引用和版本状态，生成执行快照，不替代MBR主生命周期和文件生命周期管理 |
| WMS/外部仓储系统 | L9 | WMS负责原辅包外部仓储、移库和成品入库；MES负责工序级领料需求、线边仓库存、线边投料消耗、退料和追溯映射 |
| ThingsBoard/SCADA | L7 | 保存设备映射/点位模型/关键采集结论/告警事件/过程摘要 |
| QMS/eQMS | L6 | 记录现场异常/偏差来源/批记录证据；必要时推送QMS建立正式质量流程 |
| SAP PM | L9 | 提供设备可用状态、维保到期状态和维修状态引用；MES用于执行前校验，不创建维修工单、不替代备件管理 |
| 培训系统 | L9 | 提供人员培训、岗位授权、工序/设备资质状态；MES用于执行前资质校验，不维护培训计划和培训记录 |

---

## 4. 文档索引（所有Agent必须严格遵守渐进式加载规则）
### 4.1 命名规范
所有文档统一存放于`/docs`目录，文件名采用`[两位数字序号]_[大驼峰文件名].md`格式
开发级功能卡作为 Absolute Progressive Loading 的原子文档，统一存放于`30_Feature_Cards/`目录，文件名采用`30_FC-模块-序号_功能标题.md`格式，必须在文件正文保留`card_id`和覆盖的`REQ-*`。
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
| 30 | 30_Feature_Card_Index.md | 开发级功能需求卡总索引，按`FC-*`、`REQ-*`和模块文档定位原子卡片 | 业务模块开发前用于定位功能卡 |
| 30 | 30_Feature_Cards/30_FC-*.md | 开发级功能需求卡，承载单一功能包的需求明细、边界、验收骨架和加载入口 | 按功能卡ID或需求ID精确读取，禁止整目录加载 |
| 31 | 31_需求索引清单.md | 人读版完整需求索引，按模块展示需求总览、功能卡入口、一期标识和一致性提示 | 需求评审、范围沟通、业务确认时读取 |
| - | IVD_MES整体开发口径.md | IVD MES定位、系统边界、L0-L10分层、线边仓/电子表单/DHR口径、集成口径、一期范围 | **所有Agent启动时必看** |
| - | MES系统基础表清单_按优先级.md | 147张表L0-L10分层清单、P0~P0++++开发优先级明细 | 数据库开发、架构设计时读取 |
| - | MES系统基础表逐字段数据字典_按优先级_pgsql.csv | PostgreSQL逐字段数据字典（2411行，147张表） | 生成DDL、代码生成时读取 |
| 10 | 10_主数据管理模块需求文档.md | L1模块Router：工厂/车间/产线/工作中心/物料/设备/人员/班次/仓库 | 主数据模块开发时先读Router定位功能卡 |
| 11 | 11_BOM与工艺路线模块需求文档.md | L2模块Router：BOM/明细/替代/切换/工艺路线/工序/资源/参数/检验 | BOM/工艺模块开发时先读Router定位功能卡 |
| 12 | 12_MBR模板管理模块需求文档.md | L2模块Router：MBR镜像/阶段/步骤/参数/物料/设备/质控/流转/返工/Hold | **MBR核心模块开发时先读Router定位功能卡** |
| 13 | 13_执行规则与联锁模块需求文档.md | L3模块Router：执行规则/联锁/防错/设备指令/MBR发布/变更/ECN/版本差异 | 执行规则模块开发时先读Router定位功能卡 |
| 14 | 14_生产订单与排产模块需求文档.md | L4模块Router：工单/组件/工序实例/排产/派工/配套计划 | 订单排产模块开发时先读Router定位功能卡 |
| 15 | 15_派工与现场执行模块需求文档.md | L4+L5模块Router：派工/模板化派工单/工序执行/报工/人工设备/过程监控 | 现场执行模块开发时先读Router定位功能卡 |
| 16 | 16_称量与投料模块需求文档.md | L5模块Router：投料/退料/称量/线边仓/生产领退料/物料平衡/称量审计 | 称量投料与线边仓模块开发时先读Router定位功能卡 |
| 17 | 17_电子批记录模块需求文档.md | L5模块Router：EBR/电子表单/DHR/批审核/归档/流程编码 | EBR、电子表单、DHR模块开发时先读Router定位功能卡 |
| 18 | 18_异常管理与合规审计模块需求文档.md | L6模块Router：异常/不良/检验/不合格品/电子签名/审计追踪 | 异常合规模块开发时先读Router定位功能卡 |
| 19 | 19_批次追溯模块需求文档.md | L8模块Router：物料批次/收货/序列号/WIP/成品/族谱/配套计划追溯 | 追溯模块开发时先读Router定位功能卡 |
| 20 | 20_系统集成模块需求文档.md | L9模块Router：SAP/PLM/WMS/SAP PM/培训/OA/UDI/QMS集成+接口运营 | 集成模块开发时先读Router定位功能卡 |
| 21 | 21_OT_SCADA集成模块需求文档.md | L7模块Router：SCADA系统/设备映射/采集点位/告警/OEE/环境/冷链/CIP-SIP | OT集成模块开发时先读Router定位功能卡 |
| 22 | 22_订单关闭管理模块需求文档.md | L4+L5模块Router：关闭前置校验/收率/差异分析/归档 | 订单关闭模块开发时先读Router定位功能卡 |

### 4.3 读取规则
- 首次加载仅读取`00_Blueprint.md`、`00_Agent_Collaboration_Rules.md`和`IVD_MES整体开发口径.md`
- 后续工作根据场景按需读取对应子文档，禁止加载无关内容
- 业务模块开发必须先用模块Router定位功能卡，再按`FC-*`或`REQ-*`读取单张功能卡；禁止一次加载全部模块文档或整个`30_Feature_Cards/`目录
- 涉及数据库开发时，按L层和功能卡声明的候选表加载对应表清单、字段字典CSV和数据模型治理规范，禁止一次加载全部147张表
- 新增文档必须先更新本索引，其他Agent才能识别读取

### 4.4 一期开发范围（MVP）

一期围绕"一个受控产品 + 一条典型产线 + 一个完整批记录闭环"建设最小合规闭环：

**一期包含：**
- 主数据：工厂、车间、产线、工作中心、人员、设备、物料、班次、仓库（L1）
- 工艺建模：BOM、Routing、PLM MBR镜像接收、Excel受控批导、MBR Header/Version/Phase/Step/Parameter/Material/Equipment/Quality、工单执行快照（L2）
- 工单执行：生产订单、组件、工序实例、派工、派工单模板、工序执行、报工、投料（L4、L5）
- 配液称量与线边仓：电子天平点检、称量记录、工序级领料、线边仓库存、退料、物料平衡、防错校验、称量审计（L5）
- EBR/DHR：批记录头、步骤记录、参数记录、电子表单、DHR汇总、批记录审核（L5/L6）
- 合规：电子签名、审计追踪、异常记录（L6）
- 集成：SAP 订单/BOM/物料/工艺参考数据同步，MES创建半成品SAP生产订单，WMS领退料闭环，SAP PM/培训状态引用，报工/投料异步回传（L9）
- OT：ThingsBoard 设备映射、点位、关键采集值、告警事件、过程摘要（L7）
- 运行时：Outbox、幂等、死信、对账补偿、MBR 执行上下文（L0）

**一期暂缓：**
- 深度仿真优化（L10）
- 全量 OEE 高级分析
- 全厂冷链矩阵
- 全量 CIP/SIP 自动放行
- 完整委外工艺
- 多产品复杂替代工艺全覆盖
