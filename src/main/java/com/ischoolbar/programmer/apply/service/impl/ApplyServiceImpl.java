package com.ischoolbar.programmer.apply.service.impl;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.ischoolbar.programmer.apply.entity.Apply;
import com.ischoolbar.programmer.apply.mapper.ApplyMapper;
import com.ischoolbar.programmer.apply.service.IApplyService;
import com.ischoolbar.programmer.apply.vo.ApplyVo;

/**
 * <p>
 *  服务实现类
 * </p>
 *
 * @author jobob
 * @since 2020-03-25
 */
@Service
public class ApplyServiceImpl extends ServiceImpl<ApplyMapper, Apply> implements IApplyService {

	@Override
	public Page<ApplyVo> selectApplyPageVo(Page<ApplyVo> page, Apply apply) {
		return baseMapper.selectApplyPageVo(page, apply);
	}

	@Override
	public Page<ApplyVo> selectBySummary(Page<ApplyVo> page, Apply apply) {
		return baseMapper.selectBySummary(page, apply);
	}

	@Override
	public List<ApplyVo> selectByChart(Apply apply) {
		// TODO Auto-generated method stub
		return baseMapper.selectByChart(apply);
	}

	@Override
	public BigDecimal countTotalPrice(Apply apply) {
		// TODO Auto-generated method stub
		return baseMapper.countTotalPrice(apply);
	}

	@Transactional(rollbackFor=Exception.class)
	@Override
	public Map<String, Object> deleteByIds(List<Integer> ids) {
		// TODO Auto-generated method stub
		return null;
	}

}
