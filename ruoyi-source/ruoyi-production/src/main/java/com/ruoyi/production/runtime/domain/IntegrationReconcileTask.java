package com.ruoyi.production.runtime.domain;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * 集成对账补偿任务对象 pro_integration_reconcile_task
 */
public class IntegrationReconcileTask extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    @Excel(name = "对账补偿任务ID")
    private Long reconcileTaskId;

    @Excel(name = "对账任务编号")
    private String taskNo;

    @Excel(name = "事务外箱记录ID")
    private Long outboxId;

    @Excel(name = "接口消息ID")
    private Long interfaceMsgId;

    @Excel(name = "死信消息ID")
    private Long deadLetterId;

    @Excel(name = "目标系统")
    private String targetSystem;

    @Excel(name = "对账类型")
    private String taskType;

    @Excel(name = "对账动作")
    private String taskAction;

    @Excel(name = "对账状态")
    private String taskStatus;

    @Excel(name = "负责人ID")
    private Long ownerId;

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @Excel(name = "SLA到期时间")
    private Date slaDueTime;

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @Excel(name = "解决时间")
    private Date resolvedTime;

    @Excel(name = "解决说明")
    private String resolutionComment;

    private String delFlag;

    public Long getReconcileTaskId()
    {
        return reconcileTaskId;
    }

    public void setReconcileTaskId(Long reconcileTaskId)
    {
        this.reconcileTaskId = reconcileTaskId;
    }

    public String getTaskNo()
    {
        return taskNo;
    }

    public void setTaskNo(String taskNo)
    {
        this.taskNo = taskNo;
    }

    public Long getOutboxId()
    {
        return outboxId;
    }

    public void setOutboxId(Long outboxId)
    {
        this.outboxId = outboxId;
    }

    public Long getInterfaceMsgId()
    {
        return interfaceMsgId;
    }

    public void setInterfaceMsgId(Long interfaceMsgId)
    {
        this.interfaceMsgId = interfaceMsgId;
    }

    public Long getDeadLetterId()
    {
        return deadLetterId;
    }

    public void setDeadLetterId(Long deadLetterId)
    {
        this.deadLetterId = deadLetterId;
    }

    public String getTargetSystem()
    {
        return targetSystem;
    }

    public void setTargetSystem(String targetSystem)
    {
        this.targetSystem = targetSystem;
    }

    public String getTaskType()
    {
        return taskType;
    }

    public void setTaskType(String taskType)
    {
        this.taskType = taskType;
    }

    public String getTaskAction()
    {
        return taskAction;
    }

    public void setTaskAction(String taskAction)
    {
        this.taskAction = taskAction;
    }

    public String getTaskStatus()
    {
        return taskStatus;
    }

    public void setTaskStatus(String taskStatus)
    {
        this.taskStatus = taskStatus;
    }

    public Long getOwnerId()
    {
        return ownerId;
    }

    public void setOwnerId(Long ownerId)
    {
        this.ownerId = ownerId;
    }

    public Date getSlaDueTime()
    {
        return slaDueTime;
    }

    public void setSlaDueTime(Date slaDueTime)
    {
        this.slaDueTime = slaDueTime;
    }

    public Date getResolvedTime()
    {
        return resolvedTime;
    }

    public void setResolvedTime(Date resolvedTime)
    {
        this.resolvedTime = resolvedTime;
    }

    public String getResolutionComment()
    {
        return resolutionComment;
    }

    public void setResolutionComment(String resolutionComment)
    {
        this.resolutionComment = resolutionComment;
    }

    public String getDelFlag()
    {
        return delFlag;
    }

    public void setDelFlag(String delFlag)
    {
        this.delFlag = delFlag;
    }

}