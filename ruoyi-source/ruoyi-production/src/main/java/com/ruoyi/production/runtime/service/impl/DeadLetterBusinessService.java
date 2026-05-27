package com.ruoyi.production.runtime.service.impl;

import java.util.Date;
import java.util.List;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.production.runtime.domain.DeadLetterMessage;
import com.ruoyi.production.runtime.domain.IntegrationReconcileTask;
import com.ruoyi.production.runtime.mapper.DeadLetterMessageMapper;
import com.ruoyi.production.runtime.service.IIntegrationReconcileTaskService;

/**
 * 死信消息业务组件
 * 负责死信处理、重试和补偿任务创建
 */
@Service
public class DeadLetterBusinessService
{
    private static final Logger log = LoggerFactory.getLogger(DeadLetterBusinessService.class);

    @Autowired
    private DeadLetterMessageMapper deadLetterMapper;

    @Autowired
    private IIntegrationReconcileTaskService reconcileService;

    /**
     * 重试死信消息
     * 将死信消息重新投入外箱进行发送
     */
    public int retryDeadLetter(Long deadLetterId)
    {
        DeadLetterMessage deadLetter = deadLetterMapper.selectDeadLetterMessageByDeadLetterId(deadLetterId);
        if (deadLetter == null)
        {
            return 0;
        }
        deadLetter.setProcessStatus("RETRYING");
        deadLetter.setUpdateBy(SecurityUtils.getUsername());
        int rows = deadLetterMapper.updateDeadLetterMessage(deadLetter);
        log.info("Dead letter retry initiated: id={}", deadLetterId);
        return rows;
    }

    /**
     * 人工解决死信消息
     */
    public int resolveDeadLetter(Long deadLetterId, String resolutionComment)
    {
        DeadLetterMessage deadLetter = deadLetterMapper.selectDeadLetterMessageByDeadLetterId(deadLetterId);
        if (deadLetter == null)
        {
            return 0;
        }
        deadLetter.setProcessStatus("RESOLVED");
        deadLetter.setResolvedTime(new Date());
        deadLetter.setRemark(resolutionComment);
        deadLetter.setUpdateBy(SecurityUtils.getUsername());
        return deadLetterMapper.updateDeadLetterMessage(deadLetter);
    }

    /**
     * 为死信消息创建对账补偿任务
     */
    public IntegrationReconcileTask createReconcileTask(Long deadLetterId)
    {
        DeadLetterMessage deadLetter = deadLetterMapper.selectDeadLetterMessageByDeadLetterId(deadLetterId);
        if (deadLetter == null)
        {
            return null;
        }

        IntegrationReconcileTask task = new IntegrationReconcileTask();
        task.setTaskNo("RC-" + System.currentTimeMillis());
        task.setDeadLetterId(deadLetterId);
        task.setTargetSystem(deadLetter.getTargetSystem());
        task.setTaskType("DEAD_LETTER_RETRY");
        task.setTaskAction("RESEND");
        task.setTaskStatus("OPEN");
        task.setOwnerId(deadLetter.getOwnerId());
        task.setCreateBy(SecurityUtils.getUsername());
        reconcileService.insertIntegrationReconcileTask(task);

        // 关联死信消息
        deadLetter.setReconcileTaskId(task.getReconcileTaskId());
        deadLetter.setUpdateBy(SecurityUtils.getUsername());
        deadLetterMapper.updateDeadLetterMessage(deadLetter);

        log.info("Reconcile task created for dead letter: deadLetterId={}, taskId={}", deadLetterId, task.getReconcileTaskId());
        return task;
    }
}
