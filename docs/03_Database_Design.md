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
| 排产 | `pro_shift` | 班次主数据表 | `shift_id` | `shift_code`(唯一) |
| 排产 | `pro_calendar` | 生产日历表 | `calendar_id` | `calendar_date`(唯一)、`plant_id` |
| 排产 | `pro_schedule_plan` | 排产计划表 | `plan_id` | `plan_no`(唯一)、`order_id`、`work_center_id`、`schedule_status` |
| 排产 | `pro_schedule_log` | 排产调整日志表 | `log_id` | `plan_id`、`create_time` |
| 执行 | `pro_batch_review` | 批记录审核流程表 | `review_id` | `record_id`、`review_node`、`review_status` |
| 质量 | `pro_exception_category` | 异常分类配置表 | `category_id` | `category_code`(唯一) |
| 执行 | `pro_exception_escalation` | 异常升级记录表 | `escalation_id` | `exception_id`、`escalation_time` |
| 主数据 | `pro_wc_equipment` | 工作中心设备关系表 | `id` | `work_center_id`、`equipment_id`(联合唯一) |
| 质量 | `pro_nc_handling` | 不合格品处置表 | `handling_id` | `nc_code`(唯一)、`batch_no`、`handling_status` |
| 管理 | `pro_change_request` | 工程变更请求表 | `change_id` | `change_no`(唯一)、`change_type`、`change_status` |

---
## 3. SQL脚本规范
- 所有数据库变更脚本必须存放于`/docs/sql_changes/`目录下
- 脚本命名格式：`YYYYMMDD_描述.sql`，比如`20240520_新增生产模块表.sql`
- 脚本必须包含回滚语句，避免不可逆变更
- 涉及业务数据变更的脚本必须经过DBA评审后才能执行
- 生产环境执行脚本前必须在测试环境验证通过

---
## 4. 数据模型治理规范（强制执行）

本项目遵循 `docs/MES数据模型治理规范/` 中的全部规范：

### 4.1 规范文件索引
| 规范文件 | 用途 | 加载时机 |
|----------|------|----------|
| 01_AI渐进式加载指南.md | AI按任务分批读取上下文 | 所有AI Coding任务起点 |
| 02_新增表规范.md | 新增表的判断、命名、字段要求 | 新模块、新业务对象建模 |
| 03_新增字段规范.md | 新增字段的命名、类型、字典和外键规则 | 给已有表补字段 |
| 04_字典项管理规范.md | dict_code和枚举项管理规则 | 状态、类型、原因、判断字段 |
| 05_变更记录规范.md | 数据模型变更记录模板 | 所有表结构变更 |
| 06_校验规则清单.md | 每次变更后的硬性校验规则 | SQL生成前、评审前 |
| 07_代码生成前检查清单.md | 进入建表SQL和代码生成前的检查项 | RuoYi代码生成前 |

### 4.2 强制执行要求
1. **新增表**：必须通过02_新增表规范校验，更新表清单和逐字段数据字典
2. **新增字段**：必须通过03_新增字段规范校验，更新逐字段数据字典
3. **所有变更**：必须记录在 `05_Change_Log.md` 变更记录文件中
4. **生成SQL前**：必须通过06_校验规则清单
5. **代码生成前**：必须通过07_代码生成前检查清单

### 4.3 变更记录要求
- 变更编号格式：`DM-YYYYMMDD-序号`
- 变更记录存放于：`docs/05_Change_Log.md`
- 修改核心CSV前必须备份
