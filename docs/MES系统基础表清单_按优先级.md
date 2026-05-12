# MES系统基础表清单（按优先级）

## 说明

本清单基于 MES + SAP 集成场景整理，用于作为后续开发基础表设计、模块排期和数据字典细化的基线。

表命名统一遵循 `D:\ruoyi_workplace\ruoyi-vue\docs\03_Database_Design.md`：生产模块表全部使用 `pro_` 前缀，并采用小写下划线命名。

分层口径：

- 架构分层使用 `L0-L10`：用于数据建模、模块边界、AI 渐进式加载和后续代码生成。
- 开发优先级使用 `P0/P1/P2/P0+...`：保留原来的排期口径，用于判断建设先后顺序。
- 后续新增表时，先判断属于哪个 `L` 架构层，再给出开发优先级，避免继续堆叠 `P0++` 这类难维护层级。

原开发优先级口径：

- P0 核心运行层：先保证主数据、BOM、工艺、工单、执行、基础投料和 SAP 主对象映射跑通。
- P1 增强协同层：补强替代/切换、工艺资源、质量、派工、报工明细、异常和接口消息。
- P2 高级追溯与接口运营层：按场景扩展仓储收货、深度追溯、谱系和接口回传闭环。
- P0++ MBR/EBR 与执行引擎域：补强 IVD 受控生产所需的 MBR 模板、步骤执行、规则联锁、电子批记录、电子签名和审计追踪。
- P1++ 工艺引擎增强预留域：预留仿真、人员资质、替代/委外工艺、ECN 明细和版本差异对比能力。
- P0+++ 数据采集与 ThingsBoard 最小闭环：打通 ThingsBoard 设备、采集点位、MES 设备、工单工序、批次、告警和电子批记录。
- P1+++ IVD 采集增强域：补强电子天平、OEE、清场和防混淆；条码/视觉由统一防错校验记录承接。
- P0++++ 运行时韧性与架构支撑域：补强 MBR 预编译、上下文刷新、事务外箱、幂等控制、死信隔离和集成补偿能力。

## 推荐架构分层（优化版）

### L0 运行时韧性与架构支撑层

定位：保护车间执行链路，承接 MBR 预编译、上下文刷新、事务外箱、幂等、防重、死信和集成补偿。

表清单：`pro_mbr_execution_context`、`pro_mbr_context_refresh_log`、`pro_transactional_outbox`、`pro_integration_reconcile_task`、`pro_idempotency_request`、`pro_dead_letter_message`

### L1 主数据与资源基础层

定位：定义工厂、组织、人员、物料、设备、仓储、班次、区域、公用工程等基础对象，是其他层的根数据。

表清单：`pro_plant_master`、`pro_workshop_master`、`pro_production_line_master`、`pro_work_center_master`、`pro_material_master`、`pro_equipment_master`、`pro_person_master`、`pro_work_center_person_map`、`pro_wc_equipment`、`pro_tooling_master`、`pro_fixture_master`、`pro_supplier_master`、`pro_warehouse_master`、`pro_storage_location_master`、`pro_shift`、`pro_calendar`、`pro_environment_area`、`pro_utility_system`、`pro_downtime_reason`、`pro_person_qualification`

### L2 产品、工艺与 MBR 模板层

定位：定义产品结构、BOM、工艺路线、检验方案、MBR 阶段、步骤、参数、物料、设备、质量项和复杂流转规则。

表清单：`pro_bom_header`、`pro_bom_item`、`pro_bom_item_operation_map`、`pro_bom_substitution_group`、`pro_bom_substitution_item`、`pro_bom_cutover_rule`、`pro_bom_cutover_execution_log`、`pro_routing_header`、`pro_routing_operation`、`pro_operation_relation`、`pro_operation_resource`、`pro_operation_parameter`、`pro_operation_document`、`pro_inspection_plan`、`pro_inspection_characteristic`、`pro_operation_inspection_map`、`pro_mbr_header`、`pro_mbr_version`、`pro_mbr_phase`、`pro_mbr_step`、`pro_mbr_step_parameter`、`pro_mbr_step_material`、`pro_mbr_step_equipment`、`pro_mbr_step_quality`、`pro_mbr_step_transition`、`pro_mbr_rework_rule`、`pro_mbr_dynamic_param_rule`、`pro_mbr_hold_rule`、`pro_mbr_step_person_role`、`pro_mbr_alternative_process_rule`、`pro_outsource_operation_rule`

### L3 执行规则、联锁与变更控制层

定位：把工艺模型转成可执行控制规则，并管理版本发布、工程变更、差异对比和运行中安全切换。

表清单：`pro_execution_rule`、`pro_interlock_rule`、`pro_interlock_event`、`pro_device_command_log`、`pro_error_proofing_record`、`pro_mbr_release_record`、`pro_mbr_change_record`、`pro_ecn_order`、`pro_ecn_affected_object`、`pro_mbr_version_diff`

### L4 计划订单与车间调度层

