<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>订单信息</title>
    <%@include file="/views/include/pageHeader.jsp"%>
    <%@page import="org.apache.commons.lang.StringUtils" %>
    <%@page import="java.util.*" %>
    <%@page import="com.mongodb.DBObject" %>
    <%@page import="com.channelsoft.ems.user.po.DatEntUserPo" %>
    <%@page import="com.channelsoft.ems.communicate.constant.CommSource" %>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/script/lib/summernote/summernote.css">
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/static/css/innerFrame.css">
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/static/css/blbOrderDetail.css">
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/static/css/bd5f50f4aa8111d7bd43cd1fd95713e7.css">
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/script/lib/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.css">
    <script src="<%=request.getContextPath()%>/script/lib/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
    <script src="<%=request.getContextPath()%>/script/lib/bootstrap-datetimepicker-master/js/locales/bootstrap-datetimepicker.zh-CN.js"></script>
    <script src="<%=request.getContextPath()%>/script/lib/summernote/summernote.js" ></script>
    <script src="<%=request.getContextPath()%>/script/lib/summernote/summernote-zh-CN.js" ></script>
    <script src="<%=request.getContextPath()%>/script/lib/PCASClass.js"></script>
</head>
<body>
<div id="left-part">
    <div class="left-content">
        <div class="left-content-panel">
            <div class="left-content-panel-header" style="font-weight: 700;font-size: 20px;">${user.userName}</div>
            <ul class="left-content-panel-body left-part-list" id="group1Menu">
                <li><a href="#userInfoId">基本信息</a></li>
                <li><a href="#BLBWorkInfoId">订单详情</a></li>
            </ul>
        </div>
    </div>
