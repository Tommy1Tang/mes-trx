-- ============================================================================
-- L0 运行时韧性与架构支撑层 DDL
-- 生成日期：2026-05-27
-- 数据库：PostgreSQL 16
-- 变更编号：DM-20260527-L0
-- 说明：6张运行时韧性表，保护车间执行链路，防止外部系统故障阻塞生产
-- ============================================================================

-- ============================================================================
-- 1. pro_mbr_execution_context - MBR执行上下文表
-- 用途：工单下达时预编译MBR规则快照，后续执行直接读快照不实时查PLM
-- ============================================================================
CREATE TABLE pro_mbr_execution_context (
    context_id          BIGINT          NOT NULL,
    context_no          VARCHAR(64)     NOT NULL,
    prod_order_id       BIGINT          NOT NULL,
    mbr_version_id      BIGINT          NOT NULL,
    ebr_id              BIGINT,
    previous_context_id BIGINT,
    source_ecn_id       BIGINT,
    context_version     VARCHAR(32)     NOT NULL,
    context_hash        VARCHAR(128)    NOT NULL,
    context_status      VARCHAR(32)     NOT NULL,
    refresh_status      VARCHAR(32),
    hold_reason         VARCHAR(1000),
    cache_key           VARCHAR(256),
    context_json        JSONB           NOT NULL,
    current_step_id     BIGINT,
    expire_time         TIMESTAMP,
    lock_version        INTEGER         NOT NULL DEFAULT 0,
    create_by           VARCHAR(64),
    create_time         TIMESTAMP       NOT NULL,
    update_by           VARCHAR(64),
    update_time         TIMESTAMP,
    del_flag            CHAR(1)         NOT NULL DEFAULT '0',
    remark              VARCHAR(500),
    CONSTRAINT pk_pro_mbr_execution_context PRIMARY KEY (context_id)
);

COMMENT ON TABLE pro_mbr_execution_context IS 'MBR执行上下文表';
COMMENT ON COLUMN pro_mbr_execution_context.context_id IS 'MBR执行上下文ID';
COMMENT ON COLUMN pro_mbr_execution_context.context_no IS '执行上下文编号';
COMMENT ON COLUMN pro_mbr_execution_context.prod_order_id IS '生产工单ID';
COMMENT ON COLUMN pro_mbr_execution_context.mbr_version_id IS 'MBR版本ID';
COMMENT ON COLUMN pro_mbr_execution_context.ebr_id IS '电子批记录ID';
COMMENT ON COLUMN pro_mbr_execution_context.previous_context_id IS '上一版上下文ID';
COMMENT ON COLUMN pro_mbr_execution_context.source_ecn_id IS '来源ECN ID';
COMMENT ON COLUMN pro_mbr_execution_context.context_version IS '上下文版本号';
COMMENT ON COLUMN pro_mbr_execution_context.context_hash IS '上下文哈希';
COMMENT ON COLUMN pro_mbr_execution_context.context_status IS '上下文状态';
COMMENT ON COLUMN pro_mbr_execution_context.refresh_status IS '刷新状态';
COMMENT ON COLUMN pro_mbr_execution_context.hold_reason IS '暂停原因';
COMMENT ON COLUMN pro_mbr_execution_context.cache_key IS '缓存键';
COMMENT ON COLUMN pro_mbr_execution_context.context_json IS '上下文JSON快照';
COMMENT ON COLUMN pro_mbr_execution_context.current_step_id IS '当前步骤ID';
COMMENT ON COLUMN pro_mbr_execution_context.expire_time IS '过期时间';
COMMENT ON COLUMN pro_mbr_execution_context.lock_version IS '乐观锁版本';
COMMENT ON COLUMN pro_mbr_execution_context.create_by IS '创建人';
COMMENT ON COLUMN pro_mbr_execution_context.create_time IS '创建时间';
COMMENT ON COLUMN pro_mbr_execution_context.update_by IS '更新人';
COMMENT ON COLUMN pro_mbr_execution_context.update_time IS '更新时间';
COMMENT ON COLUMN pro_mbr_execution_context.del_flag IS '逻辑删除标识';
COMMENT ON COLUMN pro_mbr_execution_context.remark IS '备注';

