package com.ischoolbar.programmer.apply.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.IService;
import com.ischoolbar.programmer.apply.entity.Employee;
import com.ischoolbar.programmer.apply.vo.EmployeeDepartmentVo;

/**
 * <p>
 * Ա 服务类
 * </p>
 *
 * @author jobob
 * @since 2020-03-25
 */
public interface IEmployeeService extends IService<Employee> {

	Page<EmployeeDepartmentVo> selectEmployeeDepartmentVo(Page<EmployeeDepartmentVo> page, Employee emp);

}
