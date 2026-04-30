# MES 项目Agent协作规则（所有Agent必须严格遵守）
## 1. 全局规则
所有Agent在项目中工作时，必须严格遵守本规则，违反规则的产出物将被拒收。

---
## 2. 文档读取规则（渐进式加载）
### 2.1 首次加载必看
Agent启动后仅允许先读取`00_Blueprint.md`，获取全局架构、API路标和文档索引，禁止直接读取其他文档。
### 2.2 按需读取规则
需要具体领域内容时，根据`00_Blueprint.md`中的文档索引，仅读取对应场景的子文档，禁止加载无关文档占用上下文窗口：
| 工作场景 | 需要读取的文档 |
|----------|----------------|
| 架构设计、技术选型 | 00_Blueprint.md + 04_System_Architecture.md |
| 接口开发、联调 | 00_Blueprint.md + 01_Interface_Specification.md |
| 数据库开发、表结构设计 | 00_Blueprint.md + 03_Database_Design.md |
| 项目管理、排期、上线 | 00_Blueprint.md + 02_Project_Plan.md |
| 业务模块开发 | 00_Blueprint.md + 对应模块的详细设计文档（10+序号段） |

### 2.3 命名规范必须遵守
所有文档统一存放于`/docs`目录，文件名严格遵循`[两位数字序号]_[大驼峰文件名].md`格式，禁止使用其他命名格式。

---
## 3. Agent角色分工规则
### 3.1 架构师Agent(01_architect)
- 负责架构设计、模块划分、API路标定义
- 负责更新`00_Blueprint.md`、`04_System_Architecture.md`、`03_Database_Design.md`
- 负责核心技术决策、代码规范制定
### 3.2 产品/需求Agent(00_pm)
- 负责需求拆解、用户故事编写、需求文档维护
- 负责更新`04_Requirement_Specification.md`和各业务模块需求文档
### 3.3 后端开发Agent(03_backend)
- 负责业务模块后端代码开发、接口实现
- 严格遵守`01_Interface_Specification.md`的接口规范
### 3.4 前端开发Agent(04_frontend)
- 负责PC端和移动端页面开发、交互实现
- 严格遵守`00_Blueprint.md`的API路标准则调用接口
### 3.5 DBA Agent(02_dba)
- 负责数据库设计、性能优化、SQL脚本编写
- 严格遵守`03_Database_Design.md`的数据库规范
### 3.6 测试/QA Agent(05_qa)
- 负责测试用例编写、测试执行、Bug跟进
- 基于需求文档和接口规范开展测试工作
### 3.7 代码评审Agent(06_reviewer)
- 负责代码评审、质量把控、规则合规检查
- 所有代码合并前必须经过评审Agent的检查

---
## 4. 产出物规范
### 4.1 代码规范
- 严格遵循RuoYi框架的代码规范、命名规范
- 生产模块代码统一存放于`/ruoyi-source/ruoyi-production/`目录下
- 前端生产模块代码统一存放于`/ruoyi-ui-source/src/views/production/`目录下
### 4.2 文档规范
- 所有新增文档必须遵循命名规范，加入`00_Blueprint.md`的文档索引
- 文档内容必须清晰、可落地，禁止模糊不清的描述
- 涉及接口的文档禁止写入具体的JSON参数，仅保留路标准则
### 4.3 SQL脚本规范
- 所有数据库变更脚本必须存放于`/docs/sql_changes/`目录下
- 脚本命名格式：`YYYYMMDD_描述.sql`，比如`20240520_新增生产模块表.sql`
