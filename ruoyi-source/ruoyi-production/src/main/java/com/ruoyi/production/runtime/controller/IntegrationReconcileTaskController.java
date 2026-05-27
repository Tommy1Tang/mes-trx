package com.ruoyi.production.runtime.controller;

import java.util.List;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.production.runtime.domain.IntegrationReconcileTask;
import com.ruoyi.production.runtime.service.IIntegrationReconcileTaskService;

/**
 * 集成对账管理Controller
 */
@RestController
@RequestMapping("/runtime/reconcile")
public class IntegrationReconcileTaskController extends BaseController
{
    @Autowired
    private IIntegrationReconcileTaskService reconcileService;

    @PreAuthorize("@ss.hasPermi('runtime:reconcile:list')")
    @GetMapping("/list")
    public TableDataInfo list(IntegrationReconcileTask reconcile)
    {
        startPage();
        List<IntegrationReconcileTask> list = reconcileService.selectIntegrationReconcileTaskList(reconcile);
        return getDataTable(list);
    }

    @Log(title = "集成对账管理", businessType = BusinessType.EXPORT)
    @PreAuthorize("@ss.hasPermi('runtime:reconcile:export')")
    @PostMapping("/export")
    public void export(HttpServletResponse response, IntegrationReconcileTask reconcile)
    {
        List<IntegrationReconcileTask> list = reconcileService.selectIntegrationReconcileTaskList(reconcile);
        ExcelUtil<IntegrationReconcileTask> util = new ExcelUtil<IntegrationReconcileTask>(IntegrationReconcileTask.class);
        util.exportExcel(response, list, "集成对账管理");
    }

    @PreAuthorize("@ss.hasPermi('runtime:reconcile:query')")
    @GetMapping(value = "/{reconcileTaskId}")
    public AjaxResult getInfo(@PathVariable Long reconcileTaskId)
    {
        return success(reconcileService.selectIntegrationReconcileTaskByReconcileTaskId(reconcileTaskId));
    }

    @PreAuthorize("@ss.hasPermi('runtime:reconcile:add')")
    @Log(title = "集成对账管理", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@Validated @RequestBody IntegrationReconcileTask reconcile)
    {
        reconcile.setCreateBy(getUsername());
        return toAjax(reconcileService.insertIntegrationReconcileTask(reconcile));
    }

    @PreAuthorize("@ss.hasPermi('runtime:reconcile:edit')")
    @Log(title = "集成对账管理", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@Validated @RequestBody IntegrationReconcileTask reconcile)
    {
        reconcile.setUpdateBy(getUsername());
        return toAjax(reconcileService.updateIntegrationReconcileTask(reconcile));
    }

    @PreAuthorize("@ss.hasPermi('runtime:reconcile:remove')")
    @Log(title = "集成对账管理", businessType = BusinessType.DELETE)
    @DeleteMapping("/{reconcileTaskIds}")
    public AjaxResult remove(@PathVariable Long[] reconcileTaskIds)
    {
        return toAjax(reconcileService.deleteIntegrationReconcileTaskByReconcileTaskIds(reconcileTaskIds));
    }
}