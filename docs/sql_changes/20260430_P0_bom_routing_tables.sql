-- ================================================
-- 变更编号：DM-20260430-001
-- 变更类型：新增表
-- 变更描述：P0层BOM与工艺表建表SQL（5张表）
-- 变更原因：MES系统基础表设计
-- 影响范围：BOM管理、工艺管理模块
-- 执行人：AI-DBA
-- 执行日期：2026-04-30
-- ================================================

-- ----------------------------
-- Table: pro_bom_header - BOM头表
-- ----------------------------
DROP TABLE IF EXISTS `pro_bom_header`;
CREATE TABLE `pro_bom_header` (
    `bom_id` BIGINT NOT NULL COMMENT 'BOM ID',
    `plant_id` BIGINT NOT NULL COMMENT '工厂ID',
    `material_id` BIGINT NOT NULL COMMENT '物料ID',
    `bom_code` VARCHAR(64) NOT NULL COMMENT 'BOM编码',
    `bom_version` VARCHAR(32) NOT NULL COMMENT 'BOM版本',
    `bom_usage` VARCHAR(64) COMMENT 'BOM用途',
    `effective_from` DATETIME COMMENT '生效开始时间',
    `effective_to` DATETIME COMMENT '生效结束时间',
    `bom_status` VARCHAR(20) NOT NULL DEFAULT '0' COMMENT 'BOM状态',
    `base_qty` DECIMAL(18,6) NOT NULL DEFAULT 0 COMMENT '基准数量',
    `base_uom` VARCHAR(20) COMMENT '基本单位',
    `create_by` VARCHAR(64) NOT NULL COMMENT '创建人',
    `create_time` DATETIME NOT NULL COMMENT '创建时间',
    `update_by` VARCHAR(64) COMMENT '更新人',
    `update_time` DATETIME COMMENT '更新时间',
    `del_flag` CHAR(1) NOT NULL DEFAULT '0' COMMENT '逻辑删除标识',
    `remark` VARCHAR(500) COMMENT '备注',
    PRIMARY KEY (`bom_id`),
    UNIQUE KEY `uk_bom_header_bom_code` (`bom_code`),
    UNIQUE KEY `uk_bom_header_bom_version` (`bom_version`),
    UNIQUE KEY `uk_bom_header_bom_usage` (`bom_usage`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='BOM头表';

-- ----------------------------
-- Table: pro_bom_item - BOM明细表
-- ----------------------------
DROP TABLE IF EXISTS `pro_bom_item`;
CREATE TABLE `pro_bom_item` (
    `bom_item_id` BIGINT NOT NULL COMMENT 'BOM明细ID',
    `bom_id` BIGINT NOT NULL COMMENT 'BOM ID',
    `item_no` VARCHAR(64) NOT NULL COMMENT '项目号',
    `component_material_id` BIGINT NOT NULL COMMENT '组件物料ID',
    `component_qty` DECIMAL(18,6) NOT NULL DEFAULT 0 COMMENT '组件数量',
    `component_uom` VARCHAR(20) COMMENT '组件单位',
    `scrap_rate` DECIMAL(18,6) COMMENT '损耗率',
    `item_type` VARCHAR(32) COMMENT '项目类型',
    `effective_from` DATETIME COMMENT '生效开始时间',
    `effective_to` DATETIME COMMENT '生效结束时间',
    `item_status` VARCHAR(20) NOT NULL DEFAULT '0' COMMENT '项目状态',
    `create_by` VARCHAR(64) NOT NULL COMMENT '创建人',
    `create_time` DATETIME NOT NULL COMMENT '创建时间',
    `update_by` VARCHAR(64) COMMENT '更新人',
    `update_time` DATETIME COMMENT '更新时间',
    `del_flag` CHAR(1) NOT NULL DEFAULT '0' COMMENT '逻辑删除标识',
    `remark` VARCHAR(500) COMMENT '备注',
    PRIMARY KEY (`bom_item_id`),
    UNIQUE KEY `uk_bom_item_item_no` (`item_no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='BOM明细表';

-- ----------------------------
-- Table: pro_bom_item_operation_map - BOM行项目工序映射表
-- ----------------------------
DROP TABLE IF EXISTS `pro_bom_item_operation_map`;
CREATE TABLE `pro_bom_item_operation_map` (
    `bom_item_op_map_id` BIGINT NOT NULL COMMENT 'BOM工序映射ID',
    `bom_item_id` BIGINT NOT NULL COMMENT 'BOM明细ID',
    `operation_id` BIGINT NOT NULL COMMENT '工序ID',
    `issue_method` VARCHAR(64) COMMENT '发料方式',
    `issue_qty` DECIMAL(18,6) NOT NULL DEFAULT 0 COMMENT '发料数量',
    `issue_uom` VARCHAR(20) COMMENT '发料单位',
    `backflush_flag` CHAR(1) NOT NULL DEFAULT 'N' COMMENT '是否倒冲',
    `mandatory_flag` CHAR(1) NOT NULL DEFAULT 'N' COMMENT '是否必需',
    `status` VARCHAR(20) NOT NULL DEFAULT '0' COMMENT '状态',
    `create_by` VARCHAR(64) NOT NULL COMMENT '创建人',
    `create_time` DATETIME NOT NULL COMMENT '创建时间',
    `update_by` VARCHAR(64) COMMENT '更新人',
    `update_time` DATETIME COMMENT '更新时间',
    `del_flag` CHAR(1) NOT NULL DEFAULT '0' COMMENT '逻辑删除标识',
    `remark` VARCHAR(500) COMMENT '备注',
    PRIMARY KEY (`bom_item_op_map_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='BOM行项目工序映射表';

-- ----------------------------
-- Table: pro_routing_header - 工艺路线头表
-- ----------------------------
DROP TABLE IF EXISTS `pro_routing_header`;
CREATE TABLE `pro_routing_header` (
    `routing_id` BIGINT NOT NULL COMMENT '工艺路线ID',
    `plant_id` BIGINT NOT NULL COMMENT '工厂ID',
    `material_id` BIGINT NOT NULL COMMENT '物料ID',
    `routing_code` VARCHAR(64) NOT NULL COMMENT '工艺路线编码',
    `routing_version` VARCHAR(32) NOT NULL COMMENT '工艺路线版本',
    `routing_type` VARCHAR(32) COMMENT '工艺路线类型',
    `effective_from` DATETIME COMMENT '生效开始时间',
    `effective_to` DATETIME COMMENT '生效结束时间',
    `routing_status` VARCHAR(20) NOT NULL DEFAULT '0' COMMENT '工艺路线状态',
    `create_by` VARCHAR(64) NOT NULL COMMENT '创建人',
    `create_time` DATETIME NOT NULL COMMENT '创建时间',
    `update_by` VARCHAR(64) COMMENT '更新人',
    `update_time` DATETIME COMMENT '更新时间',
    `del_flag` CHAR(1) NOT NULL DEFAULT '0' COMMENT '逻辑删除标识',
    `remark` VARCHAR(500) COMMENT '备注',
    PRIMARY KEY (`routing_id`),
    UNIQUE KEY `uk_routing_header_routing_code` (`routing_code`),
    UNIQUE KEY `uk_routing_header_routing_version` (`routing_version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='工艺路线头表';

-- ----------------------------
-- Table: pro_routing_operation - 工艺工序表
-- ----------------------------
DROP TABLE IF EXISTS `pro_routing_operation`;
CREATE TABLE `pro_routing_operation` (
    `operation_id` BIGINT NOT NULL COMMENT '工序ID',
    `routing_id` BIGINT NOT NULL COMMENT '工艺路线ID',
    `operation_no` VARCHAR(64) NOT NULL COMMENT '工序号',
    `operation_code` VARCHAR(64) NOT NULL COMMENT '工序编码',
    `operation_name` VARCHAR(128) NOT NULL COMMENT '工序名称',
    `work_center_id` BIGINT NOT NULL COMMENT '工作中心ID',
    `standard_time` DECIMAL(18,2) DEFAULT 0 COMMENT '标准工时',
    `time_uom` VARCHAR(20) COMMENT '时间单位',
    `operation_type` VARCHAR(32) COMMENT '工序类型',
    `operation_status` VARCHAR(20) NOT NULL DEFAULT '0' COMMENT '工序状态',
    `create_by` VARCHAR(64) NOT NULL COMMENT '创建人',
    `create_time` DATETIME NOT NULL COMMENT '创建时间',
    `update_by` VARCHAR(64) COMMENT '更新人',
    `update_time` DATETIME COMMENT '更新时间',
    `del_flag` CHAR(1) NOT NULL DEFAULT '0' COMMENT '逻辑删除标识',
    `remark` VARCHAR(500) COMMENT '备注',
    PRIMARY KEY (`operation_id`),
    UNIQUE KEY `uk_routing_operation_operation_no` (`operation_no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='工艺工序表';

-- ================================================
-- ROLLBACK 回滚脚本
-- ================================================
-- DROP TABLE IF EXISTS `pro_routing_operation`;
-- DROP TABLE IF EXISTS `pro_routing_header`;
-- DROP TABLE IF EXISTS `pro_bom_item_operation_map`;
-- DROP TABLE IF EXISTS `pro_bom_item`;
-- DROP TABLE IF EXISTS `pro_bom_header`;