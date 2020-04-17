package com.ischoolbar.programmer.apply.service.impl;

import org.springframework.stereotype.Service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.ischoolbar.programmer.apply.entity.Item;
import com.ischoolbar.programmer.apply.mapper.ItemMapper;
import com.ischoolbar.programmer.apply.service.IItemService;
import com.ischoolbar.programmer.apply.vo.ItemCategoryVo;

/**
 * <p>
 *  服务实现类
 * </p>
 *
 * @author jobob
 * @since 2020-03-25
 */
@Service
public class ItemServiceImpl extends ServiceImpl<ItemMapper, Item> implements IItemService {

	@Override
	public Page<ItemCategoryVo> selectItemCategoryVo(Page<ItemCategoryVo> page, Item item) {
		return baseMapper.selectItemCategoryVo(page, item);
	}

}
