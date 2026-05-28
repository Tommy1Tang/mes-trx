package com.ruoyi.production.runtime.domain;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * MBR执行上下文对象 pro_mbr_execution_context
 */
public class MbrExecutionContext extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    @Excel(name = "MBR执行上下文ID")
    private Long contextId;

    @Excel(name = "执行上下文编号")
    private String contextNo;

    @Excel(name = "生产工单ID")
    private Long prodOrderId;

    @Excel(name = "MBR版本ID")
    private Long mbrVersionId;

    @Excel(name = "电子批记录ID")
    private Long ebrId;

    @Excel(name = "上一版上下文ID")
    private Long previousContextId;

    @Excel(name = "来源ECN ID")
    private Long sourceEcnId;

    @Excel(name = "上下文版本号")
    private String contextVersion;

    @Excel(name = "上下文哈希")
    private String contextHash;

    @Excel(name = "上下文状态")
    private String contextStatus;

    @Excel(name = "刷新状态")
    private String refreshStatus;

    @Excel(name = "暂停原因")
    private String holdReason;

    @Excel(name = "缓存键")
    private String cacheKey;

    @Excel(name = "上下文JSON快照")
    private String contextJson;

    @Excel(name = "当前步骤ID")
    private Long currentStepId;

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @Excel(name = "过期时间")
    private Date expireTime;

    @Excel(name = "乐观锁版本")
    private Integer lockVersion;

    private String delFlag;

    public Long getContextId()
    {
        return contextId;
    }

    public void setContextId(Long contextId)
    {
        this.contextId = contextId;
    }

    public String getContextNo()
    {
        return contextNo;
    }

    public void setContextNo(String contextNo)
    {
        this.contextNo = contextNo;
    }

    public Long getProdOrderId()
    {
        return prodOrderId;
    }

    public void setProdOrderId(Long prodOrderId)
    {
        this.prodOrderId = prodOrderId;
    }

    public Long getMbrVersionId()
    {
        return mbrVersionId;
    }

    public void setMbrVersionId(Long mbrVersionId)
    {
        this.mbrVersionId = mbrVersionId;
    }

    public Long getEbrId()
    {
        return ebrId;
    }

    public void setEbrId(Long ebrId)
    {
        this.ebrId = ebrId;
    }

    public Long getPreviousContextId()
    {
        return previousContextId;
    }

    public void setPreviousContextId(Long previousContextId)
    {
        this.previousContextId = previousContextId;
    }

    public Long getSourceEcnId()
    {
        return sourceEcnId;
    }

    public void setSourceEcnId(Long sourceEcnId)
    {
        this.sourceEcnId = sourceEcnId;
    }

    public String getContextVersion()
    {
        return contextVersion;
    }

    public void setContextVersion(String contextVersion)
    {
        this.contextVersion = contextVersion;
    }

    public String getContextHash()
    {
        return contextHash;
    }

    public void setContextHash(String contextHash)
    {
        this.contextHash = contextHash;
    }

    public String getContextStatus()
    {
        return contextStatus;
    }

    public void setContextStatus(String contextStatus)
    {
        this.contextStatus = contextStatus;
    }

    public String getRefreshStatus()
    {
        return refreshStatus;
    }

    public void setRefreshStatus(String refreshStatus)
    {
        this.refreshStatus = refreshStatus;
    }

    public String getHoldReason()
    {
        return holdReason;
    }

    public void setHoldReason(String holdReason)
    {
        this.holdReason = holdReason;
    }

    public String getCacheKey()
    {
        return cacheKey;
    }

    public void setCacheKey(String cacheKey)
    {
        this.cacheKey = cacheKey;
    }

    public String getContextJson()
    {
        return contextJson;
    }

    public void setContextJson(String contextJson)
    {
        this.contextJson = contextJson;
    }

    public Long getCurrentStepId()
    {
        return currentStepId;
    }

    public void setCurrentStepId(Long currentStepId)
    {
        this.currentStepId = currentStepId;
    }

    public Date getExpireTime()
    {
        return expireTime;
    }

    public void setExpireTime(Date expireTime)
    {
        this.expireTime = expireTime;
    }

    public Integer getLockVersion()
    {
        return lockVersion;
    }

    public void setLockVersion(Integer lockVersion)
    {
        this.lockVersion = lockVersion;
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