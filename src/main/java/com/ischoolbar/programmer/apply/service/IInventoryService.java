package com.ischoolbar.programmer.apply.service;

import com.ischoolbar.programmer.apply.entity.Inventory;
import com.ischoolbar.programmer.apply.vo.InventoryVo;

import java.math.BigDecimal;
import java.util.Map;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.IService;

/**
 * <p>
 *  服务类
 * </p>
 *
 * @author jobob
 * @since 2020-04-14
 */
public interface IInventoryService extends IService<Inventory> {

	Map<String, Object> initialize();

	Page<InventoryVo> selectByPage(Page<InventoryVo> page, InventoryVo inventory);

	BigDecimal countTotalPrice();
}
