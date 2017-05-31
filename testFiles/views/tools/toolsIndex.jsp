<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>第三方工具使用首页</title>
    <%@include file="/views/include/pageHeader.jsp" %>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/static/css/innerFrame.css">
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/static/css/3fbfa3e735aef8c14de31eb189be21f6.css">
    <style type="text/css">
        .left-part-list li a:hover {
            background: #eff4f5 none repeat scroll 0 0;
        }
        .tips{
            position: absolute;
            top: 45%;
            width:100%;
            text-align: center;
            font-size: larger;
        }
    </style>
</head>
<body>
<div id="left-part">
    <div class="main-contain">
        <div class="left-content">
            <div class="left-content-panel">
                <ul class="left-content-panel-body left-part-list" id="group1Menu">
                    <c:forEach items="${activeList}" var="item">
                        <li id="li${item.integrationId}" data-href="${item.integrationUrl}"><a>${item.integrationName}</a></li>
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
        <span></span>
    </header>
    <div class="right-content" style="padding-top:55px;">
        <div class="tips">此页面空空如也<br>请移步功能管理中添加您常用的链接!</div>
        <iframe name="iframe" id="rightIframe" width="100%" height="100%" frameborder="0" style="display: block;" seamless></iframe>
    </div>
</div>

<script>
    $(function () {
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
            $("#left-part .left-content-panel li").removeClass("active");
            $(this).addClass("active");
            $("#right-part .part-header").text($(this).find("a").text());
            $("#rightIframe").show().attr('src',$(this).data("href"));
        });
        if($("#left-part .left-content-panel li").length==0){
            $(".tips").show();
        }else {
            $("#left-part .left-content-panel:first-child li:first-child").click();
            $(".tips").hide();
        }
    });
</script>
</body>
</html>
