# 任务看板 (Agent 异步消息总线)

> 最后更新：2026-05-12
> 变更说明：需求口径重大调整（DM-20260512-001），看板重新规划

---

## 阶段零：需求口径调整（已完成）

| 任务ID | 角色 | 动作描述 | 状态 | 产物位置 |
| :--- | :--- | :--- | :--- | :--- |
| [ADJ]-T01 | 全局 | 确认IVD_MES整体开发口径、147表清单、pgsql数据字典 | [DONE] | `docs/IVD_MES整体开发口径.md`、`docs/MES系统基础表清单_按优先级.md` |
| [ADJ]-T02 | 01_architect | 更新全局蓝图（00_Blueprint.md） | [DONE] | `docs/00_Blueprint.md` |
| [ADJ]-T03 | 02_dba | 更新数据库设计规范（03_Database_Design.md） | [DONE] | `docs/03_Database_Design.md` |
| [ADJ]-T04 | 00_pm | 更新进度快照、任务看板、需求索引 | [DONE] | `docs/00_Progress_Snapshot.md`、`docs/00_Task_Kanban.md` |
| [ADJ]-T05 | 01_architect | 更新系统架构（04_System_Architecture.md） | [DONE] | `docs/04_System_Architecture.md` |

---

## 阶段一（旧版）：已完成DDL生成

> 以下任务为旧版85表的DDL生成，已全部完成，产物保持不动。

| 任务ID | 角色 | 动作描述 | 状态 | 产物位置 |
| :--- | :--- | :--- | :--- | :--- |
| [P0]-T01 | 02_dba | 通过06_校验规则清单校验逐字段数据字典 | [DONE] | `docs/sql_changes/T01_validation_report.md` |
| [P0]-T02 | 02_dba | 生成P0层主数据表DDL（8张） | [DONE] | `docs/sql_changes/20260430_P0_master_tables.sql` |
| [P0]-T03 | 02_dba | 生成P0层BOM与工艺表DDL | [DONE] | `docs/sql_changes/20260430_P0_bom_routing_tables.sql` |
| [P0]-T04 | 02_dba | 生成P0层工单与执行表DDL | [DONE] | `docs/sql_changes/20260430_P0_order_execution_tables.sql` |
| [P0]-T05 | 02_dba | 生成P0层质量与异常表DDL | [DONE] | `docs/sql_changes/20260430_P0_quality_exception_tables.sql` |
| [P0]-T06 | 02_dba | 生成P0+补充表DDL（16张） | [DONE] | `docs/sql_changes/20260430_P0_supplement_tables.sql` |
| [P0]-T07 | 02_dba | 生成P1/P2层表DDL（38张） | [DONE] | `docs/sql_changes/20260430_P1_P2_tables.sql` |

---

## 阶段一（新版）：新增表DDL生成

> 新增62张表 + 已有表补充字段，按L层分批生成。以 `docs/MES系统基础表逐字段数据字典_按优先级_pgsql.csv` 为权威来源。

### 批次1：L0 运行时韧性层（6张表，一期MVP必须）

| 任务ID | 角色 | 动作描述 | 状态 | 依赖 | 产物位置 | 验收标准 |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| [L0]-T01 | 02_dba | 比对L0层6张表与已有DDL，确认哪些是新增 | [TODO] | 无 | `docs/sql_changes/L0_gap_analysis.md` | 逐表比对完成 |
| [L0]-T02 | 02_dba | 生成L0层DDL（pro_mbr_execution_context等6张） | [TODO] | T01完成 | `docs/sql_changes/20260512_L0_runtime_tables.sql` | SQL可执行，含ROLLBACK |

### 批次2：L1 主数据补充层（~12张表，一期MVP必须）

| 任务ID | 角色 | 动作描述 | 状态 | 依赖 | 产物位置 | 验收标准 |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| [L1]-T01 | 02_dba | 比对L1层20张表与已有DDL，确认新增表清单 | [TODO] | 无 | `docs/sql_changes/L1_gap_analysis.md` | 逐表比对完成 |
| [L1]-T02 | 02_dba | 生成L1新增表DDL（工装/夹具/供应商/人员资质/环境区域/公用工程/停机原因等） | [TODO] | T01完成 | `docs/sql_changes/20260512_L1_master_supplement.sql` | SQL可执行，含ROLLBACK |

### 批次3：L2 MBR模板层（~26张表，一期MVP核心）

| 任务ID | 角色 | 动作描述 | 状态 | 依赖 | 产物位置 | 验收标准 |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| [L2]-T01 | 02_dba | 比对L2层31张表与已有DDL，确认新增表清单 | [TODO] | 无 | `docs/sql_changes/L2_gap_analysis.md` | 逐表比对完成 |
| [L2]-T02 | 02_dba | 生成L2新增表DDL（MBR模板域全部 + BOM替代/切换 + 工艺资源/文档/检验） | [TODO] | T01完成 | `docs/sql_changes/20260512_L2_mbr_routing_tables.sql` | SQL可执行，含ROLLBACK |

