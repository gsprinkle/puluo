<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@include file="../../common/header.jsp"%>
<div class="easyui-layout" data-options="fit:true">
	<!-- Begin of toolbar -->
	<div id="wu-toolbar">
		<div class="wu-toolbar-button">
			<%@include file="../../common/menus.jsp"%>
		</div>
		<div class="wu-toolbar-search">
			<label>部门:</label> <input id="search-department"
				class="easyui-combobox" type="text"
				data-options="
			url:'../department/getDepartmentDropList',
			valueField:'deptId',textField:'deptName',
			onSelect : function(val){
				$('#data-datagrid').datagrid('reload',{
					'deptId' : $('#search-department').combobox('getValue'),
					'applyDate' : $('#search-applyDate').datebox('getValue')
				})
			}
			">
			<label>日期：</label> <input id="search-applyDate" type="text" />
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
<div id="add-dialog" class="easyui-dialog"
	data-options="closed:true,iconCls:'icon-save'"
	style="width: 450px; padding: 10px;">
	<form id="add-form" method="post">
		<table>
			<!-- 物品分类  cid  略-->
			<!-- 领取日期 apply_date -->
			<tr>
				<td width="60" align="right">领取日期:</td>
				<td><input type="text" name="applyDate" class="easyui-datebox"
					data-options="required:true,
					missingMessage:'请选择领取日期',
					value:getCurDate()" />
				</td>
			</tr>
			<!-- 物品名称 item_id -->
			<tr>
				<td width="70" align="right">物品:</td>
				<td><input type="text" id="add-cc-item" name="itemId"
					class="easyui-combobox"
					data-options="required:true, 
					missingMessage:'请从下拉框中选择物品',
					valueField:'itemId',
					textField:'itemName',
					url : '../item/getItemDropList',
					onLoadSuccess : function(){
						var data = $('#add-cc-item').combobox('getData');
						if(data && data.length >0){
							$('#add-cc-item').combobox('setValue',data[0].itemId);
						}
					}
					" />
				</td>
			</tr>
			<!-- 领取数量  apply_num -->
			<tr>
				<td width="60" align="right">数量:</td>
				<td><input type="text" name="applyNum"
					class="easyui-numberbox easyui-validatebox"
					data-options="required:true, missingMessage:'物品数量，只可填写数字',value:1" />
				</td>
			</tr>
			<!-- 部门 dept_id 略-->
			<!-- 领取员工 eid -->
			<tr>
				<td width="60" align="right">领取人:</td>
				<td><input type="text" name="eid" class="easyui-combobox"
					data-options="required:true, 
					missingMessage:'请选择领取人',
					url : '../employee/getEmployeeDropList',
					valueField:'eid',
					textField:'ename'
					" />
				</td>
			</tr>
			<!-- 备注  apply_remark -->
			<tr>
				<td align="right">备注:</td>
				<td><textarea name="itemRemark" rows="6" class="wu-textarea"
						style="width: 260px"></textarea></td>
			</tr>
		</table>
	</form>
</div>


<!-- 修改窗口 -->
<div id="edit-dialog" class="easyui-dialog"
	data-options="closed:true,iconCls:'icon-save'"
	style="width: 450px; padding: 10px;">
	<form id="edit-form" method="post">
		<table>
			<!-- 物品分类  cid  略-->
			<input type="hidden" name="applyId" id="edit-applyId" />
			<!-- 领取日期 apply_date -->
			<tr>
				<td width="60" align="right">领取日期:</td>
				<td><input type="text" id="edit-applyDate" name="applyDate"
					class="easyui-datebox"
					data-options="required:true,
					missingMessage:'请选择领取日期',
					value:getCurDate()" />
				</td>
			</tr>
			<!-- 物品名称 item_id -->
			<tr>
				<td width="70" align="right">物品:</td>
				<td><input type="text" id="edit-itemId" name="itemId"
					class="easyui-combobox"
					data-options="required:true, 
					missingMessage:'请从下拉框中选择物品',
					valueField:'itemId',
					textField:'itemName',
					url : '../item/getItemDropList',
					" />
				</td>
			</tr>
			<!-- 领取数量  apply_num -->
			<tr>
				<td width="60" align="right">数量:</td>
				<td><input type="text" id="edit-applyNum" name="applyNum"
					class="easyui-numberbox easyui-validatebox"
					data-options="required:true, missingMessage:'物品数量，只可填写数字'," /></td>
			</tr>
			<!-- 部门 dept_id 略-->
			<!-- 领取员工 eid -->
			<tr>
				<td width="60" align="right">领取人:</td>
				<td><input type="text" name="eid" id="edit-eid"
					class="easyui-combobox"
					data-options="required:true, 
					missingMessage:'请选择领取人',
					url : '../employee/getEmployeeDropList',
					valueField:'eid',
					textField:'ename'
					" />
				</td>
			</tr>
			<!-- 备注  apply_remark -->
			<tr>
				<td align="right">备注:</td>
				<td><textarea name="applyRemark" id="edit-applyRemark" rows="6"
						class="wu-textarea" style="width: 260px"></textarea></td>
			</tr>
		</table>
	</form>
</div>


<%@include file="../../common/footer.jsp"%>

