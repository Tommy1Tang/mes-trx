# 《MES + SAP 集成逻辑数据模型说明书》第二版：实体逐表说明

---

# 1. 文档说明

## 1.1 目的
本版本用于对 MES + SAP 集成逻辑数据模型中的核心实体进行逐表定义，明确：

- 实体业务含义
- 关键字段说明
- 主键 / 业务唯一键建议
- 主要外键关系
- 状态管理建议
- 与 SAP 集成的边界说明

## 1.2 适用阶段
适用于以下阶段：

- 逻辑模型评审
- 概要设计
- 接口方案设计
- 数据字典编制
- 开发建表前准备

## 1.3 说明原则
本版仍然属于**逻辑数据模型说明**，因此：

- 不强制指定物理字段类型长度
- 不强制指定数据库实现细节
- 重点说明实体职责和关系
- 对主键、唯一键、审计字段、有效期给出建议

---

# 2. 通用设计规范

## 2.1 通用主键规则
建议所有实体统一采用：

- `*_id` 作为系统内部主键
- 类型建议为 UUID / 雪花 ID / 长整型分布式主键

例如：
- `plant_id`
- `material_id`
- `routing_id`
- `prod_order_id`

## 2.2 通用审计字段建议
所有核心业务表建议统一增加以下字段（前面的图中未全部展开，但实施时建议保留）：

- `created_by`
- `created_time`
- `updated_by`
- `updated_time`
- `source_system`
- `remark`

对接口表还建议增加：

- `last_error_code`
- `last_error_message`
- `last_retry_time`

## 2.3 通用状态字段建议
建议不要只保留一个笼统的 `status`，实施时可拆分为：

- `record_status`：记录状态（有效 / 无效 / 作废）
- `business_status`：业务状态（如执行中、已完成）
- `sync_status`：同步状态（未同步、已同步、失败）
- `approval_status`：审批状态（如适用）

逻辑模型中用 `status` 表示占位，物理设计时建议细化。

## 2.4 通用唯一键原则
建议每张表至少明确两类键：

### 1）系统主键
如：
- `work_center_id`
- `routing_id`

### 2）业务唯一键
按业务语义建立唯一性约束，例如：
- `plant_code`
- `material_code`
- `order_no`
- `(routing_code, routing_version, plant_id)`

---

# 3. A域：主数据与工作中心映射

## 3.1 PLANT_MASTER

### 业务定义
工厂主数据，表示制造业务的组织级最上层生产地点。  
该实体既是 MES 内部组织归属基础，也通常对应 SAP Plant。

### 关键字段
- `plant_id`：系统主键
- `plant_code`：工厂编码，建议与 SAP Plant 对齐
- `plant_name`：工厂名称
- `status`：状态

### 主键建议
- PK：`plant_id`

### 业务唯一键建议
- UK：`plant_code`

### 主要关系
- 1:N `WORKSHOP_MASTER`
- 1:N `WORK_CENTER_MASTER`
- 1:N `ROUTING_HEADER`
- 1:N `PRODUCTION_ORDER`
- 1:N `MATERIAL_LOT`
- 1:N `FINISHED_GOOD_LOT`

### 管理建议
如果是集团多工厂模型，建议保留：
- 法人组织编码
- 时区
- 语言
- 币种（如后续有成本扩展）

## 3.2 WORKSHOP_MASTER

### 业务定义
车间主数据，表示工厂下属制造区域或业务分区。

### 关键字段
- `workshop_id`
- `plant_id`
- `workshop_code`
- `workshop_name`
- `status`

### 主键建议
- PK：`workshop_id`

### 业务唯一键建议
- UK：`(plant_id, workshop_code)`

### 主要关系
- N:1 `PLANT_MASTER`
- 1:N `PRODUCTION_LINE_MASTER`
- 1:N `WORK_CENTER_MASTER`

### 管理建议
如果企业管理粒度不需要车间层，可以保留逻辑层但在实施中弱化。

## 3.3 PRODUCTION_LINE_MASTER

### 业务定义
产线主数据，表示车间下的产线、制造段、装配线或单元线体。

### 关键字段
- `line_id`
- `workshop_id`
- `line_code`
- `line_name`
- `status`

### 主键建议
- PK：`line_id`

### 业务唯一键建议
- UK：`(workshop_id, line_code)`

### 主要关系
- N:1 `WORKSHOP_MASTER`
- 1:N `WORK_CENTER_MASTER`

## 3.4 WORK_CENTER_MASTER

### 业务定义
MES 工作中心主数据，表示现场实际执行单元。  
可以是：

- 工位
- 工段
- 工序段
- 设备单元
- 人工作业单元
- 线边执行区域

它是 MES 现场执行、工艺绑定、工单派工的关键对象。

### 关键字段
- `work_center_id`
- `plant_id`
- `workshop_id`
- `line_id`
- `work_center_code`
- `work_center_name`
- `work_center_type`
- `status`

### 主键建议
- PK：`work_center_id`

### 业务唯一键建议
- UK：`(plant_id, work_center_code)`

### 主要关系
- N:1 `PLANT_MASTER`
- N:1 `WORKSHOP_MASTER`
- N:1 `PRODUCTION_LINE_MASTER`
- 1:N `EQUIPMENT_MASTER`
- 1:N `ROUTING_OPERATION`
- 1:N `ORDER_OPERATION`
- 1:N `SHOP_FLOOR_DISPATCH`
- 1:N `OPERATION_EXECUTION`
- 1:N `SAP_WORK_CENTER_MAP`

