package com.ischoolbar.programmer.apply.entity;




import java.sql.Date;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
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
@EqualsAndHashCode
@Accessors(chain = true)
public class Apply {

    private static final long serialVersionUID = 1L;
    @TableField(exist = false)
    private Integer dateMode = 0;// 0:日期查询，1：月份查询  2：年查询
    @TableField(exist = false)
    private String date;

    @TableId(value = "apply_id", type = IdType.AUTO)
    private Integer applyId;
    private Integer cid;
    private Integer itemId;
    private Integer deptId;
    private Integer eid;
    private Integer applyNum;
    private Date applyDate;
    private String applyRemark;

}
