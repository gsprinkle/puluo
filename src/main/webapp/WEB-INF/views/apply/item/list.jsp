<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@include file="../../common/header.jsp"%>
<div class="easyui-layout" data-options="fit:true">
	<!-- Begin of toolbar -->
	<div id="wu-toolbar">
		<div class="wu-toolbar-button">
			<%@include file="../../common/menus.jsp"%>
		</div>
		<div class="wu-toolbar-search">
			<label>物品名称:</label><input id="search-name" onkeyup="changeName()" class="wu-text" style="width: 100px">
			<!-- <a href="#" id="search-btn"	class="easyui-linkbutton" iconCls="icon-search">搜索</a> -->
			<label>物品分类：</label><input id="search-combobox-cid" type="text" />
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
<div id="add-dialog" class="easyui-dialog" data-options="closed:true,iconCls:'icon-save'"
	style="width: 450px; padding: 10px;">
	<form id="add-form" method="post">
		<table>

			<!-- 物品分类 -->
			<tr>
				<td width="60" align="right">物品分类：</td>
				<td><input type="text" name="cid" class="easyui-combobox"
					data-options="required:true, missingMessage:'请从下拉框中选择物品',
					valueField:'cid',textField:'cname',editable:false,
					url:'${ctx }/apply/category/getCategoryDropList',method:'post'" />
				</td>
			</tr>
			<!-- 物品名称 -->
			<tr>
				<td width="60" align="right">物品名称:</td>
				<td><input type="text" name="itemName" class="wu-text easyui-validatebox"
					data-options="required:true, missingMessage:'请填写物品名称'" /></td>
			</tr>
			<!-- 单位 -->
			<tr>
				<td width="60" align="right">物品单位:</td>
				<td><input type="text" name="unit" class="wu-text easyui-validatebox"
					data-options="required:true, missingMessage:'请填写物品单位'" /></td>
			</tr>
			<!-- 单价 -->
			<tr>
				<td width="60" align="right">单价:</td>
				<td><input type="text" id="add-price" name="itemPrice" class="easyui-numberbox easyui-validatebox"
					data-options="precision:2,required:true, missingMessage:'物品价格，只可填写数字'" /> 
			</tr>
			<!-- 备注 -->
			<tr>
				<td align="right">备注:</td>
				<td><textarea name="itemRemark" rows="6" class="wu-textarea" style="width: 260px"></textarea></td>
			</tr>
		</table>
	</form>
</div>


<!-- 修改窗口 -->
<div id="edit-dialog" class="easyui-dialog" data-options="closed:true,iconCls:'icon-save'"
	style="width: 450px; padding: 10px;">
	<form id="edit-form" method="post">
		<input type="hidden" name="itemId" id="edit-id">
		<table>
			<!-- 物品分类 -->
			<tr>
				<td width="60" align="right">物品分类：</td>
				<td><input type="text" id="edit-cid" name="cid" class="easyui-combobox"
					data-options="required:true, missingMessage:'请从下拉框中选择物品',
					valueField:'cid',textField:'cname',editable:false,
					url:'${ctx }/apply/category/getCategoryDropList',method:'post'" />
				</td>
			</tr>
			<!-- 物品名称 -->
			<tr>
				<td width="60" align="right">物品名称:</td>
				<td><input type="text" id="edit-name" name="itemName" class="wu-text easyui-validatebox"
					data-options="required:true, missingMessage:'请填写物品名称'" /></td>
			</tr>
			<!-- 单位 -->
			<tr>
				<td width="60" align="right">物品单位:</td>
				<td><input type="text" id="edit-unit" name="unit" class="wu-text easyui-validatebox"
					data-options="required:true, missingMessage:'请填写物品单位'" /></td>
			</tr>
			<!-- 单价 -->
			<tr>
				<td width="60" align="right">单价:</td>
				<td><input type="text" id="edit-price" name="itemPrice" class="easyui-numberbox easyui-validatebox"
					data-options="precision:2,required:true, missingMessage:'物品价格，只可填写数字'" /> 
			</tr>
			<!-- 备注 -->
			<tr>
				<td align="right">备注:</td>
				<td><textarea id="edit-remark" name="itemRemark" rows="6" class="wu-textarea" style="width: 260px"></textarea></td>
			</tr>
		</table>
	</form>
</div>


<%@include file="../../common/footer.jsp"%>

<!-- End of easyui-dialog -->
<script type="text/javascript">

	// 页面加载完成,分类监听
	$(function(){
		$("#search-combobox-cid").combobox({
			url : '../category/getCategoryDropList',
			valueField:'cid',
			textField :'cname',
			editable:false,
			onSelect : function(){
				$('#data-datagrid').datagrid('reload',{
					cid : $("#search-combobox-cid").combobox('getValue')
				});
			}
		});
		
	});
	
	function changeName(){
		$('#data-datagrid').datagrid('reload',{
			itemName :　$("#search-name").val()
		})
	}
	
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
			url : '../item/saveOrUpdate',
			dataType : 'json',
			type : 'post',
			data : data,
			success : function(data) {
				if (data.type == 'success') {
					$.messager.alert('信息提示', '添加成功！', 'info');
					$('#add-dialog').dialog('close');
					$('#data-datagrid').datagrid('reload');
					// 关闭tabs
					closeTabByItem();
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
			url : '../item/saveOrUpdate',
			dataType : 'json',
			type : 'post',
			data : data,
			success : function(data) {
				if (data.type == 'success') {
					$.messager.alert('信息提示', '修改成功！', 'info');
					$('#edit-dialog').dialog('close');
					$('#data-datagrid').datagrid('reload');
					// 关闭tabs
					closeTabByItem();
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
					url : '../item/delete',
					dataType : 'json',
					type : 'post',
					data : {
						itemId : item.itemId
					},
					success : function(data) {
						if (data.type == 'success') {
							$.messager.alert('信息提示', '删除成功！', 'info');
							$('#data-datagrid').datagrid('reload');
							// 关闭tabs
							closeTabByItem();
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
			title : "添加部门信息",
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

		$('#edit-dialog').dialog({
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
				$("#edit-id").val(item.itemId);
				$("#edit-cid").combobox("setValue", item.cid);
				$("#edit-name").val(item.itemName);
				$("#edit-price").numberbox("setValue",item.itemPrice);
				$("#edit-unit").val(item.unit);
				$("#edit-remark").val(item.itemRemark);
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
		idField : 'itemId',
		fit : true,
		columns : [ [ {
			field : 'chk',
			checkbox : true
		},  {
			field : 'itemName',
			title : '物品名称',
			width : 100,
			sortable : true
		}, {
			field : 'cname',
			title : '物品分类',
			width : 100,
			sortable : true
		}, {
			field : 'cid',
			title : '分类id',
			width : 100,
			sortable : true,
			hidden : true
		},{
			field : 'unit',
			title : '物品单位',
			width : 100,
			sortable : true
		},{
			field : 'itemPrice',
			title : '单价',
			width : 100,
			sortable : true,
			formatter : function(value){
				return "¥ " + value.toFixed(2);
			}
		},{
			field : 'remark',
			title : '备注',
			width : 100,
			sortable : true
		}, ] ],
		onLoadSuccess : function(data) {
			$('#data-datagrid').datagrid('unselectAll');
		}
	});
	
	/*关闭tabs*/
	function closeTabByItem(){
		closeTab('库存管理');
		closeTab('领用管理');
		closeTab('采购管理');
	}
</script>