package com.ruoyi.production.runtime.service;

import java.util.List;
import com.ruoyi.production.runtime.domain.IntegrationReconcileTask;

/**
 * 集成对账补偿任务Service接口
 */
public interface IIntegrationReconcileTaskService
{
    public IntegrationReconcileTask selectIntegrationReconcileTaskByReconcileTaskId(Long reconcileTaskId);
    public List<IntegrationReconcileTask> selectIntegrationReconcileTaskList(IntegrationReconcileTask integrationReconcileTask);
    public int insertIntegrationReconcileTask(IntegrationReconcileTask integrationReconcileTask);
    public int updateIntegrationReconcileTask(IntegrationReconcileTask integrationReconcileTask);
    public int deleteIntegrationReconcileTaskByReconcileTaskIds(Long[] reconcileTaskIds);
}