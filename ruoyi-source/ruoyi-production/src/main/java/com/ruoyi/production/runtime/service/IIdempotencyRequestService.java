package com.ruoyi.production.runtime.service;

import java.util.List;
import com.ruoyi.production.runtime.domain.IdempotencyRequest;

/**
 * 幂等请求记录Service接口
 */
public interface IIdempotencyRequestService
{
    public IdempotencyRequest selectIdempotencyRequestByIdempotencyId(Long idempotencyId);
    public List<IdempotencyRequest> selectIdempotencyRequestList(IdempotencyRequest idempotencyRequest);
    public int insertIdempotencyRequest(IdempotencyRequest idempotencyRequest);
    public int updateIdempotencyRequest(IdempotencyRequest idempotencyRequest);
    public int deleteIdempotencyRequestByIdempotencyIds(Long[] idempotencyIds);
}