</div>
<div id="right-part">
    <div class="right-content">
        <div class="container-fluid">
            <div class="row" id="userInfoId">
                <div class="col-lg-12 col-md-12">
                    <div class="panel" id="top">
                        <div class="container-fluid">
                            <div class="row">
                                <div class="col-lg-3 col-md-3">
                                    <div class="user-info" >
                                        <a class="user-avatar" id="avatar">
                                            <img id="userPhoto" src="${photoUrl}" alt="" title="修改头像">
                                        </a>
                                        <h4>
                                            <input id="name" class="ember-view ember-text-field" type="text" data-name="userName">
                                        </h4>
                                        <div class="drop-btn-default">
                                            <!-- 用户状态 -->
                                            <div id="status" class="dropdown">
                                                <a id="dLabel" data-target="#" data-toggle="dropdown" data-role="button" aria-haspopup="true" aria-expanded="false">
                                                                                                                                                状态<span class="status green">正常</span>
                                                </a>
                                            </div>
                                            <!-- 遮罩层 -->
                                            <div id="wrap" class="wrap">
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-lg-9 col-md-9">
                                    <div class="row form-horizontal" id="userFieldUlUp" style="display: none">
                                        <!-- 1:字符串 2:文本框 3:下拉框 4:复选框 6:数字 7:小数 8:正则表达式 9:电话号码 10:时间输入框 -->
                                        <c:set var="curCount" value="1" />
                                        <c:forEach items="${activeFieldList}" var="item">
                                            <c:if test="${curCount <= 6}">
                                                <c:choose>
                                                    <c:when test="${item.componentType=='1'}">
                                                        <div class="col-sm-6">
                                                            <c:set value="${user[item.key]}" var="fieldKey" scope="request"></c:set>
                                                            <input id="${item.key}" data-label="${item.name}" type="text" data-required="${item.isRequired}" data-name="${item.key }" value="${fieldKey}">
                                                        </div>
                                                    </c:when>

                                                    <c:when test="${item.componentType=='2'}">
                                                        <div class="col-sm-6" data-comp-type="textarea">
                                                            <div class="form-group">
                                                                <label class="control-label col-sm-4">${item.name}</label>
                                                                <c:set value="${user[item.key]}" var="fieldKey" scope="request"></c:set>
                                                                <div class="col-sm-8">
                                                                    <textarea id="${item.key }" class="form-control" rows="4" data-required="${item.isRequired}" data-name="${item.key }" >${fieldKey}</textarea>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </c:when>

                                                    <c:when test="${item.componentType=='3'}">
                                                        <div class="col-sm-6">
                                                            <div class="form-group">
                                                                <label class="control-label col-sm-4">${item.name}</label>
                                                                <div class="col-sm-8">
                                                                    <select id="${item.key }" data-name="${item.key }" data-required="${item.isRequired}" class="form-control">
                                                                        <option value="">-</option>
                                                                        <c:forEach items="${item.candidateValue}" var="selectItems">
                                                                            <option value="${selectItems }">${selectItems }</option>
                                                                        </c:forEach>
                                                                    </select>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </c:when>

                                                    <c:when test="${item.componentType=='4'}">
                                                        <div class="col-sm-6">
                                                            <div class="form-group">
                                                                <label class="control-label col-sm-4">${item.name}</label>
                                                                <div class="col-sm-8 checkbox">
                                                                    <c:set var="checkIndex" value="0" />
                                                                    <c:forEach items="${item.candidateValue}" var="checkItems">
                                                                        <label>
                                                                            <c:set var="isChecked" value=""/>
                                                                            <c:if test="${checkItems == user[item.key][checkIndex]}">
                                                                                <c:set var="isChecked" value="checked"/>
                                                                                <c:set var="checkIndex" value="${checkIndex + 1}"/>
                                                                            </c:if>

                                                                            <input type="checkbox" value="${checkItems}" name="${item.key}" data-required="${item.isRequired}" ${isChecked}>${checkItems}
                                                                        </label>
                                                                    </c:forEach>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </c:when>

                                                    <c:when test="${item.componentType=='6'}">
                                                        <div class="col-sm-6">
                                                            <c:set value="${user[item.key]}" var="fieldKey" scope="request"></c:set>
                                                            <input id="${item.key}" type="text" data-label="${item.name}" size="30" data-required="${item.isRequired}" data-name="${item.key }" data-field="${item.name }" data-reg="^-?\d+$" value="${fieldKey}">
                                                        </div>
                                                    </c:when>

                                                    <c:when test="${item.componentType=='7'}">
                                                        <div class="col-sm-6">
                                                            <c:set value="${user[item.key]}" var="fieldKey" scope="request"></c:set>
                                                            <input id="${item.key }" type="text" data-label="${item.name}" data-required="${item.isRequired}" data-name="${item.key}" data-field="${item.name }" data-reg="^-?\d+\.\d+$" value="${fieldKey}">
                                                        </div>
                                                    </c:when>

                                                    <c:when test="${item.componentType=='8'}">
                                                        <div class="col-sm-6">
                                                            <c:set value="${user[item.key]}" var="fieldKey" scope="request"></c:set>
                                                            <c:forEach items="${item.candidateValue}" var="reg">
                                                                <input id="${item.key }" type="text" data-field-type="regular" data-label="${item.name}" data-required="${item.isRequired}" data-name="${item.key}" data-field="${item.name }" data-reg="${reg}" value="${fieldKey}">
                                                            </c:forEach>
                                                        </div>
                                                    </c:when>

                                                    <c:when test="${item.componentType=='9'}">
                                                        <div class="col-sm-6">
                                                            <c:set value="${user[item.key]}" var="fieldKey" scope="request"></c:set>
                                                            <c:forEach items="${item.candidateValue}" var="reg">
                                                                <input id="${item.key }" type="text" data-field-type="phone" data-label="${item.name}" data-required="${item.isRequired}" data-name="${item.key}" data-field="${item.name}" data-reg="${reg}" value="${fieldKey}">
                                                            </c:forEach>
                                                        </div>
                                                    </c:when>

                                                    <c:when test="${item.componentType=='10'}">
                                                        <div class="col-sm-6">
                                                            <c:set value="${user[item.key]}" var="fieldKey" scope="request"></c:set>
                                                            <c:forEach items="${item.candidateValue}" var="reg">
                                                                <input id="${item.key }" type="text" data-type="datetimepicker" data-required="${item.isRequired}" data-name="${item.key}" data-field="${item.name }" data-reg="${reg}" data-label="${item.name}" value="${fieldKey}">
                                                            </c:forEach>
                                                        </div>
                                                    </c:when>
                                                    <c:when test="${item.componentType=='11'}">
                                                        <div class="col-sm-12">
                                                            <div class="form-group">
                                                                <div class="col-sm-2 " style="text-align: right">
                                                                    <label class="control-label">${item.name}</label>
                                                                </div>
                                                                <div class="col-sm-10">
                                                                    <div class="row" data-field-type="pca">
                                                                        <div class="col-sm-4">
                                                                            <div><select class="form-control" name="province_${item.key}" id="Company_province${item.key}" data-required="${item.isRequired}" style="box-shadow: none;"></select></div>
                                                                        </div>
                                                                        <div class="col-sm-4">
                                                                            <div><select class="form-control" name="city_${item.key}" id="Company_city${item.key}" style="box-shadow: none;"></select></div>
                                                                        </div>
                                                                        <div class="col-sm-4">
                                                                            <div><select class="form-control" name="area_${item.key}" id="Company_area${item.key}" style="box-shadow: none;"></select></div>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>

                                                        <c:set value="${user[item.key]}" var="fieldKey" scope="request"></c:set>
                                                        <input id="${item.key}" value="${fieldKey}" type="hidden">
                                                    </c:when>
                                                </c:choose>
                                            </c:if>
                                            <c:set var="curCount" value="${curCount + 1}" />
                                        </c:forEach>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-sm-12">
                                    <!-- 自定义字段 -->
                                    <div class="row">
                                        <div class="col-sm-12 text-right">
                                            <a id="openOrClose" onclick="openOrClose()" class="unfold btn btn-default btn-sm btn-block" style="margin-top: 0">
                                                <span id="open">展开</span>
                                            </a>
                                        </div>
                                    </div>
                                    <div id="userFieldUlDown" class="row form-horizontal" style="display:none;padding-bottom: 30px;">
                                        <!-- 1:字符串 2:文本框 3:下拉框 4:复选框 6:数字 7:小数 8:正则表达式 9:电话号码 10:时间输入框 -->
                                        <c:set var="curIndex" value="1" />
                                        <c:forEach items="${activeFieldList}" var="item">
                                            <c:if test="${curIndex > 6}">
                                                <c:choose>
                                                    <c:when test="${item.componentType=='1'}">
                                                        <div class="col-sm-6">
                                                            <c:set value="${user[item.key]}" var="fieldKey" scope="request"></c:set>
                                                            <input id="${item.key}" data-label="${item.name}" type="text" data-required="${item.isRequired}" data-name="${item.key }" value="${fieldKey}">
                                                        </div>
                                                    </c:when>

                                                    <c:when test="${item.componentType=='2'}">
                                                        <div class="col-sm-6" data-comp-type="textarea">
                                                            <div class="form-group">
                                                                <label class="control-label col-sm-4">${item.name}</label>
                                                                <c:set value="${user[item.key]}" var="fieldKey" scope="request"></c:set>
                                                                <div class="col-sm-8">
                                                                    <textarea id="${item.key }" class="form-control" rows="4" data-required="${item.isRequired}" data-name="${item.key }" >${fieldKey}</textarea>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </c:when>

                                                    <c:when test="${item.componentType=='3'}">
                                                        <div class="col-sm-6">
                                                            <div class="form-group">
                                                                <label class="control-label col-sm-4">${item.name}</label>
                                                                <div class="col-sm-8">
                                                                    <select id="${item.key }" data-name="${item.key }" data-required="${item.isRequired}" class="form-control">
                                                                        <option value="">-</option>
                                                                        <c:forEach items="${item.candidateValue}" var="selectItems">
                                                                            <option value="${selectItems }">${selectItems }</option>
                                                                        </c:forEach>
                                                                    </select>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </c:when>

                                                    <c:when test="${item.componentType=='4'}">
                                                        <div class="col-sm-6">
                                                            <div class="form-group">
                                                                <label class="control-label col-sm-4">${item.name}</label>
                                                                <div class="col-sm-8 checkbox">
                                                                    <c:set var="checkIndex" value="0" />
                                                                    <c:forEach items="${item.candidateValue}" var="checkItems">
                                                                        <label>
                                                                            <c:set var="isChecked" value=""/>
                                                                            <c:if test="${checkItems == user[item.key][checkIndex]}">
                                                                                <c:set var="isChecked" value="checked"/>
                                                                                <c:set var="checkIndex" value="${checkIndex + 1}"/>
                                                                            </c:if>

                                                                            <input type="checkbox" value="${checkItems}" name="${item.key}" data-required="${item.isRequired}" ${isChecked}>${checkItems}
                                                                        </label>
                                                                    </c:forEach>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </c:when>

                                                    <c:when test="${item.componentType=='6'}">
                                                        <div class="col-sm-6">
                                                            <c:set value="${user[item.key]}" var="fieldKey" scope="request"></c:set>
                                                            <input id="${item.key}" type="text" data-label="${item.name}" size="30" data-required="${item.isRequired}" data-name="${item.key }" data-field="${item.name }" data-reg="^-?\d+$" value="${fieldKey}">
                                                        </div>
                                                    </c:when>

                                                    <c:when test="${item.componentType=='7'}">
                                                        <div class="col-sm-6">
                                                            <c:set value="${user[item.key]}" var="fieldKey" scope="request"></c:set>
                                                            <input id="${item.key }" type="text" data-label="${item.name}" data-required="${item.isRequired}" data-name="${item.key}" data-field="${item.name }" data-reg="^-?\d+\.\d+$" value="${fieldKey}">
                                                        </div>
                                                    </c:when>

                                                    <c:when test="${item.componentType=='8'}">
                                                        <div class="col-sm-6">
                                                            <c:set value="${user[item.key]}" var="fieldKey" scope="request"></c:set>
                                                            <c:forEach items="${item.candidateValue}" var="reg">
                                                                <input id="${item.key }" type="text" data-field-type="regular" data-label="${item.name}" data-required="${item.isRequired}" data-name="${item.key}" data-field="${item.name }" data-reg="${reg}" value="${fieldKey}">
                                                            </c:forEach>
                                                        </div>
                                                    </c:when>

                                                    <c:when test="${item.componentType=='9'}">
                                                        <div class="col-sm-6">
                                                            <c:set value="${user[item.key]}" var="fieldKey" scope="request"></c:set>
                                                            <c:forEach items="${item.candidateValue}" var="reg">
                                                                <input id="${item.key }" type="text" data-field-type="phone" data-label="${item.name}" data-required="${item.isRequired}" data-name="${item.key}" data-field="${item.name}" data-reg="${reg}" value="${fieldKey}">
                                                            </c:forEach>
                                                        </div>
                                                    </c:when>

                                                    <c:when test="${item.componentType=='10'}">
                                                        <div class="col-sm-6">
                                                            <c:set value="${user[item.key]}" var="fieldKey" scope="request"></c:set>
                                                            <c:forEach items="${item.candidateValue}" var="reg">
                                                                <input id="${item.key }" type="text" data-type="datetimepicker" data-required="${item.isRequired}" data-name="${item.key}" data-field="${item.name }" data-reg="${reg}" data-label="${item.name}" value="${fieldKey}">
                                                            </c:forEach>
                                                        </div>
                                                    </c:when>
                                                    <c:when test="${item.componentType=='11'}">
                                                        <div class="col-sm-12">
                                                            <div class="form-group">
                                                                <div class="col-sm-2 " style="text-align: right">
                                                                    <label class="control-label">${item.name}</label>
                                                                </div>
                                                                <div class="col-sm-10">
                                                                    <div class="row" data-field-type="pca">
                                                                        <div class="col-sm-4">
                                                                            <div><select class="form-control" name="province_${item.key}" id="Company_province${item.key}" data-required="${item.isRequired}" style="box-shadow: none;"></select></div>
                                                                        </div>
                                                                        <div class="col-sm-4">
                                                                            <div><select class="form-control" name="city_${item.key}" id="Company_city${item.key}" style="box-shadow: none;"></select></div>
                                                                        </div>
                                                                        <div class="col-sm-4">
                                                                            <div><select class="form-control" name="area_${item.key}" id="Company_area${item.key}" style="box-shadow: none;"></select></div>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>

                                                        <c:set value="${user[item.key]}" var="fieldKey" scope="request"></c:set>
                                                        <input id="${item.key}" value="${fieldKey}" type="hidden">
                                                    </c:when>
                                                </c:choose>
                                            </c:if>

                                            <c:set var="curIndex" value="${curIndex + 1}" />
                                        </c:forEach>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-lg-12 col-md-12">
                    <div class="panel link-history" id="BLBWorkInfoId">
                        <div class="panel-heading">订单详情</div>
                        <div class="row" id="order">
                            <div class="col-lg-9 col-md-9">
                                <div class="row form-horizontal">                                                                               
                                    <div class="col-sm-6">
                                         <div class="form-group">
                                              <label class="control-label col-sm-4">订单日期</label>
                                              <div class="col-sm-8">
                                                  <input id="dorderdate" type="text" class="form-control" value="${order.dorderdate}">
                                              </div>
                                         </div>
                                    </div>                                      
                                    <div class="col-sm-6">
                                         <div class="form-group">
                                              <label class="control-label col-sm-4">SN号</label>
                                              <div class="col-sm-8">
                                                  <input id="cinvsn" type="text" class="form-control" value="${order.cinvsn}">
                                              </div>
                                         </div>
                                    </div>                                                                          
                                    <div class="col-sm-6">
                                         <div class="form-group">
                                              <label class="control-label col-sm-4">交易编号</label>
                                              <div class="col-sm-8">
                                                  <input id="ctranh" type="text" class="form-control" value="${order.ctranh}">
                                              </div>
                                         </div>
                                    </div>   
                                    <div class="col-sm-6">
                                         <div class="form-group">
                                              <label class="control-label col-sm-4">客户编码</label>
                                              <div class="col-sm-8">
                                                  <input id="cuscode" type="text" class="form-control" value="${order.cuscode}">
                                              </div>
                                         </div>
                                    </div>                                     
                                    <div class="col-sm-6">
                                         <div class="form-group">
                                              <label class="control-label col-sm-4">客户名称</label>
                                              <div class="col-sm-8">
                                                  <input id="cusname" type="text" class="form-control" value="${order.cusname}">
                                              </div>
                                         </div>
                                    </div>                                    
                                    <div class="col-sm-6">
                                         <div class="form-group">
                                              <label class="control-label col-sm-4">销售订单号</label>
                                              <div class="col-sm-8">
                                                  <input id="cordercode" type="text" class="form-control" value="${order.cordercode}">
                                              </div>
                                         </div>
                                    </div>
                                    <div class="col-sm-6">
                                         <div class="form-group">
                                              <label class="control-label col-sm-4">发货单号</label>
                                              <div class="col-sm-8">
                                                  <input id="cdispcode" type="text" class="form-control" value="${order.cdispcode}">
                                              </div>
                                         </div>
                                    </div>                                      
                                    <div class="col-sm-6">
                                         <div class="form-group">
                                              <label class="control-label col-sm-4">出库单号</label>
                                              <div class="col-sm-8">
                                                  <input id="cckcode" type="text" class="form-control" value="${order.cckcode}">
                                              </div>
                                         </div>
                                    </div> 
                                    <div class="col-sm-6">
                                         <div class="form-group">
                                              <label class="control-label col-sm-4">出库日期</label>
                                              <div class="col-sm-8">
                                                  <input id="dckdate" type="text" class="form-control" value="${order.dckdate}">
                                              </div>
                                         </div>
                                    </div>                                                                           
                                    <div class="col-sm-6">
                                         <div class="form-group">
                                              <label class="control-label col-sm-4">存货编码</label>
                                              <div class="col-sm-8">
                                                  <input id="cinvcode" type="text" class="form-control" value="${order.cinvcode}">
                                              </div>
                                         </div>
                                    </div>                                     
                                    <div class="col-sm-6">
                                         <div class="form-group">
                                              <label class="control-label col-sm-4">存货名称</label>
                                              <div class="col-sm-8">
                                                  <input id="cinvname" type="text" class="form-control" value="${order.cinvname}">
                                              </div>
                                         </div>
                                    </div>                                    
                                    <div class="col-sm-6">
                                         <div class="form-group">
                                              <label class="control-label col-sm-4">规格型号</label>
                                              <div class="col-sm-8">
                                                  <input id="cinvstd" type="text" class="form-control" value="${order.cinvstd}">
                                              </div>
                                         </div>
                                    </div>
                                    <div class="col-sm-6">
                                         <div class="form-group">
                                              <label class="control-label col-sm-4">数量</label>
                                              <div class="col-sm-8">
                                                  <input id="iquantity" type="text" class="form-control" value="${order.iquantity}">
                                              </div>
                                         </div>
                                    </div>                                      
                                    <div class="col-sm-6">
                                         <div class="form-group">
                                              <label class="control-label col-sm-4">单价</label>
                                              <div class="col-sm-8">
                                                  <input id="iprice" type="text" class="form-control" value="${order.iprice}">
                                              </div>
                                         </div>
                                    </div>                                                                          
                                    <div class="col-sm-6">
                                         <div class="form-group">
                                              <label class="control-label col-sm-4">收货人姓名</label>
                                              <div class="col-sm-8">
                                                  <input id="ckhname" type="text" class="form-control" value="${order.ckhname}">
                                              </div>
                                         </div>
                                    </div>                                     
                                    <div class="col-sm-6">
                                         <div class="form-group">
                                              <label class="control-label col-sm-4">联系电话</label>
                                              <div class="col-sm-8">
                                                  <input id="cphone" type="text" class="form-control" value="${order.cphone}">
                                              </div>
                                         </div>
                                    </div>  
                                    <div class="col-sm-6">
                                         <div class="form-group">
                                              <label class="control-label col-sm-4">收货人省</label>
                                              <div class="col-sm-8">
                                                  <input id="cprovince" type="text" class="form-control" value="${order.cprovince}">
                                              </div>
                                         </div>
                                    </div>                                      
                                    <div class="col-sm-6">
                                         <div class="form-group">
                                              <label class="control-label col-sm-4">收货人市</label>
                                              <div class="col-sm-8">
                                                  <input id="scity" type="text" class="form-control" value="${order.scity}">
                                              </div>
                                         </div>
                                    </div>                                                                          
                                    <div class="col-sm-6">
                                         <div class="form-group">
                                              <label class="control-label col-sm-4">收货人区</label>
                                              <div class="col-sm-8">
                                                  <input id="cdistrict" type="text" class="form-control" value="${order.cdistrict}">
                                              </div>
                                         </div>
                                    </div>                                     
                                    <div class="col-sm-6">
                                         <div class="form-group">
                                              <label class="control-label col-sm-4">收货人地址</label>
                                              <div class="col-sm-8">
                                                  <textarea id="caddress" class="form-control" rows="4">${order.caddress}</textarea>
                                              </div>
                                         </div>
                                    </div>                                    
                                    <div class="col-sm-6">
                                         <div class="form-group">
                                              <label class="control-label col-sm-4">备注</label>
                                              <div class="col-sm-8">
                                                  <textarea id="cmemo" class="form-control" rows="4">${order.cmemo}</textarea>
                                              </div>
                                         </div>
                                    </div>                                                                                                     
                                </div>
                           </div>
                        </div>
                    </div>
                </div>
            </div> 

        </div>
    </div>
