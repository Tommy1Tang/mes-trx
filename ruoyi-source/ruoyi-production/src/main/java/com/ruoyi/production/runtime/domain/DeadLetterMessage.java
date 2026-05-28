package com.ruoyi.production.runtime.domain;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * 死信消息对象 pro_dead_letter_message
 */
public class DeadLetterMessage extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    @Excel(name = "死信消息ID")
    private Long deadLetterId;

    @Excel(name = "来源表名")
    private String sourceTable;

    @Excel(name = "来源业务ID")
    private Long sourceId;

    @Excel(name = "消息类型")
    private String messageType;

    @Excel(name = "目标系统")
    private String targetSystem;

    @Excel(name = "消息载荷")
    private String payload;

    @Excel(name = "失败次数")
    private Integer failureCount;

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @Excel(name = "最后失败时间")
    private Date lastFailTime;

    @Excel(name = "最后错误信息")
    private String lastErrorMessage;

    @Excel(name = "处理状态")
    private String processStatus;

    @Excel(name = "负责人ID")
    private Long ownerId;

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @Excel(name = "SLA到期时间")
    private Date slaDueTime;

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @Excel(name = "解决时间")
    private Date resolvedTime;

    @Excel(name = "补偿任务ID")
    private Long reconcileTaskId;

    /** 删除标志 */
    private String delFlag;

    public Long getDeadLetterId()
    {
        return deadLetterId;
    }

    public void setDeadLetterId(Long deadLetterId)
    {
        this.deadLetterId = deadLetterId;
    }

    public String getSourceTable()
    {
        return sourceTable;
    }

    public void setSourceTable(String sourceTable)
    {
        this.sourceTable = sourceTable;
    }

    public Long getSourceId()
    {
        return sourceId;
    }

    public void setSourceId(Long sourceId)
    {
        this.sourceId = sourceId;
    }

    public String getMessageType()
    {
        return messageType;
    }

    public void setMessageType(String messageType)
    {
        this.messageType = messageType;
    }

    public String getTargetSystem()
    {
        return targetSystem;
    }

    public void setTargetSystem(String targetSystem)
    {
        this.targetSystem = targetSystem;
    }

    public String getPayload()
    {
        return payload;
    }

    public void setPayload(String payload)
    {
        this.payload = payload;
    }

    public Integer getFailureCount()
    {
        return failureCount;
    }

    public void setFailureCount(Integer failureCount)
    {
        this.failureCount = failureCount;
    }

    public Date getLastFailTime()
    {
        return lastFailTime;
    }

    public void setLastFailTime(Date lastFailTime)
    {
        this.lastFailTime = lastFailTime;
    }

    public String getLastErrorMessage()
    {
        return lastErrorMessage;
    }

    public void setLastErrorMessage(String lastErrorMessage)
    {
        this.lastErrorMessage = lastErrorMessage;
    }

    public String getProcessStatus()
    {
        return processStatus;
    }

    public void setProcessStatus(String processStatus)
    {
        this.processStatus = processStatus;
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

    public Long getReconcileTaskId()
    {
        return reconcileTaskId;
    }

    public void setReconcileTaskId(Long reconcileTaskId)
    {
        this.reconcileTaskId = reconcileTaskId;
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