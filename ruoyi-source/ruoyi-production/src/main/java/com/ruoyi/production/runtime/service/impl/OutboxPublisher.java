package com.ruoyi.production.runtime.service.impl;

import java.util.Date;
import java.util.List;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.production.runtime.domain.TransactionalOutbox;
import com.ruoyi.production.runtime.domain.DeadLetterMessage;
import com.ruoyi.production.runtime.mapper.TransactionalOutboxMapper;
import com.ruoyi.production.runtime.service.IDeadLetterMessageService;

/**
 * 事务外箱业务组件
 * 负责事件发布、定时重试和死信转移
 */
@Service
public class OutboxPublisher
{
    private static final Logger log = LoggerFactory.getLogger(OutboxPublisher.class);

    private static final int MAX_RETRY_COUNT = 5;
    private static final String STATUS_PENDING = "PENDING";
    private static final String STATUS_SENDING = "SENDING";
    private static final String STATUS_SENT = "SENT";
    private static final String STATUS_FAILED = "FAILED";
    private static final String STATUS_DEAD = "DEAD";

    @Autowired
    private TransactionalOutboxMapper outboxMapper;

    @Autowired
    private IDeadLetterMessageService deadLetterService;

    /**
     * 发布事件到事务外箱
     * 业务Service在同一事务中调用，保证本地事务和事件写入的原子性
     */
    @Transactional
    public void publishEvent(String eventType, String bizTable, Long bizId,
                             String targetSystem, String payload, String idempotencyKey)
    {
        TransactionalOutbox outbox = new TransactionalOutbox();
        outbox.setEventType(eventType);
        outbox.setBizTable(bizTable);
        outbox.setBizId(bizId);
        outbox.setTargetSystem(targetSystem);
        outbox.setPayload(payload);
        outbox.setIdempotencyKey(idempotencyKey);
        outbox.setPublishMode("ASYNC");
        outbox.setEventStatus(STATUS_PENDING);
        outbox.setRetryCount(0);
        outbox.setCdcPublishedFlag("0");
        outbox.setCreateBy(SecurityUtils.getUsername());
        outboxMapper.insertTransactionalOutbox(outbox);
        log.info("Event published to outbox: type={}, biz={}:{}", eventType, bizTable, bizId);
    }

    /**
     * 定时任务：扫描待发送事件并重试
     * 每30秒执行一次
     */
    @Scheduled(fixedDelay = 30000)
    public void retryPendingEvents()
    {
        TransactionalOutbox query = new TransactionalOutbox();
        query.setEventStatus(STATUS_PENDING);
        List<TransactionalOutbox> pendingList = outboxMapper.selectTransactionalOutboxList(query);

        for (TransactionalOutbox outbox : pendingList)
        {
            try
            {
                outbox.setEventStatus(STATUS_SENDING);
                outbox.setUpdateBy("SYSTEM");
                outboxMapper.updateTransactionalOutbox(outbox);

                // 调用外部系统推送（具体实现在集成层）
                boolean sent = sendToTargetSystem(outbox);

                if (sent)
                {
                    outbox.setEventStatus(STATUS_SENT);
                    outbox.setSentTime(new Date());
                }
                else
                {
                    handleRetryFailure(outbox);
                }
                outbox.setUpdateBy("SYSTEM");
                outboxMapper.updateTransactionalOutbox(outbox);
            }
            catch (Exception e)
            {
                log.error("Outbox send failed: id={}, error={}", outbox.getOutboxId(), e.getMessage());
                handleRetryFailure(outbox);
                outbox.setLastErrorMessage(e.getMessage());
                outbox.setUpdateBy("SYSTEM");
                outboxMapper.updateTransactionalOutbox(outbox);
            }
        }
    }

    private void handleRetryFailure(TransactionalOutbox outbox)
    {
        int retryCount = outbox.getRetryCount() + 1;
        outbox.setRetryCount(retryCount);
        if (retryCount >= MAX_RETRY_COUNT)
        {
            // 转入死信
            DeadLetterMessage deadLetter = new DeadLetterMessage();
            deadLetter.setSourceTable("pro_transactional_outbox");
            deadLetter.setSourceId(outbox.getOutboxId());
            deadLetter.setMessageType(outbox.getEventType());
            deadLetter.setTargetSystem(outbox.getTargetSystem());
            deadLetter.setPayload(outbox.getPayload());
            deadLetter.setFailureCount(retryCount);
            deadLetter.setLastFailTime(new Date());
            deadLetter.setLastErrorMessage(outbox.getLastErrorMessage());
            deadLetter.setProcessStatus("OPEN");
            deadLetter.setCreateBy("SYSTEM");
            deadLetterService.insertDeadLetterMessage(deadLetter);

            outbox.setEventStatus(STATUS_DEAD);
            outbox.setDeadLetterId(deadLetter.getDeadLetterId());
            log.warn("Outbox event moved to dead letter: outboxId={}", outbox.getOutboxId());
        }
        else
        {
            outbox.setEventStatus(STATUS_PENDING);
            // 指数退避：下次重试时间 = 当前时间 + 2^retryCount * 10秒
            long delay = (long) Math.pow(2, retryCount) * 10000;
            outbox.setNextRetryTime(new Date(System.currentTimeMillis() + delay));
        }
    }

    /**
     * 推送到目标系统（具体实现由集成层覆盖）
     * 默认返回false，由具体的SAP/WMS/PLM集成实现覆盖
     */
    protected boolean sendToTargetSystem(TransactionalOutbox outbox)
    {
        log.debug("Default sendToTargetSystem called for: target={}, event={}", outbox.getTargetSystem(), outbox.getEventType());
        return false;
    }
}