CREATE UNIQUE INDEX uk_pro_mbr_execution_context_no ON pro_mbr_execution_context(context_no);
CREATE INDEX idx_pro_mbr_execution_context_order ON pro_mbr_execution_context(prod_order_id);
CREATE INDEX idx_pro_mbr_execution_context_mbr ON pro_mbr_execution_context(mbr_version_id);
CREATE INDEX idx_pro_mbr_execution_context_ebr ON pro_mbr_execution_context(ebr_id);
CREATE INDEX idx_pro_mbr_execution_context_status ON pro_mbr_execution_context(context_status);

-- ============================================================================
-- 2. pro_mbr_context_refresh_log - MBR执行上下文刷新日志表
-- 用途：记录ECN/返工/Hold恢复触发的上下文失效、重编译、切换过程
-- ============================================================================
CREATE TABLE pro_mbr_context_refresh_log (
    refresh_log_id      BIGINT          NOT NULL,
    old_context_id      BIGINT,
    new_context_id      BIGINT,
    source_type         VARCHAR(32)     NOT NULL,
    source_ecn_id       BIGINT,
    affected_scope      VARCHAR(1000),
    old_context_hash    VARCHAR(128),
    new_context_hash    VARCHAR(128),
    before_status       VARCHAR(32),
    after_status        VARCHAR(32),
    refresh_result      VARCHAR(32)     NOT NULL,
    diff_summary        VARCHAR(1000),
    failure_reason      VARCHAR(1000),
    operator_id         BIGINT,
    signature_id        BIGINT,
    audit_trail_id      BIGINT,
    refresh_time        TIMESTAMP       NOT NULL,
    create_by           VARCHAR(64),
    create_time         TIMESTAMP       NOT NULL,
    update_by           VARCHAR(64),
    update_time         TIMESTAMP,
    del_flag            CHAR(1)         NOT NULL DEFAULT '0',
    remark              VARCHAR(500),
    CONSTRAINT pk_pro_mbr_context_refresh_log PRIMARY KEY (refresh_log_id)
);

COMMENT ON TABLE pro_mbr_context_refresh_log IS 'MBR执行上下文刷新日志表';
COMMENT ON COLUMN pro_mbr_context_refresh_log.refresh_log_id IS 'MBR执行上下文刷新日志ID';
COMMENT ON COLUMN pro_mbr_context_refresh_log.old_context_id IS '旧上下文ID';
COMMENT ON COLUMN pro_mbr_context_refresh_log.new_context_id IS '新上下文ID';
COMMENT ON COLUMN pro_mbr_context_refresh_log.source_type IS '刷新来源类型';
COMMENT ON COLUMN pro_mbr_context_refresh_log.source_ecn_id IS '来源ECN ID';
COMMENT ON COLUMN pro_mbr_context_refresh_log.affected_scope IS '影响范围';
COMMENT ON COLUMN pro_mbr_context_refresh_log.old_context_hash IS '旧上下文的哈希';
COMMENT ON COLUMN pro_mbr_context_refresh_log.new_context_hash IS '新上下文的哈希';
COMMENT ON COLUMN pro_mbr_context_refresh_log.before_status IS '刷新前状态';
COMMENT ON COLUMN pro_mbr_context_refresh_log.after_status IS '刷新后状态';
COMMENT ON COLUMN pro_mbr_context_refresh_log.refresh_result IS '刷新结果';
COMMENT ON COLUMN pro_mbr_context_refresh_log.diff_summary IS '差异摘要';
COMMENT ON COLUMN pro_mbr_context_refresh_log.failure_reason IS '失败原因';
COMMENT ON COLUMN pro_mbr_context_refresh_log.operator_id IS '操作人ID';
COMMENT ON COLUMN pro_mbr_context_refresh_log.signature_id IS '电子签名ID';
COMMENT ON COLUMN pro_mbr_context_refresh_log.audit_trail_id IS '审计追踪ID';
COMMENT ON COLUMN pro_mbr_context_refresh_log.refresh_time IS '刷新时间';
COMMENT ON COLUMN pro_mbr_context_refresh_log.create_by IS '创建人';
COMMENT ON COLUMN pro_mbr_context_refresh_log.create_time IS '创建时间';
COMMENT ON COLUMN pro_mbr_context_refresh_log.update_by IS '更新人';
COMMENT ON COLUMN pro_mbr_context_refresh_log.update_time IS '更新时间';
COMMENT ON COLUMN pro_mbr_context_refresh_log.del_flag IS '逻辑删除标识';
COMMENT ON COLUMN pro_mbr_context_refresh_log.remark IS '备注';

