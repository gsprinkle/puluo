package com.ischoolbar.programmer.apply.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.IService;
import com.ischoolbar.programmer.apply.entity.Item;
import com.ischoolbar.programmer.apply.vo.ItemCategoryVo;

/**
 * <p>
 *  服务类
 * </p>
 *
 * @author jobob
 * @since 2020-03-25
 */
public interface IItemService extends IService<Item> {

	Page<ItemCategoryVo> selectItemCategoryVo(Page<ItemCategoryVo> page,Item item);
}
