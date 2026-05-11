package com.ruoyi.generator.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import jakarta.servlet.http.HttpServletResponse;
import org.apache.commons.io.IOUtils;
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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import com.alibaba.druid.DbType;
import com.alibaba.druid.sql.SQLUtils;
import com.alibaba.druid.sql.ast.SQLStatement;
import com.alibaba.druid.sql.dialect.postgresql.ast.statement.PgCreateTableStatement;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.core.text.Convert;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.common.utils.sql.SqlUtil;
import com.ruoyi.generator.config.GenConfig;
import com.ruoyi.generator.domain.GenTable;
import com.ruoyi.generator.domain.GenTableColumn;
import com.ruoyi.generator.service.IGenTableColumnService;
import com.ruoyi.generator.service.IGenTableService;

/**
 * 代码生成 操作处理
 * 
 * @author ruoyi
 */
@RestController
@RequestMapping("/tool/gen")
public class GenController extends BaseController
{
    @Autowired
    private IGenTableService genTableService;

    @Autowired
    private IGenTableColumnService genTableColumnService;

    /**
     * 查询代码生成列表
     */
    @PreAuthorize("@ss.hasPermi('tool:gen:list')")
    @GetMapping("/list")
    public TableDataInfo genList(GenTable genTable)
    {
        startPage();
        List<GenTable> list = genTableService.selectGenTableList(genTable);
        return getDataTable(list);
    }

    /**
     * 获取代码生成信息
     */
    @PreAuthorize("@ss.hasPermi('tool:gen:query')")
    @GetMapping(value = "/{tableId}")
    public AjaxResult getInfo(@PathVariable Long tableId)
    {
        GenTable table = genTableService.selectGenTableById(tableId);
        List<GenTable> tables = genTableService.selectGenTableAll();
        List<GenTableColumn> list = genTableColumnService.selectGenTableColumnListByTableId(tableId);
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("info", table);
        map.put("rows", list);
        map.put("tables", tables);
        return success(map);
    }

    /**
     * 查询数据库列表
     */
    @PreAuthorize("@ss.hasPermi('tool:gen:list')")
    @GetMapping("/db/list")
    public TableDataInfo dataList(GenTable genTable)
    {
        startPage();
        List<GenTable> list = genTableService.selectDbTableList(genTable);
        return getDataTable(list);
    }

    /**
     * 查询数据表字段列表
     */
    @PreAuthorize("@ss.hasPermi('tool:gen:list')")
    @GetMapping(value = "/column/{tableId}")
    public TableDataInfo columnList(Long tableId)
    {
        TableDataInfo dataInfo = new TableDataInfo();
        List<GenTableColumn> list = genTableColumnService.selectGenTableColumnListByTableId(tableId);
        dataInfo.setRows(list);
        dataInfo.setTotal(list.size());
        return dataInfo;
    }

    /**
     * 导入表结构（保存）
     */
    @PreAuthorize("@ss.hasPermi('tool:gen:import')")
    @Log(title = "代码生成", businessType = BusinessType.IMPORT)
    @PostMapping("/importTable")
    public AjaxResult importTableSave(@RequestParam("tables") String tables, @RequestParam("tplWebType") String tplWebType)
    {
        String[] tableNames = Convert.toStrArray(tables);
        // 查询表信息
        List<GenTable> tableList = genTableService.selectDbTableListByNames(tableNames);
        genTableService.importGenTable(tableList, tplWebType, SecurityUtils.getUsername());
        return success();
    }

    /**
     * 创建表结构（保存）
     */
    @PreAuthorize("@ss.hasRole('admin')")
    @Log(title = "创建表", businessType = BusinessType.OTHER)
    @PostMapping("/createTable")
    public AjaxResult createTableSave(@RequestParam("sql") String sql, @RequestParam("tplWebType") String tplWebType)
    {
        try
        {
            SqlUtil.filterKeyword(sql);
            List<SQLStatement> sqlStatements = SQLUtils.parseStatements(sql, DbType.postgresql);
            List<String> tableNames = new ArrayList<>();
            for (SQLStatement sqlStatement : sqlStatements)
            {
                if (sqlStatement instanceof PgCreateTableStatement)
                {
                    PgCreateTableStatement createTableStatement = (PgCreateTableStatement) sqlStatement;
                    if (genTableService.createTable(createTableStatement.toString()))
                    {
                        String tableName = createTableStatement.getTableName().replaceAll("`", "");
                        tableNames.add(tableName);
                    }
                }
            }
            List<GenTable> tableList = genTableService.selectDbTableListByNames(tableNames.toArray(new String[tableNames.size()]));
            String operName = SecurityUtils.getUsername();
            genTableService.importGenTable(tableList, tplWebType, operName);
            return AjaxResult.success();
        }
        catch (Exception e)
        {
            logger.error(e.getMessage(), e);
            return AjaxResult.error("创建表结构异常");
        }
    }