定位：承接生产订单、订单展开、排产计划、排产调整和派工，是执行层的上游入口。

表清单：`pro_production_order`、`pro_order_component`、`pro_order_operation`、`pro_schedule_plan`、`pro_schedule_log`、`pro_shop_floor_dispatch`

### L5 现场执行、称量与电子批记录层

定位：记录现场真实执行过程，包括工序执行、报工、人工设备投入、投退料、称量、清场、过程会话和 EBR 固化。

表清单：`pro_operation_execution`、`pro_production_report`、`pro_report_labor`、`pro_report_equipment`、`pro_operation_tracking`、`pro_operation_consumption`、`pro_operation_return`、`pro_weighing_record`、`pro_scale_device_check`、`pro_weighing_audit_log`、`pro_line_clearance_check`、`pro_batch_review`、`pro_ebr_header`、`pro_ebr_step_record`、`pro_ebr_param_record`、`pro_process_monitor_session`

### L6 质量异常与合规审计层

定位：承接检验结果、不良、异常、处置、电子签名和审计追踪，是 IVD 合规闭环的核心。

表清单：`pro_defect_code_master`、`pro_production_defect`、`pro_inspection_result`、`pro_nc_handling`、`pro_exception_record`、`pro_exception_category`、`pro_exception_escalation`、`pro_e_signature_record`、`pro_audit_trail`

### L7 OT/SCADA、环境公用与清洗冷链层

定位：承接 ThingsBoard/SCADA 设备、点位、关键采集值、告警、设备状态、OEE、环境、纯化水、冷链和 CIP/SIP 证据数据。

表清单：`pro_scada_system`、`pro_scada_device_ref`、`pro_equipment_scada_map`、`pro_scada_point`、`pro_operation_data_collect`、`pro_process_monitor_summary`、`pro_scada_alarm_event`、`pro_equipment_state_event`、`pro_oee_summary`、`pro_environment_monitor_record`、`pro_water_quality_record`、`pro_cold_chain_monitor_record`、`pro_cold_chain_alarm_notice`、`pro_cleaning_cycle`、`pro_cleaning_cycle_parameter`、`pro_cleaning_release_record`

### L8 追溯仓储与批次族谱层

定位：记录来料、批次、序列号、在制品、成品和批次/序列号谱系，用于正向追踪和反向召回。

表清单：`pro_material_lot`、`pro_goods_receipt`、`pro_goods_receipt_item`、`pro_serial_number`、`pro_wip_lot`、`pro_wip_lot_tracking`、`pro_finished_good_lot`、`pro_finished_good_serial`、`pro_lot_genealogy`、`pro_serial_genealogy`

### L9 企业集成与接口运营层

定位：定义 SAP 参考对象、SAP-MES 映射、接口消息和业务回传接口，运行时发送仍通过 L0 的 Outbox 解耦。

表清单：`pro_sap_system`、`pro_sap_plant_ref`、`pro_sap_material_ref`、`pro_sap_bom_ref`、`pro_sap_bom_item_ref`、`pro_sap_routing_ref`、`pro_sap_operation_ref`、`pro_sap_work_center_ref`、`pro_sap_production_order_ref`、`pro_sap_plant_map`、`pro_sap_material_map`、`pro_sap_bom_map`、`pro_sap_bom_item_map`、`pro_sap_routing_map`、`pro_sap_operation_map`、`pro_sap_work_center_map`、`pro_sap_production_order_map`、`pro_interface_message`、`pro_report_confirmation_if`、`pro_inspection_result_if`、`pro_consumption_posting_if`

### L10 仿真分析与持续优化层

定位：用于工艺仿真、产能评估、瓶颈分析、质量风险分析和后续持续优化，不阻塞主执行链路。

表清单：`pro_process_simulation_case`、`pro_process_simulation_result`

## 开发优先级明细（保留排期口径）

### P0 核心运行层

