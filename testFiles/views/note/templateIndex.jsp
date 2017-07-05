<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>短信管理</title>
    <%@include file="/views/include/pageHeader.jsp"%>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/script/lib/dropzone/dropzone.css"/>
    <link data-origin-file="innerFrame.css" rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/static/css/innerFrame.css">
    <link data-origin-file="templateIndex.css" rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/static/css/templateIndex.css">
    <link data-origin-file="note.css" rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/static/css/note.css">

	<script src="<%=request.getContextPath()%>/script/lib/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
	<script src="<%=request.getContextPath()%>/script/lib/bootstrap-datetimepicker-master/js/locales/bootstrap-datetimepicker.zh-CN.js"></script>
	<style>
		#noteTempDiv{
			height:100%;
		}
		#formId .form-group{
			width:30%;
			margin-right:15px;
			display:inline-block;
		}
		#userFieldUl .form-group{
			vertical-align: top;
		}
        .btn span{
            padding-right: 5px;;
        }
        .control-label{
            padding-right:0;
        }
        #formId .btn.btn-raised{
            padding:4px 16px;
            margin: 6px;
        }
        .noteContent{
            width:200px;
            overflow: hidden;
            transition: all 0.4s;
            word-break: break-all;
            white-space: nowrap;
            text-overflow: ellipsis;
        }
        .noteContent:hover{
            height:auto;
            white-space: normal;
        }
	</style>
</head>
<body>
<div class="note-contain-wrapper">
<div id="noteTempDiv">
    <header class="part-header">
        <span>短信模板</span>
        <a class="btn btn-raised btn-success fr" style="color:#fff; display: none;" type="button" id="newTplBtn" aria-haspopup="true" aria-expanded="true"
             data-toggle="modal" data-target="#createTemplateModal" onclick="initCreateTemp()">
          <span class="fa fa-plus" aria-hidden="true"></span>创建新模板
        </a>
    </header>

    <div class="right-content" id="rightContainer" >
         <div class="right-content-panel container-fluid" id="rightDiv" >
             <div class="row">
                 <div class="col-sm-12">
                     <div class="query-condition">
                         <form id="formId" class="form-horizontal" onsubmit="return false;">
                             <div class="form-group">
                                 <label class="col-md-4 control-label">模板名称：</label>
                                 <div class="col-md-8">
                                     <input type="text" class="form-control" name="tempName" id="templateName" placeholder="">
                                 </div>
                             </div>
                             <div class="form-group">
                                 <label class="col-md-4 control-label">模板状态：</label>
                                 <div class="col-md-8">
                                     <select class="form-control" id="templateStatus" name="status" onchange="">
                                         <option value="">全部</option>
                                         <option value="0">停用</option>
                                         <option value="1">启用</option>
                                     </select>
                                 </div>
                             </div>
                             <div class="fr" style="margin-top: 10px">
                                 <a class="btn btn-raised btn-default" onclick="clearTempQuery()">清空</a>
                                 <a class="btn btn-raised btn-primary" onclick="templateQuery()">查询</a>
                             </div>
                         </form>
                     </div>
                 </div>
             </div>
             <div class="row">
                 <div class="col-sm-12">
                     <div class="table-content">
                         <div class="grid">
                             <table class="table" cellspacing="0" cellpadding="0" id="grid">
                                 <thead>
                                 <tr class="order" id="chTableTitle">
                                     <th width="40"><input class="ember-view ember-checkbox all-checkbox" type="checkbox" id="allSelect"> </th>
                                     <th>模板名称</th>
                                     <th>模板内容</th>
                                     <th>模板状态</th>
                                     <th>创建人</th>
                                     <th>创建时间</th>
                                     <th>更新时间</th>
                                 </tr>
                                 </thead>
                                 <tbody></tbody>
                                 <tfoot>
                                 <tr>
                                     <td colspan="30"><div id="pagination"></div></td>
                                 </tr>
                                 </tfoot>
                             </table>
                         </div>
                     </div>
                 </div>
             </div>
        </div>
    </div>
    <div id="toolbar">
        <button id="deleteBtn" type="button" class="btn btn-raised left-btn btn-danger" style="display: none;">删除</button>
        <button id="cancelBtn" type="button" class="btn btn-raised btn-default btn-dark" onclick="cancel()">取消</button>
        <button id="statusBtn" type="button" class="btn btn-raised btn-primary">停用</button>
        <button id="editBtn" type="button" class="btn btn-raised btn-primary" data-toggle="modal" data-target="#editTemplateModal" style="display: none;">编辑</button>
    </div>
