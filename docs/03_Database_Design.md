# 数据库设计规范
## 1. 设计总规范
- 完全遵循RuoYi数据库命名规范，表名采用下划线小写格式
- 所有生产模块表名统一前缀为`pro_`，与现有系统表隔离
- 所有表必须包含以下审计字段：
  - `del_flag char(1) default '0'`：逻辑删除标识（0存在 2删除）
  - `create_by varchar(64) default ''`：创建人
  - `create_time timestamp`：创建时间
  - `update_by varchar(64) default ''`：更新人
  - `update_time timestamp`：更新时间
- 核心业务字段必须建立索引，保证查询性能
- 生产数据按月分表，历史数据归档策略：超过1年的历史数据自动归档到归档库

---

## 2. 架构分层体系（L0-L10）

本项目采用 L0-L10 十一层架构分层体系，同时保留 P0~P0++++ 十级开发优先级用于排期。

| 架构层 | 定位 | 表数量 |
|--------|------|:------:|
| L0 运行时韧性与架构支撑层 | 保护车间执行链路，承接MBR预编译、上下文刷新、事务外箱、幂等、防重、死信和集成补偿 | 6 |
| L1 主数据与资源基础层 | 定义工厂、组织、人员、物料、设备、仓储、班次、区域、公用工程等基础对象 | 20 |
| L2 产品、工艺与MBR模板层 | 定义产品结构、BOM、工艺路线、检验方案、MBR阶段、步骤、参数、物料、设备、质量项和复杂流转规则 | 31 |
| L3 执行规则、联锁与变更控制层 | 把工艺模型转成可执行控制规则，并管理版本发布、工程变更、差异对比和运行中安全切换 | 10 |
| L4 计划订单与车间调度层 | 承接生产订单、订单展开、排产计划、排产调整和派工 | 6 |
| L5 现场执行、称量与电子批记录层 | 记录现场真实执行过程，包括工序执行、报工、投退料、称量、清场、过程会话和EBR固化 | 16 |
| L6 质量异常与合规审计层 | 承接检验结果、不良、异常、处置、电子签名和审计追踪 | 9 |
| L7 OT/SCADA、环境公用与清洗冷链层 | 承接ThingsBoard/SCADA设备、点位、关键采集值、告警、设备状态、OEE、环境、纯化水、冷链和CIP/SIP | 16 |
| L8 追溯仓储与批次族谱层 | 记录来料、批次、序列号、在制品、成品和批次/序列号谱系 | 10 |
| L9 企业集成与接口运营层 | 定义SAP参考对象、SAP-MES映射、接口消息和业务回传接口 | 21 |
| L10 仿真分析与持续优化层 | 工艺仿真、产能评估、瓶颈分析、质量风险分析 | 2 |
| **合计** | | **147** |

### 2.1 开发优先级对照

| 开发优先级 | 表数量 | 说明 |
|-----------|:------:|------|
| P0 核心运行层 | 34 | 主数据、BOM、工艺、工单、执行、投料、SAP参考/映射 |
| P1 增强协同层 | 25 | 设备、人员、工装、替代料、检验、派工、不良、接口消息 |
| P2 高级追溯与接口运营层 | 15 | 供应商、仓库、收货、序列号、WIP、成品、族谱、接口回传 |
| P0+ 补充核心表 | 10 | 班次、日历、排产、批审核、异常分类、不合格品处置 |
| P0++ MBR/EBR与执行引擎域 | 24 | MBR模板、步骤、执行规则、联锁、防错、EBR、电子签名、审计追踪 |
| P1++ 工艺引擎增强预留域 | 9 | 仿真、人员资质、替代/委外工艺、ECN、版本差异 |
| P0+++ 数据采集与ThingsBoard最小闭环 | 9 | SCADA系统、设备映射、采集点位、称量、过程监控、告警 |
| P1+++ IVD核心工艺采集增强域 | 6 | 天平点检、称量审计、设备状态、停机原因、OEE、清场 |
| P1++++ 环境/公用/冷链/CIP/SIP采集域 | 9 | 环境区域、环境监测、公用工程、纯化水、冷链、清洗灭菌 |
| P0++++ 运行时韧性与架构支撑域 | 6 | MBR上下文、Outbox、对账补偿、幂等、死信 |
| **合计** | **147** | |

---

## 3. 核心表清单（按L层分组）

