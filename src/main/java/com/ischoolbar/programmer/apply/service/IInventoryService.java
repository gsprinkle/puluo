package com.ischoolbar.programmer.apply.service;

import com.ischoolbar.programmer.apply.entity.Inventory;

import java.util.Map;

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

}