| 序号 | 表名 | 中文名称 | 业务域 | 主要用途 | 主键 |
|---:|---|---|---|---|---|
| 1 | `pro_plant_master` | 工厂主数据表 | 主数据域 | 定义工厂组织 | `plant_id` |
| 2 | `pro_workshop_master` | 车间主数据表 | 主数据域 | 定义工厂下车间 | `workshop_id` |
| 3 | `pro_production_line_master` | 产线主数据表 | 主数据域 | 定义车间下产线 | `line_id` |
| 4 | `pro_work_center_master` | 工作中心主数据表 | 主数据域 | 定义现场执行工作中心 | `work_center_id` |
| 5 | `pro_material_master` | 物料主数据表 | 主数据域 | 定义原料/半成品/成品 | `material_id` |
| 6 | `pro_bom_header` | BOM头表 | BOM域 | 定义产品 BOM 主体 | `bom_id` |
| 7 | `pro_bom_item` | BOM明细表 | BOM域 | 定义标准组件行 | `bom_item_id` |
| 8 | `pro_bom_item_operation_map` | BOM行项目工序映射表 | BOM域 | 定义组件在哪道工序投料 | `bom_item_op_map_id` |
| 9 | `pro_routing_header` | 工艺路线头表 | 工艺域 | 定义工艺路线模板 | `routing_id` |
| 10 | `pro_routing_operation` | 工艺工序表 | 工艺域 | 定义标准工序模板 | `operation_id` |
| 11 | `pro_production_order` | 生产工单头表 | 执行域 | 定义 MES 工单主体 | `prod_order_id` |
| 12 | `pro_order_component` | 工单组件表 | 执行域 | 建单时固化的计划组件清单 | `order_component_id` |
| 13 | `pro_order_operation` | 工单工序表 | 执行域 | 工单展开后的工序实例 | `order_op_id` |
| 14 | `pro_operation_execution` | 工序执行实例表 | 执行域 | 定义现场实际执行过程 | `op_exec_id` |
| 15 | `pro_production_report` | 报工表 | 执行域 | 记录工序执行结果 | `report_id` |
| 16 | `pro_material_lot` | 物料批次表 | 追溯域 | 定义物料批次对象 | `material_lot_id` |
| 17 | `pro_operation_consumption` | 工序投料表 | 追溯域 | 记录实际投料 | `op_consume_id` |
| 18 | `pro_sap_system` | SAP系统定义表 | 集成域 | 定义 SAP 系统环境 | `sap_system_id` |
| 19 | `pro_sap_plant_ref` | SAP工厂参考表 | 集成域 | SAP 工厂参考数据 | `sap_plant_ref_id` |
| 20 | `pro_sap_material_ref` | SAP物料参考表 | 集成域 | SAP 物料参考数据 | `sap_material_ref_id` |
| 21 | `pro_sap_bom_ref` | SAP BOM头参考表 | 集成域 | SAP BOM Header 参考数据 | `sap_bom_ref_id` |
| 22 | `pro_sap_bom_item_ref` | SAP BOM行参考表 | 集成域 | SAP BOM Item 参考数据 | `sap_bom_item_ref_id` |
| 23 | `pro_sap_routing_ref` | SAP工艺路线参考表 | 集成域 | SAP Routing 参考数据 | `sap_routing_ref_id` |
| 24 | `pro_sap_operation_ref` | SAP工序参考表 | 集成域 | SAP Operation 参考数据 | `sap_operation_ref_id` |
| 25 | `pro_sap_work_center_ref` | SAP工作中心参考表 | 集成域 | SAP Work Center 参考数据 | `sap_work_center_ref_id` |
| 26 | `pro_sap_production_order_ref` | SAP生产订单参考表 | 集成域 | SAP Production Order 参考数据 | `sap_prod_order_ref_id` |
| 27 | `pro_sap_plant_map` | SAP工厂映射表 | 集成域 | SAP 工厂与 MES 工厂映射 | `sap_plant_map_id` |
| 28 | `pro_sap_material_map` | SAP物料映射表 | 集成域 | SAP 物料与 MES 物料映射 | `sap_material_map_id` |
| 29 | `pro_sap_bom_map` | SAP BOM头映射表 | 集成域 | SAP BOM Header 与 MES BOM Header 映射 | `sap_bom_map_id` |
| 30 | `pro_sap_bom_item_map` | SAP BOM行映射表 | 集成域 | SAP BOM Item 与 MES BOM Item 映射 | `sap_bom_item_map_id` |
| 31 | `pro_sap_routing_map` | SAP工艺路线映射表 | 集成域 | SAP Routing 与 MES Routing 映射 | `sap_routing_map_id` |
| 32 | `pro_sap_operation_map` | SAP工序映射表 | 集成域 | SAP Operation 与 MES Operation 映射 | `sap_operation_map_id` |
| 33 | `pro_sap_work_center_map` | SAP工作中心映射表 | 集成域 | SAP Work Center 与 MES Work Center 映射 | `sap_wc_map_id` |
| 34 | `pro_sap_production_order_map` | SAP生产订单映射表 | 集成域 | SAP 生产订单与 MES 工单映射 | `sap_prod_order_map_id` |

### P1 增强协同层