### 关键规则
MES 工作中心与 SAP 工作中心不是强等价关系。  
一个 SAP 工作中心可以映射多个 MES 工作中心。

## 3.5 EQUIPMENT_MASTER

### 业务定义
设备主数据，用于描述参与生产执行、采集或质量检测的设备对象。

### 关键字段
- `equipment_id`
- `work_center_id`
- `equipment_code`
- `equipment_name`
- `equipment_type`
- `status`

### 主键建议
- PK：`equipment_id`

### 业务唯一键建议
- UK：`equipment_code`
或  
- UK：`(work_center_id, equipment_code)` 视企业编码规则确定

### 主要关系
- N:1 `WORK_CENTER_MASTER`
- N:M `ROUTING_OPERATION`（通过 `OPERATION_RESOURCE`）
- 1:N `REPORT_EQUIPMENT`

### 扩展建议
后续可扩：
- 设备状态
- 点检计划
- 保养计划
- 采集通道
- IoT 标识

## 3.6 PERSON_MASTER

### 业务定义
人员主数据，用于描述操作工、检验员、班组长、工艺员等生产相关人员。

### 关键字段
- `person_id`
- `person_code`
- `person_name`
- `person_type`
- `status`

### 主键建议
- PK：`person_id`

### 业务唯一键建议
- UK：`person_code`

### 主要关系
- N:M `WORK_CENTER_MASTER`（通过 `WORK_CENTER_PERSON_MAP`）
- 1:N `REPORT_LABOR`

### 扩展建议
建议后续保留：
- 班组
- 岗位
- 技能等级
- 上岗资格
- 证书有效期

## 3.7 WORK_CENTER_PERSON_MAP

### 业务定义
工作中心与人员绑定关系表，用于表达人员与执行单元之间的配置关系。

### 关键字段
- `wc_person_map_id`
- `work_center_id`
- `person_id`
- `role_type`
- `status`

### 主键建议
- PK：`wc_person_map_id`

### 业务唯一键建议
- UK：`(work_center_id, person_id, role_type)`

### 主要关系
- N:1 `WORK_CENTER_MASTER`
- N:1 `PERSON_MASTER`

## 3.8 SAP_SYSTEM

### 业务定义
SAP 系统定义表，用于标识当前接入的 SAP 系统环境。

### 关键字段
- `sap_system_id`
- `sap_system_code`
- `sap_system_name`
- `landscape_type`
- `status`

### 主键建议
- PK：`sap_system_id`

### 业务唯一键建议
- UK：`sap_system_code`

### 说明
如果未来存在多 SAP 源系统、多集团、多个逻辑系统，该表非常必要。

## 3.9 SAP_WORK_CENTER_REF

### 业务定义
SAP 工作中心参考对象，表示从 SAP 下发或读取的工作中心定义。  
它不是 MES 执行对象，而是外部参考对象。

### 关键字段
- `sap_work_center_ref_id`
- `sap_system_id`
- `sap_plant_code`
- `sap_work_center_code`
- `sap_object_id`
- `sap_object_type`
- `sap_work_center_name`
- `status`

### 主键建议
- PK：`sap_work_center_ref_id`

### 业务唯一键建议
- UK：`(sap_system_id, sap_plant_code, sap_work_center_code)`

### 主要关系
- N:1 `SAP_SYSTEM`
- 1:N `SAP_WORK_CENTER_MAP`

### 说明
该表用于承接 SAP 主数据，不建议直接替代 MES 工作中心表。

## 3.10 SAP_WORK_CENTER_MAP

### 业务定义
SAP 工作中心与 MES 工作中心映射关系表。  
用于实现“一个 SAP 工作中心可映射多个 MES 工作中心”的建模要求。

### 关键字段
- `sap_wc_map_id`
- `sap_work_center_ref_id`
- `work_center_id`
- `plant_id`
- `valid_from`
- `valid_to`
- `sync_status`
- `last_sync_time`
- `source_system`
- `status`

### 主键建议
- PK：`sap_wc_map_id`

### 业务唯一键建议
建议至少控制：
- UK：`(sap_work_center_ref_id, work_center_id, valid_from)`

如果不允许有效期重叠，还需在逻辑上约束同一映射关系有效期不能交叉。

### 主要关系
- N:1 `SAP_WORK_CENTER_REF`
- N:1 `WORK_CENTER_MASTER`
- N:1 `PLANT_MASTER`

### 关键规则
- 支持 1:N 映射
- 支持有效期管理
- 支持历史映射保留
- 支持同步状态留痕

---

# 4. B域：工艺路线 / 工序 / 资源 / 质检

## 4.1 MATERIAL_MASTER

### 业务定义
物料主数据，表示原材料、半成品、成品、辅料、包装物等统一对象。  
是工艺、工单、追溯和集成的核心主数据之一。

### 关键字段
- `material_id`
- `material_code`
- `material_name`
- `material_group`
- `base_uom`
- `material_type`
- `batch_managed_flag`
- `serial_managed_flag`
- `status`

### 主键建议
- PK：`material_id`

### 业务唯一键建议
- UK：`material_code`
或  
- UK：`(plant_scope, material_code)`，取决于企业是否全局物料编码

### 主要关系
- 1:N `ROUTING_HEADER`
- 1:N `INSPECTION_PLAN`
- 1:N `PRODUCTION_ORDER`
- 1:N `MATERIAL_LOT`
- 1:N `WIP_LOT`
- 1:N `FINISHED_GOOD_LOT`

## 4.2 ROUTING_HEADER

### 业务定义
工艺路线头，定义某工厂内某物料某一版本的制造工艺模板。

