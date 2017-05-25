<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import = "com.channelsoft.ems.field.po.UserDefinedFiedPo" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>用户组管理首页</title>
    <%@include file="/views/include/pageHeader.jsp"%>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/script/lib/dropzone/dropzone.css"/>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/static/css/innerFrame.css">
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/static/css/newIndex.css">
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/static/css/order.css">

	<script src="<%=request.getContextPath()%>/script/lib/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
	<script src="<%=request.getContextPath()%>/script/lib/bootstrap-datetimepicker-master/js/locales/bootstrap-datetimepicker.zh-CN.js"></script>
</head>
<body>
<div id="left-part">
    <div class="main-contain">
        <header class="part-header">
            <div class="sidebar">用户与组</div>
        </header>
        <div class="left-content">
            <div class="left-content-panel">
                <div class="left-content-panel-header">用户
                    <a data-toggle="modal" data-target="#addUserModal" onclick="secondLevel();" id="addUserBtn" style="display: none;">新增用户</a>
                </div>
                <ul class="left-content-panel-body left-part-list" id="group1Menu">
                    <li id="li_all" data-href="" data-isajax="1"><a>用户管理</a></li>
                </ul>
            </div>
            <c:if test="${hasGroup3}">
                <div class="left-content-panel">
                    <div class="left-content-panel-header">用户组
                        <a data-toggle="modal" data-target="#addGroupModal" onclick="addNewGroup()">新增用户组</a></div>
                    <ul class="left-content-panel-body left-part-list" id="group3Menu">
                        <c:forEach items="${permissionList}" var="item">
                            <c:if test="${item.groupId == '3'}">
                                <li id="li${item.id}" data-href="${item.url}" data-isajax="${item.isAjax}"><a>${item.name}</a></li>
                            </c:if>
                        </c:forEach>
                    </ul>
                </div>
            </c:if>

            <div class="left-content-panel">
                <div class="left-content-panel-header">角色</div>
                <ul class="left-content-panel-body left-part-list" id="group4Menu">
                    <c:forEach items="${permissionList}" var="item">
                        <c:if test="${item.groupId == '1'}">
                            <c:if test="${item.isAjax == '0'}">
                                <li id="li${item.id}" data-href="${item.url}" data-isajax="${item.isAjax}"><a>${item.name}</a></li>
                            </c:if>
                        </c:if>
                    </c:forEach>
                </ul>
            </div>
        </div>
    </div>

    <div class="toggle-btn-box">
        <button class="toggle-btn" id="leftToggleBtn"><i class="fa fa-angle-left" aria-hidden="true" style="font-size: 20px;"></i></button>
    </div>
</div>
<div id="right-part">
    <header class="part-header">
        <span>最新用户</span>
        <div class="dropdown">
            <button class="btn btn-default dropdown-toggle" type="button" id="dropdownMenu1" data-toggle="dropdown" aria-haspopup="true" aria-expanded="true" style="border: 1px solid #eee;">
                自定义列<span class="caret"></span>
            </button>
            <ul class="dropdown-menu dropdown-menu-right" aria-labelledby="dropdownMenu1" id="dropdown1Select">
                <c:forEach items="${activeFieldLists}" var="item">
                    <c:choose>
                        <c:when test="${item.isCheck}">
                            <li><label><input type="checkbox" value="${item.key}" name="checkbox"  checked="checked">${item.name}</label></li>
                        </c:when>
                        <c:otherwise>
                            <li><label><input type="checkbox" value="${item.key}" name="checkbox" >${item.name}</label></li>
                        </c:otherwise>
                    </c:choose>
                </c:forEach>
            </ul>
        </div>
    </header>

    <div class="right-content" id="rightContainer">
        <iframe name="iframe" id="rightIframe" style="display:none" width="100%" height="100%" src="" frameborder="0" data-id="index_v1.html" seamless></iframe>
        <div class="right-content-panel container" id="rightDiv" >
            <div class="container-fluid">
                <div class="row" id="queryDiv">
                    <div class="col-sm-12">
                        <div class="query-condition">
                            <div class="col-sm-9">
                                <div class="form-inline query-list" id="queryList">
                                    <form id="queryCondition">
                                        <div class="form-group">
                                            <label for="loginName" class="control-label">登录账号：</label>
                                            <input type="text" id="loginNameQuery" name="loginName" class="form-control"/>
                                        </div>
                                        <div class="form-group">
                                            <label for="telPhone" class="control-label">手机：</label>
                                            <input type="text" id="telPhone" name="telPhone" class="form-control">
                                        </div>
                                        <div class="form-group">
                                            <label for="email" class="control-label">邮箱：</label>
                                            <input type="email" id="email" name="email" class="form-control">
                                        </div>
                                        <div class="form-group">
                                            <label for="userName" class="control-label">用户姓名：</label>
                                            <input type="text" id="userName" name="userName" class="form-control">
                                        </div>
                                        <div class="form-group">
                                            <label for="userStatus" class="control-label">用户状态：</label>
                                            <!-- <input type="text" id="userStatus" name="userStatus" class="form-control"> -->
                                            <select class="form-control" id="userStatus" name="userStatus">
                                                <option value="">所有</option>
                                                <option value="1">正常</option>
                                                <option value="3">未审核</option>
                                                <option value="4">已停用</option>
                                            </select>
                                        </div>

                                        <div class="form-group">
                                            <label for="roleIdQuery" class="control-label">角色权限：</label>
                                            <select class="form-control" id="roleIdQuery" name="roleId"></select>
                                        </div>
                                    </form>
                                </div>
                            </div>
                            <div class="col-sm-3">
                                <div class="col-sm-4">
                                    <a href="javascript:void(0)" class="btn btn-xs" id="toggleBtn">
                                        <span>更多</span>
                                        <i class="fa fa-caret-down"></i>
                                    </a>
                                </div>
                                <div class="col-sm-4">
                                    <a href="javascript:void(0)" class="btn btn-xs btn-raised" id="clearBtn" onclick="initQuery()">清空</a>
                                </div>
                                <div class="col-sm-4">
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
                                <div class="sub-switch-menu" id="noUserGrid" style="display: none;text-align: center;">
                                    <!-- 没有用户 -->
                                    <strong style="font-size: 15px">未查询到用户信息</strong>
                                </div>
                                <table class="table" cellspacing="0" cellpadding="0" id="grid">
                                    <thead>
                                    <tr class="order" id="userTableTr">
                                        <th width="40"><input class="ember-view ember-checkbox all-checkbox" type="checkbox" id="allSelect"> </th>
                                        <th>头像</th>
                                        <th width="180">用户姓名</th>
                                        <th width="150">邮箱</th>
                                        <th width="150">手机</th>
                                        <th width="150">创建时间</th>
                                        <th width="150">最后登录</th>
                                    </tr>
                                    </thead>
                                    <tbody></tbody>
                                    <tfoot>
                                    <tr id="paginationTR">
                                        <td colspan="20"><div id="pagination"></div></td>
                                    </tr>
                                    <tr id="paginationForgTR" style="display:none">
                                        <td colspan="20"><div id="paginationForg"></div></td>
                                    </tr>
                                    </tfoot>
                                </table>

                                <table class="table" cellspacing="0" cellpadding="0" id="gridGroup" style="display:none">
                                    <thead>
                                    <tr class="order">
                                        <th>用户组</th>
                                        <th>用户组成员</th>
                                        <th></th>
                                    </tr>
                                    </thead>
                                    <tbody></tbody>
                                    <tfoot>
                                    <tr>
                                        <td colspan="20"><div id="paginationGroup"></div></td>
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
    <div id="toolbar">
        <button id="deleteBtn" type="button" class="btn btn-raised left-btn btn-danger">删除</button>
        <button id="cancelBtn" type="button" class="btn btn-raised btn-default btn-dark" onclick="cancel()">取消</button>
        <button id="editBtn" type="button" class="btn btn-raised btn-primary" data-toggle="modal" data-target="#editUserModal">编辑用户</button>
    </div>
