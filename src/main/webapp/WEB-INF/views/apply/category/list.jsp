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
			<label>分类名称:</label><input id="search-name" class="wu-text" style="width: 100px"> <a href="#" id="search-btn"
				class="easyui-linkbutton" iconCls="icon-search">搜索</a>
		</div>
	</div>
	<!-- End of toolbar -->
	
	<table id="data-datagrid" class="easyui-datagrid" toolbar="#wu-toolbar"></table>
</div>
<!-- Begin of easyui-dialog -->
<!-- 物品分类 添加窗口 -->
<div id="add-dialog" class="easyui-dialog" data-options="closed:true,iconCls:'icon-save'"
	style="width: 450px; padding: 10px;">
	<form id="add-form" method="post">
		<table>
			<tr>
				<td width="60" align="right">分类名称:</td>
				<td><input type="text" name="cname" class="wu-text easyui-validatebox"
					data-options="required:true, missingMessage:'请填写分类名称'" /></td>
			</tr>
			<tr>
				<td align="right">备注:</td>
				<td><textarea name="cremark" rows="6" class="wu-textarea" style="width: 260px"></textarea></td>
			</tr>
		</table>
	</form>
</div>


<!-- 物品分类 修改窗口 -->
<div id="edit-dialog" class="easyui-dialog" data-options="closed:true,iconCls:'icon-save'"
	style="width: 450px; padding: 10px;">
	<form id="edit-form" method="post">
		<input type="hidden" name="cid" id="edit-id">
		<table>
			<tr>
				<td width="60" align="right">分类名称:</td>
				<td><input type="text" id="edit-name" name="cname" class="wu-text easyui-validatebox"
					data-options="required:true, missingMessage:'请填写分类名称'" /></td>
			</tr>
			<tr>
				<td align="right">备注:</td>
				<td><textarea id="edit-remark" name="cremark" rows="6" class="wu-textarea" style="width: 260px"></textarea></td>
			</tr>
		</table>
	</form>
</div>


<%@include file="../../common/footer.jsp"%>

<!-- End of easyui-dialog -->
<script type="text/javascript">
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
			url : '../category/saveOrUpdate',
			dataType : 'json',
			type : 'post',
			data : data,
			success : function(data) {
				if (data.type == 'success') {
					$.messager.alert('信息提示', '添加成功！', 'info');
					$('#add-dialog').dialog('close');
					$('#data-datagrid').datagrid('reload');
					// 关闭tabs
					closeTabByCategory();
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
			url : '../category/saveOrUpdate',
			dataType : 'json',
			type : 'post',
			data : data,
			success : function(data) {
				if (data.type == 'success') {
					$.messager.alert('信息提示', '修改成功！', 'info');
					$('#edit-dialog').dialog('close');
					$('#data-datagrid').datagrid('reload');
					// 关闭tabs
					closeTabByCategory();
				} else {
					$.messager.alert('信息提示', data.msg, 'warning');
				}
			}
		});
	}

	/**
	 * 批量删除
	 */
	function remove() {
		var item = $('#data-datagrid').datagrid('getSelections');
		if(item==null || item.length < 1){
			$.messager.alert('信息提示', "请选择要删除的数据", 'info');
			return;
		}
		// 封装ids
		var ids = new Array();
		for(var i = 0; i < item.length; i++){
			ids[i] = item[i].cid;
		}
		$.messager.confirm('信息提示', '确定要删除'+ids.length+'条记录吗？在这些分类下的物品、物品相关的库存、领用、采购信息将一并清空，不可恢复，确定吗？建议修改，而不是删除', function(result) {
			if (result) {
				$.messager.prompt('警告','请输入管理员密码',function(val){
					if(val == 'puluo'){
						$.ajax({
							url : '../category/delete',
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
									closeTabByCategory();
								} else {
									$.messager.alert('信息提示', data.msg, 'warning');
								}
							}
						});
					}else{
						$.messager.alert('信息提示', '密码错误或取消', 'warning');
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
		var item = $('#data-datagrid').datagrid('getSelections');
		if (item == null || item.length == 0) {
			$.messager.alert('信息提示', '请选择要修改的数据！', 'info');
			return;
		}
		if(item.length > 1){
			$.messager.alert('信息提示', '只能选择一行数据！', 'info');
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
						$("#edit-id").val(item[0].cid);
						$("#edit-name").val(item[0].cname);
						$("#edit-remark").val(item[0].cremark);
					}
				});
	}

	//搜索按钮监听
	$("#search-btn").click(function() {
		$('#data-datagrid').datagrid('reload', {
			cname : $("#search-name").val()
		});
	});

	/** 
	 * 载入数据
	 */
	$('#data-datagrid').datagrid({
		url : 'list',
		rownumbers : true,
		singleSelect : false,
		pageSize : 20,
		pagination : true,
		multiSort : true,
		fitColumns : true,
		idField : 'cid',
		fit : true,
		columns : [ [ {
			field : 'chk',
			checkbox : true
		}, {
			field : 'cname',
			title : '分类名称',
			width : 100,
			sortable : true
		}, {
			field : 'cremark',
			title : '备注',
			width : 100,
			sortable : true
		}, ] ],
		onLoadSuccess : function(data) {
			$('#data-datagrid').datagrid('unselectAll');
		}
	});
	
	function closeTabByCategory(){
		// 关闭tabs
		closeTab('物品管理');
		closeTab('库存管理');
		closeTab('采购管理');
		closeTab('领用管理');
	}
</script>