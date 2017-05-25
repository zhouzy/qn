<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html >
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>联络历史</title>
    <%@include file="/views/include/pageHeader.jsp"%>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/static/css/innerFrame.css?v=1495612557280">
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/static/css/order.css?">
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/script/lib/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.css">
    <script src="<%=request.getContextPath()%>/script/lib/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
    <script src="<%=request.getContextPath()%>/script/lib/bootstrap-datetimepicker-master/js/locales/bootstrap-datetimepicker.zh-CN.js"></script>
</head>
<body>
    <div id="left-part">
        <div class="main-contain">
            <header class="part-header">
                <div class="sidebar">联络历史</div>
            </header>
            <div class="left-content">
                <div class="left-content-panel" id="allClass">
                    <ul class="left-content-panel-body left-part-list" id="tclassId"></ul>
                </div>
            </div>
        </div>

        <div class="toggle-btn-box">
            <button class="toggle-btn" id="leftToggleBtn"><i class="fa fa-angle-left" aria-hidden="true" style="font-size: 20px;"></i></button>
        </div>
    </div>
    <div id="right-part">
        <header class="part-header">
            <span id="right-part-title">所有联络历史</span>
        </header>
        <div class="right-content">
            <div class="container-fluid">
                <div class="row">
                    <div class="col-sm-12">
                        <div class="query-condition" id="queryCondition" style="height: 56px;">
                            <div class="col-sm-9">
                                <div class="row">
                                    <div class="form-horizontal" id="queryList">
                                        <div class="col-sm-4">
                                            <div class="form-group">
                                                <label for="userName" class="control-label col-sm-4">客户姓名：</label>
                                                <div class="col-sm-8">
                                                    <input class="form-control" type="text" id="userName" name="userName">
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-sm-4">
                                            <div class="form-group">
                                                <label for="source" class="control-label col-sm-4"> 媒体类型： </label>
                                                <div class="col-sm-8">
                                                    <select class="form-control" id="source" name="source">
                                                        <option value="">所有类型</option>
                                                        <option value="5">电话呼入</option>
                                                        <option value="6">电话呼出</option>
                                                        <option value="9">电话留言</option>
                                                        <option value="10">漏话</option>
                                                        <option value="-2">其他</option>
                                                    </select>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-sm-4">
                                            <div class="form-group">
                                                <label for="telPhone" class="control-label col-sm-4"> 电话号码： </label>
                                                <div class="col-sm-8">
                                                    <input id="telPhone" type="text" name="telPhone" class="form-control">
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-sm-6">
                                            <input id="customCreateFrom" type="text" name="customCreateFrom" class="form-control" data-label="联系时间：">
                                        </div>
                                        <div class="col-sm-6">
                                            <input id="customCreateTo" type="text" name="customCreateTo" class="form-control" data-label="至：">
                                        </div>
                                        <div class="col-sm-4">
	                                        <div class="form-group">
	                                            <label for="creatorId" class="control-label col-sm-4"> 归属人： </label>
	                                            <div class="col-sm-8">
	                                                <select class="form-control" id="creatorId" name="creatorId"></select>
	                                            </div>
	                                        </div>
	                                    </div>
                                        <div class="col-sm-4">
                                            <div class="form-group">
                                                <label for="commType" class="control-label col-sm-4"> 归属： </label>
                                                <div class="col-sm-8">
                                                    <select class="form-control" id="commType" name="commType">
                                                        <option value="">全部</option>
                                                        <option value="0">名单</option>
                                                        <option value="1">客户</option>
                                                    </select>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-sm-3" style="margin-top: 5px;">
                                <div class="row">
                                    <a class="btn btn-xs" href="javascript:void(0)" id="toggleBtn"> <span>更多</span> <i class="fa fa-caret-down"></i> </a>
									<a href="javascript:void(0)" class="btn btn-xs btn-raised" id="clearBtn" styel="margin-right:10px;">清空</a>
									<a href="javascript:void(0)" class="btn btn-xs btn-raised btn-primary" id="queryBtn">查询</a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-sm-12">
                        <div class="table-content">
                            <div class="col-12 grid">
                                <table id=orderGrid class="table" cellpadding="0" cellspacing="0">
                                    <thead>
                                    <tr class="order">
                                        <th>客户姓名</th>
                                        <th>归属</th>
                                        <th>媒体类型</th>
                                        <th>呼叫类型</th>
                                        <th>电话号码</th>
                                        <th>联系时间</th>
                                        <th>归属人</th>
                                        <th>沟通小结</th>
                                    </tr>
                                    </thead>
                                    <tbody id="orderTbody">

                                    </tbody>
                                    <tfoot>
                                    <tr>
                                        <td colspan="20">
                                            <div id="pagination">
                                                <a href="javascript:void(0)" class="btn btn-sm btn-raised btn-primary fl" id="exportBtn" style="display: none;margin-top: 23px;">导出结果</a>
                                            </div>
                                        </td>
                                    </tr>
                                    </tfoot>
                                </table>
                                <!-- 无联络历史---提示框 -->
                                <div id="noCH" style="display: none;text-align: center;">
                                    <strong style="font-size: 15px">暂无联络历史</strong>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

    </div>


