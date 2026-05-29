---
card_id: FC-EBR-001
module_doc: 17_电子批记录模块需求文档.md
source_section: "2.1 EBR头管理"
requirements: ["REQ-EBR-001", "REQ-EBR-002", "REQ-EBR-003"]
tables: ["pro_ebr_header", "pro_ebr_step_record", "pro_ebr_param_record", "pro_batch_review", "pro_line_clearance_check", "pro_mbr_execution_context"]
status: confirmed
---

# FC-EBR-001 EBR头管理

## 1. 加载入口
- 路由文档：`17_电子批记录模块需求文档.md`
- 原始小节：`2.1 EBR头管理`
- 关联需求：REQ-EBR-001、REQ-EBR-002、REQ-EBR-003
- 候选关联表：pro_ebr_header、pro_ebr_step_record、pro_ebr_param_record、pro_batch_review、pro_line_clearance_check、pro_mbr_execution_context
- 架构层：L5 现场执行、称量与电子批记录层

## 2. 功能范围
本功能卡承接下列需求，用于开发 Agent 按功能包进行最小上下文加载。模块边界以路由文档为准，字段落地以数据字典和DBA治理结果为准。

## 3. 需求明细
| 需求ID | 需求名称 | 优先级 | 业务规则 | 验收标准 | 涉及角色 |
|--------|----------|--------|----------|----------|----------|
| REQ-EBR-001 | EBR头创建 | P0++ | 工单下达时根据MBR执行上下文/执行快照自动生成EBR头，关联工单、MBR版本、执行上下文`context_id`、产品、批次号和快照哈希 | EBR头信息完整，来源快照可追溯 | 系统自动 |
| REQ-EBR-002 | EBR状态管理 | P0++ | 支持EBR全生命周期：已创建→执行中→已提交→审核中→已放行→已归档 | 状态流转正确 | 系统自动 |
| REQ-EBR-003 | EBR与MBR执行上下文绑定 | P0++ | EBR必须与MBR版本和执行上下文强绑定，EBR不可脱离工单/批次执行快照独立存在；MBR后续改版不得无痕影响已创建EBR | 版本、上下文和快照绑定正确 | 系统自动 |

## 4. 开发级补充清单
- EBR头创建必须以`pro_mbr_execution_context`为来源，不能直接按当前MBR主镜像实时生成执行依据。
- EBR头必须保存或可追溯到`context_id`、`mbr_version_id`、`context_hash`、生产工单、产品、批次和创建时间。
- 若工单处于Safe Hold或上下文刷新中，EBR头创建、继续执行、提交和放行必须按上下文状态进行阻断或提示。
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
