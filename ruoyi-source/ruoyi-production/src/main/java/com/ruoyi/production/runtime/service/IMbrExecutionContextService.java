package com.ruoyi.production.runtime.service;

import java.util.List;
import com.ruoyi.production.runtime.domain.MbrExecutionContext;

/**
 * MBR执行上下文Service接口
 */
public interface IMbrExecutionContextService
{
    public MbrExecutionContext selectMbrExecutionContextByContextId(Long contextId);
    public List<MbrExecutionContext> selectMbrExecutionContextList(MbrExecutionContext mbrExecutionContext);
    public int insertMbrExecutionContext(MbrExecutionContext mbrExecutionContext);
    public int updateMbrExecutionContext(MbrExecutionContext mbrExecutionContext);
    public int deleteMbrExecutionContextByContextIds(Long[] contextIds);
}