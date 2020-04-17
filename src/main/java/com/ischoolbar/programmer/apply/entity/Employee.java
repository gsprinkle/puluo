package com.ischoolbar.programmer.apply.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;

import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.experimental.Accessors;

/**
 * <p>
 * Ա
 * </p>
 *
 * @author jobob
 * @since 2020-03-25
 */
@Data
@EqualsAndHashCode
@Accessors(chain = true)
public class Employee{

    private static final long serialVersionUID = 1L;

    /**
     * Ա
     */
    @TableId(value = "eid", type = IdType.AUTO)
    private Integer eid;

    /**
     * Ա
     */
    private String ename;

    private Integer deptId;

    private String telphone;

    private String eremark;


}
