package com.ischoolbar.programmer.apply.service.impl;

import com.ischoolbar.programmer.apply.entity.Department;
import com.ischoolbar.programmer.apply.mapper.DepartmentMapper;
import com.ischoolbar.programmer.apply.service.IDepartmentService;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Service;

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

	@Override
	public Page<Department> selectDepartmentPage(Page<Department> page, @Param("dept")Department department) {
		// TODO Auto-generated method stub
		return baseMapper.selectPageVo(page,department);
	}

	@Override
	public Map<String, Object> deleteByIds(List<Integer> ids) {
		// TODO Auto-generated method stub
		return null;
	}

}
