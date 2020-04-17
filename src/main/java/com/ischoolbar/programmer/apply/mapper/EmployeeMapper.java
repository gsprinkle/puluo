package com.ischoolbar.programmer.apply.mapper;

import org.apache.ibatis.annotations.Param;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.ischoolbar.programmer.apply.entity.Employee;
import com.ischoolbar.programmer.apply.vo.EmployeeDepartmentVo;

/**
 * <p>
 * Ա Mapper 接口
 * </p>
 *
 * @author jobob
 * @since 2020-03-25
 */
public interface EmployeeMapper extends BaseMapper<Employee> {

	Page<EmployeeDepartmentVo> selectEmployeeDepartmentVo(Page<EmployeeDepartmentVo> page, @Param("emp")Employee emp);

}
