# 开发级功能需求卡索引

> 本索引用于 Absolute Progressive Loading。模块文档负责路由，功能卡负责开发级事实。
> 最后更新：2026-05-27，新增批次归属与功能卡状态管理

## 1. 加载规则
- 通过 `card_id`、`REQ-*`、表名或模块文档名精确检索。
- 单次开发任务只加载相关功能卡，不加载全部模块文档。
- 字段以数据字典为准，接口以 `01_Interface_Specification.md` 对应小节为准。
- 新增或修改功能卡后，应同步本索引和对应模块 Router。

## 2. 功能卡状态定义
状态流转：`待确定` → `待沟通` → `沟通中` → `已沟通` → `开发中` → `已完成`

| 状态 | 含义 |
|------|------|
| 待确定 | 需求尚不明确，需要业务方进一步澄清 |
| 待沟通 | 需求基本明确，等待批次排期后与业务方评审确认 |
| 沟通中 | 正在与业务方进行功能卡评审 |
| 已沟通 | 业务方已确认，可以进入开发 |
| 开发中 | 后端/前端正在按功能卡实现 |
| 已完成 | 代码已开发、测试已通过、评审已验收 |

## 3. 开发批次与功能卡列表
| 功能卡ID | 批次 | 来源模块 | 功能卡 | 覆盖需求 | 文件 | 状态 |
|----------|------|----------|--------|----------|------|--------|
| FC-MDM-001 | 批次2 | 10_主数据管理模块需求文档.md | 工厂与组织 | REQ-MDM-001, REQ-MDM-002, REQ-MDM-003, REQ-MDM-004 | 30_Feature_Cards/30_FC-MDM-001_工厂与组织.md | 待沟通 |
| FC-MDM-002 | 批次2 | 10_主数据管理模块需求文档.md | 物料与供应商 | REQ-MDM-005, REQ-MDM-006 | 30_Feature_Cards/30_FC-MDM-002_物料与供应商.md | 待沟通 |
| FC-MDM-003 | 批次2 | 10_主数据管理模块需求文档.md | 设备与工装 | REQ-MDM-007, REQ-MDM-008, REQ-MDM-009 | 30_Feature_Cards/30_FC-MDM-003_设备与工装.md | 待沟通 |
| FC-MDM-004 | 批次2 | 10_主数据管理模块需求文档.md | 人员与资质 | REQ-MDM-010, REQ-MDM-011, REQ-MDM-012, REQ-MDM-013 | 30_Feature_Cards/30_FC-MDM-004_人员与资质.md | 待沟通 |
| FC-MDM-005 | 批次2 | 10_主数据管理模块需求文档.md | 仓储 | REQ-MDM-014, REQ-MDM-015 | 30_Feature_Cards/30_FC-MDM-005_仓储.md | 待沟通 |
| FC-MDM-006 | 批次2 | 10_主数据管理模块需求文档.md | 班次与日历 | REQ-MDM-016, REQ-MDM-017 | 30_Feature_Cards/30_FC-MDM-006_班次与日历.md | 待沟通 |
| FC-MDM-007 | 批次2 | 10_主数据管理模块需求文档.md | 环境与公用工程 | REQ-MDM-018, REQ-MDM-019, REQ-MDM-020 | 30_Feature_Cards/30_FC-MDM-007_环境与公用工程.md | 待沟通 |
| FC-BOM-001 | 批次3 | 11_BOM与工艺路线模块需求文档.md | BOM管理 | REQ-BOM-001, REQ-BOM-002, REQ-BOM-003, REQ-BOM-004 | 30_Feature_Cards/30_FC-BOM-001_BOM管理.md | 待确定 |
| FC-BOM-002 | 批次3 | 11_BOM与工艺路线模块需求文档.md | BOM替代与切换 | REQ-BOM-005, REQ-BOM-006, REQ-BOM-007, REQ-BOM-008 | 30_Feature_Cards/30_FC-BOM-002_BOM替代与切换.md | 待确定 |
| FC-ROUTE-001 | 批次3 | 11_BOM与工艺路线模块需求文档.md | 工艺路线管理 | REQ-ROUTE-001, REQ-ROUTE-002, REQ-ROUTE-003, REQ-ROUTE-004, REQ-ROUTE-005, REQ-ROUTE-006, REQ-ROUTE-007 | 30_Feature_Cards/30_FC-ROUTE-001_工艺路线管理.md | 待确定 |
| FC-ROUTE-002 | 批次3 | 11_BOM与工艺路线模块需求文档.md | 检验方案管理 | REQ-ROUTE-008, REQ-ROUTE-009, REQ-ROUTE-010 | 30_Feature_Cards/30_FC-ROUTE-002_检验方案管理.md | 待确定 |
| FC-MBR-001 | 批次4 | 12_MBR模板管理模块需求文档.md | MBR镜像头与版本 | REQ-MBR-001, REQ-MBR-002, REQ-MBR-003, REQ-MBR-004 | 30_Feature_Cards/30_FC-MBR-001_MBR镜像头与版本.md | 待确定 |
| FC-MBR-002 | 批次4 | 12_MBR模板管理模块需求文档.md | MBR阶段与步骤 | REQ-MBR-005, REQ-MBR-006, REQ-MBR-007 | 30_Feature_Cards/30_FC-MBR-002_MBR阶段与步骤.md | 待确定 |
| FC-MBR-003 | 批次4 | 12_MBR模板管理模块需求文档.md | MBR步骤参数 | REQ-MBR-008, REQ-MBR-009 | 30_Feature_Cards/30_FC-MBR-003_MBR步骤参数.md | 待确定 |
| FC-MBR-004 | 批次4 | 12_MBR模板管理模块需求文档.md | MBR步骤物料 | REQ-MBR-010, REQ-MBR-011 | 30_Feature_Cards/30_FC-MBR-004_MBR步骤物料.md | 待确定 |
| FC-MBR-005 | 批次4 | 12_MBR模板管理模块需求文档.md | MBR步骤设备 | REQ-MBR-012, REQ-MBR-013 | 30_Feature_Cards/30_FC-MBR-005_MBR步骤设备.md | 待确定 |
| FC-MBR-006 | 批次4 | 12_MBR模板管理模块需求文档.md | MBR步骤质控 | REQ-MBR-014, REQ-MBR-015 | 30_Feature_Cards/30_FC-MBR-006_MBR步骤质控.md | 待确定 |
| FC-MBR-007 | 批次4 | 12_MBR模板管理模块需求文档.md | MBR步骤流转规则 | REQ-MBR-016, REQ-MBR-017, REQ-MBR-018, REQ-MBR-019 | 30_Feature_Cards/30_FC-MBR-007_MBR步骤流转规则.md | 待确定 |
| FC-MBR-008 | 批次4 | 12_MBR模板管理模块需求文档.md | MBR返工与动态参数 | REQ-MBR-020, REQ-MBR-021, REQ-MBR-022 | 30_Feature_Cards/30_FC-MBR-008_MBR返工与动态参数.md | 待确定 |
| FC-MBR-009 | 批次4 | 12_MBR模板管理模块需求文档.md | MBR人员与替代工艺 | REQ-MBR-023, REQ-MBR-024, REQ-MBR-025 | 30_Feature_Cards/30_FC-MBR-009_MBR人员与替代工艺.md | 待确定 |
| FC-MBR-010 | 批次4 | 12_MBR模板管理模块需求文档.md | PLM MBR接收、Excel批导与执行快照 | REQ-MBR-026, REQ-MBR-027, REQ-MBR-028, REQ-MBR-029, REQ-MBR-030, REQ-MBR-031, REQ-MBR-032 | 30_Feature_Cards/30_FC-MBR-010_PLM_MBR接收、Excel批导与执行快照.md | 待确定 |
| FC-RULE-001 | 批次5 | 13_执行规则与联锁模块需求文档.md | 执行规则 | REQ-RULE-001, REQ-RULE-002, REQ-RULE-003 | 30_Feature_Cards/30_FC-RULE-001_执行规则.md | 待确定 |
| FC-RULE-002 | 批次5 | 13_执行规则与联锁模块需求文档.md | 联锁规则 | REQ-RULE-004, REQ-RULE-005, REQ-RULE-006 | 30_Feature_Cards/30_FC-RULE-002_联锁规则.md | 待确定 |
| FC-RULE-003 | 批次5 | 13_执行规则与联锁模块需求文档.md | 防错校验 | REQ-RULE-007, REQ-RULE-008 | 30_Feature_Cards/30_FC-RULE-003_防错校验.md | 待确定 |
| FC-RULE-004 | 批次5 | 13_执行规则与联锁模块需求文档.md | 设备指令 | REQ-RULE-009 | 30_Feature_Cards/30_FC-RULE-004_设备指令.md | 待确定 |
| FC-RULE-005 | 批次5 | 13_执行规则与联锁模块需求文档.md | MBR版本发布 | REQ-RULE-010, REQ-RULE-011 | 30_Feature_Cards/30_FC-RULE-005_MBR版本发布.md | 待确定 |
| FC-RULE-006 | 批次5 | 13_执行规则与联锁模块需求文档.md | MBR变更管理 | REQ-RULE-012, REQ-RULE-013 | 30_Feature_Cards/30_FC-RULE-006_MBR变更管理.md | 待确定 |
| FC-RULE-007 | 批次5 | 13_执行规则与联锁模块需求文档.md | 工程变更通知（ECN） | REQ-RULE-014, REQ-RULE-015, REQ-RULE-016 | 30_Feature_Cards/30_FC-RULE-007_工程变更通知（ECN）.md | 待确定 |
| FC-RULE-008 | 批次5 | 13_执行规则与联锁模块需求文档.md | MBR版本差异对比 | REQ-RULE-017 | 30_Feature_Cards/30_FC-RULE-008_MBR版本差异对比.md | 待确定 |
| FC-ORDER-001 | 批次6 | 14_生产订单与排产模块需求文档.md | 生产工单 | REQ-ORDER-001, REQ-ORDER-002, REQ-ORDER-003, REQ-ORDER-004, REQ-ORDER-005, REQ-ORDER-006, REQ-ORDER-007, REQ-ORDER-008, REQ-ORDER-009, REQ-ORDER-010, REQ-ORDER-011 | 30_Feature_Cards/30_FC-ORDER-001_生产工单.md | 待确定 |
| FC-SCH-001 | 批次6 | 14_生产订单与排产模块需求文档.md | 排产管理 | REQ-SCH-001, REQ-SCH-002, REQ-SCH-003, REQ-SCH-004, REQ-SCH-005, REQ-SCH-006, REQ-SCH-007, REQ-SCH-008, REQ-SCH-009 | 30_Feature_Cards/30_FC-SCH-001_排产管理.md | 待确定 |
| FC-DISP-001 | 批次6 | 14_生产订单与排产模块需求文档.md | 派工管理 | REQ-DISP-001, REQ-DISP-002, REQ-DISP-003, REQ-DISP-004, REQ-DISP-005, REQ-DISP-006, REQ-DISP-007, REQ-DISP-008, REQ-DISP-009, REQ-DISP-010, REQ-DISP-011, REQ-DISP-012 | 30_Feature_Cards/30_FC-DISP-001_派工管理.md | 待确定 |
| FC-KIT-001 | 批次6 | 14_生产订单与排产模块需求文档.md | 配套生产计划 | REQ-KIT-001, REQ-KIT-002, REQ-KIT-003, REQ-KIT-004, REQ-KIT-005, REQ-KIT-006, REQ-KIT-007, REQ-KIT-008 | 30_Feature_Cards/30_FC-KIT-001_配套生产计划.md | 待确定 |
| FC-RPT-001 | 批次7 | 15_派工与现场执行模块需求文档.md | 派工执行 | REQ-RPT-001, REQ-RPT-002, REQ-RPT-003 | 30_Feature_Cards/30_FC-RPT-001_派工执行.md | 待确定 |
| FC-RPT-002 | 批次7 | 15_派工与现场执行模块需求文档.md | 工序执行 | REQ-RPT-004, REQ-RPT-005, REQ-RPT-006 | 30_Feature_Cards/30_FC-RPT-002_工序执行.md | 待确定 |
| FC-RPT-003 | 批次7 | 15_派工与现场执行模块需求文档.md | 报工 | REQ-RPT-007, REQ-RPT-008, REQ-RPT-009, REQ-RPT-010, REQ-RPT-011, REQ-RPT-012, REQ-RPT-013 | 30_Feature_Cards/30_FC-RPT-003_报工.md | 待确定 |
| FC-RPT-004 | 批次7 | 15_派工与现场执行模块需求文档.md | 过程监控 | REQ-RPT-014, REQ-RPT-015, REQ-RPT-016, REQ-RPT-017 | 30_Feature_Cards/30_FC-RPT-004_过程监控.md | 待确定 |
| FC-RPT-005 | 批次7 | 15_派工与现场执行模块需求文档.md | 离线支持 | REQ-RPT-018 | 30_Feature_Cards/30_FC-RPT-005_离线支持.md | 待确定 |
| FC-DISP-002 | 批次6 | 15_派工与现场执行模块需求文档.md | 派工单模板化执行 | REQ-DISP-006, REQ-DISP-007, REQ-DISP-010, REQ-DISP-011, REQ-DISP-012 | 30_Feature_Cards/30_FC-DISP-002_派工单模板化执行.md | 待确定 |
| FC-WEI-001 | 批次7 | 16_称量与投料模块需求文档.md | 投料管理 | REQ-WEI-001, REQ-WEI-002, REQ-WEI-003, REQ-WEI-004, REQ-WEI-005 | 30_Feature_Cards/30_FC-WEI-001_投料管理.md | 待确定 |
| FC-WEI-002 | 批次7 | 16_称量与投料模块需求文档.md | 退料管理 | REQ-WEI-006, REQ-WEI-007, REQ-WEI-008, REQ-WEI-009 | 30_Feature_Cards/30_FC-WEI-002_退料管理.md | 待确定 |
| FC-WEI-003 | 批次7 | 16_称量与投料模块需求文档.md | 电子天平点检 | REQ-WEI-010, REQ-WEI-011, REQ-WEI-012 | 30_Feature_Cards/30_FC-WEI-003_电子天平点检.md | 待确定 |
| FC-WEI-004 | 批次7 | 16_称量与投料模块需求文档.md | 称量记录 | REQ-WEI-013, REQ-WEI-014, REQ-WEI-015, REQ-WEI-016, REQ-WEI-017 | 30_Feature_Cards/30_FC-WEI-004_称量记录.md | 待确定 |
| FC-WEI-005 | 批次7 | 16_称量与投料模块需求文档.md | 称量审计 | REQ-WEI-018, REQ-WEI-019 | 30_Feature_Cards/30_FC-WEI-005_称量审计.md | 待确定 |
| FC-LSW-001 | 批次7 | 16_称量与投料模块需求文档.md | 线边仓与生产领料 | REQ-LSW-001, REQ-LSW-002, REQ-LSW-003, REQ-LSW-004, REQ-LSW-005, REQ-LSW-006, REQ-LSW-007, REQ-LSW-008, REQ-LSW-011, REQ-LSW-012 | 30_Feature_Cards/30_FC-LSW-001_线边仓与生产领料.md | 待确定 |
| FC-BAL-001 | 批次7 | 16_称量与投料模块需求文档.md | 物料平衡 | REQ-BAL-001, REQ-BAL-002, REQ-BAL-003, REQ-BAL-004, REQ-BAL-005 | 30_Feature_Cards/30_FC-BAL-001_物料平衡.md | 待确定 |
| FC-EBR-001 | 批次8 | 17_电子批记录模块需求文档.md | EBR头管理 | REQ-EBR-001, REQ-EBR-002, REQ-EBR-003 | 30_Feature_Cards/30_FC-EBR-001_EBR头管理.md | 待确定 |
| FC-EBR-002 | 批次8 | 17_电子批记录模块需求文档.md | EBR步骤记录 | REQ-EBR-004, REQ-EBR-005, REQ-EBR-006, REQ-EBR-007 | 30_Feature_Cards/30_FC-EBR-002_EBR步骤记录.md | 待确定 |
| FC-EBR-003 | 批次8 | 17_电子批记录模块需求文档.md | EBR参数记录 | REQ-EBR-008, REQ-EBR-009, REQ-EBR-010 | 30_Feature_Cards/30_FC-EBR-003_EBR参数记录.md | 待确定 |
| FC-EBR-004 | 批次8 | 17_电子批记录模块需求文档.md | 清场检查 | REQ-EBR-011, REQ-EBR-012, REQ-EBR-013 | 30_Feature_Cards/30_FC-EBR-004_清场检查.md | 待确定 |
| FC-EBR-005 | 批次8 | 17_电子批记录模块需求文档.md | 批记录审核 | REQ-EBR-014, REQ-EBR-015, REQ-EBR-016 | 30_Feature_Cards/30_FC-EBR-005_批记录审核.md | 待确定 |
| FC-EBR-006 | 批次8 | 17_电子批记录模块需求文档.md | 批记录放行与归档 | REQ-EBR-017, REQ-EBR-018, REQ-EBR-019 | 30_Feature_Cards/30_FC-EBR-006_批记录放行与归档.md | 待确定 |
| FC-EBR-007 | 批次8 | 17_电子批记录模块需求文档.md | 收率与差异分析 | REQ-EBR-020, REQ-EBR-021, REQ-EBR-022 | 30_Feature_Cards/30_FC-EBR-007_收率与差异分析.md | 待确定 |
| FC-FORM-001 | 批次8 | 17_电子批记录模块需求文档.md | 电子表单平台 | REQ-FORM-001, REQ-FORM-002, REQ-FORM-003, REQ-FORM-004, REQ-FORM-005, REQ-FORM-006, REQ-FORM-007 | 30_Feature_Cards/30_FC-FORM-001_电子表单平台.md | 待确定 |
| FC-DHR-001 | 批次8 | 17_电子批记录模块需求文档.md | DHR模板与汇总 | REQ-DHR-001, REQ-DHR-002, REQ-DHR-003, REQ-DHR-004, REQ-DHR-005, REQ-DHR-006, REQ-DHR-007, REQ-DHR-008, REQ-DHR-009, REQ-DHR-010, REQ-DHR-011, REQ-DHR-012 | 30_Feature_Cards/30_FC-DHR-001_DHR模板与汇总.md | 待确定 |
| FC-WF-001 | 批次8 | 17_电子批记录模块需求文档.md | 流程与编码支撑 | REQ-WF-001, REQ-WF-002, REQ-WF-003, REQ-WF-004, REQ-WF-006, REQ-WF-007 | 30_Feature_Cards/30_FC-WF-001_流程与编码支撑.md | 待确定 |
| FC-EXC-001 | 批次9 | 18_异常管理与合规审计模块需求文档.md | 异常管理 | REQ-EXC-001, REQ-EXC-002, REQ-EXC-003, REQ-EXC-004, REQ-EXC-005, REQ-EXC-006, REQ-EXC-007, REQ-EXC-008, REQ-EXC-009, REQ-EXC-010, REQ-EXC-011 | 30_Feature_Cards/30_FC-EXC-001_异常管理.md | 待确定 |
| FC-QUA-001 | 批次9 | 18_异常管理与合规审计模块需求文档.md | 质量管理 | REQ-QUA-001, REQ-QUA-002, REQ-QUA-003, REQ-QUA-004, REQ-QUA-005, REQ-QUA-006, REQ-QUA-007, REQ-QUA-008 | 30_Feature_Cards/30_FC-QUA-001_质量管理.md | 待确定 |
| FC-CMP-001 | 批次9 | 18_异常管理与合规审计模块需求文档.md | 电子签名 | REQ-CMP-001, REQ-CMP-002, REQ-CMP-003, REQ-CMP-004, REQ-CMP-005 | 30_Feature_Cards/30_FC-CMP-001_电子签名.md | 待确定 |
| FC-CMP-002 | 批次9 | 18_异常管理与合规审计模块需求文档.md | 审计追踪 | REQ-CMP-006, REQ-CMP-007, REQ-CMP-008, REQ-CMP-009, REQ-CMP-010 | 30_Feature_Cards/30_FC-CMP-002_审计追踪.md | 待确定 |
| FC-TRC-001 | 批次11 | 19_批次追溯模块需求文档.md | 物料批次管理 | REQ-TRC-001, REQ-TRC-002, REQ-TRC-003 | 30_Feature_Cards/30_FC-TRC-001_物料批次管理.md | 待确定 |
| FC-TRC-002 | 批次11 | 19_批次追溯模块需求文档.md | 来料收货 | REQ-TRC-004, REQ-TRC-005, REQ-TRC-006 | 30_Feature_Cards/30_FC-TRC-002_来料收货.md | 待确定 |
| FC-TRC-003 | 批次11 | 19_批次追溯模块需求文档.md | 序列号管理 | REQ-TRC-007, REQ-TRC-008 | 30_Feature_Cards/30_FC-TRC-003_序列号管理.md | 待确定 |
| FC-TRC-004 | 批次11 | 19_批次追溯模块需求文档.md | 在制品管理 | REQ-TRC-009, REQ-TRC-010 | 30_Feature_Cards/30_FC-TRC-004_在制品管理.md | 待确定 |
| FC-TRC-005 | 批次11 | 19_批次追溯模块需求文档.md | 成品管理 | REQ-TRC-011, REQ-TRC-012 | 30_Feature_Cards/30_FC-TRC-005_成品管理.md | 待确定 |
| FC-TRC-006 | 批次11 | 19_批次追溯模块需求文档.md | 批次族谱 | REQ-TRC-013, REQ-TRC-014, REQ-TRC-015, REQ-TRC-016, REQ-TRC-017 | 30_Feature_Cards/30_FC-TRC-006_批次族谱.md | 待确定 |
| FC-TRC-007 | 批次11 | 19_批次追溯模块需求文档.md | 配套计划追溯与量值溯源 | REQ-TRC-018, REQ-TRC-019, REQ-TRC-020, REQ-TRC-021, REQ-TRC-022, REQ-TRC-023 | 30_Feature_Cards/30_FC-TRC-007_配套计划追溯与量值溯源.md | 待确定 |
| FC-TRC-008 | 批次11 | 19_批次追溯模块需求文档.md | 线边仓追溯 | REQ-TRC-024, REQ-TRC-025, REQ-TRC-026 | 30_Feature_Cards/30_FC-TRC-008_线边仓追溯.md | 待确定 |
| FC-SAP-001 | 批次12 | 20_系统集成模块需求文档.md | SAP集成 | REQ-SAP-001, REQ-SAP-002, REQ-SAP-003, REQ-SAP-004, REQ-SAP-005, REQ-SAP-006, REQ-SAP-007, REQ-SAP-008, REQ-SAP-009, REQ-SAP-010 | 30_Feature_Cards/30_FC-SAP-001_SAP集成.md | 待确定 |
| FC-PLM-001 | 批次12 | 20_系统集成模块需求文档.md | PLM/文控集成 | REQ-PLM-001, REQ-PLM-002, REQ-PLM-003, REQ-PLM-004, REQ-PLM-005, REQ-PLM-006 | 30_Feature_Cards/30_FC-PLM-001_PLM文控集成.md | 待确定 |
| FC-WMS-001 | 批次12 | 20_系统集成模块需求文档.md | WMS与线边仓集成 | REQ-WMS-001, REQ-WMS-002, REQ-WMS-003, REQ-WMS-004, REQ-WMS-005, REQ-WMS-006, REQ-WMS-007, REQ-WMS-008 | 30_Feature_Cards/30_FC-WMS-001_WMS与线边仓集成.md | 待确定 |
| FC-OA-001 | 批次12 | 20_系统集成模块需求文档.md | OA集成 | REQ-OA-001, REQ-OA-002, REQ-OA-003 | 30_Feature_Cards/30_FC-OA-001_OA集成.md | 待确定 |
| FC-UDI-001 | 批次12 | 20_系统集成模块需求文档.md | UDI集成 | REQ-UDI-001, REQ-UDI-002, REQ-UDI-003 | 30_Feature_Cards/30_FC-UDI-001_UDI集成.md | 待确定 |
| FC-QMS-001 | 批次12 | 20_系统集成模块需求文档.md | QMS集成 | REQ-QMS-001, REQ-QMS-002, REQ-QMS-003 | 30_Feature_Cards/30_FC-QMS-001_QMS集成.md | 待确定 |
| FC-IF-001 | 批次12 | 20_系统集成模块需求文档.md | 接口运营 | REQ-IF-001, REQ-IF-002, REQ-IF-003, REQ-IF-004, REQ-IF-005 | 30_Feature_Cards/30_FC-IF-001_接口运营.md | 待确定 |
| FC-PM-001 | 批次12 | 20_系统集成模块需求文档.md | SAP PM集成 | REQ-PM-001, REQ-PM-002 | 30_Feature_Cards/30_FC-PM-001_SAP_PM集成.md | 待确定 |
| FC-TRAIN-001 | 批次12 | 20_系统集成模块需求文档.md | 培训系统集成 | REQ-TRAIN-001, REQ-TRAIN-002 | 30_Feature_Cards/30_FC-TRAIN-001_培训系统集成.md | 待确定 |
| FC-SCADA-001 | 批次10 | 21_OT_SCADA集成模块需求文档.md | SCADA系统与设备 | REQ-SCADA-001, REQ-SCADA-002, REQ-SCADA-003, REQ-SCADA-004 | 30_Feature_Cards/30_FC-SCADA-001_SCADA系统与设备.md | 待确定 |
| FC-SCADA-002 | 批次10 | 21_OT_SCADA集成模块需求文档.md | 数据采集 | REQ-SCADA-005, REQ-SCADA-006, REQ-SCADA-007 | 30_Feature_Cards/30_FC-SCADA-002_数据采集.md | 待确定 |
| FC-SCADA-003 | 批次10 | 21_OT_SCADA集成模块需求文档.md | 告警与设备状态 | REQ-SCADA-008, REQ-SCADA-009, REQ-SCADA-010, REQ-SCADA-011, REQ-SCADA-012 | 30_Feature_Cards/30_FC-SCADA-003_告警与设备状态.md | 待确定 |
| FC-ENV-001 | 批次10 | 21_OT_SCADA集成模块需求文档.md | 环境监测 | REQ-ENV-001, REQ-ENV-002, REQ-ENV-003, REQ-ENV-004, REQ-ENV-005 | 30_Feature_Cards/30_FC-ENV-001_环境监测.md | 待确定 |
| FC-CC-001 | 批次10 | 21_OT_SCADA集成模块需求文档.md | 冷链监控 | REQ-CC-001, REQ-CC-002, REQ-CC-003 | 30_Feature_Cards/30_FC-CC-001_冷链监控.md | 待确定 |
| FC-CLN-001 | 批次10 | 21_OT_SCADA集成模块需求文档.md | 清洗灭菌（CIP/SIP） | REQ-CLN-001, REQ-CLN-002, REQ-CLN-003, REQ-CLN-004 | 30_Feature_Cards/30_FC-CLN-001_清洗灭菌（CIPSIP）.md | 待确定 |
| FC-CLS-001 | 批次6 | 22_订单关闭管理模块需求文档.md | 关闭前置校验 | REQ-CLS-001, REQ-CLS-002, REQ-CLS-003, REQ-CLS-004, REQ-CLS-005 | 30_Feature_Cards/30_FC-CLS-001_关闭前置校验.md | 待确定 |
| FC-CLS-002 | 批次6 | 22_订单关闭管理模块需求文档.md | 收率与差异分析 | REQ-CLS-006, REQ-CLS-007, REQ-CLS-008 | 30_Feature_Cards/30_FC-CLS-002_收率与差异分析.md | 待确定 |
| FC-CLS-003 | 批次6 | 22_订单关闭管理模块需求文档.md | 订单关闭 | REQ-CLS-009, REQ-CLS-010, REQ-CLS-011, REQ-CLS-012 | 30_Feature_Cards/30_FC-CLS-003_订单关闭.md | 待确定 |
| FC-CLS-004 | 批次6 | 22_订单关闭管理模块需求文档.md | 数据归档 | REQ-CLS-013, REQ-CLS-014, REQ-CLS-015 | 30_Feature_Cards/30_FC-CLS-004_数据归档.md | 待确定 |