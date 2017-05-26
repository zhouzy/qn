<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>我的活动</title>
    <%@include file="/views/include/pageHeader.jsp"%>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/static/css/normalize.css">
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/static/css/order.css">
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/static/css/b3529a1dc910d3089e33688fcd88c2ba.css">
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/script/lib/summernote/summernote.css">
	<%--<script src="http://123.56.112.31/IM/IM.js"></script>--%>

    <%-- 开发环境 --%>
    <script src='${IM_ROOT}/IM.js'></script> 

    <%-- 测试环境 
    <script src='http://115.28.16.107/IM/IM.js'></script>
    --%>
</head>
<body>
<header class="head">
    <div class="wrap header-inner">
        <div class="logo">
            <img src="<%=request.getContextPath()%>/static/images/logo.png" />
        </div>
        
       <!-- <a href="javascript:void(0)" id="WebIM" class="support-btn" >帮助</a> --> 
                
        <nav class="header-nav">
            <ul class="header-nav-list">
            	
                <li>
                    <a href="<%=request.getContextPath()%>/newquestion/index">提交工单</a>
                </li>
                  <li>
                  <%-- <a href="<%=request.getContextPath()%>/login">退出</a> --%>
                  <a id="logoutBtn" href="javascript:void(0);">退出</a>
                  </li>
            </ul>
            <div class="user-nav">
            	<% if (request.getAttribute("user") != null) { %>
                <div class="dropdown profile-element" style="padding:0px;">
                    <a data-toggle="dropdown" class="dropdown-toggle user" href="#">
                        <span class="avatar">
                            <img alt="image" class="img-circle" src="${photoUrl}" style="width: 60px;">
                        </span>
  						<span class="text-muted text-xs block username">${user.userName}</span>
                    </a>
              
                </div>
                <%} else { %>
                <div class="user-info">
                    <div class="dropdown-toggle">
							<span class="user-info-name">
								<a href="<%=request.getContextPath()%>/login">登录</a>
							</span>
                    </div>
                </div>
				<%} %>
        
            </div>
        </nav>
    </div>
