package com.ruoyi.production.runtime.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.production.runtime.mapper.TransactionalOutboxMapper;
import com.ruoyi.production.runtime.domain.TransactionalOutbox;
import com.ruoyi.production.runtime.service.ITransactionalOutboxService;

/**
 * 事务外箱事件Service实现
 */
@Service
public class TransactionalOutboxServiceImpl implements ITransactionalOutboxService
{
    @Autowired
    private TransactionalOutboxMapper transactionalOutboxMapper;

    @Override
    public TransactionalOutbox selectTransactionalOutboxByOutboxId(Long outboxId)
    {
        return transactionalOutboxMapper.selectTransactionalOutboxByOutboxId(outboxId);
    }

    @Override
    public List<TransactionalOutbox> selectTransactionalOutboxList(TransactionalOutbox transactionalOutbox)
    {
        return transactionalOutboxMapper.selectTransactionalOutboxList(transactionalOutbox);
    }

    @Override
    public int insertTransactionalOutbox(TransactionalOutbox transactionalOutbox)
    {
        return transactionalOutboxMapper.insertTransactionalOutbox(transactionalOutbox);
    }

    @Override
    public int updateTransactionalOutbox(TransactionalOutbox transactionalOutbox)
    {
        return transactionalOutboxMapper.updateTransactionalOutbox(transactionalOutbox);
    }

    @Override
    public int deleteTransactionalOutboxByOutboxIds(Long[] outboxIds)
    {
        return transactionalOutboxMapper.deleteTransactionalOutboxByOutboxIds(outboxIds);
    }
}