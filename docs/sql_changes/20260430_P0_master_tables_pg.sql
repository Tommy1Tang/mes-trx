-- ================================================
-- 变更编号：DM-20260430-001
-- 变更类型：新增表
-- 变更描述：P0层主数据表建表SQL（8张表）- PostgreSQL 版本
-- 变更原因：MES系统基础表设计
-- 影响范围：主数据管理模块
-- 执行人：AI-DBA
-- 执行日期：2026-04-30
-- 数据库：PostgreSQL
-- ================================================

-- ----------------------------
-- Table: pro_plant_master - 工厂主数据表
-- ----------------------------
DROP TABLE IF EXISTS pro_plant_master;
CREATE TABLE pro_plant_master (
    plant_id BIGINT NOT NULL,
    plant_code VARCHAR(64) NOT NULL,
    plant_name VARCHAR(128) NOT NULL,
    plant_type VARCHAR(32),
    address VARCHAR(500),
    status VARCHAR(20) NOT NULL DEFAULT '0',
    sort_no INT NOT NULL DEFAULT 0,
    create_by VARCHAR(64) NOT NULL,
    create_time TIMESTAMP NOT NULL,
    update_by VARCHAR(64),
    update_time TIMESTAMP,
    del_flag CHAR(1) NOT NULL DEFAULT '0',
    remark VARCHAR(500),
    CONSTRAINT pk_plant_master PRIMARY KEY (plant_id),
    CONSTRAINT uk_plant_plant_code UNIQUE (plant_code)
);

COMMENT ON TABLE pro_plant_master IS '工厂主数据表';
COMMENT ON COLUMN pro_plant_master.plant_id IS '工厂ID';
COMMENT ON COLUMN pro_plant_master.plant_code IS '工厂编码';
COMMENT ON COLUMN pro_plant_master.plant_name IS '工厂名称';
COMMENT ON COLUMN pro_plant_master.plant_type IS '工厂类型';
COMMENT ON COLUMN pro_plant_master.address IS '地址';
COMMENT ON COLUMN pro_plant_master.status IS '状态';
COMMENT ON COLUMN pro_plant_master.sort_no IS '排序号';
COMMENT ON COLUMN pro_plant_master.create_by IS '创建人';
COMMENT ON COLUMN pro_plant_master.create_time IS '创建时间';
COMMENT ON COLUMN pro_plant_master.update_by IS '更新人';
COMMENT ON COLUMN pro_plant_master.update_time IS '更新时间';
COMMENT ON COLUMN pro_plant_master.del_flag IS '逻辑删除标识';
COMMENT ON COLUMN pro_plant_master.remark IS '备注';

-- ----------------------------
-- Table: pro_workshop_master - 车间主数据表
-- ----------------------------
DROP TABLE IF EXISTS pro_workshop_master;
CREATE TABLE pro_workshop_master (
    workshop_id BIGINT NOT NULL,
    plant_id BIGINT NOT NULL,
    workshop_code VARCHAR(64) NOT NULL,
    workshop_name VARCHAR(128) NOT NULL,
    workshop_type VARCHAR(32),
    status VARCHAR(20) NOT NULL DEFAULT '0',
    sort_no INT NOT NULL DEFAULT 0,
    create_by VARCHAR(64) NOT NULL,
    create_time TIMESTAMP NOT NULL,
    update_by VARCHAR(64),
    update_time TIMESTAMP,
    del_flag CHAR(1) NOT NULL DEFAULT '0',
    remark VARCHAR(500),
    CONSTRAINT pk_workshop_master PRIMARY KEY (workshop_id),
    CONSTRAINT uk_workshop_workshop_code UNIQUE (workshop_code)
);

COMMENT ON TABLE pro_workshop_master IS '车间主数据表';
COMMENT ON COLUMN pro_workshop_master.workshop_id IS '车间ID';
COMMENT ON COLUMN pro_workshop_master.plant_id IS '工厂ID';
COMMENT ON COLUMN pro_workshop_master.workshop_code IS '车间编码';
COMMENT ON COLUMN pro_workshop_master.workshop_name IS '车间名称';
COMMENT ON COLUMN pro_workshop_master.workshop_type IS '车间类型';
COMMENT ON COLUMN pro_workshop_master.status IS '状态';
COMMENT ON COLUMN pro_workshop_master.sort_no IS '排序号';
COMMENT ON COLUMN pro_workshop_master.create_by IS '创建人';
COMMENT ON COLUMN pro_workshop_master.create_time IS '创建时间';
COMMENT ON COLUMN pro_workshop_master.update_by IS '更新人';
COMMENT ON COLUMN pro_workshop_master.update_time IS '更新时间';
COMMENT ON COLUMN pro_workshop_master.del_flag IS '逻辑删除标识';
COMMENT ON COLUMN pro_workshop_master.remark IS '备注';

