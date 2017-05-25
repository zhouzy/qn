<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>名单详情</title>
    <%@include file="/views/include/pageHeader.jsp" %>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/static/css/innerFrame.css">
</head>
<body>
<div id="listDetailApp"></div>

<!-- 发送短信弹窗 -->
<%@include file="/views/teleActivity/teleActivitySendNoteModal.jsp" %>
<script src="<%=request.getContextPath()%>/script/lib/PCASClass.js"></script>

<script>
    /**
     * 手动生成entId，兼容发送短信modal
     * Lesty 2017.3.28
     **/
    var href = location.href;
    var start = href.indexOf('//') + 2;
    var end = href.indexOf('.');
    var USER_G = {
        entId: href.substring(start, end),
        userType: '${userType}',
        userId: '${userId}',
        contextPath: '<%=request.getContextPath()%>'
    };
</script>

<script type="text/javascript" src="<%=request.getContextPath()%>/vue-static/dist/manifest.js"></script>

<script type="text/javascript" src="<%=request.getContextPath()%>/vue-static/dist/vendor.js"></script>

<script type="text/javascript" src="<%=request.getContextPath()%>/vue-static/dist/list-detail-app.js"></script>
</body>
</html>
