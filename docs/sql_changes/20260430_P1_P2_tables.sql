-- ================================================
-- 变更编号：DM-20260430-001
-- 变更类型：新增表
-- 变更描述：P1/P2层表与SAP集成表建表SQL（38张表）
-- 变更原因：MES系统基础表设计
-- 影响范围：人员、工装、BOM替代、SAP集成、追溯等模块
-- 执行人：AI-DBA
-- 执行日期：2026-04-30
-- ================================================

-- ----------------------------
-- Table: pro_sap_system - SAP系统定义表
-- ----------------------------
DROP TABLE IF EXISTS `pro_sap_system`;
CREATE TABLE `pro_sap_system` (
    `sap_system_id` BIGINT NOT NULL COMMENT 'SAP系统ID',
    `sap_system_code` VARCHAR(64) NOT NULL COMMENT 'SAP系统编码',
    `sap_system_name` VARCHAR(128) NOT NULL COMMENT 'SAP系统名称',
    `client_no` VARCHAR(64) NOT NULL COMMENT '客户端号',
    `environment_type` VARCHAR(32) COMMENT '环境类型',
    `endpoint_url` VARCHAR(500) COMMENT '接口地址',
    `status` VARCHAR(20) NOT NULL DEFAULT '0' COMMENT '状态',
    `create_by` VARCHAR(64) NOT NULL COMMENT '创建人',
    `create_time` DATETIME NOT NULL COMMENT '创建时间',
    `update_by` VARCHAR(64) COMMENT '更新人',
    `update_time` DATETIME COMMENT '更新时间',
    `del_flag` CHAR(1) NOT NULL DEFAULT '0' COMMENT '逻辑删除标识',
    `remark` VARCHAR(500) COMMENT '备注',
    PRIMARY KEY (`sap_system_id`),
    UNIQUE KEY `uk_sap_system_sap_system_code` (`sap_system_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='SAP系统定义表';

-- ----------------------------
-- Table: pro_sap_plant_ref - SAP工厂参考表
-- ----------------------------
DROP TABLE IF EXISTS `pro_sap_plant_ref`;
CREATE TABLE `pro_sap_plant_ref` (
    `sap_plant_ref_id` BIGINT NOT NULL COMMENT 'SAP工厂参考ID',
    `sap_system_id` BIGINT NOT NULL COMMENT 'SAP系统ID',
    `sap_plant_code` VARCHAR(64) NOT NULL COMMENT 'SAP工厂编码',
    `sap_plant_name` VARCHAR(128) NOT NULL COMMENT 'SAP工厂名称',
    `company_code` VARCHAR(64) NOT NULL COMMENT '公司代码',
    `status` VARCHAR(20) NOT NULL DEFAULT '0' COMMENT '状态',
    `last_sync_time` DATETIME COMMENT '最后同步时间',
    `create_by` VARCHAR(64) NOT NULL COMMENT '创建人',
    `create_time` DATETIME NOT NULL COMMENT '创建时间',
    `update_by` VARCHAR(64) COMMENT '更新人',
    `update_time` DATETIME COMMENT '更新时间',
    `del_flag` CHAR(1) NOT NULL DEFAULT '0' COMMENT '逻辑删除标识',
    `remark` VARCHAR(500) COMMENT '备注',
    PRIMARY KEY (`sap_plant_ref_id`),
    UNIQUE KEY `uk_sap_plant_ref_sap_plant_code` (`sap_plant_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='SAP工厂参考表';

-- ----------------------------
-- Table: pro_sap_material_ref - SAP物料参考表
-- ----------------------------
DROP TABLE IF EXISTS `pro_sap_material_ref`;
CREATE TABLE `pro_sap_material_ref` (
    `sap_material_ref_id` BIGINT NOT NULL COMMENT 'SAP物料参考ID',
    `sap_system_id` BIGINT NOT NULL COMMENT 'SAP系统ID',
    `sap_material_code` VARCHAR(64) NOT NULL COMMENT 'SAP物料编码',
    `sap_material_name` VARCHAR(128) NOT NULL COMMENT 'SAP物料名称',
    `plant_code` VARCHAR(64) NOT NULL COMMENT '工厂编码',
    `material_type` VARCHAR(32) COMMENT '物料类型',
    `base_uom` VARCHAR(20) COMMENT '基本单位',
    `status` VARCHAR(20) NOT NULL DEFAULT '0' COMMENT '状态',
    `last_sync_time` DATETIME COMMENT '最后同步时间',
    `create_by` VARCHAR(64) NOT NULL COMMENT '创建人',
    `create_time` DATETIME NOT NULL COMMENT '创建时间',
    `update_by` VARCHAR(64) COMMENT '更新人',
    `update_time` DATETIME COMMENT '更新时间',
    `del_flag` CHAR(1) NOT NULL DEFAULT '0' COMMENT '逻辑删除标识',
    `remark` VARCHAR(500) COMMENT '备注',
    PRIMARY KEY (`sap_material_ref_id`),
    UNIQUE KEY `uk_sap_material_ref_sap_material_code` (`sap_material_code`),
    UNIQUE KEY `uk_sap_material_ref_plant_code` (`plant_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='SAP物料参考表';

-- ----------------------------
-- Table: pro_sap_bom_ref - SAP BOM头参考表
-- ----------------------------
DROP TABLE IF EXISTS `pro_sap_bom_ref`;
CREATE TABLE `pro_sap_bom_ref` (
    `sap_bom_ref_id` BIGINT NOT NULL COMMENT 'SAP BOM参考ID',
    `sap_system_id` BIGINT NOT NULL COMMENT 'SAP系统ID',
    `sap_bom_no` VARCHAR(64) NOT NULL COMMENT 'SAP BOM编号',
    `sap_bom_alt` VARCHAR(64) COMMENT 'SAP替代BOM',
    `plant_code` VARCHAR(64) NOT NULL COMMENT '工厂编码',
    `bom_usage` VARCHAR(64) COMMENT 'BOM用途',
    `material_code` VARCHAR(64) NOT NULL COMMENT '物料编码',
    `valid_from` VARCHAR(64) COMMENT '有效开始日期',
    `valid_to` VARCHAR(64) COMMENT '有效结束日期',
    `status` VARCHAR(20) NOT NULL DEFAULT '0' COMMENT '状态',
    `last_sync_time` DATETIME COMMENT '最后同步时间',
    `create_by` VARCHAR(64) NOT NULL COMMENT '创建人',
    `create_time` DATETIME NOT NULL COMMENT '创建时间',
    `update_by` VARCHAR(64) COMMENT '更新人',
    `update_time` DATETIME COMMENT '更新时间',
    `del_flag` CHAR(1) NOT NULL DEFAULT '0' COMMENT '逻辑删除标识',
    `remark` VARCHAR(500) COMMENT '备注',
    PRIMARY KEY (`sap_bom_ref_id`),
    UNIQUE KEY `uk_sap_bom_ref_sap_bom_no` (`sap_bom_no`),
    UNIQUE KEY `uk_sap_bom_ref_sap_bom_alt` (`sap_bom_alt`),
    UNIQUE KEY `uk_sap_bom_ref_plant_code` (`plant_code`),
    UNIQUE KEY `uk_sap_bom_ref_bom_usage` (`bom_usage`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='SAP BOM头参考表';

-- ----------------------------
-- Table: pro_sap_bom_item_ref - SAP BOM行参考表
-- ----------------------------
DROP TABLE IF EXISTS `pro_sap_bom_item_ref`;
CREATE TABLE `pro_sap_bom_item_ref` (
    `sap_bom_item_ref_id` BIGINT NOT NULL COMMENT 'SAP BOM行参考ID',
    `sap_bom_ref_id` BIGINT NOT NULL COMMENT 'SAP BOM参考ID',
    `sap_item_node_no` VARCHAR(64) NOT NULL COMMENT 'SAP项目节点号',
    `sap_item_no` VARCHAR(64) NOT NULL COMMENT 'SAP项目号',
    `component_code` VARCHAR(64) NOT NULL COMMENT '组件编码',
    `component_qty` DECIMAL(18,6) NOT NULL DEFAULT 0 COMMENT '组件数量',
    `component_uom` VARCHAR(20) COMMENT '组件单位',
    `valid_from` VARCHAR(64) COMMENT '有效开始日期',
    `valid_to` VARCHAR(64) COMMENT '有效结束日期',
    `item_status` VARCHAR(20) NOT NULL DEFAULT '0' COMMENT '项目状态',
    `last_sync_time` DATETIME COMMENT '最后同步时间',
    `create_by` VARCHAR(64) NOT NULL COMMENT '创建人',
    `create_time` DATETIME NOT NULL COMMENT '创建时间',
    `update_by` VARCHAR(64) COMMENT '更新人',
    `update_time` DATETIME COMMENT '更新时间',
    `del_flag` CHAR(1) NOT NULL DEFAULT '0' COMMENT '逻辑删除标识',
    `remark` VARCHAR(500) COMMENT '备注',
    PRIMARY KEY (`sap_bom_item_ref_id`),
    UNIQUE KEY `uk_sap_bom_item_ref_sap_item_node_no` (`sap_item_node_no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='SAP BOM行参考表';

-- ----------------------------
-- Table: pro_sap_routing_ref - SAP工艺路线参考表
-- ----------------------------
DROP TABLE IF EXISTS `pro_sap_routing_ref`;
CREATE TABLE `pro_sap_routing_ref` (
    `sap_routing_ref_id` BIGINT NOT NULL COMMENT 'SAP工艺路线参考ID',
    `sap_system_id` BIGINT NOT NULL COMMENT 'SAP系统ID',
    `sap_routing_group` VARCHAR(64) COMMENT 'SAP工艺路线组',
    `sap_group_counter` VARCHAR(64) COMMENT 'SAP组计数器',
    `plant_code` VARCHAR(64) NOT NULL COMMENT '工厂编码',
    `material_code` VARCHAR(64) NOT NULL COMMENT '物料编码',
    `valid_from` VARCHAR(64) COMMENT '有效开始日期',
    `valid_to` VARCHAR(64) COMMENT '有效结束日期',
    `status` VARCHAR(20) NOT NULL DEFAULT '0' COMMENT '状态',
    `last_sync_time` DATETIME COMMENT '最后同步时间',
    `create_by` VARCHAR(64) NOT NULL COMMENT '创建人',
    `create_time` DATETIME NOT NULL COMMENT '创建时间',
    `update_by` VARCHAR(64) COMMENT '更新人',
    `update_time` DATETIME COMMENT '更新时间',
    `del_flag` CHAR(1) NOT NULL DEFAULT '0' COMMENT '逻辑删除标识',
    `remark` VARCHAR(500) COMMENT '备注',
    PRIMARY KEY (`sap_routing_ref_id`),
    UNIQUE KEY `uk_sap_routing_ref_sap_routing_group` (`sap_routing_group`),
    UNIQUE KEY `uk_sap_routing_ref_sap_group_counter` (`sap_group_counter`),
    UNIQUE KEY `uk_sap_routing_ref_plant_code` (`plant_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='SAP工艺路线参考表';

-- ----------------------------
-- Table: pro_sap_operation_ref - SAP工序参考表
-- ----------------------------
DROP TABLE IF EXISTS `pro_sap_operation_ref`;
CREATE TABLE `pro_sap_operation_ref` (
    `sap_operation_ref_id` BIGINT NOT NULL COMMENT 'SAP工序参考ID',
    `sap_routing_ref_id` BIGINT NOT NULL COMMENT 'SAP工艺路线参考ID',
    `sap_operation_no` VARCHAR(64) NOT NULL COMMENT 'SAP工序号',
    `sap_work_center_code` VARCHAR(64) NOT NULL COMMENT 'SAP工作中心编码',
    `operation_desc` VARCHAR(64) COMMENT '工序说明',
    `standard_time` DECIMAL(18,2) DEFAULT 0 COMMENT '标准工时',
    `time_uom` VARCHAR(20) COMMENT '时间单位',
    `status` VARCHAR(20) NOT NULL DEFAULT '0' COMMENT '状态',
    `last_sync_time` DATETIME COMMENT '最后同步时间',
    `create_by` VARCHAR(64) NOT NULL COMMENT '创建人',
    `create_time` DATETIME NOT NULL COMMENT '创建时间',
    `update_by` VARCHAR(64) COMMENT '更新人',
    `update_time` DATETIME COMMENT '更新时间',
    `del_flag` CHAR(1) NOT NULL DEFAULT '0' COMMENT '逻辑删除标识',
    `remark` VARCHAR(500) COMMENT '备注',
    PRIMARY KEY (`sap_operation_ref_id`),
    UNIQUE KEY `uk_sap_operation_ref_sap_operation_no` (`sap_operation_no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='SAP工序参考表';

-- ----------------------------
-- Table: pro_sap_work_center_ref - SAP工作中心参考表
-- ----------------------------
DROP TABLE IF EXISTS `pro_sap_work_center_ref`;
CREATE TABLE `pro_sap_work_center_ref` (
    `sap_work_center_ref_id` BIGINT NOT NULL COMMENT 'SAP工作中心参考ID',
    `sap_system_id` BIGINT NOT NULL COMMENT 'SAP系统ID',
    `sap_work_center_code` VARCHAR(64) NOT NULL COMMENT 'SAP工作中心编码',
    `plant_code` VARCHAR(64) NOT NULL COMMENT '工厂编码',
    `work_center_name` VARCHAR(128) NOT NULL COMMENT '工作中心名称',
    `work_center_category` VARCHAR(64) COMMENT '工作中心类别',
    `status` VARCHAR(20) NOT NULL DEFAULT '0' COMMENT '状态',
    `last_sync_time` DATETIME COMMENT '最后同步时间',
    `create_by` VARCHAR(64) NOT NULL COMMENT '创建人',
    `create_time` DATETIME NOT NULL COMMENT '创建时间',
    `update_by` VARCHAR(64) COMMENT '更新人',
    `update_time` DATETIME COMMENT '更新时间',
    `del_flag` CHAR(1) NOT NULL DEFAULT '0' COMMENT '逻辑删除标识',
    `remark` VARCHAR(500) COMMENT '备注',
    PRIMARY KEY (`sap_work_center_ref_id`),
    UNIQUE KEY `uk_sap_work_center_ref_sap_work_center_code` (`sap_work_center_code`),
    UNIQUE KEY `uk_sap_work_center_ref_plant_code` (`plant_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='SAP工作中心参考表';

-- ----------------------------
-- Table: pro_sap_production_order_ref - SAP生产订单参考表
-- ----------------------------
DROP TABLE IF EXISTS `pro_sap_production_order_ref`;
CREATE TABLE `pro_sap_production_order_ref` (
    `sap_prod_order_ref_id` BIGINT NOT NULL COMMENT 'SAP生产订单参考ID',
    `sap_system_id` BIGINT NOT NULL COMMENT 'SAP系统ID',
    `sap_order_no` VARCHAR(64) NOT NULL COMMENT 'SAP订单号',
    `plant_code` VARCHAR(64) NOT NULL COMMENT '工厂编码',
    `material_code` VARCHAR(64) NOT NULL COMMENT '物料编码',
    `order_qty` DECIMAL(18,6) NOT NULL DEFAULT 0 COMMENT '工单数量',
    `order_uom` VARCHAR(20) COMMENT '工单单位',
    `basic_start_date` DATE COMMENT '基本开始日期',
    `basic_finish_date` DATE COMMENT '基本完成日期',
    `order_status` VARCHAR(20) NOT NULL DEFAULT '0' COMMENT '工单状态',
    `last_sync_time` DATETIME COMMENT '最后同步时间',
    `create_by` VARCHAR(64) NOT NULL COMMENT '创建人',
    `create_time` DATETIME NOT NULL COMMENT '创建时间',
    `update_by` VARCHAR(64) COMMENT '更新人',
    `update_time` DATETIME COMMENT '更新时间',
    `del_flag` CHAR(1) NOT NULL DEFAULT '0' COMMENT '逻辑删除标识',
    `remark` VARCHAR(500) COMMENT '备注',
    PRIMARY KEY (`sap_prod_order_ref_id`),
    UNIQUE KEY `uk_sap_production_order_ref_sap_order_no` (`sap_order_no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='SAP生产订单参考表';

-- ----------------------------
-- Table: pro_sap_plant_map - SAP工厂映射表
-- ----------------------------
DROP TABLE IF EXISTS `pro_sap_plant_map`;
CREATE TABLE `pro_sap_plant_map` (
    `sap_plant_map_id` BIGINT NOT NULL COMMENT 'SAP工厂映射ID',
    `sap_plant_ref_id` BIGINT NOT NULL COMMENT 'SAP工厂参考ID',
    `plant_id` BIGINT NOT NULL COMMENT '工厂ID',
    `map_status` VARCHAR(20) NOT NULL DEFAULT '0' COMMENT '映射状态',
    `effective_from` DATETIME COMMENT '生效开始时间',
    `effective_to` DATETIME COMMENT '生效结束时间',
    `create_by` VARCHAR(64) NOT NULL COMMENT '创建人',
    `create_time` DATETIME NOT NULL COMMENT '创建时间',
    `update_by` VARCHAR(64) COMMENT '更新人',
    `update_time` DATETIME COMMENT '更新时间',
    `del_flag` CHAR(1) NOT NULL DEFAULT '0' COMMENT '逻辑删除标识',
    `remark` VARCHAR(500) COMMENT '备注',
    PRIMARY KEY (`sap_plant_map_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='SAP工厂映射表';

-- ----------------------------
-- Table: pro_sap_material_map - SAP物料映射表
-- ----------------------------
DROP TABLE IF EXISTS `pro_sap_material_map`;
CREATE TABLE `pro_sap_material_map` (
    `sap_material_map_id` BIGINT NOT NULL COMMENT 'SAP物料映射ID',
    `sap_material_ref_id` BIGINT NOT NULL COMMENT 'SAP物料参考ID',
    `material_id` BIGINT NOT NULL COMMENT '物料ID',
    `map_status` VARCHAR(20) NOT NULL DEFAULT '0' COMMENT '映射状态',
    `effective_from` DATETIME COMMENT '生效开始时间',
    `effective_to` DATETIME COMMENT '生效结束时间',
    `create_by` VARCHAR(64) NOT NULL COMMENT '创建人',
    `create_time` DATETIME NOT NULL COMMENT '创建时间',
    `update_by` VARCHAR(64) COMMENT '更新人',
    `update_time` DATETIME COMMENT '更新时间',
    `del_flag` CHAR(1) NOT NULL DEFAULT '0' COMMENT '逻辑删除标识',
    `remark` VARCHAR(500) COMMENT '备注',
    PRIMARY KEY (`sap_material_map_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='SAP物料映射表';

-- ----------------------------
-- Table: pro_sap_bom_map - SAP BOM头映射表
-- ----------------------------
DROP TABLE IF EXISTS `pro_sap_bom_map`;
CREATE TABLE `pro_sap_bom_map` (
    `sap_bom_map_id` BIGINT NOT NULL COMMENT 'SAP BOM映射ID',
    `sap_bom_ref_id` BIGINT NOT NULL COMMENT 'SAP BOM参考ID',
    `bom_id` BIGINT NOT NULL COMMENT 'BOM ID',
    `map_status` VARCHAR(20) NOT NULL DEFAULT '0' COMMENT '映射状态',
    `effective_from` DATETIME COMMENT '生效开始时间',
    `effective_to` DATETIME COMMENT '生效结束时间',
    `create_by` VARCHAR(64) NOT NULL COMMENT '创建人',
    `create_time` DATETIME NOT NULL COMMENT '创建时间',
    `update_by` VARCHAR(64) COMMENT '更新人',
    `update_time` DATETIME COMMENT '更新时间',
    `del_flag` CHAR(1) NOT NULL DEFAULT '0' COMMENT '逻辑删除标识',
    `remark` VARCHAR(500) COMMENT '备注',
    PRIMARY KEY (`sap_bom_map_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='SAP BOM头映射表';

-- ----------------------------
-- Table: pro_sap_bom_item_map - SAP BOM行映射表
-- ----------------------------
DROP TABLE IF EXISTS `pro_sap_bom_item_map`;
CREATE TABLE `pro_sap_bom_item_map` (
    `sap_bom_item_map_id` BIGINT NOT NULL COMMENT 'SAP BOM行映射ID',
    `sap_bom_item_ref_id` BIGINT NOT NULL COMMENT 'SAP BOM行参考ID',
    `bom_item_id` BIGINT NOT NULL COMMENT 'BOM明细ID',
    `map_status` VARCHAR(20) NOT NULL DEFAULT '0' COMMENT '映射状态',
    `effective_from` DATETIME COMMENT '生效开始时间',
    `effective_to` DATETIME COMMENT '生效结束时间',
    `create_by` VARCHAR(64) NOT NULL COMMENT '创建人',
    `create_time` DATETIME NOT NULL COMMENT '创建时间',
    `update_by` VARCHAR(64) COMMENT '更新人',
    `update_time` DATETIME COMMENT '更新时间',
    `del_flag` CHAR(1) NOT NULL DEFAULT '0' COMMENT '逻辑删除标识',
    `remark` VARCHAR(500) COMMENT '备注',
    PRIMARY KEY (`sap_bom_item_map_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='SAP BOM行映射表';

-- ----------------------------
-- Table: pro_sap_routing_map - SAP工艺路线映射表
-- ----------------------------
DROP TABLE IF EXISTS `pro_sap_routing_map`;
CREATE TABLE `pro_sap_routing_map` (
    `sap_routing_map_id` BIGINT NOT NULL COMMENT 'SAP工艺路线映射ID',
    `sap_routing_ref_id` BIGINT NOT NULL COMMENT 'SAP工艺路线参考ID',
    `routing_id` BIGINT NOT NULL COMMENT '工艺路线ID',
    `map_status` VARCHAR(20) NOT NULL DEFAULT '0' COMMENT '映射状态',
    `effective_from` DATETIME COMMENT '生效开始时间',
    `effective_to` DATETIME COMMENT '生效结束时间',
    `create_by` VARCHAR(64) NOT NULL COMMENT '创建人',
    `create_time` DATETIME NOT NULL COMMENT '创建时间',
    `update_by` VARCHAR(64) COMMENT '更新人',
    `update_time` DATETIME COMMENT '更新时间',
    `del_flag` CHAR(1) NOT NULL DEFAULT '0' COMMENT '逻辑删除标识',
    `remark` VARCHAR(500) COMMENT '备注',
    PRIMARY KEY (`sap_routing_map_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='SAP工艺路线映射表';

-- ----------------------------
-- Table: pro_sap_operation_map - SAP工序映射表
-- ----------------------------
DROP TABLE IF EXISTS `pro_sap_operation_map`;
CREATE TABLE `pro_sap_operation_map` (
    `sap_operation_map_id` BIGINT NOT NULL COMMENT 'SAP工序映射ID',
    `sap_operation_ref_id` BIGINT NOT NULL COMMENT 'SAP工序参考ID',
    `operation_id` BIGINT NOT NULL COMMENT '工序ID',
    `map_status` VARCHAR(20) NOT NULL DEFAULT '0' COMMENT '映射状态',
    `effective_from` DATETIME COMMENT '生效开始时间',
    `effective_to` DATETIME COMMENT '生效结束时间',
    `create_by` VARCHAR(64) NOT NULL COMMENT '创建人',
    `create_time` DATETIME NOT NULL COMMENT '创建时间',
    `update_by` VARCHAR(64) COMMENT '更新人',
    `update_time` DATETIME COMMENT '更新时间',
    `del_flag` CHAR(1) NOT NULL DEFAULT '0' COMMENT '逻辑删除标识',
    `remark` VARCHAR(500) COMMENT '备注',
    PRIMARY KEY (`sap_operation_map_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='SAP工序映射表';

-- ----------------------------
-- Table: pro_sap_work_center_map - SAP工作中心映射表
-- ----------------------------
DROP TABLE IF EXISTS `pro_sap_work_center_map`;
CREATE TABLE `pro_sap_work_center_map` (
    `sap_wc_map_id` BIGINT NOT NULL COMMENT 'SAP工作中心映射ID',
    `sap_work_center_ref_id` BIGINT NOT NULL COMMENT 'SAP工作中心参考ID',
    `work_center_id` BIGINT NOT NULL COMMENT '工作中心ID',
    `plant_id` BIGINT NOT NULL COMMENT '工厂ID',
    `map_status` VARCHAR(20) NOT NULL DEFAULT '0' COMMENT '映射状态',
    `effective_from` DATETIME COMMENT '生效开始时间',
    `effective_to` DATETIME COMMENT '生效结束时间',
    `create_by` VARCHAR(64) NOT NULL COMMENT '创建人',
    `create_time` DATETIME NOT NULL COMMENT '创建时间',
    `update_by` VARCHAR(64) COMMENT '更新人',
    `update_time` DATETIME COMMENT '更新时间',
    `del_flag` CHAR(1) NOT NULL DEFAULT '0' COMMENT '逻辑删除标识',
    `remark` VARCHAR(500) COMMENT '备注',
    PRIMARY KEY (`sap_wc_map_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='SAP工作中心映射表';

-- ----------------------------
-- Table: pro_sap_production_order_map - SAP生产订单映射表
-- ----------------------------
DROP TABLE IF EXISTS `pro_sap_production_order_map`;
CREATE TABLE `pro_sap_production_order_map` (
    `sap_prod_order_map_id` BIGINT NOT NULL COMMENT 'SAP生产订单映射ID',
    `sap_prod_order_ref_id` BIGINT NOT NULL COMMENT 'SAP生产订单参考ID',
    `prod_order_id` BIGINT NOT NULL COMMENT '生产工单ID',
    `map_status` VARCHAR(20) NOT NULL DEFAULT '0' COMMENT '映射状态',
    `effective_from` DATETIME COMMENT '生效开始时间',
    `effective_to` DATETIME COMMENT '生效结束时间',
    `create_by` VARCHAR(64) NOT NULL COMMENT '创建人',
    `create_time` DATETIME NOT NULL COMMENT '创建时间',
    `update_by` VARCHAR(64) COMMENT '更新人',
    `update_time` DATETIME COMMENT '更新时间',
    `del_flag` CHAR(1) NOT NULL DEFAULT '0' COMMENT '逻辑删除标识',
    `remark` VARCHAR(500) COMMENT '备注',
    PRIMARY KEY (`sap_prod_order_map_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='SAP生产订单映射表';

-- ----------------------------
-- Table: pro_person_master - 人员主数据表
-- ----------------------------
DROP TABLE IF EXISTS `pro_person_master`;
CREATE TABLE `pro_person_master` (
    `person_id` BIGINT NOT NULL COMMENT '人员ID',
    `person_code` VARCHAR(64) NOT NULL COMMENT '人员编码',
    `person_name` VARCHAR(128) NOT NULL COMMENT '人员姓名',
    `person_type` VARCHAR(32) COMMENT '人员类型',
    `dept_code` VARCHAR(64) NOT NULL COMMENT '部门编码',
    `phone` VARCHAR(64) COMMENT '电话',
    `email` VARCHAR(64) COMMENT '邮箱',
    `status` VARCHAR(20) NOT NULL DEFAULT '0' COMMENT '状态',
    `create_by` VARCHAR(64) NOT NULL COMMENT '创建人',
    `create_time` DATETIME NOT NULL COMMENT '创建时间',
    `update_by` VARCHAR(64) COMMENT '更新人',
    `update_time` DATETIME COMMENT '更新时间',
    `del_flag` CHAR(1) NOT NULL DEFAULT '0' COMMENT '逻辑删除标识',
    `remark` VARCHAR(500) COMMENT '备注',
    PRIMARY KEY (`person_id`),
    UNIQUE KEY `uk_person_master_person_code` (`person_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='人员主数据表';

-- ----------------------------
-- Table: pro_work_center_person_map - 工作中心人员关系表
-- ----------------------------
DROP TABLE IF EXISTS `pro_work_center_person_map`;
CREATE TABLE `pro_work_center_person_map` (
    `wc_person_map_id` BIGINT NOT NULL COMMENT '工作中心人员关系ID',
    `work_center_id` BIGINT NOT NULL COMMENT '工作中心ID',
    `person_id` BIGINT NOT NULL COMMENT '人员ID',
    `role_type` VARCHAR(32) COMMENT '角色类型',
    `effective_from` DATETIME COMMENT '生效开始时间',
    `effective_to` DATETIME COMMENT '生效结束时间',
    `status` VARCHAR(20) NOT NULL DEFAULT '0' COMMENT '状态',
    `create_by` VARCHAR(64) NOT NULL COMMENT '创建人',
    `create_time` DATETIME NOT NULL COMMENT '创建时间',
    `update_by` VARCHAR(64) COMMENT '更新人',
    `update_time` DATETIME COMMENT '更新时间',
    `del_flag` CHAR(1) NOT NULL DEFAULT '0' COMMENT '逻辑删除标识',
    `remark` VARCHAR(500) COMMENT '备注',
    PRIMARY KEY (`wc_person_map_id`),
    UNIQUE KEY `uk_work_center_person_map_role_type` (`role_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='工作中心人员关系表';

-- ----------------------------
-- Table: pro_tooling_master - 工装主数据表
-- ----------------------------
DROP TABLE IF EXISTS `pro_tooling_master`;
CREATE TABLE `pro_tooling_master` (
    `tooling_id` BIGINT NOT NULL COMMENT '工装ID',
    `tooling_code` VARCHAR(64) NOT NULL COMMENT '工装编码',
    `tooling_name` VARCHAR(128) NOT NULL COMMENT '工装名称',
    `tooling_type` VARCHAR(32) COMMENT '工装类型',
    `spec_model` VARCHAR(64) COMMENT '规格型号',
    `owner_dept` VARCHAR(64) COMMENT '所属部门',
    `status` VARCHAR(20) NOT NULL DEFAULT '0' COMMENT '状态',
    `create_by` VARCHAR(64) NOT NULL COMMENT '创建人',
    `create_time` DATETIME NOT NULL COMMENT '创建时间',
    `update_by` VARCHAR(64) COMMENT '更新人',
    `update_time` DATETIME COMMENT '更新时间',
    `del_flag` CHAR(1) NOT NULL DEFAULT '0' COMMENT '逻辑删除标识',
    `remark` VARCHAR(500) COMMENT '备注',
    PRIMARY KEY (`tooling_id`),
    UNIQUE KEY `uk_tooling_master_tooling_code` (`tooling_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='工装主数据表';

-- ----------------------------
-- Table: pro_fixture_master - 夹具主数据表
-- ----------------------------
DROP TABLE IF EXISTS `pro_fixture_master`;
CREATE TABLE `pro_fixture_master` (
    `fixture_id` BIGINT NOT NULL COMMENT '夹具ID',
    `fixture_code` VARCHAR(64) NOT NULL COMMENT '夹具编码',
    `fixture_name` VARCHAR(128) NOT NULL COMMENT '夹具名称',
    `fixture_type` VARCHAR(32) COMMENT '夹具类型',
    `spec_model` VARCHAR(64) COMMENT '规格型号',
    `owner_dept` VARCHAR(64) COMMENT '所属部门',
    `status` VARCHAR(20) NOT NULL DEFAULT '0' COMMENT '状态',
    `create_by` VARCHAR(64) NOT NULL COMMENT '创建人',
    `create_time` DATETIME NOT NULL COMMENT '创建时间',
    `update_by` VARCHAR(64) COMMENT '更新人',
    `update_time` DATETIME COMMENT '更新时间',
    `del_flag` CHAR(1) NOT NULL DEFAULT '0' COMMENT '逻辑删除标识',
    `remark` VARCHAR(500) COMMENT '备注',
    PRIMARY KEY (`fixture_id`),
    UNIQUE KEY `uk_fixture_master_fixture_code` (`fixture_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='夹具主数据表';

-- ----------------------------
-- Table: pro_bom_substitution_group - BOM替代组表
-- ----------------------------
DROP TABLE IF EXISTS `pro_bom_substitution_group`;
CREATE TABLE `pro_bom_substitution_group` (
    `bom_sub_group_id` BIGINT NOT NULL COMMENT '替代组ID',
    `bom_item_id` BIGINT NOT NULL COMMENT 'BOM明细ID',
    `group_code` VARCHAR(64) NOT NULL COMMENT '组编码',
    `group_name` VARCHAR(128) NOT NULL COMMENT '组名称',
    `substitution_type` VARCHAR(32) COMMENT '替代类型',
    `priority_rule` VARCHAR(64) COMMENT '优先级规则',
    `approval_required_flag` CHAR(1) NOT NULL DEFAULT 'N' COMMENT '是否需要审批',
    `status` VARCHAR(20) NOT NULL DEFAULT '0' COMMENT '状态',
    `create_by` VARCHAR(64) NOT NULL COMMENT '创建人',
    `create_time` DATETIME NOT NULL COMMENT '创建时间',
    `update_by` VARCHAR(64) COMMENT '更新人',
    `update_time` DATETIME COMMENT '更新时间',
    `del_flag` CHAR(1) NOT NULL DEFAULT '0' COMMENT '逻辑删除标识',
    `remark` VARCHAR(500) COMMENT '备注',
    PRIMARY KEY (`bom_sub_group_id`),
    UNIQUE KEY `uk_bom_substitution_group_group_code` (`group_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='BOM替代组表';

-- ----------------------------
-- Table: pro_bom_substitution_item - BOM替代料明细表
-- ----------------------------
DROP TABLE IF EXISTS `pro_bom_substitution_item`;
CREATE TABLE `pro_bom_substitution_item` (
    `bom_sub_item_id` BIGINT NOT NULL COMMENT '替代料明细ID',
    `bom_sub_group_id` BIGINT NOT NULL COMMENT '替代组ID',
    `sub_material_id` BIGINT NOT NULL COMMENT '替代物料ID',
    `priority_no` VARCHAR(64) NOT NULL COMMENT '优先级',
    `sub_qty` DECIMAL(18,6) NOT NULL DEFAULT 0 COMMENT '替代数量',
    `sub_uom` VARCHAR(20) COMMENT '替代单位',
    `effective_from` DATETIME COMMENT '生效开始时间',
    `effective_to` DATETIME COMMENT '生效结束时间',
    `approval_status` VARCHAR(20) NOT NULL DEFAULT '0' COMMENT '审批状态',
    `status` VARCHAR(20) NOT NULL DEFAULT '0' COMMENT '状态',
    `create_by` VARCHAR(64) NOT NULL COMMENT '创建人',
    `create_time` DATETIME NOT NULL COMMENT '创建时间',
    `update_by` VARCHAR(64) COMMENT '更新人',
    `update_time` DATETIME COMMENT '更新时间',
    `del_flag` CHAR(1) NOT NULL DEFAULT '0' COMMENT '逻辑删除标识',
    `remark` VARCHAR(500) COMMENT '备注',
    PRIMARY KEY (`bom_sub_item_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='BOM替代料明细表';

-- ----------------------------
-- Table: pro_bom_cutover_rule - BOM切换规则表
-- ----------------------------
DROP TABLE IF EXISTS `pro_bom_cutover_rule`;
CREATE TABLE `pro_bom_cutover_rule` (
    `cutover_rule_id` BIGINT NOT NULL COMMENT '切换规则ID',
    `bom_item_id` BIGINT NOT NULL COMMENT 'BOM明细ID',
    `from_material_id` BIGINT NOT NULL COMMENT '原物料ID',
    `to_material_id` BIGINT NOT NULL COMMENT '新物料ID',
    `cutover_type` VARCHAR(32) COMMENT '切换类型',
    `trigger_type` VARCHAR(32) COMMENT '触发类型',
    `trigger_value` VARCHAR(64) COMMENT '触发值',
    `effective_from` DATETIME COMMENT '生效开始时间',
    `effective_to` DATETIME COMMENT '生效结束时间',
    `rule_status` VARCHAR(20) NOT NULL DEFAULT '0' COMMENT '规则状态',
    `create_by` VARCHAR(64) NOT NULL COMMENT '创建人',
    `create_time` DATETIME NOT NULL COMMENT '创建时间',
    `update_by` VARCHAR(64) COMMENT '更新人',
    `update_time` DATETIME COMMENT '更新时间',
    `del_flag` CHAR(1) NOT NULL DEFAULT '0' COMMENT '逻辑删除标识',
    `remark` VARCHAR(500) COMMENT '备注',
    PRIMARY KEY (`cutover_rule_id`),
    UNIQUE KEY `uk_bom_cutover_rule_cutover_type` (`cutover_type`),
    UNIQUE KEY `uk_bom_cutover_rule_trigger_type` (`trigger_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='BOM切换规则表';

-- ----------------------------
-- Table: pro_bom_cutover_execution_log - BOM切换执行日志表
-- ----------------------------
DROP TABLE IF EXISTS `pro_bom_cutover_execution_log`;
CREATE TABLE `pro_bom_cutover_execution_log` (
    `cutover_exec_id` BIGINT NOT NULL COMMENT '切换执行ID',
    `cutover_rule_id` BIGINT NOT NULL COMMENT '切换规则ID',
    `prod_order_id` BIGINT NOT NULL COMMENT '生产工单ID',
    `order_component_id` BIGINT NOT NULL COMMENT '工单组件ID',
    `from_material_id` BIGINT NOT NULL COMMENT '原物料ID',
    `to_material_id` BIGINT NOT NULL COMMENT '新物料ID',
    `trigger_value` VARCHAR(64) COMMENT '触发值',
    `exec_time` DATETIME COMMENT '执行时间',
    `exec_result` VARCHAR(64) COMMENT '执行结果',
    `create_by` VARCHAR(64) NOT NULL COMMENT '创建人',
    `create_time` DATETIME NOT NULL COMMENT '创建时间',
    `del_flag` CHAR(1) NOT NULL DEFAULT '0' COMMENT '逻辑删除标识',
    `remark` VARCHAR(500) COMMENT '备注',
    PRIMARY KEY (`cutover_exec_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='BOM切换执行日志表';

-- ----------------------------
-- Table: pro_supplier_master - 供应商主数据表
-- ----------------------------
DROP TABLE IF EXISTS `pro_supplier_master`;
CREATE TABLE `pro_supplier_master` (
    `supplier_id` BIGINT NOT NULL COMMENT '供应商ID',
    `supplier_code` VARCHAR(64) NOT NULL COMMENT '供应商编码',
    `supplier_name` VARCHAR(128) NOT NULL COMMENT '供应商名称',
    `supplier_type` VARCHAR(32) COMMENT '供应商类型',
    `contact_person` VARCHAR(64) COMMENT '联系人',
    `contact_phone` VARCHAR(64) COMMENT '联系电话',
    `status` VARCHAR(20) NOT NULL DEFAULT '0' COMMENT '状态',
    `create_by` VARCHAR(64) NOT NULL COMMENT '创建人',
    `create_time` DATETIME NOT NULL COMMENT '创建时间',
    `update_by` VARCHAR(64) COMMENT '更新人',
    `update_time` DATETIME COMMENT '更新时间',
    `del_flag` CHAR(1) NOT NULL DEFAULT '0' COMMENT '逻辑删除标识',
    `remark` VARCHAR(500) COMMENT '备注',
    PRIMARY KEY (`supplier_id`),
    UNIQUE KEY `uk_supplier_master_supplier_code` (`supplier_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='供应商主数据表';

-- ----------------------------
-- Table: pro_goods_receipt - 收货单头表
-- ----------------------------
DROP TABLE IF EXISTS `pro_goods_receipt`;
CREATE TABLE `pro_goods_receipt` (
    `gr_id` BIGINT NOT NULL COMMENT '收货单ID',
    `gr_no` VARCHAR(64) NOT NULL COMMENT '收货单号',
    `supplier_id` BIGINT NOT NULL COMMENT '供应商ID',
    `warehouse_id` BIGINT NOT NULL COMMENT '仓库ID',
    `receipt_date` DATE COMMENT '收货日期',
    `receipt_type` VARCHAR(32) COMMENT '收货类型',
    `gr_status` VARCHAR(20) NOT NULL DEFAULT '0' COMMENT '收货状态',
    `source_doc_no` VARCHAR(64) NOT NULL COMMENT '来源单号',
    `create_by` VARCHAR(64) NOT NULL COMMENT '创建人',
    `create_time` DATETIME NOT NULL COMMENT '创建时间',
    `update_by` VARCHAR(64) COMMENT '更新人',
    `update_time` DATETIME COMMENT '更新时间',
    `del_flag` CHAR(1) NOT NULL DEFAULT '0' COMMENT '逻辑删除标识',
    `remark` VARCHAR(500) COMMENT '备注',
    PRIMARY KEY (`gr_id`),
    UNIQUE KEY `uk_goods_receipt_gr_no` (`gr_no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='收货单头表';

-- ----------------------------
-- Table: pro_goods_receipt_item - 收货单明细表
-- ----------------------------
DROP TABLE IF EXISTS `pro_goods_receipt_item`;
CREATE TABLE `pro_goods_receipt_item` (
    `gr_item_id` BIGINT NOT NULL COMMENT '收货明细ID',
    `gr_id` BIGINT NOT NULL COMMENT '收货单ID',
    `line_no` VARCHAR(64) NOT NULL COMMENT '行号',
    `material_id` BIGINT NOT NULL COMMENT '物料ID',
    `received_qty` DECIMAL(18,6) NOT NULL DEFAULT 0 COMMENT '接收数量',
    `received_uom` VARCHAR(20) COMMENT '接收单位',
    `lot_no` VARCHAR(64) NOT NULL COMMENT '批次号',
    `storage_location_id` BIGINT NOT NULL COMMENT '库位ID',
    `item_status` VARCHAR(20) NOT NULL DEFAULT '0' COMMENT '项目状态',
    `create_by` VARCHAR(64) NOT NULL COMMENT '创建人',
    `create_time` DATETIME NOT NULL COMMENT '创建时间',
    `update_by` VARCHAR(64) COMMENT '更新人',
    `update_time` DATETIME COMMENT '更新时间',
    `del_flag` CHAR(1) NOT NULL DEFAULT '0' COMMENT '逻辑删除标识',
    `remark` VARCHAR(500) COMMENT '备注',
    PRIMARY KEY (`gr_item_id`),
    UNIQUE KEY `uk_goods_receipt_item_line_no` (`line_no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='收货单明细表';

-- ----------------------------
-- Table: pro_serial_number - 物料序列号表
-- ----------------------------
DROP TABLE IF EXISTS `pro_serial_number`;
CREATE TABLE `pro_serial_number` (
    `serial_id` BIGINT NOT NULL COMMENT '序列号ID',
    `material_id` BIGINT NOT NULL COMMENT '物料ID',
    `serial_no` VARCHAR(64) NOT NULL COMMENT '序列号',
    `material_lot_id` BIGINT NOT NULL COMMENT '物料批次ID',
    `serial_status` VARCHAR(20) NOT NULL DEFAULT '0' COMMENT '序列号状态',
    `current_location` VARCHAR(64) COMMENT '当前位置',
    `create_by` VARCHAR(64) NOT NULL COMMENT '创建人',
    `create_time` DATETIME NOT NULL COMMENT '创建时间',
    `update_by` VARCHAR(64) COMMENT '更新人',
    `update_time` DATETIME COMMENT '更新时间',
    `del_flag` CHAR(1) NOT NULL DEFAULT '0' COMMENT '逻辑删除标识',
    `remark` VARCHAR(500) COMMENT '备注',
    PRIMARY KEY (`serial_id`),
    UNIQUE KEY `uk_serial_number_serial_no` (`serial_no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='物料序列号表';

-- ----------------------------
-- Table: pro_wip_lot - 在制品批次表
-- ----------------------------
DROP TABLE IF EXISTS `pro_wip_lot`;
CREATE TABLE `pro_wip_lot` (
    `wip_lot_id` BIGINT NOT NULL COMMENT '在制批次ID',
    `prod_order_id` BIGINT NOT NULL COMMENT '生产工单ID',
    `material_id` BIGINT NOT NULL COMMENT '物料ID',
    `wip_lot_no` VARCHAR(64) NOT NULL COMMENT '在制批次号',
    `current_order_op_id` BIGINT NOT NULL COMMENT '当前工单工序ID',
    `qty` DECIMAL(18,6) NOT NULL DEFAULT 0 COMMENT '数量',
    `uom` VARCHAR(20) COMMENT '单位',
    `wip_status` VARCHAR(20) NOT NULL DEFAULT '0' COMMENT '在制状态',
    `create_by` VARCHAR(64) NOT NULL COMMENT '创建人',
    `create_time` DATETIME NOT NULL COMMENT '创建时间',
    `update_by` VARCHAR(64) COMMENT '更新人',
    `update_time` DATETIME COMMENT '更新时间',
    `del_flag` CHAR(1) NOT NULL DEFAULT '0' COMMENT '逻辑删除标识',
    `remark` VARCHAR(500) COMMENT '备注',
    PRIMARY KEY (`wip_lot_id`),
    UNIQUE KEY `uk_wip_lot_wip_lot_no` (`wip_lot_no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='在制品批次表';

-- ----------------------------
-- Table: pro_wip_lot_tracking - 在制品批次跟踪表
-- ----------------------------
DROP TABLE IF EXISTS `pro_wip_lot_tracking`;
CREATE TABLE `pro_wip_lot_tracking` (
    `wip_track_id` BIGINT NOT NULL COMMENT '在制流转ID',
    `wip_lot_id` BIGINT NOT NULL COMMENT '在制批次ID',
    `from_order_op_id` BIGINT NOT NULL COMMENT '来源工序ID',
    `to_order_op_id` BIGINT NOT NULL COMMENT '目标工序ID',
    `move_qty` DECIMAL(18,6) NOT NULL DEFAULT 0 COMMENT '流转数量',
    `move_uom` VARCHAR(20) COMMENT '流转单位',
    `move_time` DATETIME COMMENT '流转时间',
    `operator_id` BIGINT NOT NULL COMMENT '操作人ID',
    `track_status` VARCHAR(20) NOT NULL DEFAULT '0' COMMENT '跟踪状态',
    `create_by` VARCHAR(64) NOT NULL COMMENT '创建人',
    `create_time` DATETIME NOT NULL COMMENT '创建时间',
    `del_flag` CHAR(1) NOT NULL DEFAULT '0' COMMENT '逻辑删除标识',
    `remark` VARCHAR(500) COMMENT '备注',
    PRIMARY KEY (`wip_track_id`),
    UNIQUE KEY `uk_wip_lot_tracking_move_time` (`move_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='在制品批次跟踪表';

-- ----------------------------
-- Table: pro_finished_good_lot - 成品批次表
-- ----------------------------
DROP TABLE IF EXISTS `pro_finished_good_lot`;
CREATE TABLE `pro_finished_good_lot` (
    `fg_lot_id` BIGINT NOT NULL COMMENT '成品批次ID',
    `prod_order_id` BIGINT NOT NULL COMMENT '生产工单ID',
    `material_id` BIGINT NOT NULL COMMENT '物料ID',
    `fg_lot_no` VARCHAR(64) NOT NULL COMMENT '成品批次号',
    `qty` DECIMAL(18,6) NOT NULL DEFAULT 0 COMMENT '数量',
    `uom` VARCHAR(20) COMMENT '单位',
    `produce_time` DATETIME COMMENT '生产时间',
    `fg_status` VARCHAR(20) NOT NULL DEFAULT '0' COMMENT '成品批次状态',
    `create_by` VARCHAR(64) NOT NULL COMMENT '创建人',
    `create_time` DATETIME NOT NULL COMMENT '创建时间',
    `update_by` VARCHAR(64) COMMENT '更新人',
    `update_time` DATETIME COMMENT '更新时间',
    `del_flag` CHAR(1) NOT NULL DEFAULT '0' COMMENT '逻辑删除标识',
    `remark` VARCHAR(500) COMMENT '备注',
    PRIMARY KEY (`fg_lot_id`),
    UNIQUE KEY `uk_finished_good_lot_fg_lot_no` (`fg_lot_no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='成品批次表';

-- ----------------------------
-- Table: pro_finished_good_serial - 成品序列号表
-- ----------------------------
DROP TABLE IF EXISTS `pro_finished_good_serial`;
CREATE TABLE `pro_finished_good_serial` (
    `fg_serial_id` BIGINT NOT NULL COMMENT '成品序列号ID',
    `fg_lot_id` BIGINT NOT NULL COMMENT '成品批次ID',
    `material_id` BIGINT NOT NULL COMMENT '物料ID',
    `serial_no` VARCHAR(64) NOT NULL COMMENT '序列号',
    `udi_code` VARCHAR(64) NOT NULL COMMENT 'UDI编码',
    `fg_serial_status` VARCHAR(20) NOT NULL DEFAULT '0' COMMENT '成品序列号状态',
    `create_by` VARCHAR(64) NOT NULL COMMENT '创建人',
    `create_time` DATETIME NOT NULL COMMENT '创建时间',
    `update_by` VARCHAR(64) COMMENT '更新人',
    `update_time` DATETIME COMMENT '更新时间',
    `del_flag` CHAR(1) NOT NULL DEFAULT '0' COMMENT '逻辑删除标识',
    `remark` VARCHAR(500) COMMENT '备注',
    PRIMARY KEY (`fg_serial_id`),
    UNIQUE KEY `uk_finished_good_serial_serial_no` (`serial_no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='成品序列号表';

-- ----------------------------
-- Table: pro_lot_genealogy - 批次族谱表
-- ----------------------------
DROP TABLE IF EXISTS `pro_lot_genealogy`;
CREATE TABLE `pro_lot_genealogy` (
    `lot_genealogy_id` BIGINT NOT NULL COMMENT '批次族谱ID',
    `source_lot_type` VARCHAR(32) COMMENT '来源批次类型',
    `source_lot_id` BIGINT COMMENT '来源批次ID',
    `source_material_lot_id` BIGINT COMMENT '来源物料批次ID',
    `source_wip_lot_id` BIGINT COMMENT '来源在制批次ID',
    `source_fg_lot_id` BIGINT COMMENT '来源成品批次ID',
    `target_lot_type` VARCHAR(32) COMMENT '目标批次类型',
    `target_lot_id` BIGINT COMMENT '目标批次ID',
    `target_material_lot_id` BIGINT COMMENT '目标物料批次ID',
    `target_wip_lot_id` BIGINT COMMENT '目标在制批次ID',
    `target_fg_lot_id` BIGINT COMMENT '目标成品批次ID',
    `relation_type` VARCHAR(32) COMMENT '关系类型',
    `qty` DECIMAL(18,6) NOT NULL DEFAULT 0 COMMENT '数量',
    `uom` VARCHAR(20) COMMENT '单位',
    `source_event_id` BIGINT NOT NULL COMMENT '来源事件ID',
    `create_time` DATETIME NOT NULL COMMENT '创建时间',
    `del_flag` CHAR(1) NOT NULL DEFAULT '0' COMMENT '逻辑删除标识',
    `remark` VARCHAR(500) COMMENT '备注',
    PRIMARY KEY (`lot_genealogy_id`),
    UNIQUE KEY `uk_lot_genealogy_source_lot_type` (`source_lot_type`),
    UNIQUE KEY `uk_lot_genealogy_source_lot_id` (`source_lot_id`),
    UNIQUE KEY `uk_lot_genealogy_target_lot_type` (`target_lot_type`),
    UNIQUE KEY `uk_lot_genealogy_target_lot_id` (`target_lot_id`),
    UNIQUE KEY `uk_lot_genealogy_relation_type` (`relation_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='批次族谱表';

-- ----------------------------
-- Table: pro_serial_genealogy - 序列号族谱表
-- ----------------------------
DROP TABLE IF EXISTS `pro_serial_genealogy`;
CREATE TABLE `pro_serial_genealogy` (
    `serial_genealogy_id` BIGINT NOT NULL COMMENT '序列号族谱ID',
    `parent_serial_type` VARCHAR(32) COMMENT '父级序列号类型',
    `parent_serial_id` BIGINT COMMENT '父级序列号ID',
    `parent_material_serial_id` BIGINT COMMENT '父级物料序列号ID',
    `parent_fg_serial_id` BIGINT COMMENT '父级成品序列号ID',
    `child_serial_type` VARCHAR(32) COMMENT '子级序列号类型',
    `child_serial_id` BIGINT COMMENT '子级序列号ID',
    `child_material_serial_id` BIGINT COMMENT '子级物料序列号ID',
    `child_fg_serial_id` BIGINT COMMENT '子级成品序列号ID',
    `relation_type` VARCHAR(32) COMMENT '关系类型',
    `source_event_id` BIGINT NOT NULL COMMENT '来源事件ID',
    `create_time` DATETIME NOT NULL COMMENT '创建时间',
    `del_flag` CHAR(1) NOT NULL DEFAULT '0' COMMENT '逻辑删除标识',
    `remark` VARCHAR(500) COMMENT '备注',
    PRIMARY KEY (`serial_genealogy_id`),
    UNIQUE KEY `uk_serial_genealogy_parent_serial_type` (`parent_serial_type`),
    UNIQUE KEY `uk_serial_genealogy_parent_serial_id` (`parent_serial_id`),
    UNIQUE KEY `uk_serial_genealogy_child_serial_type` (`child_serial_type`),
    UNIQUE KEY `uk_serial_genealogy_child_serial_id` (`child_serial_id`),
    UNIQUE KEY `uk_serial_genealogy_relation_type` (`relation_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='序列号族谱表';

-- ----------------------------
-- Table: pro_report_confirmation_if - 报工确认接口表
-- ----------------------------
DROP TABLE IF EXISTS `pro_report_confirmation_if`;
CREATE TABLE `pro_report_confirmation_if` (
    `report_if_id` BIGINT NOT NULL COMMENT '报工接口ID',
    `interface_msg_id` BIGINT NOT NULL COMMENT '接口消息ID',
    `report_id` BIGINT NOT NULL COMMENT '报工ID',
    `sap_order_no` VARCHAR(64) NOT NULL COMMENT 'SAP订单号',
    `sap_operation_no` VARCHAR(64) NOT NULL COMMENT 'SAP工序号',
    `confirm_qty` DECIMAL(18,6) NOT NULL DEFAULT 0 COMMENT '确认数量',
    `confirm_uom` VARCHAR(20) COMMENT '确认单位',
    `posting_status` VARCHAR(20) NOT NULL DEFAULT '0' COMMENT '过账状态',
    `posting_time` DATETIME COMMENT '过账时间',
    `error_message` VARCHAR(500) COMMENT '错误信息',
    `create_time` DATETIME NOT NULL COMMENT '创建时间',
    `update_time` DATETIME COMMENT '更新时间',
    `del_flag` CHAR(1) NOT NULL DEFAULT '0' COMMENT '逻辑删除标识',
    `remark` VARCHAR(500) COMMENT '备注',
    PRIMARY KEY (`report_if_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='报工确认接口表';

-- ----------------------------
-- Table: pro_inspection_result_if - 检验结果接口表
-- ----------------------------
DROP TABLE IF EXISTS `pro_inspection_result_if`;
CREATE TABLE `pro_inspection_result_if` (
    `insp_if_id` BIGINT NOT NULL COMMENT '检验接口ID',
    `interface_msg_id` BIGINT NOT NULL COMMENT '接口消息ID',
    `insp_result_id` BIGINT NOT NULL COMMENT '检验结果ID',
    `sap_order_no` VARCHAR(64) NOT NULL COMMENT 'SAP订单号',
    `sap_operation_no` VARCHAR(64) NOT NULL COMMENT 'SAP工序号',
    `inspection_lot_no` VARCHAR(64) NOT NULL COMMENT '检验批号',
    `result_payload` VARCHAR(500) COMMENT '结果报文',
    `posting_status` VARCHAR(20) NOT NULL DEFAULT '0' COMMENT '过账状态',
    `posting_time` DATETIME COMMENT '过账时间',
    `error_message` VARCHAR(500) COMMENT '错误信息',
    `create_time` DATETIME NOT NULL COMMENT '创建时间',
    `update_time` DATETIME COMMENT '更新时间',
    `del_flag` CHAR(1) NOT NULL DEFAULT '0' COMMENT '逻辑删除标识',
    `remark` VARCHAR(500) COMMENT '备注',
    PRIMARY KEY (`insp_if_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='检验结果接口表';

-- ----------------------------
-- Table: pro_consumption_posting_if - 投料过账接口表
-- ----------------------------
DROP TABLE IF EXISTS `pro_consumption_posting_if`;
CREATE TABLE `pro_consumption_posting_if` (
    `consume_if_id` BIGINT NOT NULL COMMENT '投料接口ID',
    `interface_msg_id` BIGINT NOT NULL COMMENT '接口消息ID',
    `op_consume_id` BIGINT NOT NULL COMMENT '投料记录ID',
    `sap_order_no` VARCHAR(64) NOT NULL COMMENT 'SAP订单号',
    `sap_reservation_no` VARCHAR(64) NOT NULL COMMENT 'SAP预留号',
    `sap_reservation_item` VARCHAR(64) COMMENT 'SAP预留行号',
    `material_code` VARCHAR(64) NOT NULL COMMENT '物料编码',
    `posting_qty` DECIMAL(18,6) NOT NULL DEFAULT 0 COMMENT '过账数量',
    `posting_uom` VARCHAR(20) COMMENT '过账单位',
    `posting_status` VARCHAR(20) NOT NULL DEFAULT '0' COMMENT '过账状态',
    `posting_time` DATETIME COMMENT '过账时间',
    `error_message` VARCHAR(500) COMMENT '错误信息',
    `create_time` DATETIME NOT NULL COMMENT '创建时间',
    `update_time` DATETIME COMMENT '更新时间',
    `del_flag` CHAR(1) NOT NULL DEFAULT '0' COMMENT '逻辑删除标识',
    `remark` VARCHAR(500) COMMENT '备注',
    PRIMARY KEY (`consume_if_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='投料过账接口表';

-- ================================================
-- ROLLBACK 回滚脚本
-- ================================================
-- DROP TABLE IF EXISTS `pro_consumption_posting_if`;
-- DROP TABLE IF EXISTS `pro_inspection_result_if`;
-- DROP TABLE IF EXISTS `pro_report_confirmation_if`;
-- DROP TABLE IF EXISTS `pro_serial_genealogy`;
-- DROP TABLE IF EXISTS `pro_lot_genealogy`;
-- DROP TABLE IF EXISTS `pro_finished_good_serial`;
-- DROP TABLE IF EXISTS `pro_finished_good_lot`;
-- DROP TABLE IF EXISTS `pro_wip_lot_tracking`;
-- DROP TABLE IF EXISTS `pro_wip_lot`;
-- DROP TABLE IF EXISTS `pro_serial_number`;
-- DROP TABLE IF EXISTS `pro_goods_receipt_item`;
-- DROP TABLE IF EXISTS `pro_goods_receipt`;
-- DROP TABLE IF EXISTS `pro_supplier_master`;
-- DROP TABLE IF EXISTS `pro_bom_cutover_execution_log`;
-- DROP TABLE IF EXISTS `pro_bom_cutover_rule`;
-- DROP TABLE IF EXISTS `pro_bom_substitution_item`;
-- DROP TABLE IF EXISTS `pro_bom_substitution_group`;
-- DROP TABLE IF EXISTS `pro_fixture_master`;
-- DROP TABLE IF EXISTS `pro_tooling_master`;
-- DROP TABLE IF EXISTS `pro_work_center_person_map`;
-- DROP TABLE IF EXISTS `pro_person_master`;
-- DROP TABLE IF EXISTS `pro_sap_production_order_map`;
-- DROP TABLE IF EXISTS `pro_sap_work_center_map`;
-- DROP TABLE IF EXISTS `pro_sap_operation_map`;
-- DROP TABLE IF EXISTS `pro_sap_routing_map`;
-- DROP TABLE IF EXISTS `pro_sap_bom_item_map`;
-- DROP TABLE IF EXISTS `pro_sap_bom_map`;
-- DROP TABLE IF EXISTS `pro_sap_material_map`;
-- DROP TABLE IF EXISTS `pro_sap_plant_map`;
-- DROP TABLE IF EXISTS `pro_sap_production_order_ref`;
-- DROP TABLE IF EXISTS `pro_sap_work_center_ref`;
-- DROP TABLE IF EXISTS `pro_sap_operation_ref`;
-- DROP TABLE IF EXISTS `pro_sap_routing_ref`;
-- DROP TABLE IF EXISTS `pro_sap_bom_item_ref`;
-- DROP TABLE IF EXISTS `pro_sap_bom_ref`;
-- DROP TABLE IF EXISTS `pro_sap_material_ref`;
-- DROP TABLE IF EXISTS `pro_sap_plant_ref`;
-- DROP TABLE IF EXISTS `pro_sap_system`;