| 序号 | 表名 | 中文名称 | 业务域 | 主要用途 | 主键 |
|---:|---|---|---|---|---|
| 1 | `pro_equipment_master` | 设备主数据表 | 主数据域 | 定义设备对象 | `equipment_id` |
| 2 | `pro_person_master` | 人员主数据表 | 主数据域 | 定义操作人员/检验人员 | `person_id` |
| 3 | `pro_work_center_person_map` | 工作中心人员关系表 | 主数据域 | 工作中心与人员关系 | `wc_person_map_id` |
| 4 | `pro_tooling_master` | 工装主数据表 | 工艺资源域 | 定义工装 | `tooling_id` |
| 5 | `pro_fixture_master` | 夹具主数据表 | 工艺资源域 | 定义夹具 | `fixture_id` |
| 6 | `pro_bom_substitution_group` | BOM替代组表 | BOM域 | 定义 BOM 行的替代规则组 | `bom_sub_group_id` |
| 7 | `pro_bom_substitution_item` | BOM替代料明细表 | BOM域 | 定义替代候选料、优先级、审批要求等 | `bom_sub_item_id` |
| 8 | `pro_bom_cutover_rule` | BOM切换规则表 | BOM域 | 定义旧料切换到新料的正式规则 | `cutover_rule_id` |
| 9 | `pro_bom_cutover_execution_log` | BOM切换执行日志表 | BOM域 | 记录订单/组件命中切换规则情况 | `cutover_exec_id` |
| 10 | `pro_operation_relation` | 工序关系表 | 工艺域 | 定义工序先后依赖 | `op_relation_id` |
| 11 | `pro_operation_resource` | 工序资源表 | 工艺域 | 定义工序所需资源 | `op_res_id` |
| 12 | `pro_operation_parameter` | 工序参数表 | 工艺域 | 定义工艺参数 | `op_param_id` |
| 13 | `pro_operation_document` | 工序文档表 | 工艺域 | 绑定作业指导书/图纸 | `op_doc_id` |
| 14 | `pro_inspection_plan` | 检验方案表 | 质量域 | 定义检验方案 | `insp_plan_id` |
| 15 | `pro_inspection_characteristic` | 检验特性表 | 质量域 | 定义检验项目/指标 | `insp_char_id` |
| 16 | `pro_operation_inspection_map` | 工序检验映射表 | 质量域 | 定义工序与检验特性的关系 | `op_insp_map_id` |
| 17 | `pro_shop_floor_dispatch` | 派工表 | 执行域 | 定义派工安排 | `dispatch_id` |
| 18 | `pro_report_labor` | 报工人工明细表 | 执行域 | 记录人工投入 | `report_labor_id` |
| 19 | `pro_report_equipment` | 报工设备明细表 | 执行域 | 记录设备投入 | `report_equipment_id` |
| 20 | `pro_defect_code_master` | 缺陷代码主数据表 | 质量域 | 定义缺陷代码 | `defect_code_id` |
| 21 | `pro_production_defect` | 生产不良表 | 质量域 | 记录不良明细 | `prod_defect_id` |
| 22 | `pro_inspection_result` | 检验结果表 | 质量域 | 记录现场检验结果 | `insp_result_id` |
| 23 | `pro_operation_tracking` | 工序跟踪表 | 执行域 | 记录工序执行留痕 | `op_track_id` |
| 24 | `pro_operation_return` | 工序退料表 | 追溯域 | 记录工序退料 | `op_return_id` |
| 25 | `pro_interface_message` | 接口消息主表 | 集成域 | 统一记录接口消息 | `interface_msg_id` |

### P2 高级追溯与接口运营层

| 序号 | 表名 | 中文名称 | 业务域 | 主要用途 | 主键 |
|---:|---|---|---|---|---|
| 1 | `pro_supplier_master` | 供应商主数据表 | 主数据域 | 定义供应商 | `supplier_id` |
| 2 | `pro_warehouse_master` | 仓库主数据表 | 主数据域 | 定义仓库 | `warehouse_id` |
| 3 | `pro_storage_location_master` | 库位主数据表 | 主数据域 | 定义库存地点/库位 | `storage_location_id` |
| 4 | `pro_goods_receipt` | 收货单头表 | 追溯域 | 记录来料收货 | `gr_id` |
| 5 | `pro_goods_receipt_item` | 收货单明细表 | 追溯域 | 记录收货物料明细 | `gr_item_id` |
| 6 | `pro_serial_number` | 物料序列号表 | 追溯域 | 定义物料序列号对象 | `serial_id` |
| 7 | `pro_wip_lot` | 在制品批次表 | 追溯域 | 记录在制品批次 | `wip_lot_id` |
| 8 | `pro_wip_lot_tracking` | 在制品批次跟踪表 | 追溯域 | 记录在制流转 | `wip_track_id` |
| 9 | `pro_finished_good_lot` | 成品批次表 | 追溯域 | 记录成品批次 | `fg_lot_id` |
| 10 | `pro_finished_good_serial` | 成品序列号表 | 追溯域 | 记录成品序列号 | `fg_serial_id` |
| 11 | `pro_lot_genealogy` | 批次族谱表 | 追溯域 | 记录批次来源/去向关系 | `lot_genealogy_id` |
| 12 | `pro_serial_genealogy` | 序列号族谱表 | 追溯域 | 记录序列号来源/去向关系 | `serial_genealogy_id` |
| 13 | `pro_report_confirmation_if` | 报工确认接口表 | 集成域 | MES 报工回传 SAP | `report_if_id` |
| 14 | `pro_inspection_result_if` | 检验结果接口表 | 集成域 | MES 检验结果回传 SAP | `insp_if_id` |
| 15 | `pro_consumption_posting_if` | 投料过账接口表 | 集成域 | MES 投料回传 SAP | `consume_if_id` |

### P0+ 补充核心表（需求文档驱动）

