package com.ruoyi.production.runtime.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.production.runtime.mapper.MbrContextRefreshLogMapper;
import com.ruoyi.production.runtime.domain.MbrContextRefreshLog;
import com.ruoyi.production.runtime.service.IMbrContextRefreshLogService;

/**
 * MBR执行上下文刷新日志Service实现
 */
@Service
public class MbrContextRefreshLogServiceImpl implements IMbrContextRefreshLogService
{
    @Autowired
    private MbrContextRefreshLogMapper mbrContextRefreshLogMapper;

    @Override
    public MbrContextRefreshLog selectMbrContextRefreshLogByRefreshLogId(Long refreshLogId)
    {
        return mbrContextRefreshLogMapper.selectMbrContextRefreshLogByRefreshLogId(refreshLogId);
    }

    @Override
    public List<MbrContextRefreshLog> selectMbrContextRefreshLogList(MbrContextRefreshLog mbrContextRefreshLog)
    {
        return mbrContextRefreshLogMapper.selectMbrContextRefreshLogList(mbrContextRefreshLog);
    }

    @Override
    public int insertMbrContextRefreshLog(MbrContextRefreshLog mbrContextRefreshLog)
    {
        return mbrContextRefreshLogMapper.insertMbrContextRefreshLog(mbrContextRefreshLog);
    }

    @Override
    public int updateMbrContextRefreshLog(MbrContextRefreshLog mbrContextRefreshLog)
    {
        return mbrContextRefreshLogMapper.updateMbrContextRefreshLog(mbrContextRefreshLog);
    }

    @Override
    public int deleteMbrContextRefreshLogByRefreshLogIds(Long[] refreshLogIds)
    {
        return mbrContextRefreshLogMapper.deleteMbrContextRefreshLogByRefreshLogIds(refreshLogIds);
    }
}