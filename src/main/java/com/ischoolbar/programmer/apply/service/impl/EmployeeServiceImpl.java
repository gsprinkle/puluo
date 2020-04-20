package com.ischoolbar.programmer.apply.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.ischoolbar.programmer.apply.entity.Employee;
import com.ischoolbar.programmer.apply.mapper.EmployeeMapper;
import com.ischoolbar.programmer.apply.service.IEmployeeService;
import com.ischoolbar.programmer.apply.vo.EmployeeDepartmentVo;

/**
 * <p>
 * Ա 服务实现类
 * </p>
 *
 * @author jobob
 * @since 2020-03-25
 */
@Service
public class EmployeeServiceImpl extends ServiceImpl<EmployeeMapper, Employee> implements IEmployeeService {
	@Override
	public Page<EmployeeDepartmentVo> selectEmployeeDepartmentVo(Page<EmployeeDepartmentVo> page, Employee emp) {
		return baseMapper.selectEmployeeDepartmentVo(page, emp);
	}

	@Override
	public Map<String, Object> deleteByIds(List<Integer> ids) {
		// TODO Auto-generated method stub
		return null;
	}
}
