package com.ruoyi.production.runtime.domain;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * 幂等请求记录对象 pro_idempotency_request
 */
public class IdempotencyRequest extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    @Excel(name = "幂等请求记录ID")
    private Long idempotencyId;

    @Excel(name = "幂等键")
    private String idempotencyKey;

    @Excel(name = "来源终端")
    private String sourceTerminal;

    @Excel(name = "操作人ID")
    private Long operatorId;

    @Excel(name = "业务类型")
    private String bizType;

    @Excel(name = "业务ID")
    private Long bizId;

    @Excel(name = "请求内容哈希")
    private String requestHash;

    @Excel(name = "处理状态")
    private String processStatus;

    @Excel(name = "响应快照")
    private String responseSnapshot;

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @Excel(name = "过期时间")
    private Date expireTime;

    @Excel(name = "是否已归档")
    private String archiveFlag;

    public Long getIdempotencyId()
    {
        return idempotencyId;
    }

    public void setIdempotencyId(Long idempotencyId)
    {
        this.idempotencyId = idempotencyId;
    }

    public String getIdempotencyKey()
    {
        return idempotencyKey;
    }

    public void setIdempotencyKey(String idempotencyKey)
    {
        this.idempotencyKey = idempotencyKey;
    }

    public String getSourceTerminal()
    {
        return sourceTerminal;
    }

    public void setSourceTerminal(String sourceTerminal)
    {
        this.sourceTerminal = sourceTerminal;
    }

    public Long getOperatorId()
    {
        return operatorId;
    }

    public void setOperatorId(Long operatorId)
    {
        this.operatorId = operatorId;
    }

    public String getBizType()
    {
        return bizType;
    }

    public void setBizType(String bizType)
    {
        this.bizType = bizType;
    }

    public Long getBizId()
    {
        return bizId;
    }

    public void setBizId(Long bizId)
    {
        this.bizId = bizId;
    }

    public String getRequestHash()
    {
        return requestHash;
    }

    public void setRequestHash(String requestHash)
    {
        this.requestHash = requestHash;
    }

    public String getProcessStatus()
    {
        return processStatus;
    }

    public void setProcessStatus(String processStatus)
    {
        this.processStatus = processStatus;
    }

    public String getResponseSnapshot()
    {
        return responseSnapshot;
    }

    public void setResponseSnapshot(String responseSnapshot)
    {
        this.responseSnapshot = responseSnapshot;
    }

    public Date getExpireTime()
    {
        return expireTime;
    }

    public void setExpireTime(Date expireTime)
    {
        this.expireTime = expireTime;
    }

    public String getArchiveFlag()
    {
        return archiveFlag;
    }

    public void setArchiveFlag(String archiveFlag)
    {
        this.archiveFlag = archiveFlag;
    }

}