</div>

<div id="right-new">
    <div class="right-content">
        <div>
            <div class="right-content-panel-header" style="font-weight: 700;font-size: 20px;">客户订单</div>            
            <div id="orderList"></div>
        </div>
    </div>
</div>

<script id="order-list-template" type="text/x-handlebars-template">
	<div class="col-lg-12 col-md-12">
		<div class="panel link-history">	
           <ul>
              <li>
                 <div style="font-weight:bold">
                     <label>订单号:</label><span id="ordercode">{{cordercode}}</span>
                 </div>
              </li>
              <li>
                 <div>
                     <label>订单日期:</label><span>{{dorderdate}}</span>
                 </div>
              </li>
		      <li>
                 <div>
                     <label>SN号:</label><span>{{cinvsn}}</span>
                 </div>
              </li>
              <li>
                 <div style="display:none">
                     <label>存货编码:</label><span id="invcode">{{cinvcode}}</span>
                 </div>
              </li>
           </ul>
        </div>	
	</div>
</script>

<!-- 发送短信弹窗 -->
<%@include file= "/views/userManage/modal/sendNoteModal.jsp"%>

<script type="text/javascript">
    var user = {
        userId:'${user.userId}', // 用户id
        roleId: '${user.roleId}', // 权限类别
        userType:'${user.userType}',//1:客户 2:坐席 3:管理员
        loginName:"${user.loginName}", // 登陆账号
        email:"${user.email}", // 邮箱
        userStatus: "${user.userStatus}", // 用户状态
        userName:"${user.userName}", // 用户名
        fixedPhone:"${user.fixedPhone}",
        remark:"${user.remark}",
        userDesc:"${user.userDesc}",
        entId: '${user.entId}',
        signature:"${user.signature}",
        serviceGroupId: '${user.serviceGroupId}',
        telPhone : '${user.telPhone}'
    };
    
    var USER_G = ${user};

    //客户订单列表
    var getOrderListTableData = (function(){
        var paramCache = {};

        return function(param){
            $.ajax({
                url: "<%=request.getContextPath()%>/userManageMongo/getBLBOrderList",
                dataType: 'json',
                data: {
                    telPhone: user.telPhone,
                    page: 1,
                    rows: 10
                },
                success: function(data) {
                    if (!(data.success)) {
                        notice.alert(data.msg);
                        return;
                    }

                    if(data.rows != null) {
                        createOrderListTable(data.rows);
                    }
                    
                    $.extend(paramCache, param);
                }
            });
        }
    })();
    
    //生成右侧订单小方框
    var createOrderListTable = (function(){
        var trTemp = Handlebars.compile($("#order-list-template").html());
		var $orderTable = $("#orderList");
        
        return function (tableData) {
        	var html = [];
        	var order = null;
        	
            for (var i = 0, len = tableData.length; i < len; i++) {          	
                order = tableData[i];
                var $tr = $(trTemp(order));
                html.push($tr);
            }
            
            $orderTable.empty().append(html);
            
            $('#orderList').find('.link-history').on('click', function() {
            	var $_my = $(this);
            	$.post('<%=request.getContextPath()%>/userManageMongo/getBLBOrderListDetail', {
            		cordercode: $_my.find('#ordercode').text(),
            		cinvcode: $_my.find('#invcode').text()
            	}, function(data) {
                    if (!(data.success)) {
                        notice.alert(data.msg);
                        return;
                    }

                    if(data.rows != null) {
                        for(var key in data.rows){
                        	$("#"+key).val(data.rows[key]);
                        }
                    }
            	})
            });
        };
    })();
    
    /**
     * 用户字段表单
     */
    var userModel = function(user){
        return {
            render:function(){
                $("#name").val(user.userName);

                $("#avatar").hover(function() {$(this).addClass("hover");}, function(){$(this).removeClass("hover");});

                $('#userFieldUlUp').show();
            }
        };
    }(user);

    /**
     * 用户自定义字段模块
     */
    var userFieldModule = function(){
        var $container = $('#userFieldUlDown, #userFieldUlUp');
        $container.find('[data-required]').each(function(){
            var $this = $(this);
            if($this.attr('data-required') === 'true'){
                $this.prop('required',true);
            }
        });

        var _validator = function(){
            return $container.validator();
        };

        /*
         * @desc 自定义字段选择框初始化
         * */
        function selectInit() {
            // 用户角色option内容
            var userTypeHtml = '<option value="1">客户</option><option value="2">客服</option><option value="3">管理员</option>';
            $("#userType").empty().html(userTypeHtml);

            /* 自定义字段下拉框类型赋值 */
            var u = ${user};
               $container.find('select').each(function () {
               var id = $(this).attr("id");
               $(this).val(u[id]);
            });       
        }

        /*
         * @desc 自定义字段输入框框初始化
         * */
        function inputInit() {
            var $datetimepicker = $container.find('input[data-type=datetimepicker]');
            // 生成短信和电话图标
            var spanHtml = '<span style="position: absolute;right: 30px;"><a onclick="callOut(this, event)" style="padding: 10px;"><i class="fa fa-phone"></i></a>' +
                    '<a onclick="sendNoteWin(this, event)" data-toggle="modal" data-target="#sendNoteModal" style="padding: 10px;"><i class="fa fa-envelope"></i></a></span>';

            $container.find('input[type=text][data-name]').not('[data-type=datetimepicker]').each(function() {
                var $input = $(this);
                $input.input({
                    onChange:function(){
                    }
                });

                // 手机号码
                if($input.data('fieldType') === 'phone' || $input.attr('id') === 'telPhone' || $input.attr('id') === 'fixedPhone') {
                    $input.parent().removeClass('col-sm-8').addClass('col-sm-5').after(spanHtml);
                }
            });

            if($datetimepicker.length){
                $datetimepicker.each(function(){
                    var $input = $(this),
                            dateformat = $(this).attr('data-reg'),
                            label = $input.attr('data-label');
                    var isHMS = /hh|ss/.test(dateformat);
                    $input.timeInput({
                        format:dateformat,
                        HMS:isHMS,
                        label:label,
                        value:$input.val(),
                        change:function(){
                        }
                    });
                });
            }
        }

        /*
         * @desc 自定义字段复选框初始化
         * */
        function checkBoxInit() {
            // 暂时用jstl解决初始化问题
        }

        /*
         * @desc 省市区字段初始化
         * */
        function PCAInit() {
            //省市区字段初始化
            var $pcaGroup = $('#userFieldUlUp div.row[data-field-type=pca], #userFieldUlDown div.row[data-field-type=pca]');
            $pcaGroup.each(function() {
                var fieldKey = $(this).find('select')[0].name.split('_')[1];
                var pcaArr = $('#' + fieldKey).val().split(',');

                var province = pcaArr[0];
                var city = pcaArr[1];
                var area = pcaArr[2];

                new PCAS("province_" + fieldKey, "city_" + fieldKey, "area_" + fieldKey, province, city, area);
            });
        }

        /**
         * @desc 初始化客服组相关字段
         * */
        function initServiceGroupInput() {
            // 归属客服
            var $serviceInput = $("#serviceName");
            // 归属客服组
            var $serviceGroupInput = $("#serviceGroupName");

            // 打开的页面不是客户就返回
            if(UserType.get() !== '1'){
                return;
            }

            $serviceInput.attr({
                "name": "serviceName",
            });

            $serviceGroupInput.attr({
                "name": "serviceGroupName",
            });
        }

        return {
            render: function(){
                inputInit();
                selectInit();
                checkBoxInit();
                PCAInit();
                initServiceGroupInput();

                $('#userFieldUlDown > .col-sm-6, #userFieldUlUp > .col-sm-6').not('[data-comp-type]').css({
                    height: '45px'
                });
                $('#userFieldUlDown > div.col-sm-6[data-comp-type], #userFieldUlUp > div.col-sm-6[data-comp-type]').css({
                    height: '90px'
                });

                // 必填字段label追加红色星号
                $('#userFieldUlDown [required], #userFieldUlUp [required]').closest('.form-group').find('.control-label').append('<span style="color: red;position: absolute;">*</span>');
            }
        };
    }();

    /*
     * @author Lesty
     * @codeDate 2016.8.16
     * @desc 用户角色对象
     * */
    var UserType = (function() {
        var $userType = $('#userType');

        function get() {
            return $userType.val();
        }

        function set(userType) {
            $userType.val(userType);
        }

        /*
         * @desc 根据state设置用户角色是否可操作
         * */
        function disabled(state) {
            $userType.prop('disabled', state);
        }

        return {
            get: get,
            set: set,
            disabled: disabled
        };
    })();

    /*
     * @author Lesty
     * @codeDate 2016.8.16
     * @desc 角色权限对象
     * */
    var RoleId = (function() {
        // 角色权限select框
        var $roleId = $('#roleId');
        // 整个角色权限字段
        var $roleIdField = $roleId.closest('.col-sm-6');

        function get() {
            return $roleId.val();
        }

        function set(roleId) {
            $roleId.val(roleId);
        }

        /*
         * @desc 根据state设置角色权限是否可操作
         * */
        function disabled(state) {
            $roleId.prop('disabled', state);
        }

        /*
         * @desc 根据state设置角色权限隐藏或显示
         * */
        function visible(state) {
            state === true ? $roleIdField.show() : $roleIdField.hide();
        }

        /*
         * @desc 根据数据生成角色权限下拉框
         * @rows Array [角色权限数据]
         * @toModal Boolean [true: 初始化权限编辑窗口]
         * */
        function resetRoleId(rows, toModal) {
            // 临时Option数据
            var sub = null;

            // 清空选择框
            $roleId.empty();
            // 生成选项
            for (var j = 0, len = rows.length; j < len; j++) {
                sub = rows[j];
                $roleId.append('<option value="' + sub.id + '">' + sub.name + '</option>');
            }

            if(toModal) {
                // 初始化权限编辑窗口
                rolePermissionModal.init(data.rows);
            } else {
                // 选择自身对应的选项(如果没有，则select内容为空白)
                $roleId.val(user.roleId);
            }
        }

        /*
         * @desc [生成坐席客服权限下拉框]
         * @userType String [坐席客服角色id]
         * @toModal Boolean [true: 初始化权限编辑窗口]
         * */
        function getOptions(userType, toModal) {
            // 获取坐席客服权限
            $.post("<%=request.getContextPath()%>/usrManage/secondLevel?parentId=" + userType, function(data) {
                if (data.success) {
                    // 生成角色权限
                    resetRoleId(data.rows, toModal);
                    //显示角色权限
                    visible(true);
                } else {
                    notice.danger(data.msg);
                }
            }, 'json');
        }

        return {
            get: get,
            set: set,
            disabled: disabled,
            visible: visible,
            getOptions: getOptions
        };
    })();

    /*
     * @author Lesty
     * @codeDate 2016.8.16
     * @desc 用户状态对象
     * */
    var Status = (function() {
        // 所有span状态
        var $statusSpans = $('#status').find('span.status');
        // 下拉框status列表
        var $wrap = $('#wrap');
        // 当前状态
        var curStatus = '';
        // 状态对照表
        var _status = {
            "1": ['status green', '正常'],
            "3": ['status blue', '未审核'],
            "4": ['status red', '停用'],
            "9": ['status red', '已删除']
        };

        function init(status) {
            /*
             * 每次都需要初始化的方法放这里
             * */
            // 设置当前用户状态
             if(!statusCheck(status)) {
                notice.warning('状态码不正确，用户状态初始化失败-。-');
                return;
            } else if(status === '9') {
                 notice.warning('该用户已被删除-。-');
             }

            set(status);
        }

        function get() {
            return curStatus;
        }

        function set(status) {
            curStatus = status;

            var i = 1;
            // 更新当前状态以及状态下拉框内容
            for(var code in _status){
                if(status == code){ // 当前状态
                    $($statusSpans[0]).removeClass().addClass(_status[code][0]).text(_status[code][1]).data('status', code);
                } 
            }
        }

        function statusCheck(status) {
            return (status in _status);
        }

        /*
         * @desc 根据state设置用户状态是否可操作
         * */
        function disabled(state) {
            // 通过隐藏和显示遮罩层实现disabled操作
            state === true ? $wrap.show() : $wrap.hide();
        }
        
        return {
            init: init,
            get: get,
            set: set,
            disabled: disabled
        };
    })();

    /*
     * @author Lesty
     * @codeDate 2016.8.16
     * @desc 客服组对象
     * */
    var Group = (function() {
        // 分配客服组按钮
        var $assignGroup = $('#assign');

        /*
         * @desc 根据state设置分配客服组按钮隐藏或显示
         * */
        function visible(state) {
            state === true ? $assignGroup.show() : $assignGroup.hide();
        }

        return {
            visible: visible
        };
    })();

    /*
     * @author Lesty
     * @codeDate 2016.8.16
     * @desc 登录账号对象
     * */
    var LoginName = (function() {
        var $loginName = $('#loginName');

        function get() {
            return $loginName.val();
        }

        function set(name) {
            $loginName.val(name);
        }

        /*
         * @desc 根据state设置用户角色是否只读
         * */
        function readonly(state) {
            $loginName.prop('readonly', state);
        }

        return {
            get: get,
            set: set,
            readonly: readonly
        };
    })();

    /*
    * @desc [坐席工号]
    * */
    var AgentId = (function() {
        var $agentId = $('#agentId');
        // 整个坐席工单控件字段
        var $agentIdField = $agentId.closest('.col-sm-6');
        
        function get() {
            return $agentId.val();
        }

        function set(id) {
            $agentId.val(id);
        }

        /*
         * @desc 根据state设置是否只读
         * */
        function readonly(state) {
            $agentId.prop('readonly', state);
        }

        /*
         * @desc 根据state设置控件隐藏或显示
         * */
        function visible(state) {
            state === true ? $agentIdField.show() : $agentIdField.hide();
        }

        return {
            get: get,
            set: set,
            readonly: readonly,
            visible: visible
        }
    })();

    /*
     * @desc [归属客服组]
     * */
    var ServiceGroupName = (function() {
        var $serviceGroup = $('#serviceGroupName');
        // 整个控件字段
        var $serviceGroupField = $serviceGroup.closest('.col-sm-6');

        function getName() {
            return $serviceGroup.val();
        }

        function getId() {
            return $serviceGroup.data('serviceGroupId');
        }

        function disabled(state) {
            $serviceGroup.prop('disabled', state);
        }

        /*
         * @desc 根据state设置控件隐藏或显示
         * */
        function visible(state) {
            state === true ? $serviceGroupField.show() : $serviceGroupField.hide();
        }

        return {
            getName: getName,
            getId: getId,
            disabled: disabled,
            visible: visible
        }
    })();

    /*
     * @desc [归属客服]
     * */
    var ServiceName = (function() {
        var $service = $('#serviceName');
        // 整个控件字段
        var $serviceField = $service.closest('.col-sm-6');

        function getName() {
            return $service.val();
        }

        function getId() {
            return $service.data('serviceId');
        }

        function disabled(state) {
            $service.prop('disabled', state);
        }

        /*
         * @desc 根据state设置控件隐藏或显示
         * */
        function visible(state) {
            state === true ? $serviceField.show() : $serviceField.hide();
        }

        return {
            getName: getName,
            getId: getId,
            disabled: disabled,
            visible: visible
        }
    })();

    $(function() {
        // 用户信息初始化
        userModel.render();
        // 用户自定义字段渲染
        userFieldModule.render();
        
        Status.init(user.userStatus);//初始化用户状态显示
        
        // 权限控制
        initUserPermission(UserType.get());
        
        //订单详情信息只读
        $("#order").find('input[type=text], textarea').each(function(){
        	$(this).prop('readonly', true);
        });
        
        getOrderListTableData({
            telPhone: user.telPhone,
            page: 1,
            rows: 10
        });
    });

    /*
    * @desc [根据flag判断能否修改个人信息]
    * @flag Boolean [true/不传: 能修改，false: 不能]
    * */
     function canModifyInfo(flag) {
        // 只读元素
        var $toReadOnlyEles = $("#top input, #top textarea");
        // 不可操作元素
        var $toDisabledEles = $("#top input[type=checkbox], #top select");
        var $dateEles = $('#top input[data-type=datetimepicker]').closest('.timeInputGroup').find('input, button');
        if(flag === false) {
            $toReadOnlyEles.prop('readonly', true);
            $toDisabledEles.prop('disabled', true);
            $dateEles.prop('disabled', true);
        } else {
            $toReadOnlyEles.prop('readonly', false);
            $toDisabledEles.prop('disabled', false);
            $dateEles.prop('disabled', false);
        }
    } 

    /*
    * @notice 没有把握，请勿轻易修改该函数，修改请留下修改日期及修改人姓名-。-
    * @userType String [当前打开页面的用户类别]
    * @latest Lesty 2016.9.13
    *
    * @more lately taotaotaoa 2016.10.21
    * */
     var initUserPermission = function (userType) {
        // 角色权限隐藏
        RoleId.visible(false);
        // 分配客服组按钮隐藏
        Group.visible(false);
        // 隐藏客户归属客服组
        ServiceGroupName.visible(false);
        // 隐藏客户归属客服
        ServiceName.visible(false);

        if(userType === "1") { // 打开的是客户页面
            // 隐藏坐席工号
            AgentId.visible(false);
            // 显示客户归属客服组
            ServiceGroupName.visible(true);
            // 显示客户归属客服
            ServiceName.visible(true);
        }
        
        //订单详情页用户信息不可修改  
        canModifyInfo(false);
    }; 

    //发送短信弹窗
    function sendNoteWin(ele, event) {
        event.preventDefault();
        var telPhone = $(ele).closest('.form-group').find('input').val().trim();
        var errorMsg = '';

        if(telPhone === '') {
            errorMsg = "电话号码不能为空-。-";
        } else if(!Tools.phoneCheck(telPhone)) {
            errorMsg = "电话号码格式不合法-。-";
        }

        if(errorMsg != '') {
            $('#sendNoteModal').modal('hide');
            notice.warning(errorMsg);
            event.stopImmediatePropagation();
            return;
        }

        // 初始化短信弹窗
        sendNoteModal.init(telPhone);
    }

    /*
     * @desc [软电话外呼]
     * */
    function callOut(ele, event){
        event.preventDefault();
        var telPhone = $(ele).closest('.form-group').find('input').val().trim();
        var errorMsg = '';

        if(telPhone === '') {
            errorMsg = "电话号码不能为空-。-";
        } else if(!Tools.phoneCheck(telPhone)) {
            errorMsg = "电话号码格式不合法-。-";
        }

        if(errorMsg !== '') {
            notice.warning(errorMsg);
            return;
        }

        parent.callOut(telPhone);
    }

    // 自定义字段输入内容展开或收起
    function openOrClose(){
        var $userFieldUl = $("#userFieldUlDown");
        if($userFieldUl.is(':visible')){
            $("#open").text('展开');
            $userFieldUl.slideUp();
        }
        else{
            $("#open").text('收起');
            $userFieldUl.slideDown();
        }
    }
</script>
</body>
</html>