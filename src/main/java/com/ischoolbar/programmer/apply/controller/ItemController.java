package com.ischoolbar.programmer.apply.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.ischoolbar.programmer.apply.entity.Item;
import com.ischoolbar.programmer.apply.service.IItemService;
import com.ischoolbar.programmer.apply.vo.ItemCategoryVo;

/**
 * <p>
 * 前端控制器
 * </p>
 *
 * @author jobob
 * @since 2020-03-25
 */
@RestController
@RequestMapping("/apply/item")
public class ItemController {
	@Autowired
	IItemService itemService;

	/**
	 * 列表页面
	 * 
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/list", method = RequestMethod.GET)
	public ModelAndView list(ModelAndView model) {
		model.setViewName("/apply/item/list");
		return model;
	}
	/**
	 * 分页级联查询列表
	 * @param current
	 * @param size
	 * @param item
	 * @return
	 */
	@RequestMapping(value = "/list", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> list(@RequestParam("page") int current, @RequestParam("rows") int size, Item item) {
		Map<String, Object> ret = new HashMap<>();
		Page<ItemCategoryVo> page = new Page<>();
		page.setCurrent(current);
		page.setSize(size);
		page = itemService.selectItemCategoryVo(page, item);
		ret.put("total", page.getTotal());
		ret.put("rows", page.getRecords());
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
		if(item.getCid() == null || item.getCid() == 0){
			ret.put("type", "error");
			ret.put("msg", "请选择物品的分类！");
			return ret;
		}
		if(StringUtils.isEmpty(item.getUnit())){
			ret.put("type", "error");
			ret.put("msg", "请填写物品的单位！");
			return ret;
		}
		if (!itemService.saveOrUpdate(item)) {
			ret.put("type", "error");
			ret.put("msg", "新增物品异常，请联系管理员！");
			return ret;
		}
		ret.put("type", "success");
		ret.put("msg", hasId ? "物品修改成功！" : "物品添加成功！");
		return ret;

	}/**



	/**
	 * 删除
	 * 
	 * @param category
	 * @return
	 */
	@RequestMapping(value = "/delete")
	@ResponseBody
	public Map<String, Object> delete(Integer itemId) {
		Map<String, Object> ret = new HashMap<>();

		if (!itemService.removeById(itemId)) {
			ret.put("type", "error");
			ret.put("msg", "删除物品异常，请联系管理员！");
			return ret;
		}
		ret.put("type", "success");
		ret.put("msg", "删除成功！");
		return ret;

	}
	
	/**
	 * 
	 * @return
	 */
	@RequestMapping("/getItemDropList")
	@ResponseBody
	public List<Item> getItemDropList(){
		return itemService.list();
	}

	/**
	 * 判断该物品名称是否在数据库中已存在
	 * 
	 * @param cName
	 * @return
	 */
	private boolean isExist(String itemName) {
		return itemService.getOne(new QueryWrapper<Item>().eq("item_name", itemName)) == null ? false : true;
	}
}