### 关键字段
- `routing_id`
- `material_id`
- `plant_id`
- `routing_code`
- `routing_version`
- `routing_type`
- `effective_from`
- `effective_to`
- `status`

### 主键建议
- PK：`routing_id`

### 业务唯一键建议
- UK：`(plant_id, material_id, routing_code, routing_version)`

### 主要关系
- N:1 `MATERIAL_MASTER`
- N:1 `PLANT_MASTER`
- 1:N `ROUTING_OPERATION`
- 1:N `OPERATION_RELATION`
- 1:N `PRODUCTION_ORDER`
- 1:N `SAP_ROUTING_MAP`

### 关键规则
- 工艺路线是模板，不直接代表实际执行
- 建议支持版本与有效期
- 一张工单通常只引用一个确定版本的工艺路线

## 4.3 ROUTING_OPERATION

### 业务定义
工艺工序，表示工艺路线中的标准工序模板。

### 关键字段
- `operation_id`
- `routing_id`
- `operation_no`
- `operation_name`
- `operation_type`
- `work_center_id`
- `control_key`
- `standard_time`
- `time_uom`
- `status`

### 主键建议
- PK：`operation_id`

### 业务唯一键建议
- UK：`(routing_id, operation_no)`

### 主要关系
- N:1 `ROUTING_HEADER`
- N:1 `WORK_CENTER_MASTER`
- 1:N `OPERATION_RELATION`
- 1:N `OPERATION_RESOURCE`
- 1:N `OPERATION_PARAMETER`
- 1:N `OPERATION_DOCUMENT`
- 1:N `OPERATION_INSPECTION_MAP`
- 1:N `ORDER_OPERATION`
- 1:N `SAP_OPERATION_MAP`

### 关键规则
- 是模板工序，不是执行工序
- 后续会展开成 `ORDER_OPERATION`

## 4.4 OPERATION_RELATION

### 业务定义
工序前后置关系表，用于描述工艺工序之间的先后、并行或依赖关系。

### 关键字段
- `op_relation_id`
- `routing_id`
- `predecessor_op_id`
- `successor_op_id`
- `relation_type`
- `status`

### 主键建议
- PK：`op_relation_id`

### 业务唯一键建议
- UK：`(routing_id, predecessor_op_id, successor_op_id, relation_type)`

### 主要关系
- N:1 `ROUTING_HEADER`
- N:1 `ROUTING_OPERATION`（前置工序）
- N:1 `ROUTING_OPERATION`（后置工序）

### 说明
适合支持：
- 串行
- 并行
- 汇合
- 特殊依赖

## 4.5 OPERATION_RESOURCE

### 业务定义
工序资源配置表，用于定义某标准工序执行所需资源。

### 关键字段
- `op_res_id`
- `operation_id`
- `resource_type`
- `resource_id`
- `resource_code`
- `usage_qty`
- `usage_uom`
- `required_flag`
- `status`

### 主键建议
- PK：`op_res_id`

### 业务唯一键建议
- UK：`(operation_id, resource_type, resource_id)`

### 主要关系
- N:1 `ROUTING_OPERATION`
- 可逻辑关联 `EQUIPMENT_MASTER` / `TOOLING_MASTER` / `FIXTURE_MASTER`

### 说明
这里采用统一资源表思路，便于扩展不同资源类型。

## 4.6 TOOLING_MASTER

### 业务定义
工装主数据，如刀具、模具、治具等可重复使用制造资源。

### 关键字段
- `tooling_id`
- `tooling_code`
- `tooling_name`
- `tooling_type`
- `status`

### 主键建议
- PK：`tooling_id`

### 业务唯一键建议
- UK：`tooling_code`

## 4.7 FIXTURE_MASTER

### 业务定义
夹具主数据，用于定义定位、固定或装配过程中的夹具资源。

### 关键字段
- `fixture_id`
- `fixture_code`
- `fixture_name`
- `fixture_type`
- `status`

### 主键建议
- PK：`fixture_id`

### 业务唯一键建议
- UK：`fixture_code`

## 4.8 OPERATION_PARAMETER

### 业务定义
工序工艺参数定义表，用于描述标准工序要求的参数项。

### 关键字段
- `op_param_id`
- `operation_id`
- `parameter_code`
- `parameter_name`
- `parameter_value`
- `parameter_uom`
- `status`

### 主键建议
- PK：`op_param_id`

### 业务唯一键建议
- UK：`(operation_id, parameter_code)`

### 说明
后续如果要支持参数上下限、采集值、配方型参数，可继续扩展。

## 4.9 OPERATION_DOCUMENT

### 业务定义
工序作业文档绑定表，用于挂接 SOP、图纸、作业指导书、视频等。

### 关键字段
- `op_doc_id`
- `operation_id`
- `document_code`
- `document_name`
- `document_type`
- `document_url`
- `status`

### 主键建议
- PK：`op_doc_id`

### 业务唯一键建议
- UK：`(operation_id, document_code)`

## 4.10 INSPECTION_PLAN

### 业务定义
检验方案头，定义某物料在某工厂下的标准检验方案。

### 关键字段
- `insp_plan_id`
- `material_id`
- `plant_id`
- `insp_plan_code`
- `insp_type`
- `effective_from`
- `effective_to`
- `status`

### 主键建议
- PK：`insp_plan_id`

### 业务唯一键建议
- UK：`(plant_id, material_id, insp_plan_code)`

### 主要关系
- N:1 `MATERIAL_MASTER`
- N:1 `PLANT_MASTER`
- 1:N `INSPECTION_CHARACTERISTIC`

## 4.11 INSPECTION_CHARACTERISTIC

