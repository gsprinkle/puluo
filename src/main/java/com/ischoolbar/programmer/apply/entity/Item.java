package com.ischoolbar.programmer.apply.entity;

import java.math.BigDecimal;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;

import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.experimental.Accessors;

/**
 * <p>
 * 
 * </p>
 *
 * @author jobob
 * @since 2020-03-25
 */
@Data
@EqualsAndHashCode()
@Accessors(chain = true)
public class Item {

    private static final long serialVersionUID = 1L;

    @TableId(value = "item_id", type = IdType.AUTO)
    private Integer itemId;

    private String itemName;

    private String unit;

    private BigDecimal itemPrice;
    private Integer cid;
    private String itemRemark;

}
