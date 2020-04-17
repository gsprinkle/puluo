package com.ischoolbar.programmer.apply.service.impl;

import java.util.List;

import org.springframework.stereotype.Service;

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

}
