---
card_id: FC-RULE-003
module_doc: 13_执行规则与联锁模块需求文档.md
source_section: "2.3 防错校验"
requirements: ["REQ-RULE-007", "REQ-RULE-008"]
tables: ["pro_execution_rule", "pro_interlock_rule", "pro_interlock_event", "pro_device_command_log", "pro_error_proofing_record", "pro_mbr_release_record", "pro_mbr_change_record", "pro_ecn_order", "pro_ecn_affected_object", "pro_mbr_version_diff"]
status: confirmed
---

# FC-RULE-003 防错校验

## 1. 加载入口
- 路由文档：`13_执行规则与联锁模块需求文档.md`
- 原始小节：`2.3 防错校验`
- 关联需求：REQ-RULE-007、REQ-RULE-008
- 候选关联表：pro_execution_rule、pro_interlock_rule、pro_interlock_event、pro_device_command_log、pro_error_proofing_record、pro_mbr_release_record、pro_mbr_change_record、pro_ecn_order、pro_ecn_affected_object、pro_mbr_version_diff
- 架构层：L3 执行规则、联锁与变更控制层

## 2. 功能范围
本功能卡承接下列需求，用于开发 Agent 按功能包进行最小上下文加载。模块边界以路由文档为准，字段落地以数据字典和DBA治理结果为准。

## 3. 需求明细
| 需求ID | 需求名称 | 优先级 | 业务规则 | 验收标准 | 涉及角色 |
|--------|----------|--------|----------|----------|----------|
| REQ-RULE-007 | 防错校验记录 | P0++ | 统一记录扫码、视觉、称量、设备状态、物料匹配等防错校验结果。校验类型：扫码防错（物料/设备/人员条码）、视觉防错（条码/标签/外观）、称量防错（目标值/实际值/允差）、设备防错（状态/校准）、物料防错（批次/有效期） | 校验记录完整 | 系统自动 |
| REQ-RULE-008 | 防错不通过处理 | P0++ | 防错校验不通过时的处理流程：阻断执行、触发异常、等待授权人员确认 | 处理流程明确 | 系统自动 |

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