-- ----------------------------
-- Table: pro_production_line_master - 产线主数据表
-- ----------------------------
DROP TABLE IF EXISTS pro_production_line_master;
CREATE TABLE pro_production_line_master (
    line_id BIGINT NOT NULL,
    plant_id BIGINT NOT NULL,
    workshop_id BIGINT NOT NULL,
    line_code VARCHAR(64) NOT NULL,
    line_name VARCHAR(128) NOT NULL,
    line_type VARCHAR(32),
    status VARCHAR(20) NOT NULL DEFAULT '0',
    sort_no INT NOT NULL DEFAULT 0,
    create_by VARCHAR(64) NOT NULL,
    create_time TIMESTAMP NOT NULL,
    update_by VARCHAR(64),
    update_time TIMESTAMP,
    del_flag CHAR(1) NOT NULL DEFAULT '0',
    remark VARCHAR(500),
    CONSTRAINT pk_production_line_master PRIMARY KEY (line_id),
    CONSTRAINT uk_production_line_line_code UNIQUE (line_code)
);

COMMENT ON TABLE pro_production_line_master IS '产线主数据表';
COMMENT ON COLUMN pro_production_line_master.line_id IS '产线ID';
COMMENT ON COLUMN pro_production_line_master.plant_id IS '工厂ID';
COMMENT ON COLUMN pro_production_line_master.workshop_id IS '车间ID';
COMMENT ON COLUMN pro_production_line_master.line_code IS '产线编码';
COMMENT ON COLUMN pro_production_line_master.line_name IS '产线名称';
COMMENT ON COLUMN pro_production_line_master.line_type IS '产线类型';
COMMENT ON COLUMN pro_production_line_master.status IS '状态';
COMMENT ON COLUMN pro_production_line_master.sort_no IS '排序号';
COMMENT ON COLUMN pro_production_line_master.create_by IS '创建人';
COMMENT ON COLUMN pro_production_line_master.create_time IS '创建时间';
COMMENT ON COLUMN pro_production_line_master.update_by IS '更新人';
COMMENT ON COLUMN pro_production_line_master.update_time IS '更新时间';
COMMENT ON COLUMN pro_production_line_master.del_flag IS '逻辑删除标识';
COMMENT ON COLUMN pro_production_line_master.remark IS '备注';

-- ----------------------------
-- Table: pro_work_center_master - 工作中心主数据表
-- ----------------------------
DROP TABLE IF EXISTS pro_work_center_master;
CREATE TABLE pro_work_center_master (
    work_center_id BIGINT NOT NULL,
    plant_id BIGINT NOT NULL,
    workshop_id BIGINT NOT NULL,
    line_id BIGINT NOT NULL,
    work_center_code VARCHAR(64) NOT NULL,
    work_center_name VARCHAR(128) NOT NULL,
    work_center_type VARCHAR(32),
    capacity_unit VARCHAR(64),
    status VARCHAR(20) NOT NULL DEFAULT '0',
    create_by VARCHAR(64) NOT NULL,
    create_time TIMESTAMP NOT NULL,
    update_by VARCHAR(64),
    update_time TIMESTAMP,
    del_flag CHAR(1) NOT NULL DEFAULT '0',
    remark VARCHAR(500),
    CONSTRAINT pk_work_center_master PRIMARY KEY (work_center_id),
    CONSTRAINT uk_work_center_work_center_code UNIQUE (work_center_code)
);

COMMENT ON TABLE pro_work_center_master IS '工作中心主数据表';
COMMENT ON COLUMN pro_work_center_master.work_center_id IS '工作中心ID';
COMMENT ON COLUMN pro_work_center_master.plant_id IS '工厂ID';
COMMENT ON COLUMN pro_work_center_master.workshop_id IS '车间ID';
COMMENT ON COLUMN pro_work_center_master.line_id IS '产线ID';
COMMENT ON COLUMN pro_work_center_master.work_center_code IS '工作中心编码';
COMMENT ON COLUMN pro_work_center_master.work_center_name IS '工作中心名称';
COMMENT ON COLUMN pro_work_center_master.work_center_type IS '工作中心类型';
COMMENT ON COLUMN pro_work_center_master.capacity_unit IS '产能单位';
COMMENT ON COLUMN pro_work_center_master.status IS '状态';
COMMENT ON COLUMN pro_work_center_master.create_by IS '创建人';
COMMENT ON COLUMN pro_work_center_master.create_time IS '创建时间';
COMMENT ON COLUMN pro_work_center_master.update_by IS '更新人';
COMMENT ON COLUMN pro_work_center_master.update_time IS '更新时间';
COMMENT ON COLUMN pro_work_center_master.del_flag IS '逻辑删除标识';
COMMENT ON COLUMN pro_work_center_master.remark IS '备注';

