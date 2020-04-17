<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@include file="../../common/header.jsp"%>
<script type="text/javascript" src="${ctx }/resources/js/echarts.js"></script>

<label>选择日期：</label>
<input id="search-applyDate" type="text" />
<div style="margin: 20px;">
	<a id="btn-month" class="easyui-linkbutton" data-option="iconCls:'icon-chart-curve'"  onclick="statsMonth()" href="#">月统计</a> 
	<a id="btn-year"  class="easyui-linkbutton"  data-option="iconCls:'icon-chart-curve'" onclick="statsYear()" href="#">年统计</a>
	<!-- 年月标识，1：月	 2：年 -->
	<input type="hidden" id="dateMode" value=1 />
	<!-- 日期 -->
	<input type="hidden" id="date" />
</div>

<!-- 为 ECharts 准备一个具备大小（宽高）的 DOM -->
<div id="main" style="width: 900px; height: 450px;"></div>

<script type="text/javascript">
	//基于准备好的dom，初始化echarts实例
	var myChart = echarts.init(document.getElementById('main'));

	// 指定图表的配置项和数据

	function setOption(title, keys, value1) {
		var option = {
			title : {
				text : title
			},
			tooltip : {
				trigger : 'axis',
				axisPointer : {
					type : 'cross'
				}
			},
			legend : {
				data : [ '统计' ]
			},
			grid : {
				left : '3%',
				right : '4%',
				bottom : '3%',
				containLabel : true
			},
			xAxis : {
				data : keys
			},
			yAxis : {
				type : 'value'
			},
			series : [ {
				name : '总价',
				type : 'bar',
				data : value1
			} ]
		};
		// 使用刚指定的配置项和数据显示图表。
		myChart.setOption(option);
	}
	$(document).ready(function() {
		statsMonth();
	});

	/*
		月统计
	 */
	function statsMonth() {
		// dateMode = 1
		$('#dateMode').val(1);
		$("#search-applyDate").datebox('setValue', getYearMonth());
		// 设置日期
		$('#date').val($('#search-applyDate').datebox('getValue'));
		$.ajax({
			url : 'charts',
			dataType : 'json',
			type : 'post',
			data : {
				dateMode : $('#dateMode').val(),
				date : $('#date').val()
			},
			success : function(data) {
				setOption($('#date').val() + '月统计', getKeys(data),getValues(data))
			}
		});
	}

	/*
		年统计
	 */
	function statsYear() {
		$('#dateMode').val(2);
		// 设置日期框
		$("#search-applyDate").datebox('setValue', new Date().getFullYear());
		// 设置日期
		$('#date').val($('#search-applyDate').datebox('getValue'));
		$.ajax({
			url : 'charts',
			dataType : 'json',
			type : 'post',
			data : {
				dateMode : $('#dateMode').val(),
				date : $('#date').val()
			},
			success : function(data) {
				setOption($('#date').val() + '年统计 ', getKeys(data),getValues(data))
			}
		});
	}
	function getKeys(data) {
		var keys = [];
		for (var i = 0; i < data.length; i++) {
			keys[i] = data[i].deptName;
		}
		return keys;
	}
	function getValues(data) {
		var values = [];
		for (var i = 0; i < data.length; i++) {
			values[i] = data[i].totalPrice;
		}
		return values;
	}
	function getRebackValues(keys, data) {
		var values = [];
		for (var i = 0; i < keys.length; i++) {
			values[i] = getValueFromRebackData(keys[i], data);
		}
		//console.log(values);
		return values;
	}
	function getValueFromRebackData(key, rebackData) {
		for (var i = 0; i < rebackData.length; i++) {
			if (isExistKey(key, rebackData[i]))
				return rebackData[i].money;
		}
		return 0;
	}
	function isExistKey(key, data) {
		if (data.statsDate == key)
			return true;
		return false;
	}/*
	 * 选择年月搜索
	 */
	$("#search-applyDate").datebox(
			{
				value : getYearMonth(),
				onSelect : function(date) {
					// 设置日期
					$('#date').val($('#search-applyDate').datebox('getValue'));
					$.ajax({
						url : 'charts',
						dataType : 'json',
						type : 'post',
						data : {
							dateMode : $('#dateMode').val(),
							date : $('#date').val()
						},
						success : function(data) {
							setOption($('#dateMode').val() == 1 ? '月统计 (注意总价单位为：分)' :'年统计 (注意总价单位为：分)', getKeys(data),getValues(data))
						}
					});
				},
				formatter : function(date) {
					var y = date.getFullYear();
					var m = date.getMonth() + 1;
					m = m < 10 ? '0' + m : m;
					var dateMode = $('#dateMode').val();
					if (dateMode == 1) {
						return y.toString() + '-' + m.toString();
					}
					if (dateMode == 2) {
						return y.toString();
					}
				},
				parser : function(date) {
					console.log(date);
					if (date) {
						var dateMode = $('#dateMode').val();
						if (dateMode == 1) {
							return new Date(String(date).substring(0, 4) + '-'
									+ String(date).substring(5, 7));
						}
						if (dateMode == 2) {
							return new Date(String(date).substring(0, 4));
						}
					} else {
						return new Date();
					}
				}
			})
</script>