### 批次4：L3 执行规则层（~9张表，一期MVP必须）

| 任务ID | 角色 | 动作描述 | 状态 | 依赖 | 产物位置 | 验收标准 |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| [L3]-T01 | 02_dba | 比对L3层10张表与已有DDL，确认新增表清单 | [TODO] | 无 | `docs/sql_changes/L3_gap_analysis.md` | 逐表比对完成 |
| [L3]-T02 | 02_dba | 生成L3新增表DDL（执行规则/联锁/防错/ECN/版本差异） | [TODO] | T01完成 | `docs/sql_changes/20260512_L3_rule_interlock_tables.sql` | SQL可执行，含ROLLBACK |

### 批次5：L5 现场执行补充层（~11张表，一期MVP必须）

| 任务ID | 角色 | 动作描述 | 状态 | 依赖 | 产物位置 | 验收标准 |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| [L5]-T01 | 02_dba | 比对L5层16张表与已有DDL，确认新增表清单 | [TODO] | 无 | `docs/sql_changes/L5_gap_analysis.md` | 逐表比对完成 |
| [L5]-T02 | 02_dba | 生成L5新增表DDL（称量/天平点检/称量审计/清场/EBR/过程监控） | [TODO] | T01完成 | `docs/sql_changes/20260512_L5_weighing_ebr_tables.sql` | SQL可执行，含ROLLBACK |

### 批次6：L7 OT/SCADA层（16张表，按设备接入成熟度渐进）

| 任务ID | 角色 | 动作描述 | 状态 | 依赖 | 产物位置 | 验收标准 |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| [L7]-T01 | 02_dba | 生成L7层全部DDL（SCADA系统/设备映射/采集点位/告警/OEE/环境/冷链/CIP-SIP） | [TODO] | 无 | `docs/sql_changes/20260512_L7_scada_environment_tables.sql` | SQL可执行，含ROLLBACK |

### 批次7：L8 追溯仓储层（~9张表）

| 任务ID | 角色 | 动作描述 | 状态 | 依赖 | 产物位置 | 验收标准 |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| [L8]-T01 | 02_dba | 比对L8层10张表与已有DDL，确认新增表清单 | [TODO] | 无 | `docs/sql_changes/L8_gap_analysis.md` | 逐表比对完成 |
| [L8]-T02 | 02_dba | 生成L8新增表DDL（收货/序列号/WIP/成品/族谱） | [TODO] | T01完成 | `docs/sql_changes/20260512_L8_traceability_tables.sql` | SQL可执行，含ROLLBACK |

### 批次8：L9 集成补充层（~4张表）

| 任务ID | 角色 | 动作描述 | 状态 | 依赖 | 产物位置 | 验收标准 |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| [L9]-T01 | 02_dba | 比对L9层21张表与已有DDL，确认新增表清单 | [TODO] | 无 | `docs/sql_changes/L9_gap_analysis.md` | 逐表比对完成 |
| [L9]-T02 | 02_dba | 生成L9新增表DDL（接口消息/报工回传/检验回传/投料过账） | [TODO] | T01完成 | `docs/sql_changes/20260512_L9_integration_supplement.sql` | SQL可执行，含ROLLBACK |

### 批次9：L10 仿真层（2张表，不阻塞一期）

| 任务ID | 角色 | 动作描述 | 状态 | 依赖 | 产物位置 | 验收标准 |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| [L10]-T01 | 02_dba | 生成L10层DDL（仿真方案/结果） | [TODO] | 无 | `docs/sql_changes/20260512_L10_simulation_tables.sql` | SQL可执行，含ROLLBACK |

---

## 阶段二：RuoYi 代码生成（DDL → 后端骨架）

> 一期MVP聚焦配液称量+电子批记录闭环，优先生成L0/L1/L2/L3/L4/L5/L6相关代码。

| 任务ID | 角色 | 动作描述 | 状态 | 依赖 | 产物位置 | 验收标准 |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| [CODE]-T01 | 03_backend | L0运行时韧性层代码生成 | [TODO] | [L0]-T02 | `ruoyi-source/ruoyi-production/` | 编译通过 |
| [CODE]-T02 | 03_backend | L1主数据层代码生成 | [TODO] | [L1]-T02 | 同上 | 编译通过 |
| [CODE]-T03 | 03_backend | L2工艺MBR层代码生成 | [TODO] | [L2]-T02 | 同上 | 编译通过 |
| [CODE]-T04 | 03_backend | L3执行规则层代码生成 | [TODO] | [L3]-T02 | 同上 | 编译通过 |
| [CODE]-T05 | 03_backend | L4计划订单层代码生成 | [TODO] | 已有DDL | 同上 | 编译通过 |
| [CODE]-T06 | 03_backend | L5现场执行层代码生成 | [TODO] | [L5]-T02 | 同上 | 编译通过 |
| [CODE]-T07 | 03_backend | L6质量异常层代码生成 | [TODO] | 已有DDL | 同上 | 编译通过 |
| [CODE]-T08 | 03_backend | L7 OT/SCADA层代码生成 | [TODO] | [L7]-T01 | 同上 | 编译通过 |
| [CODE]-T09 | 03_backend | L8追溯仓储层代码生成 | [TODO] | [L8]-T02 | 同上 | 编译通过 |
| [CODE]-T10 | 03_backend | L9集成层代码生成 | [TODO] | [L9]-T02 | 同上 | 编译通过 |
| [CODE]-T11 | 03_backend | L10仿真层代码生成 | [TODO] | [L10]-T01 | 同上 | 编译通过 |

