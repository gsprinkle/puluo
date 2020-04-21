package com.ischoolbar.programmer.apply.service;

import com.ischoolbar.programmer.apply.entity.Stock;
import com.ischoolbar.programmer.apply.vo.StockVo;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.IService;

/**
 * <p>
 *  服务类
 * </p>
 *
 * @author jobob
 * @since 2020-04-14
 */
public interface IStockService extends IService<Stock> {

	Map<String, Object> addOrUpdate(Stock stock);

	Page<StockVo> selectByPage(Page<StockVo> page, Stock stock);

	Page<StockVo> selectBySummary(Page<StockVo> page, StockVo stock);

	BigDecimal countTotalPrice(StockVo stock);

	Map<String, Object> deleteByIds(List<Integer> ids);

}
