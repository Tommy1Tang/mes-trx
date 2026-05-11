# MES运行时架构约束与数据落地规范

## 目标

本规范用于约束 IVD MES 在运行时的系统架构和数据落地方式，避免把 147 张业务表按传统同步 CRUD 方式直接落地后出现性能抖动、接口阻塞、重复提交、SCADA 高频数据冲击主库、运行中 MBR 上下文脑裂等问题。

核心目标：

- 车间执行动作要快速响应，关键交互目标响应时间建议控制在 500ms 以内。
- MBR/EBR 合规数据必须可靠落库，缓存不能作为合规事实源。
- SAP、WMS、OA、ThingsBoard 等外部系统不能反向阻塞车间物理执行。
- ThingsBoard 或时序库保存高频原始数据，MES 主库只保存业务结论、合规证据、摘要和引用。
- 所有关键执行、投料、称量、签名、接口回传必须支持幂等和可追溯。
- 运行中 ECN、返工、Hold 恢复等变更必须通过 Safe Hold 和上下文刷新机制处理。

## 运行时分层

| 层级 | 推荐承载 | 主要职责 | 禁止事项 |
|---|---|---|---|
| 车间交互层 | Web/平板/PDA/扫码枪 | 执行操作、扫码、防错提示、称量确认 | 不直接解析完整 MBR 规则树 |
| 运行时上下文层 | Redis + `pro_mbr_execution_context` | 缓存工单执行状态机、规则快照、步骤上下文 | Redis 不作为最终事实源 |
| MES事务主库 | 关系型数据库 | 保存工单、投料、称量、EBR、签名、审计等合规事实 | 不承接高频原始遥测 |
| CDC/MQ发布层 | Debezium/Canal + Kafka/RabbitMQ | 监听 Outbox 变化并低延迟发布事件 | 不用高频 SQL 轮询冲击主库 |
| 异步集成层 | `pro_transactional_outbox` + Worker | 异步发送 SAP、WMS、SCADA、OA 集成事件 | 不在车间请求链路里同步等待 SAP |
| OT/SCADA层 | ThingsBoard CE + 时序库 | 保存设备遥测、告警、规则链和趋势曲线 | 不把秒级/毫秒级明细全量写入 MES 主库 |
| 补偿运维层 | `pro_integration_reconcile_task` + `pro_dead_letter_message` | 处理重试、死信、人工补偿、冲销和对账 | 不让失败消息阻塞主业务表 |

## MBR预编译规范

### 触发时机

MBR 执行上下文必须在以下时机生成或刷新：

- 生产工单发布。
- 派工单发布。
- MBR 版本变更后重新下达。
- 工单发生返工、跳转、Hold 后恢复。
- ECN 生效并影响正在执行或待执行的工单。

### 数据落地

使用 `pro_mbr_execution_context` 保存预编译结果，至少应包含：

- 工单 ID、MBR 版本 ID、BOM ID、Routing ID。
- MBR 版本哈希或规则哈希。
- 编译后的 Phase/Step 状态机 JSON。
- 步骤参数、物料、设备、质控、联锁规则快照。
- 当前执行位置、上下文状态、缓存键、过期时间。
- 上下文版本、上一版上下文 ID、来源 ECN ID。
- 刷新状态、Hold 原因、乐观锁版本。
- 编译人、编译时间、失效时间、失效原因。

### 执行原则

- 车间点击“开始步骤”“扫码投料”“称量确认”时，不允许实时跨 6 张以上 MBR 模板表做规则解析。
- 运行时优先读取 `pro_mbr_execution_context` 或 Redis 中的扁平化上下文。
- 关键执行事实仍要同步或准同步落入 EBR、称量、投料、审计等事实表。
- Redis 只允许作为缓存和加速层，不能作为审计、放行、批记录的唯一依据。

## Safe Hold与上下文刷新规范

### 适用场景

以下场景必须触发上下文失效评估：

- ECN 影响当前产品、物料、BOM、Routing、MBR、检验方案或设备规则。
- MBR 版本被紧急停用、替换或召回。
- 工单执行中发生返工、跳转、偏差恢复或 Hold 恢复。
- 质量或法规要求临时调整工艺参数、上下限、复核要求。
- 关键设备、电子天平、传感器校准状态发生影响当前步骤的变化。

### 状态控制

