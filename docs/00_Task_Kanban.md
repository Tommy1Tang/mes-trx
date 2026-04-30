# 任务看板 (Agent 异步消息总线)

## 阶段一：DDL 生成（数据模型 → 建表SQL）
| 任务ID | 角色 | 动作描述 (PM下达) | 状态 | 产物位置 / 依赖 | 验收标准 (DoD) |
| :--- | :--- | :--- | :--- | :--- | :--- |
| [P0]-T01 | 02_dba | 通过06_校验规则清单校验逐字段数据字典 | [DONE] | 产物：`docs/sql_changes/T01_validation_report.md` | 硬性校验PASS，4个dict_code待补充 |
| [P0]-T02 | 02_dba | 生成P0层主数据表DDL（pro_plant_master等8张） | [DONE] | 产物：`docs/sql_changes/20260430_P0_master_tables.sql` | SQL可执行，含ROLLBACK，通过07_代码生成前检查清单 |
| [P0]-T03 | 02_dba | 生成P0层BOM与工艺表DDL | [DONE] | 产物：`docs/sql_changes/20260430_P0_bom_routing_tables.sql` | 同上 |
| [P0]-T04 | 02_dba | 生成P0层工单与执行表DDL | [DONE] | 产物：`docs/sql_changes/20260430_P0_order_execution_tables.sql` | 同上 |
| [P0]-T05 | 02_dba | 生成P0层质量与异常表DDL | [DONE] | 产物：`docs/sql_changes/20260430_P0_quality_exception_tables.sql` | 同上 |
| [P0]-T06 | 02_dba | 生成P0+补充表DDL（排产、派工、报工、工序等16张） | [DONE] | 产物：`docs/sql_changes/20260430_P0_supplement_tables.sql` | 同上 |
| [P0]-T07 | 02_dba | 生成P1/P2层表DDL（38张表） | [DONE] | 产物：`docs/sql_changes/20260430_P1_P2_tables.sql` | 同上 |

## 阶段二：RuoYi 代码生成（DDL → 后端骨架）
| 任务ID | 角色 | 动作描述 (PM下达) | 状态 | 产物位置 / 依赖 | 验收标准 (DoD) |
| :--- | :--- | :--- | :--- | :--- | :--- |
| [P0]-T08 | 03_backend | 主数据表代码生成（Entity/Mapper/Service/Controller） | [TODO] | 依赖：T02完成 → 产物：`ruoyi-source/ruoyi-production/` | 编译通过，符合RuoYi规范 |
| [P0]-T09 | 03_backend | BOM与工艺表代码生成 | [TODO] | 依赖：T03完成 | 同上 |
| [P0]-T10 | 03_backend | 工单与执行表代码生成 | [TODO] | 依赖：T04完成 | 同上 |
| [P0]-T11 | 03_backend | 质量与异常表代码生成 | [TODO] | 依赖：T05完成 | 同上 |
| [P0]-T12 | 03_backend | P0+补充表代码生成 | [TODO] | 依赖：T06完成 | 同上 |

## 阶段三：接口设计（蓝图 → 接口规范）
| 任务ID | 角色 | 动作描述 (PM下达) | 状态 | 产物位置 / 依赖 | 验收标准 (DoD) |
| :--- | :--- | :--- | :--- | :--- | :--- |
| [P0]-T13 | 01_architect | 排产管理模块接口详细设计 | [TODO] | 依赖：T08完成 → 产物：`docs/01_Interface_Specification.md` | 接口定义完整，含请求/响应格式 |
| [P0]-T14 | 01_architect | 生产订单模块接口详细设计 | [TODO] | 依赖：T08完成 | 同上 |
| [P0]-T15 | 01_architect | 物料管理模块接口详细设计 | [TODO] | 依赖：T08完成 | 同上 |
| [P0]-T16 | 01_architect | 派工单管理模块接口详细设计 | [TODO] | 依赖：T08完成 | 同上 |
| [P0]-T17 | 01_architect | 现场报工模块接口详细设计 | [TODO] | 依赖：T08完成 | 同上 |
| [P0]-T18 | 01_architect | 电子批记录模块接口详细设计 | [TODO] | 依赖：T08完成 | 同上 |
| [P0]-T19 | 01_architect | 异常管理模块接口详细设计 | [TODO] | 依赖：T08完成 | 同上 |
| [P0]-T20 | 01_architect | SAP集成模块接口详细设计 | [TODO] | 依赖：T08完成 | 同上 |

## 阶段四：前端脚手架（接口 → Vue页面）
| 任务ID | 角色 | 动作描述 (PM下达) | 状态 | 产物位置 / 依赖 | 验收标准 (DoD) |
| :--- | :--- | :--- | :--- | :--- | :--- |
| [P0]-T21 | 04_frontend | 排产管理模块前端页面搭建 | [TODO] | 依赖：T13完成 → 产物：`ruoyi-ui-source/src/views/production/` | 页面可访问，列表/表单/详情基本可用 |
| [P0]-T22 | 04_frontend | 生产订单模块前端页面搭建 | [TODO] | 依赖：T14完成 | 同上 |
| [P0]-T23 | 04_frontend | 物料管理模块前端页面搭建 | [TODO] | 依赖：T15完成 | 同上 |
| [P0]-T24 | 04_frontend | 派工单管理模块前端页面搭建 | [TODO] | 依赖：T16完成 | 同上 |
| [P0]-T25 | 04_frontend | 现场报工模块前端页面搭建 | [TODO] | 依赖：T17完成 | 同上 |
| [P0]-T26 | 04_frontend | 电子批记录模块前端页面搭建 | [TODO] | 依赖：T18完成 | 同上 |
| [P0]-T27 | 04_frontend | 异常管理模块前端页面搭建 | [TODO] | 依赖：T19完成 | 同上 |
