package com.ischoolbar.programmer.apply.service.impl;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.ischoolbar.programmer.apply.entity.Inventory;
import com.ischoolbar.programmer.apply.entity.Item;
import com.ischoolbar.programmer.apply.entity.Stock;
import com.ischoolbar.programmer.apply.mapper.InventoryMapper;
import com.ischoolbar.programmer.apply.mapper.ItemMapper;
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
	@Autowired
	ItemMapper itemMapper;

	@Transactional(rollbackFor=Exception.class)
	@Override
	public Map<String, Object> addOrUpdate(Stock stock) {
		Map<String, Object> ret = new HashMap<>();
		boolean hasId = stock.getStockId() == null ? false : true;
		// 查询物品对象
		Item item = itemMapper.selectById(stock.getItemId());
		// 查询物品对应的库存对象
		Inventory inv = inventoryMapper.selectOne(new QueryWrapper<Inventory>().eq("item_id", stock.getItemId()));
		// 如果库存列表中不存在该物品，则新建并设置属性,
		if(inv == null){
			inv = new Inventory();
			inv.setItemId(item.getItemId());
			inv.setItemName(item.getItemName());
			inv.setInventoryNum(0);
			inventoryMapper.insert(inv);
		}
		if (hasId) {
			// 如果采购有ID，表示为修改，获取旧的采购数量，用新的采购数量-旧的数量，添加到库存数量，执行修改
			Stock oldStock = baseMapper.selectById(stock.getStockId());
			Integer addNum = stock.getStockNum() - oldStock.getStockNum();
			// 获取采购差值后，更新到库存数据
			inv.setInventoryNum(addNum + inv.getInventoryNum());
			inventoryMapper.updateById(inv);
			// 更新采购数量
			baseMapper.updateById(stock);
		} else { // 如果没有采购ID，说明是新增采购信息，首先查看当天的采购列表中是否已经存在要新增的物品，如果存在，提示修改，不存在，执行新增
			List<Stock> selectList = baseMapper.selectList(new QueryWrapper<Stock>()
					.eq("item_id", stock.getItemId()).eq("stock_date", stock.getStockDate()));
			// 条件查看当天是否已经添加了相应的商品;
			if (selectList != null && selectList.size() > 0) {
				// 如果已经存在当天的采购信息，提示用户去列表中修改
				ret.put("type", "error");
				ret.put("msg", "采购列表已存在，如需修改，请在列表中双击修改！");
			} else {
				// 同步库存数据
				inv.setInventoryNum(stock.getStockNum() + inv.getInventoryNum());
				inventoryMapper.updateById(inv);
				// 如果不存在当天的采购信息，执行新增
				baseMapper.insert(stock);
				ret.put("type", "success");
				ret.put("msg", "添加成功！");
			}
		}
		return ret;
	}
	

	@Override
	public Map<String, Object> deleteByIds(List<Integer> ids) {
		Map<String, Object> ret = new HashMap<>();
		int stockNum = 0;
		// 迭代删除
		// 删除采购数据的同时，库存中对应的物品数量要减掉删除的数量
		for(Integer id : ids){
			Stock oldStock = baseMapper.selectById(id);
			Inventory inv = inventoryMapper.selectOne(new QueryWrapper<Inventory>().eq("item_id", oldStock.getItemId()));
			if(inv == null){
				ret.put("type", "error");
				ret.put("msg", "库存数据损坏，请先初始化库存");
				return ret;
			}
			inv.setInventoryNum(inv.getInventoryNum() - oldStock.getStockNum());
			inventoryMapper.updateById(inv);
			
			if (baseMapper.deleteById(id) < 1) {
				ret.put("type", "error");
				ret.put("msg", "删除库存异常，请联系管理员！");
				return ret;
			}
			stockNum ++;
		}
		ret.put("type", "success");
		ret.put("msg", "删除成功！共删除 " + stockNum +" 条记录");
		return ret;
	}

	@Override
	public Page<StockVo> selectByPage(Page<StockVo> page, Stock stock) {
		return baseMapper.selectByPage(page , stock);
	}

	@Override
	public Page<StockVo> selectBySummary(Page<StockVo> page, StockVo stock) {
		return baseMapper.selectBySummary(page,stock);
	}

	@Override
	public BigDecimal countTotalPrice(StockVo stock) {
		return baseMapper.countTotalPrice(stock);
	}



}