### 业务定义
检验特性定义表，表示检验项目、指标或判定维度。

### 关键字段
- `insp_char_id`
- `insp_plan_id`
- `characteristic_code`
- `characteristic_name`
- `characteristic_type`
- `inspection_method`
- `target_value`
- `upper_limit`
- `lower_limit`
- `sampling_rule`
- `status`

### 主键建议
- PK：`insp_char_id`

### 业务唯一键建议
- UK：`(insp_plan_id, characteristic_code)`

### 主要关系
- N:1 `INSPECTION_PLAN`
- 1:N `OPERATION_INSPECTION_MAP`
- 1:N `INSPECTION_RESULT`

## 4.12 OPERATION_INSPECTION_MAP

### 业务定义
工序与检验特性的映射关系表，表示哪道工序需要执行哪些检验特性。

### 关键字段
- `op_insp_map_id`
- `operation_id`
- `insp_char_id`
- `inspection_stage`
- `required_flag`
- `status`

### 主键建议
- PK：`op_insp_map_id`

### 业务唯一键建议
- UK：`(operation_id, insp_char_id, inspection_stage)`

### 主要关系
- N:1 `ROUTING_OPERATION`
- N:1 `INSPECTION_CHARACTERISTIC`

### 说明
建议不要把检验特性直接塞在工序表中，采用映射方式更灵活。

---

# 5. C域：生产工单 / 执行 / 报工 / 检验

## 5.1 PRODUCTION_ORDER

### 业务定义
生产工单头，表示 MES 执行层的生产任务主体。  
通常来源于 SAP 生产订单下发，也可支持 MES 自建工单场景。

### 关键字段
- `prod_order_id`
- `plant_id`
- `material_id`
- `routing_id`
- `order_no`
- `order_type`
- `order_qty`
- `order_uom`
- `planned_start_time`
- `planned_end_time`
- `release_status`
- `execution_status`
- `status`

### 主键建议
- PK：`prod_order_id`

### 业务唯一键建议
- UK：`order_no`

### 主要关系
- N:1 `PLANT_MASTER`
- N:1 `MATERIAL_MASTER`
- N:1 `ROUTING_HEADER`
- 1:N `ORDER_OPERATION`
- 1:N `WIP_LOT`
- 1:N `FINISHED_GOOD_LOT`
- 1:N `SAP_PRODUCTION_ORDER_MAP`

### 关键规则
- 工单属于执行对象，不等于 SAP 原始订单参考对象
- 建议保留工艺快照字段，避免工艺模板变更影响历史工单

## 5.2 ORDER_OPERATION

### 业务定义
工单工序，表示工单展开后的具体执行工序实例。

### 关键字段
- `order_op_id`
- `prod_order_id`
- `operation_id`
- `operation_no`
- `operation_name`
- `work_center_id`
- `planned_start_time`
- `planned_end_time`
- `dispatch_status`
- `execution_status`
- `status`

### 主键建议
- PK：`order_op_id`

### 业务唯一键建议
- UK：`(prod_order_id, operation_no)`

### 主要关系
- N:1 `PRODUCTION_ORDER`
- N:1 `ROUTING_OPERATION`
- N:1 `WORK_CENTER_MASTER`
- 1:N `SHOP_FLOOR_DISPATCH`
- 1:N `OPERATION_EXECUTION`
- 1:N `PRODUCTION_REPORT`
- 1:N `PRODUCTION_DEFECT`
- 1:N `INSPECTION_RESULT`
- 1:N `OPERATION_TRACKING`
- 1:N `OPERATION_CONSUMPTION`
- 1:N `OPERATION_RETURN`

### 关键规则
- 来源于工艺工序，但属于执行快照
- 应保留工序编号、名称、工作中心等快照字段

## 5.3 SHOP_FLOOR_DISPATCH

### 业务定义
派工记录，表示将某工单工序分配给某工作中心/班次/时间窗口的执行安排。

### 关键字段
- `dispatch_id`
- `order_op_id`
- `work_center_id`
- `dispatch_no`
- `dispatch_type`
- `dispatch_status`
- `planned_start_time`
- `planned_end_time`
- `status`

### 主键建议
- PK：`dispatch_id`

### 业务唯一键建议
- UK：`dispatch_no`

### 主要关系
- N:1 `ORDER_OPERATION`
- N:1 `WORK_CENTER_MASTER`
- 1:N `OPERATION_EXECUTION`

### 说明
一道工序支持多次派工，因此不建议把派工属性直接塞进工序表。

## 5.4 OPERATION_EXECUTION

### 业务定义
工序执行实例，表示工单工序在现场的一次实际执行过程。

### 关键字段
- `op_exec_id`
- `order_op_id`
- `dispatch_id`
- `work_center_id`
- `execution_no`
- `execution_status`
- `actual_start_time`
- `actual_end_time`
- `completed_qty`
- `scrapped_qty`
- `status`

### 主键建议
- PK：`op_exec_id`

### 业务唯一键建议
- UK：`execution_no`
或  
- UK：`(order_op_id, dispatch_id, actual_start_time)`，视现场规则

### 主要关系
- N:1 `ORDER_OPERATION`
- N:1 `SHOP_FLOOR_DISPATCH`
- N:1 `WORK_CENTER_MASTER`
- 1:N `PRODUCTION_REPORT`
- 1:N `INSPECTION_RESULT`
- 1:N `OPERATION_TRACKING`
- 1:N `OPERATION_CONSUMPTION`
- 1:N `OPERATION_RETURN`
- 1:N `WIP_LOT_TRACKING`

