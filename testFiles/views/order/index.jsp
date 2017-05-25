<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>工单中心</title>
    <%@include file="/views/include/pageHeader.jsp" %>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/static/css/innerFrame.css">
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/script/lib/summernote/summernote.css">
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/static/css/order.css">
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/script/lib/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.css">
    <script src="<%=request.getContextPath()%>/script/lib/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
    <script src="<%=request.getContextPath()%>/script/lib/bootstrap-datetimepicker-master/js/locales/bootstrap-datetimepicker.zh-CN.js"></script>
    <script src="<%=request.getContextPath()%>/script/lib/summernote/summernote.js"></script>
    <script src="<%=request.getContextPath()%>/script/lib/summernote/summernote-zh-CN.js"></script>
</head>
<body>
<div id="left-part">
    <div class="main-contain">
        <header class="part-header">
            <div class="sidebar">工单中心
                <a href="javascript:void(0);" id="batchImport" class="operation-link" onclick="goImport();" style="display: none;">批量导入</a>
            </div>
        </header>
        <div class="left-content">
            <div class="left-content-panel" id="allClass">
                <div class="left-content-panel-header">
                    我的工单
                    <a href="javascript:void(0);" id="refreshDefaultBtn">刷新</a>
                </div>
                <ul class="left-content-panel-body left-part-list" id="defaultFilterList"></ul>

                <div class="left-content-panel-header">
                    自定义筛选器
                    <a href="javascript:void(0);" id="customFilterToggleBtn">收起</a>
                    <a href="javascript:void(0);" id="refreshCustomBtn">刷新</a>
                    <a href="javascript:void(0);" id="toWorkFilter" style="display: none;">管理筛选器</a>
                </div>
                <div id="allCFList">
                    <ul class="left-content-panel-body left-part-list" id="customFilterList"></ul>
                    <div id="showMore" style="display: none;overflow:hidden;">
                        <a class="btn btn-block btn-success btn-sm" style="margin-top: 0;">
                            <span>加载更多</span>
                        </a>
                    </div>
                    <ul class="left-content-panel-body left-part-list" id="moreFilterList"></ul>
                </div>

            </div>
        </div>
    </div>

    <div class="toggle-btn-box">
        <button class="toggle-btn" id="leftToggleBtn"><i class="fa fa-angle-left" aria-hidden="true" style="font-size: 20px;"></i></button>
    </div>
</div>
<div id="right-part">
    <header class="part-header">
        <div class="sidebar-right" id="right-part-title"></div>
    </header>
    <iframe name="iframe" id="rightIframe" style="display:none" width="100%" height="100%" src="" frameborder="0"
            data-id="index_v1.html" seamless></iframe>
    <div class="right-content" id="rightDiv">
        <div class="container-fluid">
            <div class="row">
                <div class="col-sm-12">
                    <div class="query-condition" id="queryCondition" style="height: 56px;">
                        <div class="col-sm-9">
                            <div class="row">
                                <div class="form-horizontal" id="queryList">
                                    <div class="col-sm-4">
                                        <div class="form-group">
                                            <label for="tempId" class="control-label col-sm-4"> 工单模板：</label>
                                            <div class="col-sm-8">
                                                <select class="form-control" id="tempId" name="tempId"></select>
                                            </div>
                                        </div>
                                    </div>
<%--                                    <div class="col-sm-4">
                                        <div class="form-group">
                                            <label for="loginName" class="control-label col-sm-4"> 登陆账号：</label>
                                            <div class="col-sm-8">
                                                <input id="loginName" type="text" name="loginName" class="form-control">
                                            </div>
                                        </div>
                                    </div>--%>
                                    <div class="col-sm-4">
                                        <div class="form-group">
                                            <label for="workId" class="control-label col-sm-4"> 工单编号：</label>
                                            <div class="col-sm-8">
                                                <input id="workId" type="text" name="workId" class="form-control">
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-sm-4">
                                        <div class="form-group">
                                            <label for="workPhone" class="control-label col-sm-4"> 工单电话：</label>
                                            <div class="col-sm-8">
                                                <input id="workPhone" type="text" name="workPhone" class="form-control">
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-sm-4">
                                        <div class="form-group">
                                            <label for="status" class="control-label col-sm-4"> 工单状态：</label>
                                            <div class="col-sm-8">
                                                <select class="form-control" id="status" name="status" multiple style="height: 56px;">
                                                    <option value="" selected>所有状态</option>
                                                    <option value="0">尚未受理</option>
                                                    <option value="1">受理中</option>
                                                    <option value="2">等待回复</option>
                                                    <option value="3">已解决</option>
                                                    <option value="4">已关闭</option>
                                                    <option value="5">待回访</option>
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-sm-4">
                                        <div class="form-group">
                                            <label for="Work_serviceGroupId" class="control-label col-sm-4"> 受理组： </label>
                                            <div class="col-sm-8">
                                                <select id="Work_serviceGroupId" name="serviceGroupId" class="form-control">
                                                    <option value="">-- 选择受理组 --</option>
                                                    <option value="_blank_">-- 值为空 --</option>
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-sm-4">
                                        <div class="form-group">
                                            <label for="Work_customServiceId" class="control-label col-sm-4"> 受理人： </label>
                                            <div class="col-sm-8">
                                                <select id="Work_customServiceId" name="customServiceId" class="form-control">
                                                    <option value="">-- 选择受理人 --</option>
                                                    <option value="_blank_">-- 值为空 --</option>
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-sm-4">
                                        <div class="form-group">
                                            <label for="Work_creatorId" class="control-label col-sm-4"> 创建人：</label>
                                            <div class="col-sm-8">
                                                <select id="Work_creatorId" name="creatorId" class="form-control">
                                                    <option value="">-- 选择创建人 --</option>
                                                    <option value="_blank_">-- 值为空 --</option>
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-sm-4">
                                        <div class="form-group">
                                            <label for="priority" class="control-label col-sm-4"> 优先级： </label>
                                            <div class="col-sm-8">
                                                <select class="form-control" id="priority" name="priority">
                                                    <option value="-1">所有</option>
                                                    <option value="1">低</option>
                                                    <option value="2">中</option>
                                                    <option value="3">高</option>
                                                    <option value="4">紧急</option>
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                    <!-- 分隔符 -->
                                    <span class="col-sm-12" style="height: 0;"></span>
                                    <div class="col-sm-4">
                                        <input id="orderCreateFrom" class="timeInput" type="text" name="orderCreateFrom" data-type="date" data-label="工单创建时间：">
                                    </div>
                                    <div class="col-sm-4">
                                        <input id="orderCreateTo" type="text" name="orderCreateTo" data-type="date" data-label="至：">
                                    </div>
                                    <span class="col-sm-12" style="height: 0;"></span>
                                    <div class="col-sm-4">
                                        <input id="orderOverFrom" type="text" name="orderOverFrom" data-type="date" data-label="工单结束时间：">
                                    </div>
                                    <div class="col-sm-4">
                                        <input id="orderOverTo" type="text" name="orderOverTo" data-type="date" data-label="至：">
                                    </div>
                                    <div id="userFieldUl"></div>
                                </div>
                            </div>
                        </div>
                        <div class="col-sm-3" style="margin-top: 5px;">
                            <div class="row">
                                <div class="col-sm-4">
                                    <a href="javascript:void(0)" class="btn btn-xs" id="toggleBtn">
                                        <span>更多</span>
                                        <i class="fa fa-caret-down"></i>
                                    </a>
                                </div>
                                <div class="col-sm-8 text-right">
                                    <a href="javascript:void(0);" class="btn btn-xs btn-raised" id="clearBtn" style="margin-right: 10px;">清空</a>
                                    <a href="javascript:void(0);" class="btn btn-xs btn-raised btn-primary" id="queryBtn">查询</a>
                                </div>
                                <div class="col-sm-12 text-right">
                                    <button type="button" class="btn btn-sm btn-raised btn-primary" id="saveAsFilter" data-toggle="modal" style="display: none">保存为筛选器</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-sm-12">
                    <div class="table-content">
                        <div class="col-12 grid">
                            <table class="table footable" cellspacing="0" cellpadding="0" id="orderGrid"
                                   data-page-size="10">
                                <thead>
                                <tr class="order">
                                    <th data-sort-ignore="true" class="footable-first-column">
                                        <input type="checkbox" id="allSelect">
                                    </th>
                                    <c:forEach items="${fieldList}" var="item">
                                        <th>${item.name}</th>
                                    </c:forEach>
                                </tr>
                                </thead>
                                <tbody></tbody>
                                <tfoot>
                                <tr>
                                    <td colspan="20">
                                        <div id="pagination">
                                            <a href="javascript:void(0)" class="btn btn-sm btn-raised btn-primary fl" id="exportBtn" style="margin-top: 23px;display: none;">导出结果</a>
                                        </div>
                                        <div id="exportTips" style="display: none">本次导出数据量较大，请稍后到<a href="#">附件管理</a>页面自行下载</div>
                                    </td>
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
        <button id="deleteBtn" type="button"
                class="btn btn-raised left-btn btn-danger" style="display: none;">删除
        </button>
        <button id="cancelBtn" type="button"
                class="btn btn-raised btn-default">清除选择
        </button>
        <button id="editBtn" type="button" class="btn btn-raised btn-primary"
                data-toggle="modal" data-target="#editOrderModal" style="display: none;"></button>
    </div>
