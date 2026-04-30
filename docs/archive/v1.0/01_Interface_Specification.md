# 迈克生物试剂生产MES系统接口规范
## 1. 内部接口规范
### 1.1 通用规范
- 所有接口遵循RESTful风格，路径前缀为`/prod-api/`
- 权限控制：使用`@PreAuthorize`注解，遵循RuoYi权限体系
- 返回格式：统一返回`AjaxResult`对象，格式如下：
```json
{
  "code": 200, // 200成功，500失败，401未登录，403无权限
  "msg": "操作成功",
  "data": {}, // 返回数据
  "total": 0 // 分页总条数
}
```
- 幂等性：所有写操作接口支持幂等，请求头携带`requestId`作为唯一标识
- 超时时间：接口默认超时30秒，长时任务支持异步回调

---
### 1.2 模块接口列表
#### 1.2.1 排产管理模块
| 接口路径 | 请求方式 | 权限标识 | 功能说明 |
|----------|----------|----------|----------|
| `/schedule/plan/list` | GET | `schedule:plan:list` | 查询排产计划列表 |
| `/schedule/plan` | POST | `schedule:plan:add` | 新增排产计划 |
| `/schedule/plan` | PUT | `schedule:plan:edit` | 修改排产计划 |
| `/schedule/plan/{id}` | DELETE | `schedule:plan:remove` | 删除排产计划 |
| `/schedule/capacity/evaluate` | POST | `schedule:capacity:evaluate` | 产能评估 |
| `/schedule/gantt/data` | GET | `schedule:gantt:list` | 获取甘特图数据 |

#### 1.2.2 生产订单模块
| 接口路径 | 请求方式 | 权限标识 | 功能说明 |
|----------|----------|----------|----------|
| `/order/list` | GET | `production:order:list` | 查询生产订单列表 |
| `/order` | POST | `production:order:add` | 新增生产订单 |
| `/order` | PUT | `production:order:edit` | 修改生产订单 |
| `/order/{id}` | DELETE | `production:order:remove` | 删除生产订单 |
| `/order/batch/generate` | POST | `production:order:batch` | 自动生成批号 |
| `/order/sop/associate` | POST | `production:order:sop` | 关联SOP文档 |

#### 1.2.3 物料管理模块
| 接口路径 | 请求方式 | 权限标识 | 功能说明 |
|----------|----------|----------|----------|
| `/material/picking/list` | GET | `production:material:picking:list` | 查询领料单列表 |
| `/material/picking` | POST | `production:material:picking:add` | 创建领料单 |
| `/material/picking/confirm` | POST | `production:material:picking:confirm` | 确认领料 |
| `/material/return/list` | GET | `production:material:return:list` | 查询退料单列表 |
| `/material/return` | POST | `production:material:return:add` | 创建退料单 |
| `/material/validation/kitting` | POST | `production:material:validation:kitting` | 物料齐套校验 |
| `/material/validation/feeding` | POST | `production:material:validation:feeding` | 投料校验 |
| `/material/posting/sap` | POST | `production:material:posting:sap` | SAP过账 |

#### 1.2.4 派工单管理模块
| 接口路径 | 请求方式 | 权限标识 | 功能说明 |
|----------|----------|----------|----------|
| `/dispatch/order/list` | GET | `production:dispatch:order:list` | 查询派工单列表 |
| `/dispatch/order` | POST | `production:dispatch:order:add` | 生成派工单 |
| `/dispatch/order/{id}` | GET | `production:dispatch:order:query` | 查询派工单详情 |
| `/dispatch/order/qrcode/{id}` | GET | `production:dispatch:order:qrcode` | 获取派工单二维码 |
| `/dispatch/order/status/update` | PUT | `production:dispatch:order:status` | 更新派工单状态 |
| `/dispatch/template/list` | GET | `production:dispatch:template:list` | 查询派工单模板列表 |
| `/dispatch/template` | POST | `production:dispatch:template:add` | 新增派工单模板 |
| `/dispatch/template/field` | POST | `production:dispatch:template:field:add` | 新增模板扩展字段 |

#### 1.2.5 现场报工模块
| 接口路径 | 请求方式 | 权限标识 | 功能说明 |
|----------|----------|----------|----------|
| `/report/work/list` | GET | `production:report:work:list` | 查询报工列表 |
| `/report/work` | POST | `production:report:work:add` | 提交报工 |
| `/report/work/scan` | POST | `production:report:work:scan` | 扫码报工 |
| `/report/workhour/list` | GET | `production:report:workhour:list` | 查询工时记录 |
| `/report/workhour/start` | POST | `production:report:workhour:start` | 开始计时 |
| `/report/workhour/end` | POST | `production:report:workhour:end` | 结束计时 |
| `/report/actual/list` | GET | `production:report:actual:list` | 查询工序实绩 |
| `/report/actual/add` | POST | `production:report:actual:add` | 上报工序实绩 |
| `/report/sync/sap` | POST | `production:report:sync:sap` | 同步报工到SAP |