</div>
</div>

<!-- 创建新模板 -->
<div id="createTemplateModal" class="modal fade bs-example-modal-sm" data-backdrop="static">
    <div class="modal-dialog" style="width:600px;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <span class="modal-title">创建新模板</span>
            </div>
            <div class="modal-body">
                <div class="container-fluid" >
                    <div class="row">
                        <div class="col-sm-12">
                              <form id="createNoteForm" class="form-horizontal" onsubmit="return false;">
	                             <div>
	                              	<div class="form-group">
			                            <label for="tempName" class="control-label">模板名称：（必填）</label>
			                            <input type="text" class="form-control" name="tempName" id="tempName" placeholder=""/>
	                        		</div>
	                        	 </div>
	                        	 <div>
	                        		<div class="form-group textarea-list">
			                            <label for="noteContent" class="control-label">短信内容：（必填）</label>
			                            <textarea rows="5" cols="47" name="noteContent" id="noteContent"></textarea>
	                        		</div>
	                        	</div>
                              </form>
                        </div>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
            	<span style="margin-right: 10px;"><input type="checkbox" id="createdEnable">创建后不立即启用</span>
                <button type="button" class="btn btn-raised btn-default btn-sm" data-dismiss="modal">取消</button>
                <button type="button" class="btn btn-raised btn-primary btn-sm" onclick="createNoteTempSubmit()" id="createNoteTempSubmit">提交</button>
            </div>
        </div>
    </div>
</div>
<!-- 编辑模板 -->
<div id="editTemplateModal" class="modal fade bs-example-modal-sm" data-backdrop="static">
    <div class="modal-dialog" style="width:600px;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <span class="modal-title">编辑模板</span>
            </div>
            <div class="modal-body">
                <div class="container-fluid" >
                    <div class="row">
                        <div class="col-sm-12">
                              <form id="editNoteForm" class="form-horizontal" onsubmit="return false;">
	                             <div>
	                              	<div class="form-group">
			                            <label for="newtempName" class="control-label">模板名称：（必填）</label>
			                            <input type="text" class="form-control" name="tempName" id="newtempName" placeholder=""/>
	                        		</div>
	                        	 </div>
	                        	 <div>
	                        		<div class="form-group textarea-list">
			                            <label for="newnoteContent" class="control-label">短信内容：（必填）</label>
			                            <textarea rows="5" cols="47" name="noteContent" id="newnoteContent"></textarea>
	                        		</div>
	                        	</div>
                              </form>
                        </div>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
            	<span style="margin-right: 10px;"><input type="checkbox" id="editEnable">编辑后不立即启用</span>
                <button type="button" class="btn btn-raised btn-default btn-sm" data-dismiss="modal">取消</button>
                <button type="button" class="btn btn-raised btn-primary btn-sm" onclick="editNoteTempSubmit()" id="editNoteTempSubmit">提交</button>
            </div>
        </div>
    </div>
</div>

<script id="table-ch-tpl" type="text/x-handlebars-template">
    <tr data-prop="">
        <td><input type="checkbox"></td>
        <td data-prop="tempName">{{tempName}}</td>
        <td data-prop="noteContent"><div class="noteContent">{{noteContent}}</div></td>
        <td data-prop="status">{{status}}</td>
        <td data-prop="creatorName">{{creatorName}}</td>
        <td data-prop="createTime">{{createTime}}</td>
		<td data-prop="updateTime">{{updateTime}}</td>
    </tr>
