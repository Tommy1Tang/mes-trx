# T01 数据字典校验报告
校验时间: 2026-04-30
数据源: docs/MES系统基础表逐字段数据字典_按优先级.csv

## 基本统计
- 总行数: 1284
- 总表数: 85
- 主键数: 85
- 外键数: 200

## 硬性校验
结果: PASS
错误数: 0

## 字典校验
结果: WARN
缺少dict_code: 4
  - pro_bom_cutover_execution_log.exec_result
  - pro_production_defect.disposition_result
  - pro_schedule_log.adjust_reason
  - pro_exception_escalation.escalation_reason

## 字段说明校验
结果: WARN
有问题: 69
  - pro_bom_header.bom_code: 'BOM编码' (含未解释英文)
  - pro_bom_header.bom_version: 'BOM版本' (含未解释英文)
  - pro_bom_header.bom_usage: 'BOM用途' (含未解释英文)
  - pro_bom_header.bom_status: 'BOM状态' (含未解释英文)
  - pro_bom_item.bom_item_id: 'BOM明细ID' (含未解释英文)
  - pro_bom_item_operation_map.bom_item_op_map_id: 'BOM工序映射ID' (含未解释英文)
  - pro_bom_item_operation_map.bom_item_id: 'BOM明细ID' (含未解释英文)
  - pro_order_component.bom_item_id: 'BOM明细ID' (含未解释英文)
  - pro_sap_system.sap_system_id: 'SAP系统ID' (含未解释英文)
  - pro_sap_system.sap_system_code: 'SAP系统编码' (含未解释英文)
  - pro_sap_system.sap_system_name: 'SAP系统名称' (含未解释英文)
  - pro_sap_plant_ref.sap_plant_ref_id: 'SAP工厂参考ID' (含未解释英文)
  - pro_sap_plant_ref.sap_system_id: 'SAP系统ID' (含未解释英文)
  - pro_sap_plant_ref.sap_plant_code: 'SAP工厂编码' (含未解释英文)
  - pro_sap_plant_ref.sap_plant_name: 'SAP工厂名称' (含未解释英文)
  - pro_sap_material_ref.sap_material_ref_id: 'SAP物料参考ID' (含未解释英文)
  - pro_sap_material_ref.sap_system_id: 'SAP系统ID' (含未解释英文)
  - pro_sap_material_ref.sap_material_code: 'SAP物料编码' (含未解释英文)
  - pro_sap_material_ref.sap_material_name: 'SAP物料名称' (含未解释英文)
  - pro_sap_bom_ref.sap_bom_ref_id: 'SAP BOM参考ID' (含未解释英文)
  - pro_sap_bom_ref.sap_system_id: 'SAP系统ID' (含未解释英文)
  - pro_sap_bom_ref.sap_bom_no: 'SAP BOM编号' (含未解释英文)
  - pro_sap_bom_ref.sap_bom_alt: 'SAP替代BOM' (含未解释英文)
  - pro_sap_bom_ref.bom_usage: 'BOM用途' (含未解释英文)
  - pro_sap_bom_item_ref.sap_bom_item_ref_id: 'SAP BOM行参考ID' (含未解释英文)
  - pro_sap_bom_item_ref.sap_bom_ref_id: 'SAP BOM参考ID' (含未解释英文)
  - pro_sap_bom_item_ref.sap_item_node_no: 'SAP项目节点号' (含未解释英文)
  - pro_sap_bom_item_ref.sap_item_no: 'SAP项目号' (含未解释英文)
  - pro_sap_routing_ref.sap_routing_ref_id: 'SAP工艺路线参考ID' (含未解释英文)
  - pro_sap_routing_ref.sap_system_id: 'SAP系统ID' (含未解释英文)
  - pro_sap_routing_ref.sap_routing_group: 'SAP工艺路线组' (含未解释英文)
  - pro_sap_routing_ref.sap_group_counter: 'SAP组计数器' (含未解释英文)
  - pro_sap_operation_ref.sap_operation_ref_id: 'SAP工序参考ID' (含未解释英文)
  - pro_sap_operation_ref.sap_routing_ref_id: 'SAP工艺路线参考ID' (含未解释英文)
  - pro_sap_operation_ref.sap_operation_no: 'SAP工序号' (含未解释英文)
  - pro_sap_operation_ref.sap_work_center_code: 'SAP工作中心编码' (含未解释英文)
  - pro_sap_work_center_ref.sap_work_center_ref_id: 'SAP工作中心参考ID' (含未解释英文)
  - pro_sap_work_center_ref.sap_system_id: 'SAP系统ID' (含未解释英文)
  - pro_sap_work_center_ref.sap_work_center_code: 'SAP工作中心编码' (含未解释英文)
  - pro_sap_production_order_ref.sap_prod_order_ref_id: 'SAP生产订单参考ID' (含未解释英文)
  - pro_sap_production_order_ref.sap_system_id: 'SAP系统ID' (含未解释英文)
  - pro_sap_production_order_ref.sap_order_no: 'SAP订单号' (含未解释英文)
  - pro_sap_plant_map.sap_plant_map_id: 'SAP工厂映射ID' (含未解释英文)
  - pro_sap_plant_map.sap_plant_ref_id: 'SAP工厂参考ID' (含未解释英文)
  - pro_sap_material_map.sap_material_map_id: 'SAP物料映射ID' (含未解释英文)
  - pro_sap_material_map.sap_material_ref_id: 'SAP物料参考ID' (含未解释英文)
  - pro_sap_bom_map.sap_bom_map_id: 'SAP BOM映射ID' (含未解释英文)
  - pro_sap_bom_map.sap_bom_ref_id: 'SAP BOM参考ID' (含未解释英文)
  - pro_sap_bom_item_map.sap_bom_item_map_id: 'SAP BOM行映射ID' (含未解释英文)
  - pro_sap_bom_item_map.sap_bom_item_ref_id: 'SAP BOM行参考ID' (含未解释英文)
  - pro_sap_bom_item_map.bom_item_id: 'BOM明细ID' (含未解释英文)
  - pro_sap_routing_map.sap_routing_map_id: 'SAP工艺路线映射ID' (含未解释英文)
  - pro_sap_routing_map.sap_routing_ref_id: 'SAP工艺路线参考ID' (含未解释英文)
  - pro_sap_operation_map.sap_operation_map_id: 'SAP工序映射ID' (含未解释英文)
  - pro_sap_operation_map.sap_operation_ref_id: 'SAP工序参考ID' (含未解释英文)
  - pro_sap_work_center_map.sap_wc_map_id: 'SAP工作中心映射ID' (含未解释英文)
  - pro_sap_work_center_map.sap_work_center_ref_id: 'SAP工作中心参考ID' (含未解释英文)
  - pro_sap_production_order_map.sap_prod_order_map_id: 'SAP生产订单映射ID' (含未解释英文)
  - pro_sap_production_order_map.sap_prod_order_ref_id: 'SAP生产订单参考ID' (含未解释英文)
  - pro_bom_substitution_group.bom_item_id: 'BOM明细ID' (含未解释英文)
  - pro_bom_cutover_rule.bom_item_id: 'BOM明细ID' (含未解释英文)
  - pro_finished_good_serial.udi_code: 'UDI编码' (含未解释英文)
  - pro_report_confirmation_if.sap_order_no: 'SAP订单号' (含未解释英文)
  - pro_report_confirmation_if.sap_operation_no: 'SAP工序号' (含未解释英文)
  - pro_inspection_result_if.sap_order_no: 'SAP订单号' (含未解释英文)
  - pro_inspection_result_if.sap_operation_no: 'SAP工序号' (含未解释英文)
  - pro_consumption_posting_if.sap_order_no: 'SAP订单号' (含未解释英文)
  - pro_consumption_posting_if.sap_reservation_no: 'SAP预留号' (含未解释英文)
  - pro_consumption_posting_if.sap_reservation_item: 'SAP预留行号' (含未解释英文)

## 类型校验
结果: PASS

## 结论
校验通过，可进入DDL生成阶段。
建议处理4个dict_code缺失和69个字段说明问题。