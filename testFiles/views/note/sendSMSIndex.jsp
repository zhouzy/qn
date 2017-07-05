<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>发送明细</title>
    <%@include file="/views/include/pageHeader.jsp"%>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/script/lib/dropzone/dropzone.css"/>
    <link data-origin-file="innerFrame.css" rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/static/css/innerFrame.css">
    <link data-origin-file="sendSMSIndex.css" rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/static/css/sendSMSIndex.css">
    <link data-origin-file="note.css" rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/static/css/note.css">

    <style>
        #formDetailId .form-group{
            float: left;
        }

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
		.ulcenter{
			text-align:center;
		}
        .btn span{
            padding-right: 5px;;
        }
        .control-label{
            padding-left: 0;
            padding-right:0;
        }
        #formId .btn.btn-raised{
            padding:4px 16px;
            margin: 6px;
        }
        .noteContent{
            width:200px;
            overflow: hidden;
            height:28px;
            line-height:28px;
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
    <div id="noteDtailDiv" style="height: 100%">
        <header class="part-header">
            <span>发送明细</span>
        </header>
        <div class="right-content" id="rightContainer" >
            <div class="right-content-panel container-fluid" id="rightDiv" >
                <div class="row">
                    <div class="col-sm-12">
                        <div class="query-condition" id="status">
                            <form id="formDetailId" class="form-horizontal clearfix">
                                <input type="text" name="sendTime" id="sendTime" data-label="发送时间:">

                                <div class="form-group">
                                    <label class="col-md-5 control-label">客户电话:</label>
                                    <div class="col-md-7">
                                        <input type="text" class="form-control" name="custPhone" id="custPhone" placeholder="">
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col-md-5 control-label">坐席姓名:</label>
                                    <div class="col-md-7">
                                        <input type="text" class="form-control" name="opName" id="opName" placeholder="">
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col-md-5 control-label">短信类型:</label>
                                    <div class="col-md-7">
                                        <select class="form-control" name="noteType" id="noteType" onchange="">
                                            <option value="">全部</option>
                                            <option value="-1">自定义</option>
                                            <option value="0">模板</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="fr" style="margin-top: 10px">
                                    <a class="btn btn-raised btn-default" onclick="clearQuery()">清空</a>
                                    <a class="btn btn-raised btn-primary" onclick="query()">查询</a>
                                </div>
                            </form>

                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-sm-12">
                        <div class="table-content">
                            <div class="grid" style="padding-bottom: 0;">
                                <table class="table" cellspacing="0" cellpadding="0" id="gridDetail" style="table-layout:fixed;">
                                    <thead>
                                    <tr class="order" id="chTableTitle">
                                        <!--  <th width="40"><input class="ember-view ember-checkbox all-checkbox" type="checkbox" id="allSelect"> </th> -->
                                        <th style="min-width: 80px;">客户电话</th>
                                        <th style="min-width: 80px;">发送内容</th>
                                        <th style="min-width: 80px;">短信类型</th>
                                        <th style="min-width: 80px;">坐席</th>
                                        <th style="min-width: 80px;">发送时间</th>
                                        <th style="min-width: 80px;">发送结果</th>
                                        <th style="min-width: 80px;">原因</th>
                                    </tr>
                                    </thead>
                                    <tbody></tbody>
                                    <tfoot>
                                    <tr id="paginationTR">
                                        <!--  <td colspan="7"><div id="paginationDetail"></div></td> -->
                                        <td colspan="7"><div id="pagination" styel="text-align:right;"></div></td>
                                    </tr>
                                    </tfoot>
                                </table>
                            </div>
                        </div>
                    </div>

                </div>
            </div>
        </div>
    </div>
</div>
<script id="table-ch-tp2" type="text/x-handlebars-template">
    <tr data-prop="">
        <td data-prop="custPhone">{{custPhone}}</td>
        <td data-prop="noteContent"><div class="noteContent">{{noteContent}}</div></td>
        <td data-prop="tempName">{{tempName}}</td>
        <td data-prop="opName">{{opName}}</td>
        <td data-prop="sendTime">{{sendTime}}</td>
		<td data-prop="result">{{result}}</td>
		<td data-prop="reason">{{reason}}</td>
    </tr>
</script>


<script type="text/javascript">
$(function(){
    var $sendTime = $("#sendTime");
    $sendTime.timeInput({
        format:"yyyy-MM-dd",
        HMS: false,
        value: ''
    });
    $sendTime.closest('.form-group').css({
        width: '24%'
    });
	query();
});

$("#notedetail").click(function(){

	$("#left-part .left-content-panel li").removeClass("active");
	$(this).addClass("active");
	$("#noteTempDiv").hide();
	$("#noteDtailDiv").show();
	$("#rightIframe").hide();
	query();
});

/**
 * 向后台请求数据
 */
var getDetailTableData = (function(){
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
            getDetailTableData(paramCache);
        }
    });

    return function(param) {
        $.post("<%=request.getContextPath()%>/notedetail/getNotes", param, function(data){
            if(data.rows == null) {
                notice.danger('数据加载失败，请刷新页面重试！');
                // 隐藏全选按钮
//                $("#allSelect").hide();
                // 表格数据清空
                $("#gridDetail").find("tbody").empty();
                // 分页按钮设为1
                pager.update(1, 10, 0);
            } else {        
               
                // 如果表格没有数据
                if(data.rows == null ){
                    notice.alert("暂无数据！");
                    // 隐藏全选按钮
//                    $("#allSelect").hide();
                    // 表格数据清空
                    $("#gridDetail").find("tbody").empty();
                    // 分页按钮设为1
                    pager.update(1, 10, 0);
                } else {
                	createDetailTable(data.rows);

                    // 显示全选按钮并初始化
//                    $("#allSelect").show();
//                    $("#allSelect").prop("checked",false);

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
var createDetailTable = (function(){
    var tableCHTpl = Handlebars.compile($("#table-ch-tp2").html()),
        $table = $("#gridDetail");

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
    };
    
})();

//查询条件清空
function clearQuery(){
	$("#custPhone").val("");
	$("#opName").val("");
	$("#noteType").val("");
	$("#sendTime").val("");
}
//查询
function query(){
	var param=$("#formDetailId").formValue();
	var str = JSON.stringify(param);
	getDetailTableData({page:1, rows:10, entId:'${entId}',condition:str});
}
</script>
</body>
</html>