### L0 运行时韧性与架构支撑层（6张）
| 表名 | 中文名称 | 主键 | 主要用途 |
|------|----------|------|----------|
| `pro_mbr_execution_context` | MBR执行上下文表 | `context_id` | MBR预编译快照、步骤状态机、版本哈希 |
| `pro_mbr_context_refresh_log` | MBR执行上下文刷新日志表 | `refresh_log_id` | ECN/返工/Hold恢复触发的上下文刷新 |
| `pro_transactional_outbox` | 事务外箱事件表 | `outbox_id` | 本地事务内记录待异步发布的集成事件 |
| `pro_integration_reconcile_task` | 集成对账补偿任务表 | `reconcile_task_id` | 外部系统失败后的重发、冲销、人工补偿 |
| `pro_idempotency_request` | 幂等请求记录表 | `idempotency_id` | 防止弱网络下重复提交 |
| `pro_dead_letter_message` | 死信消息表 | `dead_letter_id` | 隔离多次重试失败的消息 |

### L1 主数据与资源基础层（20张）
| 表名 | 中文名称 | 主键 | 主要用途 |
|------|----------|------|----------|
| `pro_plant_master` | 工厂主数据表 | `plant_id` | 定义工厂组织 |
| `pro_workshop_master` | 车间主数据表 | `workshop_id` | 定义工厂下车间 |
| `pro_production_line_master` | 产线主数据表 | `line_id` | 定义车间下产线 |
| `pro_work_center_master` | 工作中心主数据表 | `work_center_id` | 定义现场执行工作中心 |
| `pro_material_master` | 物料主数据表 | `material_id` | 定义原料/半成品/成品 |
| `pro_equipment_master` | 设备主数据表 | `equipment_id` | 定义设备对象 |
| `pro_person_master` | 人员主数据表 | `person_id` | 定义操作人员/检验人员 |
| `pro_work_center_person_map` | 工作中心人员关系表 | `wc_person_map_id` | 工作中心与人员关系 |
| `pro_wc_equipment` | 工作中心设备关系表 | `id` | 工作中心与设备多对多 |
| `pro_tooling_master` | 工装主数据表 | `tooling_id` | 定义工装 |
| `pro_fixture_master` | 夹具主数据表 | `fixture_id` | 定义夹具 |
| `pro_supplier_master` | 供应商主数据表 | `supplier_id` | 定义供应商 |
| `pro_warehouse_master` | 仓库主数据表 | `warehouse_id` | 定义仓库 |
| `pro_storage_location_master` | 库位主数据表 | `storage_location_id` | 定义库存地点/库位 |
| `pro_shift` | 班次主数据表 | `shift_id` | 定义班次（早/中/晚班） |
| `pro_calendar` | 生产日历表 | `calendar_id` | 定义工作日/非工作日/节假日 |
| `pro_environment_area` | 环境监控区域表 | `environment_area_id` | 定义洁净区、走廊、缓冲间等受控区域 |
| `pro_utility_system` | 公用工程系统表 | `utility_system_id` | 定义纯化水、压缩空气等公用工程系统 |
| `pro_downtime_reason` | 停机原因字典表 | `downtime_reason_id` | 定义缺盖、卡瓶、设备故障等停机原因 |
| `pro_person_qualification` | 人员资质表 | `qualification_id` | 记录人员可执行的岗位、工序、设备、有效期 |

