<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
 <%@page import="java.util.*"%>
 <%@page import = "com.channelsoft.ems.field.po.UserDefinedFiedPo" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html >
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>客户管理</title>
    <%@include file="/views/include/pageHeader.jsp"%>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/static/css/order.css">
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/static/css/innerFrame.css">
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/static/css/index.css">
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/script/lib/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.css">

    <script src="<%=request.getContextPath()%>/script/lib/PCASClass.js"></script>

    <script src="<%=request.getContextPath()%>/script/lib/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
    <script src="<%=request.getContextPath()%>/script/lib/bootstrap-datetimepicker-master/js/locales/bootstrap-datetimepicker.zh-CN.js"></script>

    <script src="<%=request.getContextPath()%>/script/lib/summernote/summernote.js"></script>
    <script src="<%=request.getContextPath()%>/script/lib/summernote/summernote-zh-CN.js"></script>
</head>
<body>
<!--左侧导航栏  -->
<div id="left-part">
    <div class="main-contain">
        <header class="part-header">
            <div class="sidebar">客户管理
                <a data-toggle="modal" class="operation-link" data-target="#addUserModal" onclick="toAddUserModal();" id="addCustomBtn" style="display: none;">+客户</a>
                <a data-toggle="modal" class="operation-link" onclick="goImport();" id="batchImport" style="display: none;">批量导入</a>
            </div>
        </header>
        <div class="left-content">
            <div class="left-content-panel" id="allClass">
                <div class="left-content-panel-header">
                    系统筛选器
                    <a href="javascript:void(0);" id="refreshDefaultBtn">刷新</a>
                </div>
                <ul class="left-content-panel-body left-part-list" id="defaultFilterList"></ul>

                <div class="left-content-panel-header">
                    自定义筛选器
                    <a href="javascript:void(0);" id="customFilterToggleBtn">收起</a>
                    <a href="javascript:void(0);" id="refreshCustomBtn">刷新</a>
                    <a href="javascript:void(0);" id="toCustomerFilter" style="display: none;">管理筛选器</a>
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
        <div class="dropdown">
            <button class="btn btn-default dropdown-toggle" type="button" id="dropdownMenu1" data-toggle="dropdown" aria-haspopup="true" aria-expanded="true" style="border: 1px solid #eee;">
                自定义列<span class="caret"></span>
            </button>
            <ul class="dropdown-menu dropdown-menu-right" aria-labelledby="dropdownMenu1" id="dropdown1Select">
				<c:forEach items="${activeFieldLists}" var="item">
					<c:choose>
						<c:when test="${item.isCheck}">
							<li><label><input type="checkbox" value="${item.key}" name="checkbox" checked="checked">${item.name}</label></li>
						</c:when>
						<c:otherwise>
							<li><label><input type="checkbox" value="${item.key}" name="checkbox">${item.name}</label></li>
						</c:otherwise>
					</c:choose>
				</c:forEach>
            </ul>
        </div>
    </header>

    <div class="right-content">
        <iframe name="iframe" id="rightIframe" style="display:none" width="100%" height="100%" src="" frameborder="0" data-id="index_v1.html" seamless></iframe>
        <div class="container-fluid"  id="rightDiv">
            <div class="row">
                <div class="col-sm-12">
                    <div class="query-condition" id="queryCondition" style="height: 56px;">
                        <div class="col-sm-9">
                            <div class="row">
                                <div class="form-horizontal" id="queryList">
                                    <div class="col-sm-4">
                                        <div class="form-group">
                                            <label for="telPhone" class="control-label col-sm-4">电话：</label>
                                            <div class="col-sm-8">
                                                <input id="telPhone" type="text" name="telPhone" class="form-control">
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-sm-4">
                                        <div class="form-group">
                                            <label for="email" class="control-label col-sm-4">邮箱：</label>
                                            <div class="col-sm-8">
                                                <input id="email" type="email" name="email" class="form-control">
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-sm-4">
                                        <div class="form-group">
                                            <label for="loginName" class="control-label col-sm-4">登陆账号：</label>
                                            <div class="col-sm-8">
                                                <input id="loginName" type="text" name="loginName" class="form-control">
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-sm-4">
                                        <div class="form-group">
                                            <label for="Custom_serviceGroupId" class="control-label col-sm-4">归属组：</label>
                                            <div class="col-sm-8">
                                                <select id="Custom_serviceGroupId" name="serviceGroupId" class="form-control">
                                                    <option value="">-- 选择归属组 --</option>
                                                    <option value="_blank_">-- 值为空 --</option>
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-sm-4">
                                        <div class="form-group">
                                            <label for="Custom_serviceId" class="control-label col-sm-4">归属人：</label>
                                            <div class="col-sm-8">
                                                <select id="Custom_serviceId" name="serviceId" class="form-control">
                                                    <option value="">-- 选择归属人 --</option>
                                                    <option value="_blank_">-- 值为空 --</option>
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-sm-4">
                                        <div class="form-group">
                                            <label for="Custom_creatorId" class="control-label col-sm-4">创建人：</label>
                                            <div class="col-sm-8">
                                                <select id="Custom_creatorId" name="creatorId" class="form-control">
                                                    <option value="">-- 选择创建人 --</option>
                                                    <option value="_blank_">-- 值为空 --</option>
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-sm-4">
                                        <div class="form-group">
                                            <label for="userStatus" class="control-label col-sm-4">客户状态：</label>
                                            <div class="col-sm-8">
                                                <select class="form-control" id="userStatus" name="userStatus">
                                                    <option value="-1" selected>所有状态</option>
                                                    <option value="1">正常</option>
                                                    <option value="3">未审核</option>
                                                    <option value="4">停用</option>
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-sm-4">
                                        <div class="form-group">
                                            <label for="userName" class="control-label col-sm-4">客户姓名：</label>
                                            <div class="col-sm-8">
                                                <input id="userName" type="text" name="userName" class="form-control">
                                            </div>
                                        </div>
                                    </div>
                                    <!-- 分隔符 -->
                                    <span class="col-sm-12" style="height: 0;"></span>
                                    <div class="col-sm-6">
                                        <input id="createTime1" type="text" name="createTime1" data-type="date" data-label="客户创建时间：">
                                    </div>
                                    <div class="col-sm-6">
                                        <input id="createTime2" type="text" name="createTime2" data-type="date" data-label="至：">
                                    </div>
                                    <div class="col-sm-6">
                                        <input id="latestCntTimeFrom" type="text" name="latestCntTimeFrom" data-type="date" data-label="最近联络时间：">
                                    </div>
                                    <div class="col-sm-6">
                                        <input id="latestCntTimeTo" type="text" name="latestCntTimeTo" data-type="date" data-label="至：">
                                    </div>
                                    <div class="col-sm-6">
                                        <input id="updateTimeFrom" type="text" name="updateTimeFrom" data-type="date" data-label="最近更新时间：">
                                    </div>
                                    <div class="col-sm-6">
                                        <input id="updateTimeTo" type="text" name="updateTimeTo" data-type="date" data-label="至：">
                                    </div>
                                    <div id="customUserFieldUl"></div>
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
                                    <a href="javascript:void(0);" class="btn btn-xs btn-raised" id="cleanBtn" style="margin-right: 10px;">清空</a>
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
                            <table class="table" cellspacing="0" cellpadding="0" id="orderGrid">
                                <thead>
                                <tr class="order" id="userTableTr">
                                    <th><input type="checkbox" id="allSelect"></th>
                                    <th>头像</th>
                                    <th>客户姓名</th>
                                    <th>邮箱</th>
                                    <th>手机</th>
                                    <th>创建时间</th>
                                    <th>最后登录</th>
                                </tr>
                                </thead>
                                <tbody></tbody>
                                <tfoot>
                                <tr>
                                    <td colspan="30" >
                                        <div id="pagination">
                                            <a href="javascript:void(0)" class="btn btn-sm btn-raised btn-primary fl" id="export" style="margin-top: 23px;display: none;">导出结果</a>
                                        </div>
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
        <button id="deleteBtn" type="button" class="btn btn-raised left-btn btn-danger" style="display: none;">删除</button>
        <button type="button" class="btn btn-raised btn-default btn-dark" onclick="cancel()">取消</button>
        <button id="massBtn" type="button" class="btn btn-raised btn-info" data-toggle="modal" data-target="#massSMSModal">发送短信</button>
        <button id="editBtn" type="button" class="btn btn-raised btn-primary" data-toggle="modal" data-target="#editUserModal" style="display: none;">编辑客户</button>
    </div>