</div>

<!-- 添加用户 -->
<div id="addUserModal" class="modal fade bs-example-modal-sm" data-backdrop="static">
    <div class="modal-dialog" style="width:800px;margin: 30px auto">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <span class="modal-title">新增用户</span>
            </div>
            <div class="modal-body">
                <div class="container-fluid">
                    <form id="formId" class="row form-horizontal" autocomplete="off">
                        <!-- 角色权限    -->
                        <div class="form-group col-md-6">
                            <p class="help-block" style="text-align: right; top: -15px; right: 30px;">管理员和客服人员是处理工单的的用户角色</p>
                            <label for="typeSelect" class="control-label col-md-4"><span style="color:red">*</span>用户角色:</label>
                            <div class="col-md-8">
                                <select class="form-control" name="userType" id="typeSelect" onchange="secondLevel()"></select>
                            </div>
                        </div>

                        <div class="col-md-6 form-group" id="secondTypeBox">
                            <label for="secondType" class="control-label col-md-4"><span style="color:red">*</span>角色权限:</label>
                            <div class="col-md-8">
                                <select class="form-control" id="secondType"></select>
                            </div>
                        </div>

                        <div style="display:none">
                            <input type="text" class="form-control" name="roleId" id="roleId">
                        </div>

                        <!-- 账号密码(必填) -->
                        <div class="col-md-6 form-group">
                            <label for="loginName" class="control-label col-md-4"><span style="color:red">*</span>登录账号:</label>
                            <div class="col-md-8">
                                <input type="text" class="form-control" name="loginName" id="loginName" placeholder="请输入用户邮箱或手机号">
                            </div>
                        </div>

                        <div class="col-md-6 form-group">
                            <label for="passWord" class="col-md-4 control-label"><span style="color:red">*</span>密码:</label>
                            <div class="col-md-8">
                                <input type="text" class="form-control" name="loginPwd" id="passWord"  placeholder="请设置用户初始密码" autocomplete="off">
                            </div>
                        </div>
                        <!-- 坐席工号 -->
                        <div class="col-md-6 form-group">
                            <label for="agentId" class="col-md-4 control-label"><span style="color:red">*</span>坐席工号:</label>
                            <div class="col-md-8">
                                <input type="text" class="form-control" name="agentId" id="agentId"  placeholder="请填写坐席工号（数字）" autocomplete="off">
                            </div>
                        </div>

                        <!-- 其他信息(可选) -->
                        <div class="col-md-6 form-group">
                            <label for="inputPassword3" class="control-label col-md-4">邮箱:</label>
                            <div class="col-md-8">
                                <input type="email" class="form-control" name="email" id="inputPassword3" placeholder="">
                            </div>
                        </div>

                        <!-- 用户姓名(必填) -->
                        <div class="col-md-6 form-group">
                            <label for="addUserNameN" class="control-label col-md-4"><span id="star" style="color:red;display:none">*</span>用户姓名:</label>
                            <div class="col-md-8">
                                <input type="text" class="form-control" name="userName" id="addUserNameN">
                            </div>
                        </div>

                        <div class="col-md-6 form-group">
                            <label for="addUserPhone" class="control-label col-md-4">手机:</label>
                            <div class="col-md-8">
                                <input type="text" class="form-control" name="telPhone" id="addUserPhone">
                            </div>
                        </div>

                        <div class="col-md-6 form-group">
                            <label for="fixedPhone" class="control-label col-md-4">座机:</label>
                            <div class="col-md-8">
                                <input type="text" class="form-control" name="fixedPhone" id="fixedPhone" placeholder="">
                            </div>
                        </div>

                        <div class="col-md-6 form-group">
                            <label for="userDesc" class="control-label col-md-4">用户说明:</label>
                            <div class="col-md-8">
                                <input type="text" class="form-control" name="userDesc" id="userDesc">
                            </div>
                        </div>

                        <div class="col-md-6 form-group">
                            <label for="remark" class="control-label col-md-4">详细信息:</label>
                            <div class="col-md-8">
                                <input type="text" class="form-control" name="remark" id="remark" placeholder="">
                            </div>
                        </div>
                    </form>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-raised btn-default btn-sm" data-dismiss="modal">取消</button>
                <button type="button" class="btn btn-raised btn-primary btn-sm" onclick="addUserSubmit()">提交</button>
            </div>
        </div>
    </div>
</div>

<!-- 删除客服/管理员 -->
<div id="deleteAgentModal" class="modal fade bs-example-modal-sm" data-backdrop="static">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <span class="modal-title">删除用户</span>
            </div>
            <div class="modal-body">
                <div class="container-fluid">
                    <div class="row">
                        <div class="col-sm-10 col-sm-offset-1">
                            <form class="form-horizontal">
                                <ul>
                                    <li>
                                        <div class="form-group">
                                            <span>注意 </span>
                                        </div>
                                        <div class="form-group" id="delSingleAgent">
                                            <p>
                                                是否确认删除用户
                                                <span class="green" id="delAgent"></span>
                                                ？删除后，跟此用户
                                                <span class="red">相关工单</span>
                                                和
                                                <span class="red">文档</span>
                                                会被一起删除，且
                                                <span class="red">无法恢复</span>
                                                ，请慎重操作！
                                            </p>
                                        </div>

                                        <div class="form-group" id="delMultipleAgent" style="display:none">
                                            <p>
                                                是否确认删除
                                                <span class="red" id="agentNum"></span>
                                                个用户 ？删除后，跟此用户
                                                <span class="red">相关工单</span>
                                                和
                                                <span class="red">文档</span>
                                                会被一起删除，且
                                                <span class="red">无法恢复</span>
                                                ，请慎重操作！
                                            </p>
                                        </div>
                                    </li>
                                    <li>
                                        <div class="form-group">
                                            <span class="red">警告 </span>
                                        </div>
                                        <div class="form-group">
                                            <input type="text" class="form-control" id="inputYes" placeholder="确认删除请在此输入：yes">
                                            <p class="red" id="tishi1">您将要删除的用户是客服/管理员用户！</p>
                                        </div>
                                    </li>
                                </ul>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-raised btn-primary btn-sm" onclick="deleteAgentSubmit()" id="deleteAgentSubmit">确认删除</button>
                <button type="button" class="btn btn-raised btn-default btn-sm" data-dismiss="modal">取消</button>
            </div>
        </div>
    </div>
</div>

<!-- 编辑用户 -->
<div id="editUserModal" class="modal fade bs-example-modal-sm" data-backdrop="static">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <span class="modal-title">批量编辑用户</span>
            </div>
            <div class="modal-body">
                <div class="container-fluid">
                    <div class="row">
                        <div class="col-sm-10 col-sm-offset-1">
                            <form class="form-horizontal">
                                <div class="form-group">
                                    <label for="inputPassword3" class="control-label">账号状态 </label>
                                    <select class="form-control" id="statusSelect">
                                        <option value="">不改变</option>
                                        <option value="1">正常</option>
                                        <!-- <option value="2">暂停</option> -->
                                        <option value="3">未审核</option>
                                        <option value="4">停用</option>
                                    </select>
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