### L2 产品、工艺与MBR模板层（31张）
| 表名 | 中文名称 | 主键 | 主要用途 |
|------|----------|------|----------|
| `pro_bom_header` | BOM头表 | `bom_id` | 定义产品BOM主体 |
| `pro_bom_item` | BOM明细表 | `bom_item_id` | 定义标准组件行 |
| `pro_bom_item_operation_map` | BOM行项目工序映射表 | `bom_item_op_map_id` | 定义组件在哪道工序投料 |
| `pro_bom_substitution_group` | BOM替代组表 | `bom_sub_group_id` | 定义BOM行的替代规则组 |
| `pro_bom_substitution_item` | BOM替代料明细表 | `bom_sub_item_id` | 定义替代候选料、优先级 |
| `pro_bom_cutover_rule` | BOM切换规则表 | `cutover_rule_id` | 定义旧料切换到新料的规则 |
| `pro_bom_cutover_execution_log` | BOM切换执行日志表 | `cutover_exec_id` | 记录订单/组件命中切换规则 |
| `pro_routing_header` | 工艺路线头表 | `routing_id` | 定义工艺路线模板 |
| `pro_routing_operation` | 工艺工序表 | `operation_id` | 定义标准工序模板 |
| `pro_operation_relation` | 工序关系表 | `op_relation_id` | 定义工序先后依赖 |
| `pro_operation_resource` | 工序资源表 | `op_res_id` | 定义工序所需资源 |
| `pro_operation_parameter` | 工序参数表 | `op_param_id` | 定义工艺参数 |
| `pro_operation_document` | 工序文档表 | `op_doc_id` | 绑定作业指导书/图纸 |
| `pro_inspection_plan` | 检验方案表 | `insp_plan_id` | 定义检验方案 |
| `pro_inspection_characteristic` | 检验特性表 | `insp_char_id` | 定义检验项目/指标 |
| `pro_operation_inspection_map` | 工序检验映射表 | `op_insp_map_id` | 定义工序与检验特性的关系 |
| `pro_mbr_header` | 主批生产记录模板头表 | `mbr_id` | 定义MBR模板主体 |
| `pro_mbr_version` | MBR版本表 | `mbr_version_id` | 管理MBR不同版本、状态 |
| `pro_mbr_phase` | MBR阶段表 | `phase_id` | 定义配液、孵育、灌装等阶段 |
| `pro_mbr_step` | MBR步骤表 | `step_id` | 定义阶段下的具体操作步骤 |
| `pro_mbr_step_parameter` | MBR步骤参数表 | `step_param_id` | 定义步骤所需控制参数 |
| `pro_mbr_step_material` | MBR步骤物料表 | `step_material_id` | 定义步骤需要投放的物料 |
| `pro_mbr_step_equipment` | MBR步骤设备表 | `step_equipment_id` | 定义步骤所需设备 |
| `pro_mbr_step_quality` | MBR步骤质控表 | `step_quality_id` | 定义步骤级检验、复核要求 |
| `pro_mbr_step_transition` | MBR步骤流转规则表 | `transition_id` | 定义步骤间顺序、分支、跳转 |
| `pro_mbr_rework_rule` | MBR返工规则表 | `rework_rule_id` | 定义返工条件、目标步骤 |
| `pro_mbr_dynamic_param_rule` | 动态参数规则表 | `dynamic_rule_id` | 根据批量/物料等动态计算参数 |
| `pro_mbr_hold_rule` | 暂停待复核规则表 | `hold_rule_id` | 定义偏差/超限时的Hold规则 |
| `pro_mbr_step_person_role` | MBR步骤人员角色要求表 | `step_person_role_id` | 定义步骤需要的角色和人数 |
| `pro_mbr_alternative_process_rule` | 替代工艺规则表 | `alt_process_rule_id` | 定义可替代的工艺路线 |
| `pro_outsource_operation_rule` | 委外工序规则表 | `outsource_rule_id` | 定义委外执行的供应商和要求 |

### L3 执行规则、联锁与变更控制层（10张）
| 表名 | 中文名称 | 主键 | 主要用途 |
|------|----------|------|----------|
| `pro_execution_rule` | 执行规则表 | `exec_rule_id` | 定义防错、校验、放行和阻断规则 |
| `pro_interlock_rule` | 联锁规则表 | `interlock_rule_id` | 定义设备/物料/称量的启动或放行条件 |
| `pro_interlock_event` | 联锁事件表 | `interlock_event_id` | 记录联锁触发、阻断、解除过程 |
| `pro_device_command_log` | 设备指令日志表 | `command_log_id` | 记录MES向设备下发的指令 |
| `pro_error_proofing_record` | 防错校验记录表 | `proofing_record_id` | 统一记录扫码/视觉/称量等防错结果 |
| `pro_mbr_release_record` | MBR发布记录表 | `release_id` | 记录MBR版本发布、启用、停用 |
| `pro_mbr_change_record` | MBR变更记录表 | `mbr_change_id` | 记录MBR变更来源、审批、影响范围 |
| `pro_ecn_order` | 工程变更通知单表 | `ecn_id` | 管理正式ECN单据、审批、生效策略 |
| `pro_ecn_affected_object` | ECN影响对象表 | `ecn_object_id` | 记录ECN影响的BOM/Routing/MBR等 |
| `pro_mbr_version_diff` | MBR版本差异对比表 | `version_diff_id` | 记录MBR新旧版本差异 |