> 以下表根据需求文档分析补充，覆盖排产、电子批记录、异常管理三个模块的核心功能。

| 序号 | 表名 | 中文名称 | 业务域 | 主要用途 | 主键 | 对应需求 |
|---:|---|---|---|---|---|---|
| 1 | `pro_shift` | 班次主数据表 | 主数据域 | 定义班次（早/中/晚班） | `shift_id` | 排产/报工依赖 |
| 2 | `pro_calendar` | 生产日历表 | 主数据域 | 定义工作日/非工作日/节假日 | `calendar_id` | REQ-SCH-003 |
| 3 | `pro_schedule_plan` | 排产计划表 | 排产域 | 记录排产计划主体 | `plan_id` | REQ-SCH-003/005/008 |
| 4 | `pro_schedule_log` | 排产调整日志表 | 排产域 | 记录排产调整留痕 | `log_id` | REQ-SCH-005/008 |
| 5 | `pro_batch_review` | 批记录审核流程表 | 执行域 | 记录批记录审核节点 | `review_id` | REQ-EBR-007 |
| 6 | `pro_exception_category` | 异常分类配置表 | 执行域 | 定义异常分类（设备/工艺/质量等） | `category_id` | REQ-EXC-008 |
| 7 | `pro_exception_escalation` | 异常升级记录表 | 执行域 | 记录异常升级过程 | `escalation_id` | REQ-EXC-004 |
| 8 | `pro_wc_equipment` | 工作中心设备关系表 | 主数据域 | 工作中心与设备多对多关系 | `id` | 设备资源建模 |
| 9 | `pro_nc_handling` | 不合格品处置表 | 质量域 | 记录不合格品处置闭环 | `handling_id` | 质量闭环 |
| 10 | `pro_exception_record` | 异常记录主表 | 异常管理域 | 统一记录生产、质量、设备、物料、环境、称量等异常实例 | `exception_id` | 异常闭环 |

### P0++ MBR/EBR 与执行引擎域（IVD受控执行增强）

> 以下表用于把 MES 从“工单、工序、报工”升级为可支撑 IVD 配方执行、电子批记录、规则防错、设备联动和审计追踪的受控制造执行系统。

| 序号 | 表名 | 中文名称 | 业务域 | 主要用途 | 主键 | 对应能力 |
|---:|---|---|---|---|---|---|
| 1 | `pro_mbr_header` | 主批生产记录模板头表 | MBR模板域 | 定义 MBR 模板主体，关联产品、BOM、工艺路线和适用范围 | `mbr_id` | 多层级建模 |
| 2 | `pro_mbr_version` | MBR版本表 | MBR模板域 | 管理 MBR 不同版本、状态、生效范围和批准状态 | `mbr_version_id` | 版本与变更 |
| 3 | `pro_mbr_phase` | MBR阶段表 | MBR模板域 | 定义配液、孵育、灌装、包装、清洗等阶段 | `phase_id` | 工艺层级深度 |
| 4 | `pro_mbr_step` | MBR步骤表 | MBR模板域 | 定义阶段下的具体操作步骤，是电子批记录的最小执行单元 | `step_id` | 工艺层级深度 |
| 5 | `pro_mbr_step_parameter` | MBR步骤参数表 | MBR模板域 | 定义步骤所需温度、转速、时间、重量、压力等控制参数 | `step_param_id` | 工艺-执行联动 |
| 6 | `pro_mbr_step_material` | MBR步骤物料表 | MBR模板域 | 定义步骤需要投放或确认的物料、批次要求和允许偏差 | `step_material_id` | 投料防错 |
| 7 | `pro_mbr_step_equipment` | MBR步骤设备表 | MBR模板域 | 定义步骤所需设备、电子天平、传感器、工装和夹具 | `step_equipment_id` | 设备联动 |
| 8 | `pro_mbr_step_quality` | MBR步骤质控表 | MBR模板域 | 定义步骤级检验、复核、确认和放行要求 | `step_quality_id` | 质量闭环 |
| 9 | `pro_execution_rule` | 执行规则表 | 执行引擎域 | 定义工序或步骤的防错、校验、放行和阻断规则 | `exec_rule_id` | 独立工艺引擎 |
| 10 | `pro_interlock_rule` | 联锁规则表 | 执行引擎域 | 定义设备、物料、称量、环境、参数的启动或放行条件 | `interlock_rule_id` | 规则联锁 |
| 11 | `pro_interlock_event` | 联锁事件表 | 执行引擎域 | 记录联锁触发、阻断、解除和人工干预过程 | `interlock_event_id` | 联锁留痕 |
| 12 | `pro_device_command_log` | 设备指令日志表 | 执行引擎域 | 记录 MES 向设备、ThingsBoard、PLC 或网关下发的指令 | `command_log_id` | 设备联动 |
| 13 | `pro_error_proofing_record` | 防错校验记录表 | 执行引擎域 | 统一记录扫码、视觉、称量、设备状态、物料匹配等防错校验结果 | `proofing_record_id` | 防错执行 |
| 14 | `pro_mbr_step_transition` | MBR步骤流转规则表 | 复杂工艺域 | 定义步骤之间的顺序、分支、跳转、并行、合流和条件流转 | `transition_id` | 复杂工艺支持 |
| 15 | `pro_mbr_rework_rule` | MBR返工规则表 | 复杂工艺域 | 定义哪些步骤允许返工、返工条件、返工目标步骤和审批要求 | `rework_rule_id` | 返工工艺 |
| 16 | `pro_mbr_dynamic_param_rule` | 动态参数规则表 | 复杂工艺域 | 根据批量、物料批次、效价、温度、设备状态等动态计算参数 | `dynamic_rule_id` | 动态工艺控制 |
| 17 | `pro_mbr_hold_rule` | 暂停待复核规则表 | 复杂工艺域 | 定义偏差、超限、设备异常、环境异常时如何暂停或 Hold 批次 | `hold_rule_id` | 异常闭环 |
| 18 | `pro_mbr_release_record` | MBR发布记录表 | 版本审计域 | 记录 MBR 版本发布、启用、停用、作废和放行过程 | `release_id` | 版本生命周期 |
| 19 | `pro_mbr_change_record` | MBR变更记录表 | 版本审计域 | 记录 MBR 变更来源、审批过程、影响范围和生效情况 | `mbr_change_id` | 变更追溯 |
| 20 | `pro_ebr_header` | 电子批记录头表 | EBR记录域 | 记录工单实际执行生成的电子批记录主体 | `ebr_id` | 电子批记录 |
| 21 | `pro_ebr_step_record` | EBR步骤记录表 | EBR记录域 | 记录并固化每个 MBR Step 的实际开始、结束、执行人、设备、状态和复核结果 | `ebr_step_id` | 批记录固化 |
| 22 | `pro_ebr_param_record` | EBR参数记录表 | EBR记录域 | 固化实际温度、转速、重量、时间、压力、采集值等关键参数 | `ebr_param_id` | 参数追溯 |
| 23 | `pro_e_signature_record` | 电子签名记录表 | 合规审计域 | 记录执行、复核、审核、放行、驳回等电子签名 | `signature_id` | 电子签名 |
| 24 | `pro_audit_trail` | 审计追踪表 | 合规审计域 | 记录关键数据新增、修改、删除、复核、驳回、放行等审计事件 | `audit_trail_id` | 审计追踪 |

