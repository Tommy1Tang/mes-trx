package com.ruoyi.production.runtime.aspect;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * 幂等校验注解
 * 标记在Controller方法上，防止重复提交
 */
@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
public @interface Idempotent
{
    /** 业务类型 */
    String bizType() default "";

    /** 幂等键来源：header=从请求头取, param=从参数取 */
    String keySource() default "header";
}
