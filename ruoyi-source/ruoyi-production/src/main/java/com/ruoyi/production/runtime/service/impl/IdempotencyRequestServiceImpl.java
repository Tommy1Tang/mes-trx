package com.ruoyi.production.runtime.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.production.runtime.mapper.IdempotencyRequestMapper;
import com.ruoyi.production.runtime.domain.IdempotencyRequest;
import com.ruoyi.production.runtime.service.IIdempotencyRequestService;

/**
 * 幂等请求记录Service实现
 */
@Service
public class IdempotencyRequestServiceImpl implements IIdempotencyRequestService
{
    @Autowired
    private IdempotencyRequestMapper idempotencyRequestMapper;

    @Override
    public IdempotencyRequest selectIdempotencyRequestByIdempotencyId(Long idempotencyId)
    {
        return idempotencyRequestMapper.selectIdempotencyRequestByIdempotencyId(idempotencyId);
    }

    @Override
    public List<IdempotencyRequest> selectIdempotencyRequestList(IdempotencyRequest idempotencyRequest)
    {
        return idempotencyRequestMapper.selectIdempotencyRequestList(idempotencyRequest);
    }

    @Override
    public int insertIdempotencyRequest(IdempotencyRequest idempotencyRequest)
    {
        return idempotencyRequestMapper.insertIdempotencyRequest(idempotencyRequest);
    }

    @Override
    public int updateIdempotencyRequest(IdempotencyRequest idempotencyRequest)
    {
        return idempotencyRequestMapper.updateIdempotencyRequest(idempotencyRequest);
    }

    @Override
    public int deleteIdempotencyRequestByIdempotencyIds(Long[] idempotencyIds)
    {
        return idempotencyRequestMapper.deleteIdempotencyRequestByIdempotencyIds(idempotencyIds);
    }
}