</header>
<div class="main-content">
    <div class="left-part">
        <header>
            <div>个人中心</div>
        </header>
        <nav class="nav-list">
            <ul id="navBtns">
                <li data-link="#myQuestion"><span class="glyphicon glyphicon-question-sign" aria-hidden="true"></span> 我的工单</li>
                <li data-link="#myDetail"><span class="glyphicon glyphicon-user" aria-hidden="true"></span> 我的资料</li>
            </ul>
        </nav>
    </div>
    <div class="right-part">
        <header>
            <div id="curTitle"></div>
        </header>
        <div class="right-content" id="rightContent">
            <!-- 我的工单 -->
            <div class="container-fluid" id="myQuestion" style="padding: 0 40px">
                <div class="row">
                    <div class="col-md-12">
                        <div class="query-content">
                            <div class="col-md-8">
                                <form class="form-inline row">
                                    <div class="form-group col-md-6">
                                        <label for="orderStatus" class="control-label">工单状态：</label>
                                        <select class="form-control" id="orderStatus" style="width: 150px">
                                            <option value="-1">全部</option>
                                            <option value="0">尚未受理</option>
                                            <option value="1">受理中</option>
                                            <option value="2">等待回复</option>
                                            <option value="3">已解决</option>
                                            <option value="4">已关闭</option>
                                        </select>
                                    </div>
                                </form>
                            </div>
                            <div class="col-md-4">
                                <div class="row" style="line-height: 57px">
                                    <div class="col-md-3">
                                        <a href="javascript:void(0)" class="btn btn-xs btn-raised btn-primary" id="queryBtn">查询</a>
                                    </div>
                                    <div class="col-md-3">
                                        <a href="javascript:void(0)" class="btn btn-xs btn-raised" id="clearBtn">重置</a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-12 grid">
                        <div class="table-content">
                            <table class="table" cellspacing="0" cellpadding="0">
                                <thead>
                                <tr>
                                    <th>编号</th>
                                    <th>标题</th>
                                    <th>工单状态</th>
                                    <th>工单创建日期</th>
                                    <th>受理组</th>
                                    <th>受理人</th>
                                </tr>
                                </thead>

                                <tbody id="myQlist"></tbody>

                                <tfoot>
                                <tr>
                                    <td colspan="6">
                                        <div id="pagination"></div>
                                    </td>
                                </tr>
                                </tfoot>
                            </table>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 我的资料-普通用户所现 -->
            <div class="container-fluid" id="myDetail" style="padding: 0 40px; display: none">
                <nav class="detail-pills">
                        <ul class="pills-list" id="detailPills" style="margin-bottom: 15px;">
                            <li class="active" data-type="baseInfo">基本信息</li>
                            <li data-type="modifyPwd">修改密码</li>
                        </ul>
                </nav>

                <section id="detailSections">
                    <div class="base-info" id="baseInfo">
                        <div class="head-portrait">
                            <img class="circle-pic" id="photoUrl" src="${photoUrl}">
                            <a href="javascript:void(0)" id="uploadPortrait" class="btn btn-info">
                                <span>修改头像</span>
                            </a>
                        </div>

                        <div class="row">
                            <div class="col-md-6">
                                <form class="form-horizontal" id="baseInfoForm" method="post">
                                    <div class="form-group">
                                        <label for="email" class="col-md-2 control-label">邮箱：</label>
                                        <div class="col-md-8">
                                            <input type="email" class="form-control" id="email" name="email" value="${user.email}" placeholder="输入你的邮箱">
                                        </div>
                                    </div>

                                    <div class="form-group">
                                        <label for="nickName" class="col-md-2 control-label">昵称：</label>
                                        <div class="col-md-8">
                                            <input type="input" class="form-control" id="nickName" name="nickName" value="${user.nickName}" placeholder="输入你的昵称">
                                        </div>
                                    </div>

                                    <div class="form-group">
                                        <label for="userDesc" class="col-md-2 control-label">描述：</label>
                                        <div class="col-md-8">
                                            <textarea class="form-control" rows="3" id="userDesc" name="userDesc">${user.userDesc}</textarea>
                                            <span class="help-block">在上方文本框内输入你的描述或者个性签名</span>
                                        </div>
                                    </div>

                                    <div class="form-group">
                                        <div class="col-md-offset-2">
                                            <button type="submit" class="btn btn-primary" id="submitBtn">提交修改</button>
                                        </div>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>

                    <div class="base-info" id="modifyPwd" style="display: none">
                        <div class="row">
                            <div class="col-md-6">
                                <form class="form-horizontal" id="modifyPwdForm" method="post">
                                    <div class="form-group">
                                        <label for="password" class="col-md-3 control-label">旧密码：</label>
                                        <div class="col-md-8">
                                            <input type="password" class="form-control" id="password" name="password"  placeholder="输入你的旧密码" required>
                                        </div>
                                    </div>

                                    <div class="form-group">
                                        <label for="newPassword" class="col-md-3 control-label">新密码：</label>
                                        <div class="col-md-8">
                                            <input type="password" class="form-control" id="newPassword" name="newPassword"  placeholder="输入你的新密码" required>
                                        </div>
                                    </div>

                                    <div class="form-group">
                                        <label for="confirmPwd" class="col-md-3 control-label">确认密码：</label>
                                        <div class="col-md-8">
                                            <input type="password" class="form-control" id="confirmPwd" name="confirmPwd"  placeholder="请确认你的新密码" required>
                                        </div>
                                    </div>

                                    <div class="form-group">
                                        <div class="col-md-offset-3">
                                            <button type="submit" class="btn btn-primary" id="submitModifyForm">确认修改</button>
                                        </div>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </section>
            </div>
        </div>
    </div>
</div>