`pro_mbr_execution_context` 建议使用以下上下文状态：

- `RUNNING`：当前上下文可执行。
- `HOLD_PENDING_UPDATE`：命中变更影响，等待刷新，不允许继续执行受影响步骤。
- `RECOMPILING`：后台正在重编译上下文。
- `SWITCH_READY`：新上下文已生成，等待切换确认。
- `OBSOLETE`：旧上下文已作废。
- `FAILED`：上下文刷新失败，需要人工处理。

### 刷新日志

使用 `pro_mbr_context_refresh_log` 记录上下文刷新全过程，至少应包含：

- 刷新日志 ID。
- 原上下文 ID、新上下文 ID。
- 来源类型：ECN、返工、Hold恢复、人工刷新、系统重编译。
- 来源单据 ID，例如 `pro_ecn_order.ecn_id`。
- 影响范围：产品、工单、批次、步骤、物料、设备、检验方案。
- 刷新前状态、刷新后状态。
- 旧版本哈希、新版本哈希。
- 差异摘要和差异明细引用。
- 刷新结果、失败原因、处理人、处理时间。
- 是否触发电子签名、是否写入审计追踪。

### 处理流程

1. 变更生效前先做影响范围分析，不默认全线急停。
2. 只对受影响的工单、批次、步骤或设备范围执行 Safe Hold。
3. 将受影响上下文标记为 `HOLD_PENDING_UPDATE`。
4. 车间平板刷新或下一次提交时必须识别 Hold 状态并阻断受影响动作。
5. 后台服务根据新 MBR 或 ECN 规则重新预编译上下文。
6. 生成 `pro_mbr_context_refresh_log`，记录新旧快照差异。
7. 需要 QA、生产主管或工艺人员确认时，必须走电子签名。
8. 切换成功后旧上下文置为 `OBSOLETE`，新上下文置为 `RUNNING`。

### 禁止事项

- 禁止直接修改底层 MBR 模板表后让运行中工单继续使用旧缓存而不提示。
- 禁止 ECN 生效时不做影响范围分析。
- 禁止无审计地覆盖 `pro_mbr_execution_context`。
- 禁止把所有 ECN 都处理成全线急停，应按影响范围 Safe Hold。

## EBR事实落地规范

### 事实源边界

| 数据 | 推荐事实源 | 说明 |
|---|---|---|
| 步骤执行结果 | `pro_ebr_step_record` | 固化步骤开始、结束、执行人、设备、状态和复核结果 |
| 关键参数结论 | `pro_ebr_param_record` | 固化温度、转速、重量、时间、压力等批记录证据值 |
| 投料事实 | `OPERATION_CONSUMPTION` + `pro_weighing_record` | 投料和称量要能互相追溯 |
| 异常偏差 | `pro_exception_record` | SCADA告警、联锁阻断、称量失败等最终要能关联异常 |
| 电子签名 | `pro_e_signature_record` | 执行、复核、审核、放行、驳回都要留痕 |
| 审计追踪 | `pro_audit_trail` | 关键数据变更、重做、删除、补录必须留痕 |

### 禁止事项

- 不允许只写缓存不写 EBR。
- 不允许只保存前端展示值，不保存采集来源、时间窗口或原始数据引用。
- 不允许人工修改 EBR 关键数据后不写审计追踪。
- 不允许用报工表替代电子批记录事实表。

## 事务外箱与CDC发布规范

### 适用场景

以下场景必须采用事务外箱或等价机制：

- MES 投料回传 SAP。
- MES 报工确认回传 SAP。
- MES 检验结果回传 SAP。
- MES 向 WMS、OA、UDI、ThingsBoard 发送业务事件。
- 关键异常、偏差、放行结果需要通知外部系统。

### 数据落地

使用 `pro_transactional_outbox` 保存待发送事件，推荐字段包括：

- `outbox_id`：主键。
- `event_type`：事件类型。
- `biz_table`、`biz_id`：来源业务表和业务 ID。
- `target_system`：目标系统，例如 SAP、WMS、OA、TB。
- `payload`：事件载荷。
- `idempotency_key`：幂等键。
- `partition_key`：事件分区键，建议按工单、批次、物料或目标系统分区。
- `event_version`：事件版本。
- `trace_id`：链路追踪 ID。
- `publish_mode`：发布模式，建议为 CDC、MQ、POLLING_FALLBACK。
- `cdc_published_flag`：CDC 是否已发布标识。
- `event_status`：PENDING、PROCESSING、SUCCESS、ERROR、DEAD。
- `retry_count`、`next_retry_time`：重试次数和下次重试时间。
- `dead_letter_id`：关联死信消息。
- `last_error_message`：最后一次失败原因。
- `create_time`、`sent_time`、`update_time`：时间字段。

