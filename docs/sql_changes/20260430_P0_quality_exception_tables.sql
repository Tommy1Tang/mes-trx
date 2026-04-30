-- ================================================
-- 变更编号：DM-20260430-001
-- 变更类型：新增表
-- 变更描述：质量与异常表建表SQL（11张表）
-- 变更原因：MES系统基础表设计
-- 影响范围：质量管理、异常管理模块
-- 执行人：AI-DBA
-- 执行日期：2026-04-30
-- ================================================

-- ----------------------------
-- Table: pro_exception_category - 异常分类配置表
-- ----------------------------
DROP TABLE IF EXISTS `pro_exception_category`;
CREATE TABLE `pro_exception_category` (
    `category_id` BIGINT NOT NULL COMMENT '异常分类ID',
    `parent_id` BIGINT DEFAULT 0 COMMENT '父级ID',
    `category_code` VARCHAR(64) NOT NULL COMMENT '分类编码',
    `category_name` VARCHAR(128) NOT NULL COMMENT '分类名称',
    `category_type` VARCHAR(32) NOT NULL COMMENT '分类类型',
    `severity_level` VARCHAR(20) NOT NULL DEFAULT 'NORMAL' COMMENT '严重等级',
    `response_time_limit` INT DEFAULT 0 COMMENT '响应时限分钟',
    `escalation_flag` CHAR(1) NOT NULL DEFAULT 'N' COMMENT '是否启用升级',
    `status` VARCHAR(20) NOT NULL DEFAULT '0' COMMENT '状态',
    `create_by` VARCHAR(64) NOT NULL COMMENT '创建人',
    `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_by` VARCHAR(64) COMMENT '更新人',
    `update_time` DATETIME COMMENT '更新时间',
    `del_flag` CHAR(1) NOT NULL DEFAULT '0' COMMENT '逻辑删除标识',
    `remark` VARCHAR(500) COMMENT '备注',
    PRIMARY KEY (`category_id`),
    UNIQUE KEY `uk_exception_category_category_code` (`category_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='异常分类配置表';

-- ----------------------------
-- Table: pro_exception_escalation - 异常升级记录表
-- ----------------------------
DROP TABLE IF EXISTS `pro_exception_escalation`;
CREATE TABLE `pro_exception_escalation` (
    `escalation_id` BIGINT NOT NULL COMMENT '异常升级ID',
    `exception_id` BIGINT NOT NULL COMMENT '异常记录ID',
    `source_module` VARCHAR(64) COMMENT '来源模块',
    `source_biz_id` BIGINT COMMENT '来源业务ID',
    `category_id` BIGINT COMMENT '异常分类ID',
    `escalation_level` INT NOT NULL DEFAULT 1 COMMENT '升级等级',
    `from_person_id` BIGINT COMMENT '升级发起人ID',
    `to_person_id` BIGINT COMMENT '升级接收人ID',
    `escalation_reason` VARCHAR(500) COMMENT '升级原因',
    `escalation_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '升级时间',
    `handle_status` VARCHAR(20) NOT NULL DEFAULT 'PENDING' COMMENT '处理状态',
    `handle_time` DATETIME COMMENT '处理时间',
    `status` VARCHAR(20) NOT NULL DEFAULT '0' COMMENT '状态',
    `create_by` VARCHAR(64) NOT NULL COMMENT '创建人',
    `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_by` VARCHAR(64) COMMENT '更新人',
    `update_time` DATETIME COMMENT '更新时间',
    `del_flag` CHAR(1) NOT NULL DEFAULT '0' COMMENT '逻辑删除标识',
    `remark` VARCHAR(500) COMMENT '备注',
    PRIMARY KEY (`escalation_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='异常升级记录表';

-- ----------------------------
-- Table: pro_exception_record - 异常记录主表
-- ----------------------------
DROP TABLE IF EXISTS `pro_exception_record`;
CREATE TABLE `pro_exception_record` (
    `exception_id` BIGINT NOT NULL COMMENT '异常记录ID',
    `exception_no` VARCHAR(64) NOT NULL COMMENT '异常单号',
    `source_module` VARCHAR(64) NOT NULL COMMENT '来源模块',
    `source_biz_id` BIGINT COMMENT '来源业务ID',
    `category_id` BIGINT COMMENT '异常分类ID',
    `prod_order_id` BIGINT COMMENT '生产工单ID',
    `order_op_id` BIGINT COMMENT '工单工序ID',
    `op_exec_id` BIGINT COMMENT '工序执行ID',
    `exception_title` VARCHAR(200) NOT NULL COMMENT '异常标题',
    `exception_desc` VARCHAR(1000) COMMENT '异常描述',
    `severity_level` VARCHAR(20) NOT NULL DEFAULT 'NORMAL' COMMENT '严重等级',
    `exception_status` VARCHAR(20) NOT NULL DEFAULT 'OPEN' COMMENT '异常状态',
    `found_person_id` BIGINT COMMENT '发现人ID',
    `found_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '发现时间',
    `closed_person_id` BIGINT COMMENT '关闭人ID',
    `closed_time` DATETIME COMMENT '关闭时间',
    `create_by` VARCHAR(64) NOT NULL COMMENT '创建人',
    `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_by` VARCHAR(64) COMMENT '更新人',
    `update_time` DATETIME COMMENT '更新时间',
    `del_flag` CHAR(1) NOT NULL DEFAULT '0' COMMENT '逻辑删除标识',
    `remark` VARCHAR(500) COMMENT '备注',
    PRIMARY KEY (`exception_id`),
    UNIQUE KEY `uk_exception_record_exception_no` (`exception_no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='异常记录主表';

-- ----------------------------
-- Table: pro_nc_handling - 不合格品处置表
-- ----------------------------
DROP TABLE IF EXISTS `pro_nc_handling`;
CREATE TABLE `pro_nc_handling` (
    `handling_id` BIGINT NOT NULL COMMENT '处置ID',
    `handling_no` VARCHAR(64) NOT NULL COMMENT '处置单号',
    `prod_defect_id` BIGINT COMMENT '生产不良ID',
    `insp_result_id` BIGINT COMMENT '检验结果ID',
    `prod_order_id` BIGINT COMMENT '生产工单ID',
    `order_op_id` BIGINT COMMENT '工单工序ID',
    `material_id` BIGINT COMMENT '物料ID',
    `material_lot_id` BIGINT COMMENT '物料批次ID',
    `handling_type` VARCHAR(32) NOT NULL COMMENT '处置类型',
    `handling_result` VARCHAR(32) COMMENT '处置结果',
    `handling_qty` DECIMAL(18,6) NOT NULL DEFAULT 0 COMMENT '处置数量',
    `handler_id` BIGINT COMMENT '处置人ID',
    `handling_time` DATETIME COMMENT '处置时间',
    `approval_status` VARCHAR(20) NOT NULL DEFAULT 'PENDING' COMMENT '审批状态',
    `close_flag` CHAR(1) NOT NULL DEFAULT 'N' COMMENT '是否关闭',
    `create_by` VARCHAR(64) NOT NULL COMMENT '创建人',
    `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_by` VARCHAR(64) COMMENT '更新人',
    `update_time` DATETIME COMMENT '更新时间',
    `del_flag` CHAR(1) NOT NULL DEFAULT '0' COMMENT '逻辑删除标识',
    `remark` VARCHAR(500) COMMENT '备注',
    PRIMARY KEY (`handling_id`),
    UNIQUE KEY `uk_nc_handling_handling_no` (`handling_no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='不合格品处置表';

-- ----------------------------
-- Table: pro_batch_review - 批记录审核流程表
-- ----------------------------
DROP TABLE IF EXISTS `pro_batch_review`;
CREATE TABLE `pro_batch_review` (
    `review_id` BIGINT NOT NULL COMMENT '审核ID',
    `prod_order_id` BIGINT NOT NULL COMMENT '生产工单ID',
    `batch_record_no` VARCHAR(64) NOT NULL COMMENT '批记录编号',
    `review_node` VARCHAR(64) NOT NULL COMMENT '审核节点',
    `reviewer_id` BIGINT COMMENT '审核人ID',
    `review_status` VARCHAR(20) NOT NULL DEFAULT 'PENDING' COMMENT '审核状态',
    `review_comment` VARCHAR(500) COMMENT '审核意见',
    `submit_time` DATETIME COMMENT '提交时间',
    `review_time` DATETIME COMMENT '审核时间',
    `current_flag` CHAR(1) NOT NULL DEFAULT 'N' COMMENT '是否当前节点',
    `status` VARCHAR(20) NOT NULL DEFAULT '0' COMMENT '状态',
    `create_by` VARCHAR(64) NOT NULL COMMENT '创建人',
    `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_by` VARCHAR(64) COMMENT '更新人',
    `update_time` DATETIME COMMENT '更新时间',
    `del_flag` CHAR(1) NOT NULL DEFAULT '0' COMMENT '逻辑删除标识',
    `remark` VARCHAR(500) COMMENT '备注',
    PRIMARY KEY (`review_id`),
    UNIQUE KEY `uk_batch_review_batch_record_no` (`batch_record_no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='批记录审核流程表';

-- ----------------------------
-- Table: pro_defect_code_master - 缺陷代码主数据表
-- ----------------------------
DROP TABLE IF EXISTS `pro_defect_code_master`;
CREATE TABLE `pro_defect_code_master` (
    `defect_code_id` BIGINT NOT NULL COMMENT '缺陷代码ID',
    `defect_code` VARCHAR(64) NOT NULL COMMENT '缺陷编码',
    `defect_name` VARCHAR(128) NOT NULL COMMENT '缺陷名称',
    `defect_type` VARCHAR(32) COMMENT '缺陷类型',
    `severity_level` VARCHAR(64) COMMENT '严重等级',
    `status` VARCHAR(20) NOT NULL DEFAULT '0' COMMENT '状态',
    `create_by` VARCHAR(64) NOT NULL COMMENT '创建人',
    `create_time` DATETIME NOT NULL COMMENT '创建时间',
    `update_by` VARCHAR(64) COMMENT '更新人',
    `update_time` DATETIME COMMENT '更新时间',
    `del_flag` CHAR(1) NOT NULL DEFAULT '0' COMMENT '逻辑删除标识',
    `remark` VARCHAR(500) COMMENT '备注',
    PRIMARY KEY (`defect_code_id`),
    UNIQUE KEY `uk_defect_code_master_defect_code` (`defect_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='缺陷代码主数据表';

-- ----------------------------
-- Table: pro_production_defect - 生产不良表
-- ----------------------------
DROP TABLE IF EXISTS `pro_production_defect`;
CREATE TABLE `pro_production_defect` (
    `prod_defect_id` BIGINT NOT NULL COMMENT '生产不良ID',
    `prod_order_id` BIGINT NOT NULL COMMENT '生产工单ID',
    `order_op_id` BIGINT NOT NULL COMMENT '工单工序ID',
    `op_exec_id` BIGINT NOT NULL COMMENT '工序执行ID',
    `report_id` BIGINT NOT NULL COMMENT '报工ID',
    `defect_code_id` BIGINT NOT NULL COMMENT '缺陷代码ID',
    `defect_qty` DECIMAL(18,6) NOT NULL DEFAULT 0 COMMENT '不良数量',
    `defect_desc` VARCHAR(500) COMMENT '不良描述',
    `disposition_result` VARCHAR(64) COMMENT '处置结果',
    `status` VARCHAR(20) NOT NULL DEFAULT '0' COMMENT '状态',
    `create_by` VARCHAR(64) NOT NULL COMMENT '创建人',
    `create_time` DATETIME NOT NULL COMMENT '创建时间',
    `update_by` VARCHAR(64) COMMENT '更新人',
    `update_time` DATETIME COMMENT '更新时间',
    `del_flag` CHAR(1) NOT NULL DEFAULT '0' COMMENT '逻辑删除标识',
    `remark` VARCHAR(500) COMMENT '备注',
    PRIMARY KEY (`prod_defect_id`),
    UNIQUE KEY `uk_production_defect_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='生产不良表';

-- ----------------------------
-- Table: pro_inspection_plan - 检验方案表
-- ----------------------------
DROP TABLE IF EXISTS `pro_inspection_plan`;
CREATE TABLE `pro_inspection_plan` (
    `insp_plan_id` BIGINT NOT NULL COMMENT '检验方案ID',
    `insp_plan_code` VARCHAR(64) NOT NULL COMMENT '检验方案编码',
    `insp_plan_name` VARCHAR(128) NOT NULL COMMENT '检验方案名称',
    `insp_plan_version` VARCHAR(32) NOT NULL COMMENT '检验方案版本',
    `insp_type` VARCHAR(32) COMMENT '检验类型',
    `effective_from` DATETIME COMMENT '生效开始时间',
    `effective_to` DATETIME COMMENT '生效结束时间',
    `plan_status` VARCHAR(20) NOT NULL DEFAULT '0' COMMENT '方案状态',
    `create_by` VARCHAR(64) NOT NULL COMMENT '创建人',
    `create_time` DATETIME NOT NULL COMMENT '创建时间',
    `update_by` VARCHAR(64) COMMENT '更新人',
    `update_time` DATETIME COMMENT '更新时间',
    `del_flag` CHAR(1) NOT NULL DEFAULT '0' COMMENT '逻辑删除标识',
    `remark` VARCHAR(500) COMMENT '备注',
    PRIMARY KEY (`insp_plan_id`),
    UNIQUE KEY `uk_inspection_plan_insp_plan_code` (`insp_plan_code`),
    UNIQUE KEY `uk_inspection_plan_insp_plan_version` (`insp_plan_version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='检验方案表';

-- ----------------------------
-- Table: pro_inspection_characteristic - 检验特性表
-- ----------------------------
DROP TABLE IF EXISTS `pro_inspection_characteristic`;
CREATE TABLE `pro_inspection_characteristic` (
    `insp_char_id` BIGINT NOT NULL COMMENT '检验特性ID',
    `insp_plan_id` BIGINT NOT NULL COMMENT '检验方案ID',
    `char_code` VARCHAR(64) NOT NULL COMMENT '检验项目编码',
    `char_name` VARCHAR(128) NOT NULL COMMENT '检验项目名称',
    `char_type` VARCHAR(32) COMMENT '检验项目类型',
    `standard_value` DECIMAL(18,6) COMMENT '标准值',
    `upper_limit` DECIMAL(18,6) COMMENT '上限值',
    `lower_limit` DECIMAL(18,6) COMMENT '下限值',
    `uom` VARCHAR(20) COMMENT '单位',
    `sample_qty` DECIMAL(18,6) NOT NULL DEFAULT 0 COMMENT '抽样数量',
    `status` VARCHAR(20) NOT NULL DEFAULT '0' COMMENT '状态',
    `create_by` VARCHAR(64) NOT NULL COMMENT '创建人',
    `create_time` DATETIME NOT NULL COMMENT '创建时间',
    `update_by` VARCHAR(64) COMMENT '更新人',
    `update_time` DATETIME COMMENT '更新时间',
    `del_flag` CHAR(1) NOT NULL DEFAULT '0' COMMENT '逻辑删除标识',
    `remark` VARCHAR(500) COMMENT '备注',
    PRIMARY KEY (`insp_char_id`),
    UNIQUE KEY `uk_inspection_characteristic_char_code` (`char_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='检验特性表';

-- ----------------------------
-- Table: pro_inspection_result - 检验结果表
-- ----------------------------
DROP TABLE IF EXISTS `pro_inspection_result`;
CREATE TABLE `pro_inspection_result` (
    `insp_result_id` BIGINT NOT NULL COMMENT '检验结果ID',
    `prod_order_id` BIGINT NOT NULL COMMENT '生产工单ID',
    `order_op_id` BIGINT NOT NULL COMMENT '工单工序ID',
    `op_exec_id` BIGINT NOT NULL COMMENT '工序执行ID',
    `insp_plan_id` BIGINT NOT NULL COMMENT '检验方案ID',
    `insp_char_id` BIGINT NOT NULL COMMENT '检验特性ID',
    `sample_no` VARCHAR(64) NOT NULL COMMENT '样本号',
    `actual_value` VARCHAR(64) COMMENT '实际值',
    `result_judgement` VARCHAR(64) COMMENT '检验判定',
    `inspector_id` BIGINT NOT NULL COMMENT '检验员ID',
    `inspection_time` DATETIME COMMENT '检验时间',
    `create_by` VARCHAR(64) NOT NULL COMMENT '创建人',
    `create_time` DATETIME NOT NULL COMMENT '创建时间',
    `update_by` VARCHAR(64) COMMENT '更新人',
    `update_time` DATETIME COMMENT '更新时间',
    `del_flag` CHAR(1) NOT NULL DEFAULT '0' COMMENT '逻辑删除标识',
    `remark` VARCHAR(500) COMMENT '备注',
    PRIMARY KEY (`insp_result_id`),
    UNIQUE KEY `uk_inspection_result_sample_no` (`sample_no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='检验结果表';

-- ----------------------------
-- Table: pro_change_request - 工程变更请求表
-- ----------------------------
DROP TABLE IF EXISTS `pro_change_request`;
CREATE TABLE `pro_change_request` (
    `change_id` BIGINT NOT NULL COMMENT '变更ID',
    `change_no` VARCHAR(64) NOT NULL COMMENT '变更单号',
    `change_type` VARCHAR(32) NOT NULL COMMENT '变更类型',
    `change_title` VARCHAR(200) NOT NULL COMMENT '变更标题',
    `change_desc` VARCHAR(1000) COMMENT '变更说明',
    `affected_object_type` VARCHAR(32) NOT NULL COMMENT '受影响对象类型',
    `affected_object_id` BIGINT COMMENT '受影响对象ID',
    `source_module` VARCHAR(64) COMMENT '来源模块',
    `request_person_id` BIGINT COMMENT '申请人ID',
    `request_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '申请时间',
    `approval_status` VARCHAR(20) NOT NULL DEFAULT 'PENDING' COMMENT '审批状态',
    `change_status` VARCHAR(20) NOT NULL DEFAULT 'DRAFT' COMMENT '变更状态',
    `effective_time` DATETIME COMMENT '生效时间',
    `create_by` VARCHAR(64) NOT NULL COMMENT '创建人',
    `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_by` VARCHAR(64) COMMENT '更新人',
    `update_time` DATETIME COMMENT '更新时间',
    `del_flag` CHAR(1) NOT NULL DEFAULT '0' COMMENT '逻辑删除标识',
    `remark` VARCHAR(500) COMMENT '备注',
    PRIMARY KEY (`change_id`),
    UNIQUE KEY `uk_change_request_change_no` (`change_no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='工程变更请求表';

-- ================================================
-- ROLLBACK 回滚脚本
-- ================================================
-- DROP TABLE IF EXISTS `pro_change_request`;
-- DROP TABLE IF EXISTS `pro_inspection_result`;
-- DROP TABLE IF EXISTS `pro_inspection_characteristic`;
-- DROP TABLE IF EXISTS `pro_inspection_plan`;
-- DROP TABLE IF EXISTS `pro_production_defect`;
-- DROP TABLE IF EXISTS `pro_defect_code_master`;
-- DROP TABLE IF EXISTS `pro_batch_review`;
-- DROP TABLE IF EXISTS `pro_nc_handling`;
-- DROP TABLE IF EXISTS `pro_exception_record`;
-- DROP TABLE IF EXISTS `pro_exception_escalation`;
-- DROP TABLE IF EXISTS `pro_exception_category`;