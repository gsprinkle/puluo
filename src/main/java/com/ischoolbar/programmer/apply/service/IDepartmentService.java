package com.ischoolbar.programmer.apply.service;

import com.ischoolbar.programmer.apply.entity.Department;

import java.util.List;
import java.util.Map;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.IService;

/**
 * <p>
 *  服务类
 * </p>
 *
 * @author jobob
 * @since 2020-03-25
 */
public interface IDepartmentService extends IService<Department> {

	Page<Department> selectDepartmentPage(Page<Department> page, Department department);

	Map<String, Object> deleteByIds(List<Integer> ids);

}