<script id="table-my-template" type="text/x-handlebars-template">
    {{#each list}}
    <tr onclick="gotoCheckProblems(this)" style="cursor:pointer">
        <td>{{workId}}</td>
        <td><a title="{{title}}">{{title}}</a></td>
        <td><span class="{{#equal status '0'}}
								status status0
							{{/equal}}
							{{#equal status '1'}}
								status status1
							{{/equal}}
							{{#equal status '2'}}
								status status2
							{{/equal}}
							{{#equal status '3'}}
								status status3
							{{/equal}}
							{{#equal status '4'}}
								status status4
							{{/equal}}">{{#equal status '0'}}
								尚未受理
							{{/equal}}
							{{#equal status '1'}}
								受理中
							{{/equal}}
							{{#equal status '2'}}
								等待回复
							{{/equal}}{{#equal status '3'}}
								已解决
							{{/equal}}
							{{#equal status '4'}}
								已关闭
							{{/equal}}</span></td>
        <td>{{createDate}}</td>
        <td>{{serviceGroupName}}</td>
        <td>{{customServiceName}}</td>
    </tr>
    {{/each}}
</script>
<script type="text/javascript" src="<%=request.getContextPath()%>/script/lib/ajaxFileUpload/ajaxupload.3.5.js"></script>

<script>
    $(function(){
        // 注册事件
        regEvent();

        // 初始化页面
        $('#navBtns > li:eq(0)').click();
    });

    /*
    * @author Lesty
    * @codeDate 2016.7.13
    * @desc 注册事件
    * */
    function regEvent() {
        /* 头像上传 */
        new AjaxUpload($("#uploadPortrait"), {
            action: "<%=request.getContextPath()%>/userManageMongo/changePhoto",
            type: 'POST',
            name: "image",
            onSubmit: function(file, ext){
                if (! (ext && /^(jpg|png|jpeg|gif)$/.test(ext))){
                    notice.alert("仅支持JPG, PNG 或 GIF 格式文件上传");
                    return false;
                }
            },
            responseType:'json',
            data:{userId:"${user.userId}"},
            onComplete: function(file,response){
                if(response){
                    var data = response;
                    if(data.success==true){
                        notice.success(data.msg);
                        $("#photoUrl").attr("src","<%=request.getContextPath()%>/"+data.rows);
                    }else{
                        notice.danger(data.msg);
                    }
                }
            }
        });

        // 导航栏事件绑定
        $('#navBtns > li').on('click', function(){
            var linkId = $(this).data('link');

            // 导航栏样式
            $('#navBtns > li').removeClass('active');
            $(this).addClass('active');

            // 当前标题
            $('#curTitle').text($(this).text());

            // 切换页面
            $('#rightContent > .container-fluid').hide();
            $(linkId).show();

            if(linkId === '#myQuestion') { //我的工单
                // 查询全部工单
                queryData(-1);
                // 重置查询框
                resetQueryCondition();
            } else if(linkId === '#myDetail') { // 我的资料
                $('#detailPills > li:eq(0)').click();
            }
        });

        // 查询事件
        $('#queryBtn').on('click', function() {
            queryData($('#orderStatus').val());
        });

        // 重置查询框
        $('#clearBtn').on('click', function() {
            resetQueryCondition();
        });

        // 我的资料选项卡切换
        $('#detailPills > li').on('click', function() {
            var srcType = $(this).data('type');

            // 选项卡样式修改
            $('#detailPills > li').removeClass('active');
            $(this).addClass('active');

            // 切换页面
            $('#detailSections > .base-info').hide();
            $('#' + srcType).show();

            if(srcType === 'baseInfo') { // 基本信息
                //resetBaseInfoForm();
            } else if(srcType === 'modifyPwd') { //修改密码
                // 重置表单
                resetModifyForm();
            }

        })

        // 提交基本信息
        $('#baseInfoForm').on('submit', function(event) {
            // 阻止表单默认事件
            event.preventDefault();
            // 停止当前元素后续事件并阻止冒泡
            event.stopImmediatePropagation();

            // 按钮不可用
            $('#submitBtn').prop('disabled', true);

            var param = {
                email: $("#email").val(),
                userId: '${user.userId}',
                nickName: $("#nickName").val(),
                userDesc: $("#userDesc").val()
            };

            $.post("<%=request.getContextPath()%>/userManageMongo/updateInformation",param,infoCallBack,'json');
        });

        $('#modifyPwdForm').on('submit', function() {
            // 阻止表单默认事件
            event.preventDefault();
            // 停止当前元素后续事件并阻止冒泡
            event.stopImmediatePropagation();

            if($('#newPassword').val() !== $('#confirmPwd').val()) {
                notice.danger('新密码和确认密码不一致，请确认后重试！');

                return false;
            }

            // 按钮不可用
            $('#submitModifyForm').prop('disabled', true);

            var param = {
                loginPwd: $("#password").val(),
                newLoginPwd: $("#newPassword").val(),
                userId: '${user.userId}'
            };

            $.post("<%=request.getContextPath()%>/userManageMongo/updatePassword",param,passwordCallBack,'json');
        });
    }

    // 重置查询框
    function resetQueryCondition() {
        $('#orderStatus').val('-1');
    }

    // 重置基本信息表单
    function resetBaseInfoForm() {
        $('#email').val("${user.email}");
        $('#nickName').val("${user.nickName}");
        $('#userDesc').val("${user.userDesc}");
    }

    // 重置修改密码表单
    function resetModifyForm() {
        $('#modifyPwdForm input[type="password"]').val('');
    }

    // 基本信息表单提交成功回调
    function infoCallBack(data){
        if(data.success){
            notice.success(data.msg);
        }else{
            notice.danger(data.msg);
        }

        // 按钮可用
        $('#submitBtn').prop('disabled', false);

        return false;
    }

    function passwordCallBack(data) {
        if(data.success){
            notice.success(data.msg);
        }else{
            notice.danger(data.msg);
        }

        // 按钮可用
        $('#submitModifyForm').prop('disabled', false);

        return false;
    }

    function queryData(sta){
        getTableData({status:sta,page:1,rows:10});
    }

    function gotoCheckProblems(a){
        var workId=$(a).children("td:eq(0)").text();
        location.href="<%=request.getContextPath()%>/check/problem/"+workId;
    }

    var getTableData = (function(){
        var paramCache = {};

        /**
         * 初始化分页
         */
        var pager = new cri.Pager($("#pagination"),{
            page:1,
            pageSize:10,
            total:0,
            onPage:function(page,pageSize){
                $.extend(paramCache,{page:page,rows:pageSize});
                getTableData(paramCache);
            }
        });
        return function(param,url){
            $.ajax({
                url:"<%=request.getContextPath()%>/queryWorkOrderInfo/queryCreatorAllWorkOrder?sessionKey=${sessionKey}",
                data:param,
                dataType:"jsonp",
                success:function(data){
                    var myTemplate = Handlebars.compile($("#table-my-template").html());
                    $('#myQlist').html(myTemplate(data.rows));
                    pager.update(param.page,param.rows,data.total);
                    $.extend(paramCache,param);
                }
            });
        }
    })();  
</script>

<script>  
    $(function(){
	    $("#logoutBtn").on('click',function(){
	        // 手动点击退出，移除session
	        logout(null, function(data) {
	            if(data.success) {
	                window.location.href = '<%=request.getContextPath()%>/login';
	            } else {
	                notice.danger(data.msg);
	            }
	        });
	    });
	});
    
    var logout = (function() {
	    // 登出请求发送的标志(避免重复发送)
	    var LOGOUT_FLAG = false;

	    return function(param, callback) {
	        param = param != null ? param : {};

	        // 没发送过请求
	        if(LOGOUT_FLAG === false) {
	            // 设置登出请求标志为true
	            LOGOUT_FLAG = true;
	            $.ajax({
	                async: false,
	                url: '<%=request.getContextPath()%>/logout',
	                data: param,
	                method: 'POST',
	                success: function(data) {
	                    if(typeof callback === 'function') {
	                        callback(data);
	                    }
	                },
	                dataType: 'json'
	            }).done(function() {
	            });
	        }
	    }
	})();
</script>
</body>
</html>