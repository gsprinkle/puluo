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
			<!-- <input type="button" onclick="formatUnit()" value="去掉1" /> -->
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
<div id="add-dialog" class="easyui-dialog" data-options="closed:true,iconCls:'icon-save'"
	style="width: 450px; padding: 10px;">
	<form id="add-form" method="post">
		<table>

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
	 * 批量删除记录
	 */
	function remove() {
		var item = $('#data-datagrid').datagrid('getChecked');
		if(item==null || item.length < 1){
			$.messager.alert('信息提示', "请选择要删除的数据", 'info');
			return;
		}
		// 封装ids
		var ids = new Array();
		for(var i = 0; i < item.length; i++){
			ids[i] = item[i].itemId;
		}
		$.messager.confirm('信息提示', '确定要删除'+ids.length+'条记录？删除后，这些 物品所对应的【采购信息】、【领用信息】、【库存信息】将全部清空，三思而后行！', function(result) {
			if (result) {
				$.messager.prompt('警告','请输入管理员密码',function(val){
					if(val == 'puluo'){
						$.ajax({
							url : '../item/delete',
							dataType : 'json',
							type : 'post',
							data : {
								'ids' : ids
							},
							success : function(data) {
								if (data.type == 'success') {
									$.messager.alert('信息提示', data.msg, 'info');
									$('#data-datagrid').datagrid('reload');
									// 关闭tabs
									closeTabByItem();
								} else {
									$.messager.alert('信息提示', data.msg, 'warning');
								}
							}
						});
					}else{$.messager.alert('信息提示', '密码错误或取消', 'warning');}
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
		singleSelect : false,
		pageSize : 20,
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
			$('#data-datagrid').datagrid('clearChecked');
		}
	});
	
	/*关闭tabs*/
	function closeTabByItem(){
		closeTab('库存管理');
		closeTab('领用管理');
		closeTab('采购管理');
	}
	
/* 	function formatUnit(){
		$.ajax({
			url : '../item/formatUnit',
			dataType : 'json',
			type : 'post',
			success : function(data){
				if (data.type == 'success') {
					$.messager.alert('信息提示', data.msg, 'info');
					$('#data-datagrid').datagrid('reload');
				}
			}
		})
	} */
</script>