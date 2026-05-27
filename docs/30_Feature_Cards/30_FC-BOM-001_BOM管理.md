---
card_id: FC-BOM-001
module_doc: 11_BOM与工艺路线模块需求文档.md
source_section: "2.1 BOM管理"
requirements: ["REQ-BOM-001", "REQ-BOM-002", "REQ-BOM-003", "REQ-BOM-004"]
tables: ["pro_bom_header", "pro_bom_item", "pro_bom_item_operation_map", "pro_bom_substitution_group", "pro_bom_substitution_item", "pro_bom_cutover_rule", "pro_bom_cutover_execution_log", "pro_routing_header", "pro_routing_operation", "pro_operation_relation", "pro_operation_resource", "pro_operation_parameter"]
status: confirmed
---

# FC-BOM-001 BOM管理

## 1. 加载入口
- 路由文档：`11_BOM与工艺路线模块需求文档.md`
- 原始小节：`2.1 BOM管理`
- 关联需求：REQ-BOM-001、REQ-BOM-002、REQ-BOM-003、REQ-BOM-004
- 候选关联表：pro_bom_header、pro_bom_item、pro_bom_item_operation_map、pro_bom_substitution_group、pro_bom_substitution_item、pro_bom_cutover_rule、pro_bom_cutover_execution_log、pro_routing_header、pro_routing_operation、pro_operation_relation、pro_operation_resource、pro_operation_parameter、pro_operation_document、pro_inspection_plan、pro_inspection_characteristic、pro_operation_inspection_map
- 架构层：L2 产品、工艺与MBR模板层（前半部分）

## 2. 功能范围
本功能卡承接下列需求，用于开发 Agent 按功能包进行最小上下文加载。模块边界以路由文档为准，字段落地以数据字典和DBA治理结果为准。

## 3. 需求明细
| 需求ID | 需求名称 | 优先级 | 业务规则 | 验收标准 | 涉及角色 |
|--------|----------|--------|----------|----------|----------|
| REQ-BOM-001 | BOM头表维护 | P0 | 维护BOM编码、名称、关联产品（物料）、BOM版本、BOM类型（生产BOM/工程BOM）、状态（草稿/已发布/已停用） | BOM信息完整，编码唯一 | 工艺工程师 |
| REQ-BOM-002 | BOM明细维护 | P0 | 维护BOM组件行：物料、用量、单位、损耗率、投料点（工序）、替代组 | 组件信息完整，用量/损耗率合理 | 工艺工程师 |
| REQ-BOM-003 | BOM行工序投料映射 | P0 | 定义每个BOM组件在哪道工序投料，支持一个组件在多道工序分批投料 | 投料工序映射正确 | 工艺工程师 |
| REQ-BOM-004 | BOM版本管理 | P0 | 支持BOM多版本管理，版本号递增，支持版本对比、版本切换 | 版本管理清晰 | 工艺工程师 |

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
