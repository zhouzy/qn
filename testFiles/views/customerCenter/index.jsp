<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="zh-cmn-Hans">
<head>
    <meta charset="utf-8">
    <title>客户中心</title>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/static/css/normalize.css">
    <link href="<%=request.getContextPath()%>/script/lib/font-awesome/css/font-awesome.min.css" rel="stylesheet">
</head>
<body>
<div id="customerCenterApp"></div>

<script src="<%=request.getContextPath()%>/script/lib/lodash.min.js"></script>
<script>
    // 全局用到的信息
    var INFO_G = {
        // 上下文路径
        contextPath: '<%=request.getContextPath()%>',
        // 用户头像地址
        userPhotoUrl: '${photoUrl}',
        // 用户名
        userName: '${user.userName}'
    };
</script>
<script type="text/javascript" src="<%=request.getContextPath()%>/vue-static/dist/manifest.js"></script>

<script type="text/javascript" src="<%=request.getContextPath()%>/vue-static/dist/vendor.js"></script>

<script type="text/javascript" src="<%=request.getContextPath()%>/vue-static/dist/customer-center-app.js"></script>
</body>
</html>
