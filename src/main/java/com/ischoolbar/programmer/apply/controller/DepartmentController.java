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
import com.ischoolbar.programmer.apply.entity.Department;
import com.ischoolbar.programmer.apply.service.IDepartmentService;

/**
 * <p>
 * 前端控制器
 * </p>
 *
 * @author jobob
 * @since 2020-03-25
 */
@RestController
@RequestMapping("/apply/department")
public class DepartmentController {
	
	public static Integer ALL_DEPARTMENT_ID = 1000;

	@Autowired
	IDepartmentService deptService;

	/**
	 * 列表页面
	 * 
	 * @return
	 */
	@RequestMapping(value = "/list", method = RequestMethod.GET)
	public ModelAndView listView(ModelAndView model) {
		model.setViewName("/apply/department/list");
		return model;
	}

	/**
	 * 分页条件查询
	 * 
	 * @param current
	 * @param size
	 * @param department
	 * @return
	 */
	@RequestMapping(value = "/list", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> list(@RequestParam("page") int current, @RequestParam("rows") int size, Department department) {
		Page<Department> page = new Page<>();
		page.setCurrent(current);
		page.setSize(size);
		page = (Page<Department>) deptService.selectDepartmentPage(page, department);

		Map<String, Object> ret = new HashMap<>();
		ret.put("total", page.getTotal());
		ret.put("rows", page.getRecords());
		return ret;
	}

	/**
	 * 新增或修改
	 * 
	 * @param department
	 * @return
	 */
	@RequestMapping(value = "/saveOrUpdate")
	@ResponseBody
	public Map<String, Object> add(Department department) {
		boolean hasId = department.getDeptId() == null ? false : true;
		Map<String, Object> ret = new HashMap<>();
		if (StringUtils.isEmpty(department.getDeptName())) {
			ret.put("type", "error");
			ret.put("msg", "部门名不能为空");
			return ret;
		}
		if (!hasId && isExist(department.getDeptName())) {
			ret.put("type", "error");
			ret.put("msg", "该部门已经存在，请重新输入！");
			return ret;
		}
		if (!deptService.saveOrUpdate(department)) {
			ret.put("type", "error");
			ret.put("msg", "新增部门异常，请联系管理员！");
			return ret;
		}
		ret.put("type", "success");
		ret.put("msg", hasId ? "部门修改成功！" : "部门添加成功！");
		return ret;

	}

	/**
	 * 删除
	 * 
	 * @param department
	 * @return
	 */
	@RequestMapping(value = "/delete")
	@ResponseBody
	public Map<String, Object> delete(@RequestParam(value="ids[]",defaultValue="")List<Integer> ids) {
		return deptService.deleteByIds(ids);

	}

	/**
	 * 获取部门下拉列表数据
	 * 
	 * @return
	 */
	@RequestMapping("/getDepartmentDropList")
	@ResponseBody
	public List<Department> getDepartmentDropList() {
		List<Department> deptList = deptService.list();
		Department department = new Department();
		department.setDeptName("所有部门");
		department.setDeptId(ALL_DEPARTMENT_ID);
		deptList.add(department);
		return deptList;
	}

	/**
	 * 判断该部门名称是否在数据库中已存在
	 * 
	 * @param deptName
	 * @return
	 */
	private boolean isExist(String deptName) {
		return deptService.getOne(new QueryWrapper<Department>().eq("dept_name", deptName)) == null ? false : true;
	}
}
