package com.ischoolbar.programmer.apply.mapper;

import com.ischoolbar.programmer.apply.entity.Stock;
import com.ischoolbar.programmer.apply.vo.StockVo;

import java.math.BigDecimal;

import org.apache.ibatis.annotations.Param;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;

/**
 * <p>
 *  Mapper 接口
 * </p>
 *
 * @author jobob
 * @since 2020-04-14
 */
public interface StockMapper extends BaseMapper<Stock> {

	Page<StockVo> selectByPage(Page<StockVo> page, @Param("stock")Stock stock);

	Page<StockVo> selectBySummary(Page<StockVo> page, @Param("stock")StockVo stock);

	BigDecimal countTotalPrice(@Param("stock")StockVo stock);

}
