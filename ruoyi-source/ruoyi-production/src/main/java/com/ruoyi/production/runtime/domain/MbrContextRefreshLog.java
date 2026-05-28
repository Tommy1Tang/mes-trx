package com.ruoyi.production.runtime.domain;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * MBR执行上下文刷新日志对象 pro_mbr_context_refresh_log
 */
public class MbrContextRefreshLog extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    @Excel(name = "刷新日志ID")
    private Long refreshLogId;

    @Excel(name = "旧上下文ID")
    private Long oldContextId;

    @Excel(name = "新上下文ID")
    private Long newContextId;

    @Excel(name = "刷新来源类型")
    private String sourceType;

    @Excel(name = "来源ECN ID")
    private Long sourceEcnId;

    @Excel(name = "影响范围")
    private String affectedScope;

    @Excel(name = "旧上下文的哈希")
    private String oldContextHash;

    @Excel(name = "新上下文的哈希")
    private String newContextHash;

    @Excel(name = "刷新前状态")
    private String beforeStatus;

    @Excel(name = "刷新后状态")
    private String afterStatus;

    @Excel(name = "刷新结果")
    private String refreshResult;

    @Excel(name = "差异摘要")
    private String diffSummary;

    @Excel(name = "失败原因")
    private String failureReason;

    @Excel(name = "操作人ID")
    private Long operatorId;

    @Excel(name = "电子签名ID")
    private Long signatureId;

    @Excel(name = "审计追踪ID")
    private Long auditTrailId;

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @Excel(name = "刷新时间")
    private Date refreshTime;

    private String delFlag;

    public Long getRefreshLogId()
    {
        return refreshLogId;
    }

    public void setRefreshLogId(Long refreshLogId)
    {
        this.refreshLogId = refreshLogId;
    }

    public Long getOldContextId()
    {
        return oldContextId;
    }

    public void setOldContextId(Long oldContextId)
    {
        this.oldContextId = oldContextId;
    }

    public Long getNewContextId()
    {
        return newContextId;
    }

    public void setNewContextId(Long newContextId)
    {
        this.newContextId = newContextId;
    }

    public String getSourceType()
    {
        return sourceType;
    }

    public void setSourceType(String sourceType)
    {
        this.sourceType = sourceType;
    }

    public Long getSourceEcnId()
    {
        return sourceEcnId;
    }

    public void setSourceEcnId(Long sourceEcnId)
    {
        this.sourceEcnId = sourceEcnId;
    }

    public String getAffectedScope()
    {
        return affectedScope;
    }

    public void setAffectedScope(String affectedScope)
    {
        this.affectedScope = affectedScope;
    }

    public String getOldContextHash()
    {
        return oldContextHash;
    }

    public void setOldContextHash(String oldContextHash)
    {
        this.oldContextHash = oldContextHash;
    }

    public String getNewContextHash()
    {
        return newContextHash;
    }

    public void setNewContextHash(String newContextHash)
    {
        this.newContextHash = newContextHash;
    }

    public String getBeforeStatus()
    {
        return beforeStatus;
    }

    public void setBeforeStatus(String beforeStatus)
    {
        this.beforeStatus = beforeStatus;
    }

    public String getAfterStatus()
    {
        return afterStatus;
    }

    public void setAfterStatus(String afterStatus)
    {
        this.afterStatus = afterStatus;
    }

    public String getRefreshResult()
    {
        return refreshResult;
    }

    public void setRefreshResult(String refreshResult)
    {
        this.refreshResult = refreshResult;
    }

    public String getDiffSummary()
    {
        return diffSummary;
    }

    public void setDiffSummary(String diffSummary)
    {
        this.diffSummary = diffSummary;
    }

    public String getFailureReason()
    {
        return failureReason;
    }

    public void setFailureReason(String failureReason)
    {
        this.failureReason = failureReason;
    }

    public Long getOperatorId()
    {
        return operatorId;
    }

    public void setOperatorId(Long operatorId)
    {
        this.operatorId = operatorId;
    }

    public Long getSignatureId()
    {
        return signatureId;
    }

    public void setSignatureId(Long signatureId)
    {
        this.signatureId = signatureId;
    }

    public Long getAuditTrailId()
    {
        return auditTrailId;
    }

    public void setAuditTrailId(Long auditTrailId)
    {
        this.auditTrailId = auditTrailId;
    }

    public Date getRefreshTime()
    {
        return refreshTime;
    }

    public void setRefreshTime(Date refreshTime)
    {
        this.refreshTime = refreshTime;
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