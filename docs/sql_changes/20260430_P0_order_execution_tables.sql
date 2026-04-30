-- ================================================
-- 变更编号：DM-20260430-001
-- 变更类型：新增表
-- 变更描述：P0层工单与执行表建表SQL（7张表）
-- 变更原因：MES系统基础表设计
-- 影响范围：生产订单、现场报工、物料管理模块
-- 执行人：AI-DBA
-- 执行日期：2026-04-30
-- ================================================

-- ----------------------------
-- Table: pro_production_order - 生产工单头表
-- ----------------------------
DROP TABLE IF EXISTS `pro_production_order`;
CREATE TABLE `pro_production_order` (
    `prod_order_id` BIGINT NOT NULL COMMENT '生产工单ID',
    `plant_id` BIGINT NOT NULL COMMENT '工厂ID',
    `material_id` BIGINT NOT NULL COMMENT '物料ID',
    `bom_id` BIGINT NOT NULL COMMENT 'BOM ID',
    `routing_id` BIGINT NOT NULL COMMENT '工艺路线ID',
    `order_no` VARCHAR(64) NOT NULL COMMENT '生产工单号',
    `order_type` VARCHAR(32) COMMENT '工单类型',
    `order_qty` DECIMAL(18,6) NOT NULL DEFAULT 0 COMMENT '工单数量',
    `order_uom` VARCHAR(20) COMMENT '工单单位',
    `planned_start_time` DATETIME COMMENT '计划开始时间',
    `planned_end_time` DATETIME COMMENT '计划结束时间',
    `order_status` VARCHAR(20) NOT NULL DEFAULT '0' COMMENT '工单状态',
    `source_system` VARCHAR(64) COMMENT '来源系统',
    `create_by` VARCHAR(64) NOT NULL COMMENT '创建人',
    `create_time` DATETIME NOT NULL COMMENT '创建时间',
    `update_by` VARCHAR(64) COMMENT '更新人',
    `update_time` DATETIME COMMENT '更新时间',
    `priority_level` VARCHAR(2) NOT NULL DEFAULT '''' COMMENT '紧急程度',
    `batch_no` VARCHAR(64) COMMENT '生产批号',
    `schedule_status` VARCHAR(20) COMMENT '排产状态',
    `del_flag` CHAR(1) NOT NULL DEFAULT '0' COMMENT '逻辑删除标识',
    `remark` VARCHAR(500) COMMENT '备注',
    PRIMARY KEY (`prod_order_id`),
    UNIQUE KEY `uk_production_order_order_no` (`order_no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='生产工单头表';

-- ----------------------------
-- Table: pro_order_component - 工单组件表
-- ----------------------------
DROP TABLE IF EXISTS `pro_order_component`;
CREATE TABLE `pro_order_component` (
    `order_component_id` BIGINT NOT NULL COMMENT '工单组件ID',
    `prod_order_id` BIGINT NOT NULL COMMENT '生产工单ID',
    `order_op_id` BIGINT NOT NULL COMMENT '工单工序ID',
    `bom_item_id` BIGINT NOT NULL COMMENT 'BOM明细ID',
    `component_seq_no` VARCHAR(64) NOT NULL COMMENT '组件序号',
    `material_id` BIGINT NOT NULL COMMENT '物料ID',
    `planned_qty` DECIMAL(18,6) NOT NULL DEFAULT 0 COMMENT '计划数量',
    `issued_qty` DECIMAL(18,6) NOT NULL DEFAULT 0 COMMENT '已发料数量',
    `uom` VARCHAR(20) COMMENT '单位',
    `component_source` VARCHAR(64) COMMENT '组件来源',
    `substitution_flag` CHAR(1) NOT NULL DEFAULT 'N' COMMENT '是否替代',
    `cutover_flag` CHAR(1) NOT NULL DEFAULT 'N' COMMENT '是否切换',
    `component_status` VARCHAR(20) NOT NULL DEFAULT '0' COMMENT '组件状态',
    `create_by` VARCHAR(64) NOT NULL COMMENT '创建人',
    `create_time` DATETIME NOT NULL COMMENT '创建时间',
    `update_by` VARCHAR(64) COMMENT '更新人',
    `update_time` DATETIME COMMENT '更新时间',
    `del_flag` CHAR(1) NOT NULL DEFAULT '0' COMMENT '逻辑删除标识',
    `remark` VARCHAR(500) COMMENT '备注',
    PRIMARY KEY (`order_component_id`),
    UNIQUE KEY `uk_order_component_component_seq_no` (`component_seq_no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='工单组件表';

-- ----------------------------
-- Table: pro_order_operation - 工单工序表
-- ----------------------------
DROP TABLE IF EXISTS `pro_order_operation`;
CREATE TABLE `pro_order_operation` (
    `order_op_id` BIGINT NOT NULL COMMENT '工单工序ID',
    `prod_order_id` BIGINT NOT NULL COMMENT '生产工单ID',
    `operation_id` BIGINT NOT NULL COMMENT '工序ID',
    `operation_no` VARCHAR(64) NOT NULL COMMENT '工序号',
    `operation_code` VARCHAR(64) NOT NULL COMMENT '工序编码',
    `operation_name` VARCHAR(128) NOT NULL COMMENT '工序名称',
    `work_center_id` BIGINT NOT NULL COMMENT '工作中心ID',
    `planned_start_time` DATETIME COMMENT '计划开始时间',
    `planned_end_time` DATETIME COMMENT '计划结束时间',
    `actual_start_time` DATETIME COMMENT '实际开始时间',
    `actual_end_time` DATETIME COMMENT '实际结束时间',
    `op_status` VARCHAR(20) NOT NULL DEFAULT '0' COMMENT '工序状态',
    `create_by` VARCHAR(64) NOT NULL COMMENT '创建人',
    `create_time` DATETIME NOT NULL COMMENT '创建时间',
    `update_by` VARCHAR(64) COMMENT '更新人',
    `update_time` DATETIME COMMENT '更新时间',
    `del_flag` CHAR(1) NOT NULL DEFAULT '0' COMMENT '逻辑删除标识',
    `remark` VARCHAR(500) COMMENT '备注',
    PRIMARY KEY (`order_op_id`),
    UNIQUE KEY `uk_order_operation_operation_no` (`operation_no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='工单工序表';

-- ----------------------------
-- Table: pro_operation_execution - 工序执行实例表
-- ----------------------------
DROP TABLE IF EXISTS `pro_operation_execution`;
CREATE TABLE `pro_operation_execution` (
    `op_exec_id` BIGINT NOT NULL COMMENT '工序执行ID',
    `prod_order_id` BIGINT NOT NULL COMMENT '生产工单ID',
    `order_op_id` BIGINT NOT NULL COMMENT '工单工序ID',
    `dispatch_id` BIGINT NOT NULL COMMENT '派工ID',
    `execution_no` VARCHAR(64) NOT NULL COMMENT '执行次数',
    `start_time` DATETIME COMMENT '开始时间',
    `end_time` DATETIME COMMENT '结束时间',
    `executor_id` BIGINT NOT NULL COMMENT '执行人ID',
    `equipment_id` BIGINT NOT NULL COMMENT '设备ID',
    `exec_status` VARCHAR(20) NOT NULL DEFAULT '0' COMMENT '执行状态',
    `create_by` VARCHAR(64) NOT NULL COMMENT '创建人',
    `create_time` DATETIME NOT NULL COMMENT '创建时间',
    `update_by` VARCHAR(64) COMMENT '更新人',
    `update_time` DATETIME COMMENT '更新时间',
    `shift_id` BIGINT COMMENT '班次ID',
    `del_flag` CHAR(1) NOT NULL DEFAULT '0' COMMENT '逻辑删除标识',
    `remark` VARCHAR(500) COMMENT '备注',
    PRIMARY KEY (`op_exec_id`),
    UNIQUE KEY `uk_operation_execution_execution_no` (`execution_no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='工序执行实例表';

-- ----------------------------
-- Table: pro_production_report - 报工表
-- ----------------------------
DROP TABLE IF EXISTS `pro_production_report`;
CREATE TABLE `pro_production_report` (
    `report_id` BIGINT NOT NULL COMMENT '报工ID',
    `prod_order_id` BIGINT NOT NULL COMMENT '生产工单ID',
    `order_op_id` BIGINT NOT NULL COMMENT '工单工序ID',
    `op_exec_id` BIGINT NOT NULL COMMENT '工序执行ID',
    `report_no` VARCHAR(64) NOT NULL COMMENT '报工单号',
    `good_qty` DECIMAL(18,6) NOT NULL DEFAULT 0 COMMENT '合格数量',
    `scrap_qty` DECIMAL(18,6) NOT NULL DEFAULT 0 COMMENT '报废数量',
    `rework_qty` DECIMAL(18,6) NOT NULL DEFAULT 0 COMMENT '返工数量',
    `report_uom` VARCHAR(20) COMMENT '报工单位',
    `report_time` DATETIME COMMENT '报工时间',
    `report_person_id` BIGINT NOT NULL COMMENT '报工人ID',
    `report_status` VARCHAR(20) NOT NULL DEFAULT '0' COMMENT '报工状态',
    `create_by` VARCHAR(64) NOT NULL COMMENT '创建人',
    `create_time` DATETIME NOT NULL COMMENT '创建时间',
    `update_by` VARCHAR(64) COMMENT '更新人',
    `update_time` DATETIME COMMENT '更新时间',
    `shift_id` BIGINT COMMENT '班次ID',
    `equipment_id` BIGINT COMMENT '设备ID',
    `del_flag` CHAR(1) NOT NULL DEFAULT '0' COMMENT '逻辑删除标识',
    `remark` VARCHAR(500) COMMENT '备注',
    PRIMARY KEY (`report_id`),
    UNIQUE KEY `uk_production_report_report_no` (`report_no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='报工表';

-- ----------------------------
-- Table: pro_material_lot - 物料批次表
-- ----------------------------
DROP TABLE IF EXISTS `pro_material_lot`;
CREATE TABLE `pro_material_lot` (
    `material_lot_id` BIGINT NOT NULL COMMENT '物料批次ID',
    `material_id` BIGINT NOT NULL COMMENT '物料ID',
    `lot_no` VARCHAR(64) NOT NULL COMMENT '批次号',
    `supplier_id` BIGINT NOT NULL COMMENT '供应商ID',
    `gr_item_id` BIGINT NOT NULL COMMENT '收货明细ID',
    `received_qty` DECIMAL(18,6) NOT NULL DEFAULT 0 COMMENT '接收数量',
    `available_qty` DECIMAL(18,6) NOT NULL DEFAULT 0 COMMENT '可用数量',
    `uom` VARCHAR(20) COMMENT '单位',
    `manufacture_date` DATE COMMENT '生产日期',
    `expire_date` DATE COMMENT '失效日期',
    `lot_status` VARCHAR(20) NOT NULL DEFAULT '0' COMMENT '批次状态',
    `create_by` VARCHAR(64) NOT NULL COMMENT '创建人',
    `create_time` DATETIME NOT NULL COMMENT '创建时间',
    `update_by` VARCHAR(64) COMMENT '更新人',
    `update_time` DATETIME COMMENT '更新时间',
    `warehouse_id` BIGINT COMMENT '仓库ID',
    `storage_location_id` BIGINT COMMENT '库位ID',
    `del_flag` CHAR(1) NOT NULL DEFAULT '0' COMMENT '逻辑删除标识',
    `remark` VARCHAR(500) COMMENT '备注',
    PRIMARY KEY (`material_lot_id`),
    UNIQUE KEY `uk_material_lot_lot_no` (`lot_no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='物料批次表';

-- ----------------------------
-- Table: pro_operation_consumption - 工序投料表
-- ----------------------------
DROP TABLE IF EXISTS `pro_operation_consumption`;
CREATE TABLE `pro_operation_consumption` (
    `op_consume_id` BIGINT NOT NULL COMMENT '投料记录ID',
    `prod_order_id` BIGINT NOT NULL COMMENT '生产工单ID',
    `order_op_id` BIGINT NOT NULL COMMENT '工单工序ID',
    `op_exec_id` BIGINT NOT NULL COMMENT '工序执行ID',
    `order_component_id` BIGINT NOT NULL COMMENT '工单组件ID',
    `material_id` BIGINT NOT NULL COMMENT '物料ID',
    `material_lot_id` BIGINT NOT NULL COMMENT '物料批次ID',
    `serial_id` BIGINT NOT NULL COMMENT '序列号ID',
    `consume_qty` DECIMAL(18,6) NOT NULL DEFAULT 0 COMMENT '投料数量',
    `consume_uom` VARCHAR(20) COMMENT '投料单位',
    `consume_type` VARCHAR(32) COMMENT '投料类型',
    `consume_time` DATETIME COMMENT '投料时间',
    `create_by` VARCHAR(64) NOT NULL COMMENT '创建人',
    `create_time` DATETIME NOT NULL COMMENT '创建时间',
    `update_by` VARCHAR(64) COMMENT '更新人',
    `update_time` DATETIME COMMENT '更新时间',
    `del_flag` CHAR(1) NOT NULL DEFAULT '0' COMMENT '逻辑删除标识',
    `remark` VARCHAR(500) COMMENT '备注',
    PRIMARY KEY (`op_consume_id`),
    UNIQUE KEY `uk_operation_consumption_consume_time` (`consume_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='工序投料表';

-- ================================================
-- ROLLBACK 回滚脚本
-- ================================================
-- DROP TABLE IF EXISTS `pro_operation_consumption`;
-- DROP TABLE IF EXISTS `pro_material_lot`;
-- DROP TABLE IF EXISTS `pro_production_report`;
-- DROP TABLE IF EXISTS `pro_operation_execution`;
-- DROP TABLE IF EXISTS `pro_order_operation`;
-- DROP TABLE IF EXISTS `pro_order_component`;
-- DROP TABLE IF EXISTS `pro_production_order`;