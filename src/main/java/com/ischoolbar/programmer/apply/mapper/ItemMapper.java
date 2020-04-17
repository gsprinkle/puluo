package com.ischoolbar.programmer.apply.mapper;

import org.apache.ibatis.annotations.Param;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.ischoolbar.programmer.apply.entity.Item;
import com.ischoolbar.programmer.apply.vo.ItemCategoryVo;

/**
 * <p>
 *  Mapper 接口
 * </p>
 *
 * @author jobob
 * @since 2020-03-25
 */
public interface ItemMapper extends BaseMapper<Item> {

	Page<ItemCategoryVo> selectItemCategoryVo(Page<ItemCategoryVo> page,@Param("item")Item item);
}
