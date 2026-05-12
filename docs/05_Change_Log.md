# 数据模型变更记录

## 说明

本文档记录MES系统所有数据模型变更，包括新增表、新增字段、修改字段、删除字段、新增字典项等。

变更编号格式：`DM-YYYYMMDD-序号`

---

## 变更记录

### DM-20260430-001

#### 变更类型
新增表

#### 需求来源
MES系统基础表设计，P0+补充核心表（排产、电子批记录、异常管理模块）

#### 变更内容
新增10张表：
1. `pro_shift` - 班次主数据表
2. `pro_calendar` - 生产日历表
3. `pro_schedule_plan` - 排产计划表
4. `pro_schedule_log` - 排产调整日志表
5. `pro_batch_review` - 批记录审核流程表
6. `pro_exception_category` - 异常分类配置表
7. `pro_exception_escalation` - 异常升级记录表
8. `pro_wc_equipment` - 工作中心设备关系表
9. `pro_nc_handling` - 不合格品处置表
10. `pro_change_request` - 工程变更请求表

#### 影响范围
- 影响模块：排产管理、电子批记录、异常管理
- 影响接口：待定
- 影响报表：待定
- 影响历史数据：无
- 是否需要数据迁移：否

#### 兼容策略
新增表，不影响现有功能，完全兼容。

#### 校验结果
- 主键校验：通过（每表有且只有一个主键）
- 外键校验：通过（所有外键引用存在）
- 重复字段校验：通过
- 字典编码校验：通过
- 字段说明校验：通过

#### 评审结论
通过

---

### DM-20260430-002

#### 变更类型
新增字段

#### 需求来源
排产管理模块需求文档（REQ-SCH-002/005/008）

#### 变更内容
`pro_production_order` 表新增3个字段：
1. `priority_level` - 紧急程度 varchar(2)，字典：mes_priority_level
2. `batch_no` - 批次号 varchar(64)
3. `schedule_status` - 排产状态 varchar(20)，字典：mes_schedule_status

#### 影响范围
- 影响模块：生产订单、排产管理
- 影响接口：待定
- 影响报表：待定
- 影响历史数据：无（新增字段有默认值）
- 是否需要数据迁移：否

#### 兼容策略
新增字段，有默认值，不影响现有功能。

#### 校验结果
- 主键校验：通过
- 外键校验：通过
- 重复字段校验：通过
- 字典编码校验：通过
- 字段说明校验：通过

#### 评审结论
通过

---

### DM-20260430-003

#### 变更类型
新增字段

#### 需求来源
现场报工、物料管理模块需求

#### 变更内容
`pro_operation_execution` 表新增1个字段：
1. `shift_id` - 班次ID bigint，外键：pro_shift.shift_id

`pro_production_report` 表新增2个字段：
1. `shift_id` - 班次ID bigint，外键：pro_shift.shift_id
2. `equipment_id` - 设备ID bigint，外键：pro_equipment_master.equipment_id

`pro_material_lot` 表新增2个字段：
1. `warehouse_id` - 仓库ID bigint，外键：pro_warehouse_master.warehouse_id
2. `storage_location_id` - 库位ID bigint，外键：pro_storage_location_master.storage_location_id

#### 影响范围
- 影响模块：工序执行、报工、物料批次
- 影响接口：待定
- 影响报表：待定
- 影响历史数据：无（新增字段可空）
- 是否需要数据迁移：否

#### 兼容策略
新增字段，可空，不影响现有功能。

#### 校验结果
- 主键校验：通过
- 外键校验：通过
- 重复字段校验：通过
- 字典编码校验：通过
- 字段说明校验：通过

#### 评审结论
通过

---

### DM-20260430-004

#### 变更类型
数据字典规范化

#### 需求来源
数据模型治理规范建立

#### 变更内容
1. `00_Data_Dictionary.csv` 重构，添加 `dict_code`、`长度`、`是否必填` 列
2. 字段说明统一改为通俗中文
3. 补充字典编码：mes_shift_code、mes_calendar_day_type、mes_schedule_status、mes_schedule_adjust_type、mes_batch_review_node、mes_review_status、mes_exception_status、mes_exception_type、mes_exception_level、mes_signature_meaning、mes_relation_type、mes_handling_type、mes_handling_status、mes_change_type、mes_change_status、mes_priority_level

#### 影响范围
- 影响模块：全局
- 影响接口：无
- 影响报表：无
- 影响历史数据：无
- 是否需要数据迁移：否

#### 兼容策略
文档规范化变更，不影响现有功能。