-- ----------------------------
-- Table: pro_material_master - 物料主数据表
-- ----------------------------
DROP TABLE IF EXISTS pro_material_master;
CREATE TABLE pro_material_master (
    material_id BIGINT NOT NULL,
    material_code VARCHAR(64) NOT NULL,
    material_name VARCHAR(128) NOT NULL,
    material_type VARCHAR(32),
    spec_model VARCHAR(64),
    base_uom VARCHAR(20),
    batch_managed_flag CHAR(1) NOT NULL DEFAULT 'N',
    serial_managed_flag CHAR(1) NOT NULL DEFAULT 'N',
    status VARCHAR(20) NOT NULL DEFAULT '0',
    create_by VARCHAR(64) NOT NULL,
    create_time TIMESTAMP NOT NULL,
    update_by VARCHAR(64),
    update_time TIMESTAMP,
    del_flag CHAR(1) NOT NULL DEFAULT '0',
    remark VARCHAR(500),
    CONSTRAINT pk_material_master PRIMARY KEY (material_id),
    CONSTRAINT uk_material_material_code UNIQUE (material_code)
);

COMMENT ON TABLE pro_material_master IS '物料主数据表';
COMMENT ON COLUMN pro_material_master.material_id IS '物料ID';
COMMENT ON COLUMN pro_material_master.material_code IS '物料编码';
COMMENT ON COLUMN pro_material_master.material_name IS '物料名称';
COMMENT ON COLUMN pro_material_master.material_type IS '物料类型';
COMMENT ON COLUMN pro_material_master.spec_model IS '规格型号';
COMMENT ON COLUMN pro_material_master.base_uom IS '基本单位';
COMMENT ON COLUMN pro_material_master.batch_managed_flag IS '是否批次管理';
COMMENT ON COLUMN pro_material_master.serial_managed_flag IS '是否序列号管理';
COMMENT ON COLUMN pro_material_master.status IS '状态';
COMMENT ON COLUMN pro_material_master.create_by IS '创建人';
COMMENT ON COLUMN pro_material_master.create_time IS '创建时间';
COMMENT ON COLUMN pro_material_master.update_by IS '更新人';
COMMENT ON COLUMN pro_material_master.update_time IS '更新时间';
COMMENT ON COLUMN pro_material_master.del_flag IS '逻辑删除标识';
COMMENT ON COLUMN pro_material_master.remark IS '备注';

-- ----------------------------
-- Table: pro_equipment_master - 设备主数据表
-- ----------------------------
DROP TABLE IF EXISTS pro_equipment_master;
CREATE TABLE pro_equipment_master (
    equipment_id BIGINT NOT NULL,
    plant_id BIGINT NOT NULL,
    work_center_id BIGINT NOT NULL,
    equipment_code VARCHAR(64) NOT NULL,
    equipment_name VARCHAR(128) NOT NULL,
    equipment_type VARCHAR(32),
    asset_no VARCHAR(64) NOT NULL,
    equipment_status VARCHAR(20) NOT NULL DEFAULT '0',
    create_by VARCHAR(64) NOT NULL,
    create_time TIMESTAMP NOT NULL,
    update_by VARCHAR(64),
    update_time TIMESTAMP,
    del_flag CHAR(1) NOT NULL DEFAULT '0',
    remark VARCHAR(500),
    CONSTRAINT pk_equipment_master PRIMARY KEY (equipment_id),
    CONSTRAINT uk_equipment_equipment_code UNIQUE (equipment_code)
);

COMMENT ON TABLE pro_equipment_master IS '设备主数据表';
COMMENT ON COLUMN pro_equipment_master.equipment_id IS '设备ID';
COMMENT ON COLUMN pro_equipment_master.plant_id IS '工厂ID';
COMMENT ON COLUMN pro_equipment_master.work_center_id IS '工作中心ID';
COMMENT ON COLUMN pro_equipment_master.equipment_code IS '设备编码';
COMMENT ON COLUMN pro_equipment_master.equipment_name IS '设备名称';
COMMENT ON COLUMN pro_equipment_master.equipment_type IS '设备类型';
COMMENT ON COLUMN pro_equipment_master.asset_no IS '资产编号';
COMMENT ON COLUMN pro_equipment_master.equipment_status IS '设备状态';
COMMENT ON COLUMN pro_equipment_master.create_by IS '创建人';
COMMENT ON COLUMN pro_equipment_master.create_time IS '创建时间';
COMMENT ON COLUMN pro_equipment_master.update_by IS '更新人';
COMMENT ON COLUMN pro_equipment_master.update_time IS '更新时间';
COMMENT ON COLUMN pro_equipment_master.del_flag IS '逻辑删除标识';
COMMENT ON COLUMN pro_equipment_master.remark IS '备注';