### 关键规则
强烈建议保留此表。  
复杂现场场景下：
- 一道工序可多次执行
- 执行中可暂停/恢复
- 一次派工可拆多次执行

## 5.5 PRODUCTION_REPORT

### 业务定义
报工记录，表示现场对工序执行结果的上报。

### 关键字段
- `report_id`
- `op_exec_id`
- `order_op_id`
- `report_type`
- `report_qty`
- `qualified_qty`
- `scrapped_qty`
- `report_time`
- `report_source`
- `status`

### 主键建议
- PK：`report_id`

### 业务唯一键建议
若支持外部幂等，建议增加：
- UK：`external_report_no`
或
- UK：`(op_exec_id, report_time, report_type)` 作为弱约束

### 主要关系
- N:1 `OPERATION_EXECUTION`
- N:1 `ORDER_OPERATION`
- 1:N `REPORT_LABOR`
- 1:N `REPORT_EQUIPMENT`
- 1:N `PRODUCTION_DEFECT`
- 1:N `REPORT_CONFIRMATION_IF`

### 关键规则
报工不等于执行实例。  
一条执行可能有多次报工。

## 5.6 REPORT_LABOR

### 业务定义
报工人工明细，表示某次报工投入了哪些人员及工时。

### 关键字段
- `report_labor_id`
- `report_id`
- `person_id`
- `labor_hours`
- `status`

### 主键建议
- PK：`report_labor_id`

### 业务唯一键建议
- UK：`(report_id, person_id)`

### 主要关系
- N:1 `PRODUCTION_REPORT`
- N:1 `PERSON_MASTER`

## 5.7 REPORT_EQUIPMENT

### 业务定义
报工设备明细，表示某次报工关联了哪些设备及机时。

### 关键字段
- `report_equipment_id`
- `report_id`
- `equipment_id`
- `machine_hours`
- `status`

### 主键建议
- PK：`report_equipment_id`

### 业务唯一键建议
- UK：`(report_id, equipment_id)`

### 主要关系
- N:1 `PRODUCTION_REPORT`
- N:1 `EQUIPMENT_MASTER`

## 5.8 DEFECT_CODE_MASTER

### 业务定义
缺陷代码主数据，用于统一管理不良现象、缺陷分类、原因编码。

### 关键字段
- `defect_code_id`
- `defect_code`
- `defect_name`
- `defect_category`
- `status`

### 主键建议
- PK：`defect_code_id`

### 业务唯一键建议
- UK：`defect_code`

## 5.9 PRODUCTION_DEFECT

### 业务定义
生产不良记录，表示某次报工或某道工序上产生的缺陷明细。

### 关键字段
- `prod_defect_id`
- `report_id`
- `order_op_id`
- `defect_code_id`
- `defect_qty`
- `defect_level`
- `remark`
- `status`

### 主键建议
- PK：`prod_defect_id`

### 业务唯一键建议
- UK：`(report_id, defect_code_id, defect_level)`

### 主要关系
- N:1 `PRODUCTION_REPORT`
- N:1 `ORDER_OPERATION`
- N:1 `DEFECT_CODE_MASTER`

### 说明
不建议只在报工表上保留一个报废数，独立缺陷表便于统计和分析。

## 5.10 INSPECTION_RESULT

### 业务定义
检验结果记录，表示现场执行过程中对检验特性的实际检测结果。

### 关键字段
- `insp_result_id`
- `op_exec_id`
- `order_op_id`
- `insp_char_id`
- `inspection_stage`
- `result_value`
- `result_unit`
- `result_decision`
- `inspected_by`
- `inspected_time`
- `status`

### 主键建议
- PK：`insp_result_id`

### 业务唯一键建议
根据采集方式可设计为：
- UK：`(op_exec_id, insp_char_id, inspection_stage, inspected_time)`  
若允许重复测量，则不强制唯一，仅保留明细粒度。

### 主要关系
- N:1 `OPERATION_EXECUTION`
- N:1 `ORDER_OPERATION`
- N:1 `INSPECTION_CHARACTERISTIC`
- 1:N `INSPECTION_RESULT_IF`

### 关键规则
建议挂在执行实例上，而不是只挂工序。

## 5.11 OPERATION_TRACKING

### 业务定义
工序跟踪记录，表示工序执行过程中的事件留痕。

### 关键字段
- `op_track_id`
- `order_op_id`
- `op_exec_id`
- `tracking_event`
- `tracking_time`
- `tracking_by`
- `remark`
- `status`

### 主键建议
- PK：`op_track_id`

### 业务唯一键建议
- UK：`(op_exec_id, tracking_event, tracking_time)`

### 典型事件
- 入站
- 开工
- 暂停
- 恢复
- 完工
- 过站
- 异常挂起

### 说明
适合做：
- 看板
- 节拍分析
- 稽核留痕
- 异常追踪

---

# 6. D域：追溯 / 批次 / 序列号

## 6.1 SUPPLIER_MASTER

### 业务定义
供应商主数据，用于来料收货及来料追溯。

### 关键字段
- `supplier_id`
- `supplier_code`
- `supplier_name`
- `status`

### 主键建议
- PK：`supplier_id`

### 业务唯一键建议
- UK：`supplier_code`

## 6.2 WAREHOUSE_MASTER

### 业务定义
仓库主数据，表示工厂下仓储区域。

### 关键字段
- `warehouse_id`
- `plant_id`
- `warehouse_code`
- `warehouse_name`
- `status`

### 主键建议
- PK：`warehouse_id`

### 业务唯一键建议
- UK：`(plant_id, warehouse_code)`