CREATE INDEX idx_pro_mbr_context_refresh_log_old ON pro_mbr_context_refresh_log(old_context_id);
CREATE INDEX idx_pro_mbr_context_refresh_log_new ON pro_mbr_context_refresh_log(new_context_id);
CREATE INDEX idx_pro_mbr_context_refresh_log_source ON pro_mbr_context_refresh_log(source_type);
CREATE INDEX idx_pro_mbr_context_refresh_log_result ON pro_mbr_context_refresh_log(refresh_result);

-- ============================================================================
-- 3. pro_transactional_outbox - 事务外箱事件表
-- 用途：业务事件先落库再异步推送，保证本地事务和消息发送的原子性
-- ============================================================================
CREATE TABLE pro_transactional_outbox (
    outbox_id           BIGINT          NOT NULL,
    event_type          VARCHAR(64)     NOT NULL,
    biz_table           VARCHAR(128)    NOT NULL,
    biz_id              BIGINT          NOT NULL,
    target_system       VARCHAR(32)     NOT NULL,
    payload             JSONB           NOT NULL,
    idempotency_key     VARCHAR(128),
    partition_key       VARCHAR(128),
    event_version       VARCHAR(32),
    trace_id            VARCHAR(128),
    publish_mode        VARCHAR(32)     NOT NULL,
    cdc_published_flag  CHAR(1)         NOT NULL DEFAULT '0',
    event_status        VARCHAR(32)     NOT NULL,
    retry_count         INTEGER         NOT NULL DEFAULT 0,
    next_retry_time     TIMESTAMP,
    dead_letter_id      BIGINT,
    last_error_message  VARCHAR(1000),
    sent_time           TIMESTAMP,
    create_by           VARCHAR(64),
    create_time         TIMESTAMP       NOT NULL,
    update_by           VARCHAR(64),
    update_time         TIMESTAMP,
    del_flag            CHAR(1)         NOT NULL DEFAULT '0',
    remark              VARCHAR(500),
    CONSTRAINT pk_pro_transactional_outbox PRIMARY KEY (outbox_id)
);

COMMENT ON TABLE pro_transactional_outbox IS '事务外箱事件表';
COMMENT ON COLUMN pro_transactional_outbox.outbox_id IS '事务外箱记录ID';
COMMENT ON COLUMN pro_transactional_outbox.event_type IS '事件类型';
COMMENT ON COLUMN pro_transactional_outbox.biz_table IS '业务表名';
COMMENT ON COLUMN pro_transactional_outbox.biz_id IS '业务ID';
COMMENT ON COLUMN pro_transactional_outbox.target_system IS '目标系统';
COMMENT ON COLUMN pro_transactional_outbox.payload IS '事件载荷';
COMMENT ON COLUMN pro_transactional_outbox.idempotency_key IS '幂等键';
COMMENT ON COLUMN pro_transactional_outbox.partition_key IS '分区键';
COMMENT ON COLUMN pro_transactional_outbox.event_version IS '事件版本';
COMMENT ON COLUMN pro_transactional_outbox.trace_id IS '链路追踪ID';
COMMENT ON COLUMN pro_transactional_outbox.publish_mode IS '发布模式';
COMMENT ON COLUMN pro_transactional_outbox.cdc_published_flag IS 'CDC是否已发布';
COMMENT ON COLUMN pro_transactional_outbox.event_status IS '事件状态';
COMMENT ON COLUMN pro_transactional_outbox.retry_count IS '重试次数';
COMMENT ON COLUMN pro_transactional_outbox.next_retry_time IS '下次重试时间';
COMMENT ON COLUMN pro_transactional_outbox.dead_letter_id IS '死信消息ID';
COMMENT ON COLUMN pro_transactional_outbox.last_error_message IS '最后错误信息';
COMMENT ON COLUMN pro_transactional_outbox.sent_time IS '发送时间';
COMMENT ON COLUMN pro_transactional_outbox.create_by IS '创建人';
COMMENT ON COLUMN pro_transactional_outbox.create_time IS '创建时间';
COMMENT ON COLUMN pro_transactional_outbox.update_by IS '更新人';
COMMENT ON COLUMN pro_transactional_outbox.update_time IS '更新时间';
COMMENT ON COLUMN pro_transactional_outbox.del_flag IS '逻辑删除标识';
COMMENT ON COLUMN pro_transactional_outbox.remark IS '备注';