### P1++ 工艺引擎增强预留域（仿真/资质/ECN扩展）

> 以下表用于补足可仿真、人员资质约束、替代/委外工艺、ECN 明细和版本差异对比能力，可在 MBR/EBR 核心表落地后分阶段建设。

| 序号 | 表名 | 中文名称 | 业务域 | 主要用途 | 主键 | 对应能力 |
|---:|---|---|---|---|---|---|
| 1 | `pro_process_simulation_case` | 工艺仿真方案表 | 工艺仿真域 | 定义工艺路线、MBR版本、批量、设备、班次等仿真输入方案 | `simulation_case_id` | 可仿真 |
| 2 | `pro_process_simulation_result` | 工艺仿真结果表 | 工艺仿真域 | 记录仿真后的产能、节拍、瓶颈、质量风险和资源冲突结果 | `simulation_result_id` | 可仿真 |
| 3 | `pro_mbr_step_person_role` | MBR步骤人员角色要求表 | MBR模板域 | 定义步骤需要的操作员、复核员、QA、设备员等角色和人数 | `step_person_role_id` | 人员约束 |
| 4 | `pro_person_qualification` | 人员资质表 | 主数据域 | 记录人员可执行的岗位、工序、设备、洁净区和有效期 | `qualification_id` | 人员资质 |
| 5 | `pro_mbr_alternative_process_rule` | 替代工艺规则表 | 复杂工艺域 | 定义可替代的工艺路线、阶段、步骤和启用条件 | `alt_process_rule_id` | 替代工艺 |
| 6 | `pro_outsource_operation_rule` | 委外工序规则表 | 复杂工艺域 | 定义工序或步骤委外执行的供应商、质量要求和接收规则 | `outsource_rule_id` | 委外工艺 |
| 7 | `pro_ecn_order` | 工程变更通知单表 | 变更管理域 | 作为统一工程变更主表，管理正式 ECN 单据、来源、审批、变更类型和生效策略 | `ecn_id` | ECN集成 |
| 8 | `pro_ecn_affected_object` | ECN影响对象表 | 变更管理域 | 记录 ECN 影响的 BOM、Routing、MBR、物料、设备、检验方案等对象 | `ecn_object_id` | 影响分析 |
| 9 | `pro_mbr_version_diff` | MBR版本差异对比表 | 版本审计域 | 记录 MBR 新旧版本在阶段、步骤、参数、物料、设备和质量项上的差异 | `version_diff_id` | 差异对比 |

### P0+++ 数据采集与 ThingsBoard 最小闭环