</div>

<!-- 删除客户 -->
<div id="deleteUserModal" class="modal fade bs-example-modal-sm" data-backdrop="static">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <span class="modal-title">删除客户</span>
            </div>
            <div class="modal-body">
                <div class="container-fluid">
                    <div class="row">
                        <div class="col-sm-10 col-sm-offset-1">
                            <form class="form-horizontal" onsubmit="return false;">
                                <div class="form-group">
                                    <span>注意 </span>
                                </div>
                                <div class="form-group" id="delSingleUser">
                                    <p>
                                        是否确认删除客户
                                        <span class="green" id="delUser"></span>
                                        ？删除后，跟此客户
                                        <span class="red">相关工单</span>
                                        和
                                        <span class="red">文档</span>
                                        会被一起删除，且
                                        <span class="red">无法恢复</span>
                                        ，请慎重操作！
                                    </p>
                                </div>

                                <div class="form-group" id="delMultipleUser" style="display:none">
                                    <p>
                                        是否确认删除
                                        <span class="red" id="userNum"></span>
                                        个客户 ？删除后，跟此客户
                                        <span class="red">相关工单</span>
                                        和
                                        <span class="red">文档</span>
                                        会被一起删除，且
                                        <span class="red">无法恢复</span>
                                        ，请慎重操作！
                                    </p>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-raised btn-primary btn-sm" onclick="deleteUserSubmit()" id="deleteUserSubmit">确认删除</button>
                <button type="button" class="btn btn-raised btn-default btn-sm" data-dismiss="modal">取消</button>
            </div>
        </div>
    </div>
</div>

<!-- 发送短信弹窗 -->
<%@include file= "/views/customManager/modal/massSMSModal.jsp"%>

<!-- 编辑客户 -->
<div id="editUserModal" class="modal fade bs-example-modal-sm" data-backdrop="static" style="overflow:auto;">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <span class="modal-title">批量编辑客户</span>
            </div>
            <div class="modal-body">
                <div class="container-fluid">
                    <div class="row">
                        <div class="col-sm-10 col-sm-offset-1">
                            <form class="form-horizontal" onsubmit="return false;">
                                <div class="form-group">
                                    <label for="statusSelect" class="control-label">账号状态 </label>
                                    <select class="form-control" id="statusSelect">
                                        <option value="">不改变</option>
                                        <option value="1">正常</option>
                                        <!-- <option value="2">暂停</option> -->
                                        <option value="3">未审核</option>
                                        <option value="4">停用</option>
                                    </select>
                                </div>
                                <!-- 客户归属客服组 -->
		                        <div class="form-group">
		                            <label class="control-label">归属组：</label>
		                            <div class="">
		                                <input type="text" class="form-control" data-name = "归属组" name="serviceGroupName" id="serviceGroupNameEdit" onfocus="$(this).blur();" onclick="getDataTableServiceGroup(this,false,true);" data-target="#serviceGroupModal" placeholder="请点击选择归属组">
		                            </div>
		                        </div>
		                        <!-- 客户归属客服 -->
		                        <div class="form-group">
		                            <label class="control-label">归属人：</label>
		                            <div class="">
		                                <input type="text" class="form-control" data-name = "归属人" name="serviceName" id="serviceNameEdit" onfocus="$(this).blur();" onclick="getDataTableServiceGroup(this,false,true);" data-backdrop="false" data-target="#serviceGroupModal" placeholder="请点击选择归属人">
		                            </div>
		                        </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-raised btn-default btn-sm" data-dismiss="modal">取消</button>
                <button type="button" class="btn btn-raised btn-primary btn-sm" onclick="editUserSubmit()" id="editUserSubmit">提交</button>
            </div>
        </div>
    </div>
