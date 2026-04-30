-- ================================================
-- 变更编号：DM-20260430-001
-- 变更类型：新增表
-- 变更描述：P0+补充表与支撑表建表SQL
-- 变更原因：MES系统基础表设计
-- 影响范围：排产、派工、报工、工序管理模块
-- 执行人：AI-DBA
-- 执行日期：2026-04-30
-- ================================================

-- ----------------------------
-- Table: pro_shift - 班次主数据表
-- ----------------------------
DROP TABLE IF EXISTS `pro_shift`;
CREATE TABLE `pro_shift` (
    `shift_id` BIGINT NOT NULL COMMENT '班次ID',
    `shift_code` VARCHAR(64) NOT NULL COMMENT '班次编码',
    `shift_name` VARCHAR(128) NOT NULL COMMENT '班次名称',
    `start_time` TIME NOT NULL COMMENT '开始时间',
    `end_time` TIME NOT NULL COMMENT '结束时间',
    `cross_day_flag` CHAR(1) NOT NULL DEFAULT 'N' COMMENT '是否跨天',
    `work_hours` DECIMAL(8,2) DEFAULT 0 COMMENT '工时',
    `status` VARCHAR(20) NOT NULL DEFAULT '0' COMMENT '状态',
    `create_by` VARCHAR(64) NOT NULL COMMENT '创建人',
    `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_by` VARCHAR(64) COMMENT '更新人',
    `update_time` DATETIME COMMENT '更新时间',
    `del_flag` CHAR(1) NOT NULL DEFAULT '0' COMMENT '逻辑删除标识',
    `remark` VARCHAR(500) COMMENT '备注',
    PRIMARY KEY (`shift_id`),
    UNIQUE KEY `uk_shift_shift_code` (`shift_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='班次主数据表';

-- ----------------------------
-- Table: pro_calendar - 生产日历表
-- ----------------------------
DROP TABLE IF EXISTS `pro_calendar`;
CREATE TABLE `pro_calendar` (
    `calendar_id` BIGINT NOT NULL COMMENT '生产日历ID',
    `plant_id` BIGINT NOT NULL COMMENT '工厂ID',
    `calendar_date` DATE NOT NULL COMMENT '日历日期',
    `day_type` VARCHAR(20) NOT NULL DEFAULT 'WORKDAY' COMMENT '日期类型',
    `work_flag` CHAR(1) NOT NULL DEFAULT 'Y' COMMENT '是否工作日',
    `shift_id` BIGINT COMMENT '班次ID',
    `capacity_hours` DECIMAL(8,2) DEFAULT 0 COMMENT '可用产能小时',
    `status` VARCHAR(20) NOT NULL DEFAULT '0' COMMENT '状态',
    `create_by` VARCHAR(64) NOT NULL COMMENT '创建人',
    `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_by` VARCHAR(64) COMMENT '更新人',
    `update_time` DATETIME COMMENT '更新时间',
    `del_flag` CHAR(1) NOT NULL DEFAULT '0' COMMENT '逻辑删除标识',
    `remark` VARCHAR(500) COMMENT '备注',
    PRIMARY KEY (`calendar_id`),
    UNIQUE KEY `uk_calendar_calendar_date` (`calendar_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='生产日历表';

-- ----------------------------
-- Table: pro_schedule_plan - 排产计划表
-- ----------------------------
DROP TABLE IF EXISTS `pro_schedule_plan`;
CREATE TABLE `pro_schedule_plan` (
    `plan_id` BIGINT NOT NULL COMMENT '排产计划ID',
    `plan_no` VARCHAR(64) NOT NULL COMMENT '排产计划号',
    `prod_order_id` BIGINT NOT NULL COMMENT '生产工单ID',
    `order_op_id` BIGINT COMMENT '工单工序ID',
    `work_center_id` BIGINT NOT NULL COMMENT '工作中心ID',
    `line_id` BIGINT COMMENT '产线ID',
    `shift_id` BIGINT COMMENT '班次ID',
    `plan_date` DATE NOT NULL COMMENT '计划日期',
    `planned_start_time` DATETIME NOT NULL COMMENT '计划开始时间',
    `planned_end_time` DATETIME NOT NULL COMMENT '计划结束时间',
    `planned_qty` DECIMAL(18,6) NOT NULL DEFAULT 0 COMMENT '计划数量',
    `plan_status` VARCHAR(20) NOT NULL DEFAULT 'DRAFT' COMMENT '方案状态',
    `lock_flag` CHAR(1) NOT NULL DEFAULT 'N' COMMENT '是否锁定',
    `publish_flag` CHAR(1) NOT NULL DEFAULT 'N' COMMENT '是否发布',
    `create_by` VARCHAR(64) NOT NULL COMMENT '创建人',
    `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_by` VARCHAR(64) COMMENT '更新人',
    `update_time` DATETIME COMMENT '更新时间',
    `del_flag` CHAR(1) NOT NULL DEFAULT '0' COMMENT '逻辑删除标识',
    `remark` VARCHAR(500) COMMENT '备注',
    PRIMARY KEY (`plan_id`),
    UNIQUE KEY `uk_schedule_plan_plan_no` (`plan_no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='排产计划表';

-- ----------------------------
-- Table: pro_schedule_log - 排产调整日志表
-- ----------------------------
DROP TABLE IF EXISTS `pro_schedule_log`;
CREATE TABLE `pro_schedule_log` (
    `log_id` BIGINT NOT NULL COMMENT '日志ID',
    `plan_id` BIGINT NOT NULL COMMENT '排产计划ID',
    `adjust_type` VARCHAR(32) NOT NULL COMMENT '调整类型',
    `before_start_time` DATETIME COMMENT '调整前开始时间',
    `after_start_time` DATETIME COMMENT '调整后开始时间',
    `before_end_time` DATETIME COMMENT '调整前结束时间',
    `after_end_time` DATETIME COMMENT '调整后结束时间',
    `before_work_center_id` BIGINT COMMENT '调整前工作中心ID',
    `after_work_center_id` BIGINT COMMENT '调整后工作中心ID',
    `adjust_reason` VARCHAR(500) COMMENT '调整原因',
    `operator_id` BIGINT COMMENT '操作人ID',
    `log_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '日志时间',
    `create_by` VARCHAR(64) NOT NULL COMMENT '创建人',
    `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_by` VARCHAR(64) COMMENT '更新人',
    `update_time` DATETIME COMMENT '更新时间',
    `del_flag` CHAR(1) NOT NULL DEFAULT '0' COMMENT '逻辑删除标识',
    `remark` VARCHAR(500) COMMENT '备注',
    PRIMARY KEY (`log_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='排产调整日志表';

-- ----------------------------
-- Table: pro_wc_equipment - 工作中心设备关系表
-- ----------------------------
DROP TABLE IF EXISTS `pro_wc_equipment`;
CREATE TABLE `pro_wc_equipment` (
    `id` BIGINT NOT NULL COMMENT 'ID',
    `work_center_id` BIGINT NOT NULL COMMENT '工作中心ID',
    `equipment_id` BIGINT NOT NULL COMMENT '设备ID',
    `relation_type` VARCHAR(32) NOT NULL DEFAULT 'PRIMARY' COMMENT '关系类型',
    `primary_flag` CHAR(1) NOT NULL DEFAULT 'N' COMMENT '是否主设备',
    `effective_from` DATETIME COMMENT '生效开始时间',
    `effective_to` DATETIME COMMENT '生效结束时间',
    `status` VARCHAR(20) NOT NULL DEFAULT '0' COMMENT '状态',
    `create_by` VARCHAR(64) NOT NULL COMMENT '创建人',
    `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_by` VARCHAR(64) COMMENT '更新人',
    `update_time` DATETIME COMMENT '更新时间',
    `del_flag` CHAR(1) NOT NULL DEFAULT '0' COMMENT '逻辑删除标识',
    `remark` VARCHAR(500) COMMENT '备注',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='工作中心设备关系表';

-- ----------------------------
-- Table: pro_shop_floor_dispatch - 派工表
-- ----------------------------
DROP TABLE IF EXISTS `pro_shop_floor_dispatch`;
CREATE TABLE `pro_shop_floor_dispatch` (
    `dispatch_id` BIGINT NOT NULL COMMENT '派工ID',
    `prod_order_id` BIGINT NOT NULL COMMENT '生产工单ID',
    `order_op_id` BIGINT NOT NULL COMMENT '工单工序ID',
    `work_center_id` BIGINT NOT NULL COMMENT '工作中心ID',
    `person_id` BIGINT NOT NULL COMMENT '人员ID',
    `equipment_id` BIGINT NOT NULL COMMENT '设备ID',
    `dispatch_qty` DECIMAL(18,6) NOT NULL DEFAULT 0 COMMENT '派工数量',
    `planned_start_time` DATETIME COMMENT '计划开始时间',
    `planned_end_time` DATETIME COMMENT '计划结束时间',
    `dispatch_status` VARCHAR(20) NOT NULL DEFAULT '0' COMMENT '派工状态',
    `create_by` VARCHAR(64) NOT NULL COMMENT '创建人',
    `create_time` DATETIME NOT NULL COMMENT '创建时间',
    `update_by` VARCHAR(64) COMMENT '更新人',
    `update_time` DATETIME COMMENT '更新时间',
    `del_flag` CHAR(1) NOT NULL DEFAULT '0' COMMENT '逻辑删除标识',
    `remark` VARCHAR(500) COMMENT '备注',
    PRIMARY KEY (`dispatch_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='派工表';

-- ----------------------------
-- Table: pro_report_labor - 报工人工明细表
-- ----------------------------
DROP TABLE IF EXISTS `pro_report_labor`;
CREATE TABLE `pro_report_labor` (
    `report_labor_id` BIGINT NOT NULL COMMENT '报工人工明细ID',
    `report_id` BIGINT NOT NULL COMMENT '报工ID',
    `person_id` BIGINT NOT NULL COMMENT '人员ID',
    `labor_type` VARCHAR(32) COMMENT '人工类型',
    `work_hours` DECIMAL(18,2) DEFAULT 0 COMMENT '工时',
    `start_time` DATETIME COMMENT '开始时间',
    `end_time` DATETIME COMMENT '结束时间',
    `status` VARCHAR(20) NOT NULL DEFAULT '0' COMMENT '状态',
    `create_by` VARCHAR(64) NOT NULL COMMENT '创建人',
    `create_time` DATETIME NOT NULL COMMENT '创建时间',
    `update_by` VARCHAR(64) COMMENT '更新人',
    `update_time` DATETIME COMMENT '更新时间',
    `del_flag` CHAR(1) NOT NULL DEFAULT '0' COMMENT '逻辑删除标识',
    `remark` VARCHAR(500) COMMENT '备注',
    PRIMARY KEY (`report_labor_id`),
    UNIQUE KEY `uk_report_labor_labor_type` (`labor_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='报工人工明细表';

-- ----------------------------
-- Table: pro_report_equipment - 报工设备明细表
-- ----------------------------
DROP TABLE IF EXISTS `pro_report_equipment`;
CREATE TABLE `pro_report_equipment` (
    `report_equipment_id` BIGINT NOT NULL COMMENT '报工设备明细ID',
    `report_id` BIGINT NOT NULL COMMENT '报工ID',
    `equipment_id` BIGINT NOT NULL COMMENT '设备ID',
    `run_hours` DECIMAL(18,2) DEFAULT 0 COMMENT '运行时长',
    `start_time` DATETIME COMMENT '开始时间',
    `end_time` DATETIME COMMENT '结束时间',
    `equipment_status` VARCHAR(20) NOT NULL DEFAULT '0' COMMENT '设备状态',
    `create_by` VARCHAR(64) NOT NULL COMMENT '创建人',
    `create_time` DATETIME NOT NULL COMMENT '创建时间',
    `update_by` VARCHAR(64) COMMENT '更新人',
    `update_time` DATETIME COMMENT '更新时间',
    `del_flag` CHAR(1) NOT NULL DEFAULT '0' COMMENT '逻辑删除标识',
    `remark` VARCHAR(500) COMMENT '备注',
    PRIMARY KEY (`report_equipment_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='报工设备明细表';

-- ----------------------------
-- Table: pro_operation_tracking - 工序跟踪表
-- ----------------------------
DROP TABLE IF EXISTS `pro_operation_tracking`;
CREATE TABLE `pro_operation_tracking` (
    `op_track_id` BIGINT NOT NULL COMMENT '工序跟踪ID',
    `prod_order_id` BIGINT NOT NULL COMMENT '生产工单ID',
    `order_op_id` BIGINT NOT NULL COMMENT '工单工序ID',
    `op_exec_id` BIGINT NOT NULL COMMENT '工序执行ID',
    `track_type` VARCHAR(32) COMMENT '跟踪类型',
    `track_content` VARCHAR(500) COMMENT '跟踪内容',
    `track_time` DATETIME COMMENT '跟踪时间',
    `operator_id` BIGINT NOT NULL COMMENT '操作人ID',
    `source_module` VARCHAR(64) COMMENT '来源模块',
    `create_by` VARCHAR(64) NOT NULL COMMENT '创建人',
    `create_time` DATETIME NOT NULL COMMENT '创建时间',
    `del_flag` CHAR(1) NOT NULL DEFAULT '0' COMMENT '逻辑删除标识',
    `remark` VARCHAR(500) COMMENT '备注',
    PRIMARY KEY (`op_track_id`),
    UNIQUE KEY `uk_operation_tracking_track_type` (`track_type`),
    UNIQUE KEY `uk_operation_tracking_track_time` (`track_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='工序跟踪表';

-- ----------------------------
-- Table: pro_operation_return - 工序退料表
-- ----------------------------
DROP TABLE IF EXISTS `pro_operation_return`;
CREATE TABLE `pro_operation_return` (
    `op_return_id` BIGINT NOT NULL COMMENT '退料记录ID',
    `prod_order_id` BIGINT NOT NULL COMMENT '生产工单ID',
    `order_op_id` BIGINT NOT NULL COMMENT '工单工序ID',
    `op_exec_id` BIGINT NOT NULL COMMENT '工序执行ID',
    `order_component_id` BIGINT NOT NULL COMMENT '工单组件ID',
    `material_id` BIGINT NOT NULL COMMENT '物料ID',
    `material_lot_id` BIGINT NOT NULL COMMENT '物料批次ID',
    `return_qty` DECIMAL(18,6) NOT NULL DEFAULT 0 COMMENT '退料数量',
    `return_uom` VARCHAR(20) COMMENT '退料单位',
    `return_reason` VARCHAR(64) COMMENT '退料原因',
    `return_time` DATETIME COMMENT '退料时间',
    `create_by` VARCHAR(64) NOT NULL COMMENT '创建人',
    `create_time` DATETIME NOT NULL COMMENT '创建时间',
    `update_by` VARCHAR(64) COMMENT '更新人',
    `update_time` DATETIME COMMENT '更新时间',
    `del_flag` CHAR(1) NOT NULL DEFAULT '0' COMMENT '逻辑删除标识',
    `remark` VARCHAR(500) COMMENT '备注',
    PRIMARY KEY (`op_return_id`),
    UNIQUE KEY `uk_operation_return_return_time` (`return_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='工序退料表';

-- ----------------------------
-- Table: pro_operation_relation - 工序关系表
-- ----------------------------
DROP TABLE IF EXISTS `pro_operation_relation`;
CREATE TABLE `pro_operation_relation` (
    `op_relation_id` BIGINT NOT NULL COMMENT '工序关系ID',
    `routing_id` BIGINT NOT NULL COMMENT '工艺路线ID',
    `pre_operation_id` BIGINT NOT NULL COMMENT '前置工序ID',
    `next_operation_id` BIGINT NOT NULL COMMENT '后续工序ID',
    `relation_type` VARCHAR(32) COMMENT '关系类型',
    `join_type` VARCHAR(32) COMMENT '汇合方式',
    `lag_time` DECIMAL(18,2) DEFAULT 0 COMMENT '间隔时间',
    `status` VARCHAR(20) NOT NULL DEFAULT '0' COMMENT '状态',
    `create_by` VARCHAR(64) NOT NULL COMMENT '创建人',
    `create_time` DATETIME NOT NULL COMMENT '创建时间',
    `update_by` VARCHAR(64) COMMENT '更新人',
    `update_time` DATETIME COMMENT '更新时间',
    `del_flag` CHAR(1) NOT NULL DEFAULT '0' COMMENT '逻辑删除标识',
    `remark` VARCHAR(500) COMMENT '备注',
    PRIMARY KEY (`op_relation_id`),
    UNIQUE KEY `uk_operation_relation_relation_type` (`relation_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='工序关系表';

-- ----------------------------
-- Table: pro_operation_resource - 工序资源表
-- ----------------------------
DROP TABLE IF EXISTS `pro_operation_resource`;
CREATE TABLE `pro_operation_resource` (
    `op_res_id` BIGINT NOT NULL COMMENT '工序资源ID',
    `operation_id` BIGINT NOT NULL COMMENT '工序ID',
    `resource_type` VARCHAR(32) NOT NULL COMMENT '资源类型',
    `equipment_id` BIGINT COMMENT '设备ID',
    `tooling_id` BIGINT COMMENT '工装ID',
    `fixture_id` BIGINT COMMENT '夹具ID',
    `resource_id` BIGINT COMMENT '资源ID',
    `resource_code` VARCHAR(64) NOT NULL COMMENT '资源编码',
    `resource_name` VARCHAR(128) NOT NULL COMMENT '资源名称',
    `required_qty` DECIMAL(18,6) NOT NULL DEFAULT 0 COMMENT '需求数量',
    `resource_uom` VARCHAR(20) COMMENT '资源单位',
    `mandatory_flag` CHAR(1) NOT NULL DEFAULT 'N' COMMENT '是否必需',
    `status` VARCHAR(20) NOT NULL DEFAULT '0' COMMENT '状态',
    `create_by` VARCHAR(64) NOT NULL COMMENT '创建人',
    `create_time` DATETIME NOT NULL COMMENT '创建时间',
    `update_by` VARCHAR(64) COMMENT '更新人',
    `update_time` DATETIME COMMENT '更新时间',
    `del_flag` CHAR(1) NOT NULL DEFAULT '0' COMMENT '逻辑删除标识',
    `remark` VARCHAR(500) COMMENT '备注',
    PRIMARY KEY (`op_res_id`),
    UNIQUE KEY `uk_operation_resource_resource_type` (`resource_type`),
    UNIQUE KEY `uk_operation_resource_resource_id` (`resource_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='工序资源表';

-- ----------------------------
-- Table: pro_operation_parameter - 工序参数表
-- ----------------------------
DROP TABLE IF EXISTS `pro_operation_parameter`;
CREATE TABLE `pro_operation_parameter` (
    `op_param_id` BIGINT NOT NULL COMMENT '工序参数ID',
    `operation_id` BIGINT NOT NULL COMMENT '工序ID',
    `param_code` VARCHAR(64) NOT NULL COMMENT '参数编码',
    `param_name` VARCHAR(128) NOT NULL COMMENT '参数名称',
    `param_value` VARCHAR(64) COMMENT '参数值',
    `param_uom` VARCHAR(20) COMMENT '参数单位',
    `upper_limit` DECIMAL(18,6) COMMENT '上限值',
    `lower_limit` DECIMAL(18,6) COMMENT '下限值',
    `control_type` VARCHAR(32) COMMENT '控制类型',
    `status` VARCHAR(20) NOT NULL DEFAULT '0' COMMENT '状态',
    `create_by` VARCHAR(64) NOT NULL COMMENT '创建人',
    `create_time` DATETIME NOT NULL COMMENT '创建时间',
    `update_by` VARCHAR(64) COMMENT '更新人',
    `update_time` DATETIME COMMENT '更新时间',
    `del_flag` CHAR(1) NOT NULL DEFAULT '0' COMMENT '逻辑删除标识',
    `remark` VARCHAR(500) COMMENT '备注',
    PRIMARY KEY (`op_param_id`),
    UNIQUE KEY `uk_operation_parameter_param_code` (`param_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='工序参数表';

-- ----------------------------
-- Table: pro_operation_document - 工序文档表
-- ----------------------------
DROP TABLE IF EXISTS `pro_operation_document`;
CREATE TABLE `pro_operation_document` (
    `op_doc_id` BIGINT NOT NULL COMMENT '工序文档ID',
    `operation_id` BIGINT NOT NULL COMMENT '工序ID',
    `doc_code` VARCHAR(64) NOT NULL COMMENT '文档编码',
    `doc_name` VARCHAR(128) NOT NULL COMMENT '文档名称',
    `doc_type` VARCHAR(32) COMMENT '文档类型',
    `doc_version` VARCHAR(32) NOT NULL COMMENT '文档版本',
    `doc_url` VARCHAR(500) COMMENT '文档地址',
    `mandatory_flag` CHAR(1) NOT NULL DEFAULT 'N' COMMENT '是否必需',
    `status` VARCHAR(20) NOT NULL DEFAULT '0' COMMENT '状态',
    `create_by` VARCHAR(64) NOT NULL COMMENT '创建人',
    `create_time` DATETIME NOT NULL COMMENT '创建时间',
    `update_by` VARCHAR(64) COMMENT '更新人',
    `update_time` DATETIME COMMENT '更新时间',
    `del_flag` CHAR(1) NOT NULL DEFAULT '0' COMMENT '逻辑删除标识',
    `remark` VARCHAR(500) COMMENT '备注',
    PRIMARY KEY (`op_doc_id`),
    UNIQUE KEY `uk_operation_document_doc_code` (`doc_code`),
    UNIQUE KEY `uk_operation_document_doc_version` (`doc_version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='工序文档表';

-- ----------------------------
-- Table: pro_operation_inspection_map - 工序检验映射表
-- ----------------------------
DROP TABLE IF EXISTS `pro_operation_inspection_map`;
CREATE TABLE `pro_operation_inspection_map` (
    `op_insp_map_id` BIGINT NOT NULL COMMENT '工序检验关系ID',
    `operation_id` BIGINT NOT NULL COMMENT '工序ID',
    `insp_plan_id` BIGINT NOT NULL COMMENT '检验方案ID',
    `insp_char_id` BIGINT NOT NULL COMMENT '检验特性ID',
    `inspection_stage` VARCHAR(64) COMMENT '检验阶段',
    `mandatory_flag` CHAR(1) NOT NULL DEFAULT 'N' COMMENT '是否必需',
    `status` VARCHAR(20) NOT NULL DEFAULT '0' COMMENT '状态',
    `create_by` VARCHAR(64) NOT NULL COMMENT '创建人',
    `create_time` DATETIME NOT NULL COMMENT '创建时间',
    `update_by` VARCHAR(64) COMMENT '更新人',
    `update_time` DATETIME COMMENT '更新时间',
    `del_flag` CHAR(1) NOT NULL DEFAULT '0' COMMENT '逻辑删除标识',
    `remark` VARCHAR(500) COMMENT '备注',
    PRIMARY KEY (`op_insp_map_id`),
    UNIQUE KEY `uk_operation_inspection_map_inspection_stage` (`inspection_stage`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='工序检验映射表';

-- ----------------------------
-- Table: pro_interface_message - 接口消息主表
-- ----------------------------
DROP TABLE IF EXISTS `pro_interface_message`;
CREATE TABLE `pro_interface_message` (
    `interface_msg_id` BIGINT NOT NULL COMMENT '接口消息ID',
    `interface_code` VARCHAR(64) NOT NULL COMMENT '接口编码',
    `business_type` VARCHAR(32) COMMENT '业务类型',
    `business_key` VARCHAR(64) COMMENT '业务键',
    `direction` VARCHAR(64) COMMENT '接口方向',
    `source_system` VARCHAR(64) COMMENT '来源系统',
    `target_system` VARCHAR(64) COMMENT '目标系统',
    `message_body` VARCHAR(500) COMMENT '消息内容',
    `message_status` VARCHAR(20) NOT NULL DEFAULT '0' COMMENT '消息状态',
    `retry_count` INT DEFAULT 0 COMMENT '重试次数',
    `error_message` VARCHAR(500) COMMENT '错误信息',
    `create_time` DATETIME NOT NULL COMMENT '创建时间',
    `update_time` DATETIME COMMENT '更新时间',
    `del_flag` CHAR(1) NOT NULL DEFAULT '0' COMMENT '逻辑删除标识',
    `remark` VARCHAR(500) COMMENT '备注',
    PRIMARY KEY (`interface_msg_id`),
    UNIQUE KEY `uk_interface_message_interface_code` (`interface_code`),
    UNIQUE KEY `uk_interface_message_business_key` (`business_key`),
    UNIQUE KEY `uk_interface_message_direction` (`direction`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='接口消息主表';

-- ================================================
-- ROLLBACK 回滚脚本
-- ================================================
-- DROP TABLE IF EXISTS `pro_interface_message`;
-- DROP TABLE IF EXISTS `pro_operation_inspection_map`;
-- DROP TABLE IF EXISTS `pro_operation_document`;
-- DROP TABLE IF EXISTS `pro_operation_parameter`;
-- DROP TABLE IF EXISTS `pro_operation_resource`;
-- DROP TABLE IF EXISTS `pro_operation_relation`;
-- DROP TABLE IF EXISTS `pro_operation_return`;
-- DROP TABLE IF EXISTS `pro_operation_tracking`;
-- DROP TABLE IF EXISTS `pro_report_equipment`;
-- DROP TABLE IF EXISTS `pro_report_labor`;
-- DROP TABLE IF EXISTS `pro_shop_floor_dispatch`;
-- DROP TABLE IF EXISTS `pro_wc_equipment`;
-- DROP TABLE IF EXISTS `pro_schedule_log`;
-- DROP TABLE IF EXISTS `pro_schedule_plan`;
-- DROP TABLE IF EXISTS `pro_calendar`;
-- DROP TABLE IF EXISTS `pro_shift`;