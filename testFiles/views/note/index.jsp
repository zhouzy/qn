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
    <link data-origin-file="index.css" rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/static/css/index.css">

	<script src="<%=request.getContextPath()%>/script/lib/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
	<script src="<%=request.getContextPath()%>/script/lib/bootstrap-datetimepicker-master/js/locales/bootstrap-datetimepicker.zh-CN.js"></script>
</head>
<body>
<div id="left-part">
    <div class="main-contain">
        <header class="part-header">短信管理</header>
        <div class="left-content">
            <div class="left-content-panel">
                <ul class="left-content-panel-body left-part-list" id="group1Menu">
                    <c:forEach items="${permissionList}" var="item">
                        <c:if test="${item.groupId == '1'}">
                            <li id="li${item.id}" data-href="${item.url}" data-isajax="${item.isAjax}"><a>${item.name}</a></li>
                        </c:if>
                    </c:forEach>
                    <!-- 添加短信群发信息 -->
                    <%-- <li id= "liMessageMass" data-href = "<%=request.getContextPath()%>/note/mass" data-isajax = "0"><a>短信群发</a></li> --%>
                </ul>
            </div>

        </div>
    </div>

    <div class="toggle-btn-box">
        <button class="toggle-btn" id="leftToggleBtn"><i class="fa fa-angle-left" aria-hidden="true" style="font-size: 20px;"></i></button>
    </div>
</div>
<div id="right-part">
    <iframe name="iframe" id="rightIframe" style="display:none;" width="100%" height="100%" src="" frameborder="0" seamless></iframe>
</div>
    <script>
        $(document).ready(function() {
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

            $("#left-part .left-content-panel li").click(function(){
                lid=$(this).attr("id");
                $("#left-part .left-content-panel li").removeClass("active");
                $(this).addClass("active");
                $("#right-part .part-header").text($(this).find("a").text());
                if ($(this).data("isajax") == '1') {
                    $("#rightDiv").show();
                    $("#rightIframe").hide();
                    $("#gridGroup").hide();
                    $("#paginationTR").show();
                    $("#paginationForgTR").hide();
                    $("#toolbar").removeClass("show");
                    getTableData({page:1,rows:10,entId:'${entId}'});
                    $("#grid").show();
                }
                else {
//                    $("#rightDiv").hide();
                    $("#rightIframe").css({
                        display: 'block'
                    }).attr('src',$(this).data("href"));
					
                }
            });

            $("#left-part .left-content-panel:first-child li:first-child").click();
        });
    </script>
</body>
</html>