---

## 阶段三：接口设计（蓝图 → 接口规范）

> 一期MVP优先设计配液称量+EBR相关接口。

| 任务ID | 角色 | 动作描述 | 状态 | 依赖 | 产物位置 | 验收标准 |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| [API]-T01 | 01_architect | 主数据模块接口设计 | [TODO] | [CODE]-T02 | `docs/01_Interface_Specification.md` | 接口定义完整 |
| [API]-T02 | 01_architect | BOM/工艺/MBR模板接口设计 | [TODO] | [CODE]-T03 | 同上 | 接口定义完整 |
| [API]-T03 | 01_architect | 执行规则与联锁接口设计 | [TODO] | [CODE]-T04 | 同上 | 接口定义完整 |
| [API]-T04 | 01_architect | 生产订单与排产接口设计 | [TODO] | [CODE]-T05 | 同上 | 接口定义完整 |
| [API]-T05 | 01_architect | 配液称量+EBR接口设计（**一期MVP重点**） | [TODO] | [CODE]-T06 | 同上 | 接口定义完整 |
| [API]-T06 | 01_architect | 质量异常+合规审计接口设计 | [TODO] | [CODE]-T07 | 同上 | 接口定义完整 |
| [API]-T07 | 01_architect | OT/SCADA+环境冷链接口设计 | [TODO] | [CODE]-T08 | 同上 | 接口定义完整 |
| [API]-T08 | 01_architect | 批次追溯接口设计 | [TODO] | [CODE]-T09 | 同上 | 接口定义完整 |
| [API]-T09 | 01_architect | SAP集成+接口运营接口设计 | [TODO] | [CODE]-T10 | 同上 | 接口定义完整 |

---

## 阶段四：前端脚手架（接口 → Vue页面）

> 一期MVP优先搭建配液称量+EBR相关页面。

| 任务ID | 角色 | 动作描述 | 状态 | 依赖 | 产物位置 | 验收标准 |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| [FE]-T01 | 04_frontend | 主数据管理页面 | [TODO] | [API]-T01 | `ruoyi-ui-source/src/views/production/` | 页面可访问 |
| [FE]-T02 | 04_frontend | BOM/工艺/MBR模板页面 | [TODO] | [API]-T02 | 同上 | 页面可访问 |
| [FE]-T03 | 04_frontend | 生产订单与排产页面 | [TODO] | [API]-T04 | 同上 | 页面可访问 |
| [FE]-T04 | 04_frontend | **配液称量+EBR页面（一期MVP重点）** | [TODO] | [API]-T05 | 同上 | 页面可访问 |
| [FE]-T05 | 04_frontend | 质量异常+合规审计页面 | [TODO] | [API]-T06 | 同上 | 页面可访问 |
| [FE]-T06 | 04_frontend | 执行规则与联锁配置页面 | [TODO] | [API]-T03 | 同上 | 页面可访问 |
| [FE]-T07 | 04_frontend | OT/SCADA监控页面 | [TODO] | [API]-T07 | 同上 | 页面可访问 |
| [FE]-T08 | 04_frontend | 批次追溯页面 | [TODO] | [API]-T08 | 同上 | 页面可访问 |

---

## 任务依赖总览

```
阶段一DDL生成（按L层分批）
    ├── [L0]-T01/T02 ──→ [CODE]-T01 ──→ 运行时韧性（贯穿所有）
    ├── [L1]-T01/T02 ──→ [CODE]-T02 ──→ [API]-T01 ──→ [FE]-T01
    ├── [L2]-T01/T02 ──→ [CODE]-T03 ──→ [API]-T02 ──→ [FE]-T02
    ├── [L3]-T01/T02 ──→ [CODE]-T04 ──→ [API]-T03 ──→ [FE]-T06
    ├── 已有DDL    ──→ [CODE]-T05 ──→ [API]-T04 ──→ [FE]-T03
    ├── [L5]-T01/T02 ──→ [CODE]-T06 ──→ [API]-T05 ──→ [FE]-T04 ★MVP重点
    ├── 已有DDL    ──→ [CODE]-T07 ──→ [API]-T06 ──→ [FE]-T05
    ├── [L7]-T01     ──→ [CODE]-T08 ──→ [API]-T07 ──→ [FE]-T07
    ├── [L8]-T01/T02 ──→ [CODE]-T09 ──→ [API]-T08 ──→ [FE]-T08
    └── [L9]-T01/T02 ──→ [CODE]-T10 ──→ [API]-T09
```
