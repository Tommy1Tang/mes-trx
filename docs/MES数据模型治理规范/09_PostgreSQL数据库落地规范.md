# PostgreSQL数据库落地规范

## 目标

本规范用于把 MES 逻辑数据模型落地到 PostgreSQL，作为后续生成建表 SQL、索引、分区、CDC、代码生成和性能评审的依据。

当前推荐文件：

- 通用逻辑字典：`../MES系统基础表逐字段数据字典_按优先级.csv`
- PostgreSQL 适配字典：`../MES系统基础表逐字段数据字典_按优先级_pgsql.csv`

## 基本原则

- 业务模型不因 MySQL 切 PostgreSQL 而重做，主要调整数据库方言、索引、分区和运行时落地策略。
- 主键继续使用 `bigint` 雪花 ID，不使用 `serial`、`bigserial` 作为核心业务表主键。
- 状态、类型、原因、判断字段继续使用 `dict_code` 管理，不直接改成 PostgreSQL enum。
- 高频原始 SCADA 数据不进入 MES 主库，MES 主库只保存业务证据、摘要、告警和追溯结论。
- Outbox、审计、采集、告警、幂等、死信等高增长表必须提前设计索引和归档策略。

## 类型映射

| 逻辑类型 | PostgreSQL类型 | 说明 |
|---|---|---|
| `bigint` | `bigint` | 雪花 ID、外键 ID、业务大整数 |
| `varchar(n)` | `varchar(n)` | 编码、名称、状态、类型等 |
| `char(1)` | `char(1)` | `Y/N`、`0/1` 标识，保持与 RuoYi 字典兼容 |
| `datetime` | `timestamp` | 默认使用无时区时间，按工厂本地业务时间记录 |
| `date` | `date` | 日期 |
| `time` | `time` | 时间 |
| `decimal(p,s)` | `numeric(p,s)` | 数量、重量、温度、OEE、比例等精确数值 |
| `int` | `integer` | 序号、次数、秒数、状态版本 |
| `text` | `text` | 长文本、说明、表达式 |
| JSON类文本 | `jsonb` | 上下文快照、事件载荷、响应快照、步骤快照 |

## JSONB字段建议

以下字段在 PostgreSQL 适配版 CSV 中建议使用 `jsonb`：

| 表 | 字段 | 用途 |
|---|---|---|
| `pro_mbr_execution_context` | `context_json` | MBR预编译上下文快照 |
| `pro_transactional_outbox` | `payload` | Outbox事件载荷 |
| `pro_dead_letter_message` | `payload` | 死信消息载荷 |
| `pro_device_command_log` | `command_payload` | 设备指令内容 |
| `pro_idempotency_request` | `response_snapshot` | 幂等响应快照 |
| `pro_mbr_change_record` | `before_snapshot`、`after_snapshot` | MBR变更前后快照 |
| `pro_ebr_step_record` | `step_snapshot` | EBR步骤执行快照 |

使用规则：

- `jsonb` 字段必须保存结构化 JSON，不要混放 XML、纯文本和 JSON。
- 需要按 JSON 内部字段查询时，再考虑 GIN 索引。
- 不要把高频原始遥测曲线塞进 `jsonb`，原始曲线应保留在 ThingsBoard/时序库。

## 时间字段规范

默认使用 `timestamp`，适合工厂本地生产时间、批记录时间、报工时间。

如果未来系统跨时区、多国家部署，或需要严格按 UTC 追踪外部接口事件，可在 DDL 生成阶段把以下字段评审为 `timestamptz`：

- 接口消息时间。
- Outbox 发送时间。
- CDC 发布时间。
- 审计追踪时间。
- 死信失败时间。
- 登录、签名、跨系统调用链路时间。

同一张表内不要混用多个时间语义，字段注释必须说明业务时区。

## 主键与ID规范

- 所有核心业务表主键使用 `bigint`。
- 推荐由应用侧统一生成雪花 ID。
- 不建议核心业务表使用 PostgreSQL `serial`、`bigserial` 或 `identity`。
- 外部系统原始 ID 使用 `varchar` 保存，例如 ThingsBoard 设备 ID、SAP 单号。
- 业务编号字段继续使用 `varchar(64)` 并建立唯一索引。

## 外键策略

字段字典中的 `foreign_key_ref` 是逻辑外键事实来源。

物理外键建议分级处理：

| 场景 | 建议 |
|---|---|
| 主数据、低频配置表 | 可以创建物理外键 |
| 工单、BOM、MBR、EBR核心事实表 | 谨慎创建物理外键，需评估批量导入和并发写入 |
| 高频采集、告警、审计、Outbox、死信、幂等表 | 默认不创建物理外键，只保留逻辑外键和索引 |
| 分区表 | 优先使用逻辑外键，避免复杂分区外键约束 |

不创建物理外键不代表无约束，应用层、服务层和数据校验任务必须保证引用一致性。

## 索引命名规范

| 类型 | 命名 |
|---|---|
| 主键 | `pk_表名` |
| 唯一索引 | `uk_表名_字段1_字段2` |
| 普通索引 | `idx_表名_字段1_字段2` |
| GIN索引 | `gin_表名_字段` |
| 分区表本地索引 | `idx_分区表名_字段` |

常见索引规则：

- 所有主键自动建立主键索引。
- 所有 `unique_key_part = Y` 字段应纳入唯一索引设计。
- 所有高频查询的外键字段应建立普通索引。
- 状态 + 时间字段组合适合 Outbox、死信、补偿任务、告警列表。
- 工单 + 工序 + 批次字段组合适合 EBR、投料、称量、采集和追溯查询。