<!-- End of easyui-dialog -->
<script type="text/javascript">
	/*
	 * 选择日期时搜索
	 */
	$("#search-applyDate").datebox({
		value : getCurDate(),
		onSelect : function(date) {
			$('#data-datagrid').datagrid('reload', {
				'deptId' : $('#search-department').combobox('getValue'),
				'applyDate' : $('#search-applyDate').datebox('getValue')
			})
		}
	})

	/**
	 *  添加记录
	 */
	function add() {
		var validate = $("#add-form").form("validate");
		if (!validate) {
			$.messager.alert("消息提醒", "请检查你输入的数据!", "warning");
			return;
		}
		var data = $("#add-form").serialize();
		$.ajax({
			url : '../apply/saveOrUpdate',
			dataType : 'json',
			type : 'post',
			data : data,
			success : function(data) {
				if (data.type == 'success') {
					$.messager.alert('信息提示', '添加成功！', 'info');
					$('#add-dialog').dialog('close');
					$('#data-datagrid').datagrid('reload');
				} else {
					$.messager.alert('信息提示', data.msg, 'warning');
				}
			}
		});
	}

	/**
	 * Name 修改记录
	 */
	function edit() {
		var validate = $("#edit-form").form("validate");
		if (!validate) {
			$.messager.alert("消息提醒", "请检查你输入的数据!", "warning");
			return;
		}

		var data = $("#edit-form").serialize();
		$.ajax({
			url : '../apply/saveOrUpdate',
			dataType : 'json',
			type : 'post',
			data : data,
			success : function(data) {
				if (data.type == 'success') {
					$.messager.alert('信息提示', '修改成功！', 'info');
					$('#edit-dialog').dialog('close');
					$('#data-datagrid').datagrid('reload');
				} else {
					$.messager.alert('信息提示', data.msg, 'warning');
				}
			}
		});
	}

	/**
	 * 删除记录
	 */
	function remove() {
		$.messager.confirm('信息提示', '确定要删除该记录？', function(result) {
			if (result) {
				var item = $('#data-datagrid').datagrid('getSelected');
				$.ajax({
					url : '../apply/delete',
					dataType : 'json',
					type : 'post',
					data : {
						applyId : item.applyId
					},
					success : function(data) {
						if (data.type == 'success') {
							$.messager.alert('信息提示', '删除成功！', 'info');
							$('#data-datagrid').datagrid('reload');
						} else {
							$.messager.alert('信息提示', data.msg, 'warning');
						}
					}
				});
			}
		});
	}

	/**
	 * Name 打开添加窗口
	 */
	function openAdd() {
		//$('#add-form').form('clear');
		$('#add-dialog').dialog({
			closed : false,
			modal : true,
			title : "添加信息",
			buttons : [ {
				text : '确定',
				iconCls : 'icon-ok',
				handler : add
			}, {
				text : '取消',
				iconCls : 'icon-cancel',
				handler : function() {
					$('#add-dialog').dialog('close');
				}
			} ]
		});
	}

	/**
	 * 打开修改窗口
	 */
	function openEdit() {
		//$('#edit-form').form('clear');
		var item = $('#data-datagrid').datagrid('getSelected');
		if (item == null || item.length == 0) {
			$.messager.alert('信息提示', '请选择要修改的数据！', 'info');
			return;
		}

		$('#edit-dialog').dialog(
				{
					closed : false,
					modal : true,
					title : "修改信息",
					buttons : [ {
						text : '确定',
						iconCls : 'icon-ok',
						handler : edit
					}, {
						text : '取消',
						iconCls : 'icon-cancel',
						handler : function() {
							$('#edit-dialog').dialog('close');
						}
					} ],
					onBeforeOpen : function() {
						$("#edit-applyId").val(item.applyId);
						$("#edit-itemId").combobox('setValue', item.itemId);
						$("#edit-eid").combobox('setValue', item.eid);
						$("#edit-applyNum")
								.numberbox("setValue", item.applyNum);
						$("#edit-applyDate").datebox('setValue',
								myformatter(new Date(item.applyDate)));
						$("#edit-applyRemark").val(item.applyRemark);
					}
				});
	}

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
			applyDate : $('#search-applyDate').datebox('getValue')
		},
		columns : [ [ {
			field : 'chk',
			checkbox : true
		}, {
			field : 'applyDate',
			title : '领取日期',
			width : 100,
			sortable : true,
			formatter : function(value) {
				if (value) {
					return myformatter(new Date(value));
				}

			}
		}, {
			field : 'cname',
			title : '物品分类',
			width : 100,
			sortable : true
		}, {
			field : 'itemName',
			title : '物品名称',
			width : 100,
			sortable : true
		}, {
			field : 'eid',
			title : '员工',
			width : 100,
			sortable : true,
			hidden : true
		}, {
			field : 'itemPrice',
			title : '单价',
			width : 100,
			sortable : true,
			formatter : function(value) {
				if (value) {
					return "¥ " + value
				}
			}
		}, {
			field : 'applyNum',
			title : '领取数量',
			width : 100,
			sortable : true
		}, {
			field : 'cid',
			title : '物品分类ID',
			width : 100,
			sortable : true,
			hidden : true
		}, {
			field : 'itemId',
			title : '物品ID',
			width : 100,
			sortable : true,
			hidden : true
		}, {
			field : 'deptId',
			title : '部门ID',
			width : 100,
			sortable : true,
			hidden : true
		}, {
			field : 'unit',
			title : '单位',
			width : 100,
			sortable : true
		}, {
			field : 'totalPrice',
			title : '总价',
			width : 100,
			sortable : true,
			formatter : function(value) {
				return "¥ " + value;
			}
		}, {
			field : 'deptName',
			title : '领取部门',
			width : 100,
			sortable : true
		}, {
			field : 'ename',
			title : '领取员工',
			width : 100,
			sortable : true
		}, {
			field : 'applyRemark',
			title : '备注',
			width : 100,
			sortable : true
		}, ] ],
		onLoadSuccess : function(data) {
			$('#data-datagrid').datagrid('unselectAll');
		}
	});
</script>