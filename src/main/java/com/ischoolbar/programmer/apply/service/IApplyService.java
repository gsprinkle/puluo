package com.ischoolbar.programmer.apply.service;

import java.math.BigDecimal;
import java.util.List;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.IService;
import com.ischoolbar.programmer.apply.entity.Apply;
import com.ischoolbar.programmer.apply.vo.ApplyVo;

/**
 * <p>
 *  服务类
 * </p>
 *
 * @author jobob
 * @since 2020-03-25
 */
public interface IApplyService extends IService<Apply> {
	Page<ApplyVo> selectApplyPageVo(Page<ApplyVo> page, Apply apply);

	Page<ApplyVo> selectBySummary(Page<ApplyVo> page, Apply apply);

	List<ApplyVo> selectByChart(Apply apply);

	BigDecimal countTotalPrice(Apply apply);
}
