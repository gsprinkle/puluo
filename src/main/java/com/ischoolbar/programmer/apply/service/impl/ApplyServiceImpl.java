package com.ischoolbar.programmer.apply.service.impl;

import java.math.BigDecimal;
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
import com.ischoolbar.programmer.apply.entity.Inventory;
import com.ischoolbar.programmer.apply.entity.Item;
import com.ischoolbar.programmer.apply.mapper.ApplyMapper;
import com.ischoolbar.programmer.apply.mapper.EmployeeMapper;
import com.ischoolbar.programmer.apply.mapper.InventoryMapper;
import com.ischoolbar.programmer.apply.mapper.ItemMapper;
import com.ischoolbar.programmer.apply.service.IApplyService;
import com.ischoolbar.programmer.apply.vo.ApplyVo;

/**
 * <p>
 * 服务实现类
 * </p>
 *
 * @author jobob
 * @since 2020-03-25
 */
@Service
public class ApplyServiceImpl extends ServiceImpl<ApplyMapper, Apply> implements IApplyService {

	@Autowired
	ItemMapper itemMapper;

	@Autowired
	EmployeeMapper empMapper;
	@Autowired
	InventoryMapper inventoryMapper;

	@Override
	public Page<ApplyVo> selectApplyPageVo(Page<ApplyVo> page, Apply apply) {
		return baseMapper.selectApplyPageVo(page, apply);
	}

	@Override
	public Page<ApplyVo> selectBySummary(Page<ApplyVo> page, Apply apply) {
		return baseMapper.selectBySummary(page, apply);
	}

	@Override
	public BigDecimal countTotalPrice(Apply apply) {
		return baseMapper.countTotalPrice(apply);
	}

	@Transactional(rollbackFor = Exception.class)
	@Override
	public Map<String, Object> deleteByIds(List<Integer> ids) {
		Map<String, Object> ret = new HashMap<>();
		// 定义计数器
		int applyNum = 0;
		// 迭代删除领用信息
		for(Integer id : ids){
			// 首先更新库存，领用信息删除后，库存应该增加相应的物品数量
			// 先查询自己是否存在,不存在跳过
			Apply apply = baseMapper.selectById(id);
			if(apply == null) {
				continue;
			}
			// 查出对应的库存对象
			Inventory inv = inventoryMapper.selectOne(new QueryWrapper<Inventory>().eq("item_id", apply.getItemId()));
			if(inv == null){
				ret.put("type", "error");
				ret.put("msg", "库存数据损坏，请先初始化库存");
				return ret;
			}
			inv.setInventoryNum(inv.getInventoryNum() + apply.getApplyNum());
			inventoryMapper.updateById(inv);
			// 删除自己
			applyNum += baseMapper.deleteById(id);
		}
		ret.put("type", "success");
		ret.put("msg", "删除成功！共删除 " + applyNum + " 个领用信息。");
		return ret;
	}

	@Override
	public Map<String, Object> addOrUpdate(Apply apply) {
		Map<String, Object> ret = new HashMap<>();
		boolean hasId = apply.getApplyId() == null ? false : true;
		// 设置部门
		Integer deptId = empMapper.selectById(apply.getEid()).getDeptId();
		apply.setDeptId(deptId);
		// 查询物品对象
		Item item = itemMapper.selectById(apply.getItemId());
		// 查询物品对应的库存对象
		Inventory inv = inventoryMapper.selectOne(new QueryWrapper<Inventory>().eq("item_id", item.getItemId()));
		// 如果库存列表中不存在该物品，则新建并设置属性,
		if (inv == null) {
			inv = new Inventory();
			inv.setItemId(item.getItemId());
			inv.setItemName(item.getItemName());
			inv.setInventoryNum(0);
			inventoryMapper.insert(inv);
		}
		

		if (hasId) {// 有领用ID，表示是修改领用信息
			// 获取旧的领用数量，新的领用数量-旧的领用数量，库存量-差量
			Apply oldApply = baseMapper.selectById(apply.getApplyId());
			Integer diffValue = apply.getApplyNum() - oldApply.getApplyNum();
			// 修改库存量并更新到数据库
			inv.setInventoryNum(inv.getInventoryNum() - diffValue);
			inventoryMapper.updateById(inv);
			// 修改领用信息
			baseMapper.updateById(apply);
		}else{ // 没有领用ID，表示是新增领用信息
			// 数据校验
			if (apply.getItemId() == null) {
				ret.put("type", "error");
				ret.put("msg", "物品不能为空");
				return ret;
			}
			if (apply.getEid() == null) {
				ret.put("type", "error");
				ret.put("msg", "领取人不能为空");
				return ret;
			}
			if (apply.getApplyNum() == null || apply.getApplyNum() == 0) {
				ret.put("type", "error");
				ret.put("msg", "请正确填写领取数量");
				return ret;
			}
			if (apply.getApplyDate() == null) {
				ret.put("type", "error");
				ret.put("msg", "请选择正确的领取日期");
				return ret;
			}
			// 检查当天是否已经存在同日期、同员工、同物品的领用信息
			List<Apply> applyList = baseMapper.selectList(new QueryWrapper<Apply>().eq("item_id", apply.getItemId()).eq("apply_date", apply.getApplyDate()).eq("eid", apply.getEid()));
			// 如果存在，提示用户去修改
			if(applyList != null && applyList.size()>0){
				ret.put("type", "error");
				ret.put("msg", apply.getApplyDate().toString() + "已添加过同员工同物品的领用信息，无需再次添加");
				return ret;
			}
			// 不存在，新增,先更新库存信息，领用了多少，库存应该减少多少
			inv.setInventoryNum(inv.getInventoryNum() - apply.getApplyNum());
			inventoryMapper.updateById(inv);
			// 执行领用信息新增
			baseMapper.insert(apply);
		}
		ret.put("type", "success");
		ret.put("msg", hasId ? "修改成功！" : "添加成功！");
		return ret;
	}

}