## 6.3 STORAGE_LOCATION_MASTER

### 业务定义
库存地点/库位主数据，表示仓库内的存储位置。

### 关键字段
- `storage_location_id`
- `warehouse_id`
- `storage_location_code`
- `storage_location_name`
- `status`

### 主键建议
- PK：`storage_location_id`

### 业务唯一键建议
- UK：`(warehouse_id, storage_location_code)`

## 6.4 GOODS_RECEIPT

### 业务定义
收货单头，表示一次来料接收入库业务。

### 关键字段
- `gr_id`
- `plant_id`
- `supplier_id`
- `gr_no`
- `gr_type`
- `gr_date`
- `status`

### 主键建议
- PK：`gr_id`

### 业务唯一键建议
- UK：`gr_no`

### 主要关系
- N:1 `PLANT_MASTER`
- N:1 `SUPPLIER_MASTER`
- 1:N `GOODS_RECEIPT_ITEM`

## 6.5 GOODS_RECEIPT_ITEM

### 业务定义
收货明细，表示收货单中的物料明细项。

### 关键字段
- `gr_item_id`
- `gr_id`
- `material_id`
- `storage_location_id`
- `received_qty`
- `received_uom`
- `status`

### 主键建议
- PK：`gr_item_id`

### 业务唯一键建议
- UK：`(gr_id, material_id, storage_location_id)`  
若允许同物料重复行，则可改为行号唯一。

## 6.6 MATERIAL_LOT

### 业务定义
物料批次，表示原材料、半成品或其他批次管理物料的批次对象。

### 关键字段
- `material_lot_id`
- `material_id`
- `plant_id`
- `lot_no`
- `lot_type`
- `supplier_lot_no`
- `manufacture_date`
- `expiry_date`
- `current_qty`
- `lot_status`
- `status`

### 主键建议
- PK：`material_lot_id`

### 业务唯一键建议
- UK：`(plant_id, material_id, lot_no)`

### 主要关系
- N:1 `MATERIAL_MASTER`
- N:1 `PLANT_MASTER`
- 1:N `SERIAL_NUMBER`
- 1:N `OPERATION_CONSUMPTION`
- 1:N `OPERATION_RETURN`
- 1:N `LOT_GENEALOGY`

## 6.7 SERIAL_NUMBER

### 业务定义
物料序列号，表示单件级追踪对象。

### 关键字段
- `serial_id`
- `material_id`
- `material_lot_id`
- `serial_no`
- `serial_status`
- `status`

### 主键建议
- PK：`serial_id`

### 业务唯一键建议
- UK：`serial_no`
或  
- UK：`(material_id, serial_no)`，看企业是否全局唯一

### 主要关系
- N:1 `MATERIAL_MASTER`
- N:1 `MATERIAL_LOT`
- 1:N `OPERATION_CONSUMPTION`
- 1:N `OPERATION_RETURN`
- 1:N `SERIAL_GENEALOGY`

## 6.8 OPERATION_CONSUMPTION

### 业务定义
工序投料记录，表示某次执行消耗了什么物料、哪个批次或哪个序列号。

### 关键字段
- `op_consume_id`
- `op_exec_id`
- `order_op_id`
- `material_id`
- `material_lot_id`
- `serial_id`
- `consume_qty`
- `consume_uom`
- `consumption_type`
- `status`

### 主键建议
- PK：`op_consume_id`

### 业务唯一键建议
若按扫描明细可不强约束；  
若按聚合过账，可建议：
- UK：`(op_exec_id, material_id, material_lot_id, serial_id, consumption_type)`

### 主要关系
- N:1 `OPERATION_EXECUTION`
- N:1 `ORDER_OPERATION`
- N:1 `MATERIAL_MASTER`
- N:1 `MATERIAL_LOT`
- N:1 `SERIAL_NUMBER`
- 1:N `CONSUMPTION_POSTING_IF`

### 关键规则
投料记录是追溯链的核心数据。

## 6.9 OPERATION_RETURN

### 业务定义
工序退料记录，表示执行中退回的物料、批次或序列号。

### 关键字段
- `op_return_id`
- `op_exec_id`
- `order_op_id`
- `material_id`
- `material_lot_id`
- `serial_id`
- `return_qty`
- `return_uom`
- `return_reason`
- `status`

### 主键建议
- PK：`op_return_id`

### 业务唯一键建议
- UK：`(op_exec_id, material_id, material_lot_id, serial_id, return_reason)`

## 6.10 WIP_LOT

### 业务定义
在制品批次，表示工单执行过程中形成的中间批次对象。

### 关键字段
- `wip_lot_id`
- `prod_order_id`
- `material_id`
- `plant_id`
- `wip_lot_no`
- `wip_status`
- `current_qty`
- `status`

### 主键建议
- PK：`wip_lot_id`

### 业务唯一键建议
- UK：`(plant_id, wip_lot_no)`

### 主要关系
- N:1 `PRODUCTION_ORDER`
- N:1 `MATERIAL_MASTER`
- N:1 `PLANT_MASTER`
- 1:N `WIP_LOT_TRACKING`
- 1:N `LOT_GENEALOGY`

## 6.11 WIP_LOT_TRACKING

### 业务定义
在制品批次流转跟踪表，记录在制批次在工序执行中的变化过程。

### 关键字段
- `wip_track_id`
- `wip_lot_id`
- `op_exec_id`
- `order_op_id`
- `tracking_event`
- `tracking_time`
- `event_qty`
- `status`

### 主键建议
- PK：`wip_track_id`

### 业务唯一键建议
- UK：`(wip_lot_id, op_exec_id, tracking_event, tracking_time)`

