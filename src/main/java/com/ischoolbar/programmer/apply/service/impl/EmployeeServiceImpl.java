package com.ischoolbar.programmer.apply.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.ischoolbar.programmer.apply.entity.Apply;
import com.ischoolbar.programmer.apply.entity.Employee;
import com.ischoolbar.programmer.apply.entity.Item;
import com.ischoolbar.programmer.apply.entity.Stock;
import com.ischoolbar.programmer.apply.mapper.ApplyMapper;
import com.ischoolbar.programmer.apply.mapper.EmployeeMapper;
import com.ischoolbar.programmer.apply.mapper.StockMapper;
import com.ischoolbar.programmer.apply.service.IEmployeeService;
import com.ischoolbar.programmer.apply.vo.EmployeeDepartmentVo;

/**
 * <p>
 * Ա 服务实现类
 * </p>
 *
 * @author jobob
 * @since 2020-03-25
 */
@Service
public class EmployeeServiceImpl extends ServiceImpl<EmployeeMapper, Employee> implements IEmployeeService {
	@Autowired
	ApplyMapper applyMapper;

	@Override
	public Page<EmployeeDepartmentVo> selectEmployeeDepartmentVo(Page<EmployeeDepartmentVo> page, Employee emp) {
		return baseMapper.selectEmployeeDepartmentVo(page, emp);
	}

	@Transactional
	@Override
	public Map<String, Object> deleteByIds(List<Integer> ids) {
		Map<String, Object> ret = new HashMap<>();
		int applyNum = 0;
		int empNum = 0;
		try {
			// 删除员工，一并删除该员工相关的领用信息
			// 查询出
			for (Integer id : ids) {
				//先查询自己是否存在,不存在跳过
				Employee emp = baseMapper.selectById(id);
				if(emp == null){
					continue;
				}
				// 删除与该员工相关的领用信息
				applyNum += applyMapper.delete(new QueryWrapper<Apply>().eq("eid", id));
				// 删除该员工
				empNum += baseMapper.deleteById(id);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			ret.put("type", "error");
			ret.put("msg", "删除员工异常，请联系管理员！");
			return ret;
		}
		String msg = "删除成功！共删除 " + empNum + " 条员工信息和 " + applyNum + " 条领用信息";
		ret.put("type", "success");
		ret.put("msg", msg);
		ret.put("applyNum", applyNum);
		ret.put("empNum", empNum);
		return ret;
	}
}