### L4 计划订单与车间调度层（6张）
| 表名 | 中文名称 | 主键 | 主要用途 |
|------|----------|------|----------|
| `pro_production_order` | 生产工单头表 | `prod_order_id` | 定义MES工单主体 |
| `pro_order_component` | 工单组件表 | `order_component_id` | 建单时固化的计划组件清单 |
| `pro_order_operation` | 工单工序表 | `order_op_id` | 工单展开后的工序实例 |
| `pro_schedule_plan` | 排产计划表 | `plan_id` | 记录排产计划主体 |
| `pro_schedule_log` | 排产调整日志表 | `log_id` | 记录排产调整留痕 |
| `pro_shop_floor_dispatch` | 派工表 | `dispatch_id` | 定义派工安排 |

### L5 现场执行、称量与电子批记录层（16张）
| 表名 | 中文名称 | 主键 | 主要用途 |
|------|----------|------|----------|
| `pro_operation_execution` | 工序执行实例表 | `op_exec_id` | 定义现场实际执行过程 |
| `pro_production_report` | 报工表 | `report_id` | 记录工序执行结果 |
| `pro_report_labor` | 报工人工明细表 | `report_labor_id` | 记录人工投入 |
| `pro_report_equipment` | 报工设备明细表 | `report_equipment_id` | 记录设备投入 |
| `pro_operation_tracking` | 工序跟踪表 | `op_track_id` | 记录工序执行留痕 |
| `pro_operation_consumption` | 工序投料表 | `op_consume_id` | 记录实际投料 |
| `pro_operation_return` | 工序退料表 | `op_return_id` | 记录工序退料 |
| `pro_weighing_record` | 投料称量记录表 | `weighing_id` | 记录称量目标值/实际值/允差 |
| `pro_scale_device_check` | 电子天平点检校准记录表 | `scale_check_id` | 记录天平使用前点检、校准状态 |
| `pro_weighing_audit_log` | 称量审计日志表 | `weighing_audit_id` | 记录称量修改、复核、驳回留痕 |
| `pro_line_clearance_check` | 清场检查记录表 | `clearance_check_id` | 支撑换批、换品种、防混淆检查 |
| `pro_batch_review` | 批记录审核流程表 | `review_id` | 记录批记录审核节点 |
| `pro_ebr_header` | 电子批记录头表 | `ebr_id` | 记录工单实际执行的EBR主体 |
| `pro_ebr_step_record` | EBR步骤记录表 | `ebr_step_id` | 固化每个MBR Step的实际执行 |
| `pro_ebr_param_record` | EBR参数记录表 | `ebr_param_id` | 固化实际温度、转速、重量等参数 |
| `pro_process_monitor_session` | 过程监控会话表 | `monitor_session_id` | 表达一次配液/孵育/清洗等过程监控 |

### L6 质量异常与合规审计层（9张）
| 表名 | 中文名称 | 主键 | 主要用途 |
|------|----------|------|----------|
| `pro_defect_code_master` | 缺陷代码主数据表 | `defect_code_id` | 定义缺陷代码 |
| `pro_production_defect` | 生产不良表 | `prod_defect_id` | 记录不良明细 |
| `pro_inspection_result` | 检验结果表 | `insp_result_id` | 记录现场检验结果 |
| `pro_nc_handling` | 不合格品处置表 | `handling_id` | 记录不合格品处置闭环 |
| `pro_exception_record` | 异常记录主表 | `exception_id` | 统一记录各类异常实例 |
| `pro_exception_category` | 异常分类配置表 | `category_id` | 定义异常分类 |
| `pro_exception_escalation` | 异常升级记录表 | `escalation_id` | 记录异常升级过程 |
| `pro_e_signature_record` | 电子签名记录表 | `signature_id` | 记录执行/复核/审核/放行等电子签名 |
| `pro_audit_trail` | 审计追踪表 | `audit_trail_id` | 记录关键数据的审计事件 |

