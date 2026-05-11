# 数据库设计规范
## 1. 设计总规范
- 完全遵循RuoYi数据库命名规范，表名采用下划线小写格式
- 所有生产模块表名统一前缀为`pro_`，与现有系统表隔离
- 所有表必须包含以下审计字段：
  - `del_flag char(1) default '0'`：逻辑删除标识（0存在 2删除）
  - `create_by varchar(64) default ''`：创建人
  - `create_time timestamp`：创建时间
  - `update_by varchar(64) default ''`：更新人
  - `update_time timestamp`：更新时间
- 核心业务字段必须建立索引，保证查询性能
- 生产数据按月分表，历史数据归档策略：超过1年的历史数据自动归档到归档库

---
## 2. 核心表清单
| 模块 | 表名 | 说明 | 主键 | 核心索引 |
|------|------|------|------|----------|
| 派工单 | `pro_dispatch_template` | 派工单模板表 | `template_id` | `process_type` |
| 派工单 | `pro_dispatch_template_field` | 模板扩展字段表 | `field_id` | `template_id` |
| 派工单 | `pro_dispatch_order` | 派工单主表 | `dispatch_id` | `order_id`、`batch_no`、`dispatch_no`(唯一) |
| 派工单 | `pro_dispatch_person` | 派工单人员关联表 | `id` | `dispatch_id` |
| 批记录 | `pro_batch_record` | 电子批记录主表 | `record_id` | `batch_no`(唯一)、`order_id` |
| 批记录 | `pro_batch_record_data` | 批记录数据采集表 | `data_id` | `record_id`、`data_type` |
| 批记录 | `pro_batch_quality_relation` | 质量关联表 | `id` | `record_id` |
| 批记录 | `pro_batch_signature` | 电子签名表 | `signature_id` | `record_id` |
| 报工 | `pro_work_report` | 现场报工主表 | `report_id` | `dispatch_id`、`batch_no`、`report_no`(唯一) |
| 报工 | `pro_work_hour_record` | 工时记录表 | `record_id` | `user_id`、`dispatch_id` |
| 报工 | `pro_process_actual` | 工序实绩表 | `actual_id` | `dispatch_id` |
| 异常 | `pro_production_exception` | 异常工单表 | `exception_id` | `batch_no`、`status`、`exception_no`(唯一) |
| 异常 | `pro_exception_level_config` | 分级响应配置表 | `config_id` | `exception_type`、`level` |
| 异常 | `pro_exception_knowledge_base` | 知识库表 | `kb_id` | `exception_type` |

---
## 3. SQL脚本规范
- 所有数据库变更脚本必须存放于`/docs/sql_changes/`目录下
- 脚本命名格式：`YYYYMMDD_描述.sql`，比如`20240520_新增生产模块表.sql`
- 脚本必须包含回滚语句，避免不可逆变更
- 涉及业务数据变更的脚本必须经过DBA评审后才能执行
- 生产环境执行脚本前必须在测试环境验证通过
