package com.ischoolbar.programmer.apply.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.ischoolbar.programmer.apply.entity.Apply;
import com.ischoolbar.programmer.apply.entity.Inventory;
import com.ischoolbar.programmer.apply.entity.Item;
import com.ischoolbar.programmer.apply.entity.Stock;
import com.ischoolbar.programmer.apply.mapper.ApplyMapper;
import com.ischoolbar.programmer.apply.mapper.InventoryMapper;
import com.ischoolbar.programmer.apply.mapper.ItemMapper;
import com.ischoolbar.programmer.apply.mapper.StockMapper;
import com.ischoolbar.programmer.apply.service.IItemService;
import com.ischoolbar.programmer.apply.vo.ItemCategoryVo;

/**
 * <p>
 *  服务实现类
 * </p>
 *
 * @author jobob
 * @since 2020-03-25
 */
@Service
public class ItemServiceImpl extends ServiceImpl<ItemMapper, Item> implements IItemService {
	
	@Autowired
	StockMapper stockMapper;
	
	@Autowired
	ApplyMapper applyMapper;
	
	@Autowired
	InventoryMapper inventoryMapper;

	@Override
	public Page<ItemCategoryVo> selectItemCategoryVo(Page<ItemCategoryVo> page, Item item) {
		return baseMapper.selectItemCategoryVo(page, item);
	}

	@Transactional(rollbackFor=Exception.class)
	@Override
	public Map<String, Object> deleteByIds(List<Integer> ids) {
		Map<String, Object> ret = new HashMap<>();
		int itemnum = 0;	// 物品记录数
		int applynum = 0;	// 领用记录数
		int stocknum = 0;  	// 采购记录数
		int invnum = 0;		// 库存记录数
		String msg = "删除成功！共删除 ";
		try {
			// 迭代删除物品
			for (Integer id : ids) {
				//先查询自己是否存在,不存在跳过
				Item item = baseMapper.selectById(id);
				if(item == null){
					continue;
				}
				// 先删除该物品对应的 【采购信息】、【领用信息】、【库存信息】
				stocknum += stockMapper.delete(new QueryWrapper<Stock>().eq("item_id", id));
				applynum += applyMapper.delete(new QueryWrapper<Apply>().eq("item_id", id));
				invnum += inventoryMapper.delete(new QueryWrapper<Inventory>().eq("item_id", id));
				// 再删除自己
				itemnum += baseMapper.deleteById(id);
			}
			msg = msg + stocknum + " 个采购信息、" + applynum + " 个领用信息、" + invnum + " 个 库存信息和 " + itemnum + " 个物品信息";  
		} catch (Exception e) {
			e.printStackTrace();
			ret.put("type", "error");
			ret.put("msg", "删除分类异常，请联系管理员！");
			return ret;
		}
		ret.put("type", "success");
		ret.put("msg", msg);
		ret.put("stocknum", stocknum);	//采购数量
		ret.put("applynum", applynum);	//领用数量
		ret.put("invnum", invnum);		//库存数量
		ret.put("itemnum", itemnum);	//物品数量
		return ret;
	}

	@Transactional(rollbackFor=Exception.class)
	@Override
	public Map<String, Object> addOrUpdate(Item item) {
		boolean hasId = item.getItemId() == null ? false : true;
		Map<String, Object> ret = new HashMap<>();
		if (StringUtils.isEmpty(item.getItemName())) {
			ret.put("type", "error");
			ret.put("msg", "物品名不能为空");
			return ret;
		}
		if (!hasId && isExist(item.getItemName())) {
			ret.put("type", "error");
			ret.put("msg", "该物品已经存在，请重新输入！");
			return ret;
		}
		if(item.getItemPrice() == null || item.getItemPrice().equals(0)){
			ret.put("type", "error");
			ret.put("msg", "价格不能为空或0，请重新输入！");
			return ret;
		}
		/*if(item.getCid() == null || item.getCid() == 0){
			ret.put("type", "error");
			ret.put("msg", "请选择物品的分类！");
			return ret;
		}*/
		if(StringUtils.isEmpty(item.getUnit())){
			ret.put("type", "error");
			ret.put("msg", "请填写物品的单位！");
			return ret;
		}
		if (hasId) {
			baseMapper.updateById(item);
		}else{
			baseMapper.insert(item);
			// 新增物品，同时新增库存列表
			// 查询物品对应的库存对象
			Inventory inv = inventoryMapper.selectOne(new QueryWrapper<Inventory>().eq("item_id", item.getItemId()));
			// 如果库存列表中不存在该物品，则新建设置属性,并插入到库存表
			if(inv == null){
				inv = new Inventory();
				inv.setItemId(item.getItemId());
				inv.setItemName(item.getItemName());
				inv.setInventoryNum(0);
				inventoryMapper.insert(inv);
			}
		}
		ret.put("type", "success");
		ret.put("msg", hasId ? "物品修改成功！" : "物品添加成功！");
		return ret;
	}
	
	/**
	 * 判断该物品名称是否在数据库中已存在
	 * 
	 * @param cName
	 * @return
	 */
	private boolean isExist(String itemName) {
		return baseMapper.selectOne(new QueryWrapper<Item>().eq("item_name", itemName)) == null ? false : true;
	}

}
