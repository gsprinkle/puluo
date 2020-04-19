package com.ischoolbar.programmer.apply.vo;

import java.math.BigDecimal;

import com.ischoolbar.programmer.apply.entity.Stock;

import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = false)
public class StockVo extends Stock{
	private String cname;
	private String itemName;// 物品名称
	private String unit;//
	private BigDecimal itemPrice;// 物品价格
	private BigDecimal totalPrice;
	
	
	// 查询字段，不映射数据库
    private Integer dateMode;
    private String date;
    private String summaryDate;
}