### L7 OT/SCADA、环境公用与清洗冷链层（16张）
| 表名 | 中文名称 | 主键 | 主要用途 |
|------|----------|------|----------|
| `pro_scada_system` | SCADA系统定义表 | `scada_system_id` | 定义ThingsBoard系统 |
| `pro_scada_device_ref` | SCADA设备参考表 | `scada_device_ref_id` | 保存ThingsBoard设备信息 |
| `pro_equipment_scada_map` | MES设备SCADA映射表 | `equipment_scada_map_id` | MES设备与ThingsBoard设备绑定 |
| `pro_scada_point` | SCADA采集点位表 | `scada_point_id` | 定义telemetry key、单位、上下限 |
| `pro_operation_data_collect` | 工序采集结果表 | `collect_id` | 固化与工单/工序相关的关键采集值 |
| `pro_process_monitor_summary` | 过程监控摘要表 | `monitor_summary_id` | 保存最大值/最小值/均值/超限时长 |
| `pro_scada_alarm_event` | SCADA告警事件表 | `scada_alarm_event_id` | 保存告警事件并关联MES异常/批次 |
| `pro_equipment_state_event` | 设备状态事件表 | `state_event_id` | 记录Run/Stop/Alarm/微停机 |
| `pro_oee_summary` | OEE汇总表 | `oee_summary_id` | 汇总稼动率/性能/良率/OEE |
| `pro_environment_monitor_record` | 环境监测记录表 | `environment_record_id` | 固化温湿度/压差/粒子数 |
| `pro_water_quality_record` | 纯化水质量记录表 | `water_quality_record_id` | 固化电导率/TOC/水温/流速 |
| `pro_cold_chain_monitor_record` | 冷链监控记录表 | `cold_chain_record_id` | 固化冰箱/冷库/运输箱温度 |
| `pro_cold_chain_alarm_notice` | 冷链报警通知表 | `cold_chain_notice_id` | 记录冷链报警通知和响应 |
| `pro_cleaning_cycle` | 清洗灭菌周期表 | `cleaning_cycle_id` | 表达一次CIP/SIP过程 |
| `pro_cleaning_cycle_parameter` | 清洗灭菌参数记录表 | `cleaning_param_id` | 保存清洗灭菌参数 |
| `pro_cleaning_release_record` | 清洗灭菌放行记录表 | `cleaning_release_id` | 保存清洗结果和放行结论 |

### L8 追溯仓储与批次族谱层（10张）
| 表名 | 中文名称 | 主键 | 主要用途 |
|------|----------|------|----------|
| `pro_material_lot` | 物料批次表 | `material_lot_id` | 定义物料批次对象 |
| `pro_goods_receipt` | 收货单头表 | `gr_id` | 记录来料收货 |
| `pro_goods_receipt_item` | 收货单明细表 | `gr_item_id` | 记录收货物料明细 |
| `pro_serial_number` | 物料序列号表 | `serial_id` | 定义物料序列号对象 |
| `pro_wip_lot` | 在制品批次表 | `wip_lot_id` | 记录在制品批次 |
| `pro_wip_lot_tracking` | 在制品批次跟踪表 | `wip_track_id` | 记录在制流转 |
| `pro_finished_good_lot` | 成品批次表 | `fg_lot_id` | 记录成品批次 |
| `pro_finished_good_serial` | 成品序列号表 | `fg_serial_id` | 记录成品序列号 |
| `pro_lot_genealogy` | 批次族谱表 | `lot_genealogy_id` | 记录批次来源/去向关系 |
| `pro_serial_genealogy` | 序列号族谱表 | `serial_genealogy_id` | 记录序列号来源/去向关系 |

### L9 企业集成与接口运营层（21张）
| 表名 | 中文名称 | 主键 | 主要用途 |
|------|----------|------|----------|
| `pro_sap_system` | SAP系统定义表 | `sap_system_id` | 定义SAP系统环境 |
| `pro_sap_plant_ref` | SAP工厂参考表 | `sap_plant_ref_id` | SAP工厂参考数据 |
| `pro_sap_material_ref` | SAP物料参考表 | `sap_material_ref_id` | SAP物料参考数据 |
| `pro_sap_bom_ref` | SAP BOM头参考表 | `sap_bom_ref_id` | SAP BOM Header参考数据 |
| `pro_sap_bom_item_ref` | SAP BOM行参考表 | `sap_bom_item_ref_id` | SAP BOM Item参考数据 |
| `pro_sap_routing_ref` | SAP工艺路线参考表 | `sap_routing_ref_id` | SAP Routing参考数据 |
| `pro_sap_operation_ref` | SAP工序参考表 | `sap_operation_ref_id` | SAP Operation参考数据 |
| `pro_sap_work_center_ref` | SAP工作中心参考表 | `sap_work_center_ref_id` | SAP Work Center参考数据 |
| `pro_sap_production_order_ref` | SAP生产订单参考表 | `sap_prod_order_ref_id` | SAP Production Order参考数据 |
| `pro_sap_plant_map` | SAP工厂映射表 | `sap_plant_map_id` | SAP工厂与MES工厂映射 |
| `pro_sap_material_map` | SAP物料映射表 | `sap_material_map_id` | SAP物料与MES物料映射 |
| `pro_sap_bom_map` | SAP BOM头映射表 | `sap_bom_map_id` | SAP BOM与MES BOM映射 |
| `pro_sap_bom_item_map` | SAP BOM行映射表 | `sap_bom_item_map_id` | SAP BOM Item与MES BOM Item映射 |
| `pro_sap_routing_map` | SAP工艺路线映射表 | `sap_routing_map_id` | SAP Routing与MES Routing映射 |
| `pro_sap_operation_map` | SAP工序映射表 | `sap_operation_map_id` | SAP Operation与MES Operation映射 |
| `pro_sap_work_center_map` | SAP工作中心映射表 | `sap_wc_map_id` | SAP Work Center与MES Work Center映射 |
| `pro_sap_production_order_map` | SAP生产订单映射表 | `sap_prod_order_map_id` | SAP生产订单与MES工单映射 |
| `pro_interface_message` | 接口消息主表 | `interface_msg_id` | 统一记录接口消息 |
| `pro_report_confirmation_if` | 报工确认接口表 | `report_if_id` | MES报工回传SAP |
| `pro_inspection_result_if` | 检验结果接口表 | `insp_if_id` | MES检验结果回传SAP |
| `pro_consumption_posting_if` | 投料过账接口表 | `consume_if_id` | MES投料回传SAP |

