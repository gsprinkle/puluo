<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@include file="../../common/header.jsp"%>
<script type="text/javascript" src="${ctx }/resources/js/datagrid-export.js"></script>
<div class="easyui-layout" data-options="fit:true">
	<!-- 领用信息toolbar -->
	<div id="wu-toolbar">
		<div class="wu-toolbar-button">
			<%@include file="../../common/menus.jsp"%>
		</div>
		<div class="wu-toolbar-search">
			<label>部门:</label> <input id="search-department" class="easyui-combobox" type="text"
				data-options="
			url:'../department/getDepartmentDropList',
			valueField:'deptId',textField:'deptName',
			onSelect : function(val){
				// 重新加载数据
				var dateMode = $('#dateMode').val();
				var date = $('#date').val();
				loadData(dateMode,date);
			}
			">
			<!-- 日期模式 -->
			<label>日期模式:<input type="radio" id="dayModel" name="dateRadio" value="1">日
			</label> <label><input type="radio" checked="checked" name="dateRadio" value="2">月</label> <label
				style="margin-right: 30px;"><input type="radio" name="dateRadio" value="3">年</label>
			<!-- 选择日期 -->
			<label>选择日期:</label> <input id="search-date" type="text" />
			<!-- 日期模式 默认为月 -->
			<input type="hidden" id="dateMode" value="2" />
			<!-- 日期参数 -->
			<input type="hidden" id="date" />
			<!-- 统计 -->
			<a href="#" onclick="openWindow()" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-chart-bar'" >统计</a>
		</div>
	</div>

	<!-- summary toolbar -->
	<div id="summary-toolbar">
		<div>
			<label id="lbSummary" style="color: '#ff8888'"></label> <label style="margin: 0 5px;"> </label> <a id="btn-export"
				href="#" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-chart-curve'">导出Excel</a>
		</div>
	</div>
	<!-- End of toolbar -->
	<table id="data-datagrid" class="easyui-datagrid" toolbar="#wu-toolbar"></table>
	<style>
