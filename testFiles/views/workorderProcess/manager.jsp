<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>工单流程管理</title>
    <%@include file="/views/include/pageHeader.jsp"%>
    <link href="<%=request.getContextPath()%>/static/css/selfField.css" type="text/css" rel="stylesheet">
	<%--<link href="<%=request.getContextPath()%>/static/css/ef3763efa8e67025e2caf0ced6deb474.css" type="text/css" rel="stylesheet">--%>
</head>
<body>
	<div class="container-fluid">
		<div class="panel" style="padding:20px;">
			<div class="kf5-section">
				<header class="kf5-list-header">
					<h3>启用的工单流程（${size1}）</h3>
				</header>
				<ul id="field_list" class="kf5-list1 move">
					<c:forEach items="${activeList}" var="item">
						<li>
							<div id="${item.tempId}" class="col-md-3">${item.tempName}</div>
							<div>														 
							
							<a class="btn-sm fr" href="<%=request.getContextPath()%>/workProcess/templateHandler?_id=${item._id}" target="_self">编辑</a>
<%-- 							<c:choose>                                                       
                               <c:when test="${item.statusChange==true}">
                                   <a class="btn-sm danger fr" href="javascript:void(0);" target="_self">停用</a>
                               </c:when>	
                            </c:choose> --%>	 								
							</div> 
							<input type="hidden" value="${item.tempId}" class="item-field-id">
						</li>
					</c:forEach>
				</ul>
			</div>
		</div>
		<div class="ps-scrollbar-x-rail">
			<div class="ps-scrollbar-x"></div>
		</div>
		<div class="ps-scrollbar-y-rail">
			<div class="ps-scrollbar-y"></div>
		</div>
	</div>
</body>

</html>