    /**
     * 修改保存代码生成业务
     */
    @PreAuthorize("@ss.hasPermi('tool:gen:edit')")
    @Log(title = "代码生成", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult editSave(@Validated @RequestBody GenTable genTable)
    {
        genTableService.validateEdit(genTable);
        genTableService.updateGenTable(genTable);
        return success();
    }

    /**
     * 删除代码生成
     */
    @PreAuthorize("@ss.hasPermi('tool:gen:remove')")
    @Log(title = "代码生成", businessType = BusinessType.DELETE)
    @DeleteMapping("/{tableIds}")
    public AjaxResult remove(@PathVariable Long[] tableIds)
    {
        genTableService.deleteGenTableByIds(tableIds);
        return success();
    }

    /**
     * 预览代码
     */
    @PreAuthorize("@ss.hasPermi('tool:gen:preview')")
    @GetMapping("/preview/{tableId}")
    public AjaxResult preview(@PathVariable("tableId") Long tableId) throws IOException
    {
        Map<String, String> dataMap = genTableService.previewCode(tableId);
        return success(dataMap);
    }

    /**
     * 生成代码（下载方式）
     */
    @PreAuthorize("@ss.hasPermi('tool:gen:code')")
    @Log(title = "代码生成", businessType = BusinessType.GENCODE)
    @GetMapping("/download/{tableName}")
    public void download(HttpServletResponse response, @PathVariable("tableName") String tableName) throws IOException
    {
        byte[] data = genTableService.downloadCode(tableName);
        genCode(response, data);
    }

    /**
     * 生成代码（自定义路径）
     */
    @PreAuthorize("@ss.hasPermi('tool:gen:code')")
    @Log(title = "代码生成", businessType = BusinessType.GENCODE)
    @GetMapping("/genCode/{tableName}")
    public AjaxResult genCode(@PathVariable("tableName") String tableName)
    {
        if (!GenConfig.isAllowOverwrite())
        {
            return AjaxResult.error("【系统预设】不允许生成文件覆盖到本地");
        }
        genTableService.generatorCode(tableName);
        return success();
    }

    /**
     * 同步数据库
     */
    @PreAuthorize("@ss.hasPermi('tool:gen:edit')")
    @Log(title = "代码生成", businessType = BusinessType.UPDATE)
    @GetMapping("/synchDb/{tableName}")
    public AjaxResult synchDb(@PathVariable("tableName") String tableName)
    {
        genTableService.synchDb(tableName);
        return success();
    }

    /**
     * 批量生成代码
     */
    @PreAuthorize("@ss.hasPermi('tool:gen:code')")
    @Log(title = "代码生成", businessType = BusinessType.GENCODE)
    @GetMapping("/batchGenCode")
    public void batchGenCode(HttpServletResponse response, String tables) throws IOException
    {
        String[] tableNames = Convert.toStrArray(tables);
        byte[] data = genTableService.downloadCode(tableNames);
        genCode(response, data);
    }

    /**
     * 生成zip文件
     */
    private void genCode(HttpServletResponse response, byte[] data) throws IOException
    {
        response.reset();
        response.addHeader("Access-Control-Allow-Origin", "*");
        response.addHeader("Access-Control-Expose-Headers", "Content-Disposition");
        response.setHeader("Content-Disposition", "attachment; filename=\"ruoyi.zip\"");
        response.addHeader("Content-Length", "" + data.length);
        response.setContentType("application/octet-stream; charset=UTF-8");
        IOUtils.write(data, response.getOutputStream());
    }

    /**
     * AI调用专用：生成代码返回结构化JSON
     * 无需权限校验，内部使用
     *
     * @param tableName 数据库表名
     * @param moduleName 模块路径，如production/order
     * @param businessName 业务名，生成的类名前缀
     * @param functionName 功能描述，用于生成注释和菜单名称
     * @param author 作者名，默认AI Generator
     * @param genType 生成类型：all（前后端全量）/ backend（仅后端）/ frontend（仅前端），默认all
     * @param tplWebType 前端类型：vue/vue3，默认vue
     * @return 结构化代码结果
     */
    @GetMapping("/api/generate")
    public AjaxResult generateCodeForAi(
            @RequestParam String tableName,
            @RequestParam String moduleName,
            @RequestParam String businessName,
            @RequestParam String functionName,
            @RequestParam(defaultValue = "AI Generator") String author,
            @RequestParam(defaultValue = "all") String genType,
            @RequestParam(defaultValue = "vue") String tplWebType)
    {
        try
        {
            // 1. 检查表是否已经导入，如果没有自动导入
            GenTable genTable = genTableService.selectGenTableByName(tableName);
            if (genTable == null)
            {
                // 自动导入表结构
                List<GenTable> tableList = genTableService.selectDbTableListByNames(new String[]{tableName});
                if (tableList.isEmpty())
                {
                    return error("数据库表不存在：" + tableName);
                }
                genTableService.importGenTable(tableList, tplWebType, author);
                genTable = genTableService.selectGenTableByName(tableName);
            }

            // 2. 更新生成配置
            genTable.setModuleName(moduleName);
            genTable.setBusinessName(businessName);
            genTable.setFunctionName(functionName);
            genTable.setFunctionAuthor(author);
            genTable.setTplWebType(tplWebType);
            genTable.setTplCategory("crud"); // 默认CRUD类型
            genTableService.validateEdit(genTable);
            genTableService.updateGenTable(genTable);

            // 3. 生成代码
            Map<String, String> codeMap = genTableService.previewCode(genTable.getTableId());

            // 4. 分类整理返回结果
            Map<String, Object> result = new HashMap<>();
            Map<String, String> backend = new HashMap<>();
            Map<String, String> frontend = new HashMap<>();
            String sql = "";

            for (Map.Entry<String, String> entry : codeMap.entrySet())
            {
                String key = entry.getKey();
                String value = entry.getValue();

                if (key.startsWith("java/controller/"))
                {
                    backend.put("controller", value);
                }
                else if (key.startsWith("java/service/") && key.endsWith("Impl.java.vm"))
                {
                    backend.put("serviceImpl", value);
                }
                else if (key.startsWith("java/service/"))
                {
                    backend.put("service", value);
                }
                else if (key.startsWith("java/domain/"))
                {
                    backend.put("domain", value);
                }
                else if (key.startsWith("java/mapper/") && key.endsWith("Mapper.java.vm"))
                {
                    backend.put("mapper", value);
                }
                else if (key.startsWith("java/mapper/") && key.endsWith("Mapper.xml.vm"))
                {
                    backend.put("mapperXml", value);
                }
                else if (key.startsWith("vue/") && key.endsWith(".vue.vm"))
                {
                    frontend.put("vue", value);
                }
                else if (key.startsWith("vue/") && key.endsWith(".js.vm"))
                {
                    frontend.put("js", value);
                }
                else if (key.startsWith("sql/"))
                {
                    sql = value;
                }
            }

            // 根据genType过滤结果
            if ("backend".equals(genType))
            {
                result.put("backend", backend);
            }
            else if ("frontend".equals(genType))
            {
                result.put("frontend", frontend);
            }
            else
            {
                result.put("backend", backend);
                result.put("frontend", frontend);
                result.put("sql", sql);
            }

            // 返回路径信息
            Map<String, String> pathInfo = new HashMap<>();
            pathInfo.put("backendPath", "ruoyi-production/src/main/java/com/ruoyi/" + moduleName + "/");
            pathInfo.put("frontendPath", "src/views/" + moduleName + "/");
            result.put("pathInfo", pathInfo);

            return success(result);
        }
        catch (Exception e)
        {
            logger.error("AI生成代码失败：" + e.getMessage(), e);
            return error("生成代码失败：" + e.getMessage());
        }
    }
}