</script>


<script type="text/javascript">

$("#notetemplate").click(function(){
	$("#left-part .left-content-panel li").removeClass("active");
	$(this).addClass("active");
	$("#noteTempDiv").show();
	$("#noteDtailDiv").hide();
	$("#rightIframe").hide();
	templateQuery();
});

$("#noteMass").click(function(){
	$("#left-part .left-content-panel li").removeClass("active");
	$(this).addClass("active");
	$("#noteTempDiv").hide();
	$("#noteDtailDiv").hide();
	$("#rightIframe").show();
	$("#rightIframe").attr("src","<%=request.getContextPath()%>/note/mass");
});
//获得模板信息的url
var TEMP_INFO_URL = "<%=request.getContextPath()%>/note/getnotetemp?sessionKey=" + $.cookie("sessionKey");

$(function(){
    // 权限菜单按钮控制隐藏或者显示
    permissionControl();
	templateQuery();
});

/**
 * @desc [权限菜单按钮控制隐藏或者显示]
 */
var permissionControl = (function() {
    // 页面权限菜单对应的url与按钮元素的对照表
    var pageUrlObj = {
        'note/create': $('#newTplBtn'),
        'note/editTemp': $('#editBtn'),
        'note/modifyStatus': $('#statusBtn'),
        'note/delete': $('#deleteBtn')
    };

    return function() {
        // 获取页面权限菜单数组
        var pagePermissionArr = top.PERMISSION_MENU_G.getPagePermission(Tools.getSearchParamValue(null, 'permissionId'));
        var tmpObj = null;

        // 控制菜单元素(按钮)的显示
        for(var i = 0, len = pagePermissionArr.length; i < len; i++) {
            tmpObj = pagePermissionArr[i];

            if(tmpObj.url in pageUrlObj) {
                pageUrlObj[tmpObj.url].show();
            }
        }
    };
})();

function templateQuery(){
	getTableData({page:1, rows:10, entId:'${entId}',tempName:$("#templateName").val(),tempStatus:$("#templateStatus").val()});
}

/**
 * 向后台请求数据
 */
var getTableData = (function(){
        // 保存请求参数
    var paramCache = {};
    /**
     * 初始化分页
     */
    var pager = new cri.Pager($("#pagination"),{
        page:1,
        pageSize:10,
        total:0,
        onPage:function(page,pageSize){
            $.extend(paramCache, {page: page, rows: pageSize});
            getTableData(paramCache);
        }
    });

    return function(param) {
        $.post(TEMP_INFO_URL, param, function(data){
            if(data.rows == null) {
                notice.danger('数据加载失败，请刷新页面重试！');
                // 隐藏全选按钮
                $("#allSelect").hide();
                // 表格数据清空
                $("#grid").find("tbody").empty();
                // 分页按钮设为1
                pager.update(1, 10, 0);
            } else {

                // 如果表格没有数据
                if(data.rows == null ){
                    notice.alert("暂无数据！");
                    // 隐藏全选按钮
                    $("#allSelect").hide();
                    // 表格数据清空
                    $("#grid").find("tbody").empty();
                    // 分页按钮设为1
                    pager.update(1, 10, 0);
                } else {
                    createTable(data.rows);

                    // 显示全选按钮并初始化
                    $("#allSelect").show();
                    $("#allSelect").prop("checked",false);

                    pager.update(param.page, param.rows, data.total);
                    $.extend(paramCache, param);
                }
            }
        });
    }
})();

/**
 * 刷新表格
 */