#### 1.2.6 电子批记录模块
| 接口路径 | 请求方式 | 权限标识 | 功能说明 |
|----------|----------|----------|----------|
| `/batch/record/list` | GET | `production:batch:record:list` | 查询批记录列表 |
| `/batch/record/{batchNo}` | GET | `production:batch:record:query` | 查询批记录详情 |
| `/batch/record/data/{recordId}` | GET | `production:batch:record:data` | 查询批记录采集数据 |
| `/batch/record/signature` | POST | `production:batch:record:signature` | 电子签名 |
| `/batch/record/export/{recordId}` | GET | `production:batch:record:export` | 导出GMP格式批记录 |
| `/batch/trace/{batchNo}` | GET | `production:batch:trace:query` | 批次追溯查询 |

#### 1.2.7 异常管理模块
| 接口路径 | 请求方式 | 权限标识 | 功能说明 |
|----------|----------|----------|----------|
| `/exception/list` | GET | `production:exception:list` | 查询异常工单列表 |
| `/exception` | POST | `production:exception:add` | 上报异常工单 |
| `/exception/{id}` | GET | `production:exception:query` | 查询异常详情 |
| `/exception/handle` | POST | `production:exception:handle` | 处理异常工单 |
| `/exception/upgrade/{id}` | POST | `production:exception:upgrade` | 异常升级 |
| `/exception/monitor/kanban` | GET | `production:exception:monitor:kanban` | 异常监控看板数据 |
| `/exception/stat/report` | GET | `production:exception:stat:report` | 异常统计报表 |
| `/exception/kb/list` | GET | `production:exception:kb:list` | 查询知识库列表 |
| `/exception/kb` | POST | `production:exception:kb:add` | 新增知识库条目 |
| `/exception/kb/search` | GET | `production:exception:kb:search` | 知识库搜索 |

---
## 2. 第三方系统接口规范
### 2.1 SAP接口规范
#### 2.1.1 通用参数
- 协议：RFC/HTTPS
- 编码：UTF-8
- 签名：使用SSL证书签名
- 幂等键：每个请求携带唯一`MESSAGE_ID`
#### 2.1.2 接口列表
| 接口名称 | 功能说明 | 输入参数 | 输出参数 |
|----------|----------|----------|----------|
| `ZFM_MES_MAT_SYNC` | 物料主数据同步 | 物料编码、名称、规格、单位、批次管理标识 | 同步结果、错误信息 |
| `ZFM_MES_ORDER_SYNC` | 生产订单同步 | 订单号、物料编码、数量、批次号、计划开始/结束时间 | 同步结果、错误信息 |
| `ZFM_MES_GOODS_ISSUE` | 投料过账 | 订单号、物料编码、批次号、数量、移动类型、成本中心 | 过账结果、物料凭证号、错误信息 |
| `ZFM_MES_CONFIRMATION` | 报工过账 | 订单号、工序号、合格数量、不合格数量、工时 | 过账结果、确认号、错误信息 |
| `ZFM_MES_GOODS_RECEIPT` | 成品入库过账 | 订单号、物料编码、批次号、数量、库存地点 | 过账结果、物料凭证号、错误信息 |

### 2.2 WMS接口规范
#### 2.2.1 通用参数
- 协议：HTTPS
- 内容类型：application/json
- 签名：使用`appKey`+`appSecret`签名
- 响应格式：
```json
{
  "code": "0", // 0成功，非0失败
  "msg": "成功",
  "data": {}
}
```
#### 2.2.2 接口列表
| 接口路径 | 请求方式 | 功能说明 |
|----------|----------|----------|
| `/api/wms/pickingOrder/create` | POST | 创建领料单 |
| `/api/wms/pickingOrder/cancel` | POST | 取消领料单 |
| `/api/wms/returnOrder/create` | POST | 创建退料单 |
| `/api/wms/productIn/create` | POST | 创建成品入库单 |
| `/api/wms/inventory/query` | POST | 查询库存 |
| `/api/mes/callback/picking` | POST | WMS领料完成回调MES |
| `/api/mes/callback/return` | POST | WMS退料完成回调MES |
| `/api/mes/callback/productIn` | POST | WMS入库完成回调MES |

### 2.3 OA接口规范
#### 2.3.1 通用参数
- 协议：HTTPS
- 内容类型：application/json
- 认证：Token认证
#### 2.3.2 接口列表
| 接口路径 | 请求方式 | 功能说明 |
|----------|----------|----------|
| `/api/oa/process/start` | POST | 启动OA流程 |
| `/api/mes/oa/callback` | POST | OA流程结果回调 |

### 2.4 思宇UDI系统接口规范
#### 2.4.1 通用参数
- 协议：HTTPS
- 内容类型：application/json
#### 2.4.2 接口列表
| 接口路径 | 请求方式 | 功能说明 |
|----------|----------|----------|
| `/api/udi/generate` | POST | 生成UDI码 |
| `/api/mes/udi/callback` | POST | UDI生成完成回调 |
| `/api/udi/print` | POST | 打印UDI标签 |

---
## 3. 移动端接口规范
- 移动端接口前缀为`/prod-api/mobile/`
- 认证方式：Token认证，token放在请求头`Authorization`中
- 支持离线模式：离线数据本地缓存，网络恢复后自动同步
- 核心移动端接口：扫码报工、异常上报、派工单查询、工时记录
