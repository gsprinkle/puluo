package com.ischoolbar.programmer.apply.service.impl;

import com.ischoolbar.programmer.apply.entity.Stock;
import com.ischoolbar.programmer.apply.mapper.StockMapper;
import com.ischoolbar.programmer.apply.service.IStockService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.stereotype.Service;

/**
 * <p>
 *  服务实现类
 * </p>
 *
 * @author jobob
 * @since 2020-04-14
 */
@Service
public class StockServiceImpl extends ServiceImpl<StockMapper, Stock> implements IStockService {

}
