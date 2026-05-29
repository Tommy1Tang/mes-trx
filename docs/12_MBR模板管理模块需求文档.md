# MBR模板管理模块需求文档（L2层后半）
## 1. 模块概述
MBR（Master Batch Record，主批生产记录模板）是IVD受控生产的核心建模层，定义了产品从配液、称量、孵育、灌装、冻干到包装的全部受控执行步骤。PLM 是 MBR 主系统，负责 SOP 拆解、MBR 设计、版本审批、生效、冻结和变更控制；MES 是 MBR 执行系统，负责接收 PLM 已批准的结构化 MBR 镜像、完成结构校验、生成工单/批次执行快照，并驱动 EBR 执行。

MES 中的 `pro_mbr_*` 表定位为 PLM MBR 的执行镜像和执行结构，不承载 MBR 主版本审批、主版本发布、主版本冻结和 SOP 文档生命周期。PLM 暂时无法结构化输出时，MES 可提供 Excel 批导作为受控补充入口，但批导必须走同等校验、审计、权限和来源文件留存，不得绕过 PLM 审批。

MBR与BOM/工艺路线的边界必须保持清晰：BOM定义物料和基准用量，工艺路线定义工序级骨架，MBR定义工序下的工步级执行明细。MBR Phase通常对应工艺路线工序，MBR Step对应工序下的执行工步；Step中的物料、设备、参数和质控必须引用或校验BOM、工艺路线、检验方案等上游基准，不允许脱离上游基准另建一套执行主数据。

**架构层：** L2 产品、工艺与MBR模板层（后半部分）
**涉及表：** pro_mbr_header、pro_mbr_version、pro_mbr_phase、pro_mbr_step、pro_mbr_step_parameter、pro_mbr_step_material、pro_mbr_step_equipment、pro_mbr_step_quality、pro_mbr_step_transition、pro_mbr_rework_rule、pro_mbr_dynamic_param_rule、pro_mbr_hold_rule、pro_mbr_step_person_role、pro_mbr_alternative_process_rule、pro_outsource_operation_rule、pro_mbr_execution_context、pro_mbr_context_refresh_log；MBR导入控制候选表待DBA评审


## 2. Absolute Progressive Loading 路由
本模块文档只作为 Router 和模块边界，不承载全部开发细节。开发 Agent 必须按功能卡、字段字典和接口路标进行最小上下文加载。

### 2.1 功能卡索引
| 功能卡ID | 功能卡 | 覆盖需求 | 文件 |
|----------|--------|----------|------|
| FC-MBR-001 | MBR镜像头与版本 | REQ-MBR-001, REQ-MBR-002, REQ-MBR-003, REQ-MBR-004 | 30_Feature_Cards/30_FC-MBR-001_MBR镜像头与版本.md |
| FC-MBR-002 | MBR阶段与步骤 | REQ-MBR-005, REQ-MBR-006, REQ-MBR-007 | 30_Feature_Cards/30_FC-MBR-002_MBR阶段与步骤.md |
| FC-MBR-003 | MBR步骤参数 | REQ-MBR-008, REQ-MBR-009 | 30_Feature_Cards/30_FC-MBR-003_MBR步骤参数.md |
| FC-MBR-004 | MBR步骤物料 | REQ-MBR-010, REQ-MBR-011 | 30_Feature_Cards/30_FC-MBR-004_MBR步骤物料.md |
| FC-MBR-005 | MBR步骤设备 | REQ-MBR-012, REQ-MBR-013 | 30_Feature_Cards/30_FC-MBR-005_MBR步骤设备.md |
| FC-MBR-006 | MBR步骤质控 | REQ-MBR-014, REQ-MBR-015 | 30_Feature_Cards/30_FC-MBR-006_MBR步骤质控.md |
| FC-MBR-007 | MBR步骤流转规则 | REQ-MBR-016, REQ-MBR-017, REQ-MBR-018, REQ-MBR-019 | 30_Feature_Cards/30_FC-MBR-007_MBR步骤流转规则.md |
| FC-MBR-008 | MBR返工与动态参数 | REQ-MBR-020, REQ-MBR-021, REQ-MBR-022 | 30_Feature_Cards/30_FC-MBR-008_MBR返工与动态参数.md |
| FC-MBR-009 | MBR人员与替代工艺 | REQ-MBR-023, REQ-MBR-024, REQ-MBR-025 | 30_Feature_Cards/30_FC-MBR-009_MBR人员与替代工艺.md |
| FC-MBR-010 | PLM MBR接收、Excel批导与执行快照 | REQ-MBR-026, REQ-MBR-027, REQ-MBR-028, REQ-MBR-029, REQ-MBR-030, REQ-MBR-031, REQ-MBR-032 | 30_Feature_Cards/30_FC-MBR-010_PLM_MBR接收、Excel批导与执行快照.md |

### 2.2 开发加载规则
1. 先读取 `00_Blueprint.md`、`00_Agent_Collaboration_Rules.md`、`IVD_MES整体开发口径.md`。
2. 按需求ID或功能卡ID读取本模块对应功能卡，例如 `rg "REQ-XXX-001" docs/30_Feature_Cards` 或 `rg "FC-XXX-001" docs/30_Feature_Cards`。
3. 只加载功能卡声明的相关表字段、接口小节和治理规范，禁止一次加载整个字段字典。
4. 若功能卡仍缺页面字段、交互或验收细节，先补卡再开发。

