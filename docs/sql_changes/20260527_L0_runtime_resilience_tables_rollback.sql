-- ============================================================================
-- L0 运行时韧性与架构支撑层 DDL 回滚脚本
-- 生成日期：2026-05-27
-- 说明：按依赖关系逆序删除
-- ============================================================================

DROP TABLE IF EXISTS pro_dead_letter_message CASCADE;
DROP TABLE IF EXISTS pro_idempotency_request CASCADE;
DROP TABLE IF EXISTS pro_integration_reconcile_task CASCADE;
DROP TABLE IF EXISTS pro_transactional_outbox CASCADE;
DROP TABLE IF EXISTS pro_mbr_context_refresh_log CASCADE;
DROP TABLE IF EXISTS pro_mbr_execution_context CASCADE;
