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
import com.ischoolbar.programmer.apply.entity.Category;
import com.ischoolbar.programmer.apply.service.ICategoryService;
import com.ischoolbar.programmer.apply.service.IItemService;


/**
 * <p>
 *  前端控制器
 * </p>
 *
 * @author jobob
 * @since 2020-03-25
 */
@RestController
@RequestMapping("/apply/category")
public class CategoryController {
	
	@Autowired
	ICategoryService categoryService;
	@Autowired
	IItemService itemService;
	
	

	/**
	 * 列表页面
	 * @return
	 */
	@RequestMapping(value="/list",method=RequestMethod.GET)
	public ModelAndView listView(ModelAndView model){
		model.setViewName("/apply/category/list");
		return model;
	}
	/**
	 * 分页条件查询
	 * @param current
	 * @param size
	 * @param category
	 * @return
	 */
	@RequestMapping(value="/list",method=RequestMethod.POST)
	@ResponseBody
	public Map<String,Object> list(@RequestParam("page") int current, @RequestParam("rows") int size,Category category) {
		Page<Category> page = new Page<>();
		page.setCurrent(current);
		page.setSize(size);
		page = (Page<Category>) categoryService.selectCategoryPage(page, category);
		
		Map<String,Object> ret = new HashMap<>();
		ret.put("total", page.getTotal());
		ret.put("rows", page.getRecords());
		return ret;
	}
	/**
	 * 新增或修改
	 * @param category
	 * @return
	 */
	@RequestMapping(value="/saveOrUpdate")
	@ResponseBody
	public Map<String,Object> add(Category category){
		boolean hasId = category.getCid() == null ? false : true;
		Map<String,Object> ret = new HashMap<>();
		if(StringUtils.isEmpty(category.getCname())){
			ret.put("type", "error");
			ret.put("msg", "用户名不能为空");
			return ret;
		}
		if(!hasId && isExist(category.getCname())){
			ret.put("type", "error");
			ret.put("msg", "该分类已经存在，请重新输入！");
			return ret;
		}
		if(!categoryService.saveOrUpdate(category)){
			ret.put("type", "error");
			ret.put("msg", "新增分类异常，请联系管理员！");
			return ret;
		}
		ret.put("type", "success");
		ret.put("msg", hasId ? "分类修改成功！" : "分类添加成功！");
		return ret;
		
	}
	
	
	/**
	 * 删除
	 * @param category
	 * @return
	 */
	@RequestMapping(value="/delete")
	@ResponseBody
	public Map<String,Object> delete(@RequestParam(value="ids[]",defaultValue="")List<Integer> ids){
		return categoryService.deleteByIds(ids);
	}
	
	/**
	 * 获取分类下拉列表数据
	 * @return
	 */
	@RequestMapping("/getCategoryDropList")
	@ResponseBody
	public List<Category> getCategoryDropList(){
		return categoryService.list();
	}
	
	
	
	
	
	
	
	
	/**
	 * 判断该分类名称是否在数据库中已存在
	 * @param cName
	 * @return
	 */
	private boolean isExist(String cname) {
		return categoryService.getOne(new QueryWrapper<Category>().eq("cname", cname)) == null ? false : true;
	}
}