CREATE INDEX idx_pro_transactional_outbox_status ON pro_transactional_outbox(event_status);
CREATE INDEX idx_pro_transactional_outbox_target ON pro_transactional_outbox(target_system);
CREATE INDEX idx_pro_transactional_outbox_biz ON pro_transactional_outbox(biz_table, biz_id);
CREATE INDEX idx_pro_transactional_outbox_retry ON pro_transactional_outbox(next_retry_time) WHERE event_status = 'PENDING';
CREATE INDEX idx_pro_transactional_outbox_type ON pro_transactional_outbox(event_type);

-- ============================================================================
-- 4. pro_integration_reconcile_task - 集成对账补偿任务表
-- 用途：记录SAP/WMS等外部系统失败后的重发、冲销、人工补偿闭环
-- ============================================================================
CREATE TABLE pro_integration_reconcile_task (
    reconcile_task_id   BIGINT          NOT NULL,
    task_no             VARCHAR(64)     NOT NULL,
    outbox_id           BIGINT,
    interface_msg_id    BIGINT,
    dead_letter_id      BIGINT,
    target_system       VARCHAR(32)     NOT NULL,
    task_type           VARCHAR(32)     NOT NULL,
    task_action         VARCHAR(32),
    task_status         VARCHAR(32)     NOT NULL,
    owner_id            BIGINT,
    sla_due_time        TIMESTAMP,
    resolved_time       TIMESTAMP,
    resolution_comment  VARCHAR(1000),
    create_by           VARCHAR(64),
    create_time         TIMESTAMP       NOT NULL,
    update_by           VARCHAR(64),
    update_time         TIMESTAMP,
    del_flag            CHAR(1)         NOT NULL DEFAULT '0',
    remark              VARCHAR(500),
    CONSTRAINT pk_pro_integration_reconcile_task PRIMARY KEY (reconcile_task_id)
);

COMMENT ON TABLE pro_integration_reconcile_task IS '集成对账补偿任务表';
COMMENT ON COLUMN pro_integration_reconcile_task.reconcile_task_id IS '集成对账补偿任务ID';
COMMENT ON COLUMN pro_integration_reconcile_task.task_no IS '对账任务编号';
COMMENT ON COLUMN pro_integration_reconcile_task.outbox_id IS '事务外箱记录ID';
COMMENT ON COLUMN pro_integration_reconcile_task.interface_msg_id IS '接口消息ID';
COMMENT ON COLUMN pro_integration_reconcile_task.dead_letter_id IS '死信消息ID';
COMMENT ON COLUMN pro_integration_reconcile_task.target_system IS '目标系统';
COMMENT ON COLUMN pro_integration_reconcile_task.task_type IS '对账类型';
COMMENT ON COLUMN pro_integration_reconcile_task.task_action IS '对账动作';
COMMENT ON COLUMN pro_integration_reconcile_task.task_status IS '对账状态';
COMMENT ON COLUMN pro_integration_reconcile_task.owner_id IS '负责人ID';
COMMENT ON COLUMN pro_integration_reconcile_task.sla_due_time IS 'SLA到期时间';
COMMENT ON COLUMN pro_integration_reconcile_task.resolved_time IS '解决时间';
COMMENT ON COLUMN pro_integration_reconcile_task.resolution_comment IS '解决说明';
COMMENT ON COLUMN pro_integration_reconcile_task.create_by IS '创建人';
COMMENT ON COLUMN pro_integration_reconcile_task.create_time IS '创建时间';
COMMENT ON COLUMN pro_integration_reconcile_task.update_by IS '更新人';
COMMENT ON COLUMN pro_integration_reconcile_task.update_time IS '更新时间';
COMMENT ON COLUMN pro_integration_reconcile_task.del_flag IS '逻辑删除标识';
COMMENT ON COLUMN pro_integration_reconcile_task.remark IS '备注';

CREATE UNIQUE INDEX uk_pro_integration_reconcile_task_no ON pro_integration_reconcile_task(task_no);
CREATE INDEX idx_pro_integration_reconcile_task_outbox ON pro_integration_reconcile_task(outbox_id);
CREATE INDEX idx_pro_integration_reconcile_task_status ON pro_integration_reconcile_task(task_status);
CREATE INDEX idx_pro_integration_reconcile_task_target ON pro_integration_reconcile_task(target_system);
CREATE INDEX idx_pro_integration_reconcile_task_owner ON pro_integration_reconcile_task(owner_id);

