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
			<label>员工姓名:</label><input id="search-name" onkeyup="changeName()" class="wu-text" style="width: 100px">
			<label>所属部门：</label><input id="search-combobox-deptId" type="text" />
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
			<!-- 所属部门 -->
			<tr>
				<td width="60" align="right">所属部门：</td>
				<td><input type="text" name="deptId" class="easyui-combobox"
					data-options="required:true, missingMessage:'请从下拉框中选择员工',
					valueField:'deptId',textField:'deptName',editable:false,
					url:'${ctx }/apply/department/getDepartmentDropList',method:'post'" />
				</td>
			</tr>
			<!-- 员工名称 -->
			<tr>
				<td width="60" align="right">员工姓名:</td>
				<td><input type="text" name="ename" class="wu-text easyui-validatebox"
					data-options="required:true, missingMessage:'请填写员工姓名'" /></td>
			</tr>
			<!-- telphone -->
			<tr>
				<td width="60" align="right">手机号码:</td>
				<td><input type="text" name="telphone" class="wu-text" /></td>
			</tr>
			<!-- 备注 -->
			<tr>
				<td align="right">备注:</td>
				<td><textarea name="eremark" rows="6" class="wu-textarea" style="width: 260px"></textarea></td>
			</tr>
		</table>
	</form>
</div>


<!-- 修改窗口 -->
<div id="edit-dialog" class="easyui-dialog" data-options="closed:true,iconCls:'icon-save'"
	style="width: 450px; padding: 10px;">
	<form id="edit-form" method="post">
		<input type="hidden" name="eid" id="edit-id">
		<table>
			<!-- 所属部门 -->
			<tr>
				<td width="60" align="right">所属部门：</td>
				<td><input type="text" id="edit-deptId" name="deptId" class="easyui-combobox"
					data-options="required:true, missingMessage:'请从下拉框中选择部门',
					valueField:'deptId',textField:'deptName',editable:false,
					url:'${ctx }/apply/department/getDepartmentDropList',method:'post'" />
				</td>
			</tr>
			<!-- 员工名称 -->
			<tr>
				<td width="60" align="right">员工名称:</td>
				<td><input type="text" id="edit-name" name="ename" class="wu-text easyui-validatebox"
					data-options="required:true, missingMessage:'请填写员工名称'" /></td>
			</tr>
			<!-- telphone -->
			<tr>
				<td width="60" align="right">员工单位:</td>
				<td><input type="text" id="edit-telphone" name="telphone" class="wu-text"/></td>
			</tr>
			<!-- 备注 -->
			<tr>
				<td align="right">备注:</td>
				<td><textarea id="edit-remark" name="eremark" rows="6" class="wu-textarea" style="width: 260px"></textarea></td>
			</tr>
		</table>
	</form>
</div>


<%@include file="../../common/footer.jsp"%>

<!-- End of easyui-dialog -->
<script type="text/javascript">

	// 页面加载完成,分类监听
	$(function(){
		$("#search-combobox-deptId").combobox({
			url : '../department/getDepartmentDropList',
			valueField:'deptId',
			textField :'deptName',
			editable : false,
			onSelect : function(){
				$('#data-datagrid').datagrid('reload',{
					deptId : $("#search-combobox-deptId").combobox('getValue')
				});
			}
		});
		
	});
	
	function changeName(){
		$('#data-datagrid').datagrid('reload',{
			ename :$("#search-name").val()
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
			url : '../employee/saveOrUpdate',
			dataType : 'json',
			type : 'post',
			data : data,
			success : function(data) {
				if (data.type == 'success') {
					$.messager.alert('信息提示', '添加成功！', 'info');
					$('#add-dialog').dialog('close');
					$('#data-datagrid').datagrid('reload');
					//关闭tabs
					closeTabByEmp();
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
			url : '../employee/saveOrUpdate',
			dataType : 'json',
			type : 'post',
			data : data,
			success : function(data) {
				if (data.type == 'success') {
					$.messager.alert('信息提示', '修改成功！', 'info');
					$('#edit-dialog').dialog('close');
					$('#data-datagrid').datagrid('reload');
					//关闭tabs
					closeTabByEmp();
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
		var item = $('#data-datagrid').datagrid('getChecked');
		if(item==null || item.length < 1){
			$.messager.alert('信息提示', "请选择要删除的数据", 'info');
			return;
		}
		// 封装ids
		var ids = new Array();
		for(var i = 0; i < item.length; i++){
			ids[i] = item[i].eid;
		}
		$.messager.confirm('信息提示', '确定要删除'+ids.length+'条记录？删除后，这些员工和与员工相关的领用信息将被清空，三思！建议修改员工，而不是删除。', function(result) {
			if (result) {
				$.messager.prompt('警告','请输入管理员密码',function(val){
					if(val == 'puluo'){
						$.ajax({
							url : '../employee/delete',
							dataType : 'json',
							type : 'post',
							data : {
								'ids' : ids
							},
							success : function(data) {
								if (data.type == 'success') {
									$.messager.alert('信息提示', data.msg, 'info');
									$('#data-datagrid').datagrid('reload');
									//关闭tabs
									closeTabByEmp();
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
				$("#edit-id").val(item.eid);
				$("#edit-deptId").combobox("setValue", item.deptId);
				$("#edit-name").val(item.ename);
				$("#edit-telphone").val(item.telphone);
				$("#edit-remark").val(item.eremark);
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
		pagination : true,
		multiSort : true,
		fitColumns : false,
		idField : 'eid',
		fit : true,
		columns : [ [ {
			field : 'chk',
			checkbox : true
		},  {
			field : 'ename',
			title : '员工名称',
			width : 100,
			sortable : true
		}, {
			field : 'deptId',
			title : '部门ID',
			width : 100,
			sortable : true,
			hidden : true
			
		}, {
			field : 'deptName',
			title : '所属部门',
			width : 100,
			sortable : true
		}, {
			field : 'telphone',
			title : '手机号码',
			width : 100,
			sortable : true
		},{
			field : 'eremark',
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
	function closeTabByEmp(){
		closeTab('库存管理');
		closeTab('领用管理');
		closeTab('采购管理');
	}
</script>