### 发布模式

- 首选 CDC 模式：使用 Debezium、Canal 或数据库原生日志订阅能力监听 Outbox 表变更。
- MQ 消费者接收 CDC 事件后异步调用 SAP、WMS、OA、ThingsBoard 等外部系统。
- SQL 轮询只能作为 CDC 故障时的降级方案，不允许作为高并发主路径。
- 降级轮询必须分页、限流、按状态和时间窗口扫描，并设置独立线程池。

### 处理规则

- 车间本地动作只需要完成 MES 本地事务和 Outbox 写入，不等待 SAP 返回。
- 外部系统失败时更新 Outbox 状态，不回滚已完成的车间事实。
- 超过最大重试次数后进入 `pro_dead_letter_message`。
- 需要人工处理的失败进入 `pro_integration_reconcile_task`。
- Outbox 表必须建立适合 CDC 和补偿查询的索引，避免全表扫描。

## SAP/WMS集成补偿规范

### 核心原则

外部系统失败只能进入补偿和对账流程，不能直接锁死车间执行主链路。CDC 只能降低 MES 到 MQ 的发布延迟，不能保证 SAP 一定实时入账，因此补偿任务和对账看板仍然必须保留。

### 使用表

- `_IF` 接口表：保存具体接口业务数据和回传状态。
- `INTERFACE_MESSAGE`：保存统一接口消息。
- `pro_transactional_outbox`：保存异步发布事件。
- `pro_integration_reconcile_task`：保存人工补偿、重发、冲销、对账任务。
- `pro_dead_letter_message`：保存无法自动处理的失败消息。

### 补偿动作

补偿任务至少支持以下动作：

- 重发。
- 跳过并说明原因。
- 本地冲销。
- SAP 冲销。
- 人工更正后重发。
- 标记为已对账。
- 升级为异常或偏差。

## 幂等控制与归档规范

### 适用场景

以下动作必须有 `client_request_id` 或等价幂等键：

- 扫码投料。
- 电子称量确认。
- 工序开始、暂停、恢复、完成。
- 报工提交。
- 电子签名。
- 异常关闭。
- 放行、驳回、复核。
- 接口消息重试。

### 数据落地

使用 `pro_idempotency_request` 记录请求幂等信息，推荐字段包括：

- `idempotency_id`：主键。
- `idempotency_key`：请求唯一键。
- `source_terminal`：来源终端。
- `operator_id`：操作人。
- `biz_type`、`biz_id`：业务类型和业务 ID。
- `request_hash`：请求内容哈希。
- `process_status`：处理中、成功、失败。
- `response_snapshot`：已处理请求的返回摘要。
- `expire_time`：幂等记录过期时间。
- `archive_flag`：是否已归档。

### 处理规则

- 同一个幂等键重复提交时，不允许重复落投料、报工、签名等事实。
- 重复请求应返回第一次成功结果或明确的处理中状态。
- 幂等记录过期时间要覆盖现场弱网络重试窗口。
- 幂等表必须按时间或业务域进行分区、归档或清理，避免无限膨胀。
- 已归档数据仍需满足审计追踪要求，不能物理删除关键合规证据。

## ThingsBoard与SCADA数据落地规范

### 数据分层

| 数据类型 | 保存位置 | MES是否落库 |
|---|---|---|
| 原始毫秒级遥测 | ThingsBoard/时序库 | 不落 MES 主库 |
| 秒级或分钟级趋势 | ThingsBoard/时序库 | 只保存链接或摘要 |
| 与批次放行相关的极值、均值、超限时长 | MES `pro_process_monitor_summary` 或 `pro_ebr_param_record` | 必须落库 |
| 与工序执行相关的单点采集值 | MES `pro_operation_data_collect` | 必须落库 |
| 告警事件 | ThingsBoard + `pro_scada_alarm_event` | MES 保存业务相关告警 |
| 偏差和异常结论 | MES `pro_exception_record` | 必须落库 |

