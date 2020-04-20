package com.ischoolbar.programmer.apply.service;

import com.ischoolbar.programmer.apply.entity.Category;

import java.util.List;
import java.util.Map;

import com.baomidou.mybatisplus.core.metadata.IPage;
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
public interface ICategoryService extends IService<Category> {
	IPage<Category> selectCategoryPage(Page<Category> page,Category category);

	Map<String, Object> deleteByIds(List<Integer> ids);
}
