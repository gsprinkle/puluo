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
		return itemService.addOrUpdate(item);

	}/**



	/**
	 * 删除
	 * 
	 * @param category
	 * @return
	 */
	@RequestMapping(value = "/delete")
	@ResponseBody
	public Map<String, Object> delete(@RequestParam(value="ids[]",defaultValue="")List<Integer> ids) {
		return itemService.deleteByIds(ids);
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
	 * 去掉1
	 * @return
	 */
	@RequestMapping("/formatUnit")
	@ResponseBody
	public Map<String,Object> formatUnit(){
		Map<String,Object> ret = new HashMap<>();
		List<Item> itemList = itemService.list();
		for(Item item : itemList){
			String unit = item.getUnit();
			if(unit.contains("1")){
				item.setUnit(unit.substring(1,unit.length()));
				itemService.saveOrUpdate(item);
			}
		}
		ret.put("type", "success");
		ret.put("msg", "批量去除1成功！");
		return ret;
	}

	
}
