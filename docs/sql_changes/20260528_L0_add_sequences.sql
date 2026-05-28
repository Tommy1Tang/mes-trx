-- L0 Runtime Resilience: 为6张表添加序列和默认值
-- 执行前请确认表已存在

-- 1. pro_transactional_outbox
CREATE SEQUENCE IF NOT EXISTS pro_transactional_outbox_outbox_id_seq;
ALTER TABLE pro_transactional_outbox ALTER COLUMN outbox_id SET DEFAULT nextval('pro_transactional_outbox_outbox_id_seq');
SELECT setval('pro_transactional_outbox_outbox_id_seq', COALESCE((SELECT MAX(outbox_id) FROM pro_transactional_outbox), 0) + 1, false);

-- 2. pro_dead_letter_message
CREATE SEQUENCE IF NOT EXISTS pro_dead_letter_message_dead_letter_id_seq;
ALTER TABLE pro_dead_letter_message ALTER COLUMN dead_letter_id SET DEFAULT nextval('pro_dead_letter_message_dead_letter_id_seq');
SELECT setval('pro_dead_letter_message_dead_letter_id_seq', COALESCE((SELECT MAX(dead_letter_id) FROM pro_dead_letter_message), 0) + 1, false);

-- 3. pro_integration_reconcile_task
CREATE SEQUENCE IF NOT EXISTS pro_integration_reconcile_task_reconcile_task_id_seq;
ALTER TABLE pro_integration_reconcile_task ALTER COLUMN reconcile_task_id SET DEFAULT nextval('pro_integration_reconcile_task_reconcile_task_id_seq');
SELECT setval('pro_integration_reconcile_task_reconcile_task_id_seq', COALESCE((SELECT MAX(reconcile_task_id) FROM pro_integration_reconcile_task), 0) + 1, false);

-- 4. pro_mbr_execution_context
CREATE SEQUENCE IF NOT EXISTS pro_mbr_execution_context_context_id_seq;
ALTER TABLE pro_mbr_execution_context ALTER COLUMN context_id SET DEFAULT nextval('pro_mbr_execution_context_context_id_seq');
SELECT setval('pro_mbr_execution_context_context_id_seq', COALESCE((SELECT MAX(context_id) FROM pro_mbr_execution_context), 0) + 1, false);

-- 5. pro_mbr_context_refresh_log
CREATE SEQUENCE IF NOT EXISTS pro_mbr_context_refresh_log_refresh_log_id_seq;
ALTER TABLE pro_mbr_context_refresh_log ALTER COLUMN refresh_log_id SET DEFAULT nextval('pro_mbr_context_refresh_log_refresh_log_id_seq');
SELECT setval('pro_mbr_context_refresh_log_refresh_log_id_seq', COALESCE((SELECT MAX(refresh_log_id) FROM pro_mbr_context_refresh_log), 0) + 1, false);

-- 6. pro_idempotency_request
CREATE SEQUENCE IF NOT EXISTS pro_idempotency_request_request_id_seq;
ALTER TABLE pro_idempotency_request ALTER COLUMN request_id SET DEFAULT nextval('pro_idempotency_request_request_id_seq');
SELECT setval('pro_idempotency_request_request_id_seq', COALESCE((SELECT MAX(request_id) FROM pro_idempotency_request), 0) + 1, false);
