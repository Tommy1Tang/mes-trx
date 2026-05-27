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
import com.ruoyi.production.runtime.domain.MbrExecutionContext;
import com.ruoyi.production.runtime.service.IMbrExecutionContextService;

/**
 * MBR执行上下文管理Controller
 */
@RestController
@RequestMapping("/runtime/mbr-context")
public class MbrExecutionContextController extends BaseController
{
    @Autowired
    private IMbrExecutionContextService contextService;

    @PreAuthorize("@ss.hasPermi('runtime:mbrContext:list')")
    @GetMapping("/list")
    public TableDataInfo list(MbrExecutionContext context)
    {
        startPage();
        List<MbrExecutionContext> list = contextService.selectMbrExecutionContextList(context);
        return getDataTable(list);
    }

    @Log(title = "MBR执行上下文管理", businessType = BusinessType.EXPORT)
    @PreAuthorize("@ss.hasPermi('runtime:mbrContext:export')")
    @PostMapping("/export")
    public void export(HttpServletResponse response, MbrExecutionContext context)
    {
        List<MbrExecutionContext> list = contextService.selectMbrExecutionContextList(context);
        ExcelUtil<MbrExecutionContext> util = new ExcelUtil<MbrExecutionContext>(MbrExecutionContext.class);
        util.exportExcel(response, list, "MBR执行上下文管理");
    }

    @PreAuthorize("@ss.hasPermi('runtime:mbrContext:query')")
    @GetMapping(value = "/{contextId}")
    public AjaxResult getInfo(@PathVariable Long contextId)
    {
        return success(contextService.selectMbrExecutionContextByContextId(contextId));
    }

    @PreAuthorize("@ss.hasPermi('runtime:mbrContext:add')")
    @Log(title = "MBR执行上下文管理", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@Validated @RequestBody MbrExecutionContext context)
    {
        context.setCreateBy(getUsername());
        return toAjax(contextService.insertMbrExecutionContext(context));
    }

    @PreAuthorize("@ss.hasPermi('runtime:mbrContext:edit')")
    @Log(title = "MBR执行上下文管理", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@Validated @RequestBody MbrExecutionContext context)
    {
        context.setUpdateBy(getUsername());
        return toAjax(contextService.updateMbrExecutionContext(context));
    }

    @PreAuthorize("@ss.hasPermi('runtime:mbrContext:remove')")
    @Log(title = "MBR执行上下文管理", businessType = BusinessType.DELETE)
    @DeleteMapping("/{contextIds}")
    public AjaxResult remove(@PathVariable Long[] contextIds)
    {
        return toAjax(contextService.deleteMbrExecutionContextByContextIds(contextIds));
    }
}