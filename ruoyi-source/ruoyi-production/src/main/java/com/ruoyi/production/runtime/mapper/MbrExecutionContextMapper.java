package com.ruoyi.production.runtime.mapper;

import java.util.List;
import com.ruoyi.production.runtime.domain.MbrExecutionContext;

/**
 * MBR执行上下文Mapper接口
 */
public interface MbrExecutionContextMapper
{
    public MbrExecutionContext selectMbrExecutionContextByContextId(Long contextId);
    public List<MbrExecutionContext> selectMbrExecutionContextList(MbrExecutionContext mbrExecutionContext);
    public int insertMbrExecutionContext(MbrExecutionContext mbrExecutionContext);
    public int updateMbrExecutionContext(MbrExecutionContext mbrExecutionContext);
    public int deleteMbrExecutionContextByContextIds(Long[] contextIds);
}