## 推荐重点索引

| 表 | 推荐索引 |
|---|---|
| `pro_transactional_outbox` | `(event_status, create_time)`、`(target_system, event_status)`、`(idempotency_key)`、`(partition_key, create_time)` |
| `pro_idempotency_request` | 唯一索引 `(idempotency_key)`、普通索引 `(expire_time, archive_flag)` |
| `pro_dead_letter_message` | `(process_status, target_system)`、`(sla_due_time)` |
| `pro_integration_reconcile_task` | `(task_status, target_system)`、`(owner_id, sla_due_time)` |
| `pro_audit_trail` | `(biz_type, biz_id)`、`(operation_time)`、`(operator_id, operation_time)` |
| `pro_operation_data_collect` | `(prod_order_id, order_op_id)`、`(scada_point_id, collect_time)` |
| `pro_scada_alarm_event` | `(alarm_status, alarm_time)`、`(equipment_id, alarm_time)`、`(exception_id)` |
| `pro_ebr_step_record` | `(ebr_id, step_id)`、`(prod_order_id)` 如落地时保留冗余 |
| `pro_ebr_param_record` | `(ebr_step_id)`、`(scada_point_id, sample_time)` |
| `pro_weighing_record` | `(op_consume_id)`、`(material_lot_id)`、`(scale_equipment_id, weighing_time)` |

## 分区与归档策略

以下表建议优先评估 PostgreSQL 分区：

| 表 | 建议分区键 | 建议策略 |
|---|---|---|
| `pro_operation_data_collect` | `collect_time` | 按月分区 |
| `pro_scada_alarm_event` | `alarm_time` | 按月分区 |
| `pro_equipment_state_event` | `state_start_time` | 按月分区 |
| `pro_environment_monitor_record` | `monitor_time` | 按月分区 |
| `pro_cold_chain_monitor_record` | `record_time` | 按月分区 |
| `pro_audit_trail` | `operation_time` | 按月或按季度分区 |
| `pro_transactional_outbox` | `create_time` | 按月分区，已完成事件可归档 |
| `pro_idempotency_request` | `expire_time` | 按月分区，过期后归档 |
| `pro_dead_letter_message` | `create_time` | 按月分区 |
| `pro_ebr_param_record` | `sample_time` | 数据量大时按月分区 |

归档原则：

- 合规证据不能简单物理删除。
- 已完成 Outbox 可转历史表或冷分区。
- 幂等记录可按过期时间归档，但与审计相关的数据要保留可追溯线索。
- 分区清理必须经过 QA/IT 数据保留策略确认。

## CDC与Outbox落地

PostgreSQL 推荐使用逻辑复制配合 Debezium 监听 `pro_transactional_outbox`。

落地要求：

- 数据库必须启用逻辑复制能力。
- Outbox 表必须包含事件状态、目标系统、分区键、幂等键、链路追踪 ID。
- 应用本地事务只负责写业务事实和 Outbox，不同步等待外部系统。
- CDC 发布失败时允许启用 SQL 轮询降级，但不能作为高并发主路径。
- 消费端必须支持幂等消费，不能假设 MQ 只投递一次。

## PostgreSQL DDL生成注意事项

生成 DDL 时建议：

- 表名和字段名保持小写下划线，不使用双引号包裹标识符。
- `varchar`、`char` 保留长度。
- `numeric` 必须带精度和小数位，如 `numeric(18,6)`。
- `timestamp` 不带长度。
- `jsonb` 不带长度。
- `text` 不带长度。
- 默认值字符串必须使用单引号。
- `del_flag` 默认值建议为 `'0'`。
- `create_time` 可默认 `CURRENT_TIMESTAMP`，是否默认由代码生成规范统一决定。

## RuoYi代码生成注意事项

- PostgreSQL 字段类型到 Java 类型需重新映射。
- `numeric` 对应 `BigDecimal`。
- `timestamp` 对应 `LocalDateTime` 或项目统一时间类型。
- `date` 对应 `LocalDate`。
- `time` 对应 `LocalTime`。
- `jsonb` 建议先按 `String` 或 JSON 类型处理，不要直接展开成多个字段。
- `bigint` 主键对应 `Long`。
- `char(1)` 标识字段建议按 `String` 处理，保持字典兼容。

## 禁止事项

- 禁止把 MySQL 的 `auto_increment`、`tinyint`、`datetime` 原样带入 PostgreSQL DDL。
- 禁止核心业务主键改成数据库自增而不评估分布式 ID 策略。
- 禁止在高频写入表上无脑添加大量物理外键。
- 禁止没有索引地扫描 Outbox、采集、告警、审计和幂等表。
- 禁止把 ThingsBoard 原始时序数据全量落入 MES PostgreSQL 主库。
- 禁止把 JSON 字段设计为 `varchar(500)` 后又在代码里塞复杂对象。

## AI Coding加载建议

当任务涉及 PostgreSQL、pgsql、建表 SQL、DDL、索引、分区、CDC、RuoYi 代码生成时，必须加载本规范。

推荐加载顺序：

1. 读取 `README.md`。
2. 读取本规范。
3. 读取 `08_MES运行时架构约束与数据落地规范.md`。
4. 按目标模块读取 `../MES系统基础表逐字段数据字典_按优先级_pgsql.csv`。
5. 生成 SQL 前读取 `06_校验规则清单.md` 和 `07_代码生成前检查清单.md`。
