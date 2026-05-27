---
card_id: FC-SCADA-001
module_doc: 21_OT_SCADA集成模块需求文档.md
source_section: "2.1 SCADA系统与设备"
requirements: ["REQ-SCADA-001", "REQ-SCADA-002", "REQ-SCADA-003", "REQ-SCADA-004"]
tables: ["pro_scada_system", "pro_scada_device_ref", "pro_equipment_scada_map", "pro_scada_point", "pro_operation_data_collect", "pro_process_monitor_summary", "pro_scada_alarm_event", "pro_equipment_state_event", "pro_oee_summary", "pro_environment_area", "pro_environment_monitor_record", "pro_utility_system"]
status: confirmed
---

# FC-SCADA-001 SCADA系统与设备

## 1. 加载入口
- 路由文档：`21_OT_SCADA集成模块需求文档.md`
- 原始小节：`2.1 SCADA系统与设备`
- 关联需求：REQ-SCADA-001、REQ-SCADA-002、REQ-SCADA-003、REQ-SCADA-004
- 候选关联表：pro_scada_system、pro_scada_device_ref、pro_equipment_scada_map、pro_scada_point、pro_operation_data_collect、pro_process_monitor_summary、pro_scada_alarm_event、pro_equipment_state_event、pro_oee_summary、pro_environment_area、pro_environment_monitor_record、pro_utility_system、pro_water_quality_record、pro_cold_chain_monitor_record、pro_cold_chain_alarm_notice、pro_cleaning_cycle、pro_cleaning_cycle_parameter、pro_cleaning_release_record
- 架构层：L7 OT/SCADA、环境公用与清洗冷链层

## 2. 功能范围
本功能卡承接下列需求，用于开发 Agent 按功能包进行最小上下文加载。模块边界以路由文档为准，字段落地以数据字典和DBA治理结果为准。

## 3. 需求明细
| 需求ID | 需求名称 | 优先级 | 业务规则 | 验收标准 | 涉及角色 |
|--------|----------|--------|----------|----------|----------|
| REQ-SCADA-001 | SCADA系统定义 | P0+++ | 定义ThingsBoard系统：系统名称、访问地址、认证方式、启用状态 | 系统配置正确 | 系统管理员 |
| REQ-SCADA-002 | SCADA设备参考同步 | P0+++ | 从ThingsBoard同步设备信息：设备ID、设备名、设备类型、同步状态 | 设备信息完整 | 系统自动 |
| REQ-SCADA-003 | MES设备SCADA映射 | P0+++ | 建立MES设备与ThingsBoard设备的绑定关系 | 映射关系正确 | 设备管理员 |
| REQ-SCADA-004 | SCADA采集点位定义 | P0+++ | 定义采集点位：telemetry key、单位、数据类型、采样频率、上下限 | 点位定义完整 | 设备管理员 |

## 4. 开发级补充清单
- 页面入口：待前端开发前由产品/架构确认。
- 查询条件：开发前按字段字典和业务高频检索项补齐。
- 新增/编辑规则：以本卡需求明细、字段字典必填/长度/dict_code为准。
- 删除/停用规则：涉及已被工单、批次、审计或接口引用的数据，默认只允许停用，不允许物理删除。
- 权限点：遵循RuoYi权限体系，权限标识以接口规范为准。
- 审计追踪：影响受控生产、放行、追溯和接口补偿的数据必须留痕。

## 5. 验收用例骨架
- 正向：必填字段完整、编码唯一、状态有效时可保存。
- 反向：编码重复、必填缺失、引用对象不存在或状态不可用时必须阻断。
- 权限：无对应权限时不可新增、编辑、删除/停用或导出。
- 审计：新增、修改、停用、审核、导入等关键动作可追溯。
