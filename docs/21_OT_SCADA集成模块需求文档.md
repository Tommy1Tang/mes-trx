# OT/SCADA集成模块需求文档（L7层）
## 1. 模块概述
负责承接ThingsBoard/SCADA设备、点位、关键采集值、告警、设备状态、OEE、环境监测、纯化水、冷链和CIP/SIP证据数据。设计边界是：ThingsBoard保存高频原始遥测和实时规则，MES固化与工单、批次、步骤、质量、异常和电子批记录相关的关键证据数据。

**架构层：** L7 OT/SCADA、环境公用与清洗冷链层
**涉及表：** pro_scada_system、pro_scada_device_ref、pro_equipment_scada_map、pro_scada_point、pro_operation_data_collect、pro_process_monitor_summary、pro_scada_alarm_event、pro_equipment_state_event、pro_oee_summary、pro_environment_area、pro_environment_monitor_record、pro_utility_system、pro_water_quality_record、pro_cold_chain_monitor_record、pro_cold_chain_alarm_notice、pro_cleaning_cycle、pro_cleaning_cycle_parameter、pro_cleaning_release_record


## 2. Absolute Progressive Loading 路由
本模块文档只作为 Router 和模块边界，不承载全部开发细节。开发 Agent 必须按功能卡、字段字典和接口路标进行最小上下文加载。

### 2.1 功能卡索引
| 功能卡ID | 功能卡 | 覆盖需求 | 文件 |
|----------|--------|----------|------|
| FC-SCADA-001 | SCADA系统与设备 | REQ-SCADA-001, REQ-SCADA-002, REQ-SCADA-003, REQ-SCADA-004 | 30_Feature_Cards/30_FC-SCADA-001_SCADA系统与设备.md |
| FC-SCADA-002 | 数据采集 | REQ-SCADA-005, REQ-SCADA-006, REQ-SCADA-007 | 30_Feature_Cards/30_FC-SCADA-002_数据采集.md |
| FC-SCADA-003 | 告警与设备状态 | REQ-SCADA-008, REQ-SCADA-009, REQ-SCADA-010, REQ-SCADA-011, REQ-SCADA-012 | 30_Feature_Cards/30_FC-SCADA-003_告警与设备状态.md |
| FC-ENV-001 | 环境监测 | REQ-ENV-001, REQ-ENV-002, REQ-ENV-003, REQ-ENV-004, REQ-ENV-005 | 30_Feature_Cards/30_FC-ENV-001_环境监测.md |
| FC-CC-001 | 冷链监控 | REQ-CC-001, REQ-CC-002, REQ-CC-003 | 30_Feature_Cards/30_FC-CC-001_冷链监控.md |
| FC-CLN-001 | 清洗灭菌（CIP/SIP） | REQ-CLN-001, REQ-CLN-002, REQ-CLN-003, REQ-CLN-004 | 30_Feature_Cards/30_FC-CLN-001_清洗灭菌（CIPSIP）.md |

### 2.2 开发加载规则
1. 先读取 `00_Blueprint.md`、`00_Agent_Collaboration_Rules.md`、`IVD_MES整体开发口径.md`。
2. 按需求ID或功能卡ID读取本模块对应功能卡，例如 `rg "REQ-XXX-001" docs/30_Feature_Cards` 或 `rg "FC-XXX-001" docs/30_Feature_Cards`。
3. 只加载功能卡声明的相关表字段、接口小节和治理规范，禁止一次加载整个字段字典。
4. 若功能卡仍缺页面字段、交互或验收细节，先补卡再开发。

## 3. 核心流程

### 3.1 SCADA数据采集流程
1. ThingsBoard设备持续采集高频遥测数据
2. MES配置采集点位和关键值规则
3. ThingsBoard在采集完成后将关键值推送到MES
4. MES固化关键值到pro_operation_data_collect
5. 摘要数据保存到pro_process_monitor_summary
6. 数据关联到EBR

### 3.2 告警处理流程
1. ThingsBoard检测到异常，生成告警
2. 告警事件推送到MES
3. MES记录告警事件到pro_scada_alarm_event
4. 关键告警自动触发MES异常流程
5. 告警关联到工单、批次、异常记录

### 3.3 环境监测流程
1. 环境传感器持续采集温湿度、压差、粒子数
2. ThingsBoard保存高频原始数据
3. MES固化关键环境数据到pro_environment_monitor_record
4. 环境超限时自动告警
5. 环境数据关联到EBR作为批放行证据

## 4. 关键设计原则
1. ThingsBoard管高频过程，MES管合规结论
2. 原始高频遥测保留在ThingsBoard/时序库
3. MES只保存与工单、批次、步骤、放行相关的关键值、摘要、告警和曲线引用
4. 毫秒级联锁尽量在PLC/边缘侧完成，MES负责规则配置、放行判定和证据固化
5. 环境、冷链、清洗数据是批放行证据的一部分

## 5. 与其他模块的关系
- L1 设备主数据 → L7 SCADA设备映射
- L5 工序执行 → L7 数据采集（执行时采集数据）
- L5 EBR → L7 采集数据关联（数据固化到EBR）
- L6 异常管理 → L7 告警关联（告警触发异常）
- L0 Outbox → L7 SCADA集成（异步解耦）
