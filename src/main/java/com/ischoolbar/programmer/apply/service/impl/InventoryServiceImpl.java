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
import com.ischoolbar.programmer.apply.mapper.InventoryMapper;
import com.ischoolbar.programmer.apply.mapper.ItemMapper;
import com.ischoolbar.programmer.apply.service.IInventoryService;
import com.ischoolbar.programmer.apply.vo.InventoryVo;

/**
 * <p>
 *  服务实现类
 * </p>
 *
 * @author jobob
 * @since 2020-04-14
 */
@Service
public class InventoryServiceImpl extends ServiceImpl<InventoryMapper, Inventory> implements IInventoryService {

	@Autowired
	ItemMapper itemMapper;
	
	@Autowired
	InventoryMapper inventoryMapper;
	
	/**
	 * 初始化库存数据
	 */
	@Transactional(rollbackFor = Exception.class)
	@Override
	public Map<String, Object> initialize() {
		Map<String, Object> ret = new HashMap<>();
		// 查询所有商品，初始化库存列表
		List<Item> itemList = itemMapper.selectList(null);
		// 遍历物品列表，并查看库存中是否已存在该物品，若没有则添加到库存中，库存量默认为0
		for(Item item : itemList) {
			List<Inventory> invList = inventoryMapper.selectList(new QueryWrapper<Inventory>().eq("item_id", item.getItemId()));
			if(invList == null || invList.size()<1){
				Inventory inv = new Inventory();
				inv.setInventoryNum(0);
				inv.setItemId(item.getItemId());
				baseMapper.insert(inv);
			}
		}
		// 查询所有采购进货信息，同步数量到库存数据中(待完成)
		
		// 查询所有请领信息，同步数据到库存数据中
		
		ret.put("type", "success");
		ret.put("info", "初始化成功");
		return ret;
	}

	@Override
	public Page<InventoryVo> selectByPage(Page<InventoryVo> page, InventoryVo inventory) {
		
		return baseMapper.selectByPage(page,inventory);
	}

	@Override
	public BigDecimal countTotalPrice() {
		// TODO Auto-generated method stub
		return baseMapper.countTotalPrice();
	}

}