</div>

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
                                    <label for="filterName" class="control-label col-sm-4">客户筛选器名称<span style="color: red">*</span>：</label>
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

<%--添加客户弹出框--%>
<%@include file="/views/addUserModal.jsp"%>

<%-- 客户筛选器列表 --%>
<script id="user-filter-list" type="text/x-handlebars-template">
    {{#each filterList}}
    <li data-title="{{this.condition.title}}" data-condition-id="{{this.condition.conditionId}}">
        <a href="#">{{this.condition.title}}
            <span class="num">{{this.num}}</span>
        </a>
    </li>
    {{/each}}
</script>

<script id="table-tr-template-agent" type="text/x-handlebars-template">
    <tr>
        <td>{{#equal userType '1'}}<input type="checkbox">{{/equal}}</td>
        <td style="display:none">{{userId}}</td>
        <td style="display:none">{{userLabel}}</td>
    </tr>
</script>

<!-- 客户头像模板 -->
<script id="table-tr-template-photo" type="text/x-handlebars-template">
    <td data-prop="photoUrl" class="user">
        <a class="avatar">
           <img src="{{photoUrl}}" onclick="viewDetails('{{userId}}','{{userName}}')">
        </a>
    </td>
</script>

<script  id="table-tr-template-user" type="text/x-handlebars-template">
        <td data-prop="userName" class="user">
            <div class="user-right">
                <a class="name" href="#" onclick="viewDetails('{{userId}}','{{userName}}')">{{userName}}
                    <span class="{{#equal phoneBinded '手机已绑定'}}status blue{{/equal}}">{{phoneBinded}}</span>
                </a>
                <span class="{{#equal userStatus '停用'}}status red{{/equal}}{{#equal userStatus '未审核'}}status orange{{/equal}}">{{userStatus}}</span>                
            </div>
        </td>
</script>

<!-- 1:字符串 -->
<script id="custom-field-comp-1" type="text/x-handlebars-template">
    <div class="col-sm-4">
        <div class="form-group">
            <label class="control-label col-sm-4">{{name}}：</label>
            <div class="col-sm-8">
                <input id="{{key}}" type="text" name="{{key}}" class="form-control" data-label="{{name}}" value="{{ownValue}}">
            </div>
        </div>
    </div>
</script>
<!-- 2:文本框 -->
<script id="custom-field-comp-2" type="text/x-handlebars-template">
    <div class="col-sm-4" data-comp-type="textarea">
        <div class="form-group">
            <label class="control-label col-sm-4">{{name}}：</label>
            <div class="col-sm-8">
                <textarea class="form-control" name="{{key}}" id="{{key}}" rows="4" data-label="{{name}}">{{ownValue}}</textarea>
            </div>
        </div>
    </div>
</script>
<!-- 3:下拉框 -->
<script id="custom-field-comp-3" type="text/x-handlebars-template">
    <div class="col-sm-4">
        <div class="form-group">
            <label class="control-label col-sm-4">{{name}}：</label>
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
<script id="custom-field-comp-4" type="text/x-handlebars-template">

</script>
<!-- 5:未定 -->
<script id="custom-field-comp-5" type="text/x-handlebars-template">
</script>
<!-- 6:数字 -->
<script id="custom-field-comp-6" type="text/x-handlebars-template">
    <div class="col-sm-4">
        <div class="form-group">
            <label class="control-label col-sm-4">{{name}}：</label>
            <div class="col-sm-8">
                <input id="{{key}}" type="text" name="{{key}}" class="form-control" data-reg="^-?\d+$" data-label="{{name}}" value="{{ownValue}}">
            </div>
        </div>
    </div>
</script>
<!-- 7:小数 -->
<script id="custom-field-comp-7" type="text/x-handlebars-template">
    <div class="col-sm-4">
        <div class="form-group">
            <label class="control-label col-sm-4">{{name}}：</label>
            <div class="col-sm-8">
                <input id="{{key}}" type="text" name="{{key}}" class="form-control" data-reg="^-?\d+\.\d+$" data-label="{{name}}" value="{{ownValue}}">
            </div>
        </div>
    </div>
</script>
<!-- 8:正则表达式 -->
<script id="custom-field-comp-8" type="text/x-handlebars-template">
    <div class="col-sm-4">
        <div class="form-group">
            <label class="control-label col-sm-4">{{name}}：</label>
            <div class="col-sm-8">
                <input id="{{key}}" type="text" name="{{key}}" class="form-control" data-reg="{{reg}}" data-label="{{name}}" value="{{ownValue}}">
            </div>
        </div>
    </div>
</script>
<!-- 9:电话号码 -->
<script id="custom-field-comp-9" type="text/x-handlebars-template">
    <div class="col-sm-4">
        <div class="form-group">
            <label class="control-label col-sm-4">{{name}}：</label>
            <div class="col-sm-8">
                <input id="{{key}}" type="text" name="{{key}}" class="form-control" data-reg="{{reg}}" data-label="{{name}}" value="{{ownValue}}">
            </div>
        </div>
    </div>
</script>
<!-- 10:时间输入框 -->
<script id="custom-field-comp-10" type="text/x-handlebars-template">
    <%--    <div class="col-sm-6">
            <input id="{{key}}" type="text" name="{{key}}" data-label="{{name}}" data-type="datetimepicker" data-reg="{{reg}}" data-field="{{name}}" data-name="{{key}}" value="{{ownValue}}">
        </div>--%>
</script>
<!-- 11:省市区 -->
<script id="custom-field-comp-11" type="text/x-handlebars-template">
    <div class="col-sm-10">
        <div class="form-group">
            <label class="control-label col-sm-2" style="padding-right: 20px;">{{name}}：</label>

            <div class="col-sm-10">
                <div class="row">
                    <div class="col-sm-4">
                        <span><select class="form-control" data-label="{{name}}" data-field-type="pca" name="province_{{key}}" id="Custom_province{{key}}" style="box-shadow: none;"></select></span>
                    </div>
                    <div class="col-sm-4">
                        <span><select class="form-control" data-field-type="pca" name="city_{{key}}" id="Custom_city{{key}}" style="box-shadow: none;"></select></span>
                    </div>
                    <div class="col-sm-4">
                        <span><select class="form-control" data-field-type="pca" name="area_{{key}}" id="Custom_area{{key}}" style="box-shadow: none;"></select></span>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <input type="hidden" name='Custom{{key}}' id="{{key}}">
</script>

<script src="<%=request.getContextPath()%>/script/lib/PCASClass.js"></script>

<script type="text/javascript">
    //点击查询按钮，保存查询条件
    var searchData = {};
    // 归属客服组下相应的客服名称
    var SERVICE_NAME_G = {};
    // 选中的自定义列的所有字段
    var fieldNames = {};
    <%
    List<UserDefinedFiedPo> ls = (List<UserDefinedFiedPo>)request.getAttribute("activeFieldLists"); 
%>
    $(function () {
    	fieldNames = {};
    	//单独加入头像列
    	fieldNames["photoUrl"] = "头像";
        <%
        for(int i = 0;i  < ls.size(); i ++){
        	 if(ls.get(i).isIsCheck()){
       	 %>
       	fieldNames["<%= ls.get(i).getKey()%>"] = "<%= ls.get(i).getName()%>";
       	 <%}
        }
      %>    

        setUserTable(fieldNames);
        // 初始化默认字段
        defaultFieldInit();

        // 权限菜单按钮控制隐藏或者显示
        permissionControl();

        // 生成自定义字段列表
        getCustomizeFieldListData();

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
        var $customFilter = $('#toCustomerFilter');
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
            'userManageMongo/addUser': $('#addCustomBtn'),
            'userManageMongo/updateBatch': $('#editBtn'),
            'userImport/index': $('#batchImport'),
            'clientReport/exportClients': $('#export'),
            'queryUserCondition/getIndex': CustomerFilter,
            'userManageMongo/deleteUser': $('#deleteBtn')
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
        var $allDates = $("#createTime1, #createTime2, #latestCntTimeFrom, #latestCntTimeTo, #updateTimeFrom, #updateTimeTo");

        // 初始化归属客服组
        serviceGroupInit();
        // 初始化创建人
        creatorInit();

        // 设置控件偏移量
        $allDates.closest('div.col-sm-6').css({
            'margin-left': '-18px'
        });

        $allDates.timeInput({
            format:"yyyy-MM-dd hh:mm:ss",
            HMS:true,
            value: ''
        });

        // 设置控件高度
        $('#queryList').children('div').not('#customUserFieldUl').css({
            height: '48px'
        });
    }

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
                    value = '${user.userId}';

                    if(fieldKey === 'serviceId') { // 归属客服为我时(此时并不知道归属客服组是多少)
                        // 增加一条option并选中
                        $('#Custom_serviceId').append('<option value="' + value + '">' + '${user.userName}' + '</option>');
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
                } else if(fieldKey === 'serviceGroupId' || fieldKey === 'serviceId' || fieldKey === 'creatorId') {
                    $field = $('#Custom_' + fieldKey);

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
            pcasInit('Custom', key.toString(), PCAKeys[key]);
        }
    }

    /**
     * @desc 初始化归属客服组
     */
    function serviceGroupInit() {
        $.post('<%=request.getContextPath()%>/groupMongo/getAgentGroups', {
            rows: -1
        }, function(data) {
            var $serviceGroupId = $('#Custom_serviceGroupId');
            var rows = data.rows;
            var group = null;
            var optionsHtml = '<option value="" selected>-- 选择归属组 --</option><option value="_blank_">-- 值为空 --</option>';
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
            var $creatorId = $('#Custom_creatorId');
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
     * @desc 创建左侧客户筛选器列表
     * @author Lesty
     * @isGetTableData Boolean 是否获取表格数据
     * @isMore String 是否获取更多筛选器，'0': 获取前半部分，'1': 获取后半部分
     */
    function createFilterList(isGetTableData, isDefault, isMore, callback) {
        // 取默认筛选器时，isMore参数为空
        isMore = isDefault === '1' ? '' : isMore;
        $.post("<%=request.getContextPath()%>/queryUserCondition/queryConditionList", {
            isDefault: isDefault,
            isMore: isMore
        }, function(data) {
            var $list = null;

            if(isDefault === '1') { // 获取默认筛选器
                refreshDefaultFilterList(data);
                $list = $('#defaultFilterList');
            } else {
                refreshCustomFilterList(data, isMore);
                $list = $('#allCFList');
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
        return function (param){
            $.ajax({
                url: "<%=request.getContextPath()%>/newuserManage/getUsersFieldList",
                dataType: 'json',
                data: {
                },
                success: function(data) {
                    if(!(data.success)) {
                        notice.danger(data.msg);
                        return;
                    }

                    if(data.rows != null) {
                        createCustomizeFieldList(data.rows);
                    }

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
        var $fieldList = $('#customUserFieldUl');

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
                pcasInit('Custom', PCAKeys[i]);
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
        var fieldTemp = Handlebars.compile($('#custom-field-comp-' + data.componentType).html());
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

    /*
     * @desc 所有默认字段格式检测
     * @return true:格式正确 false:格式错误
     * */
    function allDefaultFieldCheck() {
        /* 邮箱格式校验 */
        var email = $("#email").val().trim();
        if (email != "") {
            if (!Tools.mailCheck(email)) {
                notice.warning("邮箱格式不正确！");
                return false;
            }
        }

        /* 手机格式校验 */
        var telPhone = $("#telPhone").val().trim();
        if (telPhone != "") {
            if (!Tools.phoneCheck(telPhone)) {
                notice.warning('电话格式不正确！');
                return false;
            }
        }

        var customCreateFromStr = $("#createTime1").val();
        var customCreateToStr = $("#createTime2").val();
        var latestCntTimeFromStr = $("#latestCntTimeFrom").val();
        var latestCntTimeToStr = $("#latestCntTimeTo").val();
        var updateTimeFromStr = $("#updateTimeFrom").val();
        var updateTimeToStr = $("#updateTimeTo").val();


        try {
            customCreateFromStr = new Date(customCreateFromStr).getTime();
            customCreateToStr = new Date(customCreateToStr).getTime();
            latestCntTimeFromStr = new Date(latestCntTimeFromStr).getTime();
            latestCntTimeToStr = new Date(latestCntTimeToStr).getTime();
            updateTimeFromStr = new Date(updateTimeFromStr).getTime();
            updateTimeToStr = new Date(updateTimeToStr).getTime();
        } catch (e) {
            notice.warning("时间格式不正确");
            return false;
        }
        if (customCreateFromStr > customCreateToStr) {
            notice.warning("客户创建时间:起始与截止时间范围不正确-。-");
            return false;
        }
        if (latestCntTimeFromStr > latestCntTimeToStr) {
            notice.warning("最近联络时间:起始与截止时间范围不正确-。-");
            return false;
        }
        if (updateTimeFromStr > updateTimeToStr) {
            notice.warning("最近更新时间:起始与截止时间范围不正确-。-");
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
        var $regFieldList = $('#customUserFieldUl input[data-reg]').not('[data-type=datetimepicker]');
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

    /**
     * 客户自定义字段模块
     */
    var userFieldModule = function(){
        var $container = $('#customUserFieldUl');

        var _validator = function(){
            return $container.validator();
        };

        return {
            render:function(){
                var $customUserFieldUl = $('#customUserFieldUl');
                $customUserFieldUl.children('div').not('[data-comp-type=textarea]').css({
                    height: '48px'
                });

                $customUserFieldUl.children('div[data-comp-type=textarea]').css({
                    height: '96px'
                });
            },
            _validator: _validator
        };
    }();

    /**
     * @desc 刷新左侧客户筛选器列表
     */
    var refreshDefaultFilterList = (function () {
        var conditionTemp = Handlebars.compile($("#user-filter-list").html());

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
                $('#cleanBtn').click();

                getTableData.fromServer({
                    page: 1,
                    rows: 10,
                    conditionId: $this.attr('data-condition-id')
                }, '<%=request.getContextPath()%>/queryUserCondition/queryByCondition', 'post');


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
     * @desc 刷新左侧客户筛选器列表
     */
    var refreshCustomFilterList = (function () {
        var conditionTemp = Handlebars.compile($("#user-filter-list").html());

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
                $('#cleanBtn').click();

                getTableData.fromServer({
                    page: 1,
                    rows: 10,
                    conditionId: $this.attr('data-condition-id')
                }, '<%=request.getContextPath()%>/queryUserCondition/queryByCondition', 'post');


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
        var typeCache = '';
        // 缓存表格数据
        var objectListCache = {};

        /**
         * 初始化分页
         */
        var pager = new cri.Pager($("#pagination"), {
            page: 1,
            pageSize: 10,
            total: 0,
            onPage: function (page, pageSize) {
                $.extend(paramCache, {page: page, rows: pageSize});
                fromServer(paramCache, urlCache, typeCache);
            }
        });

        function setTable(objectList) {
            $("#toolbar").removeClass("show");
            // 关闭全选按钮勾选状态
            $('#allSelect').prop('checked', false);

            if (objectList) {
                for (var i = 0, len = objectList.length; i < len; i++) {
                    if (objectList[i].loginTime == null) {
                        objectList[i].loginTime = "未登录";
                    }
                    
                    if (objectList[i].userStatus == "未审核") {
                        objectList[i].userStatus = "3";
                    }else if (objectList[i].userStatus == "停用") {
                        objectList[i].userStatus = "4";
                    }
                }
                createTable(objectList);
            }
        }

        // 从服务器获取数据
        function fromServer(param, url, type) {
            typeCache = type || 'post';
            urlCache = url;
            $.ajax({
                url: urlCache,
                dataType: 'json',
                data: param,
                type: typeCache,
                success: function (data) {
                    if (!data.success) {
                        notice.alert(data.msg);
                        return;
                    }

                    // 缓存数据(请求不同，返回的数据格式也不同)
                    // 而queryByCondition请求返回的表格数据是在data.rows.userList里面(@吉泽老师)
                    // 而queryByPageCondition请求返回的表格数据是在data.rows里面(@吉泽老师)
                    // @leatest Lesty 2016.11.5
                    objectListCache = data.rows.userList || data.rows;

                    if(urlCache.indexOf('queryByCondition') !== -1) {
                        $('#allClass').find('li.active span.num').text(data.total);
                    }
                    setTable(objectListCache);

                    // 如果存在筛选器查询条件，初始化自定义字段
                    if(data.rows.query) {
                        customizeFieldInit(JSON.parse(data.rows.query));
                    }

                    paramCache = param;
                    pager.update(param.page, param.rows, data.total);
                }
            });
        }

        // 从本地缓存获取数据
        function fromLocal() {
            setTable(objectListCache);
        }

        return {
            fromServer: fromServer,
            fromLocal: fromLocal
        };
    })();

    /**
     * 刷新表格
     */
    var createTable = (function () {
        var trTempAgent = Handlebars.compile($("#table-tr-template-agent").html());
        var userTemp = Handlebars.compile($("#table-tr-template-user").html());
        var photoTemp = Handlebars.compile($("#table-tr-template-photo").html());
        
        var $table = $("#orderGrid");

        return function (tableData) {
            var html = [];
            var checkCount = tableData.length;

            for (var i = 0, len = tableData.length; i < len; i++) {
                if (tableData[i].userStatus == "4") {
                    tableData[i].userStatus = "停用";

                } else if (tableData[i].userStatus == "3") {
                    tableData[i].userStatus = '未审核';

                } else {
                    tableData[i].userStatus = "";
                }

                if (tableData[i].phoneBinded == "1") {
                    tableData[i].phoneBinded = "手机已绑定";
                } else {
                    tableData[i].phoneBinded = "";
                }

                var $tr = null;

                $tr = $(trTempAgent(tableData[i]));
                $tr.data("data", tableData[i]);
                var fns = $.extend({}, fieldNames);
/*                 $tr.find("td[data-prop]").each(function () {
                    var $this = $(this);
                    var prop = $this.data("prop");
                    if (!fns[prop]) {
                        $this.hide();
                        fns[prop] = undefined;
                    }
                }); */
                for (var p in fns) {
                    if (fns[p]) {
                    	if(p == "photoUrl")/**客户头像特殊处理**/{
                    		$tr.append($(photoTemp(tableData[i])));
                    	}else if(p == "userName")/**客户字段特殊处理**/{
                    		$tr.append($(userTemp(tableData[i])));
                    	}else{
                            var _t = tableData[i][p] || "";

                            // 如果字段是角色，则显示相应中文
                            if(p === 'userType') {
                                _t = tableData[i].userTypeDesc;
                            }
                            //如果字段是roleId表示具体的角色,用roleName取对应中文名字
                            if(p === 'roleId') {
                                _t = tableData[i].roleName;
                            }
                            $tr.append('<td data-prop="'+p+'">'+_t+'</td>');
                    	}
                    }
                }
                html.push($tr);
            }
            if (checkCount <= 0) {
                $("#allSelect").css("display", "none");
            } else {
                $("#allSelect").css("display", "block");
            }

            $table.find("tbody").empty().append(html);
        };
    })();

    /*
     * @author Lesty
     * @codeDate 2016.8.6
     * @desc 到添加客户modal
     * */
    function toAddUserModal() {
        addUserModal.init();
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
        param.createTime1 = $("#createTime1").val() === '' ? '' : +new Date($("#createTime1").val())+'';
        param.createTime2 = $("#createTime2").val() === '' ? '' : +new Date($("#createTime2").val())+'';
        param.latestCntTimeFrom = $("#latestCntTimeFrom").val() === '' ? '' : +new Date($("#latestCntTimeFrom").val())+'';
        param.latestCntTimeTo = $("#latestCntTimeTo").val() === '' ? '' : +new Date($("#latestCntTimeTo").val())+'';
        param.updateTimeFrom = $("#updateTimeFrom").val() === '' ? '' : +new Date($("#updateTimeFrom").val())+'';
        param.updateTimeTo = $("#updateTimeTo").val() === '' ? '' : +new Date($("#updateTimeTo").val())+'';

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

        var url = '<%=request.getContextPath()%>/queryUserCondition/addCondition';
        $.post(url, sendData, function(data) {
            var $title = $('#filterName');
            if(data.success) {
                notice.success("客户筛选器 [" + title + "] 保存成功！");
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

    /**进入批量导入界面 */
    function goImport() {
        $("#right-part").find('.part-header .dropdown').hide();
        $("#rightDiv").hide();
        // 取消所有勾选项并隐藏工具栏
        $("#orderGrid").find("input[type=checkbox]").prop("checked", false);
        $("#toolbar").removeClass("show");
        $("#rightIframe").show().attr('src', '<%=request.getContextPath()%>/userImport/index');
    }

    /* 查看客户详情 */
    function viewDetails(userId, userName) {
        var url = "<%=request.getContextPath()%>/userManageMongo/userDetails?userId=" + userId + '&t=' + new Date();
        parent.openTab(url, "user", userName, false);
    }

    /* 批量编辑客户 */
    function editUserSubmit() {
        // 包含选中客户ID的数组
        var checkedIdsArr = [];
        // 获取选中客户id集合
        $("#orderGrid").find('td input[type=checkbox]:checked').each(function () {
            var $tr = $(this).closest("tr");
            checkedIdsArr.push($tr.data("data").userId);
        });

        // 用户状态
        var userStatus = $('#statusSelect').val();
        // 参数
        var userInfos = {
            userLabel: '', // 这个东西不清楚什么作用，历史遗留，不发送则后端报错
            userStatus: userStatus,
            entId: '${entId}'
        };
        // 归属人元素
        var $serviceNameEdit = $('#serviceNameEdit');
        // 归属组元素
        var $serviceGroupNameEdit = $('#serviceGroupNameEdit');


        // 如果选择了归属组
        if($serviceGroupNameEdit.val()) {
            userInfos.serviceGroupName = $serviceGroupNameEdit.val();
            userInfos.serviceGroupId = $serviceGroupNameEdit.data('serviceGroupId');

            // 如果选择了归属人
            if ($serviceNameEdit.val()) {
                userInfos.serviceName = $serviceNameEdit.val();
                userInfos.serviceId = $serviceNameEdit.data('serviceId');
            } else { // 不选归属组，则清除(这里做一个临时处理，因为传空到后端，后端不做修改)
                userInfos.serviceName = '';
                userInfos.serviceId = '';
            }
        }

        $.post("<%=request.getContextPath()%>/userManageMongo/updateBatch?ids=" + checkedIdsArr, {userInfos: JSON.stringify(userInfos)}, updateCallBack, 'json');
    }

    /* 批量编辑回调函数 */
    function updateCallBack(data) {
        if (data.success) {
            notice.success("客户更新成功！");
            // 刷新表格数据
            $('#allClass').find('li.active').click();
            // 重置表单
            $('#statusSelect').val('');
            $('#serviceGroupNameEdit').val('');
            $('#serviceNameEdit').val('');
            // 隐藏modal
            $("#editUserModal").modal('hide');
        } else {
            notice.danger(data.msg);
        }
    }
    /* 取消按钮 */
    function cancel() {
        $("#orderGrid input[type=checkbox]").each(function () {
            $(this).attr("checked", false);
        });
        $("#toolbar").removeClass("show");
    }

    function setUserTable(fieldNames) {
        var $tr = $('#userTableTr');
        var appendHtml = '';
        appendHtml += '<th><input type="checkbox" id="allSelect"></th>';
        for (var key in fieldNames) {
            appendHtml += '<th>' + fieldNames[key] + '</th>';
        }
        $tr.empty().append(appendHtml);
        getTableData.fromLocal();
    }

    function getUserStatus(userStatusStr) {
        var userStatus = "";
        if (userStatusStr == "正常") {
            userStatus = "1";
        } else if (userStatusStr == "已停用") {
            userStatus = "4";
        } else if (userStatusStr == "未审核") {
            userStatus = "3";
        } else {
            userStatus = "";
        }
        return userStatus;
    }

    /* 删除普通客户 */
    function deleteUserSubmit() {
        var userIdArr = [];
        $("#orderGrid").find('td input[type=checkbox]:checked').each(function () {
            var trData = $(this).closest("tr").data("data");
            userIdArr.push(trData.userId);
        });

        $.ajax({
            url: "<%=request.getContextPath()%>/userManageMongo/deleteUser?ids=" + userIdArr.join(','),
            type: "post",
            dataType: "json",
            data: {
                entId: "${entId}"
            },
            success: function (data) {
                if (data.success) {
                    /**
                     * 判断当前active是默认筛选器还是自定义筛选器
                     * 如果是自定义，则需要额外判断属于剩余的，还是默认的前几个
                     * @latest Lesty 2016.11.4
                     * */
                    $('#allClass').find('li.active').click();
                    if($('#defaultFilterList').children('li.active').length > 0) { // 如果active选项在默认筛选器中
                        createFilterList(false, '1');
                    } else if($('#customFilterList').children('li.active').length > 0) { // 如果active选项在自定义前几个筛选器中
                        createFilterList(false, '0', '0');
                    } else { // 自定义剩余筛选器中
                        createFilterList(false, '0', '1');
                    }

                    $("#deleteUserModal").modal('hide');
                    notice.success("客户删除成功！");
                } else {
                    notice.danger("删除失败！" + data.msg);
                }
            }
        });
    }

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
        $('#toCustomerFilter').on('click', function(event) {
            event.preventDefault();

            top.openTab('<%=request.getContextPath()%>/queryUserCondition/getIndex', null, '客户筛选器管理', true);
        });

        // 加载更多
        $('#showMore').children('a.btn').on('click', function(event) {
            event.preventDefault();

            // 获取后半部分筛选器列表
            createFilterList(false, '0', '1');

            // 隐藏加载更多按钮
            $('#showMore').hide();
        });

        // 改变归属客服组
        $('#Custom_serviceGroupId').on('change', function() {
            var $serviceId = $('#Custom_serviceId');
            // 获取相应客服组下的客服列表
            var data = SERVICE_NAME_G[this.value] || [];
            var member = null;
            var optionsHtml = '<option value="">-- 选择归属人 --</option><option value="_blank_">-- 值为空 --</option>';
            for(var i = 0, len = data.length; i < len; i++) {
                member = data[i];
                // 增加options选项
                optionsHtml += '<option value="' + member.userId + '">' + member.userName +'</option>';
            }

            $serviceId.html(optionsHtml);
            if($serviceId.data('val') != null) {
                $serviceId.val($serviceId.data('val')).change();
                $serviceId.data('val', null);

                if($serviceId.val() == null) {
                    $serviceId.prop('selectedIndex', 0);
                }
            }
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
            param.createTime1 = $("#createTime1").val() === '' ? '' : +new Date($("#createTime1").val())+'';
            param.createTime2 = $("#createTime2").val() === '' ? '' : +new Date($("#createTime2").val())+'';
            param.latestCntTimeFrom = $("#latestCntTimeFrom").val() === '' ? '' : +new Date($("#latestCntTimeFrom").val())+'';
            param.latestCntTimeTo = $("#latestCntTimeTo").val() === '' ? '' : +new Date($("#latestCntTimeTo").val())+'';
            param.updateTimeFrom = $("#updateTimeFrom").val() === '' ? '' : +new Date($("#updateTimeFrom").val())+'';
            param.updateTimeTo = $("#updateTimeTo").val() === '' ? '' : +new Date($("#updateTimeTo").val())+'';

            // 去除查询条件的首位空格
            for(var p in param) {
                if(param.hasOwnProperty(p) && typeof param[p] === 'string') {
                    param[p] = param[p].trim();
                }
            }

            searchData = JSON.stringify(param);

            getTableData.fromServer({page: 1, rows: 10, queryJson: searchData}, '<%=request.getContextPath()%>/queryUserCondition/queryByPageCondition', 'POST');
        });

        // 另存为筛选器
        $('#saveAsFilter').on('click', function() {
            // 所有默认字段格式检测
            // 所有自定义字段格式检测
            if(!allDefaultFieldCheck() || !allCustomizeFieldCheck()) {
                return false;
            }

            $('#saveFilterModal').modal('show');
            $('#filterName').focus();
        });

        // 保存筛选器
        $('#saveFilterBtn').on('click', saveNewFilter);

        // 清空所有选项
        $('#cleanBtn').on('click', function (event) {
            // 阻止a标签默认跳转
            event.preventDefault();

            var $queryList = $("#queryList");
            // 清空查询条件
            searchData = {};
            // 清空所有控件内容
            $queryList.find('input, textarea').val('');
            $queryList.find('select').prop('selectedIndex', 0);
            $('#Custom_serviceGroupId').change();
        });

        // 导出查询结果
        $('#export').on('click', function (event) {
            // 阻止a标签默认跳转
            event.preventDefault();

            var conditionId = $("#allClass").find('li.active').attr("data-condition-id");
            // 对象为空，转为空字符串
            if($.isEmptyObject(searchData)) {
                searchData = '';
            }

            $.ajax({
                url: "<%=request.getContextPath()%>/clientReport/exportClients?sessionKey=" + $.cookie("sessionKey"),
                type: "post",
                dataType: "json",
                data: {
                    param: searchData,
                    condition: conditionId,
                    entId: '${entId}'
                },
                success: function (data) {
                    if (data.success) {
                        window.location.href = "<%=request.getContextPath()%>" + data.rows;
                    } else {
                        notice.alert("未能导出数据", "alert-danger");
                    }
                }
            });
        });

        // 自定义列选项点击事件
        // 使用事件委托机制，必须委托到checkbox，否则会多次触发(label特性)
        $("#dropdown1Select").on('click', 'input[type=checkbox]', function() {
            var $that = $(this);
            var selectedKey = $that.val(), // 获取操作的key值
            flag = $that.prop("checked"); //获取是选中还是取消选中的标识
            // 更改后端字段表的数据值
            //保存操作
            var url = '<%=request.getContextPath()%>/userField/fieldDistribute';
            var data = {
                key: selectedKey,
                flag: flag,
                pageUrl: "customManage"
            };
            $.ajax({
                url: url,
                type: "post",
                dataType: "json",
                data: data,
                success: function (data) {
                    if (data.success) {
                        //如果客户操作成功，刷新表头及数据
                        var fieldParam = {};
                        $('#dropdown1Select').find('input[type=checkbox]:checked').each(function () {
                            var $this = $(this);                            
                            //单独加入头像列
                            fieldParam["photoUrl"] = "头像";
                            
                            fieldParam[$this.val()] = $this.parent().text();
                        });

                        // 更新缓存字段列表
                        fieldNames = fieldParam;

                        setUserTable(fieldNames);
                        var selectedCount = 0;
                        var allCheckbox = $orderGrid.find('input[type=checkbox]');
                        for(var key in selectedCheckbox) {
                            if (selectedCheckbox.hasOwnProperty(key)) {
                                allCheckbox[key].checked = selectedCheckbox[key];

                                if (key != 0 && selectedCheckbox[key]) {
                                    selectedCount++;
                                }
                            }
                        }
                        if (selectedCount) {
                            $("#editBtn").text("编辑 " + selectedCount + " 个客户");
                            $("#toolbar").addClass("show");
                        } else {
                            $("#toolbar").removeClass("show");
                        }
                        if (selectedCount < allCheckbox.length -1) {
                            allCheckbox[0].checked = false
                        }
                    } else {
                        notice.warning("操作失败!");
                    }
                }
            });
        });

        // 监听表单checkbox改变事件(事件委托)
        var selectedCheckbox = {};
        $orderGrid.on('change', 'input[type=checkbox]', function () {
            /*
            * @des 缓存勾选项的索引
            * */
            var allCheckbox = $orderGrid.find('input[type=checkbox]');
            var thisIndex = allCheckbox.index(this);
            // 全选
            if (thisIndex === 0) {
                for (var iCheckbox = 0, lenCheckbox = allCheckbox.length; iCheckbox < lenCheckbox; iCheckbox++) {
                    selectedCheckbox[iCheckbox] = this.checked;
                }
            } else {
                // 单选
                selectedCheckbox[thisIndex] = this.checked;
            }

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
                $("#editBtn").text("编辑 " + checkedCount + " 个客户");
                $("#toolbar").addClass("show");
            } else {
                $("#toolbar").removeClass("show");
            }
        });

        /**
         * 删除行数据
         */
        $("#deleteBtn").click(function() {
            var userIdArr = [];
            var userNameArr = [];

            $("#orderGrid").find('td input[type=checkbox]:checked').each(function () {
                var trData = $(this).closest("tr").data('data');

                userIdArr.push(trData.userId);
                userNameArr.push(trData.userName);
            });

            if (userIdArr.length === 1) { /* 单选删除 */
                $("#delUser").text(userNameArr[0]);
                $("#delSingleUser").css("display", "block");
                $("#delMultipleUser").css("display", "none");
                $("#deleteUserModal").modal('show');
            } else if(userIdArr.length > 1) { /* 多选删除 */
                $("#delSingleUser").css("display", "none");
                $("#delMultipleUser").css("display", "block");
                $("#userNum").text(userIdArr.length);
                $("#deleteUserModal").modal('show');
            }
        });

        // 群发短信
        $('#massBtn').on('click', function() {
            var telArr = [];

            // 获取所有电话号码
            $("#orderGrid").find('td input[type=checkbox]:checked').each(function () {
                var tel = $(this).closest("tr").data("data").telPhone;
                if(tel != null && tel.trim() != '') {
                    telArr.push(tel.trim());
                }
            });

            // 初始化群发短信modal
            massSMSModal.init(telArr.join(';'));
        });
    }
</script>

</body>
</html>