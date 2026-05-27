---
card_id: FC-MBR-010
module_doc: 12_MBR模板管理模块需求文档.md
source_section: "2.10 PLM MBR接收、Excel批导与执行快照"
requirements: ["REQ-MBR-026", "REQ-MBR-027", "REQ-MBR-028", "REQ-MBR-029", "REQ-MBR-030", "REQ-MBR-031", "REQ-MBR-032"]
tables: ["pro_mbr_header", "pro_mbr_version", "pro_mbr_phase", "pro_mbr_step", "pro_mbr_step_parameter", "pro_mbr_step_material", "pro_mbr_step_equipment", "pro_mbr_step_quality", "pro_mbr_step_transition", "pro_mbr_rework_rule", "pro_mbr_dynamic_param_rule", "pro_mbr_hold_rule"]
status: confirmed
---

# FC-MBR-010 PLM MBR接收、Excel批导与执行快照

## 1. 加载入口
- 路由文档：`12_MBR模板管理模块需求文档.md`
- 原始小节：`2.10 PLM MBR接收、Excel批导与执行快照`
- 关联需求：REQ-MBR-026、REQ-MBR-027、REQ-MBR-028、REQ-MBR-029、REQ-MBR-030、REQ-MBR-031、REQ-MBR-032
- 候选关联表：pro_mbr_header、pro_mbr_version、pro_mbr_phase、pro_mbr_step、pro_mbr_step_parameter、pro_mbr_step_material、pro_mbr_step_equipment、pro_mbr_step_quality、pro_mbr_step_transition、pro_mbr_rework_rule、pro_mbr_dynamic_param_rule、pro_mbr_hold_rule、pro_mbr_step_person_role、pro_mbr_alternative_process_rule、pro_outsource_operation_rule、pro_mbr_execution_context、pro_mbr_context_refresh_log
- 架构层：L2 产品、工艺与MBR模板层（后半部分）

## 2. 功能范围
本功能卡承接下列需求，用于开发 Agent 按功能包进行最小上下文加载。模块边界以路由文档为准，字段落地以数据字典和DBA治理结果为准。

## 3. 需求明细
| 需求ID | 需求名称 | 优先级 | 业务规则 | 验收标准 | 涉及角色 |
|--------|----------|--------|----------|----------|----------|
| REQ-MBR-026 | PLM MBR接收批次管理 | P0 | 每次PLM接口接收或Excel批导必须生成接收/导入批次，记录来源系统、来源版本、接收时间、处理状态和触发人 | 每次导入可追溯 | 系统自动/接口运维 |
| REQ-MBR-027 | Excel MBR批导受控入口 | P0 | 当PLM暂不能结构化输出时，Excel批导必须使用固定模板版本，保留文件哈希、上传人、上传时间、来源说明和审核状态 | 批导不能绕过审批和审计 | 工艺工程师 |
| REQ-MBR-028 | MBR结构完整性校验 | P0 | 导入后校验工序、工步、参数、物料、设备、质控项、字典项、单位精度、必填规则和引用对象映射 | 校验失败不得进入可执行状态 | 系统自动 |
| REQ-MBR-029 | 导入错误明细 | P0 | 校验失败时生成错误明细，标识对象类型、字段、错误原因、严重级别和处理建议 | 错误定位清晰 | 系统自动 |
| REQ-MBR-030 | PLM版本与MES镜像映射 | P0 | 建立PLM MBR ID/版本与MES镜像MBR ID/版本的映射，支持按产品、工厂、产线、有效期和状态查询 | 来源映射准确 | 系统自动 |
| REQ-MBR-031 | 工单/批次执行快照生成 | P0 | 工单创建或下达时，基于当前有效MBR镜像生成执行快照，固化Phase/Step、参数、物料、设备、质控、签名、跳转、返工和Hold规则 | EBR执行只引用快照 | 系统自动 |
| REQ-MBR-032 | 快照哈希与审计 | P0 | 执行快照必须记录快照哈希、生成时间、来源MBR版本、生成对象和审计日志 | 快照可校验不可无痕变更 | 系统自动 |

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
