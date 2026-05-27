# MES 项目Agent协作规则（所有Agent必须严格遵守）

> 最后更新：2026-05-27
> 变更说明：新增 Absolute Progressive Loading 功能卡读取规则，明确模块文档作为Router、开发级需求以功能卡为准

## 1. 全局规则
所有Agent在项目中工作时，必须严格遵守本规则，违反规则的产出物将被拒收。

---

## 2. 文档读取规则（渐进式加载）
### 2.1 首次加载必看
Agent启动后必须先读取以下3个文件，获取全局架构、协作规则和开发口径：
1. `00_Blueprint.md` — 全局架构、API路标、文档索引
2. `00_Agent_Collaboration_Rules.md` — 本文件，协作规则
3. `IVD_MES整体开发口径.md` — IVD MES定位、系统边界、L0-L10分层、工艺口径、合规口径、集成口径、一期范围

禁止直接读取其他文档。

### 2.2 按需读取规则
需要具体领域内容时，根据`00_Blueprint.md`中的文档索引，仅读取对应场景的子文档，禁止加载无关文档占用上下文窗口：

| 工作场景 | 需要读取的文档 |
|----------|----------------|
| 架构设计、技术选型 | 00_Blueprint.md + 04_System_Architecture.md |
| 接口开发、联调 | 00_Blueprint.md + 01_Interface_Specification.md |
| 数据库开发、表结构设计 | 00_Blueprint.md + 03_Database_Design.md + 对应L层的表清单和字段字典CSV |
| 项目管理、排期、上线 | 00_Blueprint.md + 02_Project_Plan.md |
| 业务模块开发 | 00_Blueprint.md + 对应模块Router（10~22）+ 30_Feature_Card_Index.md + 对应功能卡 |
| 需求确认、变更评审 | 00_Blueprint.md + 00_Requirement_Index.md + 30_Feature_Card_Index.md + 05_Change_Log.md |
| 任务领取、交接 | 00_Blueprint.md + 00_Task_Kanban.md + 00_Progress_Snapshot.md |

### 2.3 Absolute Progressive Loading 功能卡规则
业务模块开发必须采用“Router定位、功能卡落地”的上下文加载方式：
- 模块需求文档`10_*.md`至`22_*.md`只作为Router，负责说明模块边界、核心流程、关联关系和功能卡索引。
- 开发级事实以`30_Feature_Cards/30_FC-*.md`为准，单个任务只加载相关功能卡。
- 定位方式优先使用`rg "REQ-XXX-001" 30_Feature_Cards`或`rg "FC-XXX-001" 30_Feature_Cards`。
- 禁止为了一个开发任务一次性加载全部模块文档、全部字段字典或整个功能卡目录。
- 若功能卡缺少页面字段、交互、接口、验收或异常规则，先补功能卡并同步`30_Feature_Card_Index.md`和对应模块Router，再进入开发。

### 2.4 数据库开发按L层加载规则
涉及数据库开发时，禁止一次加载全部147张表。必须按任务所属的L架构层加载：
- 先加载 `IVD_MES整体开发口径.md` 中对应层的说明
- 再加载相关功能卡声明的候选表
- 最后仅加载候选表在`MES系统基础表逐字段数据字典_按优先级_pgsql.csv`中的字段定义
- 新增表/字段前必须读取`MES数据模型治理规范/`中对应规范，DDL只能输出到`docs/sql_changes/`等待人类执行

### 2.5 命名规范必须遵守
所有文档统一存放于`/docs`目录，文件名严格遵循`[两位数字序号]_[大驼峰文件名].md`格式，禁止使用其他命名格式。
开发级功能卡统一存放于`30_Feature_Cards/`，采用`30_FC-模块-序号_功能标题.md`格式，并在正文保留`card_id`、`module_doc`、`source_section`和`requirements`元数据。

---

## 3. Agent角色分工规则
### 3.1 架构师Agent(01_architect)
- 负责架构设计、模块划分、API路标定义
- 负责更新`00_Blueprint.md`、`04_System_Architecture.md`、`03_Database_Design.md`
- 负责核心技术决策、代码规范制定
- 负责L0-L10架构分层的维护和演进

### 3.2 产品/需求Agent(00_pm)
- 负责需求拆解、用户故事编写、需求文档维护
- 负责更新`00_Requirement_Index.md`、各业务模块Router和`30_Feature_Cards/`开发级功能卡
- 负责一期MVP范围的把控和需求优先级管理

### 3.3 后端开发Agent(03_backend)
- 负责业务模块后端代码开发、接口实现
- 严格遵守`01_Interface_Specification.md`的接口规范
- 代码生成前必须通过`07_代码生成前检查清单`

### 3.4 前端开发Agent(04_frontend)
- 负责PC端和移动端页面开发、交互实现
- 严格遵守`00_Blueprint.md`的API路标准则调用接口

### 3.5 DBA Agent(02_dba)
- 负责数据库设计、性能优化、SQL脚本编写
- 严格遵守`03_Database_Design.md`的数据库规范
- 新增表/字段前必须通过`06_校验规则清单`
- DDL生成必须以`MES系统基础表逐字段数据字典_按优先级_pgsql.csv`为权威来源

### 3.6 测试/QA Agent(05_qa)
- 负责测试用例编写、测试执行、Bug跟进
- 基于需求文档和接口规范开展测试工作

### 3.7 代码评审Agent(06_reviewer)
- 负责代码评审、质量把控、规则合规检查
- 所有代码合并前必须经过评审Agent的检查
- 合规性检查（FDA 21 CFR Part 11、GMP）是评审重点

---

## 4. 产出物规范
### 4.1 代码规范
- 严格遵循RuoYi框架的代码规范、命名规范
- 生产模块代码统一存放于`/ruoyi-source/ruoyi-production/`目录下
- 前端生产模块代码统一存放于`/ruoyi-ui-source/src/views/production/`目录下
- 代码按L层组织包结构：`com.ruoyi.production.{层名}.{模块名}`

### 4.2 文档规范
- 所有新增文档必须遵循命名规范，加入`00_Blueprint.md`的文档索引
- 文档内容必须清晰、可落地，禁止模糊不清的描述
- 涉及接口的文档禁止写入具体的JSON参数，仅保留路标准则

### 4.3 SQL脚本规范
- 所有数据库变更脚本必须存放于`/docs/sql_changes/`目录下
- 脚本命名格式：`YYYYMMDD_描述.sql`
- 脚本必须包含回滚语句
- DDL生成必须以`MES系统基础表逐字段数据字典_按优先级_pgsql.csv`为权威来源

### 4.4 变更记录规范
- 所有数据模型变更必须记录在`05_Change_Log.md`
- 变更编号格式：`DM-YYYYMMDD-序号`
- 修改核心CSV前必须备份
