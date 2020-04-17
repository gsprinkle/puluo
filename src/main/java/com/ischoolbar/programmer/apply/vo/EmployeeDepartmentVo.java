package com.ischoolbar.programmer.apply.vo;

import com.ischoolbar.programmer.apply.entity.Employee;

import lombok.Data;

/** 

* @author 作者 郭小雨

* @version 创建时间：2020年3月27日 下午12:16:38 

* 类说明 

*/
@Data
public class EmployeeDepartmentVo extends Employee{
	private String deptName;
}
