package com.ischoolbar.programmer.apply.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.ischoolbar.programmer.apply.entity.Category;
import com.ischoolbar.programmer.apply.entity.Item;
import com.ischoolbar.programmer.apply.mapper.CategoryMapper;
import com.ischoolbar.programmer.apply.mapper.ItemMapper;
import com.ischoolbar.programmer.apply.service.ICategoryService;
import com.ischoolbar.programmer.apply.service.IItemService;

/**
 * <p>
 * 服务实现类
 * </p>
 *
 * @author jobob
 * @since 2020-03-25
 */
@Service
public class CategoryServiceImpl extends ServiceImpl<CategoryMapper, Category> implements ICategoryService {
	@Autowired
	ItemMapper itemMapper;
	
	@Autowired
	IItemService itemService;

	@Override
	public IPage<Category> selectCategoryPage(Page<Category> page, Category category) {
		return baseMapper.selectPageVo(page, category);
	}

	@Transactional(rollbackFor=Exception.class)
	@Override
	public Map<String, Object> deleteByIds(List<Integer> ids) {
		Map<String, Object> ret = new HashMap<>();
		int cnum = 0;		// 物品分类计数
		int itemnum = 0;	// 物品计数
		int applynum = 0;	// 领用计数
		int stocknum = 0;	// 采购计数
		int invnum = 0;		// 库存计数
		String msg = "";
		try {
			// 迭代删除分类及物品
			for (Integer id : ids) {
				// 先删除该分类下的所有物品（封装物品itemIds,调用物品的deleteByIds）
				List<Integer> itemIds = new ArrayList<>();
				
				List<Item> itemList = itemMapper.selectList(new QueryWrapper<Item>().eq("cid", id));
				for(Item item : itemList){
					itemIds.add(item.getItemId());
				}
				Map<String, Object> delitems = itemService.deleteByIds(itemIds);
				itemnum += (int)delitems.get("itemnum");
				applynum += (int)delitems.get("applynum");
				stocknum += (int)delitems.get("stocknum");
				invnum +=  ((Integer)delitems.get("invnum") == null) ? 0 : (Integer)delitems.get("invnum");
				// 再删除自己
				cnum += baseMapper.deleteById(id);
				// 拼接 返回 提示字符串
				msg = "删除成功！共删除 ";
				msg = msg + cnum + " 个分类和 " 
				+ itemnum + " 个物品信息" 
				+ stocknum + " 个采购信息、" 
				+ applynum + " 个领用信息、" 
				+ invnum + " 个库存信息 " ;
			}
		} catch (Exception e) {
			e.printStackTrace();
			ret.put("type", "error");
			ret.put("msg", "删除分类异常，请联系管理员！");
			return ret;
		}
		ret.put("type", "success");
		ret.put("msg", msg);
		return ret;
	}

}
