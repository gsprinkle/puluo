package com.ischoolbar.programmer.apply.controller;

import java.math.BigDecimal;
import java.util.ArrayList;
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

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.ischoolbar.programmer.apply.entity.Apply;
import com.ischoolbar.programmer.apply.service.IApplyService;
import com.ischoolbar.programmer.apply.service.IEmployeeService;
import com.ischoolbar.programmer.apply.service.IItemService;
import com.ischoolbar.programmer.apply.vo.ApplyVo;

/**
 * <p>
 * 前端控制器
 * </p>
 *
 * @author jobob
 * @since 2020-03-25
 */
@RestController
@RequestMapping("/apply/apply")
public class ApplyController {

	@Autowired
	IApplyService applyService;
	@Autowired
	IItemService itemService;
	@Autowired
	IEmployeeService employeeService;

	/**
	 * 列表页面
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/list", method = RequestMethod.GET)
	public ModelAndView list(ModelAndView model) {
		model.setViewName("/apply/apply/list");
		return model;
	}

	/**
	 * 分页级联查询列表
	 * @param current
	 * @param size
	 * @param apply
	 * @return
	 */
	@RequestMapping(value = "/list", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> list(@RequestParam("page") int current, @RequestParam("rows") int size, ApplyVo apply) {
		Map<String, Object> ret = new HashMap<>();
		Page<ApplyVo> page = new Page<>();
		page.setCurrent(current);
		page.setSize(size);
		page = applyService.selectApplyPageVo(page, apply);
		ret.put("total", page.getTotal());
		ret.put("rows", page.getRecords());
		return ret;
	}


	/**
	 * 统计数据
	 * @param current
	 * @param size
	 * @param apply
	 * @return
	 */
	@RequestMapping(value="/summary",method = RequestMethod.POST)
	public Map<String, Object> summary(@RequestParam("page") int current, @RequestParam("rows") int size,
			ApplyVo apply) {
		Map<String, Object> ret = new HashMap<>();
		Page<ApplyVo> page = new Page<>();
		page.setCurrent(current);
		page.setSize(size);
		page = applyService.selectBySummary(page, apply);
		ret.put("total", page.getTotal());
		ret.put("rows", page.getRecords());
		// 计算合计  分类unit\totalPrice
		BigDecimal countTotal = applyService.countTotalPrice(apply);
		List<ApplyVo> footer = new ArrayList<>();
		ApplyVo av = new ApplyVo();
		String date = apply.getDate();
		Integer dateMode = apply.getDateMode();
		String unit = "";
		if(dateMode == 2) {
			unit = date.replaceFirst("-", "年") + "月";
		}
		if(dateMode == 3) {
			unit = date + "年";
		}
		av.setUnit(unit + "领用合计");
		av.setTotalPrice(countTotal);
		footer.add(av);
		ret.put("footer",footer);
		return ret;
	}
	/**
	 * 新增或修改
	 * @param category
	 * @return
	 */
	@RequestMapping(value = "/saveOrUpdate")
	@ResponseBody
	public Map<String, Object> addOrUpdate(Apply apply) {
		return applyService.addOrUpdate(apply);
	}

	/**
	 * 删除
	 * @param applyId
	 * @return
	 */
	@RequestMapping(value = "/delete")
	@ResponseBody
	public Map<String, Object> delete(@RequestParam(value="ids[]",defaultValue="")List<Integer> ids) {
		return applyService.deleteByIds(ids);

	}

}
