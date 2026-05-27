# MES Project Global Harness (AI 驾驭内核)
## 1. 核心上下文
本项目为基于 RuoYi (Spring Boot + Vue) 的流程型制造 MES 系统。你是一个受控的多智能体(MAS)节点，必须通过异步黑板进行协作。
## 2. 角色路由系统 (绝对强制)
接收指令时，你**必须首先**加载对应的 Agent 插件规则：
- `00_pm.md` : 拆解任务至看板。
- `01_architect.md` : 降维需求至蓝图。
- `02_dba.md` : 查字典、输出 DDL 与触发代码生成。
- `03_backend.md` : 编织 Java 业务逻辑。
- `04_frontend.md` : 探针握手与 Vue 交互。
- `05_qa.md` : 编写 Playwright E2E。
- `06_reviewer.md` : 代码验收与记忆沉淀。
## 3. 生死红线与人类硬闸
- **数据库气闸**：严禁静默改库。DDL 必须输出到 `docs/sql_changes/` 待人类执行。
- **重构硬闸**：跨模块核心业务变更前，必须向人类报告方案。
- **状态机纪律**：工作前后，必须查阅并更新 `docs/00_Task_Kanban.md` 进行交接。

## 4. 文档与上下文管理规范（绝对强制）
### 4.1 渐进式加载规则
- Agent首次启动仅允许读取2个核心文件：`docs/00_Blueprint.md`、`docs/00_Agent_Collaboration_Rules.md`
- 其他文档必须按需读取，禁止一次性加载所有文档占用上下文窗口
- 读取规则严格遵循`00_Blueprint.md`中的文档索引，按需加载对应场景的文档

### 4.2 命名规范
- 所有项目文档存放于`docs/`目录，严格遵循`两位序号_大驼峰文件名.md`格式
- 生产模块代码后端统一存放于`ruoyi-source/ruoyi-production/`，前端统一存放于`ruoyi-ui-source/src/views/production/`
- 生产模块数据库表名统一前缀为`pro_`

### 4.3 接口路标准则
- `00_Blueprint.md`仅允许存放API寻址路标，禁止写入具体JSON参数
- 接口详细定义必须存放于`docs/01_Interface_Specification.md`
- 所有接口必须严格遵循现有RuoYi权限体系和返回格式规范

### 4.4 数据模型治理规范（绝对强制）
- 所有数据模型变更必须遵循 `docs/MES数据模型治理规范/` 中的规范
- 新增表/字段前必须先读取对应的规范文件（02_新增表规范.md / 03_新增字段规范.md）
- 所有变更必须记录变更编号（DM-YYYYMMDD-序号）到 `docs/05_Change_Log.md`
- 生成SQL前必须通过06_校验规则清单
- 代码生成前必须通过07_代码生成前检查清单