> 以下表用于预留 ThingsBoard CE 作为 SCADA/IIoT 平台时的集成能力。设计边界是：ThingsBoard 保存高频原始遥测和实时规则，MES 固化与工单、工序、批次、质量、异常和电子批记录相关的关键证据数据。

| 序号 | 表名 | 中文名称 | 业务域 | 主要用途 | 主键 | 对应能力 |
|---:|---|---|---|---|---|---|
| 1 | `pro_scada_system` | SCADA系统定义表 | 数据采集域 | 定义 ThingsBoard 系统、访问地址、认证方式和启用状态 | `scada_system_id` | 系统接入 |
| 2 | `pro_scada_device_ref` | SCADA设备参考表 | 数据采集域 | 保存 ThingsBoard 设备ID、设备名、设备类型和同步状态 | `scada_device_ref_id` | 设备同步 |
| 3 | `pro_equipment_scada_map` | MES设备SCADA映射表 | 数据采集域 | 建立 MES 设备与 ThingsBoard 设备之间的绑定关系 | `equipment_scada_map_id` | 设备映射 |
| 4 | `pro_scada_point` | SCADA采集点位表 | 数据采集域 | 定义 telemetry key、单位、数据类型、采样频率和上下限 | `scada_point_id` | 点位建模 |
| 5 | `pro_operation_data_collect` | 工序采集结果表 | 数据采集域 | 固化与工单、工序、批次、设备相关的关键采集值 | `collect_id` | 采集固化 |
| 6 | `pro_weighing_record` | 投料称量记录表 | 称量域 | 记录电子天平称量目标值、实际值、允差、复核和放行结果 | `weighing_id` | 电子称量 |
| 7 | `pro_process_monitor_session` | 过程监控会话表 | 过程监控域 | 表达一次配液、孵育、清洗、冷链等过程监控实例 | `monitor_session_id` | 过程监控 |
| 8 | `pro_process_monitor_summary` | 过程监控摘要表 | 过程监控域 | 保存最大值、最小值、均值、超限时长和曲线链接 | `monitor_summary_id` | 曲线摘要 |
| 9 | `pro_scada_alarm_event` | SCADA告警事件表 | 数据采集域 | 保存 ThingsBoard 告警事件，并关联 MES 异常、工单和批次 | `scada_alarm_event_id` | 告警闭环 |

### P1+++ IVD核心工艺采集增强域

> 以下表用于覆盖 IVD 生产中的称量合规、灌装线 OEE、微停机分析和清场防混淆。条码防错和视觉校验统一由 `pro_error_proofing_record` 承接。

| 序号 | 表名 | 中文名称 | 业务域 | 主要用途 | 主键 | 对应能力 |
|---:|---|---|---|---|---|---|
| 1 | `pro_scale_device_check` | 电子天平点检校准记录表 | 称量域 | 记录电子天平使用前点检、校准状态、有效期和判定结果 | `scale_check_id` | 称量合规 |
| 2 | `pro_weighing_audit_log` | 称量审计日志表 | 称量域 | 记录称量修改、复核、驳回、异常处理和电子签名留痕 | `weighing_audit_id` | 称量审计 |
| 3 | `pro_equipment_state_event` | 设备状态事件表 | 设备采集域 | 记录 Run、Stop、Alarm、微停机和设备状态切换过程 | `state_event_id` | 设备状态 |
| 4 | `pro_downtime_reason` | 停机原因字典表 | 设备采集域 | 定义缺盖、卡瓶、缺标签、设备故障等停机原因 | `downtime_reason_id` | 停机分析 |
| 5 | `pro_oee_summary` | OEE汇总表 | 设备采集域 | 汇总稼动率、性能、良率、OEE、停机次数和停机时长 | `oee_summary_id` | OEE分析 |
| 6 | `pro_line_clearance_check` | 清场检查记录表 | 防混淆域 | 支撑换批、换品种、首件尾件确认和防混淆检查 | `clearance_check_id` | 清场防错 |

### P1++++ 环境、公用工程、冷链、CIP/SIP采集域

> 以下表用于覆盖洁净区环境监测、纯化水、冷链资产和清洗灭菌过程。原则上高频原始数据仍保留在 ThingsBoard，MES 固化批记录、放行、偏差和审计需要的数据。

