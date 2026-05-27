---
card_id: FC-SAP-001
module_doc: 20_系统集成模块需求文档.md
source_section: "2.1 SAP集成"
requirements: ["REQ-SAP-001", "REQ-SAP-002", "REQ-SAP-003", "REQ-SAP-004", "REQ-SAP-005", "REQ-SAP-006", "REQ-SAP-007", "REQ-SAP-008", "REQ-SAP-009", "REQ-SAP-010"]
tables: ["pro_sap_system", "pro_sap_plant_ref", "pro_sap_material_ref", "pro_sap_bom_ref", "pro_sap_bom_item_ref", "pro_sap_routing_ref", "pro_sap_operation_ref", "pro_sap_work_center_ref", "pro_sap_production_order_ref", "pro_sap_plant_map", "pro_sap_material_map", "pro_sap_bom_map"]
status: confirmed
---

# FC-SAP-001 SAP集成

## 1. 加载入口
- 路由文档：`20_系统集成模块需求文档.md`
- 原始小节：`2.1 SAP集成`
- 关联需求：REQ-SAP-001、REQ-SAP-002、REQ-SAP-003、REQ-SAP-004、REQ-SAP-005、REQ-SAP-006、REQ-SAP-007、REQ-SAP-008、REQ-SAP-009、REQ-SAP-010
- 候选关联表：pro_sap_system、pro_sap_plant_ref、pro_sap_material_ref、pro_sap_bom_ref、pro_sap_bom_item_ref、pro_sap_routing_ref、pro_sap_operation_ref、pro_sap_work_center_ref、pro_sap_production_order_ref、pro_sap_plant_map、pro_sap_material_map、pro_sap_bom_map、pro_sap_bom_item_map、pro_sap_routing_map、pro_sap_operation_map、pro_sap_work_center_map、pro_sap_production_order_map、pro_interface_message、pro_report_confirmation_if、pro_inspection_result_if、pro_consumption_posting_if
- 架构层：L9 企业集成与接口运营层

## 2. 功能范围
本功能卡承接下列需求，用于开发 Agent 按功能包进行最小上下文加载。模块边界以路由文档为准，字段落地以数据字典和DBA治理结果为准。

## 3. 需求明细
| 需求ID | 需求名称 | 优先级 | 业务规则 | 验收标准 | 涉及角色 |
|--------|----------|--------|----------|----------|----------|
| REQ-SAP-001 | SAP系统定义 | P0 | 定义SAP系统环境：系统地址、认证方式、启用状态 | 系统配置正确 | 系统管理员 |
| REQ-SAP-002 | SAP主数据参考同步 | P0 | 从SAP接收工厂、物料、BOM、Routing、工作中心等参考数据，存储到MES参考表 | 参考数据完整 | 系统自动 |
| REQ-SAP-003 | SAP主数据映射维护 | P0 | 维护SAP主数据与MES主数据的映射关系：SAP工厂→MES工厂、SAP物料→MES物料等 | 映射关系正确 | 系统管理员 |
| REQ-SAP-004 | SAP生产订单同步 | P0 | 从SAP接收生产订单，自动创建MES工单 | 订单同步及时 | 系统自动 |
| REQ-SAP-005 | 投料过账回传SAP | P0 | 投料确认后通过Outbox异步发送到SAP（移动类型261） | 过账准确 | 系统自动 |
| REQ-SAP-006 | 报工确认回传SAP | P0 | 报工审核通过后通过Outbox异步发送到SAP | 回传及时 | 系统自动 |
| REQ-SAP-007 | 检验结果回传SAP | P0 | 检验结果记录后通过Outbox异步发送到SAP | 回传准确 | 系统自动 |
| REQ-SAP-008 | MES创建SAP生产订单 | P0 | MES根据配套计划调用SAP创建R1/R2/R3、校准品、质控品生产订单，不使用计划订单转单接口 | SAP订单创建成功，返回正式订单号 | 系统自动 |
| REQ-SAP-009 | SAP订单号回写绑定 | P0 | SAP返回正式生产订单号后，MES写回本地工单、SAP参考/映射和`plan_no`绑定关系 | 本地订单与SAP订单号一致 | 系统自动 |
| REQ-SAP-010 | MRP重算与冲抵监控 | P0 | MES创建SAP半成品生产订单后，可触发单物料MRP重算或等待定时MRP；系统记录重复供应窗口和冲抵结果 | 计划员可识别计划订单是否被冲抵/调整 | 接口运维 |

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
