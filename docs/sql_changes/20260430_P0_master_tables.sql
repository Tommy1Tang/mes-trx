-- ================================================
-- 变更编号：DM-20260430-001
-- 变更类型：新增表
-- 变更描述：P0层主数据表建表SQL（8张表）
-- 变更原因：MES系统基础表设计
-- 影响范围：主数据管理模块
-- 执行人：AI-DBA
-- 执行日期：2026-04-30
-- ================================================

-- ----------------------------
-- Table: pro_plant_master - 工厂主数据表
-- ----------------------------
DROP TABLE IF EXISTS `pro_plant_master`;
CREATE TABLE `pro_plant_master` (
    `plant_id` BIGINT NOT NULL COMMENT '工厂ID',
    `plant_code` VARCHAR(64) NOT NULL COMMENT '工厂编码',
    `plant_name` VARCHAR(128) NOT NULL COMMENT '工厂名称',
    `plant_type` VARCHAR(32) COMMENT '工厂类型',
    `address` VARCHAR(500) COMMENT '地址',
    `status` VARCHAR(20) NOT NULL DEFAULT '0' COMMENT '状态',
    `sort_no` INT NOT NULL DEFAULT 0 COMMENT '排序号',
    `create_by` VARCHAR(64) NOT NULL COMMENT '创建人',
    `create_time` DATETIME NOT NULL COMMENT '创建时间',
    `update_by` VARCHAR(64) COMMENT '更新人',
    `update_time` DATETIME COMMENT '更新时间',
    `del_flag` CHAR(1) NOT NULL DEFAULT '0' COMMENT '逻辑删除标识',
    `remark` VARCHAR(500) COMMENT '备注',
    PRIMARY KEY (`plant_id`),
    UNIQUE KEY `uk_plant_plant_code` (`plant_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='工厂主数据表';

-- ----------------------------
-- Table: pro_workshop_master - 车间主数据表
-- ----------------------------
DROP TABLE IF EXISTS `pro_workshop_master`;
CREATE TABLE `pro_workshop_master` (
    `workshop_id` BIGINT NOT NULL COMMENT '车间ID',
    `plant_id` BIGINT NOT NULL COMMENT '工厂ID',
    `workshop_code` VARCHAR(64) NOT NULL COMMENT '车间编码',
    `workshop_name` VARCHAR(128) NOT NULL COMMENT '车间名称',
    `workshop_type` VARCHAR(32) COMMENT '车间类型',
    `status` VARCHAR(20) NOT NULL DEFAULT '0' COMMENT '状态',
    `sort_no` INT NOT NULL DEFAULT 0 COMMENT '排序号',
    `create_by` VARCHAR(64) NOT NULL COMMENT '创建人',
    `create_time` DATETIME NOT NULL COMMENT '创建时间',
    `update_by` VARCHAR(64) COMMENT '更新人',
    `update_time` DATETIME COMMENT '更新时间',
    `del_flag` CHAR(1) NOT NULL DEFAULT '0' COMMENT '逻辑删除标识',
    `remark` VARCHAR(500) COMMENT '备注',
    PRIMARY KEY (`workshop_id`),
    UNIQUE KEY `uk_workshop_workshop_code` (`workshop_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='车间主数据表';

-- ----------------------------
-- Table: pro_production_line_master - 产线主数据表
-- ----------------------------
DROP TABLE IF EXISTS `pro_production_line_master`;
CREATE TABLE `pro_production_line_master` (
    `line_id` BIGINT NOT NULL COMMENT '产线ID',
    `plant_id` BIGINT NOT NULL COMMENT '工厂ID',
    `workshop_id` BIGINT NOT NULL COMMENT '车间ID',
    `line_code` VARCHAR(64) NOT NULL COMMENT '产线编码',
    `line_name` VARCHAR(128) NOT NULL COMMENT '产线名称',
    `line_type` VARCHAR(32) COMMENT '产线类型',
    `status` VARCHAR(20) NOT NULL DEFAULT '0' COMMENT '状态',
    `sort_no` INT NOT NULL DEFAULT 0 COMMENT '排序号',
    `create_by` VARCHAR(64) NOT NULL COMMENT '创建人',
    `create_time` DATETIME NOT NULL COMMENT '创建时间',
    `update_by` VARCHAR(64) COMMENT '更新人',
    `update_time` DATETIME COMMENT '更新时间',
    `del_flag` CHAR(1) NOT NULL DEFAULT '0' COMMENT '逻辑删除标识',
    `remark` VARCHAR(500) COMMENT '备注',
    PRIMARY KEY (`line_id`),
    UNIQUE KEY `uk_production_line_line_code` (`line_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='产线主数据表';

-- ----------------------------
-- Table: pro_work_center_master - 工作中心主数据表
-- ----------------------------
DROP TABLE IF EXISTS `pro_work_center_master`;
CREATE TABLE `pro_work_center_master` (
    `work_center_id` BIGINT NOT NULL COMMENT '工作中心ID',
    `plant_id` BIGINT NOT NULL COMMENT '工厂ID',
    `workshop_id` BIGINT NOT NULL COMMENT '车间ID',
    `line_id` BIGINT NOT NULL COMMENT '产线ID',
    `work_center_code` VARCHAR(64) NOT NULL COMMENT '工作中心编码',
    `work_center_name` VARCHAR(128) NOT NULL COMMENT '工作中心名称',
    `work_center_type` VARCHAR(32) COMMENT '工作中心类型',
    `capacity_unit` VARCHAR(64) COMMENT '产能单位',
    `status` VARCHAR(20) NOT NULL DEFAULT '0' COMMENT '状态',
    `create_by` VARCHAR(64) NOT NULL COMMENT '创建人',
    `create_time` DATETIME NOT NULL COMMENT '创建时间',
    `update_by` VARCHAR(64) COMMENT '更新人',
    `update_time` DATETIME COMMENT '更新时间',
    `del_flag` CHAR(1) NOT NULL DEFAULT '0' COMMENT '逻辑删除标识',
    `remark` VARCHAR(500) COMMENT '备注',
    PRIMARY KEY (`work_center_id`),
    UNIQUE KEY `uk_work_center_work_center_code` (`work_center_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='工作中心主数据表';

-- ----------------------------
-- Table: pro_material_master - 物料主数据表
-- ----------------------------
DROP TABLE IF EXISTS `pro_material_master`;
CREATE TABLE `pro_material_master` (
    `material_id` BIGINT NOT NULL COMMENT '物料ID',
    `material_code` VARCHAR(64) NOT NULL COMMENT '物料编码',
    `material_name` VARCHAR(128) NOT NULL COMMENT '物料名称',
    `material_type` VARCHAR(32) COMMENT '物料类型',
    `spec_model` VARCHAR(64) COMMENT '规格型号',
    `base_uom` VARCHAR(20) COMMENT '基本单位',
    `batch_managed_flag` CHAR(1) NOT NULL DEFAULT 'N' COMMENT '是否批次管理',
    `serial_managed_flag` CHAR(1) NOT NULL DEFAULT 'N' COMMENT '是否序列号管理',
    `status` VARCHAR(20) NOT NULL DEFAULT '0' COMMENT '状态',
    `create_by` VARCHAR(64) NOT NULL COMMENT '创建人',
    `create_time` DATETIME NOT NULL COMMENT '创建时间',
    `update_by` VARCHAR(64) COMMENT '更新人',
    `update_time` DATETIME COMMENT '更新时间',
    `del_flag` CHAR(1) NOT NULL DEFAULT '0' COMMENT '逻辑删除标识',
    `remark` VARCHAR(500) COMMENT '备注',
    PRIMARY KEY (`material_id`),
    UNIQUE KEY `uk_material_material_code` (`material_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='物料主数据表';

-- ----------------------------
-- Table: pro_equipment_master - 设备主数据表
-- ----------------------------
DROP TABLE IF EXISTS `pro_equipment_master`;
CREATE TABLE `pro_equipment_master` (
    `equipment_id` BIGINT NOT NULL COMMENT '设备ID',
    `plant_id` BIGINT NOT NULL COMMENT '工厂ID',
    `work_center_id` BIGINT NOT NULL COMMENT '工作中心ID',
    `equipment_code` VARCHAR(64) NOT NULL COMMENT '设备编码',
    `equipment_name` VARCHAR(128) NOT NULL COMMENT '设备名称',
    `equipment_type` VARCHAR(32) COMMENT '设备类型',
    `asset_no` VARCHAR(64) NOT NULL COMMENT '资产编号',
    `equipment_status` VARCHAR(20) NOT NULL DEFAULT '0' COMMENT '设备状态',
    `create_by` VARCHAR(64) NOT NULL COMMENT '创建人',
    `create_time` DATETIME NOT NULL COMMENT '创建时间',
    `update_by` VARCHAR(64) COMMENT '更新人',
    `update_time` DATETIME COMMENT '更新时间',
    `del_flag` CHAR(1) NOT NULL DEFAULT '0' COMMENT '逻辑删除标识',
    `remark` VARCHAR(500) COMMENT '备注',
    PRIMARY KEY (`equipment_id`),
    UNIQUE KEY `uk_equipment_equipment_code` (`equipment_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='设备主数据表';

-- ----------------------------
-- Table: pro_warehouse_master - 仓库主数据表
-- ----------------------------
DROP TABLE IF EXISTS `pro_warehouse_master`;
CREATE TABLE `pro_warehouse_master` (
    `warehouse_id` BIGINT NOT NULL COMMENT '仓库ID',
    `plant_id` BIGINT NOT NULL COMMENT '工厂ID',
    `warehouse_code` VARCHAR(64) NOT NULL COMMENT '仓库编码',
    `warehouse_name` VARCHAR(128) NOT NULL COMMENT '仓库名称',
    `warehouse_type` VARCHAR(32) COMMENT '仓库类型',
    `status` VARCHAR(20) NOT NULL DEFAULT '0' COMMENT '状态',
    `create_by` VARCHAR(64) NOT NULL COMMENT '创建人',
    `create_time` DATETIME NOT NULL COMMENT '创建时间',
    `update_by` VARCHAR(64) COMMENT '更新人',
    `update_time` DATETIME COMMENT '更新时间',
    `del_flag` CHAR(1) NOT NULL DEFAULT '0' COMMENT '逻辑删除标识',
    `remark` VARCHAR(500) COMMENT '备注',
    PRIMARY KEY (`warehouse_id`),
    UNIQUE KEY `uk_warehouse_warehouse_code` (`warehouse_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='仓库主数据表';

-- ----------------------------
-- Table: pro_storage_location_master - 库位主数据表
-- ----------------------------
DROP TABLE IF EXISTS `pro_storage_location_master`;
CREATE TABLE `pro_storage_location_master` (
    `storage_location_id` BIGINT NOT NULL COMMENT '库位ID',
    `warehouse_id` BIGINT NOT NULL COMMENT '仓库ID',
    `storage_location_code` VARCHAR(64) NOT NULL COMMENT '库位编码',
    `storage_location_name` VARCHAR(128) NOT NULL COMMENT '库位名称',
    `location_type` VARCHAR(32) COMMENT '库位类型',
    `status` VARCHAR(20) NOT NULL DEFAULT '0' COMMENT '状态',
    `create_by` VARCHAR(64) NOT NULL COMMENT '创建人',
    `create_time` DATETIME NOT NULL COMMENT '创建时间',
    `update_by` VARCHAR(64) COMMENT '更新人',
    `update_time` DATETIME COMMENT '更新时间',
    `del_flag` CHAR(1) NOT NULL DEFAULT '0' COMMENT '逻辑删除标识',
    `remark` VARCHAR(500) COMMENT '备注',
    PRIMARY KEY (`storage_location_id`),
    UNIQUE KEY `uk_storage_location_storage_location_code` (`storage_location_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='库位主数据表';

-- ================================================
-- ROLLBACK 回滚脚本
-- ================================================
-- DROP TABLE IF EXISTS `pro_storage_location_master`;
-- DROP TABLE IF EXISTS `pro_warehouse_master`;
-- DROP TABLE IF EXISTS `pro_equipment_master`;
-- DROP TABLE IF EXISTS `pro_material_master`;
-- DROP TABLE IF EXISTS `pro_work_center_master`;
-- DROP TABLE IF EXISTS `pro_production_line_master`;
-- DROP TABLE IF EXISTS `pro_workshop_master`;
-- DROP TABLE IF EXISTS `pro_plant_master`;
