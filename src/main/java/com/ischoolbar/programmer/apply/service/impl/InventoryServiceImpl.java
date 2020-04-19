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
		// 初始化库存信息 先清空
		
		baseMapper.truncate();
		
		List<Inventory> initList = baseMapper.initList();
		// 库存列表中是否存在该物品，存在修改数量，不存在添加
		for(Inventory inv : initList) {
			saveOrUpdate(inv);
		}
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
