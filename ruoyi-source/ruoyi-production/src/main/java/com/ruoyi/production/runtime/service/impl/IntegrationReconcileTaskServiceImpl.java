package com.ruoyi.production.runtime.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.production.runtime.mapper.IntegrationReconcileTaskMapper;
import com.ruoyi.production.runtime.domain.IntegrationReconcileTask;
import com.ruoyi.production.runtime.service.IIntegrationReconcileTaskService;

/**
 * 集成对账补偿任务Service实现
 */
@Service
public class IntegrationReconcileTaskServiceImpl implements IIntegrationReconcileTaskService
{
    @Autowired
    private IntegrationReconcileTaskMapper integrationReconcileTaskMapper;

    @Override
    public IntegrationReconcileTask selectIntegrationReconcileTaskByReconcileTaskId(Long reconcileTaskId)
    {
        return integrationReconcileTaskMapper.selectIntegrationReconcileTaskByReconcileTaskId(reconcileTaskId);
    }

    @Override
    public List<IntegrationReconcileTask> selectIntegrationReconcileTaskList(IntegrationReconcileTask integrationReconcileTask)
    {
        return integrationReconcileTaskMapper.selectIntegrationReconcileTaskList(integrationReconcileTask);
    }

    @Override
    public int insertIntegrationReconcileTask(IntegrationReconcileTask integrationReconcileTask)
    {
        return integrationReconcileTaskMapper.insertIntegrationReconcileTask(integrationReconcileTask);
    }

    @Override
    public int updateIntegrationReconcileTask(IntegrationReconcileTask integrationReconcileTask)
    {
        return integrationReconcileTaskMapper.updateIntegrationReconcileTask(integrationReconcileTask);
    }

    @Override
    public int deleteIntegrationReconcileTaskByReconcileTaskIds(Long[] reconcileTaskIds)
    {
        return integrationReconcileTaskMapper.deleteIntegrationReconcileTaskByReconcileTaskIds(reconcileTaskIds);
    }
}