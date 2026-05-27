package com.ruoyi.production.runtime.mapper;

import java.util.List;
import com.ruoyi.production.runtime.domain.TransactionalOutbox;

/**
 * 事务外箱事件Mapper接口
 */
public interface TransactionalOutboxMapper
{
    public TransactionalOutbox selectTransactionalOutboxByOutboxId(Long outboxId);
    public List<TransactionalOutbox> selectTransactionalOutboxList(TransactionalOutbox transactionalOutbox);
    public int insertTransactionalOutbox(TransactionalOutbox transactionalOutbox);
    public int updateTransactionalOutbox(TransactionalOutbox transactionalOutbox);
    public int deleteTransactionalOutboxByOutboxIds(Long[] outboxIds);
}