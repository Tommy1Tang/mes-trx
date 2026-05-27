package com.ruoyi.production.runtime.mapper;

import java.util.List;
import com.ruoyi.production.runtime.domain.MbrContextRefreshLog;

/**
 * MBR执行上下文刷新日志Mapper接口
 */
public interface MbrContextRefreshLogMapper
{
    public MbrContextRefreshLog selectMbrContextRefreshLogByRefreshLogId(Long refreshLogId);
    public List<MbrContextRefreshLog> selectMbrContextRefreshLogList(MbrContextRefreshLog mbrContextRefreshLog);
    public int insertMbrContextRefreshLog(MbrContextRefreshLog mbrContextRefreshLog);
    public int updateMbrContextRefreshLog(MbrContextRefreshLog mbrContextRefreshLog);
    public int deleteMbrContextRefreshLogByRefreshLogIds(Long[] refreshLogIds);
}