<!-- 添加客户组 -->
<div id="addGroupModal" class="modal fade" data-backdrop="static">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <span class="modal-title">添加用户组</span>
            </div>
            <div class="modal-body">
                <form class="form-horizontal">
                    <div class="form-group">
                        <label class="col-sm-3 control-label">用户组名称:</label>
                        <div class="col-sm-7">
                            <input type="text" name="groupId" id="edit_groupId" style="display:none">
                            <input type="text" class="form-control" placeholder="请输入用户组名称" name="groupName" id="edit_groupName">
                        </div>
                    </div>
                </form>
                <div class="container-fluid">
                    <div class="row">
                        <span class="col-sm-7">点击用户</span><span class="col-sm-5">已选择用户</span>
                    </div>
                    <div class="row select-box-content">
                        <div class="col-sm-5 select-box left">
                            <div class="search-box"><input id="user-search" name="search" placeholder="输入用户姓名或用户ID搜索" type="search"></div>
                            <ul id="unselected" class="ulcenter">
                            </ul>
                        </div>
                        <i class="icon fa fa-arrow-right"></i>
                        <div class="col-sm-5 select-box right">
                            <ul id="selected" class="ulcenter"></ul>
                        </div>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-raised btn-default btn-sm" data-dismiss="modal" id="edit_cancel">取消</button>
                <button type="button" class="btn btn-raised btn-primary btn-sm" id="deleteGroup" style="display:none" onclick="deleteSubmit()">删除</button>
                <button type="button" class="btn btn-raised btn-primary btn-sm" onclick="editSubmit()">提交</button>
            </div>
        </div>
    </div>
</div>

<%@include file="./userImport.jsp"%>

<!-- 用户头像模板 -->
<script id="table-tr-template-photo" type="text/x-handlebars-template">
    <td data-prop="photoUrl" class="user">
        <a class="avatar">
            <img src="{{photoUrl}}" onclick="viewDetails('{{userId}}','{{userName}}')">
        </a>
    </td>
</script>