</div>
<%@include file="editWf.jsp" %>

<!-- 保存筛选器 -->
<div id="saveFilterModal" class="modal fade bs-example-modal-sm" data-backdrop="static">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <span class="modal-title">保存筛选器</span>
            </div>
            <div class="modal-body">
                <div class="container-fluid">
                    <div class="row">
                        <div class="col-sm-10 col-sm-offset-1">
                            <form class="form-horizontal" onsubmit="saveNewFilter(event)">
                                <div class="form-group">
                                    <label for="filterName" class="control-label col-sm-4">工单筛选器名称<span style="color: red">*</span>：</label>
                                    <div class="col-sm-8">
                                        <input id="filterName" type="text" name="filterName" class="form-control" required>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-raised btn-default btn-sm" data-dismiss="modal">取消</button>
                <button type="button" class="btn btn-raised btn-primary btn-sm" id="saveFilterBtn">保存</button>
            </div>
        </div>
    </div>
</div>

<script id="table-tr-template" type="text/x-handlebars-template">
    <tr>
        <td><input type="checkbox"></td>
        <td>{{workId}}</td>
        <td class="form-order-title"><a>{{title}}</a></td>
        <td><span class="tip-order-state {{statusClass}}">{{statusStr}}</span></td>
        <td>{{creatorName}}</td>
        <td>{{customName}}</td>
        <td>{{workPhone}}</td>
        <td>{{createDate}}</td>
        <td>{{serviceGroupName}}</td>
        <td>{{customServiceName}}</td>
        <td>{{tempName}}</td>
        <td>{{resolveDate}}</td>
    </tr>
</script>