-- ============================================================================
-- 5. pro_idempotency_request - 幂等请求记录表
-- 用途：防止弱网络下重复投料、重复报工、重复签名
-- ============================================================================
CREATE TABLE pro_idempotency_request (
    idempotency_id      BIGINT          NOT NULL,
    idempotency_key     VARCHAR(128)    NOT NULL,
    source_terminal     VARCHAR(128),
    operator_id         BIGINT,
    biz_type            VARCHAR(64)     NOT NULL,
    biz_id              BIGINT,
    request_hash        VARCHAR(128)    NOT NULL,
    process_status      VARCHAR(32)     NOT NULL,
    response_snapshot   JSONB,
    expire_time         TIMESTAMP       NOT NULL,
    archive_flag        CHAR(1)         NOT NULL DEFAULT '0',
    create_by           VARCHAR(64),
    create_time         TIMESTAMP       NOT NULL,
    update_by           VARCHAR(64),
    update_time         TIMESTAMP,
    del_flag            CHAR(1)         NOT NULL DEFAULT '0',
    remark              VARCHAR(500),
    CONSTRAINT pk_pro_idempotency_request PRIMARY KEY (idempotency_id)
);

COMMENT ON TABLE pro_idempotency_request IS '幂等请求记录表';
COMMENT ON COLUMN pro_idempotency_request.idempotency_id IS '幂等请求记录ID';
COMMENT ON COLUMN pro_idempotency_request.idempotency_key IS '幂等键';
COMMENT ON COLUMN pro_idempotency_request.source_terminal IS '来源终端';
COMMENT ON COLUMN pro_idempotency_request.operator_id IS '操作人ID';
COMMENT ON COLUMN pro_idempotency_request.biz_type IS '业务类型';
COMMENT ON COLUMN pro_idempotency_request.biz_id IS '业务ID';
COMMENT ON COLUMN pro_idempotency_request.request_hash IS '请求内容哈希';
COMMENT ON COLUMN pro_idempotency_request.process_status IS '处理状态';
COMMENT ON COLUMN pro_idempotency_request.response_snapshot IS '响应快照';
COMMENT ON COLUMN pro_idempotency_request.expire_time IS '过期时间';
COMMENT ON COLUMN pro_idempotency_request.archive_flag IS '是否已归档';
COMMENT ON COLUMN pro_idempotency_request.create_by IS '创建人';
COMMENT ON COLUMN pro_idempotency_request.create_time IS '创建时间';
COMMENT ON COLUMN pro_idempotency_request.update_by IS '更新人';
COMMENT ON COLUMN pro_idempotency_request.update_time IS '更新时间';
COMMENT ON COLUMN pro_idempotency_request.del_flag IS '逻辑删除标识';
COMMENT ON COLUMN pro_idempotency_request.remark IS '备注';

CREATE UNIQUE INDEX uk_pro_idempotency_request_key ON pro_idempotency_request(idempotency_key, biz_type);
CREATE INDEX idx_pro_idempotency_request_biz ON pro_idempotency_request(biz_type, biz_id);
CREATE INDEX idx_pro_idempotency_request_expire ON pro_idempotency_request(expire_time);
CREATE INDEX idx_pro_idempotency_request_status ON pro_idempotency_request(process_status);

-- ============================================================================
-- 6. pro_dead_letter_message - 死信消息表
-- 用途：隔离多次重试失败的接口消息/设备事件，避免阻塞主流程
-- ============================================================================
CREATE TABLE pro_dead_letter_message (
    dead_letter_id      BIGINT          NOT NULL,
    source_table        VARCHAR(128),
    source_id           BIGINT,
    message_type        VARCHAR(64)     NOT NULL,
    target_system       VARCHAR(32),
    payload             JSONB,
    failure_count       INTEGER         NOT NULL DEFAULT 0,
    last_fail_time      TIMESTAMP,
    last_error_message  VARCHAR(1000),
    process_status      VARCHAR(32)     NOT NULL,
    owner_id            BIGINT,
    sla_due_time        TIMESTAMP,
    resolved_time       TIMESTAMP,
    reconcile_task_id   BIGINT,
    create_by           VARCHAR(64),
    create_time         TIMESTAMP       NOT NULL,
    update_by           VARCHAR(64),
    update_time         TIMESTAMP,
    del_flag            CHAR(1)         NOT NULL DEFAULT '0',
    remark              VARCHAR(500),
    CONSTRAINT pk_pro_dead_letter_message PRIMARY KEY (dead_letter_id)
);

