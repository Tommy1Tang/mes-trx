package com.ruoyi.production.runtime.mapper;

import java.util.List;
import com.ruoyi.production.runtime.domain.IntegrationReconcileTask;

/**
 * 集成对账补偿任务Mapper接口
 */
public interface IntegrationReconcileTaskMapper
{
    public IntegrationReconcileTask selectIntegrationReconcileTaskByReconcileTaskId(Long reconcileTaskId);
    public List<IntegrationReconcileTask> selectIntegrationReconcileTaskList(IntegrationReconcileTask integrationReconcileTask);
    public int insertIntegrationReconcileTask(IntegrationReconcileTask integrationReconcileTask);
    public int updateIntegrationReconcileTask(IntegrationReconcileTask integrationReconcileTask);
    public int deleteIntegrationReconcileTaskByReconcileTaskIds(Long[] reconcileTaskIds);
}