<%-- 筛选器列表 --%>
<script id="filter-list" type="text/x-handlebars-template">
    {{#each filterList}}
    <li data-title="{{this.condition.title}}" data-condition-id="{{this.condition.conditionId}}">
        <a href="#">{{this.condition.title}}
            <span class="num">{{this.num}}</span>
        </a>
    </li>
    {{/each}}
</script>


<script id="tooltip-template" type="text/x-handlebars-template">
    <div class="tip-content panel panel-default">
        <div class="tip-header panel-heading">
            <span class="col-12"># {{workId}}</span><span class="tip-order-state {{statusClass}}">{{statusStr}}</span>
        </div>
        <div class="tip-row panel-body">
            <div class="container-fluid">
                <div class="row">
                    <span class="col-xs-3">标题</span><span class="col-xs-9">{{title}}</span>
                </div>
                <div class="row">
                    <span class="col-xs-3">时间</span><span class="col-xs-9">{{createDate}}</span>
                </div>
                <div class="row">
                    <span class="col-xs-3">客户名称</span><span class="col-xs-9">{{customName}}</span>
                </div>
            </div>
            {{#if event.[0]}}
            <div class="container-fluid">
                <div class="row">
                    <span class="col-xs-12">最新回复</span>
                </div>
                <div class="row">
                    <span class="col-xs-3">内容</span><span class="col-xs-9">{{event.[0].[0]}}</span>
                </div>
                <div class="row">
                    <span class="col-xs-3">回复人</span><span class="col-xs-9">{{event.[0].[3]}}</span>
                </div>
            </div>
            {{/if}}
        </div>
    </div>
</script>
<!-- 1:字符串 -->
<script id="field-comp-1" type="text/x-handlebars-template">
    <div class="col-sm-4">
        <div class="form-group">
            <label class="control-label col-sm-4">
                <span class="row">{{name}}：</span>
            </label>
            <div class="col-sm-8">
                <input id="{{key}}" type="text" name="{{key}}" class="form-control" data-label="{{name}}">
            </div>
        </div>
    </div>
</script>
<!-- 2:文本框 -->
<script id="field-comp-2" type="text/x-handlebars-template">
    <div class="col-sm-4" data-comp-type="textarea">
        <div class="form-group">
            <label class="control-label col-sm-4">
                <span class="row">{{name}}：</span>
            </label>
            <div class="col-sm-8">
                <textarea class="form-control" name="{{key}}" id="{{key}}" rows="4" data-label="{{name}}"></textarea>
            </div>
        </div>
    </div>
</script>
<!-- 3:下拉框 -->
<script id="field-comp-3" type="text/x-handlebars-template">
    <div class="col-sm-4">
        <div class="form-group">
            <label class="control-label col-sm-4">
                <span class="row">{{name}}：</span>
            </label>
            <div class="col-sm-8">
                <select class="form-control" id="{{key}}" name="{{key}}" data-label="{{name}}">
                    <option value="" selected>-- 全部 --</option>
                    <option value="_blank_">-- 值为空 --</option>
                    {{#each candidateValue}}
                    <option value="{{this}}">{{this}}</option>
                    {{/each}}
                </select>
            </div>
        </div>
    </div>
</script>
<!-- 4:复选框 -->
<script id="field-comp-4" type="text/x-handlebars-template">
<%--    {{#if covered}}
    <div class="col-sm-12">
        <div class="form-group">
            <label class="control-label col-sm-2" style="padding-right: 20px;">{{name}}</label>
            <div class="col-sm-10 checkbox" style="padding-left: 10px;">
                {{#each candidateValue}}
                <label>
                    <input type="checkbox" value="{{this}}" name="{{../key}}" data-label="{{../name}}">{{this}}
                </label>
                {{/each}}
            </div>
        </div>
    </div>
    {{else}}
    <div class="col-sm-6">
        <div class="form-group">
            <label class="control-label col-sm-4">{{name}}</label>
            <div class="col-sm-8 checkbox">
                {{#each candidateValue}}
                <label>
                    <input type="checkbox" value="{{this}}" name="{{../key}}" data-label="{{../name}}">{{this}}
                </label>
                {{/each}}
            </div>
        </div>
    </div>
    {{/if}}--%>
</script>
<!-- 5:未定 -->
<script id="field-comp-5" type="text/x-handlebars-template">

</script>
<!-- 6:数字 -->
<script id="field-comp-6" type="text/x-handlebars-template">
    <div class="col-sm-4">
        <div class="form-group">
            <label class="control-label col-sm-4">
                <span class="row">{{name}}：</span>
            </label>
            <div class="col-sm-8">
                <input id="{{key}}" type="text" name="{{key}}" class="form-control" data-reg="^-?\d+$" data-label="{{name}}">
            </div>
        </div>
    </div>
</script>
<!-- 7:小数 -->
<script id="field-comp-7" type="text/x-handlebars-template">
    <div class="col-sm-4">
        <div class="form-group">
            <label class="control-label col-sm-4">
                <span class="row">{{name}}：</span>
            </label>
            <div class="col-sm-8">
                <input id="{{key}}" type="text" name="{{key}}" class="form-control" data-reg="^-?\d+\.\d+$" data-label="{{name}}">
            </div>
        </div>
    </div>
</script>
<!-- 8:正则表达式 -->
<script id="field-comp-8" type="text/x-handlebars-template">
    <div class="col-sm-4">
        <div class="form-group">
            <label class="control-label col-sm-4">
                <span class="row">{{name}}：</span>
            </label>
            <div class="col-sm-8">
                <input id="{{key}}" type="text" name="{{key}}" class="form-control" data-reg="{{reg}}" data-label="{{name}}">
            </div>
        </div>
    </div>
</script>
<!-- 9:电话号码 -->
<script id="field-comp-9" type="text/x-handlebars-template">
    <div class="col-sm-4">
        <div class="form-group">
            <label class="control-label col-sm-4">
                <span class="row">{{name}}：</span>
            </label>
            <div class="col-sm-8">
                <input id="{{key}}" type="text" name="{{key}}" class="form-control" data-reg="{{reg}}" data-label="{{name}}">
            </div>
        </div>
    </div>
</script>
<!-- 10:时间输入框 -->
<script id="field-comp-10" type="text/x-handlebars-template">
<%--    <div class="col-sm-6">
        <input id="{{key}}" type="text" name="{{key}}" data-label="{{name}}" data-type="datetimepicker" data-reg="{{reg}}" data-field="{{name}}" data-name="{{key}}">
    </div>--%>
</script>
<!-- 11:省市区 -->
<script id="field-comp-11" type="text/x-handlebars-template">
    <div class="col-sm-10">
        <div class="form-group">
            <label class="control-label col-sm-2" style="padding-right: 20px;">{{name}}：</label>

            <div class="col-sm-10">
                <div class="row">
                    <div class="col-sm-4">
                        <span><select class="form-control" data-label="{{name}}" data-field-type="pca" name="province_{{key}}" id="Work_province{{key}}" style="box-shadow: none;"></select></span>
                    </div>
                    <div class="col-sm-4">
                        <span><select class="form-control" data-field-type="pca" name="city_{{key}}" id="Work_city{{key}}" style="box-shadow: none;"></select></span>
                    </div>
                    <div class="col-sm-4">
                        <span><select class="form-control" data-field-type="pca" name="area_{{key}}" id="Work_area{{key}}" style="box-shadow: none;"></select></span>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <input type="hidden" name='{{key}}' id="{{key}}">
</script>
<script src="<%=request.getContextPath()%>/script/lib/PCASClass.js"></script>

<script>
    //点击查询按钮，保存查询条件
    var searchData = {};
    // 归属客服组下相应的客服名称
    var SERVICE_NAME_G = {};

    $(function () {
        // 初始化默认字段
        defaultFieldInit();

        // 权限菜单按钮控制隐藏或者显示
        permissionControl();

        // 创建左侧默认筛选器列表，同时生成右侧表格
        createFilterList(true, '1', '0', function() {
            // 创建左侧自定义筛选器列表
            createFilterList(false, '0', '0', function(data) {
                var $showMore = $('#showMore');
                if(data.total > 5) {
                    $showMore.show();
                } else {
                    $showMore.hide();
                }
            });
        });

        // 清空全选按钮
        $("#allSelect").prop("checked", false);

        // 事件注册
        regEvent();
    });

    /*
     * @desc 筛选器对象
     * */
    var CustomerFilter = (function() {
        // 管理筛选器元素
        var $customFilter = $('#toWorkFilter');
        // 保存为筛选器元素
        var $saveAsFilter = $('#saveAsFilter');

        function hide() {
            $customFilter.hide();
            $saveAsFilter.hide();
        }

        function show() {
            $customFilter.show();
            $saveAsFilter.show();
        }

        return {
            hide: hide,
            show: show
        };
    })();

    /**
     * @desc [权限菜单按钮控制隐藏或者显示]
     */
    var permissionControl = (function() {
        // 页面权限菜单对应的url与按钮元素的对照表
        var pageUrlObj = {
            'queryWorkOrderInfo/updateWorkOrder': $('#editBtn'),
            'userImport/workOrderIndex': $('#batchImport'),
            'reportWork/exportWfList': $('#exportBtn'),
            'queryWorkOrderInfo/deleteWorkOrder': $('#deleteBtn'),
            'queryWorkCondition/getIndex': CustomerFilter
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
    * @desc 默认字段初始化
    * */
    function defaultFieldInit() {
        var $allDates = $("#orderCreateFrom, #orderCreateTo, #orderOverFrom, #orderOverTo");

        // 设置工单模板下拉选项
        workTplInit();

        // 初始化受理客服组
        serviceGroupInit();

        // 创建人初始化
        creatorInit();

        // 设置控件偏移量
        $allDates.closest('div.col-sm-6').css({
            //'margin-left': '-18px'
        });
        $allDates.timeInput({
            format:"yyyy-MM-dd hh:mm:ss",
            HMS:true,
            value: ''
        });

        // 初始化默认查询条件样式
        $('#queryList').children('div').not('#userFieldUl').css({
            height: '55px'
        });
    }

    /**
     * @desc 初始化受理客服组
     */
    function serviceGroupInit() {
        $.post('<%=request.getContextPath()%>/groupMongo/getAgentGroups', {
            rows: -1
        }, function(data) {
            var $serviceGroupId = $('#Work_serviceGroupId');
            var rows = data.rows;
            var group = null;
            var optionsHtml = '<option value="" selected>-- 选择受理组 --</option><option value="_blank_">-- 值为空 --</option>';
            for(var i = 0, len = rows.length; i < len; i++) {
                group = rows[i];
                // 增加options选项
                optionsHtml += '<option value="' + group.groupId + '">' + group.groupName +'</option>';
                // 缓存数据到全局客服组-客服对象
                SERVICE_NAME_G[group.groupId] = group.members;
            }

            $serviceGroupId.html(optionsHtml);
            if($serviceGroupId.data('val') != null) {
                $serviceGroupId.val($serviceGroupId.data('val')).change();
            }
        });
    }

    /**
     * @desc 创建人初始化
     */
    function creatorInit() {
        $.post('<%=request.getContextPath()%>/userManageMongo/findAgentsForCondition', function(data) {
            var $creatorId = $('#Work_creatorId');
            var rows = data.rows;
            var creator = null;
            var optionsHtml = '<option value="" selected>-- 选择创建人 --</option><option value="_blank_">-- 值为空 --</option>';
            for(var i = 0, len = rows.length; i < len; i++) {
                creator = rows[i];
                // 增加options选项
                optionsHtml += '<option value="' + creator.userId + '">' + creator.userName +'</option>';
            }

            $creatorId.html(optionsHtml);
            if($creatorId.data('val') != null) {
                $creatorId.val($creatorId.data('val'));
            }
        });
    }

    // 设置工单模板下拉选项
    function workTplInit() {
        $.ajax({
            url: "http://<%=request.getServerName()%>:" + parent.workBasePath + "/workorder/queryTemplate?sessionKey=" + $.cookie("sessionKey"),
            type: "post",
            dataType: "jsonp",
            data: "",
            success: function (data) {
                if (data.success) {
                    var sub = data.rows,
                            optionsHtml = '<option value="-1" selected>所有模板</option>',
                            $tempId = $("#tempId");

                    // 添加选项
                    for (var i = 0, len = sub.length; i < len; i++) {
                        optionsHtml += '<option value="' + sub[i].tempId + '">' + sub[i].tempName + '</option>';
                    }

                    //默认选中第一条数据
                    $tempId.html(optionsHtml);
                }
            }
        });
    }

    /*
     * @desc 省市区字段初始化
     * @prefix String [id前缀，避免冲突]
     * @PCAKeys Array [包含所有省市区字段key的数组]
     * */
    function pcasInit(prefix, PCAKeys, values) {
        var pcaArr = values != null ? values : [];
        new PCAS("#" + prefix +"_province" + PCAKeys,"#" + prefix + "_city" + PCAKeys,"#" + prefix + "_area" + PCAKeys, pcaArr[0], pcaArr[1], pcaArr[2]);
    }

    /**
     * @desc 创建左侧筛选器列表
     * @author Lesty
     * @isGetTableData Boolean 是否获取表格数据
     * @isMore String 是否获取更多筛选器，'0': 获取前半部分，'1': 获取后半部分
     */
    function createFilterList(isGetTableData, isDefault, isMore, callback) {
        // 取默认筛选器时，isMore参数为空
        isMore = isDefault === '1' ? '' : isMore;
        $.post("<%=request.getContextPath()%>/queryWorkCondition/queryConditionList", {
            isDefault: isDefault,
            isMore: isMore
        }, function(data) {
            var $list = null;

            if(isDefault === '1') { // 获取默认筛选器
                refreshDefaultFilterList(data);
                $list = $('#defaultFilterList');
            } else {
                refreshCustomFilterList(data, isMore);
                $list = $('#customFilterList');
            }

            // 如果需要获得表格数据
            if(isGetTableData === true) {
                $list && $list.find('li.active').click();
            }

            if(typeof callback === 'function') {
                callback(data);
            }
        });
    }

    /*
     * @author Lesty
     * @codeDate 2016.8.6
     * @desc [获取自定义字段列表数据]
     * */
    var getCustomizeFieldListData = (function(){
        return function(param, callback){
            $.ajax({
                url:"<%=request.getContextPath()%>/workorder/queryTemplateField?sessionKey="+ $.cookie("sessionKey"),
                type: "post",
                dataType: 'jsonp',
                data: param,
                success: function(data) {
                    if(!(data.success)) {
                        notice.danger(data.msg);
                        return;
                    }

                    if(data.rows != null) {
                        createCustomizeFieldList(data.rows.field);
                    }

                    if(typeof callback === 'function') {
                        callback();
                    }
                }
            });
        }
    })();

    /*
     * @author Lesty
     * @codeDate 2016.8.6
     * @desc [创建/刷新自定义字段列表]
     * @tableData Array [自定义字段列表数据]
     * */
    var createCustomizeFieldList = (function(){
        var $fieldList = $('#userFieldUl');

        return function(tableData) {
            var list = tableData ? tableData : [];
            var html = [];
            // 一个控件元素
            var $ele = null;
            // 一条数据
            var field = null;
            var PCAKeys = [];

            // 没有自定义字段
            if (list.length <= 0) {
                $fieldList.empty();
                return;
            }

            // 遍历数据生成自定义字段列表
            for(var i = 0, len = list.length; i < len; i++) {
                field = list[i];
                if(field.default === true) {
                    continue;
                }
                // 保存省市区字段key用以初始化
                if(field.componentType === '11') {
                    PCAKeys.push(field.key);
                }

                $ele = getOneField(field);
                // 添加一条数据
                html.push($ele);
            }

            // 创建表格
            $fieldList.empty().append(html);

            // 自定义字段渲染
            userFieldModule.render();

            // 省市区字段初始化
            for(var i = 0, len = PCAKeys.length; i < len; i++) {
                pcasInit('Work', PCAKeys[i]);
            }
        }
    })();

    /*
     * @desc 获取一条自定义字段的html
     * @data String [自定义字段数据]
     * @return Object [导入数据过后的html模板对象]
     * */
    function getOneField(data) {
        // 需要正则的componentType对象
        var regComps = {
            8: '8',
            9: '9',
            10: '10'
        };
        // 模板
        var fieldTemp = Handlebars.compile($('#field-comp-' + data.componentType).html());
        // 一条数据
        var $field = null;

        // 如果控件类型需要正则，则创建reg属性
        if(data.componentType in regComps) {
            data.reg = Array.isArray(data.candidateValue) ? data.candidateValue[0] : "";
        }

        // 复选框多于3个，则铺满一行
        if(data.componentType === '4' && data.candidateValue.length > 3) {
            data.covered = true;
        }

        // 生成数据
        $field = $(fieldTemp(data));

        return $field;
    }

    /**
     * 用户自定义字段模块
     */
    var userFieldModule = function(){
        var $container = $('#userFieldUl');

        var _validator = function(){
            return $container.validator();
        };

        return {
            render:function(){
                var $userFieldUl = $('#userFieldUl');
                $userFieldUl.children('div').not('[data-comp-type=textarea]').css({
                    height: '55px'
                });

                $userFieldUl.children('div[data-comp-type=textarea]').css({
                    height: '96px'
                });
            },
            _validator: _validator
        };
    }();

    /**
     * @desc 刷新左侧系统筛选器列表
     */
    var refreshDefaultFilterList = (function () {
        var conditionTemp = Handlebars.compile($("#filter-list").html());

        // 默认筛选器
        var $defaultFilterList = $("#defaultFilterList");

        return function (data) {
            var listData = {
                filterList: data.rows
            };

            var $li = $(conditionTemp(listData));
            // 当前选中的标题
            var title = $defaultFilterList.find('li.active').attr('data-title');
            // 要被标记为active的菜单项
            var $toBeActive = null;

            $defaultFilterList.empty().append($li);

            if($('#allClass').find('li.active').length === 0) { // 如果active选项不存在
                if(title != null) {
                    $toBeActive = $defaultFilterList.find('li[data-title="' + title + '"]');
                } else {
                    $toBeActive = $defaultFilterList.find('li:eq(0)');
                }

                $toBeActive.addClass('active');
            }

            /* 点击事件 */
            $defaultFilterList.find('li').click(function () {
                var $this = $(this);

                $('#allClass').find('li.active').removeClass("active");
                $this.addClass("active");

                //清空查询条件
                $('#clearBtn').click();

                getTableData.fromServer({
                    page: 1,
                    rows: 10,
                    conditionId: $this.attr('data-condition-id')
                }, '<%=request.getContextPath()%>/queryWorkCondition/queryByConditionId');


                var title = $(this).attr('data-title');
                $("#right-part-title").text(title);
                // 隐藏Iframe
                $("#rightIframe").hide();
                // 显示表格框
                $("#rightDiv").show();
            });
        }
    })();

    /**
     * @desc 刷新左侧自定义筛选器列表
     */
    var refreshCustomFilterList = (function () {
        var conditionTemp = Handlebars.compile($("#filter-list").html());

        // 默认前几个筛选器
        var $customFilterList = $("#customFilterList");
        // 更多筛选器
        var $moreFilterList = $('#moreFilterList');

        return function (data, isMore) {
            var listData = {
                filterList: data.rows
            };

            // 判断需要刷新的筛选器列表
            var $ui = (isMore === '1' ? $moreFilterList : $customFilterList);

            var $li = $(conditionTemp(listData));
            // 当前选中的标题
            var title = $ui.find('li.active').attr('data-title');
            // 要被标记为active的菜单项
            var $toBeActive = null;

            $ui.empty().append($li);

            if($('#allClass').find('li.active').length === 0) { // 如果active选项不存在
                if(title != null) {
                    $toBeActive = $ui.find('li[data-title="' + title + '"]');
                } else {
                    $toBeActive = $ui.find('li:eq(0)');
                }

                $toBeActive.addClass('active');
            }

            /* 点击事件 */
            $ui.find('li').click(function () {
                var $this = $(this);

                $('#allClass').find('li.active').removeClass("active");
                $this.addClass("active");

                //清空查询条件
                $('#clearBtn').click();

                getTableData.fromServer({
                    page: 1,
                    rows: 10,
                    conditionId: $this.attr('data-condition-id')
                }, '<%=request.getContextPath()%>/queryWorkCondition/queryByConditionId');


                var title = $(this).attr('data-title');
                $("#right-part-title").text(title);
                // 隐藏Iframe
                $("#rightIframe").hide();
                // 显示表格框
                $("#rightDiv").show();
                $("#right-part").find('.part-header .dropdown').css('display', 'inline-block');
            });
        }
    })();

    /**
     * 向后台请求数据
     */
    var getTableData = (function () {
        var paramCache = {};
        var urlCache = '';
        // 表格数据
        var objectListCache = null;
        // 筛选器条件
        var filterConditionCache = {};

        /**
         * 初始化分页
         */
        var pager = new cri.Pager($("#pagination"), {
            page: 1,
            pageSize: 10,
            total: 0,
            onPage: function (page, pageSize) {
                $.extend(paramCache, {page: page, rows: pageSize});
                fromServer(paramCache, urlCache);
            }
        });

        /**
         * @desc 自定义字段初始化
         */
        function customizeFieldInit(conditionData) {
            // 字段
            var $field = null;
            // 字段值
            var value = null;
            // 确保字段唯一
            var PCAKeys = {};
            var tmpPCA = '';
            var pcaField = '';

            for(var fieldKey in conditionData) {
                if(conditionData.hasOwnProperty(fieldKey)) {
                    $field = $('#' + fieldKey);
                    value = conditionData[fieldKey];

                    // 如果值是me，就修改为当前登录账号id
                    if(value === 'me') {
                        value = '${userId}';

                        if(fieldKey === 'customServiceId') { // 归属客服为我时
                            // 增加一条option并选中
                            $('#Work_customServiceId').append('<option value="' + value + '">' + '${userName}' + '</option>');
                        }
                    }

                    if($field.attr('data-type') === "date") { // 如果是时间控件
                        $field.val(cri.formatDate(new Date(+value), 'yyyy-MM-dd hh:mm:ss'));
                    } else if(fieldKey.split('_')[1] != null) { // 省市区
                        pcaField = fieldKey.split('_')[1];
                        tmpPCA = fieldKey.split('_')[0];
                        if(PCAKeys[pcaField] == null) {
                            PCAKeys[pcaField] = [];
                        }

                        if(tmpPCA === 'province') { // 省
                            PCAKeys[pcaField][0] = value;
                        } else if(tmpPCA === 'city') { // 市
                            PCAKeys[pcaField][1] = value;
                        } else if(tmpPCA === 'area') { // 区
                            PCAKeys[pcaField][2] = value;
                        }
                    } else if(fieldKey === 'serviceGroupId' || fieldKey === 'customServiceId' || fieldKey === 'creatorId') {
                        $field = $('#Work_' + fieldKey);

                        // 如果归属客服组option创建完毕
                        if($field.children('option').length > 2) {
                            $field.val(value).change();
                        } else {
                            $field.data('val', value);
                        }
                    } else {
                        $field.val(value);
                    }
                }
            }
            // 省市区初始化
            for(var key in PCAKeys) {
                pcasInit('Work', key.toString(), PCAKeys[key]);
            }
        }

        // 选取选中行的数据
        function getSelected() {
            var data = [];
            $("#orderGrid").find('tbody input[type=checkbox]:checked').each(function () {
                var index = parseInt($(this).closest("tr").data("row"));
                data.push(objectListCache[index]);
            });

            return data;
        }

        // 设置表格
        function setTable(objectList) {
            $("#toolbar").removeClass("show");
            // 关闭全选按钮勾选状态
            $('#allSelect').prop('checked', false);
            // 隐藏导出错误信息
            $('#exportTips').hide();

            if (objectList) {
                createTable(objectList);
            }
        }

        // 从服务器获取数据
        function fromServer(param, url) {
            urlCache = url;
            $.ajax({
                url: urlCache,
                dataType: 'json',
                data: param,
                type: 'post',
                success: function (data) {
                    if (!data.success) {
                        notice.alert(data.msg);
                        return;
                    }

                    // 而queryByConditionId请求返回的表格数据是在data.rows.orderList里面(@杜梦)
                    // 而queryByPageCondition请求返回的表格数据是在data.rows里面(@杜梦)
                    // @leatest Lesty 2016.11.22
                    objectListCache = data.rows.orderList || data.rows;

                    setTable(objectListCache);

                    if(urlCache.indexOf('queryByConditionId') !== -1) {
                        $('#allClass').find('li.active span.num').text(data.total);
                    }

                    // 如果存在筛选器查询条件，初始化自定义字段
                    if(data.rows.query) {
                        // 保存
                        filterConditionCache = JSON.parse(data.rows.query);
                        // 设置模板值
                        $('#tempId').val(filterConditionCache.tempId);
                        if(filterConditionCache.tempId === '-1') {
                            customizeFieldInit(filterConditionCache);
                        } else {
                            // 手动生成自定义字段并赋值
                            getCustomizeFieldListData({
                                tempId: filterConditionCache.tempId
                            }, function() {
                                customizeFieldInit(filterConditionCache);
                            });
                        }
                    }

                    paramCache = param;
                    pager.update(param.page, param.rows, data.total);
                }
            });
        }

        return {
            fromServer: fromServer,
            getSelected: getSelected
        };
    })();

    /**
     * 刷新表格
     */
    var createTable = (function () {
        var trTemp = Handlebars.compile($("#table-tr-template").html());
        var tooltipTemp = Handlebars.compile($("#tooltip-template").html());
        var $table = $("#orderGrid");
        // 工单状态按0-5排列
        var wfStatus = ["尚未受理", "受理中", "等待客户回复", "已解决", "已关闭", "待回访"];
        // 工单状态对应样式按0-5排列
        var statusClassMap = ['orange', 'red', 'blue', 'green', 'black', 'red'];
		
        return function (tableData) {
            var html = [];
            var tempData = null;
            // 提示元素
            var $tip = null;
            // 一行表单元素
            var $tr = null;
            // 工单标题
            var $orderTitle = null;
            // 数据总数
            var dataCount = tableData.length;

            for (var i = 0, len = tableData.length; i < len; i++) {
                tempData = tableData[i];
                // 根据工单状态转换为相应文字并设置样式
                if ((tempData.status != null) && (0 <= tempData.status)) {
                    tempData.statusStr = wfStatus[tempData.status];
                    tempData.statusClass = statusClassMap[tempData.status];
                } else {
                    tempData.statusStr = "-";
                    tempData.statusClass = 'red';
                }

                $tr = $(trTemp(tempData));
                // 存入行数
                $tr.data("row", i);
                // 获取工单标题对象
                $orderTitle = $tr.find("a");
                // 获取提示元素模板
                $tip = $(tooltipTemp(tempData));

                $orderTitle.data("data", tempData).tooltipster({
                    content: $tip,
                    theme: 'tooltipster-shadow'
                });

                html.push($tr);
            }
            $table.find("tbody").empty().append(html);

            // 根据数据数量控制全选按钮展示
            if (dataCount <= 0) {
                $("#allSelect").css("display", "none");
            } else {
                $("#allSelect").css("display", "block");
            }
        };
    })();

    /*
     * @desc 所有默认字段格式检测
     * @return true:格式正确 false:格式错误
     * */
    function allDefaultFieldCheck() {
        /* 工单电话校验 */
        var workPhone = $("#workPhone").val().trim();
        if (workPhone != "") {
            if (!Tools.phoneCheck(workPhone)) {
                notice.warning('工单电话格式不正确！');
                return false;
            }
        }

        var orderCreateFromStr = $("#orderCreateFrom").val();
        var orderCreateToStr = $("#orderCreateTo").val();

        var orderOverFromStr = $("#orderOverFrom").val();
        var orderOverToStr = $("#orderOverTo").val();

        try {
            orderCreateFromStr = new Date(orderCreateFromStr).getTime();
            orderCreateToStr = new Date(orderCreateToStr).getTime();

            orderOverFromStr = new Date(orderOverFromStr).getTime();
            orderOverToStr = new Date(orderOverToStr).getTime();
        } catch (e) {
            notice.warning("时间格式不正确-。-");
            return false;
        }
        if (orderCreateFromStr > orderCreateToStr) {
            notice.warning("工单创建时间:起始与截止时间范围不正确-。-");
            return false;
        }

        if (orderOverFromStr > orderOverToStr) {
            notice.warning("工单结束时间:起始与截止时间范围不正确-。-");
            return false;
        }

        return true;
    }

    /*
     * @desc 自定义字段格式检测
     * @value String [字段的值]
     * @reg String [对应的正则表达式]
     * @return true:格式正确 false:格式错误
     * */
    function customizeFieldCheck(value, reg) {
        if(reg != null) {
            // 正则
            var regular = new RegExp(reg);
            return regular.test(value);
        } else {
            return true;
        }
    }

    /*
     * @desc 所有自定义字段格式检测
     * @return true:格式正确 false:格式错误
     * */
    function allCustomizeFieldCheck() {
        // 需要正则验证的自定义字段(日期除外)
        var $regFieldList = $('#userFieldUl input[data-reg]').not('[data-type=datetimepicker]');
        // 一个字段
        var $regField = null;
        var value = '';
        var reg = null;
        var label = '';

        // 遍历正则字段
        for(var i = 0, len = $regFieldList.length; i < len; i++) {
            // 获取当前字段
            $regField = $($regFieldList[i]);
            // 取值
            value = $regField.val().trim();
            reg = $regField.data('reg');
            // 字段不匹配正则，则提示错误并return
            if(value !== '' && customizeFieldCheck(value, reg) === false) {
                label = $regField.data('label');
                notice.warning(label + ' 格式不正确！');
                return false;
            }
        }

        return true;
    }

    // 保存新的筛选器
    function saveNewFilter(event) {
        // 阻止刷新页面
        event.preventDefault();

        var title = $('#filterName').val().trim();
        var sendData = {
            title: title
        };

        // 设置特殊参数
        var param = $("#queryList").formValue();
        param.orderCreateFrom = $("#orderCreateFrom").val() === '' ? '' : +new Date($("#orderCreateFrom").val()) + '';
        param.orderCreateTo = $("#orderCreateTo").val() === '' ? '' : +new Date($("#orderCreateTo").val())+'';
        param.orderOverFrom = $("#orderOverFrom").val() === '' ? '' : +new Date($("#orderOverFrom").val())+'';
        param.orderOverTo = $("#orderOverTo").val() === '' ? '' : +new Date($("#orderOverTo").val())+'';

        // 生成多选下拉框对象
        var statusSelect = new MultipleSelect('status');
        // 拼接特定形式
        param.status = {
            '$in': statusSelect.get()
        };

        // 去除查询条件的首位空格
        for(var p in param) {
            if(param.hasOwnProperty(p) && typeof param[p] === 'string') {
                param[p] = param[p].trim();
            }
        }

        // 增加属性
        sendData.queryJson = JSON.stringify(param);

        // 验证通过，保存按钮不可点击(待请求完成后可点击)
        var $saveFilterBtn = $('#saveFilterBtn');
        $saveFilterBtn.prop('disabled', true);

        var url = '<%=request.getContextPath()%>/queryWorkCondition/addCondition';
        $.post(url, sendData, function(data) {
            var $title = $('#filterName');
            if(data.success) {
                notice.success("工单筛选器 [" + title + "] 保存成功！");
                $('#saveFilterModal').modal('hide');
                // 清空标题栏
                $title.val('');

                // 刷新筛选器列表
                if($('#moreFilterList').children('li').length > 0) { // 刷新more部分自定义筛选器
                    createFilterList(false, '0', '1');
                } else {
                    createFilterList(false, '0', '0', function(data) { // 刷新默认部分自定义筛选器
                        var $showMore = $('#showMore');
                        if(data.total > 5) {
                            $showMore.show();
                        } else {
                            $showMore.hide();
                        }
                    });
                }
            } else {
                notice.danger(data.msg);
                // 聚焦
                $title.focus();
            }

            // 按钮可点击
            $saveFilterBtn.prop('disabled', false);
        });
    }

    function goDelete(idStr) {
        var param = {};
        param.deleteId = idStr;
        $.ajax({
            url: "http://<%=request.getServerName()%>:" + parent.workBasePath + "/queryWorkOrderInfo/deleteWorkOrder?sessionKey=" + $.cookie("sessionKey"),
            dataType: 'jsonp',
            data: param,
            success: function (data) {
                if (data.success) {
                    notice.alert("工单数据删除成功！", "alert-success");
                    $("#allClass > .left-content-panel-header > a:eq(0)").click();
                } else {
                    notice.alert("工单数据删除失败！", "alert-danger");
                }
            }
        });
    }

    /**进入批量导入工单界面 */
    function goImport() {
        $('#rightDiv').hide();
        // 取消所有勾选项并隐藏工具栏
        $("#orderGrid").find("input[type=checkbox]").prop("checked", false);
        $("#toolbar").removeClass("show");
        $("#rightIframe").show().attr('src', '<%=request.getContextPath()%>/userImport/workOrderIndex');
    }

    /**
     * @desc 多选下拉框对象
     * @author Lesty
     */
    function MultipleSelect(id, valueArr) {
        this.id = id;
        this.$ele = $('#' + id);

        if(valueArr) {
            this.set(valueArr);
        }
    }

    MultipleSelect.prototype.set = function(valueArr) {
        valueArr = Array.isArray(valueArr) ? valueArr : [];

        this.$ele.val(valueArr);
    };

    MultipleSelect.prototype.get = function() {
        var valueArr = [];
        this.$ele.children('option:selected').each(function() {
            valueArr.push(this.value);
        });

        return valueArr;
    };

    /*
    * @desc 事件注册
    * */
    function regEvent() {
        var $orderGrid = $('#orderGrid');

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
        
        // 模板改变时，获取相应自定义字段
        $('#tempId').on('change', function() {
            var tempId = this.value;
            if(tempId == null) {
                notice.danger('模板id获取失败-。-');
                return;
            }
            if(tempId !== '-1') {
                getCustomizeFieldListData({tempId: tempId});
            } else {
                $('#userFieldUl').empty();
            }
        });

        // 刷新默认筛选器
        $('#refreshDefaultBtn').on('click', function() {
            createFilterList(false, '1');
        });

        // 刷新自定义筛选器
        $('#refreshCustomBtn').on('click', function() {
            var $lis = $('#moreFilterList').children('li');

            // 自定义筛选器前5个
            createFilterList(false, '0', '0', function(data) {
                var $showMore = $('#showMore');
                if(data.total > 5 && $lis.length < 1) {
                    $showMore.show();
                } else {
                    $showMore.hide();
                }
            });

            if($lis.length > 0) { // 如果moreFilterList存在筛选器
                createFilterList(false, '0', '1');
            }
        });

        // 自定义筛选器列表展开/收起按钮
        $('#customFilterToggleBtn').on('click', function() {
            var $this = $(this);
            var toggleText = '';

            $('#allCFList').slideToggle();

            if($this.text() === '展开') {
                toggleText = '收起';
            } else {
                toggleText = '展开';
            }

            $this.text(toggleText);
        });

        // 管理筛选器事件
        $('#toWorkFilter').on('click', function(event) {
            event.preventDefault();

            top.openTab('<%=request.getContextPath()%>/queryWorkCondition/getIndex', null, '工单筛选器管理', true);
        });

        // 加载更多
        $('#showMore').children('a.btn').on('click', function(event) {
            event.preventDefault();

            // 获取后半部分筛选器列表
            createFilterList(false, '0', '1');

            // 隐藏加载更多按钮
            $('#showMore').hide();
        });

        // 改变受理客服组
        $('#Work_serviceGroupId').on('change', function() {
            var $customServiceId = $('#Work_customServiceId');
            // 获取相应客服组下的客服列表
            var data = SERVICE_NAME_G[this.value] || [];
            var member = null;
            var optionsHtml = '<option value="">-- 选择受理人 --</option><option value="_blank_">-- 值为空 --</option>';
            for(var i = 0, len = data.length; i < len; i++) {
                member = data[i];
                // 增加options选项
                optionsHtml += '<option value="' + member.userId + '">' + member.userName +'</option>';
            }

            $customServiceId.html(optionsHtml);
            if($customServiceId.data('val') != null) {
                $customServiceId.val($customServiceId.data('val')).change();
                $customServiceId.data('val', null);

                if($customServiceId.val() == null) {
                    $customServiceId.prop('selectedIndex', 0);
                }
            }
        });

        // 监听表单checkbox改变事件(事件委托)
        $orderGrid.on('change', 'input[type=checkbox]', function () {
            // 总共条数
            var allCount = $orderGrid.find('tbody tr').length;
            // 选中的条数
            var checkedCount = 0;

            // 获取当前checkbox的父元素
            var $t = $(this).parent();
            // 如果是全选按钮，将全部checkbox的勾选状态设为和全选按钮一致
            if ($t.is("th")) {
                $orderGrid.find("tbody input[type=checkbox]").prop("checked", $(this).prop("checked"));
            }

            // 需要等到全选按钮设置完后进行取值
            checkedCount = $orderGrid.find('tbody input[type=checkbox]:checked').length;

            // 如果不是全选按钮
            if (!$t.is("th")) {
                $("#allSelect").prop("checked", allCount === checkedCount);
            }

            if (checkedCount) {
                $("#editBtn").text("编辑 " + checkedCount + " 个工单");
                $("#toolbar").addClass("show");
            } else {
                $("#toolbar").removeClass("show");
            }
        });

        // table工单标题点击事件
        $orderGrid.on('click', 'a.tooltipstered', function() {
            var data = $(this).data("data");
            var url = "<%=request.getContextPath()%>/order/detail?workId=" + data.workId;
            var title = "#" + data.workId + "-" + data.title;

            parent.openTab(url, "order", title, false);
        });

        //添加删除按钮事件
        $("#deleteBtn").click(function () {
            var data = getTableData.getSelected();
            var idStr = [];
            for (var i = 0; i < data.length; i++) {
                idStr.push(data[i].workId)
            }
            $("#toolbar").removeClass("show");
            //提交删除参数
            idStr = idStr.join(",");
            if (confirm("确定要删除选中的工单！")) {
                goDelete(idStr);
            }
        });

        //添加清空按钮事件
        $("#cancelBtn").click(function () {
            $("input[type=checkbox]").prop("checked", false);
            $("#toolbar").removeClass("show");
        });

        // 查询条件展开或收起事件
        $("#toggleBtn").on('click', function (event) {
            // 阻止a标签默认跳转
            event.preventDefault();
            var $my = $(this);
            if ($my.hasClass('to-click')) {
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

        // 清空所有选项
        $('#clearBtn').on('click', function (event) {
            // 阻止a标签默认跳转
            event.preventDefault();
            // 清空查询条件
            searchData = {};
            // 清空所有控件内容
            var $queryList = $('#queryList');
            $queryList.find('input, textarea').val('');
            $queryList.find('select').prop('selectedIndex', 0);
            $('#tempId').change();
            $('#Work_serviceGroupId').change();
        });

        // 导出查询结果
        $('#exportBtn').on('click', function (event) {
            // 阻止a标签默认跳转
            event.preventDefault();

            var conditionId = $("#allClass").find("li.active").attr("data-condition-id");
            // 对象为空，转为空字符串
            if($.isEmptyObject(searchData)) {
                searchData = '';
            }

            $.ajax({
                url: "http://<%=request.getServerName()%>:" + parent.workBasePath + "/reportWork/exportWfList?sessionKey=" + $.cookie("sessionKey"),
                type: "post",
                dataType: "jsonp",
                data: {
                    param: searchData,
                    condition: conditionId,
                    entId: '${entId}'
                },
                success: function (data) {
                    if (data.success) {
                        // 隐藏导出错误信息
                        $('#exportTips').hide();
                        var downloadUrl = "http://<%=request.getServerName()%>:" + parent.workBasePath + data.rows.fileUrl;
                        window.location.href = downloadUrl;

                        // 将文件标记为下载成功
                        $.post('<%=request.getContextPath()%>/reportWork/updateExportStatus', {
                            status: '3',
                            fileUrl: data.rows.fileUrl
                        });
                    } else {
                        notice.danger(data.msg);
                    }
                },
                error: function(xhr, status) {
                    if(status === 'timeout') {
                        $('#exportTips').show();
                    }
                }
            });


        });

        // 查询事件
        $('#queryBtn').on('click', function (event) {
            // 阻止a标签默认跳转
            event.preventDefault();

            // 所有默认字段格式检测
            // 所有自定义字段格式检测
            if(!allDefaultFieldCheck() || !allCustomizeFieldCheck()) {
                return false;
            }

            // 设置特殊参数
            var param = $("#queryList").formValue();
            param.orderCreateFrom = $("#orderCreateFrom").val() === '' ? '' : +new Date($("#orderCreateFrom").val()) + '';
            param.orderCreateTo = $("#orderCreateTo").val() === '' ? '' : +new Date($("#orderCreateTo").val())+'';
            param.orderOverFrom = $("#orderOverFrom").val() === '' ? '' : +new Date($("#orderOverFrom").val())+'';
            param.orderOverTo = $("#orderOverTo").val() === '' ? '' : +new Date($("#orderOverTo").val())+'';

            // 生成多选下拉框对象
            var statusSelect = new MultipleSelect('status');
            // 拼接特定形式
            param.status = {
                '$in': statusSelect.get()
            };

            // 去除查询条件的首位空格
            for(var p in param) {
                if(param.hasOwnProperty(p) && typeof param[p] === 'string') {
                    param[p] = param[p].trim();
                }
            }

            searchData = JSON.stringify(param);

            getTableData.fromServer({
                page: 1,
                rows: 10,
                queryJson: searchData
            }, '<%=request.getContextPath()%>/queryWorkCondition/queryByPageCondition');
        });

        // 弹出另存为筛选器的modal
        $('#saveAsFilter').on('click', function() {
            // 所有默认字段格式检测
            // 所有自定义字段格式检测
            if(!allDefaultFieldCheck() || !allCustomizeFieldCheck()) {
                return false;
            }

            $('#saveFilterModal').modal('show');
            // 确保focus生效
            setTimeout(function() {
                $('#filterName').focus();
            }, 400);
        });

        // 保存新的筛选器
        $('#saveFilterBtn').on('click', saveNewFilter);

        $('#exportTips').children('a').on('click', function(event) {
            event.preventDefault();
            top.openTab("<%=request.getContextPath()%>/attachments/index?target=exportOrderTab", null, '附件管理', true);
        });
    }

</script>
</body>
</html>