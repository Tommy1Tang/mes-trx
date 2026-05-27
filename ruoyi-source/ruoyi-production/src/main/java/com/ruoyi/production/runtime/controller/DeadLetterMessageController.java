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
import com.ruoyi.production.runtime.domain.DeadLetterMessage;
import com.ruoyi.production.runtime.service.IDeadLetterMessageService;

/**
 * 死信消息管理Controller
 */
@RestController
@RequestMapping("/runtime/dead-letter")
public class DeadLetterMessageController extends BaseController
{
    @Autowired
    private IDeadLetterMessageService deadLetterService;

    @PreAuthorize("@ss.hasPermi('runtime:deadLetter:list')")
    @GetMapping("/list")
    public TableDataInfo list(DeadLetterMessage deadLetter)
    {
        startPage();
        List<DeadLetterMessage> list = deadLetterService.selectDeadLetterMessageList(deadLetter);
        return getDataTable(list);
    }

    @Log(title = "死信消息管理", businessType = BusinessType.EXPORT)
    @PreAuthorize("@ss.hasPermi('runtime:deadLetter:export')")
    @PostMapping("/export")
    public void export(HttpServletResponse response, DeadLetterMessage deadLetter)
    {
        List<DeadLetterMessage> list = deadLetterService.selectDeadLetterMessageList(deadLetter);
        ExcelUtil<DeadLetterMessage> util = new ExcelUtil<DeadLetterMessage>(DeadLetterMessage.class);
        util.exportExcel(response, list, "死信消息管理");
    }

    @PreAuthorize("@ss.hasPermi('runtime:deadLetter:query')")
    @GetMapping(value = "/{deadLetterId}")
    public AjaxResult getInfo(@PathVariable Long deadLetterId)
    {
        return success(deadLetterService.selectDeadLetterMessageByDeadLetterId(deadLetterId));
    }

    @PreAuthorize("@ss.hasPermi('runtime:deadLetter:add')")
    @Log(title = "死信消息管理", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@Validated @RequestBody DeadLetterMessage deadLetter)
    {
        deadLetter.setCreateBy(getUsername());
        return toAjax(deadLetterService.insertDeadLetterMessage(deadLetter));
    }

    @PreAuthorize("@ss.hasPermi('runtime:deadLetter:edit')")
    @Log(title = "死信消息管理", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@Validated @RequestBody DeadLetterMessage deadLetter)
    {
        deadLetter.setUpdateBy(getUsername());
        return toAjax(deadLetterService.updateDeadLetterMessage(deadLetter));
    }

    @PreAuthorize("@ss.hasPermi('runtime:deadLetter:remove')")
    @Log(title = "死信消息管理", businessType = BusinessType.DELETE)
    @DeleteMapping("/{deadLetterIds}")
    public AjaxResult remove(@PathVariable Long[] deadLetterIds)
    {
        return toAjax(deadLetterService.deleteDeadLetterMessageByDeadLetterIds(deadLetterIds));
    }
}