## 6.12 FINISHED_GOOD_LOT

### 业务定义
成品批次，表示工单产出形成的成品批次对象。

### 关键字段
- `fg_lot_id`
- `prod_order_id`
- `material_id`
- `plant_id`
- `fg_lot_no`
- `produced_qty`
- `lot_status`
- `status`

### 主键建议
- PK：`fg_lot_id`

### 业务唯一键建议
- UK：`(plant_id, material_id, fg_lot_no)`

### 主要关系
- N:1 `PRODUCTION_ORDER`
- N:1 `MATERIAL_MASTER`
- N:1 `PLANT_MASTER`
- 1:N `FINISHED_GOOD_SERIAL`
- 1:N `LOT_GENEALOGY`

## 6.13 FINISHED_GOOD_SERIAL

### 业务定义
成品序列号，表示成品单件级追踪对象。

### 关键字段
- `fg_serial_id`
- `fg_lot_id`
- `material_id`
- `serial_no`
- `serial_status`
- `status`

### 主键建议
- PK：`fg_serial_id`

### 业务唯一键建议
- UK：`serial_no`
或  
- UK：`(material_id, serial_no)`

### 主要关系
- N:1 `FINISHED_GOOD_LOT`
- N:1 `MATERIAL_MASTER`
- 1:N `SERIAL_GENEALOGY`

## 6.14 LOT_GENEALOGY

### 业务定义
批次族谱关系表，用于构建批次之间的来源与去向链路。

### 关键字段
- `lot_genealogy_id`
- `source_lot_type`
- `source_lot_id`
- `target_lot_type`
- `target_lot_id`
- `relation_type`
- `traced_qty`
- `status`

### 主键建议
- PK：`lot_genealogy_id`

### 业务唯一键建议
- UK：`(source_lot_type, source_lot_id, target_lot_type, target_lot_id, relation_type)`

### 说明
该表是提升追溯效率的关键。

## 6.15 SERIAL_GENEALOGY

### 业务定义
序列号族谱关系表，用于构建单件级来源与去向追踪链。

### 关键字段
- `serial_genealogy_id`
- `source_serial_id`
- `target_serial_id`
- `relation_type`
- `status`

### 主键建议
- PK：`serial_genealogy_id`

### 业务唯一键建议
- UK：`(source_serial_id, target_serial_id, relation_type)`

---

# 7. E域：SAP-MES 集成映射

## 7.1 SAP_PLANT_REF

### 业务定义
SAP 工厂参考对象。

### 关键字段
- `sap_plant_ref_id`
- `sap_system_id`
- `sap_plant_code`
- `sap_plant_name`
- `status`

### 主键建议
- PK：`sap_plant_ref_id`

### 业务唯一键建议
- UK：`(sap_system_id, sap_plant_code)`

## 7.2 SAP_MATERIAL_REF

### 业务定义
SAP 物料参考对象。

### 关键字段
- `sap_material_ref_id`
- `sap_system_id`
- `sap_material_code`
- `sap_material_name`
- `material_type`
- `base_uom`
- `status`

### 主键建议
- PK：`sap_material_ref_id`

### 业务唯一键建议
- UK：`(sap_system_id, sap_material_code)`

## 7.3 SAP_BOM_REF

### 业务定义
SAP BOM 参考对象。

### 关键字段
- `sap_bom_ref_id`
- `sap_system_id`
- `sap_material_code`
- `sap_plant_code`
- `sap_bom_no`
- `sap_bom_alt`
- `status`

### 主键建议
- PK：`sap_bom_ref_id`

### 业务唯一键建议
- UK：`(sap_system_id, sap_plant_code, sap_material_code, sap_bom_no, sap_bom_alt)`

## 7.4 SAP_ROUTING_REF

### 业务定义
SAP 工艺路线参考对象。

### 关键字段
- `sap_routing_ref_id`
- `sap_system_id`
- `sap_material_code`
- `sap_plant_code`
- `sap_group_no`
- `sap_group_counter`
- `status`

### 主键建议
- PK：`sap_routing_ref_id`

### 业务唯一键建议
- UK：`(sap_system_id, sap_plant_code, sap_group_no, sap_group_counter)`

## 7.5 SAP_OPERATION_REF

### 业务定义
SAP 工艺工序参考对象。

### 关键字段
- `sap_operation_ref_id`
- `sap_routing_ref_id`
- `sap_operation_no`
- `sap_work_center_code`
- `control_key`
- `status`

### 主键建议
- PK：`sap_operation_ref_id`

### 业务唯一键建议
- UK：`(sap_routing_ref_id, sap_operation_no)`

## 7.6 SAP_PRODUCTION_ORDER_REF

### 业务定义
SAP 生产订单参考对象。

### 关键字段
- `sap_prod_order_ref_id`
- `sap_system_id`
- `sap_order_no`
- `sap_order_type`
- `sap_material_code`
- `sap_plant_code`
- `order_status`
- `status`

### 主键建议
- PK：`sap_prod_order_ref_id`

### 业务唯一键建议
- UK：`(sap_system_id, sap_order_no)`

## 7.7 SAP_PLANT_MAP

### 业务定义
SAP 工厂与 MES 工厂映射。

### 主键建议
- PK：`sap_plant_map_id`

### 业务唯一键建议
- UK：`(sap_plant_ref_id, plant_id, valid_from)`

## 7.8 SAP_MATERIAL_MAP

### 业务定义
SAP 物料与 MES 物料映射。

### 主键建议
- PK：`sap_material_map_id`

