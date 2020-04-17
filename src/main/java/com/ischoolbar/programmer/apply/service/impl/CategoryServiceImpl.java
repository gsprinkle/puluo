package com.ischoolbar.programmer.apply.service.impl;

import com.ischoolbar.programmer.apply.entity.Category;
import com.ischoolbar.programmer.apply.mapper.CategoryMapper;
import com.ischoolbar.programmer.apply.service.ICategoryService;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
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
public class CategoryServiceImpl extends ServiceImpl<CategoryMapper, Category> implements ICategoryService {

	@Override
	public IPage<Category> selectCategoryPage(Page<Category> page, Category category) {
		return baseMapper.selectPageVo(page, category);
	}

}
