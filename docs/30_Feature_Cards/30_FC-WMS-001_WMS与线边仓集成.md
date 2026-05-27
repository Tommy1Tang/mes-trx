---
card_id: FC-WMS-001
module_doc: 20_系统集成模块需求文档.md
source_section: "2.3 WMS与线边仓集成"
requirements: ["REQ-WMS-001", "REQ-WMS-002", "REQ-WMS-003", "REQ-WMS-004", "REQ-WMS-005", "REQ-WMS-006", "REQ-WMS-007", "REQ-WMS-008"]
tables: ["pro_sap_system", "pro_sap_plant_ref", "pro_sap_material_ref", "pro_sap_bom_ref", "pro_sap_bom_item_ref", "pro_sap_routing_ref", "pro_sap_operation_ref", "pro_sap_work_center_ref", "pro_sap_production_order_ref", "pro_sap_plant_map", "pro_sap_material_map", "pro_sap_bom_map"]
status: confirmed
---

# FC-WMS-001 WMS与线边仓集成

## 1. 加载入口
- 路由文档：`20_系统集成模块需求文档.md`
- 原始小节：`2.3 WMS与线边仓集成`
- 关联需求：REQ-WMS-001、REQ-WMS-002、REQ-WMS-003、REQ-WMS-004、REQ-WMS-005、REQ-WMS-006、REQ-WMS-007、REQ-WMS-008
- 候选关联表：pro_sap_system、pro_sap_plant_ref、pro_sap_material_ref、pro_sap_bom_ref、pro_sap_bom_item_ref、pro_sap_routing_ref、pro_sap_operation_ref、pro_sap_work_center_ref、pro_sap_production_order_ref、pro_sap_plant_map、pro_sap_material_map、pro_sap_bom_map、pro_sap_bom_item_map、pro_sap_routing_map、pro_sap_operation_map、pro_sap_work_center_map、pro_sap_production_order_map、pro_interface_message、pro_report_confirmation_if、pro_inspection_result_if、pro_consumption_posting_if
- 架构层：L9 企业集成与接口运营层

## 2. 功能范围
本功能卡承接下列需求，用于开发 Agent 按功能包进行最小上下文加载。模块边界以路由文档为准，字段落地以数据字典和DBA治理结果为准。

## 3. 需求明细
| 需求ID | 需求名称 | 优先级 | 业务规则 | 验收标准 | 涉及角色 |
|--------|----------|--------|----------|----------|----------|
| REQ-WMS-001 | 工序领料请求 | P0 | MES按工序/MBR Step发起领料申请，并通过Outbox发送WMS执行库房拣配和移库 | 请求及时 | 系统自动 |
| REQ-WMS-002 | WMS移库结果接收 | P0 | WMS完成移库到线边仓后回传实际移库结果，MES据此建立线边仓库存台账 | 回传及时 | 系统自动 |
| REQ-WMS-003 | WMS合并移库映射 | P0 | WMS可合并相同物料相同批次移库，MES必须保存工序级领料需求与WMS实际移库结果的映射 | 映射完整 | 系统自动 |
| REQ-WMS-004 | 退料入库请求 | P0 | MES退料审核通过后自动发送退料请求到WMS，由WMS执行实物退回库房 | 请求及时 | 系统自动 |
| REQ-WMS-005 | WMS退料确认接收 | P0 | WMS完成库房接收后回传确认，MES冲减线边仓库存并关闭退料单 | 退料闭环 | 系统自动 |
| REQ-WMS-006 | 成品入库请求 | P0 | 生产完工报工后自动发送成品入库请求到WMS | 请求及时 | 系统自动 |
| REQ-WMS-007 | 库存查询 | P0 | 实时调用WMS查询原料库/成品库可用库存、批次、库位；线边仓库存以MES为准 | 查询准确 | 系统自动 |
| REQ-WMS-008 | 扫码对接 | P0 | 支持WMS扫码完成后自动同步到MES | 同步及时 | 系统自动 |

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
