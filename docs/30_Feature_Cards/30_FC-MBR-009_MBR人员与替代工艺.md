---
card_id: FC-MBR-009
module_doc: 12_MBR模板管理模块需求文档.md
source_section: "2.9 MBR人员与替代工艺"
requirements: ["REQ-MBR-023", "REQ-MBR-024", "REQ-MBR-025"]
tables: ["pro_mbr_header", "pro_mbr_version", "pro_mbr_phase", "pro_mbr_step", "pro_mbr_step_parameter", "pro_mbr_step_material", "pro_mbr_step_equipment", "pro_mbr_step_quality", "pro_mbr_step_transition", "pro_mbr_rework_rule", "pro_mbr_dynamic_param_rule", "pro_mbr_hold_rule"]
status: confirmed
---

# FC-MBR-009 MBR人员与替代工艺

## 1. 加载入口
- 路由文档：`12_MBR模板管理模块需求文档.md`
- 原始小节：`2.9 MBR人员与替代工艺`
- 关联需求：REQ-MBR-023、REQ-MBR-024、REQ-MBR-025
- 候选关联表：pro_mbr_header、pro_mbr_version、pro_mbr_phase、pro_mbr_step、pro_mbr_step_parameter、pro_mbr_step_material、pro_mbr_step_equipment、pro_mbr_step_quality、pro_mbr_step_transition、pro_mbr_rework_rule、pro_mbr_dynamic_param_rule、pro_mbr_hold_rule、pro_mbr_step_person_role、pro_mbr_alternative_process_rule、pro_outsource_operation_rule、pro_mbr_execution_context、pro_mbr_context_refresh_log
- 架构层：L2 产品、工艺与MBR模板层（后半部分）

## 2. 功能范围
本功能卡承接下列需求，用于开发 Agent 按功能包进行最小上下文加载。模块边界以路由文档为准，字段落地以数据字典和DBA治理结果为准。

## 3. 需求明细
| 需求ID | 需求名称 | 优先级 | 业务规则 | 验收标准 | 涉及角色 |
|--------|----------|--------|----------|----------|----------|
| REQ-MBR-023 | 步骤人员角色要求 | P1++ | 定义步骤需要的操作员、复核员、QA、设备员等角色和人数 | 角色要求明确 | 工艺工程师 |
| REQ-MBR-024 | 替代工艺规则 | P1++ | 定义可替代的工艺路线、阶段、步骤和启用条件 | 替代规则明确 | 工艺工程师 |
| REQ-MBR-025 | 委外工序规则 | P1++ | 定义工序或步骤委外执行的供应商、质量要求和接收规则 | 委外规则明确 | 工艺工程师 |

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
