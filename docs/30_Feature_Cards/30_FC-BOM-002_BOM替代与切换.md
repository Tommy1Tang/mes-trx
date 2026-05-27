---
card_id: FC-BOM-002
module_doc: 11_BOM与工艺路线模块需求文档.md
source_section: "2.2 BOM替代与切换"
requirements: ["REQ-BOM-005", "REQ-BOM-006", "REQ-BOM-007", "REQ-BOM-008"]
tables: ["pro_bom_header", "pro_bom_item", "pro_bom_item_operation_map", "pro_bom_substitution_group", "pro_bom_substitution_item", "pro_bom_cutover_rule", "pro_bom_cutover_execution_log", "pro_routing_header", "pro_routing_operation", "pro_operation_relation", "pro_operation_resource", "pro_operation_parameter"]
status: confirmed
---

# FC-BOM-002 BOM替代与切换

## 1. 加载入口
- 路由文档：`11_BOM与工艺路线模块需求文档.md`
- 原始小节：`2.2 BOM替代与切换`
- 关联需求：REQ-BOM-005、REQ-BOM-006、REQ-BOM-007、REQ-BOM-008
- 候选关联表：pro_bom_header、pro_bom_item、pro_bom_item_operation_map、pro_bom_substitution_group、pro_bom_substitution_item、pro_bom_cutover_rule、pro_bom_cutover_execution_log、pro_routing_header、pro_routing_operation、pro_operation_relation、pro_operation_resource、pro_operation_parameter、pro_operation_document、pro_inspection_plan、pro_inspection_characteristic、pro_operation_inspection_map
- 架构层：L2 产品、工艺与MBR模板层（前半部分）

## 2. 功能范围
本功能卡承接下列需求，用于开发 Agent 按功能包进行最小上下文加载。模块边界以路由文档为准，字段落地以数据字典和DBA治理结果为准。

## 3. 需求明细
| 需求ID | 需求名称 | 优先级 | 业务规则 | 验收标准 | 涉及角色 |
|--------|----------|--------|----------|----------|----------|
| REQ-BOM-005 | BOM替代组定义 | P1 | 定义BOM行的替代规则组，一个替代组包含多个候选物料 | 替代组定义清晰 | 工艺工程师 |
| REQ-BOM-006 | BOM替代料明细 | P1 | 定义替代候选料、优先级、审批要求、有效期、使用条件 | 替代料信息完整 | 工艺工程师 |
| REQ-BOM-007 | BOM切换规则定义 | P1 | 定义旧料切换到新料的正式规则，包含切换时间点、切换方式（立即/用完/指定日期） | 切换规则明确 | 工艺工程师 |
| REQ-BOM-008 | BOM切换执行日志 | P1 | 记录订单/组件命中切换规则的情况，包含切换前物料、切换后物料、切换时间 | 日志完整可追溯 | 系统自动 |

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