-- ----------------------------
-- Table: pro_warehouse_master - 仓库主数据表
-- ----------------------------
DROP TABLE IF EXISTS pro_warehouse_master;
CREATE TABLE pro_warehouse_master (
    warehouse_id BIGINT NOT NULL,
    plant_id BIGINT NOT NULL,
    warehouse_code VARCHAR(64) NOT NULL,
    warehouse_name VARCHAR(128) NOT NULL,
    warehouse_type VARCHAR(32),
    status VARCHAR(20) NOT NULL DEFAULT '0',
    sort_no INT NOT NULL DEFAULT 0,
    create_by VARCHAR(64) NOT NULL,
    create_time TIMESTAMP NOT NULL,
    update_by VARCHAR(64),
    update_time TIMESTAMP,
    del_flag CHAR(1) NOT NULL DEFAULT '0',
    remark VARCHAR(500),
    CONSTRAINT pk_warehouse_master PRIMARY KEY (warehouse_id),
    CONSTRAINT uk_warehouse_warehouse_code UNIQUE (warehouse_code)
);

COMMENT ON TABLE pro_warehouse_master IS '仓库主数据表';
COMMENT ON COLUMN pro_warehouse_master.warehouse_id IS '仓库ID';
COMMENT ON COLUMN pro_warehouse_master.plant_id IS '工厂ID';
COMMENT ON COLUMN pro_warehouse_master.warehouse_code IS '仓库编码';
COMMENT ON COLUMN pro_warehouse_master.warehouse_name IS '仓库名称';
COMMENT ON COLUMN pro_warehouse_master.warehouse_type IS '仓库类型';
COMMENT ON COLUMN pro_warehouse_master.status IS '状态';
COMMENT ON COLUMN pro_warehouse_master.sort_no IS '排序号';
COMMENT ON COLUMN pro_warehouse_master.create_by IS '创建人';
COMMENT ON COLUMN pro_warehouse_master.create_time IS '创建时间';
COMMENT ON COLUMN pro_warehouse_master.update_by IS '更新人';
COMMENT ON COLUMN pro_warehouse_master.update_time IS '更新时间';
COMMENT ON COLUMN pro_warehouse_master.del_flag IS '逻辑删除标识';
COMMENT ON COLUMN pro_warehouse_master.remark IS '备注';

-- ----------------------------
-- Table: pro_storage_location_master - 库位主数据表
-- ----------------------------
DROP TABLE IF EXISTS pro_storage_location_master;
CREATE TABLE pro_storage_location_master (
    storage_location_id BIGINT NOT NULL,
    warehouse_id BIGINT NOT NULL,
    storage_location_code VARCHAR(64) NOT NULL,
    storage_location_name VARCHAR(128) NOT NULL,
    location_type VARCHAR(32),
    status VARCHAR(20) NOT NULL DEFAULT '0',
    sort_no INT NOT NULL DEFAULT 0,
    create_by VARCHAR(64) NOT NULL,
    create_time TIMESTAMP NOT NULL,
    update_by VARCHAR(64),
    update_time TIMESTAMP,
    del_flag CHAR(1) NOT NULL DEFAULT '0',
    remark VARCHAR(500),
    CONSTRAINT pk_storage_location_master PRIMARY KEY (storage_location_id),
    CONSTRAINT uk_storage_location_storage_location_code UNIQUE (storage_location_code)
);

COMMENT ON TABLE pro_storage_location_master IS '库位主数据表';
COMMENT ON COLUMN pro_storage_location_master.storage_location_id IS '库位ID';
COMMENT ON COLUMN pro_storage_location_master.warehouse_id IS '仓库ID';
COMMENT ON COLUMN pro_storage_location_master.storage_location_code IS '库位编码';
COMMENT ON COLUMN pro_storage_location_master.storage_location_name IS '库位名称';
COMMENT ON COLUMN pro_storage_location_master.location_type IS '库位类型';
COMMENT ON COLUMN pro_storage_location_master.status IS '状态';
COMMENT ON COLUMN pro_storage_location_master.sort_no IS '排序号';
COMMENT ON COLUMN pro_storage_location_master.create_by IS '创建人';
COMMENT ON COLUMN pro_storage_location_master.create_time IS '创建时间';
COMMENT ON COLUMN pro_storage_location_master.update_by IS '更新人';
COMMENT ON COLUMN pro_storage_location_master.update_time IS '更新时间';
COMMENT ON COLUMN pro_storage_location_master.del_flag IS '逻辑删除标识';
COMMENT ON COLUMN pro_storage_location_master.remark IS '备注';
