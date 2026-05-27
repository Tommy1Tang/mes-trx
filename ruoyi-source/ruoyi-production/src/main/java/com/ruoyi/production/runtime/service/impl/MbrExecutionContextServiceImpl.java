package com.ruoyi.production.runtime.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.production.runtime.mapper.MbrExecutionContextMapper;
import com.ruoyi.production.runtime.domain.MbrExecutionContext;
import com.ruoyi.production.runtime.service.IMbrExecutionContextService;

/**
 * MBR执行上下文Service实现
 */
@Service
public class MbrExecutionContextServiceImpl implements IMbrExecutionContextService
{
    @Autowired
    private MbrExecutionContextMapper mbrExecutionContextMapper;

    @Override
    public MbrExecutionContext selectMbrExecutionContextByContextId(Long contextId)
    {
        return mbrExecutionContextMapper.selectMbrExecutionContextByContextId(contextId);
    }

    @Override
    public List<MbrExecutionContext> selectMbrExecutionContextList(MbrExecutionContext mbrExecutionContext)
    {
        return mbrExecutionContextMapper.selectMbrExecutionContextList(mbrExecutionContext);
    }

    @Override
    public int insertMbrExecutionContext(MbrExecutionContext mbrExecutionContext)
    {
        return mbrExecutionContextMapper.insertMbrExecutionContext(mbrExecutionContext);
    }

    @Override
    public int updateMbrExecutionContext(MbrExecutionContext mbrExecutionContext)
    {
        return mbrExecutionContextMapper.updateMbrExecutionContext(mbrExecutionContext);
    }

    @Override
    public int deleteMbrExecutionContextByContextIds(Long[] contextIds)
    {
        return mbrExecutionContextMapper.deleteMbrExecutionContextByContextIds(contextIds);
    }
}