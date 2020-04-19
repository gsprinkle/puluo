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
			<label style="color:#e73904;" id="countTotal"></label>
		</div>

	</div>
	<!-- End of toolbar -->
	<!-- 库存 -->
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
function EasyUILoad() {
    $("<div class=\"datagrid-mask\"></div>").css({ display: "block", width: "100%", height: "auto !important" }).appendTo("body");
    $("<div class=\"datagrid-mask-msg\"></div>").html("<img  class ='img1' /> 正在运行，请稍候。。。").appendTo("body").css({ display: "block", left: ($(document.body).outerWidth(true) - 190) / 2, top: ($(window).height() - 45) / 2 });
}

function dispalyEasyUILoad() {
    $(".datagrid-mask").remove();
    $(".datagrid-mask-msg").remove();
}	
	/**
	初始化库存列表
	 */
	function initialize() {
		// 添加模式
		EasyUILoad();
		 $.ajax({
			url : 'initialize',
			type : 'GET',
			dataType : 'json',
			success : function(data) {
				dispalyEasyUILoad();
				if (data.type == 'success') {
					$.messager.alert('信息提示', '初始化成功！', 'info');
					$('#data-datagrid').datagrid('reload');
				} else {
					$.messager.alert('信息提示', data.msg, 'warning');
				}
			}
		});
	}
	 
	 
	/**
		库存列表
	*/
	$('#data-datagrid').datagrid({
		url : 'list',
		rownumbers : true,
		singleSelect : true,
		pageSize : 20,
		pagination : true,
		multiSort : true,
		fitColumns : false,
		idField : 'inventoryId',
		fit : true,
		columns : [ [ {
			field : 'chk',
			checkbox : true
		}, {
			field : 'cname',
			title : '物品分类',
			width : 100,
			sortable : true,
		}, {
			field : 'itemName',
			title : '物品名称',
			width : 100,
			sortable : true
		}, {
			field : 'cid',
			title : '分类id',
			width : 100,
			sortable : true,
			hidden : true
		}, {
			field : 'inventoryNum',
			title : '剩余库存',
			width : 60,
			sortable : true,
		},  {
			field : 'unit',
			title : '单位',
			width : 40,
			sortable : true
		},{
			field : 'totalPrice',
			title : '总价',
			width : 100,
			sortable : true,
			formatter : function(value){
				if(value){
					return value.toFixed(2);
				}
			}
		}, {
			field : 'inventoryRemark',
			title : '备注',
			width : 100,
			sortable : true
		} ] ],
		onLoadSuccess : function(data) {
			$('#data-datagrid').datagrid('unselectAll');
			if(data.countTotal){
				$('#countTotal').text('当前库存物品总价值：' + data.countTotal.toFixed(2) + '元');
			}
		},
		onDblClickRow : onDblClickRow,
		onClickRow : onClickRow
	});
	// 编辑行 索引
	var editIndex = undefined;
	// 结束行编辑
	function endEditing(){
		if(editIndex == undefined){return true;}
		// 获取选择的值
		var inventoryId = $("#data-datagrid").datagrid('getData').rows[editIndex].inventoryId;
		var eNum = $("#data-datagrid").datagrid('getEditor',{index:editIndex,field:'inventoryNum'});
		var inventoryNum = $(eNum.target).val();
		$.ajax({
			url : 'saveOrUpdate',
			dataType : 'json',
			data : {
				'inventoryId' : inventoryId,
				'inventoryNum' : inventoryNum,
			},
			success : function(){
				$("#data-datagrid").datagrid('endEdit',editIndex);
				$("#data-datagrid").datagrid('reload');
				editIndex = undefined;
			}
		});
		
	}
	
	// 双击开启行编辑
	function onDblClickRow(index){
		if (editIndex != index){
			if (endEditing()){
				$("#data-datagrid").datagrid('beginEdit',index);
				editIndex = index;
			} else {
				$('#data-datagrid').datagrid('selectRow', editIndex);
			}
		}
	}
	function onClickRow(){
		endEditing();
	}

	/**
		产品名称 搜索框，根据输入的关键词搜索
	 */
	function changeName() {
		$('#data-datagrid').datagrid('reload', {
			itemName : $("#search-name").val()
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
		var item = $('#data-datagrid').datagrid('getSelected');
		if (!item) {
			$.messager.alert('信息提示', '请选择要删除的数据！', 'info');
			return;
		}
		$.messager.confirm('信息提示', '确定要删除该记录？', function(result) {
			if (result) {
				var item = $('#data-datagrid').datagrid('getSelected');
				$.ajax({
					url : '../inventory/delete',
					dataType : 'json',
					type : 'post',
					data : {
						inventoryId : item.inventoryId
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
		var node = $("#tt").tree('getChecked', 'checked');
		if (node.length < 1) {
			$.messager.alert('Warning', "请在左边勾选一个分类");
			return;
		} else if (node.length > 1) {
			$.messager.alert('Warning', "只能勾选一个分类");
			return;
		}
		// console.log(node);
		// 填充 产品 分类 表单项
		$("#add-item-cid").val(node[0].id);

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
				$("#edit-brand").combobox("setValue", item.brandId);
				$("#edit-cid").combobox("setValue", item.cid);
				$("#edit-name").val(item.itemName);
				$("#edit-remark").val(item.itemRemark);
			}
		});
	}
</script>