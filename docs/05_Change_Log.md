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