### 落地原则

- MES 管“结果与合规”，ThingsBoard 管“过程与高频”。
- `pro_operation_data_collect` 不用于保存全量原始曲线。
- EBR 中的参数记录应保存业务证据值、采集时间窗口、点位、来源和原始曲线链接。
- SCADA 告警进入 MES 后，需要按业务规则判断是否生成异常、偏差、Hold 或联锁事件。

## 死信隔离与监控规范

### 进入死信的条件

- 超过最大重试次数仍失败。
- 外部系统返回不可恢复错误。
- 报文结构错误，无法解析。
- 幂等冲突无法自动判断。
- 业务对象已关闭或作废，无法继续处理。

### 数据落地

使用 `pro_dead_letter_message` 保存死信内容，至少包含：

- 来源表、来源 ID、消息类型。
- 目标系统。
- 原始 payload 或 payload 引用。
- 失败次数、最后失败时间、最后失败原因。
- 处理状态、处理人、处理结论。
- 是否生成补偿任务。

### 监控要求

- 必须建立死信和补偿任务监控视图或看板。
- 必须监控 PENDING、ERROR、DEAD、超 SLA 未处理数量。
- 必须按目标系统、接口类型、工厂、业务域统计失败趋势。
- 死信堆积达到阈值时必须通知 IT、生产计划或 QA 责任人。

## 代码级强制契约

### 推荐注解或框架约束

后端代码建议通过统一注解、AOP 或基础框架强制执行以下契约：

- `@MesTransactional`：本地事务、EBR事实、Outbox 事件必须在同一个事务边界内完成。
- `@Idempotent`：扫码、称量、报工、签名、放行动作必须校验幂等键。
- `@OutboxEvent`：跨系统调用只能写 Outbox 事件，由异步通道发布。
- `@AuditTrail`：关键主数据、MBR、EBR、签名、异常、补偿操作必须写审计追踪。

### 禁止直连

- 禁止业务代码直接调用 SAP、WMS、OA、ThingsBoard 等外部接口并等待返回后再提交本地事实。
- 禁止出现绕过 Outbox 的同步 `RestTemplate`、HTTP Client、Feign 直连外部系统调用。
- 禁止在 Controller 层直接写入 EBR、签名、审计等关键事实表。
- 禁止绕过幂等服务直接提交投料、称量、报工和签名。

### 代码评审要求

涉及以下关键词的代码必须重点评审：

- SAP、WMS、OA、ThingsBoard、SCADA。
- RestTemplate、Feign、HttpClient、WebClient。
- Outbox、MQ、CDC、Kafka、RabbitMQ。
- Idempotent、client_request_id、trace_id。
- EBR、signature、audit、weighing、consumption。

## 禁止性架构规则

- 禁止车间执行请求同步等待 SAP/WMS/OA 返回后才提交本地事实。
- 禁止把 ThingsBoard 高频遥测全量写入 MES 主库。
- 禁止把 Redis 当成电子批记录、审计追踪或签名事实源。
- 禁止在现场扫码、称量、报工动作中实时联表解析完整 MBR 模板。
- 禁止运行中 ECN 生效后不刷新或不失效对应 MBR 执行上下文。
- 禁止关键执行动作没有幂等键。
- 禁止接口失败只记录日志、不进入可处理的补偿任务。
- 禁止手工修复接口数据但不写审计追踪。
- 禁止高并发主路径使用无边界 SQL 轮询 Outbox。

## AI Coding加载建议

当任务涉及以下关键词时，必须加载本规范：

- MBR执行引擎。
- MBR上下文刷新、Safe Hold、ECN。
- EBR电子批记录。
- ThingsBoard/SCADA/数据采集。
- SAP/WMS/OA接口。
- 报工回传、投料过账、检验回传。
- 电子天平、称量、防错。
- 幂等、重试、死信、Outbox、CDC、MQ、Redis。
- 异常补偿、接口对账、弱网络。

推荐加载顺序：

1. 读取 `README.md`。
2. 读取本规范。
3. 读取 `MES系统基础表清单_按优先级.md` 中对应业务域。
4. 只读取目标表在逐字段数据字典中的字段行。
5. 生成代码或 SQL 前读取 `06_校验规则清单.md` 和 `07_代码生成前检查清单.md`。

