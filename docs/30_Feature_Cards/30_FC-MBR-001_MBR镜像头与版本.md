---
card_id: FC-MBR-001
module_doc: 12_MBR模板管理模块需求文档.md
source_section: "2.1 MBR镜像头与版本"
requirements: ["REQ-MBR-001", "REQ-MBR-002", "REQ-MBR-003", "REQ-MBR-004"]
tables: ["pro_mbr_header", "pro_mbr_version", "pro_mbr_phase", "pro_mbr_step", "pro_mbr_step_parameter", "pro_mbr_step_material", "pro_mbr_step_equipment", "pro_mbr_step_quality", "pro_mbr_step_transition", "pro_mbr_rework_rule", "pro_mbr_dynamic_param_rule", "pro_mbr_hold_rule"]
status: confirmed
---

# FC-MBR-001 MBR镜像头与版本

## 1. 加载入口
- 路由文档：`12_MBR模板管理模块需求文档.md`
- 原始小节：`2.1 MBR镜像头与版本`
- 关联需求：REQ-MBR-001、REQ-MBR-002、REQ-MBR-003、REQ-MBR-004
- 候选关联表：pro_mbr_header、pro_mbr_version、pro_mbr_phase、pro_mbr_step、pro_mbr_step_parameter、pro_mbr_step_material、pro_mbr_step_equipment、pro_mbr_step_quality、pro_mbr_step_transition、pro_mbr_rework_rule、pro_mbr_dynamic_param_rule、pro_mbr_hold_rule、pro_mbr_step_person_role、pro_mbr_alternative_process_rule、pro_outsource_operation_rule、pro_mbr_execution_context、pro_mbr_context_refresh_log
- 架构层：L2 产品、工艺与MBR模板层（后半部分）

## 2. 功能范围
本功能卡承接下列需求，用于开发 Agent 按功能包进行最小上下文加载。模块边界以路由文档为准，字段落地以数据字典和DBA治理结果为准。

## 3. 需求明细
| 需求ID | 需求名称 | 优先级 | 业务规则 | 验收标准 | 涉及角色 |
|--------|----------|--------|----------|----------|----------|
| REQ-MBR-001 | MBR镜像头表管理 | P0++ | 接收并保存PLM已批准MBR的头信息，包括PLM MBR ID、MES镜像ID、产品/物料、BOM、Routing、适用范围、来源系统、来源版本和状态 | MBR头信息完整，来源可追溯 | 系统自动 |
| REQ-MBR-002 | MBR镜像版本管理 | P0++ | 接收PLM版本号、生效日期、失效日期、批准状态、冻结/作废状态和适用范围；MES状态不得反向替代PLM主状态 | 版本状态与PLM一致 | 系统自动 |
| REQ-MBR-003 | MBR镜像启用控制 | P0++ | 只有PLM已批准且MES结构校验通过的MBR镜像才能用于新建工单；校验失败或PLM已作废版本不得启用 | 未批准/校验失败版本不可执行 | 系统自动 |
| REQ-MBR-004 | MBR镜像停用/冻结同步 | P0++ | PLM停用、冻结或作废版本后，MES同步镜像状态；不影响已生成执行快照的历史工单，除非PLM ECN要求进入Safe Hold | 历史执行证据不被覆盖 | 系统自动 |

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