.selected {
	background: red;
}
</style>
	<!-- Begin of easyui-dialog -->

	<!-- 统计datagrid -->
	<div id="summary-dialog" class="easyui-dialog" data-options="closed:true,iconCls:'icon-chart-pie'">
		<table id="summary-datagrid" class="easyui-datagrid" toolbar="#summary-toolbar"></table>
	</div>

	<!-- 添加领用对话框 -->
	<div id="add-dialog" class="easyui-dialog" data-options="closed:true,iconCls:'icon-save'"
		style="width: 450px; padding: 10px;">
		<form id="add-form" method="post">
			<table>
				<!-- 领取日期 apply_date -->
				<tr>
					<td width="60" align="right">领取日期:</td>
					<td><input type="text" name="applyDate" class="easyui-datebox"
						data-options="required:true,
					missingMessage:'请选择领取日期',
					value:getCurDate()" /></td>
				</tr>
				<!-- 物品名称 item_id -->
				<tr>
					<td width="70" align="right">物品:</td>
					<td><input type="text" id="add-cc-item" name="itemId" class="easyui-combobox"
						data-options="required:true, 
					missingMessage:'请从下拉框中选择物品',
					valueField:'itemId',
					textField:'itemName',
					url : '../item/getItemDropList',
					onLoadSuccess : function(){
						var data = $('#add-cc-item').combobox('getData');
						if(data && data.length >0){
							$('#add-cc-item').combobox('setValue',data[0].itemId);
							$('#itemUnit').text(data[0].unit);
							$('#show-item-price').text(data[0].itemPrice + '元');
						}
					},
					onSelect : function(data){
						$('#itemUnit').text(data.unit);
						$('#show-item-price').text(data.itemPrice + '元');
					}
					" />
					</td>
				</tr>
				<!-- 领取数量  apply_num -->
				<tr>
					<td width="60" align="right">数量:</td>
					<td><input type="text" name="applyNum" class="easyui-numberbox easyui-validatebox"
						data-options="required:true, missingMessage:'必填',value:1" /></td>
				</tr>
				
				<!-- 显示单位--> <!-- 显示单价 -->
				<tr>
					<td></td>
					<td align="left">
						单位：<span id="itemUnit" style="margin:5px 20px 5px 0;color:#0add00"></span>
						单价：<span id="show-item-price" style="margin:5px 20px 5px 0;color:#0add00"></span>
					</td>
				</tr>
				
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
					<td><textarea name="itemRemark" rows="6" class="wu-textarea" style="width: 260px"></textarea></td>
				</tr>
			</table>
		</form>
	</div>


	<!-- 修改窗口 -->
	<div id="edit-dialog" class="easyui-dialog" data-options="closed:true,iconCls:'icon-save'"
		style="width: 450px; padding: 10px;">
		<form id="edit-form" method="post">
			<table>
				<input type="hidden" name="applyId" id="edit-applyId" />
				<!-- 领取日期 apply_date -->
				<tr>
					<td width="60" align="right">领取日期:</td>
					<td><input type="text" id="edit-applyDate" name="applyDate" class="easyui-datebox"
						data-options="required:true,
					missingMessage:'请选择领取日期',
					value:getCurDate()" /></td>
				</tr>
				<!-- 物品名称 item_id -->
				<tr>
					<td width="70" align="right">物品:</td>
					<td><input type="text" id="edit-itemId" name="itemId" class="easyui-combobox"
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
					<td><input type="text" id="edit-applyNum" name="applyNum" class="easyui-numberbox easyui-validatebox"
						data-options="required:true, missingMessage:'物品数量，只可填写数字'," /></td>
				</tr>
				<!-- 部门 dept_id 略-->
				<!-- 领取员工 eid -->
				<tr>
					<td width="60" align="right">领取人:</td>
					<td><input type="text" name="eid" id="edit-eid" class="easyui-combobox"
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
					<td><textarea name="applyRemark" id="edit-applyRemark" rows="6" class="wu-textarea" style="width: 260px"></textarea></td>
				</tr>
			</table>
		</form>
	</div>


	<%@include file="../../common/footer.jsp"%>

	<!-- End of easyui-dialog -->
	<script type="text/javascript">
		$("#date").val(getYearMonth());
		// 日期选择，默认为月
		$("#search-date").datebox(
				{
					value : getYearMonth(),
					onSelect : function(date) {
						// 设置日期
						$("#date").val($(this).datebox('getValue'));
						// 重新加载数据
						var dateMode = $("#dateMode").val();
						var date = $("#date").val();
						loadData(dateMode, date);
					},
					formatter : function(date) {
						var y = date.getFullYear();
						var m = date.getMonth() + 1;
						var d = date.getDate();
						var dateMode = $('#dateMode').val();
						if (dateMode == 1) {
							return y + '-' + (m < 10 ? ('0' + m) : m) + '-'
									+ (d < 10 ? ('0' + d) : d);
						}
						if (dateMode == 2) {
							return y.toString() + '-' + (m < 10 ? '0' + m : m);
						}
						if (dateMode == 3) {
							return y.toString();
						}
					},
					parser : function(date) {
						//console.log(date);
						if (date) {
							var dateMode = $('#dateMode').val();
							if (dateMode == 2) {
								return new Date(String(date).substring(0, 4)
										+ '-' + String(date).substring(5, 7));
							}
							if (dateMode == 3) {
								return new Date(String(date).substring(0, 4));
							} else {
								return new Date(String(date));
							}
						} else {
							return new Date();
						}
					}
				});

		// 日期类型查询 1：日 	2：月	3：年
		$(":radio[name='dateRadio']").click(function() {
			// 获取dateMode值，并设置到隐藏域中
			var dateMode = $(this).val();
			$("#dateMode").val(dateMode);
			// 清空当前日期框
			$("#search-date").datebox('clear');
			// 默认设置为当前时间，格式根据dateMode决定,date也设置
			var curDate = new Date();
			if (dateMode == 1) {
				$("#search-date").datebox('setValue', myformatter(curDate));
				$("#date").val(myformatter(curDate));
			}
			if (dateMode == 2) {
				$("#search-date").datebox('setValue', getYearMonth());
				$("#date").val(getYearMonth());
			}
			if (dateMode == 3) {
				$("#search-date").datebox('setValue', curDate.getFullYear());
				$("#date").val(curDate.getFullYear());
			}
			var date = $("#date").val();
			loadData(dateMode, date);
		});
		// 选择列表模式 加载数据方法
		function loadData(dateMode, date) {
			$('#data-datagrid').datagrid('load', {
				'dateMode' : $("#dateMode").val(),
				'date' : $("#date").val(),
				'deptId' : $('#search-department').combobox('getValue')
			});
			$('#summary-datagrid').datagrid('load', {
				'dateMode' : $("#dateMode").val(),
				'date' : $("#date").val(),
				'deptId' : $('#search-department').combobox('getValue')
			});
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
				url : '../apply/saveOrUpdate',
				dataType : 'json',
				type : 'post',
				data : data,
				success : function(data) {
					if (data.type == 'success') {
						$.messager.alert('信息提示', '添加成功！', 'info');
						$('#add-dialog').dialog('close');
						$('#data-datagrid').datagrid('reload');
						$('#summary-datagrid').datagrid('reload');
						/*关闭tabs*/
						closeTabByApply();
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
						$('#summary-datagrid').datagrid('reload');
						
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
			if (item == null || item.length < 1) {
				$.messager.alert('信息提示', "请选择要删除的数据", 'info');
				return;
			}
			// 封装ids
			var ids = new Array();
			for (var i = 0; i < item.length; i++) {
				ids[i] = item[i].applyId;
			}
			$.messager.confirm('信息提示', '确定要删除' + ids.length + '条记录？', function(result) {
				if (result) {
					$.ajax({
						url : '../apply/delete',
						dataType : 'json',
						type : 'post',
						data : {
							'ids' : ids
						},
						success : function(data) {
							if (data.type == 'success') {
								$.messager.alert('信息提示', data.msg,
										'info');
								$('#data-datagrid').datagrid('reload');
								$('#summary-datagrid').datagrid('reload');
								/*关闭tabs*/
								closeTabByApply();
							} else {
								$.messager.alert('信息提示', data.msg,
										'warning');
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

		// 编辑行 索引
		var editIndex = undefined;
		// 结束行编辑
		function endEditing() {
			if (editIndex == undefined) {
				return true;
			}
			// 获取选择的值
			// 要修改的领用ID
			var applyId = $("#data-datagrid").datagrid('getData').rows[editIndex].applyId;
			// 要修改的物品ID
			var itemId = $("#data-datagrid").datagrid('getData').rows[editIndex].itemId;
			// 要修改的员工
			var eid = $("#data-datagrid").datagrid('getData').rows[editIndex].eid;

			// 获取编辑器对象
			var eNum = $("#data-datagrid").datagrid('getEditor', {
				index : editIndex,
				field : 'applyNum'
			});
			
			// 从编辑器对象中获取最新的领用数量
			var applyNum = $(eNum.target).val();
			$.ajax({
				url : 'saveOrUpdate',
				dataType : 'json',
				data : {
					'applyId' : applyId,
					'applyNum' : applyNum,
					'itemId' : itemId,
					'eid' : eid
				},
				success : function() {
					$("#data-datagrid").datagrid('endEdit', editIndex);
					$("#data-datagrid").datagrid('reload');
					$("#summary-datagrid").datagrid('reload');
					editIndex = undefined;
					/*关闭tabs*/
					closeTabByApply();
				}
			});
		}
		// 双击开启行编辑
		function onDblClickRow(index) {
			if (editIndex != index) {
				if (endEditing()) {
					$("#data-datagrid").datagrid('beginEdit', index);
					editIndex = index;
				} else {
					$('#data-datagrid').datagrid('selectRow', editIndex);
				}
			}
		}
		// 单击其它的行，结束编辑
		function onClickRow() {
			endEditing();
		}
		// 编辑好之后保存
		function save() {
			endEditing();
		}
		// 编辑完之后，取消保存
		function cancel() {
			if (editIndex == undefined) {
				return;
			} else {
				editIndex = undefined;
				$("#data-datagrid").datagrid('endEdit', editIndex);
				$("#data-datagrid").datagrid('reload');
				$('#summary-datagrid').datagrid('reload');
			}
		}
		/** 
		 * 载入数据
		 */
		$('#data-datagrid').datagrid({
			url : 'list',
			rownumbers : true,
			singleSelect : false,
			checkOnSelect : true,
			selectOnCheck :true,
			pageSize : 100,
			pageList : [ 20, 40, 60, 80, 100 ],
			pagination : true,
			multiSort : true,
			fitColumns : false,
			
			idField : 'applyId',
			fit : true,
			onDblClickRow : onDblClickRow,
			onClickRow : onClickRow,
			queryParams : {
				'dateMode' : $("#dateMode").val(),
				'date' : $("#date").val(),
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
			},  {
				field : 'itemId',
				title : '物品名称',
				width : 100,
				sortable : true,
				formatter :function(val,row){
					if(val){
						return row.itemName;
					}
				}
			}, {
				field : 'deptName',
				title : '领取部门',
				width : 100,
				sortable : true
			}, {
				field : 'eid',
				title : '领取员工',
				width : 100,
				sortable : true,
				formatter : function(val,row){
					if(val){
						return row.ename;
					}
				}
			}, {
				field : 'itemPrice',
				title : '单价',
				width : 60,
				sortable : true,
				formatter : function(value) {
					if (value) {
						return "¥ " + value.toFixed(2);
					}
				}
			}, {
				field : 'applyNum',
				title : '领取数量',
				width : 60,
				sortable : true,
				editor : "text"
			}, {
				field : 'unit',
				title : '单位',
				width : 50,
				sortable : true
			}, {
				field : 'totalPrice',
				title : '总价',
				width : 80,
				sortable : true,
				formatter : function(value) {
					if (value) {
						return "¥ " + value.toFixed(2);
					}
				}
			}, {
				field : 'applyRemark',
				title : '备注',
				//width : 100,
				sortable : true
			}, ] ],
			onLoadSuccess : function(data) {
				$('#data-datagrid').datagrid('unselectAll');
				$('#data-datagrid').datagrid('clearChecked');
			}
		});

		/*统计列表 summary-datagrid  */
		$('#summary-datagrid').datagrid(
				{
					url : 'summary',
					rownumbers : true,
					singleSelect : true,
					pageSize : 100,
					pageList : [ 20, 40, 60, 80, 100 ],
					pagination : true,
					multiSort : true,
					fitColumns : true,
					idField : 'applyId',
					fit : true,
					showFooter : false,
					queryParams : {
						'dateMode' : $("#dateMode").val(),
						'date' : $("#date").val(),
					},
					columns : [ [ {
						field : 'summaryDate',
						title : '领取日期',
						width : 100,
						sortable : true
					}, {
						field : 'deptName',
						title : '领取部门',
						width : 100,
						sortable : true
					}, {
						field : 'itemName',
						title : '物品名称',
						width : 100,
						sortable : true
					}, {
						field : 'itemPrice',
						title : '物品单价',
						width : 100,
						sortable : true,
						formatter : function(value) {
							if (value) {
								return "¥ " + value.toFixed(2);
							}
						}
					}, {
						field : 'applyNum',
						title : '物品数量',
						width : 100,
						sortable : true
					}, {
						field : 'unit',
						title : '物品单位',
						width : 100,
						sortable : true
					}, {
						field : 'totalPrice',
						title : '总价',
						width : 100,
						sortable : true,
						formatter : function(value) {
							if (value) {
								return "¥ " + value.toFixed(2);
							}
						}
					}, {
						field : 'applyRemark',
						title : '备注',
						width : 100,
						sortable : true
					}, ] ],
					onLoadSuccess : function(data) {
						if (data.footer[0]) {
							$('#lbSummary').text(
									data.footer[0].unit + ': '
											+ data.footer[0].totalPrice + '元');
						}
					}
				});

		/*打开统计datagrid窗口*/
		function openWindow() {
			// 禁用日模式
			$("#dayModel").attr("disabled", true);
			$("#summary-dialog").dialog({
				title : '领用统计',
				closed : false,
				resizable : true,
				height : 400,
				width : 650,
				onClose : function() {
					// 启用日模式
					$("#dayModel").attr("disabled", false);
				}

			});
		}
		/*导出Excel*/
		$('#btn-export').click(function() {
			var date = $('#date').val();
			var dateMode = $('#dateMode').val();
			var name = '';
			if (dateMode == 2) {
				name = date + '月领用统计.xls';
			}
			if (dateMode == 3) {
				name = date + '年领用统计.xls';
			}
			$('#summary-datagrid').datagrid('toExcel', name);
		});

		/*关闭tabs*/
		function closeTabByApply() {
			closeTab('库存管理');
		}
	</script>