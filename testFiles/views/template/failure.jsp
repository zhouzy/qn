<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="utf-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>异常</title>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/static/css/normalize.css">
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/static/css/404.css">
</head>
<body >
<div class="gray-bg">
    <div class="middle-box text-center animated fadeInDown">
        <img src="<%=request.getContextPath()%>/static/images/kuqibiaoqi.png"></img>
        <h2 class="font-bold">哎呀...出错了</h2>

        <div class="operation">
            <div class="lianjie">
                <a href="#"><img src="<%=request.getContextPath()%>/static/images/refresh.png"><div>刷新一下</div></a>
            </div>
            ${exception}
        </div>
    </div>
</div>
</body>
</html>