var createTable = (function(){
    var tableCHTpl = Handlebars.compile($("#table-ch-tpl").html()),
        $table = $("#grid");

    return function(tableData){
        var html = [], // 获得数据后的所有行模板
            fns = null, // 表格所要展示的列名
            $tr = null, // 获得数据后的行模板
            checkCount = tableData.length; // 表格数据长度


        for(var i= 0,len = tableData.length; i < len; i++){
            // 获取行数据
            $tr = $(tableCHTpl(tableData[i]));
            $tr.data("data",tableData[i]);

            html.push($tr);
        }

        // 替换数据
        $table.find("tbody").empty().append(html);

        // 绑定选择框事件(全选和单选)
        $table.find("input[type=checkbox]").change(function(){
            var $t = $(this).parent(),
                    checkLen = 0; // 状态为选中的按钮数量

            // 如果点击的是全选按钮, 则修改当前页所有选择框
            if($t.is("th")){
                $table.find("td input[type=checkbox]").prop("checked", $(this).prop("checked"));
                // 获取状态为选中的按钮数量
                checkLen = $table.find('td input[type=checkbox]:checked').length;
            } else {
                // 获取状态为选中的按钮数量
                checkLen = $table.find('td input[type=checkbox]:checked').length;
                // 如果所有数据都被选中，则让全选按钮状态为true
                if(checkCount == checkLen){
                    $("#allSelect").prop("checked",true);
                }
                else{
                    $("#allSelect").prop("checked",false);
                }
            }

            // 如果有选择数据，则显示工具栏
            if(checkLen > 0){
            	var selected = getSelect();
            	var enable = 0;
            	var stop =0;
            	for(var i=0;i<selected.length;i++){
            		if(selected[i].status=="启用"){
            			enable++;
            		}else{
            			stop++;
            		}
            	}
            	//如果选择只有一条且为停用则显示编辑按钮
            	if(selected.length==1&&stop==1){
            		$("#editBtn").prop('disabled', false);
            	}else{
            		$("#editBtn").prop('disabled', true);
            	}
            	//如果全部选择为启用  或者全部为停用
            	if(enable==selected.length){
            		$("#statusBtn").text("停用");
            		$('#statusBtn').prop('disabled', false);
            		$("#deleteBtn").prop('disabled', true);
            	}else if(stop==selected.length){
            		$("#statusBtn").text("启用");
            		$('#statusBtn').prop('disabled', false);
            		$("#deleteBtn").prop('disabled', false);
            	}else{
            		$('#statusBtn').prop('disabled', true);
            		$("#deleteBtn").prop('disabled', true);
            	}
            	$("#toolbar").addClass("show");
            }
            else{
                $("#toolbar").removeClass("show");
            }
        });

    };

})();

function initCreateTemp(){
	$("#tempName").val("");
	$("#noteContent").val("");
	$("#createdEnable").prop("checked",false);
}

function clearTempQuery(){
	$("#templateName").val("");
	$("#templateStatus").val("");
}

//启用停用按钮点击事件
 $("#statusBtn").click(function (){
	 var selected = getSelect();
	 var tempStatus;
	 var tempId=[];
	 if(selected[0].status=="启用"){
		 tempStatus=0;
	 }else{
		 tempStatus=1;
	 }
	 for(var i=0;i<selected.length;i++){
		 tempId[i]=selected[i].tempId;
	 }
	 $.ajax({
		 url:"<%=request.getContextPath()%>/note/modifyStatus",
		 dataType:'json',
		 type:'POST',
		 data:{
			 entId:"${entId}",
			 status:tempStatus,
			 tempId:tempId
		 },
		 traditional: true,
		 success:function(data){
			 if(data.success){
				 notice.alert("修改成功");
				 $("#toolbar").removeClass("show");
				 getTableData({page:1, rows:10, entId:'${entId}'});
			 }else{
				 notice.alert("修改失败");
				 $("#toolbar").removeClass("show");
			 }

		 }
	 });
 });
