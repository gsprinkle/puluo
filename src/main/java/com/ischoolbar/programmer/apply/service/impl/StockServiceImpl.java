package com.ischoolbar.programmer.apply.service.impl;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.ischoolbar.programmer.apply.entity.Inventory;
import com.ischoolbar.programmer.apply.entity.Stock;
import com.ischoolbar.programmer.apply.mapper.InventoryMapper;
import com.ischoolbar.programmer.apply.mapper.StockMapper;
import com.ischoolbar.programmer.apply.service.IStockService;
import com.ischoolbar.programmer.apply.vo.StockVo;

/**
 * <p>
 * 服务实现类
 * </p>
 *
 * @author jobob
 * @since 2020-04-14
 */
@Service
public class StockServiceImpl extends ServiceImpl<StockMapper, Stock> implements IStockService {
	@Autowired
	InventoryMapper inventoryMapper;

	@Override
	public Map<String, Object> addOrUpdate(Stock stock) {
		Map<String, Object> ret = new HashMap<>();
		boolean hasId = stock.getStockId() == null ? false : true;
		if (hasId) {
			// 如果有ID，表示为修改，获取旧的进货数量，用新的进货数量-旧的数量，添加到库存的数量，执行修改
			Stock oldStock = baseMapper.selectById(stock.getStockId());
			Integer addNum = stock.getStockNum() - oldStock.getStockNum();
			// 更新库存
			Inventory inv = inventoryMapper
					.selectOne(new QueryWrapper<Inventory>().eq("item_id", stock.getItemId()));
			inv.setInventoryNum(addNum + inv.getInventoryNum());
			inventoryMapper.updateById(inv);
			// 更新进货数量
			baseMapper.updateById(stock);
		} else {
			List<Stock> selectList = baseMapper.selectList(new QueryWrapper<Stock>()
					.eq("item_id", stock.getItemId()).eq("stock_date", stock.getStockDate()));
			// 如果没有ID，表示新增，提示用户去列表中修改，如果没有，执行新增；
			// 条件查看当天是否已经添加了相应的商品;
			if (selectList != null && selectList.size() > 0) {
				// 如果已经存在，提示用户去列表中修改
				ret.put("type", "error");
				ret.put("msg", "进货列表已存在，如需修改，请在列表中双击修改！");
			} else {
				// 如果不存在，执行新增
				baseMapper.insert(stock);
				// 同步库存数据
				Inventory inv = inventoryMapper
						.selectOne(new QueryWrapper<Inventory>().eq("item_id", stock.getItemId()));
				inv.setInventoryNum(stock.getStockNum() + inv.getInventoryNum());
				inventoryMapper.updateById(inv);
				ret.put("type", "success");
				ret.put("msg", "添加成功！");
			}
		}
		return ret;
	}

	@Override
	public Map<String, Object> delete(Integer stockId) {
		Map<String, Object> ret = new HashMap<>();
		// 删除进货数据的同时，库存中对应的物品数量要减掉删除的数量
		Stock oldStock = baseMapper.selectById(stockId);
		Inventory inv = inventoryMapper.selectOne(new QueryWrapper<Inventory>().eq("item_id", oldStock.getItemId()));
		inv.setInventoryNum(inv.getInventoryNum() - oldStock.getStockNum());
		inventoryMapper.updateById(inv);
		if (baseMapper.deleteById(stockId) < 1) {
			ret.put("type", "error");
			ret.put("msg", "删除库存异常，请联系管理员！");
			return ret;
		}
		ret.put("type", "success");
		ret.put("msg", "删除成功！");
		return ret;
	}

	@Override
	public Page<StockVo> selectByPage(Page<StockVo> page, Stock stock) {
		// TODO Auto-generated method stub
		return baseMapper.selectByPage(page , stock);
	}

	@Override
	public Page<StockVo> selectBySummary(Page<StockVo> page, StockVo stock) {
		// TODO Auto-generated method stub
		return baseMapper.selectBySummary(page,stock);
	}

	@Override
	public BigDecimal countTotalPrice(StockVo stock) {
		// TODO Auto-generated method stub
		return baseMapper.countTotalPrice(stock);
	}

}