COMMENT ON TABLE pro_dead_letter_message IS '死信消息表';
COMMENT ON COLUMN pro_dead_letter_message.dead_letter_id IS '死信消息ID';
COMMENT ON COLUMN pro_dead_letter_message.source_table IS '来源表名';
COMMENT ON COLUMN pro_dead_letter_message.source_id IS '来源业务ID';
COMMENT ON COLUMN pro_dead_letter_message.message_type IS '消息类型';
COMMENT ON COLUMN pro_dead_letter_message.target_system IS '目标系统';
COMMENT ON COLUMN pro_dead_letter_message.payload IS '消息载荷';
COMMENT ON COLUMN pro_dead_letter_message.failure_count IS '失败次数';
COMMENT ON COLUMN pro_dead_letter_message.last_fail_time IS '最后失败时间';
COMMENT ON COLUMN pro_dead_letter_message.last_error_message IS '最后错误信息';
COMMENT ON COLUMN pro_dead_letter_message.process_status IS '处理状态';
COMMENT ON COLUMN pro_dead_letter_message.owner_id IS '负责人ID';
COMMENT ON COLUMN pro_dead_letter_message.sla_due_time IS 'SLA到期时间';
COMMENT ON COLUMN pro_dead_letter_message.resolved_time IS '解决时间';
COMMENT ON COLUMN pro_dead_letter_message.reconcile_task_id IS '补偿任务ID';
COMMENT ON COLUMN pro_dead_letter_message.create_by IS '创建人';
COMMENT ON COLUMN pro_dead_letter_message.create_time IS '创建时间';
COMMENT ON COLUMN pro_dead_letter_message.update_by IS '更新人';
COMMENT ON COLUMN pro_dead_letter_message.update_time IS '更新时间';
COMMENT ON COLUMN pro_dead_letter_message.del_flag IS '逻辑删除标识';
COMMENT ON COLUMN pro_dead_letter_message.remark IS '备注';

CREATE INDEX idx_pro_dead_letter_message_status ON pro_dead_letter_message(process_status);
CREATE INDEX idx_pro_dead_letter_message_type ON pro_dead_letter_message(message_type);
CREATE INDEX idx_pro_dead_letter_message_target ON pro_dead_letter_message(target_system);
CREATE INDEX idx_pro_dead_letter_message_owner ON pro_dead_letter_message(owner_id);
CREATE INDEX idx_pro_dead_letter_message_reconcile ON pro_dead_letter_message(reconcile_task_id);

-- ============================================================================
-- 外键约束（建议在业务表创建后补充，此处仅声明引用关系）
-- pro_mbr_execution_context.prod_order_id → pro_production_order.prod_order_id
-- pro_mbr_execution_context.mbr_version_id → pro_mbr_version.mbr_version_id
-- pro_mbr_execution_context.ebr_id → pro_ebr_header.ebr_id
-- pro_mbr_execution_context.previous_context_id → pro_mbr_execution_context.context_id
-- pro_mbr_execution_context.source_ecn_id → pro_ecn_order.ecn_id
-- pro_mbr_execution_context.current_step_id → pro_mbr_step.step_id
-- pro_mbr_context_refresh_log.old_context_id → pro_mbr_execution_context.context_id
-- pro_mbr_context_refresh_log.new_context_id → pro_mbr_execution_context.context_id
-- pro_mbr_context_refresh_log.source_ecn_id → pro_ecn_order.ecn_id
-- pro_mbr_context_refresh_log.operator_id → pro_person_master.person_id
-- pro_mbr_context_refresh_log.signature_id → pro_e_signature_record.signature_id
-- pro_mbr_context_refresh_log.audit_trail_id → pro_audit_trail.audit_trail_id
-- pro_transactional_outbox.dead_letter_id → pro_dead_letter_message.dead_letter_id
-- pro_integration_reconcile_task.outbox_id → pro_transactional_outbox.outbox_id
-- pro_integration_reconcile_task.interface_msg_id → pro_interface_message.interface_msg_id
-- pro_integration_reconcile_task.dead_letter_id → pro_dead_letter_message.dead_letter_id
-- pro_integration_reconcile_task.owner_id → pro_person_master.person_id
-- pro_idempotency_request.operator_id → pro_person_master.person_id
-- pro_dead_letter_message.owner_id → pro_person_master.person_id
-- pro_dead_letter_message.reconcile_task_id → pro_integration_reconcile_task.reconcile_task_id
-- ============================================================================