#### 校验结果
- 主键校验：通过
- 外键校验：通过
- 重复字段校验：通过
- 字典编码校验：通过
- 字段说明校验：通过

#### 评审结论
通过

---

### DM-20260430-005

#### 变更类型
数据字典补充

#### 需求来源
T01校验发现4个字段缺少dict_code

#### 变更内容
补充4个字段的字典编码：
1. `pro_bom_cutover_execution_log.exec_result` - 新增字典 `mes_exec_result`
2. `pro_production_defect.disposition_result` - 新增字典 `mes_disposition_result`
3. `pro_schedule_log.adjust_reason` - 新增字典 `mes_adjust_reason`
4. `pro_exception_escalation.escalation_reason` - 新增字典 `mes_escalation_reason`

#### 影响范围
- 影响模块：BOM管理、质量管理、排产管理、异常管理
- 影响接口：无（仅字典补充）
- 影响报表：无
- 影响历史数据：无
- 是否需要数据迁移：否

#### 兼容策略
仅补充字典编码，不影响现有功能。

#### 校验结果
- 硬性校验：通过
- 字典编码校验：通过

#### 评审结论
通过

---

### DM-20260512-001

#### 变更类型
需求口径重大调整（全局影响）

#### 需求来源
IVD_MES整体开发口径、MES系统基础表清单_按优先级（新版147表）、MES系统基础表逐字段数据字典_按优先级_pgsql

#### 变更内容
1. **项目定位升级**：从通用MES系统调整为IVD试剂生产的受控制造执行平台
2. **表数量扩展**：85张表 → 147张表（新增62张表），覆盖MBR/EBR模板、执行规则联锁、OT/SCADA采集、环境冷链、运行时韧性等新域
3. **架构分层体系重构**：原P0/P1/P2三级开发优先级，调整为L0-L10十一层架构分层 + P0~P0++++十级开发优先级双轨并行
4. **系统边界明确化**：新增PLM、ThingsBoard/SCADA、QMS三个集成对象的接口口径
5. **合规要求明确化**：明确FDA 21 CFR Part 11、ISO 13485:2016、GMP合规落地要求
6. **一期范围重新定义**：从全部模块铺开调整为以"配液称量+电子批记录闭环"为MVP的最小合规闭环
7. **新增基线文件**：
   - `docs/IVD_MES整体开发口径.md` — 整体开发口径与系统边界
   - `docs/MES系统基础表清单_按优先级.md` — 147表L0-L10分层清单
   - `docs/MES系统基础表逐字段数据字典_按优先级_pgsql.csv` — PostgreSQL逐字段数据字典（2411行）

#### 新增表统计（按架构层）
| 架构层 | 新增表数 | 说明 |
|--------|---------|------|
| L0 运行时韧性层 | 6 | Outbox、幂等、死信、对账、MBR上下文 |
| L1 主数据层 | 4 | 工装、夹具、供应商、人员资质等（原P1/P2并入） |
| L2 工艺MBR层 | 31 | MBR模板、步骤、参数、流转规则等（全新域） |
| L3 执行规则层 | 10 | 执行规则、联锁、防错、ECN变更（全新域） |
| L5 现场执行层 | 4 | 称量、天平点检、清场、过程监控（新增） |
| L7 OT/SCADA层 | 16 | SCADA系统、采集点位、告警、OEE、环境、冷链、CIP/SIP（全新域） |
| L8 追溯仓储层 | 10 | 物料批次、收货、序列号、WIP、成品、族谱（新增） |
| L9 集成层 | 21 | SAP参考/映射表、接口消息（原P0并入+新增） |

#### 影响范围
- 影响模块：全局（所有模块均受影响）
- 影响接口：全部API需按新口径重新审视
- 影响报表：待定
- 影响历史数据：无（尚未执行DDL到生产环境）
- 是否需要数据迁移：否

#### 兼容策略
- 已有的6个SQL文件（85张表）保持不动，作为基线
- 新增62张表需后续生成新的SQL文件
- 已完成的T01-T07任务标记为DONE，新表DDL作为新任务排入看板

#### 关联文档变更
- `00_Blueprint.md` — 模块图、API路标、文档索引更新
- `03_Database_Design.md` — 表清单扩展至147张
- `00_Progress_Snapshot.md` — 进度快照重写
- `00_Task_Kanban.md` — 看板重新规划
- `00_Requirement_Index.md` — 需求索引扩展
- `04_System_Architecture.md` — 架构方案补充
- `00_Agent_Collaboration_Rules.md` — 协作规则更新

#### 评审结论
待人类确认