package com.ischoolbar.programmer.apply.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.ischoolbar.programmer.apply.entity.Apply;
import com.ischoolbar.programmer.apply.vo.ApplyVo;

/**
 * <p>
 *  Mapper 接口
 * </p>
 *
 * @author jobob
 * @since 2020-03-25
 */
public interface ApplyMapper extends BaseMapper<Apply> {

	Page<ApplyVo> selectApplyPageVo(Page<ApplyVo> page,@Param("apply")Apply apply);
	Page<ApplyVo> selectBySummary(Page<ApplyVo> page,@Param("apply")Apply apply);
	List<ApplyVo> selectByChart(@Param("apply")Apply apply);
}
