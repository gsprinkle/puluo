package com.ischoolbar.programmer.apply.mapper;

import com.ischoolbar.programmer.apply.entity.Department;

import org.apache.ibatis.annotations.Param;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;

/**
 * <p>
 *  Mapper 接口
 * </p>
 *
 * @author jobob
 * @since 2020-03-25
 */
public interface DepartmentMapper extends BaseMapper<Department> {

	Page<Department> selectPageVo(Page<Department> page, @Param("dept")Department department);

}
