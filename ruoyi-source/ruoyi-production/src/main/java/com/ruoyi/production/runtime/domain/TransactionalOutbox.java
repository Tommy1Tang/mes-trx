package com.ruoyi.production.runtime.domain;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * 事务外箱事件对象 pro_transactional_outbox
 */
public class TransactionalOutbox extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    @Excel(name = "事务外箱记录ID")
    private Long outboxId;

    @Excel(name = "事件类型")
    private String eventType;

    @Excel(name = "业务表名")
    private String bizTable;

    @Excel(name = "业务ID")
    private Long bizId;

    @Excel(name = "目标系统")
    private String targetSystem;

    @Excel(name = "事件载荷")
    private String payload;

    @Excel(name = "幂等键")
    private String idempotencyKey;

    @Excel(name = "分区键")
    private String partitionKey;

    @Excel(name = "事件版本")
    private String eventVersion;

    @Excel(name = "链路追踪ID")
    private String traceId;

    @Excel(name = "发布模式")
    private String publishMode;

    @Excel(name = "CDC是否已发布")
    private String cdcPublishedFlag;

    @Excel(name = "事件状态")
    private String eventStatus;

    @Excel(name = "重试次数")
    private Integer retryCount;

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @Excel(name = "下次重试时间")
    private Date nextRetryTime;

    @Excel(name = "死信消息ID")
    private Long deadLetterId;

    @Excel(name = "最后错误信息")
    private String lastErrorMessage;

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @Excel(name = "发送时间")
    private Date sentTime;

    public Long getOutboxId()
    {
        return outboxId;
    }

    public void setOutboxId(Long outboxId)
    {
        this.outboxId = outboxId;
    }

    public String getEventType()
    {
        return eventType;
    }

    public void setEventType(String eventType)
    {
        this.eventType = eventType;
    }

    public String getBizTable()
    {
        return bizTable;
    }

    public void setBizTable(String bizTable)
    {
        this.bizTable = bizTable;
    }

    public Long getBizId()
    {
        return bizId;
    }

    public void setBizId(Long bizId)
    {
        this.bizId = bizId;
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

    public String getIdempotencyKey()
    {
        return idempotencyKey;
    }

    public void setIdempotencyKey(String idempotencyKey)
    {
        this.idempotencyKey = idempotencyKey;
    }

    public String getPartitionKey()
    {
        return partitionKey;
    }

    public void setPartitionKey(String partitionKey)
    {
        this.partitionKey = partitionKey;
    }

    public String getEventVersion()
    {
        return eventVersion;
    }

    public void setEventVersion(String eventVersion)
    {
        this.eventVersion = eventVersion;
    }

    public String getTraceId()
    {
        return traceId;
    }

    public void setTraceId(String traceId)
    {
        this.traceId = traceId;
    }

    public String getPublishMode()
    {
        return publishMode;
    }

    public void setPublishMode(String publishMode)
    {
        this.publishMode = publishMode;
    }

    public String getCdcPublishedFlag()
    {
        return cdcPublishedFlag;
    }

    public void setCdcPublishedFlag(String cdcPublishedFlag)
    {
        this.cdcPublishedFlag = cdcPublishedFlag;
    }

    public String getEventStatus()
    {
        return eventStatus;
    }

    public void setEventStatus(String eventStatus)
    {
        this.eventStatus = eventStatus;
    }

    public Integer getRetryCount()
    {
        return retryCount;
    }

    public void setRetryCount(Integer retryCount)
    {
        this.retryCount = retryCount;
    }

    public Date getNextRetryTime()
    {
        return nextRetryTime;
    }

    public void setNextRetryTime(Date nextRetryTime)
    {
        this.nextRetryTime = nextRetryTime;
    }

    public Long getDeadLetterId()
    {
        return deadLetterId;
    }

    public void setDeadLetterId(Long deadLetterId)
    {
        this.deadLetterId = deadLetterId;
    }

    public String getLastErrorMessage()
    {
        return lastErrorMessage;
    }

    public void setLastErrorMessage(String lastErrorMessage)
    {
        this.lastErrorMessage = lastErrorMessage;
    }

    public Date getSentTime()
    {
        return sentTime;
    }

    public void setSentTime(Date sentTime)
    {
        this.sentTime = sentTime;
    }

}