# Vue + Element UI 常见问题
### [Bug] el-table 数据更新但视图不刷新
**症状**: 修改了表格数据，但界面没变化。
**原因**: Vue 的响应式检测不到对象内部深层属性的变化，或者 el-table 的 `key` 属性缺失。
**解法**: 使用 `this.$set()` 更新数据，或给 el-table 加上 `:key="tableKey"`，更新时让 `tableKey++`。
