package com.ischoolbar.programmer.apply.entity;

import java.io.Serializable;
import java.sql.Date;

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
 * @since 2020-04-14
 */
@Data
@EqualsAndHashCode(callSuper = false)
@Accessors(chain = true)
public class Stock implements Serializable {

    private static final long serialVersionUID = 1L;

    @TableId(value = "stock_id", type = IdType.AUTO)
    private Integer stockId;

    private Integer itemId;

    private Date stockDate;

    private Integer stockNum;

    private String stockRemark;
    
    


}
