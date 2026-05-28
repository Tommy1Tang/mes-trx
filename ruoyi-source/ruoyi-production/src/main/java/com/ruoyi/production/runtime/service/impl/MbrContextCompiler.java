package com.ruoyi.production.runtime.service.impl;

import java.util.Date;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.production.runtime.domain.MbrExecutionContext;
import com.ruoyi.production.runtime.domain.MbrContextRefreshLog;
import com.ruoyi.production.runtime.mapper.MbrExecutionContextMapper;
import com.ruoyi.production.runtime.service.IMbrContextRefreshLogService;

/**
 * MBR执行上下文编译器
 * 工单下达时将MBR模板预编译为JSON快照
 * ECN/返工/Hold恢复时触发上下文刷新
 */
@Service
public class MbrContextCompiler
{
    private static final Logger log = LoggerFactory.getLogger(MbrContextCompiler.class);

    @Autowired
    private MbrExecutionContextMapper contextMapper;

    @Autowired
    private IMbrContextRefreshLogService refreshLogService;

    private final ObjectMapper objectMapper = new ObjectMapper();

    /**
     * 编译MBR执行上下文
     * 工单下达时调用，将MBR版本的步骤、参数、物料、设备、质控等信息预编译为JSON快照
     *
     * @param prodOrderId 生产工单ID
     * @param mbrVersionId MBR版本ID
     * @param mbrSnapshot MBR结构化快照（JSON字符串）
     * @return 编译后的执行上下文
     */
    @Transactional
    public MbrExecutionContext compile(Long prodOrderId, Long mbrVersionId, String mbrSnapshot)
    {
        MbrExecutionContext context = new MbrExecutionContext();
        context.setContextNo("CTX-" + System.currentTimeMillis());
        context.setProdOrderId(prodOrderId);
        context.setMbrVersionId(mbrVersionId);
        context.setContextVersion("1.0");
        context.setContextHash(calcHash(mbrSnapshot));
        context.setContextStatus("ACTIVE");
        context.setContextJson(mbrSnapshot);
        context.setCacheKey("mbr:ctx:" + prodOrderId + ":" + mbrVersionId);
        context.setLockVersion(0);
        context.setCreateBy(SecurityUtils.getUsername());
        contextMapper.insertMbrExecutionContext(context);

        log.info("MBR context compiled: contextId={}, order={}, mbrVersion={}",
                 context.getContextId(), prodOrderId, mbrVersionId);
        return context;
    }

    /**
     * 刷新MBR执行上下文
     * ECN变更、返工、Hold恢复时调用
     *
     * @param oldContextId 旧上下文ID
     * @param newSnapshot 新的MBR快照
     * @param sourceType 刷新来源（ECN/REWORK/HOLD_RELEASE）
     * @param sourceEcnId 来源ECN ID（可选）
     * @return 新的执行上下文
     */
    @Transactional
    public MbrExecutionContext refresh(Long oldContextId, String newSnapshot, String sourceType, Long sourceEcnId)
    {
        MbrExecutionContext oldContext = contextMapper.selectMbrExecutionContextByContextId(oldContextId);
        if (oldContext == null)
        {
            throw new RuntimeException("旧上下文不存在: " + oldContextId);
        }

        // 标记旧上下文失效
        oldContext.setContextStatus("INVALID");
        oldContext.setRefreshStatus("REFRESHING");
        oldContext.setUpdateBy(SecurityUtils.getUsername());
        contextMapper.updateMbrExecutionContext(oldContext);

        // 编译新上下文
        MbrExecutionContext newContext = new MbrExecutionContext();
        newContext.setContextNo("CTX-" + System.currentTimeMillis());
        newContext.setProdOrderId(oldContext.getProdOrderId());
        newContext.setMbrVersionId(oldContext.getMbrVersionId());
        newContext.setPreviousContextId(oldContextId);
        newContext.setSourceEcnId(sourceEcnId);
        newContext.setContextVersion(calcNextVersion(oldContext.getContextVersion()));
        newContext.setContextHash(calcHash(newSnapshot));
        newContext.setContextStatus("ACTIVE");
        newContext.setContextJson(newSnapshot);
        newContext.setCacheKey(oldContext.getCacheKey());
        newContext.setLockVersion(0);
        newContext.setCreateBy(SecurityUtils.getUsername());
        contextMapper.insertMbrExecutionContext(newContext);

        // 记录刷新日志
        MbrContextRefreshLog refreshLog = new MbrContextRefreshLog();
        refreshLog.setOldContextId(oldContextId);
        refreshLog.setNewContextId(newContext.getContextId());
        refreshLog.setSourceType(sourceType);
        refreshLog.setSourceEcnId(sourceEcnId);
        refreshLog.setOldContextHash(oldContext.getContextHash());
        refreshLog.setNewContextHash(newContext.getContextHash());
        refreshLog.setBeforeStatus("ACTIVE");
        refreshLog.setAfterStatus("ACTIVE");
        refreshLog.setRefreshResult("SUCCESS");
        refreshLog.setRefreshTime(new Date());
        refreshLog.setCreateBy(SecurityUtils.getUsername());
        refreshLogService.insertMbrContextRefreshLog(refreshLog);

        log.info("MBR context refreshed: old={}, new={}, source={}", oldContextId, newContext.getContextId(), sourceType);
        return newContext;
    }

    private String calcHash(String content)
    {
        if (StringUtils.isBlank(content))
        {
            return "";
        }
        try
        {
            java.security.MessageDigest md = java.security.MessageDigest.getInstance("SHA-256");
            byte[] hash = md.digest(content.getBytes(java.nio.charset.StandardCharsets.UTF_8));
            StringBuilder sb = new StringBuilder();
            for (byte b : hash)
            {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        }
        catch (Exception e)
        {
            return String.valueOf(content.hashCode());
        }
    }

    private String calcNextVersion(String currentVersion)
    {
        if (StringUtils.isBlank(currentVersion))
        {
            return "1.0";
        }
        try
        {
            String[] parts = currentVersion.split("\\.");
            int minor = Integer.parseInt(parts[1]) + 1;
            return parts[0] + "." + minor;
        }
        catch (Exception e)
        {
            return currentVersion + ".1";
        }
    }
}
