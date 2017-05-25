<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>功能管理首页</title>
	<%@include file="/views/include/pageHeader_refact.jsp" %>
	<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/static/css/functionManage.css">
</head>
<body>
<div id="left-part" class="page__left-sidebar">
	<div class="qn-container">
		<header class="qn-container__header">
			功能管理
		</header>
		<div class="qn-container__body">
			<c:if test="${hasGroup1}">
				<div class="qn-nav-bar">
					<div class="qn-nav-bar__header">工单管理</div>
					<ul class="qn-nav-bar__list" id="group1Menu">
						<c:forEach items="${permissionList}" var="item">
							<c:if test="${item.groupId == '1'}">
								<li class="qn-nav-bar__list-item" id="li${item.id}" data-href="${item.url}" data-isajax="${item.isAjax}"><a>${item.name}</a></li>
							</c:if>
						</c:forEach>
					</ul>
				</div>
			</c:if>

			<c:if test="${hasGroup2}">
				<div class="qn-nav-bar">
					<div class="qn-nav-bar__header">客户管理</div>
					<ul class="qn-nav-bar__list" id="group2Menu">
						<c:forEach items="${permissionList}" var="item">
							<c:if test="${item.groupId == '2'}">
								<li class="qn-nav-bar__list-item" id="li${item.id}" data-href="${item.url}" data-isajax="${item.isAjax}"><a>${item.name}</a></li>
							</c:if>
						</c:forEach>
					</ul>
				</div>
			</c:if>

			<c:if test="${hasGroup3}">
				<div class="qn-nav-bar">
					<div class="qn-nav-bar__header">其它管理</div>
					<ul class="qn-nav-bar__list" id="group3Menu">
						<c:forEach items="${permissionList}" var="item">
							<c:if test="${item.groupId == '3'}">
								<li class="qn-nav-bar__list-item" id="li${item.id}" data-href="${item.url}" data-isajax="${item.isAjax}"><a>${item.name}</a></li>
							</c:if>
						</c:forEach>
					</ul>
				</div>
			</c:if>
		</div>
	</div>

	<div class="toggle-btn-box">
		<button class="toggle-btn" id="leftToggleBtn"><i class="fa fa-angle-left" aria-hidden="true" style="font-size: 20px;"></i></button>
	</div>
</div>
<div id="right-part" class="page__main">
	<div id="rightPartHeader" class="page__main-header"></div>
	<div class="page__main-content">
		<iframe name="iframe" id="rightIframe" style="display:none" width="100%" height="100%" src="" frameborder="0" data-id="index_v1.html" seamless></iframe>
    </div>
</div>
<script>
    $(document).ready(function () {
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
		bindLeftMenuEvt();
        $("#left-part .qn-nav-bar__list-item:eq(0)").click();
    });

    /**
	 * 绑定左侧菜单栏点击事件
     */
    function bindLeftMenuEvt(){
        $("#left-part .qn-nav-bar__list-item").click(function(){
            $("#left-part li").removeClass("active");
            $(this).addClass("active");
            $("#rightPartHeader").text($(this).find("a").text());
            if ($(this).data("isajax") == '1') {
                $("#rightDiv").show();
                $("#rightIframe").hide();
                $("#gridGroup").hide();
                $("#paginationTR").show();
                $("#paginationForgTR").hide();
                $("#toolbar").removeClass("show");
                getTableData({page:1,rows:10,entId:'${entId}'},$(this).data("href"));
                $("#grid").show();
            }
            else {
                $("#rightDiv").hide();
                $("#rightIframe").show().attr('src',$(this).data("href"));
            }
        });
	}
</script>
</body>
</html>
