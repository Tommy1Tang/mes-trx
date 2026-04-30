# MyBatis 常见问题
### [Bug] MyBatis 分页参数顺序错误
**症状**: 分页查询结果不对，或者报错 `Parameter index out of range`
**原因**: RuoYi 的 `PageHelper.startPage(pageNum, pageSize)` 必须放在 SQL 查询的**紧前一行**，中间不能有其他代码。
**解法**: 确保 `startPage` 和 Mapper 调用之间没有任何逻辑代码。