### L10 仿真分析与持续优化层（2张）
| 表名 | 中文名称 | 主键 | 主要用途 |
|------|----------|------|----------|
| `pro_process_simulation_case` | 工艺仿真方案表 | `simulation_case_id` | 定义仿真输入方案 |
| `pro_process_simulation_result` | 工艺仿真结果表 | `simulation_result_id` | 记录仿真后的产能/瓶颈/风险 |

---

## 4. 数据字典文件

| 文件 | 内容 | 用途 |
|------|------|------|
| `docs/00_Data_Dictionary.csv` | 业务概念字典（dict_code/长度/是否必填） | 字段设计参考 |
| `docs/MES系统基础表逐字段数据字典_按优先级_pgsql.csv` | PostgreSQL逐字段数据字典（2411行，147张表） | 生成DDL、代码生成的权威来源 |
| `docs/MES系统基础表清单_按优先级.md` | 147表L0-L10分层清单 | 表清单索引、开发排期参考 |
| `docs/参考文件/MES系统基础表逐字段数据字典_按优先级.csv` | MySQL版逐字段数据字典（参考） | 历史参考 |

---

## 5. SQL脚本规范
- 所有数据库变更脚本必须存放于`/docs/sql_changes/`目录下
- 脚本命名格式：`YYYYMMDD_描述.sql`，比如`20240520_新增生产模块表.sql`
- 脚本必须包含回滚语句，避免不可逆变更
- 涉及业务数据变更的脚本必须经过DBA评审后才能执行
- 生产环境执行脚本前必须在测试环境验证通过

---

## 6. 数据模型治理规范（强制执行）

本项目遵循 `docs/MES数据模型治理规范/` 中的全部规范：

### 6.1 规范文件索引
| 规范文件 | 用途 | 加载时机 |
|----------|------|----------|
| 01_AI渐进式加载指南.md | AI按任务分批读取上下文 | 所有AI Coding任务起点 |
| 02_新增表规范.md | 新增表的判断、命名、字段要求 | 新模块、新业务对象建模 |
| 03_新增字段规范.md | 新增字段的命名、类型、字典和外键规则 | 给已有表补字段 |
| 04_字典项管理规范.md | dict_code和枚举项管理规则 | 状态、类型、原因、判断字段 |
| 05_变更记录规范.md | 数据模型变更记录模板 | 所有表结构变更 |
| 06_校验规则清单.md | 每次变更后的硬性校验规则 | SQL生成前、评审前 |
| 07_代码生成前检查清单.md | 进入建表SQL和代码生成前的检查项 | RuoYi代码生成前 |

### 6.2 强制执行要求
1. **新增表**：必须通过02_新增表规范校验，更新表清单和逐字段数据字典
2. **新增字段**：必须通过03_新增字段规范校验，更新逐字段数据字典
3. **所有变更**：必须记录在 `05_Change_Log.md` 变更记录文件中
4. **生成SQL前**：必须通过06_校验规则清单
5. **代码生成前**：必须通过07_代码生成前检查清单

### 6.3 变更记录要求
- 变更编号格式：`DM-YYYYMMDD-序号`
- 变更记录存放于：`docs/05_Change_Log.md`
- 修改核心CSV前必须备份