| 序号 | 表名 | 中文名称 | 业务域 | 主要用途 | 主键 | 对应能力 |
|---:|---|---|---|---|---|---|
| 1 | `pro_environment_area` | 环境监控区域表 | 环境监控域 | 定义洁净区、走廊、缓冲间、冷库、称量间等受控区域 | `environment_area_id` | 区域建模 |
| 2 | `pro_environment_monitor_record` | 环境监测记录表 | 环境监控域 | 固化温度、湿度、压差、粒子数等关键环境数据 | `environment_record_id` | EMS监控 |
| 3 | `pro_utility_system` | 公用工程系统表 | 公用工程域 | 定义纯化水、压缩空气、真空、蒸汽等公用工程系统 | `utility_system_id` | 公用工程 |
| 4 | `pro_water_quality_record` | 纯化水质量记录表 | 公用工程域 | 固化电导率、TOC、水温、流速等纯化水质量数据 | `water_quality_record_id` | 水质追溯 |
| 5 | `pro_cold_chain_monitor_record` | 冷链监控记录表 | 冷链域 | 固化冰箱、冷库、冷柜、运输箱等冷链温度数据 | `cold_chain_record_id` | 冷链监控 |
| 6 | `pro_cold_chain_alarm_notice` | 冷链报警通知表 | 冷链域 | 记录冷链报警通知人、通知方式、通知时间和响应结果 | `cold_chain_notice_id` | 报警通知 |
| 7 | `pro_cleaning_cycle` | 清洗灭菌周期表 | 清洗灭菌域 | 表达一次 CIP/SIP 清洗或灭菌过程的开始、结束和状态 | `cleaning_cycle_id` | CIP/SIP过程 |
| 8 | `pro_cleaning_cycle_parameter` | 清洗灭菌参数记录表 | 清洗灭菌域 | 保存温度、流速、电导率、压力、持续时间等清洗灭菌参数 | `cleaning_param_id` | 清洗曲线 |
| 9 | `pro_cleaning_release_record` | 清洗灭菌放行记录表 | 清洗灭菌域 | 保存清洗结果、复核人、放行结论和偏差关联 | `cleaning_release_id` | 清洗放行 |

### P0++++ 运行时韧性与架构支撑域

> 以下表不是普通业务对象，而是为高并发车间执行、SAP 异步集成、ThingsBoard/SCADA 数据分层和洁净区弱网络环境提供运行时保护。设计目标是避免 MBR 实时联表解析、运行中 ECN 上下文脑裂、SAP 反向阻塞产线、重复提交和失败消息污染核心执行链路。

| 序号 | 表名 | 中文名称 | 业务域 | 主要用途 | 主键 | 对应能力 |
|---:|---|---|---|---|---|---|
| 1 | `pro_mbr_execution_context` | MBR执行上下文表 | 运行时支撑域 | 保存工单下达时预编译后的 MBR 规则快照、步骤状态机、版本哈希和缓存键 | `context_id` | MBR预编译 |
| 2 | `pro_mbr_context_refresh_log` | MBR执行上下文刷新日志表 | 运行时支撑域 | 记录 ECN、返工、Hold恢复等触发的上下文失效、重编译、切换和失败过程 | `refresh_log_id` | Safe Hold刷新 |
| 3 | `pro_transactional_outbox` | 事务外箱事件表 | 运行时支撑域 | 在 MES 本地事务内记录待异步发布的 SAP、WMS、SCADA、OA 等集成事件 | `outbox_id` | 异步解耦 |
| 4 | `pro_integration_reconcile_task` | 集成对账补偿任务表 | 运行时支撑域 | 记录 SAP/WMS 等外部系统失败后的重发、冲销、人工补偿和对账闭环 | `reconcile_task_id` | 负反馈补偿 |
| 5 | `pro_idempotency_request` | 幂等请求记录表 | 运行时支撑域 | 记录客户端请求唯一键，防止弱网络下重复投料、重复报工、重复签名 | `idempotency_id` | 幂等控制 |
| 6 | `pro_dead_letter_message` | 死信消息表 | 运行时支撑域 | 隔离多次重试失败的接口消息、设备事件和异步任务，避免阻塞主流程 | `dead_letter_id` | 失败隔离 |

## 数量统计

### 架构分层统计

| 架构层 | 表数量 |
|---|---:|
| L0 运行时韧性与架构支撑层 | 6 |
| L1 主数据与资源基础层 | 20 |
| L2 产品、工艺与 MBR 模板层 | 31 |
| L3 执行规则、联锁与变更控制层 | 10 |
| L4 计划订单与车间调度层 | 6 |
| L5 现场执行、称量与电子批记录层 | 16 |
| L6 质量异常与合规审计层 | 9 |
| L7 OT/SCADA、环境公用与清洗冷链层 | 16 |
| L8 追溯仓储与批次族谱层 | 10 |
| L9 企业集成与接口运营层 | 21 |
| L10 仿真分析与持续优化层 | 2 |
| 合计 | 147 |

### 开发优先级统计

| 开发优先级 | 表数量 |
|---|---:|
| P0 核心运行层 | 34 |
| P1 增强协同层 | 25 |
| P2 高级追溯与接口运营层 | 15 |
| P0+ 补充核心表 | 10 |
| P0++ MBR/EBR 与执行引擎域 | 24 |
| P1++ 工艺引擎增强预留域 | 9 |
| P0+++ 数据采集与 ThingsBoard 最小闭环 | 9 |
| P1+++ IVD核心工艺采集增强域 | 6 |
| P1++++ 环境、公用工程、冷链、CIP/SIP采集域 | 9 |
| P0++++ 运行时韧性与架构支撑域 | 6 |
| 合计 | 147 |
