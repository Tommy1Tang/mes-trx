---
card_id: FC-SCADA-003
module_doc: 21_OT_SCADA集成模块需求文档.md
source_section: "2.3 告警与设备状态"
requirements: ["REQ-SCADA-008", "REQ-SCADA-009", "REQ-SCADA-010", "REQ-SCADA-011", "REQ-SCADA-012"]
tables: ["pro_scada_system", "pro_scada_device_ref", "pro_equipment_scada_map", "pro_scada_point", "pro_operation_data_collect", "pro_process_monitor_summary", "pro_scada_alarm_event", "pro_equipment_state_event", "pro_oee_summary", "pro_environment_area", "pro_environment_monitor_record", "pro_utility_system"]
status: confirmed
---

# FC-SCADA-003 告警与设备状态

## 1. 加载入口
- 路由文档：`21_OT_SCADA集成模块需求文档.md`
- 原始小节：`2.3 告警与设备状态`
- 关联需求：REQ-SCADA-008、REQ-SCADA-009、REQ-SCADA-010、REQ-SCADA-011、REQ-SCADA-012
- 候选关联表：pro_scada_system、pro_scada_device_ref、pro_equipment_scada_map、pro_scada_point、pro_operation_data_collect、pro_process_monitor_summary、pro_scada_alarm_event、pro_equipment_state_event、pro_oee_summary、pro_environment_area、pro_environment_monitor_record、pro_utility_system、pro_water_quality_record、pro_cold_chain_monitor_record、pro_cold_chain_alarm_notice、pro_cleaning_cycle、pro_cleaning_cycle_parameter、pro_cleaning_release_record
- 架构层：L7 OT/SCADA、环境公用与清洗冷链层

## 2. 功能范围
本功能卡承接下列需求，用于开发 Agent 按功能包进行最小上下文加载。模块边界以路由文档为准，字段落地以数据字典和DBA治理结果为准。

## 3. 需求明细
| 需求ID | 需求名称 | 优先级 | 业务规则 | 验收标准 | 涉及角色 |
|--------|----------|--------|----------|----------|----------|
| REQ-SCADA-008 | SCADA告警事件记录 | P0+++ | 保存ThingsBoard告警事件，关联MES异常、工单和批次 | 告警记录完整 | 系统自动 |
| REQ-SCADA-009 | 告警自动触发异常 | P0+++ | 关键告警自动触发MES异常流程 | 触发及时 | 系统自动 |
| REQ-SCADA-010 | 设备状态事件记录 | P1+++ | 记录Run、Stop、Alarm、微停机和设备状态切换过程 | 状态记录完整 | 系统自动 |
| REQ-SCADA-011 | OEE汇总分析 | P1+++ | 汇总稼动率、性能、良率、OEE、停机次数和停机时长 | OEE计算准确 | 系统自动 |
| REQ-SCADA-012 | 停机原因记录 | P1+++ | 记录停机原因：缺盖、卡瓶、缺标签、设备故障等 | 原因记录完整 | 生产人员 |

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