## 3. 核心流程

### 3.1 PLM MBR接收与镜像落库流程
1. PLM/文控系统完成MBR设计、审批、生效或冻结。
2. PLM向MES下发已批准结构化MBR，或在过渡期由授权人员上传受控Excel模板。
3. MES登记接收/导入批次、来源版本和来源文件。
4. MES执行结构完整性、引用对象、字典项、单位精度和必填规则校验；引用对象至少包括工艺路线工序、BOM明细或物料、设备/工装/夹具、工艺参数或采集点位、检验方案/检验特性。
5. 校验通过后写入`pro_mbr_*`镜像表，建立PLM版本与MES镜像版本映射。
6. 校验失败时生成错误明细，不允许进入可执行状态。

### 3.1.1 MBR导入映射校验口径
1. MBR Header/Version必须明确产品、工厂、产线、BOM版本、工艺路线版本和PLM MBR版本。
2. MBR Phase必须能映射到有效工艺路线工序。
3. MBR Step必须归属Phase；若Step也携带工序引用，必须与所属Phase的工序一致。
4. MBR Step Material必须匹配BOM明细或物料；同一BOM项被多个工步引用时，数量汇总必须与BOM/工序发料数量受控匹配。
5. MBR Step Equipment必须匹配设备、工装或夹具；如工艺路线已定义工序资源，步骤设备不得脱离工序资源范围。
6. MBR Step Parameter必须匹配工艺参数或采集点位，参数编码、单位、上下限和采集方式必须可校验。
7. MBR Step Quality必须匹配检验方案、检验特性或质控项，判定标准、复核和签名要求必须可执行。
8. PLM MBR或Excel批导发现上游对象不存在、状态无效或版本不匹配时，只能生成导入错误或待确认项，不允许自动创建或修改BOM/工艺路线基准。

### 3.2 工单执行快照流程
1. SAP生产订单同步或MES创建工单时，系统匹配当前有效的PLM MBR镜像。
2. 工单下达时，MES将MBR镜像预编译为工单/批次执行快照。
3. 执行快照固化来源BOM版本、工艺路线版本、MBR版本、来源文件/来源映射、Phase/Step结构、Step物料、Step设备、Step参数、Step质控、签名、跳转、返工和Hold规则。
4. EBR执行引用执行快照，不实时读取PLM，也不随PLM后续改版自动变化。
5. 快照哈希、生成时间、来源版本和生成日志必须进入审计追踪。

### 3.3 PLM ECN影响运行中工单流程
1. PLM ECN审批通过并下发MES。
2. MES识别影响对象：产品、物料、MBR版本、工单、批次、工序和执行快照。
3. 对未开工工单，按新有效镜像重新匹配或阻断下达。
4. 对运行中工单，进入Safe Hold和上下文刷新机制，由QA/工艺确认是否刷新执行上下文或按原快照继续。
5. MES只执行PLM变更结果，不在MES内重新审批MBR主版本。

### 3.4 候选数据模型（待DBA治理评审）
- MBR导入控制：`pro_mbr_import_batch`、`pro_mbr_import_item`、`pro_mbr_import_validate_log`、`pro_mbr_import_error`。
- MBR来源文件与映射：`pro_mbr_source_file`、`pro_mbr_source_map`。
- 执行快照沿用：`pro_mbr_execution_context`、`pro_mbr_context_refresh_log`。
- MBR与上游基准的精确映射候选字段：`pro_mbr_step_material.bom_item_op_map_id`、`pro_mbr_step_equipment.op_res_id`、`pro_mbr_step_parameter.op_param_id`，是否落地由DBA按治理规范评审。
- 上述候选模型仅作为需求口径，字段字典和DDL必须由DBA按数据模型治理规范评审后落地。

## 4. 合规要求
1. MES不做MBR主版本审批、主版本发布、主版本冻结和SOP文档生命周期管理。
2. PLM已批准MBR进入MES后，必须通过结构完整性校验才可用于工单。
3. Excel批导是受控补充入口，必须留存文件、哈希、上传人、校验结果、审核状态和审计追踪。
4. 工单执行必须引用执行快照，EBR不可脱离MBR快照独立存在。
5. PLM ECN影响运行中工单时，必须进入Safe Hold和上下文刷新机制，不得无痕替换历史执行证据。

## 5. 与其他模块的关系
- PLM/文控 → MBR镜像（L9到L2，已批准结构化MBR接收）
- BOM + 工艺路线 → MBR镜像（L2层引用和校验基础；BOM/工艺路线维护工序级基准，MBR维护工步级执行明细）
- MBR镜像 → 生产订单（L4层，工单下达生成执行快照）
- MBR执行快照 → EBR步骤记录（L5层，执行固化）
- MBR步骤参数快照 → EBR参数记录（L5层，参数固化）
- MBR步骤质控快照 → 检验结果/电子签名（L6层）
- PLM ECN → Safe Hold/上下文刷新（L3/L0）
- MBR执行上下文 → 运行时韧性（L0层）
