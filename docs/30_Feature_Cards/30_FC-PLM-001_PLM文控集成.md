---
card_id: FC-PLM-001
module_doc: 20_系统集成模块需求文档.md
source_section: "2.2 PLM/文控集成"
requirements: ["REQ-PLM-001", "REQ-PLM-002", "REQ-PLM-003", "REQ-PLM-004", "REQ-PLM-005", "REQ-PLM-006"]
tables: ["pro_sap_system", "pro_sap_plant_ref", "pro_sap_material_ref", "pro_sap_bom_ref", "pro_sap_bom_item_ref", "pro_sap_routing_ref", "pro_sap_operation_ref", "pro_sap_work_center_ref", "pro_sap_production_order_ref", "pro_sap_plant_map", "pro_sap_material_map", "pro_sap_bom_map"]
status: confirmed
---

# FC-PLM-001 PLM/文控集成

## 1. 加载入口
- 路由文档：`20_系统集成模块需求文档.md`
- 原始小节：`2.2 PLM/文控集成`
- 关联需求：REQ-PLM-001、REQ-PLM-002、REQ-PLM-003、REQ-PLM-004、REQ-PLM-005、REQ-PLM-006
- 候选关联表：pro_sap_system、pro_sap_plant_ref、pro_sap_material_ref、pro_sap_bom_ref、pro_sap_bom_item_ref、pro_sap_routing_ref、pro_sap_operation_ref、pro_sap_work_center_ref、pro_sap_production_order_ref、pro_sap_plant_map、pro_sap_material_map、pro_sap_bom_map、pro_sap_bom_item_map、pro_sap_routing_map、pro_sap_operation_map、pro_sap_work_center_map、pro_sap_production_order_map、pro_interface_message、pro_report_confirmation_if、pro_inspection_result_if、pro_consumption_posting_if
- 架构层：L9 企业集成与接口运营层

## 2. 功能范围
本功能卡承接下列需求，用于开发 Agent 按功能包进行最小上下文加载。模块边界以路由文档为准，字段落地以数据字典和DBA治理结果为准。

## 3. 需求明细
| 需求ID | 需求名称 | 优先级 | 业务规则 | 验收标准 | 涉及角色 |
|--------|----------|--------|----------|----------|----------|
| REQ-PLM-001 | PLM已批准MBR镜像接收 | P0 | 从PLM接收已批准结构化MBR镜像，包括工序、工步、生产指令、参数、物料、设备、质控项、SOP引用和适用范围 | 接收内容完整 | 系统自动 |
| REQ-PLM-002 | PLM MBR版本与适用范围同步 | P0 | 同步PLM MBR ID、版本号、生效/失效日期、状态、产品、工厂、车间、产线、工作中心等适用范围 | 版本状态准确 | 系统自动 |
| REQ-PLM-003 | PLM ECN接收与影响分析触发 | P0 | 从PLM接收ECN，触发MES识别受影响MBR镜像、工单、批次和执行快照 | 影响范围可识别 | 系统自动 |
| REQ-PLM-004 | SOP/文档引用同步 | P0 | 从PLM/文控接收SOP、生产文件、版本号、链接、状态和工序绑定关系，MES只保存引用和查看入口 | 文档引用正确 | 系统自动 |
| REQ-PLM-005 | Excel批导作为受控补充入口 | P0 | PLM暂无法结构化输出时，MES支持受控Excel批导，保留模板版本、文件哈希、上传人、校验结果、审核状态和审计追踪 | 批导可追溯 | 工艺工程师 |
| REQ-PLM-006 | MBR接收/校验/导入结果回传 | P0 | MES完成接收、结构校验和镜像落库后，向PLM或接口运维回传处理结果；失败时回传错误明细 | 处理结果闭环 | 系统自动 |

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