### 业务唯一键建议
- UK：`(sap_material_ref_id, material_id, valid_from)`

## 7.9 SAP_BOM_MAP

### 业务定义
SAP BOM 与 MES BOM 映射。

### 主键建议
- PK：`sap_bom_map_id`

### 业务唯一键建议
- UK：`(sap_bom_ref_id, bom_id, valid_from)`

## 7.10 BOM_HEADER

### 业务定义
MES BOM 头对象。  
用于承接生产用结构化物料清单。

### 关键字段
- `bom_id`
- `material_id`
- `plant_id`
- `bom_code`
- `bom_version`
- `status`

### 主键建议
- PK：`bom_id`

### 业务唯一键建议
- UK：`(plant_id, material_id, bom_code, bom_version)`

## 7.11 SAP_ROUTING_MAP

### 业务定义
SAP 工艺路线与 MES 工艺路线映射。

### 主键建议
- PK：`sap_routing_map_id`

### 业务唯一键建议
- UK：`(sap_routing_ref_id, routing_id, valid_from)`

## 7.12 SAP_OPERATION_MAP

### 业务定义
SAP 工序与 MES 工艺工序映射。

### 主键建议
- PK：`sap_operation_map_id`

### 业务唯一键建议
- UK：`(sap_operation_ref_id, operation_id, valid_from)`

## 7.13 SAP_PRODUCTION_ORDER_MAP

### 业务定义
SAP 生产订单与 MES 工单映射。

### 主键建议
- PK：`sap_prod_order_map_id`

### 业务唯一键建议
- UK：`(sap_prod_order_ref_id, prod_order_id)`

## 7.14 INTERFACE_MESSAGE

### 业务定义
接口消息主表，用于记录系统间报文交互留痕。

### 关键字段
- `interface_msg_id`
- `interface_type`
- `direction`
- `source_system`
- `target_system`
- `business_object_type`
- `business_key`
- `message_status`
- `message_time`
- `retry_count`
- `status`

### 主键建议
- PK：`interface_msg_id`

### 业务唯一键建议
建议增加：
- `external_message_id`
- UK：`(source_system, external_message_id)`

### 关键规则
接口消息与业务对象要分离，便于重试和审计。

## 7.15 REPORT_CONFIRMATION_IF

### 业务定义
报工确认接口表，用于承接 MES 报工回传 SAP 的业务数据。

### 关键字段
- `report_if_id`
- `report_id`
- `sap_prod_order_ref_id`
- `sap_operation_no`
- `confirmation_qty`
- `scrap_qty`
- `posting_date`
- `interface_status`
- `status`

### 主键建议
- PK：`report_if_id`

### 业务唯一键建议
- UK：`(report_id, sap_prod_order_ref_id, sap_operation_no, posting_date)`

### 主要关系
- N:1 `PRODUCTION_REPORT`
- N:1 `SAP_PRODUCTION_ORDER_REF`
- N:1 `INTERFACE_MESSAGE`

## 7.16 INSPECTION_RESULT_IF

### 业务定义
检验结果回传接口表。

### 关键字段
- `insp_if_id`
- `insp_result_id`
- `sap_prod_order_ref_id`
- `sap_operation_no`
- `inspection_lot_no`
- `interface_status`
- `status`

### 主键建议
- PK：`insp_if_id`

### 业务唯一键建议
- UK：`(insp_result_id, sap_prod_order_ref_id, sap_operation_no)`

## 7.17 CONSUMPTION_POSTING_IF

### 业务定义
投料/物料消耗回传接口表，用于将 MES 工序投料结果回传 SAP 过账。

### 关键字段
- `consume_if_id`
- `op_consume_id`
- `sap_prod_order_ref_id`
- `sap_material_code`
- `posting_qty`
- `movement_type`
- `interface_status`
- `status`

### 主键建议
- PK：`consume_if_id`

### 业务唯一键建议
- UK：`(op_consume_id, sap_prod_order_ref_id, sap_material_code, movement_type)`

---

# 8. 关键建模结论

## 8.1 参考对象与执行对象必须分开
尤其是：
- SAP 工作中心 vs MES 工作中心
- SAP 工艺工序 vs MES 工单工序
- SAP 订单参考对象 vs MES 生产工单

## 8.2 工艺模板与执行实例必须分开
- `ROUTING_*` 是标准模板
- `PRODUCTION_ORDER / ORDER_OPERATION / OPERATION_EXECUTION` 是实际执行对象

## 8.3 追溯必须落到工序执行粒度
只有把以下对象关联起来，追溯链才完整：
- 工序执行
- 投料
- 批次 / SN
- 在制品
- 成品批次

## 8.4 接口数据不能混入业务主表
建议：
- 业务表只存业务结果
- 接口表只存接口处理状态和回传内容
- 消息主表存统一链路审计

---

# 9. 下一步建议

建议你后续继续做两份文档之一：

## 方案A：字段级数据字典
我可以继续把上面这些实体展开成：

- 字段名
- 中文名
- 是否必填
- 是否主键
- 是否唯一
- 取值说明
- 来源系统
- 示例值

这就接近正式数据字典了。

## 方案B：接口字段映射说明书
我可以继续输出：

- SAP → MES 主数据接口字段映射
- SAP → MES 工单接口字段映射
- MES → SAP 报工确认字段映射
- MES → SAP 质检结果字段映射
- MES → SAP 物料消耗字段映射

这就接近实施接口设计稿了。

如果你愿意，我建议下一步直接做：

**《MES + SAP 集成逻辑数据模型说明书》第三版：字段级数据字典（核心表）》**

你回我一句：

**出第三版**