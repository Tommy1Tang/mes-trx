---
card_id: FC-ROUTE-001
module_doc: 11_BOM与工艺路线模块需求文档.md
source_section: "2.3 工艺路线管理"
requirements: ["REQ-ROUTE-001", "REQ-ROUTE-002", "REQ-ROUTE-003", "REQ-ROUTE-004", "REQ-ROUTE-005", "REQ-ROUTE-006", "REQ-ROUTE-007"]
tables: ["pro_bom_header", "pro_bom_item", "pro_bom_item_operation_map", "pro_bom_substitution_group", "pro_bom_substitution_item", "pro_bom_cutover_rule", "pro_bom_cutover_execution_log", "pro_routing_header", "pro_routing_operation", "pro_operation_relation", "pro_operation_resource", "pro_operation_parameter"]
status: confirmed
---

# FC-ROUTE-001 工艺路线管理

## 1. 加载入口
- 路由文档：`11_BOM与工艺路线模块需求文档.md`
- 原始小节：`2.3 工艺路线管理`
- 关联需求：REQ-ROUTE-001、REQ-ROUTE-002、REQ-ROUTE-003、REQ-ROUTE-004、REQ-ROUTE-005、REQ-ROUTE-006、REQ-ROUTE-007
- 候选关联表：pro_bom_header、pro_bom_item、pro_bom_item_operation_map、pro_bom_substitution_group、pro_bom_substitution_item、pro_bom_cutover_rule、pro_bom_cutover_execution_log、pro_routing_header、pro_routing_operation、pro_operation_relation、pro_operation_resource、pro_operation_parameter、pro_operation_document、pro_inspection_plan、pro_inspection_characteristic、pro_operation_inspection_map
- 架构层：L2 产品、工艺与MBR模板层（前半部分）

## 2. 功能范围
本功能卡承接下列需求，用于开发 Agent 按功能包进行最小上下文加载。模块边界以路由文档为准，字段落地以数据字典和DBA治理结果为准。

## 3. 需求明细
| 需求ID | 需求名称 | 优先级 | 业务规则 | 验收标准 | 涉及角色 |
|--------|----------|--------|----------|----------|----------|
| REQ-ROUTE-001 | 工艺路线头表维护 | P0 | 维护工艺路线编码、名称、关联产品/BOM、版本、状态 | 工艺路线信息完整 | 工艺工程师 |
| REQ-ROUTE-002 | 工艺工序维护 | P0 | 维护标准工序模板：工序编码、名称、工序类型（配液/灌装/包装/检验等）、标准工时、前置工序 | 工序信息完整 | 工艺工程师 |
| REQ-ROUTE-003 | 工序关系定义 | P1 | 定义工序之间的先后依赖关系（顺序/并行/分支） | 关系定义正确 | 工艺工程师 |
| REQ-ROUTE-004 | 工序资源绑定 | P1 | 定义工序所需的工作中心、设备、工装、夹具 | 资源绑定完整 | 工艺工程师 |
| REQ-ROUTE-005 | 工序参数定义 | P1 | 定义工序所需的工艺参数：温度、转速、时间、压力等，包含目标值、上下限 | 参数定义完整 | 工艺工程师 |
| REQ-ROUTE-006 | 工序文档绑定 | P1 | 绑定工序的作业指导书、图纸、SOP等文档 | 文档关联正确 | 工艺工程师 |
| REQ-ROUTE-007 | 工艺路线版本管理 | P0 | 支持工艺路线多版本管理，版本对比、版本切换 | 版本管理清晰 | 工艺工程师 |

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
