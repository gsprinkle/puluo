package com.ischoolbar.programmer.apply.vo;

import java.math.BigDecimal;

import com.ischoolbar.programmer.apply.entity.Apply;

import lombok.Data;

/** 

* @author 作者 郭小雨

* @version 创建时间：2020年3月27日 下午3:29:49 

* 类说明 

*/
@Data
public class ApplyVo extends Apply{
	private String cname; 		// 物品分类
	private String itemName;	// 物品名称
	private String ename;		// 领取员工
	private String deptName; 	// 领取部门
	private BigDecimal itemPrice;		// 单价
	private String unit;		// 单位
	private BigDecimal totalPrice;	// 总价格
	
	
}