<!-- 联络历史分类 -->
<script id="condition-custom" type="text/x-handlebars-template">
    {{#each commsListNum}}
    <li>
        <a href="#">{{this.title}}
            <span class="num">{{this.number}}</span>
        </a>
    </li>
    {{/each}}
</script>
    
<script id="table-tr-template-agent" type="text/x-handlebars-template">
    <tr>
        <td>
            {{#equal commType '0'}}
            <a class="name" href="#" onclick="viewDetails('{{namesId}}','{{userName}}','{{commType}}')">{{userName}}</a>
            {{else}}
            <a class="name" href="#" onclick="viewDetails('{{userId}}','{{userName}}','{{commType}}')">{{userName}}</a>
            {{/equal}}
        </td>
        <td>{{commTypeDesc}}</td>
		<td>{{source}}</td>
        <td>{{callType}}</td>
		<td>{{protectNum}}</td>
        <td>{{startTime}}</td> 
		<td>{{creatorName}}</td> 
		<td>{{content}}</td>
    </tr>
</script>

<script type="text/javascript">
//点击查询按钮，保存查询条件
var  searchData={};

$(function(){
	getTableData({condition:'01',queryParam:"",entId:'${entId}',page:1,rows:10,refreshRight:1});

    // 初始化默认查询条件样式
    $('#queryList > div.col-sm-4, #queryList > div.col-sm-12').css({
        height: '48px'
    });
    
 	//设置创建人下拉选项
    setCreatorIdOptions();
    defaultDateInit();
    // 权限菜单按钮控制隐藏或者显示
    permissionControl();

    // 左侧菜单展开/收起按钮
    $('#leftToggleBtn').on('click', (function() {
        var isOpen = true;
        var $body = $('body');
        var $leftToggleIcon = $('#leftToggleBtn').children('i');

        return function(event) {
            event.preventDefault();

            $body.toggleClass('left-is-closed');
            // 根据左侧菜单打开状态，修改按钮类
            if(isOpen) {
                $leftToggleIcon.removeClass('fa-angle-left').addClass('fa-angle-right');
            } else {
                $leftToggleIcon.removeClass('fa-angle-right').addClass('fa-angle-left');
            }

            isOpen = !isOpen;
        };
    })());

	// 展开或收起事件
    $("#toggleBtn").on('click', function(event) {
        // 阻止a标签默认跳转
        event.preventDefault();
        var $my = $(this);
        if($my.hasClass('to-click')) {
            $('#queryCondition').css({
                height: '56px'
            });
            $my.removeClass('to-click');
            $my.find('span').text('更多');
            $my.find('i').removeClass('fa-caret-up').addClass('fa-caret-down');
        } else {
            $('#queryCondition').css({
                'height': 'auto'
            });
            $my.addClass('to-click');
            $my.find('span').text('收起');
            $my.find('i').removeClass('fa-caret-down').addClass('fa-caret-up');
        }
    });

	// 查询事件
    $('#queryBtn').on('click', function(event) {
        // 阻止a标签默认跳转
        event.preventDefault();

        // 所有默认字段格式检测
        if(!allDefaultFieldCheck()) {
            return false;
        }

        // 设置特殊参数
        var param = $("#queryList").formValue();
        var customCreateFromVal = $("#customCreateFrom").val();
        var customCreateToVal = $("#customCreateTo").val();
        param.customCreateFrom = customCreateFromVal === '' ? '' : +new Date(customCreateFromVal) + "";
        param.customCreateTo = customCreateToVal === '' ? '' : +new Date(customCreateToVal) + "";

        var  condi = $("#allClass").find('li.active').data("queryType");

        // 去除查询条件的首位空格
        for(var p in param) {
            if(param.hasOwnProperty(p) && typeof param[p] === 'string') {
                param[p] = param[p].trim();
            }
        }
        searchData = encodeURI(JSON.stringify(param));

        //向后台发送数据encodeURI();
        getTableData({page:1,rows:10,entId:'${entId}',condition:condi,queryParam:searchData,refreshRight:-1});
    });
    
    // 清空所有选项
    $('#clearBtn').on('click', function(event) {
        // 阻止a标签默认跳转
        event.preventDefault();

        searchData = {};
        // 清空所有控件内容
        var $queryList = $('#queryList');
        $queryList.find('input, textarea').val('');
        $queryList.find('select').prop('selectedIndex', 0);
    });
    
 	// 导出查询结果
    $('#exportBtn').on('click', function(event) {
        // 阻止a标签默认跳转
        event.preventDefault();
        
        var  condi= $("#allClass li.active").data("queryType");
        $.ajax({
            url:"<%=request.getContextPath()%>/communicate/exportCommsHis?sessionKey="+ $.cookie("sessionKey"),
            type:"post",
            dataType:"json",
            data: {
            	param:searchData,
            	condition:condi,
            	entId:'${entId}'
            	
            },
            success : function(data){
                  if(data.rows.success){
                	  var downloadUrl = "<%=request.getContextPath()%>"+data.rows.fileUrl;
                               
                	  window.location.href=downloadUrl;
                } else {
                	notice.alert("未能导出数据","alert-danger");
                }
            }
        });
    });
});

/**
 * @desc [权限菜单按钮控制隐藏或者显示]
 */
var permissionControl = (function() {
    // 页面权限菜单对应的url与按钮元素的对照表
    var pageUrlObj = {
        'communicate/exportCommsHis': $('#exportBtn')
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

/*
 * @desc 默认时间字段初始化
 * */
function defaultDateInit() {
    var $allDates = $("#customCreateFrom, #customCreateTo");
    // 设置控件偏移量
    $allDates.closest('div.col-sm-6').css({
        'margin-left': '-18px'
    });
    $allDates.timeInput({
        format:"yyyy-MM-dd hh:mm:ss",
        HMS:true,
        value: ''
    });
}

//设置创建人下拉选项
function setCreatorIdOptions() {
	var queryCondition = JSON.stringify({"userStatus":"1"});
	var param = {page: 0, rows: 0,entId:'${entId}',query:queryCondition}
    $.ajax({
        url: "<%=request.getContextPath()%>/newuserManage/getuser",
        type: "post",
        dataType: "json",
        data: param,
        success: function (data) {
            if (data.success) {
                var sub = data.rows,
                    $tempId = $("#creatorId");
                $tempId.empty();
                $tempId.append('<option value=""> 所有用户</option>');
                // 添加选项
                for (var i = 0, len = sub.length; i < len; i++) {
                	if(sub[i].userName == "" || sub[i].userName == null){
                		sub[i].userName = sub[i].userId;
                	}
                    $tempId.append('<option value="' + sub[i].userId + '">' + sub[i].userName + '</option>');
                }

                //默认选中第一条数据
                $tempId.prop('selectedIndex', 0);
            }
        }
    });
}

/*
 * @desc 所有默认字段格式检测
 * @return true:格式正确 false:格式错误
 * */
function allDefaultFieldCheck() {
    /* 手机格式校验 */
    var telPhone = $("#telPhone").val().trim();
    if (telPhone !== "") {
        if (!Tools.phoneCheck(telPhone)) {
            notice.warning('电话号码格式不正确！');
            return false;
        }
    }

    var customCreateFromStr = $("#customCreateFrom").val();
    var customCreateToStr = $("#customCreateTo").val();
    try {
        customCreateFromStr = new Date(customCreateFromStr).getTime();
        customCreateToStr = new Date(customCreateToStr).getTime();
    } catch (e) {
        notice.warning("时间格式不正确-。-");
        return false;
    }

    if (customCreateFromStr > customCreateToStr) {
        notice.warning("联系时间:起始与截止时间范围不正确-。-");
        return false;
    }

    return true;
}

/**
 * 向后台请求数据
 */
var getTableData = (function(){
    var paramCache = {};

    /**
     * 初始化分页
     */
    var pager = new cri.Pager($("#pagination"),{
        page:1,
        pageSize:10,
        total:0,
        onPage:function(page,pageSize){
            $.extend(paramCache,{page:page,rows:pageSize});
            getTableData(paramCache);
        }
    });
    return function(param,url){
        $.ajax({
     	    url : "<%=request.getContextPath()%>/communicate/queryCumms",
            dataType:'json',
            data:param,
            success:function(data){
                if(!data.success){
                    notice.alert(data.msg);
                    return;
                }
                //刷新左侧分类菜单
                if(param.refreshRight == 1){
                    refreshRightButton(data.rows);
                    param.refreshRight = -1; //设置第一次进入分页参数 将refreshRight置为-1,加快点击分页查询速度
                }
                //$("#toolbar").removeClass("show");
                if(data.rows.objectList){
					createTable(data.rows.objectList);
				}
                pager.update(param.page,param.rows,data.total);
                $.extend(paramCache,param);
            }
        });
    }
})();

/**
 * 刷新左侧分类菜单
 */
var refreshRightButton = (function(){
    var conditionTemp = Handlebars.compile($("#condition-custom").html());       

    var $ui = $("#tclassId");       

    return function(data){

        $li = $(conditionTemp(data));
        $ui.empty().append($li);

        $("#tclassId li:first").addClass("active");          
        /* 分类 */
        var i=0;
        $("#tclassId li").each(function(){
        	var $this = $(this);
        	if(i<9){
        		$this.data("queryType","0"+(i+1));
        	}else{
        		$this.data("queryType",i+1);
        	}	
        	i=i+1;
        });
        
        /* 分类点击事件 */
        $("#tclassId li").click(function(){
            var $this = $(this);
            var $prevActiveLi = $("#allClass").find('li.active');
            var allDateField = $('#customCreateFrom, #customCreateTo');

            $prevActiveLi.removeClass("active");
            $this.addClass("active");
            //清空查询条件
            $('#clearBtn').click();

            // 所有联络历史则显示时间查询框，其他都不显示(因为其他的本身就含有时间限制，如：当月联络历史)
            // @latest Lesty 2016.8.24
            if($this.data('queryType') !== '01') {
                allDateField.closest('div.col-sm-6').hide();
            } else {
                allDateField.closest('div.col-sm-6').show();
            }

            getTableData({page:1,rows:10,condition:$this.data("queryType"),entId:'${entId}',queryParam:"",refreshRight:-1});
            
            $("#tclassId").data("queryType",$this.data("queryType"));
            var title=$(this).html().split("<")[1];                   
            title=title.split(">")[1];
            
            $("#right-part-title").text(title);
            //$("#rightIframe").hide().parent().css("overflow","auto");
           	$("#right-part .part-header .dropdown").css('display','inline-block');
            //$("#rightDiv").show();
        });
    }
})();

/**
 * 刷新表格
 */
var createTable = (function(){
	var trTempAgent = Handlebars.compile($("#table-tr-template-agent").html());
    var $table = $("#orderGrid");
    return function(tableData){
        var html = [];
        var rows = tableData ? tableData : [];
        var tempInfo = null;
        var $tr = null;
        // 联络归属类型对照表
        var CONTACT_TYPE_MAP = {
            '0': '名单',
            '1': '客户'
        };

        // if没有联络历史
        if (rows.length <= 0) {
        	$table.hide();
        	$('#noCH').show();
            return;
        } else {
        	$('#noCH').hide();
        	$table.show();
        }
        var map = {
            '0': '外呼',
            '1': '客户'
        };
        for(var i = 0, len = rows.length; i < len; i++) {
            tempInfo = tableData[i];
            tempInfo.commTypeDesc = CONTACT_TYPE_MAP[tempInfo.commType || '1'];
            $tr = $(trTempAgent(tempInfo));
            html.push($tr);
        }
        $table.find("tbody").empty().append(html);
    };
})();

/* 查看用户详情 */
function viewDetails(userId, userName, commType) {
    //0:电销外拨,进入名单详情
    var _t = +new Date();
    if (commType === "0") {
        parent.openTab("<%=request.getContextPath()%>/teleActivity/detail?namesId=" + userId + '&t=' + _t, "user", '名单-' + userName, true);
    }
    else {
        parent.openTab("<%=request.getContextPath()%>/userManageMongo/userDetails?userId=" + userId + '&t=' + _t, "user", userName, false);
    }
}

</script>

</body>
</html>
