<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>外呼活动</title>
    <%@include file="/views/include/pageHeader.jsp" %>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/static/css/innerFrame.css">
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/static/css/teleActivity.css">
	<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/script/lib/select2-4.0.3/dist/css/select2.css">
    <script src="<%=request.getContextPath()%>/script/lib/PCASClass.js"></script>
	<script src="<%=request.getContextPath()%>/script/lib/select2-4.0.3/dist/js/select2.js"></script>
	<script src="<%=request.getContextPath()%>/script/lib/select2-4.0.3/dist/js/i18n/zh-CN.js"></script>
</head>
<body>
<div id="teleActivityApp">
    <%--左侧菜单组件--%>
    <%--监听select-menu事件--%>
    <left-menu :is-open="isLeftOpen"
               top-title="外呼活动"
               v-on:select-menu="selectMenu(arguments[0])">
    </left-menu>


    <%--右侧部分--%>
    <div :class="['tele-activity__right-part', {'tele-activity__right-part_open': !isLeftOpen}]">
        <!-- 路由出口 -->
        <!-- 路由匹配到的组件将渲染在这里 -->
        <router-view :top-title="rightTopTitle"></router-view>
    </div>
</div>

<script>
    /**
     * 包含全局通用的一些内置数据
     * Lesty 2017.3.30
     **/
    var USER_G = {
        userType: '${userType}',
        userId: '${userId}'
    };

    /**
	 * @deprecated
	 * 请调用 openNameDetailsTab方法
     * @desc 打开名单详情页
     * @namesId String [名单id]
     * @title String [新标签的标题]
     */
    function openNameDetails(namesId, title, evt){
		evt && evt.stopPropagation();
        title = title != null ? title : namesId;

        var url = location.origin + "/teleActivity/detail?namesId=" + namesId + "&loginTime=" + '${loginTime}';
        // 这里将首次打开刷新设为true
        // 考虑到用户从活动管理打开名单详情，然后又从我的活动打开同个名单详情
        // 这时候如果不刷新，用户执行不了打电话等操作
        top.openTab(url, "user", '名单-' + title, true);
    }

    /**
	 * 打开名单详情Tab
	 * @param {Object} {namesId,title,reservationId,teleActivityId}
	 */
    function openNameDetailsTab(param,evt){
    	evt && evt.stopPropagation();
    	var namesId = param.namesId;
    	if(namesId === undefined || namesId === null || namesId.trim() === ""){
			return ;
		}
		var	title = param.title ? param.title : namesId,
			queryStr = Object.keys(param).map(function(key,index){
				return key + "=" + param[key];
			}).join("&"),
    		url   = location.origin + "/teleActivity/detail?loginTime=" + '${loginTime}&' + queryStr;
		top.openTab(url,"user",'名单-' + title, true);
	}

	/**
	 * 进行外呼
	 * @deprecated
	 * 请调用  openCallTab方法
	 * @param telPhone
	 * @param teleActivityId
	 * @param namesId
	 * @param evt
	 */
    function openCall(telPhone,teleActivityId,namesId,disNumber,evt) {
        console.log(namesId);
		evt && evt.stopPropagation();
        top.callOut(telPhone,true,{
            teleActivityId : teleActivityId,
            namesId        : namesId,
			disNumber      : disNumber
        });
    }

	/**
	 * 外呼
	 * @param param
	 * 	{
	 * 		telPhone       : 外呼号码[required],
	 * 		teleActivityId : 活动ID[required],
	 * 		namesId        : 名单ID[required],
	 * 		reserveId      : 预约ID[required]
	 * 		disNumber      : 外显号码[required]
	 * 	}
	 * @param evt
	 */
	function openCallTab(param,evt){
		evt && evt.stopPropagation();
		var telPhone = param.telPhone;
		if(telPhone === undefined || telPhone === null || telPhone.trim() === ""){
			return ;
		}
		top.callOut(telPhone,true,param);
	}
</script>

<script type="text/javascript" src="<%=request.getContextPath()%>/vue-static/dist/manifest.js"></script>

<script type="text/javascript" src="<%=request.getContextPath()%>/vue-static/dist/vendor.js"></script>

<script type="text/javascript" src="<%=request.getContextPath()%>/vue-static/dist/build.js"></script>
</body>
</html>
