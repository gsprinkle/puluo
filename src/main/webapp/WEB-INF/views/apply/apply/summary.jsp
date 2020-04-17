<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@include file="../../common/header.jsp"%>
<script type="text/javascript" src="${ctx }/resources/js/datagrid-export.js"></script>

<div class="easyui-layout" data-options="fit:true">

	<!-- Begin of toolbar -->
	<div>
		<a id="btn-month" href="#" class="easyui-linkbutton" data-options="plain:true">月统计</a> 
		<a id="btn-year" href="#" class="easyui-linkbutton" data-options="plain:true">年统计</a>
		<a id="btn-export" href="#" class="easyui-linkbutton" data-options="plain:true">导出Excel</a>
	</div>
	<!-- 年月标识，1：月	 2：年 -->
	<input type="hidden" id="dateMode" value=1 />

	<div id="wu-toolbar">
		<div class="wu-toolbar-button">
			<%@include file="../../common/menus.jsp"%>
		</div>
		<div class="wu-toolbar-search">
			<label>部门:</label> 
			<input id="search-department" class="easyui-combobox" type="text"
				data-options="
			url:'../department/getDepartmentDropList',
			valueField:'deptId',textField:'deptName',
			onSelect : function(val){
				$('#data-datagrid').datagrid('reload',{
					'deptId' : $('#search-department').combobox('getValue'),
					'date' : $('#search-applyDate').datebox('getValue'),
					'dateMode' : $('#dateMode').val()
				})
			}			
			">
			<label>月份：</label> <input id="search-applyDate" type="text" />
			<!-- <a href="#" id="search-btn"	class="easyui-linkbutton" iconCls="icon-search">搜索</a> -->
		</div>

	</div>
	<!-- End of toolbar -->
	<table id="data-datagrid" class="easyui-datagrid" toolbar="#wu-toolbar"></table>
</div>
<style>
.selected {
	background: red;
}
</style>
<!-- Begin of easyui-dialog -->

<%@include file="../../common/footer.jsp"%>

<!-- End of easyui-dialog -->
<script type="text/javascript">

$('#search-department').combobox({
	onLoadSuccess : function(){
		var val = $(this).combobox('getData');
		if(val != null){
			$(this).combobox('select',val[0].deptId);
			$('#data-datagrid').datagrid('reload');
		}
	}
})
	/**
	 * 点击月统计按钮
	 */
	$('#btn-month').click(function() {
		$('#dateMode').val(1);
		$("#search-applyDate").datebox('setValue', getYearMonth());
		$('#data-datagrid').datagrid('load', {
			'deptId' : $('#search-department').combobox('getValue'),
			'date' : $('#search-applyDate').datebox('getValue'),
			'dateMode' : $('#dateMode').val()
		});
		$('#data-datagrid').datagrid('reloadFooter');
	})

	$('#btn-year').click(function() {
		$('#dateMode').val(2);
		// 设置日期框
		$("#search-applyDate").datebox('setValue', new Date().getFullYear());
		$('#data-datagrid').datagrid('load', {
			'deptId' : $('#search-department').combobox('getValue'),
			'date' : $('#search-applyDate').datebox('getValue'),
			'dateMode' : $('#dateMode').val()
		});
		$('#data-datagrid').datagrid('reloadFooter');
	})
/**
 * 导入Excel
 */
 $('#btn-export').click(function(){
	 var date = $('#search-applyDate').datebox('getValue');
	 var dateMode = $('#dateMode').val();
	 var name ='';
	 name = date + ((dateMode == 1 ? '月统计.xls' : '年统计.xls')); 
	 $('#data-datagrid').datagrid('toExcel',name);
 });
	/*
	 * 选择年月搜索
	 */
	$("#search-applyDate").datebox(
			{
				value : getYearMonth(),
				onSelect : function(date) {
					$('#data-datagrid').datagrid(
							'reload',
							{
								'deptId' : $('#search-department').combobox(
										'getValue'),
								'date' : $('#search-applyDate').datebox(
										'getValue'),
								'dateMode' : $('#dateMode').val()
							})
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

	/** 
	 * 载入数据
	 */
	$('#data-datagrid').datagrid({
		url : 'list',
		rownumbers : true,
		singleSelect : true,
		pageSize : 100,
		pageList : [20,40,60,80,100],
		pagination : true,
		multiSort : true,
		fitColumns : false,
		idField : 'applyId',
		fit : false,
		showFooter : true,
		queryParams : {
			date : $('#search-applyDate').datebox('getValue'),
			dateMode : $('#dateMode').val(),
		},
		columns : [ [ {
			field : 'date',
			title : ($('#dateMode').val() == 1) ? '领取年月' : '领取年',
			width : 100,
			sortable : true
		}, {
			field : 'deptName',
			title : '领取部门',
			width : 100,
			sortable : true
		}, {
			field : 'cname',
			title : '物品分类',
			width : 100,
			sortable : true
		}, {
			field : 'totalPrice',
			title : '总价',
			width : 100,
			sortable : true,
			formatter : function(value) {
				return "¥ " + value.toFixed(2);
			}
		}, ] ],
		onLoadSuccess : function(data) {
			$('#data-datagrid').datagrid('unselectAll');
		}
	});
</script>