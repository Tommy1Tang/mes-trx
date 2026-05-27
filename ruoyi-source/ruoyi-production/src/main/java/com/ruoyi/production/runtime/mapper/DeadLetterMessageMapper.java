package com.ruoyi.production.runtime.mapper;

import java.util.List;
import com.ruoyi.production.runtime.domain.DeadLetterMessage;

/**
 * 死信消息Mapper接口
 */
public interface DeadLetterMessageMapper
{
    public DeadLetterMessage selectDeadLetterMessageByDeadLetterId(Long deadLetterId);
    public List<DeadLetterMessage> selectDeadLetterMessageList(DeadLetterMessage deadLetterMessage);
    public int insertDeadLetterMessage(DeadLetterMessage deadLetterMessage);
    public int updateDeadLetterMessage(DeadLetterMessage deadLetterMessage);
    public int deleteDeadLetterMessageByDeadLetterIds(Long[] deadLetterIds);
}