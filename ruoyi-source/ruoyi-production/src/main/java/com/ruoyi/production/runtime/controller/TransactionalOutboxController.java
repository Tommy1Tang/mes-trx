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
import com.ruoyi.production.runtime.domain.TransactionalOutbox;
import com.ruoyi.production.runtime.service.ITransactionalOutboxService;

/**
 * 事务外箱管理Controller
 */
@RestController
@RequestMapping("/runtime/outbox")
public class TransactionalOutboxController extends BaseController
{
    @Autowired
    private ITransactionalOutboxService outboxService;

    @PreAuthorize("@ss.hasPermi('runtime:outbox:list')")
    @GetMapping("/list")
    public TableDataInfo list(TransactionalOutbox outbox)
    {
        startPage();
        List<TransactionalOutbox> list = outboxService.selectTransactionalOutboxList(outbox);
        return getDataTable(list);
    }

    @Log(title = "事务外箱管理", businessType = BusinessType.EXPORT)
    @PreAuthorize("@ss.hasPermi('runtime:outbox:export')")
    @PostMapping("/export")
    public void export(HttpServletResponse response, TransactionalOutbox outbox)
    {
        List<TransactionalOutbox> list = outboxService.selectTransactionalOutboxList(outbox);
        ExcelUtil<TransactionalOutbox> util = new ExcelUtil<TransactionalOutbox>(TransactionalOutbox.class);
        util.exportExcel(response, list, "事务外箱管理");
    }

    @PreAuthorize("@ss.hasPermi('runtime:outbox:query')")
    @GetMapping(value = "/{outboxId}")
    public AjaxResult getInfo(@PathVariable Long outboxId)
    {
        return success(outboxService.selectTransactionalOutboxByOutboxId(outboxId));
    }

    @PreAuthorize("@ss.hasPermi('runtime:outbox:add')")
    @Log(title = "事务外箱管理", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@Validated @RequestBody TransactionalOutbox outbox)
    {
        outbox.setCreateBy(getUsername());
        return toAjax(outboxService.insertTransactionalOutbox(outbox));
    }

    @PreAuthorize("@ss.hasPermi('runtime:outbox:edit')")
    @Log(title = "事务外箱管理", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@Validated @RequestBody TransactionalOutbox outbox)
    {
        outbox.setUpdateBy(getUsername());
        return toAjax(outboxService.updateTransactionalOutbox(outbox));
    }

    @PreAuthorize("@ss.hasPermi('runtime:outbox:remove')")
    @Log(title = "事务外箱管理", businessType = BusinessType.DELETE)
    @DeleteMapping("/{outboxIds}")
    public AjaxResult remove(@PathVariable Long[] outboxIds)
    {
        return toAjax(outboxService.deleteTransactionalOutboxByOutboxIds(outboxIds));
    }
}