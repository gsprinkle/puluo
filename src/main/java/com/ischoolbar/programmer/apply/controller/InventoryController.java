package com.ischoolbar.programmer.apply.controller;


import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.ischoolbar.programmer.apply.entity.Inventory;
import com.ischoolbar.programmer.apply.entity.Item;
import com.ischoolbar.programmer.apply.service.IInventoryService;
import com.ischoolbar.programmer.apply.service.IItemService;
import com.ischoolbar.programmer.apply.vo.InventoryVo;

/**
 * <p>
 *  前端控制器
 * </p>
 *
 * @author jobob
 * @since 2020-04-14
 */
@RestController
@RequestMapping("/apply/inventory")
public class InventoryController {
	@Autowired
	IInventoryService inventoryService;

	@Autowired
	IItemService itemService;

	@RequestMapping("/initialize")
	@ResponseBody
	public Map<String, Object> initialize() {
		return inventoryService.initialize();
	}

	/**
	 * 列表页面
	 * 
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/list", method = RequestMethod.GET)
	public ModelAndView list(ModelAndView model) {
		model.setViewName("/apply/inventory/list");
		return model;
	}

	/**
	 * 分页级联查询列表
	 * 
	 * @param current
	 * @param size
	 * @param inventory
	 * @return
	 */
	@RequestMapping(value = "/list", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> list(@RequestParam("page") int current, @RequestParam("rows") int size, InventoryVo inventory) {
		Map<String, Object> ret = new HashMap<>();
		Page<InventoryVo> page = new Page<>();
		page.setCurrent(current);
		page.setSize(size);
		page = inventoryService.selectByPage(page, inventory);
		ret.put("total", page.getTotal());
		ret.put("rows", page.getRecords());
		// 查询 总价值
		BigDecimal total = inventoryService.countTotalPrice();
		ret.put("countTotal", total);
		return ret;
	}

	/**
	 * 新增或修改
	 * 
	 * @param category
	 * @return
	 */
	@RequestMapping(value = "/saveOrUpdate")
	@ResponseBody
	public Map<String, Object> addOrUpdate(Inventory inventory) {
		boolean hasId = inventory.getInventoryId() == null ? false : true;
		Map<String, Object> ret = new HashMap<>();
		if (!inventoryService.saveOrUpdate(inventory)) {
			ret.put("type", "error");
			ret.put("msg", "新增库存异常，请联系管理员！");
			return ret;
		}
		ret.put("type", "success");
		ret.put("msg", hasId ? "品牌修改成功！" : "品牌添加成功！");
		return ret;

	}
	/**
	 * 删除
	 * @param inventoryId
	 * @return
	 */
	@RequestMapping(value = "/delete")
	@ResponseBody
	public Map<String, Object> delete(Integer inventoryId) {
		Map<String, Object> ret = new HashMap<>();

		if (!inventoryService.removeById(inventoryId)) {
			ret.put("type", "error");
			ret.put("msg", "删除库存异常，请联系管理员！");
			return ret;
		}
		ret.put("type", "success");
		ret.put("msg", "删除成功！");
		return ret;
	}

	/**
	 * 判断该产品名称是否在库存表中存在
	 * 
	 * @param cName
	 * @return
	 */
	private boolean isExist(Integer itemId) {
		List<Inventory> list = inventoryService.list(new QueryWrapper<Inventory>().eq("item_id", itemId));
		if(list == null || list.size()<1){
			return false;
		}
		return true;
	}
}
