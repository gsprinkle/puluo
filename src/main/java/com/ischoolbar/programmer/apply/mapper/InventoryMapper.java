package com.ischoolbar.programmer.apply.mapper;

import com.ischoolbar.programmer.apply.entity.Inventory;
import com.ischoolbar.programmer.apply.vo.InventoryVo;

import java.math.BigDecimal;

import org.apache.ibatis.annotations.Param;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;

/**
 * <p>
 *  Mapper 接口
 * </p>
 *
 * @author jobob
 * @since 2020-04-14
 */
public interface InventoryMapper extends BaseMapper<Inventory> {

	Page<InventoryVo> selectByPage(Page<InventoryVo> page, @Param("inv")InventoryVo inventory);
	
	BigDecimal countTotalPrice();

}
