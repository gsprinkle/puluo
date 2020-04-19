package com.ischoolbar.programmer.apply.vo;

import java.math.BigDecimal;

import com.ischoolbar.programmer.apply.entity.Inventory;

import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = false)
public class InventoryVo extends Inventory {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private BigDecimal itemPrice; // 商品单价
	private String unit;			// 商品单位
	private BigDecimal totalPrice; // 单个商品的总价格
	private Integer cid;
	private String cname; // 商品分类名称
}
