package com.ruoyi.production.runtime.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.production.runtime.mapper.DeadLetterMessageMapper;
import com.ruoyi.production.runtime.domain.DeadLetterMessage;
import com.ruoyi.production.runtime.service.IDeadLetterMessageService;

/**
 * 死信消息Service实现
 */
@Service
public class DeadLetterMessageServiceImpl implements IDeadLetterMessageService
{
    @Autowired
    private DeadLetterMessageMapper deadLetterMessageMapper;

    @Override
    public DeadLetterMessage selectDeadLetterMessageByDeadLetterId(Long deadLetterId)
    {
        return deadLetterMessageMapper.selectDeadLetterMessageByDeadLetterId(deadLetterId);
    }

    @Override
    public List<DeadLetterMessage> selectDeadLetterMessageList(DeadLetterMessage deadLetterMessage)
    {
        return deadLetterMessageMapper.selectDeadLetterMessageList(deadLetterMessage);
    }

    @Override
    public int insertDeadLetterMessage(DeadLetterMessage deadLetterMessage)
    {
        return deadLetterMessageMapper.insertDeadLetterMessage(deadLetterMessage);
    }

    @Override
    public int updateDeadLetterMessage(DeadLetterMessage deadLetterMessage)
    {
        return deadLetterMessageMapper.updateDeadLetterMessage(deadLetterMessage);
    }

    @Override
    public int deleteDeadLetterMessageByDeadLetterIds(Long[] deadLetterIds)
    {
        return deadLetterMessageMapper.deleteDeadLetterMessageByDeadLetterIds(deadLetterIds);
    }
}