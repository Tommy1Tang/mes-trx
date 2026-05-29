# BOM与工艺路线模块需求文档（L2层前半）
## 1. 模块概述
负责定义产品结构（BOM）和工艺路线（Routing），是MBR模板的上游输入。BOM定义"用什么料"，工艺路线定义"做什么工序"，二者共同构成MBR模板的基础。

本模块只维护工序级基准，不维护工步级执行明细。BOM负责物料结构、基准用量、损耗率和BOM行到工序的投料映射；工艺路线负责工序、工序顺序、工序资源、工序参数、工序文档和工序检验点。具体到某个工步的扫码、称量、投料、设备校验、参数采集、复核、签名和EBR/DHR留痕，由MBR模板模块承载。

**架构层：** L2 产品、工艺与MBR模板层（前半部分）
**涉及表：** pro_bom_header、pro_bom_item、pro_bom_item_operation_map、pro_bom_substitution_group、pro_bom_substitution_item、pro_bom_cutover_rule、pro_bom_cutover_execution_log、pro_routing_header、pro_routing_operation、pro_operation_relation、pro_operation_resource、pro_operation_parameter、pro_operation_document、pro_inspection_plan、pro_inspection_characteristic、pro_operation_inspection_map


## 2. Absolute Progressive Loading 路由
本模块文档只作为 Router 和模块边界，不承载全部开发细节。开发 Agent 必须按功能卡、字段字典和接口路标进行最小上下文加载。

### 2.1 功能卡索引
| 功能卡ID | 功能卡 | 覆盖需求 | 文件 |
|----------|--------|----------|------|
| FC-BOM-001 | BOM管理 | REQ-BOM-001, REQ-BOM-002, REQ-BOM-003, REQ-BOM-004 | 30_Feature_Cards/30_FC-BOM-001_BOM管理.md |
| FC-BOM-002 | BOM替代与切换 | REQ-BOM-005, REQ-BOM-006, REQ-BOM-007, REQ-BOM-008 | 30_Feature_Cards/30_FC-BOM-002_BOM替代与切换.md |
| FC-ROUTE-001 | 工艺路线管理 | REQ-ROUTE-001, REQ-ROUTE-002, REQ-ROUTE-003, REQ-ROUTE-004, REQ-ROUTE-005, REQ-ROUTE-006, REQ-ROUTE-007 | 30_Feature_Cards/30_FC-ROUTE-001_工艺路线管理.md |
| FC-ROUTE-002 | 检验方案管理 | REQ-ROUTE-008, REQ-ROUTE-009, REQ-ROUTE-010 | 30_Feature_Cards/30_FC-ROUTE-002_检验方案管理.md |

### 2.2 开发加载规则
1. 先读取 `00_Blueprint.md`、`00_Agent_Collaboration_Rules.md`、`IVD_MES整体开发口径.md`。
2. 按需求ID或功能卡ID读取本模块对应功能卡，例如 `rg "REQ-XXX-001" docs/30_Feature_Cards` 或 `rg "FC-XXX-001" docs/30_Feature_Cards`。
3. 只加载功能卡声明的相关表字段、接口小节和治理规范，禁止一次加载整个字段字典。
4. 若功能卡仍缺页面字段、交互或验收细节，先补卡再开发。

## 3. 核心流程

### 3.1 BOM创建流程
1. 工艺工程师创建BOM头表，关联产品物料
2. 添加BOM组件行，定义用量、损耗率、投料工序
3. 如有替代料，定义替代组和替代料明细
4. 提交审核，审核通过后发布

### 3.2 工艺路线创建流程
1. 工艺工程师创建工艺路线头表，关联产品/BOM
2. 添加标准工序，定义工序类型、标准工时
3. 定义工序关系（顺序/并行）
4. 绑定工序级资源、参数、文档
5. 关联检验方案
6. 提交审核，审核通过后发布

### 3.3 BOM切换流程
1. 工艺工程师定义切换规则（旧料→新料、切换时间点）
2. 系统在建单时自动检查切换规则
3. 命中切换规则的组件自动使用新料
4. 记录切换执行日志

## 4. 与其他模块的关系
- BOM → 生产订单组件展开（L4层）
- 工艺路线 → 工单工序实例展开（L4层）
- BOM + 工艺路线 → MBR模板（L2层后半，作为工步级执行模板的引用和校验基础）
- 检验方案 → 检验结果记录（L6层）
- 工序资源 → 排产能齐套校验（L4层）

## 5. 与MBR模板的边界口径
| 对象 | BOM与工艺路线侧 | MBR模板侧 |
|------|------------------|-----------|
| 物料/组件 | 维护BOM明细、基准用量、损耗率、BOM行到工序的投料映射 | 在工步上引用BOM明细或物料，定义扫码、称量、投料、偏差、批次校验和EBR留痕 |
| 设备/资源 | 维护工序所需工作中心、设备、工装、夹具和资源数量 | 在工步上引用设备/工装/夹具，定义扫码、清洁/校准/点检校验、采集点和执行留痕 |
| 参数 | 维护工序级工艺参数、目标值、上下限和控制类型 | 在工步上定义参数填写/采集、必填、精度、上下限和是否写入批记录 |
| 检验/质控 | 维护工序与检验方案、检验特性的关系 | 在工步上定义质控项、复核、签名、阻断和异常触发规则 |

MBR导入、Excel批导或工单执行快照生成时，必须以本模块的BOM、工艺路线和检验方案作为上游基准进行映射校验；发现不一致时生成导入错误或待确认项，不允许反向自动修改BOM或工艺路线。
