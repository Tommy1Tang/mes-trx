# Spring 核心常见问题
### [Bug] 事务不回滚
**症状**: `@Transactional` 注解的方法报错后，数据库没有回滚。
**原因**: 同类内部调用（this.xxx()）会绕过 Spring AOP 代理，导致事务失效。
**解法**: 将被调用方法抽到另一个 Service 中，或通过 `AopContext.currentProxy()` 获取代理对象调用。
