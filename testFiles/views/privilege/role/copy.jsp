<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>复制角色</title>
    <%@include file="/views/include/pageHeader.jsp"%>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/static/css/privilege.css">
</head>
<body id="home">
<div class="panel-wrap panel" style="background: #fff;margin: 0 15px;">
<ul class="breadcrumbs">
	<li>
		<a href="<%=request.getContextPath()%>/role/list">客服权限和角色</a>
	</li>
	<li>复制角色</li>
</ul>
<form id="roleForm">
<div class="field t-col">
	<h4>角色名称</h4>
	<div class="t-col-content mb20"><input type="text" value="复制：${role.name}" name="name" id="roleName" /></div>
</div>
<div class="field t-col">
	<h4>角色描述</h4>
	<div class="t-col-content">
		<textarea class="shuru" rows="3" cols="80" name="description" id="roleDesc">${role.description}</textarea>
		<p class="hint">对该设定的角色进行描述，将显示在具体用户选择角色的页面</p>
	</div>
</div>
</form>
<form id="permissionForm">
    <hr />
<c:forEach items="${permissionList}" var="item">
	<div class="field t-col">
		<h4>
		<label>
		<c:choose>
			<c:when test="${item.check}"><input type="checkbox" checked="checked" name="${item.id}" /></c:when>
			<c:otherwise><input type="checkbox" name="${item.id}" /></c:otherwise>
		</c:choose>
		${item.name}
		</label>
		</h4>
        <div class="t-col-content mb20">
            <c:if test="${item.hasChildren == true && item.children[0].type == '0'}">
                <c:if test="${item.name == '外呼活动'}">
                    <div class="mb5">
                        <label>
                            能查看哪些活动：
                            <select name="filterActivityRange" id="filterActivityRange">
                                <option value="3" selected="selected">全部</option>
                                <option value="2">组内</option>
                                <option value="1">我的</option>
                            </select>
                        </label>
                    </div>
                </c:if>
            </c:if>
            <c:if test="${item.hasChildren == true && item.children[0].type == '1'}">
            <div class="mb5">
                <div class="menu-permission"
                        <c:if test="${item.name == '客户管理' || item.name == '联络历史' || item.name == '工单中心'}">
                            style="top: -13px;"
                        </c:if>
                        >
                    </c:if>
                    <c:forEach items="${item.children}" var="item2">
                        <c:if test="${item2.type == '0'}">
                            <div class="mb5">
                                <label>
                                    <c:choose>
                                        <c:when test="${item2.check}">
                                            <input type="checkbox" checked="checked" name="${item2.id}" />
                                        </c:when>
                                        <c:otherwise>
                                            <input type="checkbox" name="${item2.id}" />
                                        </c:otherwise>
                                    </c:choose>
                                        ${item2.name}</label>
                                <div class="menu-permission">
                                    <c:forEach items="${item2.children}" var="item3">
                                        <label>
                                            <c:choose>
                                                <c:when test="${item3.check}">
                                                    <input type="checkbox" checked="checked" name="${item3.id}" />
                                                </c:when>
                                                <c:otherwise>
                                                    <input type="checkbox" name="${item3.id}" />
                                                </c:otherwise>
                                            </c:choose>
                                                ${item3.name}</label>
                                    </c:forEach>
                                </div>
                            </div>
                        </c:if>
                        <c:if test="${item2.type == '1'}">
                            <label>
                                <c:choose>
                                    <c:when test="${item2.check}">
                                        <input type="checkbox" checked="checked" name="${item2.id}" />
                                    </c:when>
                                    <c:otherwise>
                                        <input type="checkbox" name="${item2.id}" />
                                    </c:otherwise>
                                </c:choose>
                                    ${item2.name}</label>
                        </c:if>
                    </c:forEach>
                    <c:if test="${item.hasChildren == true && item.children[0].type == '1'}">
                </div>
                <c:if test="${item.name == '客户管理'}">
                    <div class="menu-permission" style="top: 17px;">
                        <label>
                            数据权限：
                            <select name="filterRoleRange" id="filterRoleRange">
                                <option value="3" selected="selected">全部</option>
                                <option value="2">组内</option>
                                <option value="1">我的</option>
                            </select>
                        </label>
                    </div>
                </c:if>
                <c:if test="${item.name == '工单中心'}">
                    <div class="menu-permission" style="top: 17px;">
                        <label>
                            数据权限：
                            <select name="filterWorkRange" id="filterWorkRange">
                                <option value="3" selected="selected">全部</option>
                                <option value="2">组内</option>
                                <option value="1">我的</option>
                            </select>
                        </label>
                    </div>
                </c:if>
                <c:if test="${item.name == '联络历史'}">
                    <div class="menu-permission" style="top: 17px;">
                        <label>
                            数据权限：
                            <select name="filterHistoryRange" id="filterHistoryRange">
                                <option value="3" selected="selected">全部</option>
                                <option value="2">组内</option>
                                <option value="1">我的</option>
                            </select>
                        </label>
                    </div>
                </c:if>
            </div>
            </c:if>
        </div>
	</div>
	<hr />
</c:forEach>
    <div class="field">
        <button id="cancelBtn" class="btn btn-sm btn-raised" type="button">取消</button>
        <button id="formSubmit" class="btn btn-sm btn-raised btn-primary" type="button" style="margin-left: 10px">提交</button>
    </div>
