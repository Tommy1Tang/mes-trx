package com.ruoyi.production.runtime.service.impl;

import java.util.Date;
import java.util.List;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import com.ruoyi.production.runtime.domain.TransactionalOutbox;
import com.ruoyi.production.runtime.domain.IntegrationReconcileTask;
import com.ruoyi.production.runtime.mapper.TransactionalOutboxMapper;
import com.ruoyi.production.runtime.service.IIntegrationReconcileTaskService;

/**
 * 集成对账调度器
 * 定期扫描外箱中sending状态超时的事件，创建对账补偿任务
 */
@Service
public class ReconciliationScheduler
{
    private static final Logger log = LoggerFactory.getLogger(ReconciliationScheduler.class);

    /** sending状态超时阈值：5分钟 */
    private static final long SENDING_TIMEOUT_MS = 5 * 60 * 1000;

    @Autowired
    private TransactionalOutboxMapper outboxMapper;

    @Autowired
    private IIntegrationReconcileTaskService reconcileService;

    /**
     * 每5分钟扫描一次sending超时的事件
     */
    @Scheduled(fixedDelay = 300000)
    public void scanSendingTimeout()
    {
        TransactionalOutbox query = new TransactionalOutbox();
        query.setEventStatus("SENDING");
        List<TransactionalOutbox> sendingList = outboxMapper.selectTransactionalOutboxList(query);

        long now = System.currentTimeMillis();
        for (TransactionalOutbox outbox : sendingList)
        {
            if (outbox.getUpdateTime() != null && (now - outbox.getUpdateTime().getTime()) > SENDING_TIMEOUT_MS)
            {
                // 超时，创建对账任务
                IntegrationReconcileTask task = new IntegrationReconcileTask();
                task.setTaskNo("RC-TIMEOUT-" + System.currentTimeMillis());
                task.setOutboxId(outbox.getOutboxId());
                task.setTargetSystem(outbox.getTargetSystem());
                task.setTaskType("SEND_TIMEOUT");
                task.setTaskAction("RESEND");
                task.setTaskStatus("OPEN");
                task.setCreateBy("SYSTEM");
                reconcileService.insertIntegrationReconcileTask(task);

                // 将外箱事件重置为PENDING
                outbox.setEventStatus("PENDING");
                outbox.setUpdateBy("SYSTEM");
                outboxMapper.updateTransactionalOutbox(outbox);

                log.warn("Sending timeout detected, reconcile task created: outboxId={}, taskId={}",
                         outbox.getOutboxId(), task.getReconcileTaskId());
            }
        }
    }
}
