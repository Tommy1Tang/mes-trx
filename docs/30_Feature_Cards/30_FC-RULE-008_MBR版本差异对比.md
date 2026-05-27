---
card_id: FC-RULE-008
module_doc: 13_执行规则与联锁模块需求文档.md
source_section: "2.8 MBR版本差异对比"
requirements: ["REQ-RULE-017"]
tables: ["pro_execution_rule", "pro_interlock_rule", "pro_interlock_event", "pro_device_command_log", "pro_error_proofing_record", "pro_mbr_release_record", "pro_mbr_change_record", "pro_ecn_order", "pro_ecn_affected_object", "pro_mbr_version_diff"]
status: confirmed
---

# FC-RULE-008 MBR版本差异对比

## 1. 加载入口
- 路由文档：`13_执行规则与联锁模块需求文档.md`
- 原始小节：`2.8 MBR版本差异对比`
- 关联需求：REQ-RULE-017
- 候选关联表：pro_execution_rule、pro_interlock_rule、pro_interlock_event、pro_device_command_log、pro_error_proofing_record、pro_mbr_release_record、pro_mbr_change_record、pro_ecn_order、pro_ecn_affected_object、pro_mbr_version_diff
- 架构层：L3 执行规则、联锁与变更控制层

## 2. 功能范围
本功能卡承接下列需求，用于开发 Agent 按功能包进行最小上下文加载。模块边界以路由文档为准，字段落地以数据字典和DBA治理结果为准。

## 3. 需求明细
| 需求ID | 需求名称 | 优先级 | 业务规则 | 验收标准 | 涉及角色 |
|--------|----------|--------|----------|----------|----------|
| REQ-RULE-017 | MBR版本差异对比 | P1++ | 记录MBR新旧版本在阶段、步骤、参数、物料、设备和质量项上的差异，支持可视化展示 | 差异展示清晰 | 工艺工程师 |

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
