package com.ruoyi.production.runtime.aspect;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.reflect.MethodSignature;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.common.core.domain.AjaxResult;
import jakarta.servlet.http.HttpServletRequest;

/**
 * 幂等校验注解
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

/**
 * 幂等校验切面
 * 防止弱网络下重复提交（投料、报工、签名等）
 */
@Aspect
@Component
public class IdempotencyInterceptor
{
    /** 临时内存缓存，生产环境建议替换为Redis */
    private static final Map<String, String> IDEMPOTENCY_CACHE = new ConcurrentHashMap<>();

    @Around("@annotation(idempotent)")
    public Object around(ProceedingJoinPoint joinPoint, Idempotent idempotent) throws Throwable
    {
        HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();

        String idempotencyKey = resolveIdempotencyKey(request, joinPoint, idempotent);
        if (StringUtils.isBlank(idempotencyKey))
        {
            return joinPoint.proceed();
        }

        String cacheKey = idempotent.bizType() + ":" + idempotencyKey;
        String cachedResponse = IDEMPOTENCY_CACHE.get(cacheKey);
        if (cachedResponse != null)
        {
            return AjaxResult.success("幂等命中，返回缓存响应", cachedResponse);
        }

        Object result = joinPoint.proceed();
        IDEMPOTENCY_CACHE.put(cacheKey, String.valueOf(result));
        return result;
    }

    private String resolveIdempotencyKey(HttpServletRequest request, ProceedingJoinPoint joinPoint, Idempotent idempotent)
    {
        if ("header".equals(idempotent.keySource()))
        {
            return request.getHeader("X-Idempotency-Key");
        }
        // 从方法参数中提取
        MethodSignature signature = (MethodSignature) joinPoint.getSignature();
        String[] paramNames = signature.getParameterNames();
        Object[] args = joinPoint.getArgs();
        for (int i = 0; i < paramNames.length; i++)
        {
            if ("idempotencyKey".equals(paramNames[i]) && args[i] != null)
            {
                return String.valueOf(args[i]);
            }
        }
        return request.getHeader("X-Idempotency-Key");
    }
}