</form>
</div>
<script type="text/javascript">
    $(function () {
        $("#filterRoleRange").val('${role.filterRoleRange}');
        $("#filterWorkRange").val('${role.filterWorkRange}');
        $("#filterHistoryRange").val('${role.filterHistoryRange}');
        $("#filterActivityRange").val('${role.filterActivityRange}');

        // 初始化所有复选框勾选状态
        initCheckboxStatus();

        // 注册事件
        regEvent();
    });

    /*
     * @desc [初始化所有复选框勾选状态]
     * @author Lesty
     * @codeDate 2016.10.12
     * */
    function initCheckboxStatus() {
        $('#permissionForm').find('.field > h4 input[type=checkbox]').each(function () {
            var $this = $(this);
            // 根据勾选状态做不同处理
            if ($this.prop('checked') === true) { // 如果是勾选状态
                var $childCheckbox = $this.closest('.field').find('.mb5 > label > input[type=checkbox]');

                if($childCheckbox.length === 0) { // 如果二级菜单不存在
                    // 子菜单设为菜单权限
                    $childCheckbox = $this.closest('.field').find('.menu-permission input[type=checkbox]');
                } else {
                    $childCheckbox.each(function () {
                        childMenuCheckboxChange(this);
                    });
                }

                // 子菜单恢复可操作状态
                $childCheckbox.prop('disabled', false).parent('label').removeClass('disabled');
            } else { // 如果是取消勾选状态
                $this.closest('.field').find('.mb5 input[type=checkbox]').prop('checked', false).prop('disabled', true).parent('label').addClass('disabled');
            }
        });
    }

    /*
     * @desc [主菜单checkbox改变勾选状态]
     * */
    function mainMenuCheckboxChange(checkboxEle) {
        var $checkbox = $(checkboxEle);

        // 根据勾选状态做不同处理
        if ($checkbox.prop('checked') === true) { // 如果是勾选状态
            var $childCheckbox = $checkbox.closest('.field').find('.mb5 > label > input[type=checkbox]');
            // 如果二级菜单不存在
            if($childCheckbox.length === 0) {
                // 子菜单设为菜单权限
                $childCheckbox = $checkbox.closest('.field').find('.menu-permission input[type=checkbox]');
            }

            // 子菜单恢复可操作状态
            $childCheckbox.prop('disabled', false).parent('label').removeClass('disabled');
        } else { // 如果是取消勾选状态
            // 所有子菜单变成不可操作状态并设置checkbox状态为不勾选
            $checkbox.closest('.field').find('.mb5 input[type=checkbox]').prop('checked', false).prop('disabled', true).parent('label').addClass('disabled');
        }
    }

    /*
     * @desc [二级子菜单checkbox改变勾选状态]
     * */
    function childMenuCheckboxChange(checkboxEle) {
        var $checkbox = $(checkboxEle);

        // 根据勾选状态做不同处理
        if ($checkbox.prop('checked') === true) { // 如果是勾选状态
            // 菜单权限恢复可操作状态
            $checkbox.closest('.mb5').find('.menu-permission input[type=checkbox]').prop('disabled', false).parent('label').removeClass('disabled');
        } else { // 如果是取消勾选状态
            // 菜单权限变成不可操作状态并设置checkbox状态为不勾选
            $checkbox.closest('.mb5').find('.menu-permission input[type=checkbox]').prop('checked', false).prop('disabled', true).parent('label').addClass('disabled');
        }
    }

    function updateCallBack(data) {
        if (data.success) {
            notice.alert(data.msg);
            window.location.href = "<%=request.getContextPath()%>/role/list";
        } else {
            notice.alert(data.msg, 'alert-danger');
        }
    }

    function regEvent() {
        // 取消编辑
        $('#cancelBtn').on('click', function () {
            // 这里使用js的click事件，因为jquery触发器不会触发元素默认事件(而是触发你绑定的事件)
            // @latest Lesty 2016.10.12
            $('.breadcrumbs').find('li:eq(0) > a')[0].click();
        });

        // 提交表单
        $("#formSubmit").click(function () {
            var name = $("#roleName").val();
            // 用户选择的所有权限id
            var permissionIds = [];
            var description = $("#roleDesc").val();
            var pFormArr = $("#permissionForm").serializeArray();
            for (var i = 0; i < pFormArr.length; i++) {
                var item = pFormArr[i];
                if(item.name == "filterRoleRange" || item.name == "filterWorkRange" || item.name == "filterHistoryRange" || item.name=="filterActivityRange"){
                    continue;
                }

                permissionIds.push(item.name);
            }
            var filterRoleRange = $("#filterRoleRange").val();
            var filterWorkRange = $("#filterWorkRange").val();
            var filterHistoryRange = $("#filterHistoryRange").val();
            var filterActivityRange=$("#filterActivityRange").val();
            $.post("<%=request.getContextPath()%>/role/copyRole/" + permissionIds.join(','), {
                filterRoleRange: filterRoleRange,
                filterWorkRange: filterWorkRange,
                filterHistoryRange: filterHistoryRange,
                filterActivityRange:filterActivityRange,
                description: description,
                name: name
            }, updateCallBack, 'json');
        });

        // 监听主菜单checkbox勾选状态
        $('#permissionForm').find('.field > h4').on('click', 'input[type=checkbox]', function () {
            // 主菜单checkbox改变勾选状态
            mainMenuCheckboxChange(this);
        });

        // 监听子菜单checkbox勾选状态
        $('#permissionForm').find('.mb5 > label').on('click', 'input[type=checkbox]', function () {
            // 二级子菜单checkbox改变勾选状态
            childMenuCheckboxChange(this);
        });
    }
</script>
</body>
</html>