<script id="table-tr-template" type="text/x-handlebars-template">
    <tr id="userFieldRows">
        <td>{{#equal userType '1'}}<input type="checkbox">{{/equal}}
            {{#equal userType '2'}}<input type="checkbox">{{/equal}}
        </td>
        <td style="display:none">{{userId}}</td>
        <td style="display:none">{{userLabel}}</td>
    </tr>
</script>

<script id="table-tr-template-agent" type="text/x-handlebars-template">
    <tr>
        <td >{{#equal userType '1'}}<input type="checkbox">{{/equal}}</td>
        <td  style="display:none">{{userId}}</td>
        <td style="display:none">{{userLabel}}</td>
    </tr>
</script>

<script id="table-tr-template-founder" type="text/x-handlebars-template">
    <tr>
        <td>{{#equal userType '1'}}<input type="checkbox">{{/equal}}
            {{#equal userType '2'}}<input type="checkbox">{{/equal}}
            {{#equal userType '3'}}<input type="checkbox">{{/equal}}
        </td>
        <td style="display:none">{{userId}}</td>
        <td style="display:none">{{userLabel}}</td>
    </tr>
</script>

<script id="table-tr-template-user" type="text/x-handlebars-template">
    <td data-prop="userName" class="user">
        <div class="user-right">
            <a class="name" href="#" onclick="viewDetails('{{userId}}','{{userName}}')">{{userName}}
                <span class="{{#equal phoneBinded '手机已绑定'}}status blue{{/equal}}">{{phoneBinded}}</span>
            </a>
            <span class="{{#equal userStatus '停用'}}status red{{/equal}}{{#equal userStatus '未审核'}}status orange{{/equal}}">{{userStatus}}</span>
        </div>
    </td>
</script>

<script id="tableGroup-tr-template" type="text/x-handlebars-template">
    <tr>
        <td><a href="#" onclick="showAgents('{{groupId}}')">{{groupName}}</a></td>
        <td>{{count}}</td>
        <td><a onclick="edit('{{groupName}}','{{groupId}}')" data-toggle="modal" data-target="#addGroupModal" >编辑</a></td>
    </tr>
</script>

<script type="text/javascript">
    $("#agentId").keypress(function (event) {
        var keyCode = event.keyCode || event.which;
        if ((keyCode >= 48 && keyCode <= 57))
            return true;
        else
            return false;
    });

    <% List<UserDefinedFiedPo> ls = (List<UserDefinedFiedPo>)request.getAttribute("activeFieldLists");%>

    var num = <%= ls.size()%>;

    $(function(){
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

    if ('${userType1}' !== '2') {
        $('#addUserBtn').show();
    }
    //    	new PCAS("province","city","area");
    /* 添加用户,根据权限动态加载用户类型 */
    setTypeSelect();
    //userFieldModule.render();

    //      根据角色数量决定“角色”一栏的显示隐藏 @2016/12/15 @by wuliuyang
    if ($("#group4Menu").find("li").length == 0) {
        $("#group4Menu").parents(".left-content-panel").hide()

    }

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


    $("#left-part .left-content-panel li").click(function () {
        lid = $(this).attr("id");

        $("#left-part .left-content-panel li").removeClass("active");
        $(this).addClass("active");
        $("#right-part .part-header>span").text($(this).find("a").text());
        if ($(this).parent().attr("id") != "group3Menu") {
            if ($(this).data("isajax") == '1') {
                $("#queryDiv").show();
                $("#right-part .part-header .dropdown").css("display", "inline-block");
                $("#rightDiv").show();
                $("#rightIframe").hide().parent().css("overflow", "auto");
                $("#gridGroup").hide();
                $("#paginationTR").show();
                $("#paginationForgTR").hide();
                $("#toolbar").removeClass("show");
                //清空查询条件
                initQuery();
                //初始化角色权限选项
                initRole(lid);
                var userType;
                var role;
                var url = "<%=request.getContextPath()%>/newuserManage/getuser";
                if (lid == 'li_all') {

                } else if (lid == 'li_op') {
                    userType = '2';
                } else if (lid == 'li_official') {
                    userType = '2';
                    role = '6';
                } else if (lid == 'li_manage') {
                    userType = '3';
                    role = '3';
                }
                var param = $("#queryCondition").formValue();
                var queryCondition = JSON.stringify(param);
                getTableData({
                    page: 1,
                    rows: 10,
                    entId: '${entId}',
                    userType: userType,
                    role: role,
                    query: queryCondition
                }, url);
            }
            else {
                $("#queryDiv").hide();
                $("#right-part .part-header .dropdown").hide();
                $("#rightDiv").hide();
                $("#rightIframe").show().attr('src', $(this).data("href")).parent().css("overflow", "hidden");
                $("#toolbar").removeClass("show");
            }
        } else {
            $("#queryDiv").hide();
            $("#right-part .part-header .dropdown").hide();
            $("#toolbar").removeClass("show");
            if ($(this).data("isajax") == '1') {
                $("#rightDiv").show();
                $("#rightIframe").hide().parent().css("overflow", "auto");
                $("#grid").hide();
                getTableDataGroup({page: 1, rows: 10, entId: '${entId}'}, $(this).data("href"));
            }
        }
        $("#allSelect").prop("checked", false);
    });
    $("#group1Menu li:first-child").click();
    initAddGridModal();
        $('#addUserBtn').on('click', function() {
            var $formId = $('#formId');
            $formId.find('input, select').val('');
        });
    });

    $("#toggleBtn").on('click', function (event) {
        // 阻止a标签默认跳转
        event.preventDefault();
        var $my = $(this);
        if ($my.hasClass('to-click')) {
            $('#queryList').css({
                height: '53px'
            });
            $my.removeClass('to-click');
            $my.find('span').text('更多');
            $my.find('i').removeClass('fa-caret-up').addClass('fa-caret-down');
        } else {
            $('#queryList').css({
                'height': 'auto'
            });
            $my.addClass('to-click');
            $my.find('span').text('收起');
            $my.find('i').removeClass('fa-caret-down').addClass('fa-caret-up');
        }
    });
    //清空按钮
    function initQuery() {
        $("#loginNameQuery").val("");
        $("#telPhone").val("");
        $("#email").val("");
        $("#userName").val("");
        $("#userStatus").val("");
        $("#opLevel").val("");
        $("#roleIdQuery").val("");
    }
    //初始化角色权限按钮
    function initRole(lid) {
        var selectHTML = "";
        if (lid == 'li_all') {
            selectHTML = "<option value=''>所有角色</option><option value='4'>普通客服</option><option value='5'>客服班长</option>" +
                "<option value='6'>职能人员</option><option value='3'>管理员</option>";
        } else if (lid == 'li_op') {
            selectHTML = "<option value=''>全部客服</option><option value='4'>普通客服</option><option value='5'>客服班长</option>";
        } else if (lid == 'li_official') {
            selectHTML = "<option value='6'>职能人员</option>";
        } else if (lid == 'li_manage') {
            selectHTML = "<option value='3'>管理员</option>";
        }
        $("#roleIdQuery").html(selectHTML);
    }
    //条件查询按钮
    $("#queryBtn").click(function () {
        var url = "<%=request.getContextPath()%>/newuserManage/getuser";
        var param = $("#queryCondition").formValue();

        // 去除查询条件的首位空格
        for (var p in param) {
            if (param.hasOwnProperty(p) && typeof param[p] === 'string') {
                param[p] = param[p].trim();
            }
        }

        var queryCondition = JSON.stringify(param);
        var userType = '';
        var role = '';
        $("#group1Menu li").each(function () {
            var style = $(this).attr("class");
            if (style == "active") {
                lid = $(this).attr("id");
                if (lid == 'li_all') {

                } else if (lid == 'li_op') {
                    userType = '2';
                } else if (lid == 'li_official') {
                    userType = '2';
                    role = '6';
                } else if (lid == 'li_manage') {
                    userType = '3';
                    role = '3';
                }
            }
        });
        getTableData({
            page: 1,
            rows: 10,
            entId: '${entId}',
            userType: userType,
            role: role,
            query: queryCondition
        }, url);
    });
    /**
     * 向后台请求数据
     */
    var getTableData = (function () {
        /**
         * 初始化分页
         */
        var pager = new cri.Pager($("#pagination"), {
            page: 1,
            pageSize: 10,
            total: 0,
            onPage: function (page, pageSize) {
                var url = "<%=request.getContextPath()%>/newuserManage/getuser";
                var param = $("#queryCondition").formValue();
                var queryCondition = JSON.stringify(param);
                var userType;
                var role;
                var roleId = null;
                $("#group1Menu li").each(function () {
                    var style = $(this).attr("class");
                    if (style == "active") {
                        lid = $(this).attr("id");
                        if (lid == 'li_all') {

                        } else if (lid == 'li_op') {
                            userType = '2';
                        } else if (lid == 'li_official') {
                            userType = '2';
                            role = '6';
                        } else if (lid == 'li_manage') {
                            userType = '3';
                            role = '3';
                        }
                        var thiUrl = $(this).data("href");
                        if (thiUrl.indexOf("role/list") >= 0) {
                            url = "<%=request.getContextPath()%>/userManageMongo/queryUser/7";
                            roleId = $(this).data("roleId");
                        }
                    }

                });
                $("#group4Menu li").each(function () {
                    var style = $(this).attr("class");
                    if (style == "active") {
                        var thiUrl = $(this).data("href");
                        if (thiUrl.indexOf("role/list") >= 0) {
                            url = "<%=request.getContextPath()%>/userManageMongo/queryUser/7";
                            roleId = $(this).data("roleId");
                        }
                    }
                });
                getTableData({
                    page: page,
                    rows: pageSize,
                    entId: '${entId}',
                    userType: userType,
                    roleId: roleId,
                    role: role,
                    query: queryCondition
                }, url);
            }
        });
        return function (param, url) {
            $.post(url, param, function (data) {
                if (!data.success) {
                    notice.danger(data.msg);
                    return;
                }

                if (data.rows.length == "0") {
                    $("#grid").hide();
                    $("#noUserGrid").show();
                } else {
                    $("#grid").show();
                    $("#noUserGrid").hide();
                    for (var i = 0; i < data.rows.length; i++) {
                        if (data.rows[i].loginTime == null) data.rows[i].loginTime = "未登录";
                    }
                    createTable(data.rows);
                    $("#grid tbody").show();
                    pager.update(param.page, param.rows, data.total);
                }
            });
        }
    })();

    var getTableDataForg = (function () {
        var pager = null;
        var groupId = null;
        return function (param, url) {
            $("#paginationTR").hide();
            $("#paginationForgTR").show();
            if (param.groupId != undefined && param.page == 1 && param.groupId != groupId) {
                groupId = param.groupId;
                if (pager == null) {
                    pager = new cri.Pager($("#paginationForg"), {
                        page: 1,
                        pageSize: 10,
                        total: 0,
                        onPage: function (page, pageSize) {
                            var userStatus = "";
                            $("#status li").each(function () {
                                var style = $(this).attr("class");
                                if (style == "active") {
                                    userStatus = getUserStatus($(this).text());
                                }
                            });
                            getTableDataForg({
                                page: page,
                                rows: pageSize,
                                entId: '${entId}',
                                groupId: param.groupId,
                                userStatus: userStatus
                            }, "<%=request.getContextPath()%>/groupMongo/getDetailMembers");
                        }
                    });
                } else {
                    var userStatus = "";
                    $("#status li").each(function () {
                        var style = $(this).attr("class");
                        if (style == "active") {
                            userStatus = getUserStatus($(this).text());
                        }
                    });
                    pager.options.onPage = function (page, pageSize) {
                        getTableDataForg({
                            page: page,
                            rows: pageSize,
                            entId: '${entId}',
                            groupId: param.groupId,
                            userStatus: userStatus
                        }, "<%=request.getContextPath()%>/groupMongo/getDetailMembers");
                    };
                }
            }
            url = url || "";
            $.ajax({
                url: url,
                dataType: 'json',
                data: param,
                success: function (data) {
                    if (!data.success) {
                        notice.danger(data.msg);
                        return;
                    }

                    for (var i = 0; i < data.rows.length; i++) {
                        if (data.rows[i].loginTime == null)data.rows[i].loginTime = "未登录";
                    }
                    createTable(data.rows);
                    pager.update(param.page, param.rows, data.total);
                    $("#grid").show();
                }
            });
        }
    })();

    var getTableDataGroup = (function () {
        /**
         * 初始化分页
         */
        var pager = new cri.Pager($("#paginationGroup"), {
            page: 1,
            pageSize: 10,
            total: 0,
            onPage: function (page, pageSize) {
                getTableDataGroup({
                    page: page,
                    rows: pageSize,
                    entId: '${entId}'
                }, "<%=request.getContextPath()%>/groupMongo/getGroups");
            }
        });
        return function (param, url) {
            url = url || "";
            $.ajax({
                url: url,
                dataType: 'json',
                data: param,
                success: function (data) {
                    if (!data.success) {
                        notice.danger(data.msg);
                    }
                    createTableGroup(data.rows);
                    pager.update(param.page, param.rows, data.total);
                    $("#gridGroup").show();
                }
            });
        }
    })();

    /**
     * 刷新表格
     */
    var fieldNames = {
        photoUrl: "头像",
        userName: "用户名",
        email: "邮箱",
        telPhone: "电话",
        createTime: "创建时间",
        loginTime: "最后登陆"
    };
    var defaultFieldNames = fieldNames;
    var createTable = (function () {
        var trTemp = Handlebars.compile($("#table-tr-template").html());
        var trTempAgent = Handlebars.compile($("#table-tr-template-agent").html());
        var trTempFounder = Handlebars.compile($("#table-tr-template-founder").html());
        var userTemp = Handlebars.compile($("#table-tr-template-user").html());
        var photoTemp = Handlebars.compile($("#table-tr-template-photo").html());

        var $table = $("#grid");

        return function (tableData, type) {
            var html = [];
            // 包含复选框的数据条数
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

                // 如果该用户是创始人
                if (tableData[i].founder == "1") {
                    tableData[i].userTypeDesc = "创始人";
                }

                var $tr = "";
                // 登录的账号是管理员，但不是创始人
                if ("${userType1}" == "3" && "${isFounder}" != "1") {
                    if (tableData[i].userType === "3") {
                        checkCount = checkCount - 1;
                    }

                    $tr = $(trTemp(tableData[i]));
                }

                // 登录的账号是创始人
                if ("${isFounder}" == "1") {
                    if (tableData[i].founder == "1") {
                        checkCount = checkCount - 1;
                    }

                    $tr = $(trTempFounder(tableData[i]));
                }

                // 登录的账号是坐席(谁都不能操作)
                if ("${userType1}" == "2") {
                    checkCount = checkCount - 1;

                    $tr = $(trTempAgent(tableData[i]));
                }

                $tr.data("data", tableData[i]);

                var fns = $.extend({}, fieldNames);

                for (var p in fns) {
                    if (fns[p]) {
                        if (p == "photoUrl")/**用户头像特殊处理**/{
                            $photoTd = $(photoTemp(tableData[i]));
                            $tr.append($photoTd);
                        } else if (p == "userName")/**用户字段特殊处理**/{
                            $userTd = $(userTemp(tableData[i]));
                            $tr.append($userTd);
                        } else {
                            var _t = tableData[i][p] || "";

                            // 如果字段是角色，则显示相应中文
                            if(p === 'userType') {
                                _t = tableData[i].userTypeDesc;
                            }
                            //如果字段是roleId表示具体的角色,用roleName取对应中文名字
                            if(p === 'roleId') {
                                _t = tableData[i].roleName;
                            }

                            $tr.append('<td data-prop="' + p + '">' + _t + '</td>');
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

            $table.find("input[type=checkbox]").change(function () {
                var $t = $(this).parent();
                if ($t.is("th")) {
                    $table.find("td input[type=checkbox]").prop("checked", $(this).prop("checked"));
                }
                var length = $table.find('td input[type=checkbox]:checked').length;

                if (!$t.is("th")) {
                    if (checkCount == length) {
                        $("#allSelect").prop("checked", true);
                    }
                    else {
                        $("#allSelect").prop("checked", false);
                    }
                }

                if ($table.find('td input[type=checkbox]:checked').length) {
                    $("#editBtn").text("编辑 " + length + " 个用户");
                    $("#toolbar").addClass("show");
                }
                else {
                    $("#toolbar").removeClass("show");
                }
            });

        };
    })();
    //根据即时的字段排序动态生成handebar模板
    function handlebarsComplete($tr) {
        var handbarHTML = $tr.html();
//    	handbarHTML = '<span>'+handbarHTML;
        for (var p in fieldNames) {
            if (false) {
                handbarHTML += '<td data-prop="userName" class="user">';
                handbarHTML += '<a class="avatar"><img src="{{photoUrl}}" onclick="viewDetails(\'{{userId}}\',\'{{userName}}\')"></a>';
                handbarHTML += '<div class="user-right">';
                handbarHTML += '<a class="name" href="#" onclick="viewDetails(\'{{userId}}\',\'{{userName}}\')">{{userName}}';
                handbarHTML += '<span class="{{#equal phoneBinded \'手机已绑定\'}}status blue{{/equal}}">{{phoneBinded}}</span></a>';
                handbarHTML += '<span class="{{#equal userStatus \'停用\'}}status red{{/equal}}{{#equal userStatus \'未审核\'}}status orange{{/equal}}">{{userStatus}}</span>';
                handbarHTML += '<span class="privilege">{{userTypeDesc}}</span></div></td>';
            } else {
                handbarHTML += '<td data-prop="' + p + '">{{' + p + '}}</td>';
            }
        }
        handbarHTML += '</tr>';

        $tr.html('<th>kk</th>');
    }

    var createTableGroup = (function () {
        var trTemp = Handlebars.compile($("#tableGroup-tr-template").html());
        var $table = $("#gridGroup");

        return function (tableData) {
            var html = [];
            for (var i = 0, len = tableData.length; i < len; i++) {
                var $tr = $(trTemp(tableData[i]));
                html.push($tr);
            }
            $table.find("tbody").empty().append(html);
            $table.find("input[type=checkbox]").change(function () {
                var $t = $(this).parent();
                if ($t.is("th")) {
                    $table.find("td input[type=checkbox]").prop("checked", $(this).prop("checked"));
                }
                if ($table.find('td input[type=checkbox]:checked').length) {
                    $("#toolbar").addClass("show");
                }
                else {
                    $("#toolbar").removeClass("show");
                }
            });
        };
    })();
    /**
     * 初始化添加客服组对话框
     */
    function initAddGridModal() {
        $("#user-search").keyup(function () {
            var value = this.value;
            if (value != "") {
                $("#unselected li").each(function () {
                    var $li = $(this);
                    if ($li.text().indexOf(value) < 0) {
                        $li.hide();
                    }
                    else {
                        $li.show();
                    }
                });
            }
            else {
                $("#unselected li").show();
            }
        });

        $("#addGroupModal .select-box-content").find("li").click(function () {
            var $other = $(this).closest(".select-box").siblings(".select-box").find("ul");
            var $li = $(this).detach();
            $other.append($li);
        });
    }
    /**
     *编辑客服组
     */
    function edit(groupName, groupId) {
        $("#deleteGroup").show();
        $("#edit_groupName").val(groupName);
        $("#edit_groupId").val(groupId);
        $.post("<%=request.getContextPath()%>/groupMongo/getAgents", {"groupId": groupId}, editCallBack, "json");
    }
    function editCallBack(data) {
        var rows = data.rows;
        $("#addGroupModal .select-box-content ul#unselected").html("");
        $("#addGroupModal .select-box-content ul#selected").html("");
        for (var i = 0; i < rows.length; i++) {
            var li = "<li><input style='display:none;' value='" + rows[i].userId + "' />" + rows[i].userId + "&lt;" + rows[i].userName + "&gt;</li>";
            if (rows[i].groupId == $("#edit_groupId").val()) {
                $("#addGroupModal .select-box-content ul#selected").append(li);
            } else {
                $("#addGroupModal .select-box-content ul#unselected").append(li);
            }
        }

        $("#addGroupModal .select-box-content").find("li").click(function () {
            var $other = $(this).closest(".select-box").siblings(".select-box").find("ul");
            var $li = $(this).detach();
            $other.append($li);
        });
    }
    /**
     *客服组删除
     */
    function deleteSubmit() {
        var groupId = $("#edit_groupId").val();
        if (confirm("确定要删除该客服组吗？删除后无法恢复哦！"))
            $.post("<%=request.getContextPath()%>/groupMongo/deleteGroup", {"groupId": groupId}, deleteSubmitCallBack, "json");
    }
    function deleteSubmitCallBack(data) {
        if (data.success == true) {
            $("#edit_cancel").click();
            $("#deleteGroup").hide();
            getTableDataGroup({
                page: 1,
                rows: 10,
                entId: '${entId}'
            }, "<%=request.getContextPath()%>/groupMongo/getGroups");
            notice.success(data.msg);
        } else {
            notice.danger(data.msg);
        }
    }
    /**
     *提交编辑结果
     */
    function editSubmit() {
        var param = new Object();
        param.groupId = $("#edit_groupId").val();
        param.groupName = $("#edit_groupName").val();
        param.userIds = "";
        var inputs = $("#addGroupModal .select-box-content ul#selected").find("input");

        if (inputs.length > 0) {
            inputs.each(function () {
                if (param.userIds) {
                    param.userIds = param.userIds + "," + $(this).val();
                } else {
                    param.userIds = $(this).val();
                }
            });
        }
        //param.agents=param.agents.substring(0,param.agents.length-1);
        if (param.groupId != "")
            $.post("<%=request.getContextPath()%>/groupMongo/updateGroup", param, editSubmitCallBack, "json");
        else
            $.post("<%=request.getContextPath()%>/groupMongo/addGroup", param, addSubmitCallBack, "json");
    }
    function editSubmitCallBack(data) {
        if (data.success == true) {
            $("#edit_cancel").click();
            $("#deleteGroup").hide();
            getTableDataGroup({
                page: 1,
                rows: 10,
                entId: '${entId}'
            }, "<%=request.getContextPath()%>/groupMongo/getGroups");
            notice.success(data.msg);
        } else {
            notice.danger(data.msg);
        }
    }
    function addSubmitCallBack(data) {
        if (data.success == true) {
            $("#edit_cancel").click();
            if ($("#gridGroup").is(':hidden') == false)
                getTableDataGroup({
                    page: 1,
                    rows: 10,
                    entId: '${entId}'
                }, "<%=request.getContextPath()%>/groupMongo/getGroups");
            notice.success(data.msg);
        } else {
            notice.danger(data.msg);
        }
    }
    /**
     *展示指定groupId下的客服列表
     */
    function showAgents(groupId) {
        $("#rightDiv").show();
        $("#rightIframe").hide();
        $("#rightIframe").parent().css("overflow", "auto");
        $("#gridGroup").hide();
        getTableDataForg({
            page: 1,
            rows: 10,
            entId: '${entId}',
            groupId: groupId
        }, "<%=request.getContextPath()%>/groupMongo/getDetailMembers");
    }
    /**
     *添加客服组
     */
    function addNewGroup() {
        $("#addGroupModal input").each(function () {
            $(this).val("");
        });
        $("#deleteGroup").hide();
        $.post("<%=request.getContextPath()%>/groupMongo/getAgents", null, addGroupCallBack, "json");

    }
    function addGroupCallBack(data) {
        var rows = data.rows;
        $("#addGroupModal .select-box-content ul#unselected").html("");
        $("#addGroupModal .select-box-content ul#selected").html("");
        for (var i = 0; i < rows.length; i++) {
            var li = "<li><input style='display:none;' value='" + rows[i].userId + "' />" + rows[i].userId + "&lt;" + rows[i].userName + "&gt;</li>";
            $("#addGroupModal .select-box-content ul#unselected").append(li);
        }
        $("#addGroupModal .select-box-content").find("li").click(function () {
            var $other = $(this).closest(".select-box").siblings(".select-box").find("ul");
            var $li = $(this).detach();
            $other.append($li);
        });
    }
    /**
     * 删除行数据
     */
    $("#deleteBtn").click(function deleteRow() {
        var userIdArrs = [];
        var userTypeArrs = [];
        var userNameArrs = [];
        
        $("#grid").find('td input[type=checkbox]:checked').each(function () {
            var trData = $(this).closest("tr").data("data");
            
            userIdArrs.push(trData.userId);
            userTypeArrs.push(trData.userType);
            userNameArrs.push(trData.userName);
        });
        
        for (var i = 0; i < userTypeArrs.length; i++) {
            if (userTypeArrs[i] == "管理员") {
                if ("${isFounder}" != "1") {
                    notice.warning("你不是创始人，没有权限删除管理员！");
                    return false;
                }
            }
        }
        /* 单选删除 */
        if (userIdArrs.length == 1) {
            $("#delAgent").text(userNameArrs[0]);
            $("#delSingleAgent").css("display", "block");
            $("#delMultipleAgent").css("display", "none");

            $("#tishi1").css("display", "block");

            $("#deleteAgentModal").modal('show');
        }
        /* 多选删除 */
        if (userIdArrs.length > 1) {
            $("#delSingleAgent").css("display", "none");
            $("#delMultipleAgent").css("display", "block");
            $("#agentNum").text(userIdArrs.length);
            $("#tishi1").css("display", "none");

            $("#deleteAgentModal").modal('show');
        }
    });

    /* 删除客服/管理员*/
    function deleteAgentSubmit() {
        var trArr = [];
        $("#grid").find('td input[type=checkbox]:checked').each(function () {
            var $tr = $(this).closest("tr");
            trArr.push($tr.data("data").userId);
        });

        if ($("#inputYes").val().toUpperCase() == "YES") {
            $.ajax({
                url: "<%=request.getContextPath()%>/userManageMongo/deleteUser?ids=" + trArr,
                type: "post",
                dataType: "json",
                data: {
                    entId: "${entId}",
                },
                success: function (data) {
                    if (data.success) {
//                    	var url=$("#"+lid).data("href");
//                        getTableData({page:1,rows:10,entId:'${entId}'},url);
                        $("#queryBtn").click();
                        $("#toolbar").removeClass("show");
                        $("#deleteAgentModal").modal('hide');
                        notice.success("用户删除成功！");
                    } else {
                        notice.danger("删除失败！" + data.msg);
                    }
                }
            });
        }
    }

    function importSubmit() {
        var param = new Object();
        param.addUserFlag = '1';
        param.updateUserFlag = '1';

        $.ajaxFileUpload({
            url: "<%=request.getContextPath()%>/userImport/upload",// url
            secureuri: false,
            fileElementId: 'fileImport',// 上传控件的id
            dataType: 'json',
            data: param, // 其它请求参数
            success: function (data) {
                importSubmitCallBack(data);
            },
            handleError: function (data, status, e) {
                notice.danger("导入失败");
            }
        });
    }
    function importSubmitCallBack(data) {
        if (!data.success) {
            notice.danger(data.msg);
            return;
        }

        $("#edit_cancel").click();
        notice.success(data.msg);
    }

    /* 是否发邮件提醒 */
    var send = "false";
    $("#receiveEmail").click(function () {
        var isChecked = $(this).prop("checked");
        if (isChecked == true) {
            if ($("#inputPassword3").val() != "")
                send = "true";
            else {
                notice.warning("请先填写邮箱！");
                $(this).attr("checked", false);
            }
        }
    });


    /*  添加用户 */
    function addUserSubmit() {
        var addType = $("#typeSelect").val();
        /* if($("#secondType").val()==null){
         $("#roleId").val(addType);
         }else{
         $("#roleId").val($("#secondType").val());
         } */
        if (addType == "3") {
            $("#roleId").val(addType);
        } else if (addType == "2") {
            $("#roleId").val($("#secondType").val());
        }

        /* 登录账号不能为空且不能全为空格 */
        var loginName = $("#loginName").val();
        if (loginName == "") {
            notice.warning("登录账号不能为空！");
            return false;
        } else if (loginName.trim().length == 0) {
            notice.warning("登录账号不能全为空格！");
            return false;
        }

        /*验证坐席工号的数字性以及长度（最多6个）*/
        var agentNum = $("#agentId").val();
        if (!agentNum) {
            notice.warning("坐席工号不能为空!");
            return false;
        } else {
            var reg = /^\d+$/;
            if (reg.test(agentNum)) {
                if (agentNum.length > 6) {
                    notice.warning("坐席工号长度最多为6位!");
                    return false;
                }
            } else {
                notice.warning("坐席工号必须为数字!");
                return false;
            }

        }
        // 确认账号登录方式
        var loginType = Tools.getAccountType(loginName);


        /* 密码必须大于等于6位且不能全为空格 */
        var password = $("#passWord").val();
        if (password.length < 6) {
            notice.warning("密码长度必须大于等于6位！");
            return false;
        } else if (password.trim().length == 0) {
            notice.warning("密码不能全为空格！");
            return false;
        }

        /* 邮箱格式校验 */
        var email = $("#inputPassword3").val();
        if (email != "") {
            if (!mailFormat(email)) {
                return false;
            }
        }

        /* 检测用户名是否重复 */
        if ($("#typeSelect").val() == "2" || $("#typeSelect").val() == "3") {
            var uName = $("#addUserNameN").val();
            if (!checkName(uName)) {
                return false;
            }
        }
        /* 检测登录账号是否重复 */
        if (!checkLoginName($("#loginName").val())) {
            return false;
        }

        /* 自定义字段复选框表单提交  */
        var param = $("#formId").formValue();

        var str = JSON.stringify(param);

        /*  添加客服和管理员，校验用户姓名  */
        var userName = $("#addUserNameN").val();
        if (addType != "1") {
            if (userName == "") {
                notice.warning("请填写用户姓名!");
                return false;
            }
        }

        var telPhone = $("#addUserPhone").val();
        /* 手机格式校验（1开头11位） */
        if (telPhone != "") {
            if (!phoneFormat(telPhone)) {
                return;
            }
        }

        var fixedPhone = $("#fixedPhone").val();
        /* 座机格式校验（1开头11位） */
        if (fixedPhone != "") {
            if (!fixedPhoneFormat(fixedPhone)) {
                return;
            }
        }


        /* 校验手机号是否已存在 */
        if (telPhone != "") {
            var bool = existPhone(telPhone);
            if (bool == "false") {
                return;
            }
            else if (bool == "true") {
                $.ajax({
                    url: "<%=request.getContextPath()%>/userManageMongo/addUser",
                    type: "post",
                    dataType: "json",
                    data: {
                        entId: "${entId}",
                        userInfos: str,
                        send: send,
                        loginType: loginType,
                    },
                    success: function (data) {
                        if (data.success) {
                            notice.success("用户创建成功！");
                            $("#addUserModal").modal('hide');
                            var userId = data.rows;
                            var userName = $("#loginName").val();
                            var url = "<%=request.getContextPath()%>/userManageMongo/userDetails?userId=" + userId;
                            parent.openTab(url, "user", userName, false);
                        } else {
                            $("#addUserModal").modal('hide');
                            notice.danger("添加失败！" + data.msg);
                        }
                    }
                });
            }
        } else {
            $.ajax({
                url: "<%=request.getContextPath()%>/userManageMongo/addUser",
                type: "post",
                dataType: "json",
                data: {
                    entId: "${entId}",
                    userInfos: str,
                    send: send,
                    loginType: loginType
                },
                success: function (data) {
                    if (data.success) {
                        notice.success("用户创建成功！");
                        $("#addUserModal").modal('hide');
                        var userId = data.rows;
                        var userName = $("#loginName").val();
                        var url = "<%=request.getContextPath()%>/userManageMongo/userDetails?userId=" + userId;
                        parent.openTab(url, "user", userName, false);
                    } else {
                        notice.danger("添加失败！" + data.msg);
                    }
                },
                error: function (xhr, status) {
                    notice.danger("添加失败：" + status);
                }
            });
        }
    }
    /**进入批量导入界面 */
    function goImport() {
        $("#rightDiv").hide();
        $("#rightIframe").show().attr('src', '<%=request.getContextPath()%>/userImport/index');
    }
    /* 查看用户详情 */
    function viewDetails(userId, userName) {
        var url = "<%=request.getContextPath()%>/userManageMongo/userDetails?userId=" + userId + '&t=' + (+new Date());
        parent.openTab(url, "user", userName, false);
    }
    /* 批量编辑用户 */
    function editUserSubmit() {
        var trArr = [];
        $("#grid").find('td input[type=checkbox]:checked').each(function () {
            var $tr = $(this).closest("tr");
            trArr.push($tr.data("data").userId);
        });
        var userLabel = $("#newLabel").val();
        var userStatus = document.getElementById("statusSelect").value;
        var entId = '${entId}';
        var userInfos = "{'userLabel':'" + userLabel + "','userStatus':'" + userStatus + "','entId':'" + entId + "'}";

        $.post("<%=request.getContextPath()%>/userManageMongo/updateBatch?ids=" + trArr + "&userInfos=" + userInfos, updateCallBack, 'json');
    }
    /* 批量编辑回调函数 */
    function updateCallBack(data) {
        if (data.success) {
            notice.success("用户更新成功！");
            //document.getElementById("newLabel").value="";
            $("#editUserModal").modal('hide');
            $("#group1Menu").find('li:first-child').click();
        } else {
            notice.danger(data.msg);
        }
    }
    /* 取消按钮 */
    function cancel() {
        $("#grid").find('input[type=checkbox]').each(function () {
            $(this).attr("checked", false);
        });
        $("#toolbar").removeClass("show");
    }

    /* 客服类型二级下拉框 */
    function secondLevel() {
        var parentId = document.getElementById("typeSelect").value;
        $("#passWord").val("");
        if (parentId == 1) {
            // 博乐宝需求 客户自动生成随机密码
            $("#passWord").val(Tools.createRandPwd(6));

            $('#secondTypeBox').hide();

            $("#star").css("display", "none");
            $("#addUserNameN").attr("placeholder", "");
        } else if (parentId == 2) {
            $('#secondTypeBox').show();

            $("#star").css("display", "inline-block");
            $("#addUserNameN").attr("placeholder", "管理员或客服必填");

            var id = "";
            if ("${userType1}" == "2" && "${roleId}" == "5") {
                id = "4";
            }
            $.post("<%=request.getContextPath()%>/usrManage/secondLevel?parentId=" + parentId + "&id=" + id, secondLevelCallBack, 'json');
        } else if (parentId == 3) {
            $('#secondTypeBox').hide();

            $("#star").css("display", "inline-block");
            $("#addUserNameN").attr("placeholder", "管理员或客服必填");
        } else {
            $('#secondTypeBox').hide();

            $("#star").css("display", "none");
            $("#addUserNameN").attr("placeholder", "");
        }
    }
    /* 客服类型二级下拉框回调函数 */
    function secondLevelCallBack(data) {
        if (data.success) {
            var $secondType = $("#secondType");
            $secondType.empty();
            for (var j = 0; j < data.rows.length; j++) {
                var sub = data.rows[j];
                $secondType.append('<option value="' + sub.id + '">' + sub.name + '</option>');
            }
        } else {
            notice.danger(data.msg);
        }
    }
    /*  邮箱格式校验 */
    function mailFormat(email) {
        var patrn = /^(\w)+(\.\w+)*@(\w)+((\.\w+)+)$/;
        if (patrn.test(email)) {
            return true;
        } else {
            notice.warning("请输入正确的邮箱格式！");
            return false;
        }
    }

    /*  手机校验 （1开头11位）*/
    function phoneFormat(telPhone) {
        //var patrn = /^1\d{10}$/;
//        var patrn = /^1\d{10}$|^[9][1]\d{10}$|^[9][0][1]\d{10}$/;
        var patrn = /^[0-9]*$/;
        if (patrn.test(telPhone)) {
            return true;
        } else {
            notice.warning("请输入正确的手机格式！");
            return false;
        }
    }
    function fixedPhoneFormat(telPhone) {
        var patrn = /^[0-9]*$/;
        if (patrn.test(telPhone)) {
            return true;
        } else {
            notice.warning("请输入正确的座机格式！");
            return false;
        }
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
    /*  用户按状态分类显示 */
    $("#status li").click(function () {
        $("#allSelect").prop("checked", false);
        $("#toolbar").removeClass("show");
        this.removeClass("active");

        $(this).addClass("active");
        var url = "";
        var roleId = null;
        var userStatus = getUserStatus($(this).text());
        $("#group1Menu li").each(function () {
            var style = $(this).attr("class");
            if (style == "active") {
                url = $(this).data("href");
                if (url.indexOf("role/list") >= 0) {
                    url = "<%=request.getContextPath()%>/userManageMongo/queryUser/7";
                    roleId = $(this).data("roleId");
                }
            }
        });
        getTableData({page: 1, rows: 10, entId: '${entId}', roleId: roleId, userStatus: userStatus}, url);
        $("#grid").show();
    });

    $("#dropdown1Select").find('li :checkbox').click(function (e) {
        //获取点击的事件
        var $that = $(this);
        var selecteKey = $that.val(), /**获取操作的key值**/
        flag = $that.prop("checked")/**获取是选中还是取消选中的标识**/;
        /**更改后端字段表的数据值**/
            //保存操作
        var url = '<%=request.getContextPath()%>/userField/fieldDistribute';
        data = {
            key: selecteKey,
            flag: flag,
            pageUrl: "userManage"
        };
        $.ajax({
            url: url,
            type: "post",
            dataType: "json",
            data: data,
            success: function (data) {
                if (data.success) {
                    //如果用户操作成功，刷新表头及数据
                    updateHeader()
                } else {
                    notice.warning("操作失败!");
                }
            }
        });
        function updateHeader() {

            //更新表头数据
            var fieldParam = {};
            $('#dropdown1Select').find(':checkbox[name=checkbox]:checked').each(function (i) {
                var $this = $(this);
                //单独加入头像列
                fieldParam["photoUrl"] = "头像";
                fieldParam[$this.val()] = $this.parent().text();
            });
            setUserTable(fieldParam);
            fieldNames = fieldParam;
            e.stopPropagation();
        }
    });
    function setUserTable(fieldNames) {
        var $tr = $('#userTableTr');
        $tr.empty().append('<th width="40"><input class="ember-view ember-checkbox all-checkbox" type="checkbox" id="allSelect"> </th>');
        for (var key in fieldNames) {
            $tr.append('<th width="150">' + fieldNames[key] + '</th>');
            if (key.indexOf('field') == 0) {
            }
        }
        $("#grid tbody").hide();
        refresh(fieldNames);
    }

    function refresh() {
        $("#queryBtn").click();
    }

    /* 校验手机号码是否已存在 */
    function existPhone(telPhone) {
        var result = "false";
        $.ajax({
            url: "<%=request.getContextPath()%>/userManageMongo/existsPhone1?telPhone=" + telPhone,
            type: "post",
            dataType: "json",
            async: false,
            data: {
                userInfos: "{'telPhone':'" + telPhone + "','entId':'${entId}'}",
            },
            success: function (data) {
                if (data.success) {
                    result = "true";
                } else {
                    notice.warning(data.msg);
                }
            }
        });
        return result;
    }

    function callout(telphone) {
        if (telphone != "") {
            parent.callOut(telphone);
        } else {
            notice.warning("号码为空!");
        }
    }

    // 添加用户,根据权限动态加载用户类型
    // @latest Lesty 2016.8.3
    function setTypeSelect() {
        // 选项内容HTML
        var optionHTML = "";
        if ("${isFounder}" == "1") { // 创始人
            optionHTML = '<option value="2">客服</option><option value="3">管理员</option>';
        } else if ("${userType1}" == "3" && "${roleId}" == "3" && "${isFounder}" != "1") { // 管理员
            optionHTML = '<option value="2">客服</option>';
        } else if ("${userType1}" == "2" && "${roleId}" == "4") { // 普通客服
            optionHTML = '';
        } else if ("${userType1}" == "2" && "${roleId}" == "5") { // 客服班长
            optionHTML = '<option value="2">客服</option>';
        }
        $("#typeSelect").empty().append(optionHTML);
    }

    /* 校验用户名是否已存在 */
    function checkName(name) {
        var result = false;
        $.ajax({
            url: "<%=request.getContextPath()%>/userManageMongo/checkUserName?userName=" + name,
            type: "post",
            dataType: "json",
            async: false,
            data: {
                userInfos: "{'userName':'" + name + "','entId':'${entId}'}",
            },
            success: function (data) {
                if (data.success) {
                    result = true;
                } else {
                    notice.warning(data.msg);
                }
            }
        });
        return result;
    }

    /* 校验登录账号是否已存在 */
    function checkLoginName(name) {
        var result = false;
        $.ajax({
            url: "<%=request.getContextPath()%>/userManageMongo/checkLoginName?loginName=" + name,
            type: "post",
            dataType: "json",
            async: false,
            data: {
                userInfos: "{'loginName':'" + name + "','entId':'${entId}'}",
            },
            success: function (data) {
                if (data.success) {
                    result = true;
                } else {
                    notice.warning(data.msg);
                }
            }
        });
        return result;
    }

    function gotoRoleUser(roleId) {
        $("#rightDiv").show();
        $("#rightIframe").hide().parent().css("overflow", "auto");
        $("#gridGroup").hide();
        $("#grid").hide();
        $("#group4Menu li.active").data("roleId", roleId);
        getTableData({
            page: 1,
            rows: 10,
            entId: '${entId}',
            roleId: roleId
        }, "<%=request.getContextPath()%>/userManageMongo/queryUser/7");
    }
</script>
</body>
</html>
