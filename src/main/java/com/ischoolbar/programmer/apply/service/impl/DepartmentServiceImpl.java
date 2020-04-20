package com.ischoolbar.programmer.apply.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.ischoolbar.programmer.apply.entity.Department;
import com.ischoolbar.programmer.apply.entity.Employee;
import com.ischoolbar.programmer.apply.mapper.DepartmentMapper;
import com.ischoolbar.programmer.apply.mapper.EmployeeMapper;
import com.ischoolbar.programmer.apply.service.IDepartmentService;
import com.ischoolbar.programmer.apply.service.IEmployeeService;

/**
 * <p>
 *  服务实现类
 * </p>
 *
 * @author jobob
 * @since 2020-03-25
 */
@Service
public class DepartmentServiceImpl extends ServiceImpl<DepartmentMapper, Department> implements IDepartmentService {
	@Autowired
	IEmployeeService empService;
	@Autowired
	EmployeeMapper empMapper;

	@Override
	public Page<Department> selectDepartmentPage(Page<Department> page, @Param("dept")Department department) {
		// TODO Auto-generated method stub
		return baseMapper.selectPageVo(page,department);
	}

	@Transactional
	@Override
	public Map<String, Object> deleteByIds(List<Integer> ids) {
		Map<String, Object> ret = new HashMap<>();
		int applyNum = 0;
		int empNum = 0;
		int deptNum = 0;
		try {
			// 迭代删除部门，该部门下的员工一并删除
			for(Integer id : ids) {
				List<Integer> eids = new ArrayList<>();
				List<Employee> empList = empMapper.selectList(new QueryWrapper<Employee>().eq("dept_id", id));
				// 如果该部门下的员工不为空，封装IDS
				if(empList != null && empList.size()>=1) {
					for(Employee emp : empList) {
						eids.add(emp.getEid());
					}
				}
				// 删除所有员工，一并删除员工相关的领用信息
				Map<String, Object> delEmps = empService.deleteByIds(eids);
				empNum += (Integer)delEmps.get("empNum");
				applyNum += (Integer)delEmps.get("applyNum");
				// 删除自身
				deptNum += baseMapper.deleteById(id);
			}
		}catch(Exception e) {
			e.printStackTrace();
			ret.put("type", "error");
			ret.put("msg", "删除部门异常，请联系管理员！");
			return ret;
		}
		String msg = "删除成功！共删除 " + deptNum + " 条部门信息、" + empNum + " 条员工信息和 " + applyNum + " 条领用信息";
		ret.put("type", "success");
		ret.put("msg", msg);
		ret.put("deptNum", deptNum);
		ret.put("empNum", empNum);
		ret.put("applyNum", applyNum);
		return ret;
	}

}