//编辑按钮点击事件
 $("#editBtn").click(function (){
	 var selected = getSelect();
	 if(selected.length==1){
		 $("#newtempName").val(selected[0].tempName);
		 $("#newnoteContent").val(selected[0].noteContent);
	 }
	 $("#editEnable").prop("checked",false);
 });
 //编辑提交按钮
 function editNoteTempSubmit(){
		if($("#newtempName").val().trim()==""){
			notice.danger("缺少模板标题");
			return ;
		}
		if($("#newnoteContent").val().trim()==""){
			notice.danger("缺少模板内容");
			return ;
		}
	 	var param=$("#editNoteForm").formValue();
		var str = JSON.stringify(param);
		var status;
		var tempId;
		if($("#editEnable").prop("checked")){
			status = 0;
		}else{
			status = 1;
		}
		var selected = getSelect();
		if(selected.length==1){
			tempId=selected[0].tempId;
		}
		$.ajax({
	        url : "<%=request.getContextPath()%>/note/editTemp",
	        type : "post",
	        dataType : "json",
	        data : {
	            entId :"${entId}",
	            info: str,
	            status: status,
	            tempId:tempId
	        },
	        success : function (data) {
	            if (data.success) {
	                notice.success("模板修改成功！");
	                $("#editTemplateModal").modal('hide');
	                getTableData({page:1, rows:10, entId:'${entId}'});
	                $("#toolbar").removeClass("show");
	            } else {
	            	$("#editTemplateModal").modal('hide');
	                notice.danger("修改失败！"+data.msg);
	            }
	        }
	    });
 }
 //删除按钮
 $("#deleteBtn").click(function(){
	 var selected = getSelect();
	 var tempId=[];
	 for(var i=0;i<selected.length;i++){
		 tempId[i]=selected[i].tempId;
	 }
	 $.ajax({
		 url:"<%=request.getContextPath()%>/note/delete",
		 dataType:'json',
		 type:'POST',
		 data:{
			 entId:"${entId}",
			 tempId:tempId
		 },
		 traditional: true,
		 success:function(data){
			 if(data.success){
				 notice.alert("删除成功");
				 $("#toolbar").removeClass("show");
				 getTableData({page:1, rows:10, entId:'${entId}'});
			 }else{
				 notice.alert("删除失败");
				 $("#toolbar").removeClass("show");
			 }

		 }
	 });
 });

 /* 取消按钮 */
 function cancel(){
	 $("#grid input[type=checkbox]").each(function(){
         $(this).attr("checked",false);
     });
     $("#toolbar").removeClass("show");
 }

function getSelect() {
    var data = [],
        rowData = null;
    $("#grid td input[type=checkbox]").each(function(){
        if($(this).prop("checked")){
            rowData = $(this).closest("tr").data("data");
            data.push(rowData);
        }
    });
    return data;
}

//创建模板
function createNoteTempSubmit(){
	if($("#tempName").val().trim()==""){
		notice.danger("缺少模板标题");
		return ;
	}
	if($("#noteContent").val().trim()==""){
		notice.danger("缺少模板内容");
		return ;
	}
	var param=$("#createNoteForm").formValue();
	var str = JSON.stringify(param);
	var status;
	if($("#createdEnable").prop("checked")){
		status = 0;
	}else{
		status = 1;
	}
	$.ajax({
        url : "<%=request.getContextPath()%>/note/create",
        type : "post",
        dataType : "json",
        data : {
            entId :"${entId}",
            info: str,
            status: status,
        },
        success : function (data) {
            if (data.success) {
                notice.success("模板创建成功！");
                $("#tempName").val("");
                $("#noteContent").val("");
                $("#createTemplateModal").modal('hide');
                getTableData({page:1, rows:10, entId:'${entId}'});
            } else {
            	$("#createTemplateModal").modal('hide');
                notice.danger("创建失败！"+data.msg);
            }
        }
    });
}

</script>

</body>
</html>