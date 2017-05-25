<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>工单中心</title>
    <%@include file="/views/include/pageHeader.jsp"%>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/static/css/innerFrame.css">
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/static/css/order.css">
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/script/lib/summernote/summernote.css">
    <script src="<%=request.getContextPath()%>/script/lib/PCASClass.js"></script>
</head>
<body>
<div class="left-side" data-status="0">
    <header class="head">
        <span>客户信息</span>
    </header>
    <div class="container-fluid info-panel">
        <div class="row">
            <div class="col-sm-12">
                <div class="list-group">
                    <div class="list-group-item">
                        <div class="row-picture"  id="userPic">
                            <img class="circle" src="${photoUrl}" alt="icon">
                        </div>
                        <div class="row-content">
                            <h6 class="list-group-item-heading">${user.userName}</h6>
                            <p class="list-group-item-text">状态<span class="status green" id="userStatus" style="margin-left: 5px;">正常</span></p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="row">
            <div class="col-sm-12">
                <div class="form-horizontal">
                    <div class="form-group">
                        <label class="control-label col-sm-4">邮箱：</label>
                        <div class="col-sm-8">
                            <p class="form-control-static">${user.email}</p>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="control-label col-sm-4">手机：</label>
                        <div class="col-sm-8">
                            <p class="form-control-static">${user.telPhone}</p>
                            <a class="form-group-right-btn" onclick="callOut('${user.telPhone}')"><i class="fa fa-phone"></i></a>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="control-label col-sm-4">座机：</label>
                        <div class="col-sm-8">
                            <p class="form-control-static">${user.fixedPhone}</p>
                            <a class="form-group-right-btn" onclick="callout('${user.fixedPhone}')"><i class="fa fa-phone"></i></a>
                        </div>
                    </div>
                    <div id="nikAndSign">
                        <div class="form-group">
                            <label class="control-label col-sm-4">客服昵称：</label>
                            <div class="col-sm-8">
                                <p class="form-control-static">${user.nickName}</p>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="control-label col-sm-4">客服签名：</label>
                            <div class="col-sm-8">
                                <p class="form-control-static">${user.signature}</p>
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="control-label col-sm-4">角色：</label>
                        <div class="col-sm-8">
                        	<p id="typeSelect" class="form-control-static"> </p>
                        </div>
                    </div>
                    <div class="form-group" id="roleSelect" style="display:none">
                        <label class="control-label col-sm-4" id="roleLabel">角色权限：</label>
                        <div class="col-sm-8">
                        	<p id="secondType" class="form-control-static"> </p>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="control-label col-sm-4">用户说明：</label>
                        <div class="col-sm-8">
                            <p class="form-control-static">${user.userDesc}</p>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="control-label col-sm-4">详细信息：</label>
                        <div class="col-sm-8">
                            <p class="form-control-static">${user.remark}</p>
                        </div>
                    </div>

                    <div class="form-group">
                        <div class="col-sm-12">
                            <a id="openOrClose" onclick="openOrClose()" class="btn btn-block btn-success btn-sm">展开</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="row">
            <div class="col-sm-12">
                <div id="userFieldUl" class="form-horizontal" style="display:none;">
                    <c:forEach items="${activeFieldList}" var="item">
                        <div class="form-group">
                            <%--1:文本框,2:文本区域,3:下拉菜单,4:复选框,5:单选框,6:数字,7:小数,8:正则匹配字段,9:电话号,10:时间输入框--%>
                            <label class="control-label col-sm-4">${item.name}：</label>
                            <c:choose>
                                <c:when test="${item.componentType=='1' || item.componentType=='2' || item.componentType=='6' || item.componentType=='7' || item.componentType=='8' || item.componentType=='9' || item.componentType=='10' || item.componentType=='11'}">
                                    <c:set value="${user[item.key]}" var="fieldKey" scope="request"></c:set>
                                    <div class="col-sm-8">
                                        <p class="form-control-static">${fieldKey}</p>
                                    </div>
                                </c:when>

                                <c:when test="${item.componentType=='3'}">
                                    <div class="col-sm-8">
                                        <c:set value="${user[item.key]}" var="fieldKey" scope="request"></c:set>
                                        <select id="${item.key }" class="form-control" data-name="${item.key }" disabled>
                                            <option value="${fieldKey}">${fieldKey}</option>
                                        </select>
                                    </div>
                                </c:when>

                                <c:when test="${item.componentType=='4'}">
                                    <div class="col-sm-8">
                                        <div class="checkbox">
                                            <c:set var="checkIndex" value="0" />
                                            <c:forEach items="${item.candidateValue}" var="checkItems">
                                                <label class="checkbox-inline" style="cursor: not-allowed;">
                                                    <c:set var="isChecked" value=""/>
                                                    <c:if test="${checkItems == user[item.key][checkIndex]}">
                                                        <c:set var="isChecked" value="checked"/>
                                                        <c:set var="checkIndex" value="${checkIndex + 1}"/>
                                                    </c:if>

                                                    <input type="checkbox" value="${checkItems}" name="${item.key}" disabled="" ${isChecked}>${checkItems}
                                                </label>
                                            </c:forEach>
                                        </div>
                                    </div>
                                </c:when>
                            </c:choose>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </div>
    </div>
</div>
<div class="right-side">
    <header class="head">
        <span>工单编号：${workId}</span>
        <div class="wfTitleInfoRight">工单创建人:<span>${creator}</span>创建时间:<span id="createTime"></span>创建渠道:<span id="source"></span>受理组:<span id="groupName"></span>受理人:<span id="acceptcustom"></span>
            <span class="status status${status}" id="wfStatusInfo"></span>
        </div>
    </header>
    <div class="right-content" >
        <div class="top-info">
            <div class="info-item item-4">
                <label>呼入/呼出：</label>
                <span id="callType"></span>
            </div>
            <div class="info-item item-4">
                <label>通话号码：</label>
                <span id="workPhone"></span>
                <span><a id="callOut" style="padding: 10px;"><i class="fa fa-phone"></i></a></span>
            </div>
            <div class="info-item item-4">
                <label>通话归属地：</label>
                <span id="callArea"></span>
            </div>
        </div>
        <div class="main-info container-fluid">
            <div class="form-horizontal row">
                <div class="form-group col-sm-4" style="padding-left: 0">
                    <input id="customId" type="hidden">
                    <label for="orderTpl" class="control-label col-sm-6">工单模板：</label>
                    <span id="orderTpl" class="col-sm-6 form-control-static read-only">${tempName}</span>
                </div>
                <div id="fieldList" class="row form-horizontal">
                    <div class="form-group col-sm-12" id="pushTitle" style="display:none;">
                        <label class="control-label col-sm-2">标题：</label>
                        <span id="title" class="col-sm-6 form-control-static read-only"></span>
                    </div>

                    <div class="form-group col-sm-12" id="pushContent" style="display:none;">
                        <label class="control-label col-sm-2">问题描述：</label>
                        <p class="col-sm-6 form-control-static read-only"></p>
                    </div>
                </div>
            </div>
        </div>
        <div class="main-info container-fluid">
            <div class="row" style="margin-top:15px; margin-bottom:15px;">
                <div class="form-line">

                </div>
            </div>
            <div class="row form-horizontal" style="margin-top:25px;">
                <div class="col-sm-12">
                    <div class="form-group" style="font-size: 12px">
                        <label class="col-sm-2" style="margin-top: 10px;">工单回复：</label>
                        <div class="col-sm-3">
                            <div class="radio">
                                <label>
                                    <input class="ember-view ember-radio" type="radio"  value="0" name="replay-choice">公共回复
                                </label>
                            </div>
                        </div>
                        <div class="col-sm-3">
                            <div class="radio">
                                <label>
                                    <input class="ember-view ember-radio" type="radio" value="1" name="replay-choice"  checked>内部回复(仅坐席)
                                </label>
                            </div>
                        </div>
                    </div>
                </div>


                <div class="form-group col-sm-12" id="contentGroup">
                    <label class="col-sm-2 text-right control-label">回复内容:</label>
                    <div class="col-sm-10">
                        <div class="md-editor" id="editor"></div>
                    </div>
                    <div class="col-sm-10 col-sm-offset-2"><span class="help-block">请输入回复内容</span></div>
                </div>
            </div>
            <div class="row form-horizontal" style="margin-top:15px;">
                <div class="col-sm-12 form-group">
                    <label class="control-label text-right col-sm-2">附件上传:</label>
                    <div class="col-sm-10" >
                        <form id="uploadForm" class="uploader col-sm-12" enctype="multipart/form-data">
                            <input id="file" type="file" name="file" value=""/>
                            <span id="uploadBtn" class="uploadBtn">上传文件</span>
                            <span style="color:blue">上传文件类型可为jpeg、txt、doc、docx、excel、zip格式，大小不能超过<span style="color:red">2m</span>!</span>
                        </form>
                    </div>
                </div>
            </div>
        </div>
        <div class="main-info container-fluid">
            <div class="row">
                <div class="col-sm-12">
                    <div class="ticket-comment-header">
                        <h3 id="ticketCommentHeaderTitle">操作历史<span></span></h3>
                        <div class="btn-group fr">
                            <a class="btn btn-sm active" id="orderCommentBtn">工单回复</a>
                            <a class="btn btn-sm btn-br" id="orderEventBtn">工单事件</a>
                        </div>
                    </div>
                </div>
                <!-- 工单回复列表 -->
                <div class="col-sm-10 col-sm-offset-1 ticket-comment-list" id="orderCommentList"></div>
                <!-- 工单事件列表 -->
                <div class="col-sm-10 col-sm-offset-1 ticket-comment-list" id="eventList" style="display:none;"></div>
            </div>
        </div>
        <br style="clear:both;" />
    </div>
</div>
<div id="bottom-bar" class="show" >
    <div class="form-inline service-box" id="serviceBox">
        <label>
            <input type="checkbox" id="distributeBtn"> 分配给
        </label>

        <select id="serviceGroup" name="serviceGroupName" class="form-control" disabled></select>
        <select id="customService" name="customServiceName" class="form-control" disabled>
            <option value="" disabled selected hidden>-- 选择受理人 --</option>
        </select>
    </div>

    <div class="btn-group dropup btn-box" id="lidiv">
        <button id="submitFun" data-href="0" type="button" class="btn btn-raised btn-danger" >回复工单为<span id="submitStr">尚未受理</span></button>
        <button id = "buttonSmall" type="button" class="btn btn-raised btn-danger dropdown-toggle border-le" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" >
            <span class="caret"></span>
            <span class="sr-only">Toggle Dropdown</span>
        </button>
        <ul class="dropdown-menu" >
            <li class="dropdown-header">回复工单</li>
            <li role="separator" class="divider"></li>
            <li><a data-href="1">回复工单为<span class="status status1">受理中</span></a></li>
            <li><a data-href="2">回复工单为<span class="status status2">等待回复</span></a></li>
            <li><a data-href="3">回复工单为<span class="status status3">已解决</span></a></li>
            <li><a data-href="4">回复工单为<span class="status status4">待回访</span></a></li>
        </ul>
    </div>
</div>
<div id="pictureViewOverlay" class="picture-view-overlay">
    <div class="content">
        <span class="close-btn">x</span>
        <img src=""/>
    </div>
</div>
<script id="event-template" type="text/x-handlebars-template">
    <div class="ticket-comment-item">
        <article>
            <div class="wrap">
                <a class="user-avatar" onclick="showUserDetail('{{updatorId}}', '{{updatorName}}')">
                    <!-- 暂时为静态坐席图片 -->
                    <img onclick="showUserDetail('{{updatorId}}', '{{updatorName}}')" width="80" height="80" src="<%=request.getContextPath()%>/static/images/avater/agent.jpg" onerror="this.src='<%=request.getContextPath()%>/static/images/avater/agent.jpg'"> </a>
                <header>
                    <a class="ember-view" onclick="showUserDetail('{{updatorId}}', '{{updatorName}}')">{{updatorName}}</a>  ·
                    <time>{{#formatDate contentUpdateDate "yyyy年MM月dd日 hh:mm"}}{{/formatDate}}</time>
                </header>
                <ul class="event-list">
                    {{#if content}}
                    <li class="event-comment">
                        <p>{{{content}}}</p>
                    </li>
                    {{/if}}
                    {{#each statuslist}}
                    {{#equal this.eventDisplay '1'}}
                    {{#if this.oldValue}}
                    <li class="event_action"><strong>{{this.fieldName}}</strong> {{this.oldValue}} 改为 {{this.newValue}}</li>
                    {{else}}
                    <li class="event_action"><strong>{{this.fieldName}}</strong> 为 {{this.newValue}}</li>
                    {{/if}}
                    {{/equal}}
                    {{/each}}
                </ul>
            </div>
        </article>
    </div>
</script>
<script id="comment-body-template" type="text/x-handlebars-template">
    <div class="ticket-comment-item">
        <article>
            <div class="wrap">
                <a class="ember-view user-avatar" onclick="showUserDetail('{{updatorId}}', '{{updatorName}}')">
                    <img onclick="showUserDetail('{{updatorId}}', '{{updatorName}}')" src="{{#equal isAgent '1'}}<%=request.getContextPath()%>/static/images/avater/agent.jpg{{/equal}}{{#equal isAgent null}}<%=request.getContextPath()%>/static/images/avater/end_user.jpg{{/equal}}" onerror="this.src='<%=request.getContextPath()%>/static/images/avater/agent.jpg'">
                </a>
                <header>
                    <a class="ember-view" onclick="showUserDetail('{{updatorId}}', '{{updatorName}}')">{{updatorName}}</a>
                    <time>{{#formatDate contentUpdateDate "yyyy年MM月dd日 hh:mm"}}{{/formatDate}}</time>
                    {{#equal isPublicReply "1"}}<span class="private-replay">私有回复</span>{{/equal}}
                </header>
                <div class="comment-body">
                    {{#if content}}
                    <p>{{{content}}}</p>
                    {{/if}}
                </div>
                {{#attachmentList attachment}}{{/attachmentList}}
                {{#if sessionId}}
                {{#equal source "5"}}
                <div>
                    <span>录音：</span>
                    <span class="audio-phone"><audio src="" controls="controls" id="recordUrl"></audio></span>
                </div>
                {{/equal}}
                {{#equal source "6"}}
                <div>
                    <span>录音：</span>
                    <span class="audio-phone"><audio src="" controls="controls" id="recordUrl"></audio></span>
                </div>
                {{/equal}}
                {{#equal source "9"}}
                <div>
                    <span>录音：</span>
                    <span class="audio-phone"><audio src="" controls="controls" id="recordUrl"></audio></span>
                </div>
                {{/equal}}
                {{/if}}
            </div>
        </article>
    </div>
</script>
<script src="<%=request.getContextPath()%>/script/lib/summernote/summernote.js" ></script>
<script src="<%=request.getContextPath()%>/script/lib/summernote/summernote-zh-CN.js" ></script>
<script>
    Handlebars.registerHelper('attachmentList', function(items, options) {
        var out = '<ul class="attachmentList">';
        for(var i=0, l=items.length; i<l; i++) {
            var file = items[i];
            console.log(items)
            if(file.type == "1"){
                out += '<li class="list-item picture">' +
                        '<img src="'+ file.fastDFSPath+ file.littleRelativePath + '" data-relativepath="' +file.fastDFSPath+ file.relativePath +'" onclick="javascript:viewPicture(this);"/>' +
                        '<span class="file-name">' + file.originalName + '--' +
                        '<a href="<%=request.getContextPath()%>/attachments/download?newFileName='+file.fileNew+'&relativePath='+file.relativePath+'">下载</a></span>' +
                        '</li>'
            }
            else{
                out += '<li class="list-item">' +
                            '<span class="file-name">' + file.originalName + '--' +
                                '<a href="<%=request.getContextPath()%>/attachments/download?newFileName='+file.fileNew+'&relativePath='+file.relativePath+'">下载</a>' +
                            '</span>' +
                       '</li>'
            }
        }
        return out + "</ul>";
    });
    /**
     * 查看图片详情
     * @param e
     */
    function viewPicture(e){
        var $overlay = $("#pictureViewOverlay");
        var picturePath = $(e).data('relativepath');
        $overlay.find('img').attr('src',picturePath);
        $overlay.show();
        $overlay.find('.close-btn').one('click',function(){
            $overlay.hide();
        });
    }
</script>
<script>
    //定义优先级常量
    var priortyArray=["-","低","中","高","紧急"];
    var typeArray = ["-","问题","事务","故障","任务"];
    var sourceStr = ["网页表单","WEBCHAT","API接口","邮件","手机端","电话呼入","电话呼出"];
    //定义所获取的工单类型
    var typeText;
    //工单详情的原始值集合
    var originalInfo = {};

    //接收自定义字段的key值
    var field=[];
    /* 接收自定义字段的key对应的type */
    var fieldType={};
    /* 记录复选框自定义字段初始值 */
    var fields=[];
    /* 自定义字段格式校验 */
    var check_bool = {};
	// 省市区字段key
    var areaFieldKeys=[];
	// 所有字段信息
    var fieldInfoList = [];

    var attachMentList = [];

    $(function() {
        /* 加载工单模板 */
        chooseOrderTpl("${tempId}");

        if("${user.userType}"=="1"){
            $("#typeSelect").text("客户");
        }else if("${user.userType}"=="2"){
            $("#typeSelect").text("客服");
        }else if("${user.userType}"=="3"){
            $("#typeSelect").text("管理员");
        }


        if("${user.userType}"=="2"){
            var parentId="${user.userType}";
            $.post("<%=request.getContextPath()%>/usrManage/secondLevel?parentId="+parentId, secondLevelCallBack, 'json');
        }
        else{
            $("#roleSelect").css("display","none");
        }

        if("${user.userType}"!="1"){
            var userId="${user.userId}";
            var loginName="${user.loginName}";
            $("#nikAndSign").css("display","block");
            $("#groupName1").css("display","block");
            //查询所属客服组
            <%-- $.post("<%=request.getContextPath()%>/usrManage/belongGroup?userId="+userId+"&loginName="+loginName, belongGroupCallBack, 'json'); --%>
        }
        else{
            $("#nikAndSign").css("display","none");
            $("#groupName1").css("display","none");
        }

        var $userStatus = $("#userStatus");
        if("${user.userStatus}"=="9") { // 如果用户已被删除
            $userStatus.removeClass().addClass("status red").html("已删除");
            $('#userPic').on('click', function() {
                notice.warning('该用户已被删除，无法查看用户详情-。-');
            });
        } else { // 没被删除的用户
            $('#userPic').on('click', goUserDetail);
            if("${user.userStatus}"=="1"){
                $userStatus.removeClass().addClass("status green").html("正常");
            }
            else if("${user.userStatus}"=="4"){
                $userStatus.removeClass().addClass("status red").html("停用");
            }
            else if("${user.userStatus}"=="3"){
                $userStatus.removeClass().addClass("status blue").html("未审核");
            }
        }

        $('#distributeBtn').on('change', function() {
            // 如果选中
            if($(this).prop('checked') === true) {
                $('#serviceGroup').prop('disabled', false);

                // 如果客服已经选过了，则可操作
                if($('#customService').val() !== "" && $('#customService').val() != null) {
                    $('#customService').prop('disabled', false);
                }
            } else { // 如果取消选中
                // 所有选项框都不可操作
                //默认选中第一个
                $('#serviceGroup').prop('selectedIndex', 0);
                $('#customService').prop('selectedIndex', 0);
                $('#serviceBox select').prop('disabled', true);
            }
        });

        $('#serviceGroup').on('change', function() {
            $.ajax({
                url:"<%=request.getContextPath()%>/userApi/queryGroupAgent",
                type:"post",
                dataType:"json",
                data: {groupId: $(this).val(), entId: "${entId}"},
                success : function(data){
                    var serviceList = data.rows[0].agentList,
                        html = '<option value="" disabled selected hidden>-- 选择受理人 --</option>';

                    if(serviceList) {
                        for(var i = 0, len = serviceList.length; i < len; i++) {
                            html += '<option value="' + serviceList[i].userId +'">' + serviceList[i].userName +'</option>';
                        }
                    }

                    // 清空客服下拉框，并添加新的数据
                    // 让客服选项框变为可选
                    $('#customService').empty().append(html).prop('disabled', false);
                }
            });
        });
        //富文本框编辑
        $("#editor").summernote({
            lang:"zh-CN",
            height: 85,
            toolbar:[
                ['style', ['style','bold', 'italic', 'underline', 'clear']],
                ['font', ['strikethrough', 'superscript', 'subscript','hr']],
                ['fontsize', ['fontsize']],
                ['color', ['color']],
                ['para', ['ul', 'ol', 'paragraph','table']],
                ['height', ['height','redo','undo']]
            ]
        });

        $('#file').on('change',function(){
            var that = this;
            var fd = new FormData($('#uploadForm')[0]);

            // 判断文件大小
            if(that.files[0].size > 2097152) {
                notice.warning('上传文件大小不能超过2M');
                // 清空file值，使得选择同一个文件也可以触发chagne事件
                that.value = '';
                return false;
            }

            fd.append("userId", "${userId}");
            fd.append("userName","${userName}");
            $.ajax({
                url: '<%=request.getContextPath()%>/attachments/upload',
                type: 'POST',
                cache: false,
                data: fd,
                processData: false,
                contentType: false
            }).done(function(res) {
                that.value = '';
                if(res.success){
                    var fileInfo = res.rows[0];
                    if(fileInfo){
                        attachMentList.push(fileInfo);
                        var $ft = $('<div class="col-sm-2 file-list-item"><a src="#" class="file-name">'+fileInfo.originalName+'</a><span class="deleteBtn">X</span></div>');
                        $ft.data("fileInfo",fileInfo);
                        $ft.find('span.deleteBtn').click(function(){
                            $.post("<%=request.getContextPath()%>/attachments/delete",{"newFileName":fileInfo.fileNew},function(data){
                                if(data.success){
                                    $ft.remove();
                                    if(!$('#uploadForm').last().is('.file-list-item')){
                                        $('#uploadBtn').text('上传文件');
                                    }
                                }
                                else{
                                    notice.danger('删除附件失败!');
                                }
                            });
                        });
                        $('#uploadForm').before($ft);
                        $('#uploadBtn').text('继续上传文件');
                    }
                }
                else{
                    notice.danger('上传附件失败:'+res.message);
                }
            });
        });

        $("#bottom-bar .dropdown-menu li a").on("click",function(){
            var spanStyleText = [{style:'status status0',text:'尚未处理'},{style:'status status1',text:'受理中'},{style:'status status2',text:'等待回复'},{style:'status status3',text:'已解决'},{style:'status status4',text:'待回访'}];
            var $submitFun = $("#submitFun");
            var $this = $(this);
            var thisHref = $this.attr("data-href");
            var submitHref = $submitFun.attr("data-href");
            var thisStyleText = spanStyleText[parseInt(submitHref)];
            $submitFun.attr("data-href",thisHref).find("span").text(spanStyleText[parseInt(thisHref)].text);
            //$this.attr("data-href",submitHref).find("span").text(thisStyleText.text).attr("class",thisStyleText.style);
            $("#lidiv").removeClass("open");
            submit(thisHref);
        });

        $("#submitFun").click(function(){
            submit($(this).attr("data-href"));
        });
    });

    //获取上传附件的信息
    function getAttachments(){
    	 var attachMentList = [];
    	 $('#uploadForm').parent().find(".file-list-item").each(function(){
             attachMentList.push($(this).data("fileInfo"));
         });
        return JSON.stringify(attachMentList);
    }

    /*
     * @author Lesty
     * @codeDate 2016.6.9
     * @desc [根据选择的模板id切换模板列表]
     * */
    function chooseOrderTpl(tempId) {
        if (tempId != null && tempId !== "") {
            $.ajax({
                url:"<%=request.getContextPath()%>/workorder/queryTemplateField?sessionKey="+ $.cookie("sessionKey"),
                type:"post",
                dataType:"jsonp",
                data: {tempId: tempId},
                success : function(data){
                    if(data.success){
                        orderForm.render(data.rows);
                        loadRightInfo();
                    }
                }
            });
        }
    }

    /**
     * 工单表单
     */
    var orderForm = function(){
        var $form = $('#fieldList');
        var _createFormGroup = function(nodeType,attrs,label,options){
            var $group = $('<div class="form-group col-sm-4"></div>'),
                $e,
                $label = $('<label class="control-label col-sm-6">'+label+'：</label>'),
                inputWidth = 'col-sm-6';
            if(nodeType == 'INPUT'){
                $e = $('<input class="form-control"/>');
            }
            else if(nodeType == 'SELECT'){
                $e = $('<select class="form-control"></select>');
                if(options){
                    for(var i in options){
                        $e.append('<option value="' + options[i].value + '">' + options[i].text + '</option>');
                    }
                }
            }
            else if(nodeType == 'TEXTAREA'){
                $group.removeClass('col-sm-4').addClass('col-sm-12').attr('data-comp-type', 'textarea');
                $label.removeClass('col-sm-6').addClass('col-sm-2');
                $e = $('<textarea class="form-control"></textarea>');
                $group.append($e);
                inputWidth = 'col-sm-10';
            }
            else if(nodeType == 'CHECKBOX'){
                $e = $('<div class="checkbox"></div>');
                if(options){
                    if(options.length > 4) {
                        $group.removeClass('col-sm-4').addClass('col-sm-12');
                        $label.removeClass('col-sm-6').addClass('col-sm-2');
                        inputWidth = "col-sm-10";
                    } else if(options.length > 2) {
                        $group.removeClass('col-sm-4').addClass('col-sm-6');
                        $label.removeClass('col-sm-6').addClass('col-sm-4');
                        inputWidth = "col-sm-8";
                    }
                    for(var i in options){
                        $e.append('<label><input type="checkbox" value="' + options[i].value + '" />'+options[i].text + '</label');
                    }
                }
            }
            if(nodeType != 'CHECKBOX'){
                for(var k in attrs){
                    $e.attr(k,attrs[k]);
                }
            }
            else{
                var $input = $e.find('input');
                for(var j in attrs){
                    $input.attr(j,attrs[j]);
                }
            }
            $group.append($label,$('<div class="'+ inputWidth +'"></div>').append($e));
            return $group;
        };
        /**
         * @author Lesty
         * @codeDate 2016.6.9
         * @desc [根据字段数据创建相应组件]
         * @rowData Object [服务器返回的，包含field数组对象(所有需要显示的字段)和group数组(客服组)对象的数据]
         */
        function createOrderMainInfo(rowData) {
            var $fieldList = $('#fieldList'), // 字段列表元素
                fieldList = rowData.field, // 字段列表数据
                html = '', // 动态添加的html
                tmpField = null,
                tmpKey = '',
                tmpName = '',
                groupList = rowData.group || [],
                i = 0,
                len = 0;
            field=[];
            fieldType={};
            fieldInfoList = fieldList;

            // 初始化表单
            $fieldList.children('.form-group').not("#addressInfo,#pushTitle,#pushContent").remove();

            // 设置所有字段
            for(var j = 0, fLen = fieldList.length; j < fLen; j++) {
                html = '';
                tmpField = fieldList[j];
                tmpKey   = tmpField.key;
                tmpName  = tmpField.name;
                var type = tmpField.componentType;
                var validateAttr = {};
                if(tmpField.isRequired){
                    validateAttr.required = true;
                    tmpName += '<span style="color: red">*</span>';
                }

                //根据字段的不同类型，展示不同控件
                if(type === '1') { // 文本框
                    if(tmpKey === "title") {
                        field.push(tmpKey);
                        fieldType[tmpKey] = tmpField.componentType;
                        continue;
                    }
                    else {
                        html = _createFormGroup('INPUT',$.extend(validateAttr,{name:tmpKey,id:tmpKey}),tmpName);
                    }
                }
                else if(type === '2') { // 文本区域textarea
                    if(tmpKey !== 'queDesc') {
                        validateAttr.required = true;
                        html = _createFormGroup('TEXTAREA',$.extend(validateAttr,{name:tmpKey,id:tmpKey}),tmpName);
                    }
                    else{
                        field.push(tmpKey);
                        fieldType[tmpKey] = tmpField.componentType;
                        continue;
                    }
                }
                else if(type === '3') { // 下拉菜单select
                     var options = [];
	               	 //工单优先级
	               	 if(tmpKey === "priority") {
	               		 options.push({value:"1",text:"低"});
	               		 options.push({value:"2",text:"中"});
	               		 options.push({value:"3",text:"高"});
	               		 options.push({value:"4",text:"紧急"});
	               	 } else {
                         options.push({value: '', text: ' - '});
	                        for(i = 0, len = tmpField.candidateValue.length; i < len; i++) {
	                            options.push({value:tmpField.candidateValue[i],text:tmpField.candidateValue[i]});
	                        }
	               	 }
                    html = _createFormGroup('SELECT',$.extend(validateAttr,{name:tmpKey,id:tmpKey}),tmpName,options);
                }
                else if(type === '4') { // 复选框 checkbox
                    var op = [];
                    for(i=0, len = fieldList[j].candidateValue.length;i < len;i++){
                        op.push({value:fieldList[j].candidateValue[i],text:fieldList[j].candidateValue[i]});
                    }
                    html = _createFormGroup('CHECKBOX',$.extend(validateAttr,{name:tmpKey}),tmpName,op);
                }
                else if(type === '5') { // 单选框 radio
                    continue;
                }
                else if(type === '6') { // 数字 number
                    validateAttr.role = 'number';
                    html = _createFormGroup('INPUT',$.extend(validateAttr,{name:tmpKey,id:tmpKey,"data-name":tmpKey,"data-field":tmpName,role:'number'}),tmpName);
                }
                else if(type === '7') { // 小数 float
                    validateAttr.role = 'number';
                    html = _createFormGroup('INPUT',$.extend(validateAttr,{name:tmpKey,id:tmpKey,"data-name":tmpKey,"data-field":tmpName,role:'number'}),tmpName);
                }
                else if(type === '8') { // 正则表达式匹配
                    validateAttr.role = 'text';
                    tmpField.candidateValue && tmpField.candidateValue.length && (validateAttr.pattern = tmpField.candidateValue[0]);
                    html = _createFormGroup('INPUT',$.extend(validateAttr,{name:tmpKey,id:tmpKey,"data-name":tmpKey,"data-field":tmpName,"data-type":fieldList[j].componentType}),tmpName);
                }
                else if(type === '9') { // 电话号码
                    validateAttr.role = 'tel';
                    html = _createFormGroup('INPUT',$.extend(validateAttr,{name:tmpKey,id:tmpKey,"data-name":tmpKey,"data-field":tmpName}),tmpName);
                }
                else if(type === '10') { // 时间输入框
                    html = $('<input />').attr('name',tmpKey).attr('id',tmpKey).data('name',tmpKey).attr('role', 'timeInput').data('label',tmpName + "：").prop('required', tmpField.isRequired);
                    tmpField.candidateValue && tmpField.candidateValue.length && html.data('format',tmpField.candidateValue[0]);
                }
                else if(type === '11') { // 省市区
                	html = '<div class="form-group col-sm-12">' +
	                    '<label class="control-label col-sm-2">' + tmpName + '</label>' +
	                    '<div class="col-sm-2">' +
	                        '<select class="form-control" name="province_' + tmpKey + '" id="Company_province" + tmpKey></select>' +
	                    '</div>' +
	                    '<div class="col-sm-2">' +
	                        '<select class="form-control" name="city_' + tmpKey + '" id="Company_city" + tmpKey></select>' +
	                    '</div>' +
	                    '<div class="col-sm-2">' +
	                        '<select class="form-control" name="area_' + tmpKey + '" id="Company_area" + tmpKey></select>' +
	                    '</div>' +
	                    '<input type="hidden" name="' + tmpKey + '" id="' + tmpKey + '" data-name='+tmpKey+' data-field="'+tmpKey+'"/>' +
	                '</div>';
	                areaFieldKeys.push(tmpKey);
                }

                field.push(tmpKey);
                fieldType[tmpKey]=fieldList[j].componentType;
                $fieldList.append(html);
                if(type === '10'){
                    var $input = html.timeInput({
                        format:html.data('format')
                    });
                    var $inputGroup = html.closest('.form-group').addClass('col-sm-6');
//                    $inputGroup.find('label.col-sm-4').removeClass('col-sm-4').addClass('col-sm-6');
//                    $inputGroup.find('div.col-sm-8').removeClass('col-sm-8').addClass('col-sm-6');
                }
            }

            // 设置客服组
            html = '<option value="" disabled selected hidden>-- 选择受理组 --</option>';
            for(i = 0, len = groupList.length; i < len; i++) {
                html += '<option value="' + groupList[i].groupId +'">' + groupList[i].groupName +'</option>';
            }
            $('#serviceGroup').empty().append(html);
        }

        var _validator;
        var _createValidator = function(){
            return $form.validator({
                validateOnBlur:false
            });
        };

        var _formValue = function(){
            return $form.formValue();
        };

        return {
            render:function(data){
            	areaFieldKeys = [];
                createOrderMainInfo(data);
                _validator = _createValidator();

                $('#fieldList > div.form-group').not('[data-comp-type=textarea]').css({
                    height: '48px'
                });

                $('#fieldList > div[data-comp-type=textarea]').css({
                    height: '96px'
                });
            },
            validate:function(){
                var editor = $.trim($("<p>" + $("#editor").code() + "</p>").text());
                if(editor.length){ // 如果问题描述不为空
                    // 隐藏问题描述错误提示框
                    $('#contentGroup').removeClass('has-error').find('.help-block').hide();
                	// 验证省市区
                	for (var i = 0; i < fieldInfoList.length; i++) {
                		var fieldInfo = fieldInfoList[i];
                		if (fieldInfo.componentType == "11") {
                			if (fieldInfo.isRequired) {
                				var key = fieldInfo.key;
                				var p = $("select[name=province_" + key + "]").val();
                				var c = $("select[name=city_" + key + "]").val();
                				var a = $("select[name=area_" + key + "]").val();
                				if (p == "") {
                					notice.warning(fieldInfo.name + ' 省不能为空!');
                                    return false;
                				}
                				if (c == "") {
                					notice.warning(fieldInfo.name + ' 市不能为空!');
                                    return false;
                				}
                				if (a == "") {
                					notice.warning(fieldInfo.name + ' 区不能为空!');
                                    return false;
                				}
                			}
                		} else if(fieldInfo.componentType == '4') { // cri中对复选框的validator与bootstrap冲突，需要特殊判断
                            if (fieldInfo.isRequired) {
                                if(!$('#fieldList').find('input[name=' + fieldInfo.key +']').is(':checked')) {
                                    notice.warning(fieldInfo.name + ' 不能为空!');
                                    return false;
                                }
                            }
                        } else if(!_validator.validate($('#' + fieldInfo.key))){
                            $('#' + fieldInfo.key).focus();
                            notice.warning('工单信息未填写完善，请检查-。-');
                            return false;
                        }
                	}
                    return true;
                }
                else{ // 问题描述为空的时候
                    $('#contentGroup').addClass('has-error').find('.help-block').show();
                    notice.warning('问题描述不能为空!');
                    $('.note-editable.panel-body').focus();
                    return false;
                }
            },
            getValue:function(){
                var param = _formValue();
                //param.queDesc = $.trim($($("#editor").code()).text());
                // 获取省市区的值
                for (var i = 0; i < areaFieldKeys.length; i++) {
                	var key = areaFieldKeys[i];
                	var area = $("select[name=province_" + key + "]").val() + ","
        			+ $("select[name=city_" + key + "]").val() + "," + $("select[name=area_" + key + "]").val();
                	param[key] = area;
                }

                // 获取所有checkbox的值
                var test = {};
                $("#fieldList input[type=checkbox]").each(function () {
                    test[this.name] || (test[this.name] = []);
                    if ($(this).prop('checked')) {
                        test[this.name].push($(this).attr('value'));
                    }
                });

                // 将参数合并到param中
                $.extend(param, test);

                return param;
            }
        };
    }();


    /* 加载字段信息 */
    function loadRightInfo() {
        var params={};
        var param = {};
        param.workId=parseInt("${workId}");
        params.info=JSON.stringify(param);
        $.ajax({
            url : "<%=request.getContextPath()%>/workorder/detail?sessionKey="+ $.cookie("sessionKey"),
            type : "post",
            dataType : 'jsonp',
            data : params,
            success : function(data) {
                if (data.success) {
                    //查询成功
                    var leftObj = data.rows[0];
                    if (leftObj != null) {
                        var tempId = leftObj.tempId || "";
                        var serviceGroupId = leftObj.serviceGroupId || "";
                        var customServiceId = leftObj.customServiceId || "";
                        var status = leftObj.status || "";
                        var type= leftObj.type || "";
                        var priority = leftObj.priority || "";
                        var title = leftObj.title || "";

                        // 设置呼叫类型(呼入/呼出)
                        var callType = '';
                        if(leftObj.source === '5' || leftObj.source === '9' || leftObj.source === '10') {
                            callType = "呼入";
                        } else if(leftObj.source === '6') {
                            callType = '呼出';
                        }
                        $('#callType').text(callType);

                        // 设置通话号码
                        $('#workPhone').text(leftObj.workPhone);

                        $('#callOut').attr('onclick', "callOut('" + leftObj.workPhone + "')");

                        // 设置通话归属地
                        $('#callArea').text(leftObj.callArea);

                        // 工单自定义字段的处理
                        for(var i=0;i<field.length;i++){
                            var f = field[i];
                            f = leftObj[field[i]] || "";
                            // 记录原始工单自定义字段信息
                            originalInfo[field[i]] = f;
                            fields=[];

                            // 复选框类型的自定义字段
                            if(fieldType[field[i]]=="4"){
                                // 复选框赋值
                                var curIndex = 0;
                                var isChecked = false;
                                $("#fieldList input[type=checkbox][name=" + field[i] + "]").each(function(){
                                    isChecked = false;
                                    if(f[curIndex] === this.value) {
                                        isChecked = true;
                                        curIndex++;
                                    }

                                    $(this).prop('checked', isChecked);
                                    fields.push(this.value);
                                });

                                $("#"+field[i]).val(fields).data("original-value",fields).data("field",field[i]).data("type","4");
                            }else if (fieldType[field[i]]=="1") {
                                if (field[i] == "title") {
                                    $('#title').text(f);
                                    $('#pushTitle').show();
                                } else {
                                    $("#"+field[i]).val(f).data("original-value",f).data("field",field[i]).data("type",fieldType[field[i]]);
                                }
                            }else if (fieldType[field[i]]=="2") {
                                if (field[i] == "queDesc") {
                                    $('#pushContent').show().find('p').text(f);
                                } else {
                                    $("#"+field[i]).val(f).data("original-value",f).data("field",field[i]).data("type",fieldType[field[i]]);
                                }
                            }else if (fieldType[field[i]]=="10"){
                                // 时间输入框初始化与赋值
                                $("#"+field[i]).val(f).data("original-value",f).data("field",field[i]).data("type",fieldType[field[i]]);
                            }else if(fieldType[field[i]]=="11") {
                                // 省市区赋值
                                var pcaArr = [];
                                if (f != null) {
                                    pcaArr = f.split(",");
                                }
                                new PCAS("province_" + field[i],"city_" + field[i],"area_" + field[i],pcaArr[0],pcaArr[1],pcaArr[2]);
                                $("#"+field[i]).val(f).data("original-value",f).data("field",field[i]).data("type",fieldType[field[i]]);
                            }else{
                                // 设置工单自定义字段信息
                                $("#"+field[i]).val(f).data("original-value",f).data("field",field[i]).data("type",fieldType[field[i]]);
                            }
                        }

                        //记录原始工单信息
                        originalInfo["tempId"] = tempId;
                        originalInfo["serviceGroupId"] = serviceGroupId;
                        originalInfo["customServiceId"] = customServiceId;
                        originalInfo["status"] = status;
                    }
                    createTop(data.rows[0]);
                    console.log(JSON.stringify(data.rows[0].attachment));
                    createReply(data.rows[0].event);
                    //把订单详情信息写入到工单合并弹出框
                    var eventList = data.rows[0].event;
                    var _lastContent = '';
                    for(var i = eventList.length-1;i>=0;i--){
                        if(eventList[i].content){
                            _lastContent = eventList[i].content;
                        }
                    }
                    $("#mergeOrderModal .order-title").text('#'+leftObj.workId + ',' + title);
                    _lastContent = '#'+leftObj.workId+' “' + title + '” 已合并至此工单，并在此工单进行讨论。<br/>'+ '#'+leftObj.workId+' 的最后回复：'+_lastContent;
                    $("#order2Content").code(_lastContent);
                } else {
                    notice.alert("左侧数据查询失败！"+data.msg);
                }
            }
        });
    }

    function createTop(data){
        var createDate = cri.formatDate(new Date(data.createDate),"yyyy-MM-dd HH:mm:ss");
        $("#createTime").html(createDate);
        $("#source").html(sourceStr[data.source]);
        $("#groupName").html(data.serviceGroupName || "-");
        $("#acceptcustom").html(data.customServiceName || "-");
        var spanStyleText = [{style:'status status0',text:'尚未受理'},{style:'status status1',text:'受理中'},{style:'status status2',text:'等待回复'},{style:'status status3',text:'已解决'},{style:'status status5',text:'待回访'}];
        var clazz = $("#wfStatusInfo").attr("class");
        var statusText = "尚未受理";
        for (var i = 0; i < spanStyleText.length; i++) {
            if (spanStyleText[i].style == clazz) {
                statusText = spanStyleText[i].text;
            }
        }
        $("#wfStatusInfo").html(statusText);
        //设置提交按钮的显示值和调用方法
        setSubmitAttr("${status}", statusText);
    }

    //设置提交按钮的显示值和调用方法
    function setSubmitAttr(status, statusStr) {
        var spanStyleText = [{style:'status status1',text:'尚未受理'},{style:'status status1',text:'受理中'},{style:'status status2',text:'等待回复'},{style:'status status4',text:'待回访'}],
            $s            = $("#submitFun"),
            submitH       = $s.attr("data-href");

        if(submitH != status){
            var $a = $s.siblings('ul').find('a[data-href='+status+']');
            if(status==null){
                $s.attr("data-href",status).find("span").text("已关闭");
            }else{
                $s.attr("data-href",status).find("span").text(statusStr);
            }
        }
    }

    //选择工单状态后触发的方法——提交按钮相应变更
    function chooseWfStatus() {
        var _s = $("#wfStatus>option:selected");
        setSubmitAttr(_s.val(), _s.text());
    }

    /**
     *创建工单回复事件
     */
    var createReply = (function(){
        var eventTemp = Handlebars.compile($("#event-template").html());
        var commentTemp = Handlebars.compile($("#comment-body-template").html());

        var $workreply = $("#orderCommentList");
        var $eventList = $("#eventList");

        return function(eventList){
            var eventHtml = [];
            var commentHtml = [];
            for(var i= 0,len=eventList.length; i<len;i++){
                var e = eventList[i];
                eventHtml.push(eventTemp(e));
                if(e.content || e.source == "9"){
                    if(typeof e.attachment == 'string'){
                        e.attachment = $.parseJSON(e.attachment);
                    }

                    var $tmp = $(commentTemp(e));
                    if(e.source == "9"){
                    	if(e.sessionId && e.ccodEntId){
                    	var callUrl = "<%=request.getContextPath()%>/communicate/getCallRecordUrl";
                            $.ajax({
                                url :callUrl ,
                                type : "post",
                                dataType : 'json',
                                data:{
                                    "sessionId":e.sessionId,
                                    "ccodEntId":e.ccodEntId,
                                },
                                success : function(data) {
                                    $audio=$($tmp.find("audio")[0]);
                                    if (data.success) {
                                        var url=data.rows;
                                        $audio.on("error",function(){
                                            if($audio.siblings("font").length<=0){
                                                $audio.css("display","none");
                                                $audio.after("<font color='red'>录音资源不存在</font>");
                                            }
                                        });
                                        $audio.attr("src",url);
                                    } else {
                                        notice.warning(data.msg);
                                        if($audio.siblings("font").length<=0){
                                            $audio.css("display","none");
                                            $audio.after("<font color='red'>该用户没有留言</font>");
                                        }
                                    }
                                }
                            });
                        }
                        else{
                            var $audio = $($tmp.find("audio")[0]);
                            if($audio.siblings("font").length<=0){
                                $audio.css("display","none");
                                $audio.after('<span style="color:red">该用户没有留言</span>');
                            }
                        }
                    }
                    if(e.sessionId && (e.source=='5'||e.source=='6')){
                        $audio=$($tmp.find("audio")[0]);
                        var url="<%=request.getContextPath()%>/communicate/getRecordUrl";
                        $.ajax({
                            url :url ,
                            type : "post",
                            dataType : 'json',
                            data:{
                                "sessionId":e.sessionId,
                                "ccodEntId":e.ccodEntId,
                                "ccodAgentId":e.ccodAgentId
                            },
                            success : function(data) {
                                if (data.success) {
                                    var url=data.rows;
                                    $audio.on("error",function(){
                                        if($audio.siblings("font").length<=0){
                                            $audio.css("display","none");
                                            $audio.after("<font color='red'>录音资源不存在</font>");
                                        }
                                    });
                                    $audio.attr("src",url);
                                } else {
                                    //notice.warning(data.msg);
                                }
                            }
                        });
                    }
                    commentHtml.push($tmp);
                }
            }
            $workreply.empty().html(commentHtml);
            $eventList.empty().html(eventHtml);
            $("#orderCommentBtn").click(function(e){
                $("#orderEventBtn").removeClass("active");
                $(this).addClass("active");
                $("#orderCommentList").show();
                $("#eventList").hide();
                //$("#ticketCommentHeaderTitle").html("工单回复");
            });

            $("#orderEventBtn").click(function(e){
                $("#orderCommentBtn").removeClass("active");
                $(this).addClass("active");
                $("#orderCommentList").hide();
                $("#eventList").show();
                //$("#ticketCommentHeaderTitle").html("工单事件");
            });
        };
    })();

    /**
     * @param type 0:尚未处理,1:受理中,2:等待回复,3:已解决
     */
    function submit(type){
       	if(type=="4"){
    		type="5";//这里的data-href=4就是待回访工单，即5
    	}
        if(!orderForm.validate()){
            return;
        }

        //是否公开回复标记
        var isPublicReply = $("input[name='replay-choice']:checked").val();
        //var $wfStatus = $("#wfStatus");
        var $customServiceName = $("#customService");
        var content = $("#editor").code();
        var contentText = $.trim($("<p>" + content + "</p>").text());
        //工单状态联动
        //$wfStatus.val(type);
        //数据提交之前的校验
        var inputArr = [$("#serviceGroup"),$customServiceName];
        for(var i=0;i<field.length;i++){
        	inputArr.push($("#"+field[i]));
        }
        if ($("#distributeBtn").prop('checked') === true) {
            if (inputArr[0].find('option:selected').val() == "" || inputArr[0].find('option:selected').val() == undefined) {
                notice.alert('受理组不能为空！','alert-danger');
                return;
            }
            //工单状态不为‘尚未受理’时，受理人不能为空！
            if (type != 0 && (inputArr[1].find('option:selected').val() == "" || inputArr[1].find('option:selected').val() == undefined)) {
                notice.alert('受理人不能为空！','alert-danger');
                return;
            }
			//当有客服人的时候，工单状态不能为尚未受理
            if(type=="0"){
                type = "1";
            }
        } else {
            // 工单状态提交为受理中或其他时，如果之前没有受理客服组和受理客服，必须要选择一个
            if (type != "0" && ($("#groupName").html() == "-" || $("#acceptcustom").html() == "-")) {
                notice.alert('请分配受理组和受理人！','alert-danger');
                return;
            }
        }
        if(type=="" || type==null){
            notice.alert('工单状态不能为空！','alert-danger');
            return;
        }

        //左侧信息和右侧信息都没有变动，不能提交
        /* 自定义字段处理 */
        var bfield=true;
        for(var i=0;i<field.length;i++){
            if(fieldType[field[i]] == "4"){
                var c_fields=[];//存放自定义复选框提交参数
                $("#"+field[i]+" input[type=checkbox]:checked").each(function(){
                    c_fields.push($(this).val());
                });
                if(originalInfo[field[i]] != c_fields+"")
                    bfield=false;
            }else if(fieldType[field[i]] == "3"){
                if(originalInfo[field[i]]!=inputArr[2+i].find('option:selected').val())
                    bfield=false;
            }else if(fieldType[field[i]] == "10"){
                var time = $("#" + field[i]).val();
                if(originalInfo[field[i]]!=time)
                    bfield=false;
            }else if(fieldType[field[i]] == "11"){
                var pca = $("select[name=province_" + field[i] + "]").val() + ","
                        + $("select[name=city_" + field[i] + "]").val() + "," + $("select[name=area_" + field[i] + "]").val();
                if(originalInfo[field[i]]!=pca)
                    bfield=false;
            }else{
                if(originalInfo[field[i]]!=inputArr[2+i].val())
                    bfield=false;
            }
        }

        if (/* originalInfo["status"] == inputArr[3].find('option:selected').val() && */
        contentText == "" && bfield) {
            notice.info("工单还未进行任何更改，不能提交更新！");
            return;
        }

        if (contentText == "") {
            notice.info("工单回复内容不能为空！");
            return;
        }

        var formValue = {};
        formValue["status"] = type;
        formValue["content"] = content;
        if ($("#distributeBtn").prop('checked') === true) {
            formValue["serviceGroupName"] = (inputArr[0].find('option:selected').val() === '') ? "" : inputArr[0].find("option:selected").text();
            formValue["serviceGroupId"] = inputArr[0].val();
            formValue["customServiceName"] = (inputArr[1].find('option:selected').val() === '') ? "" : inputArr[1].find("option:selected").text();
            formValue["customServiceId"] = inputArr[1].val();
        }

        //{isAgent:"1"}表示当前为座席操作
        ajax($.extend(orderForm.getValue(), formValue,{tempId:"${tempId}"},{workId:parseInt('${workId}')},{updatorId:"${userId}"},{updatorName:"${userName}"},{isPublicReply:isPublicReply+""},{isAgent:"1"},{attachment:getAttachments()}));
    }

    /*  更新工单 */
    function ajax(params){
        var info = encodeURI(JSON.stringify(params));
        $.ajax({
            url : "<%=request.getContextPath()%>/workorder/update?sessionKey="+ $.cookie("sessionKey"),
            type : "post",
            dataType : 'jsonp',
            data:{info:info, entId:"${entId}"} ,
            success : function(data) {
                if (data.success) {
                    notice.alert("工单数据提交成功！","alert-success");
                    //location.reload(); // 用这个如果分配了座席右下角的checkbox会处于勾选状态
                    window.location.href = window.location.href;
                } else {
                    notice.alert("工单数据提交失败！","alert-danger");
                }
            }
        });
    }

    function showUserDetail(updatorId, updatorName){
        var url="<%=request.getContextPath()%>/userManageMongo/userDetails?userId="+updatorId;
        parent.openTab(url,"user",updatorName,false);
    }

    /* 二级下拉框回调函数 */
    function secondLevelCallBack(data) {
        if (data.success) {
            $("#roleSelect").css("display", "block");
            var $secondType = $("#secondType");
            for (var j = 0; j < data.rows.length; j++) {
                var sub = data.rows[j];

                if ("${user.roleId}" == sub.id) {
                    $secondType.text(sub.name);
                }
            }
        } else {
            notice.danger(data.msg);
        }
    }

    /* 所属客服组回调函数 */
    function belongGroupCallBack(data){
        var spanHtml="";
        if(data.rows.length!=0){
            for(var i=0;i<data.rows.length;i++){
                spanHtml+="<span>"+data.rows[i].groupName+"</span>";
            }
        }
        $("#groupName1").empty().append(spanHtml);
    }

    /* 查看用户详情 */
    function viewDetails(userId,userName){
        var url="<%=request.getContextPath()%>/userManageMongo/userDetails?userId="+userId;
        parent.openTab(url,"user",userName,false);
    }

    /* 自定义字段输入内容展开或收起 */
    function openOrClose(){
        var $userFieldUl = $("#userFieldUl");
        var $button = $("#openOrClose");
        if($userFieldUl.is(':visible')){
            $button.text('展开');
            $userFieldUl.slideUp();
        }
        else{
            $button.text('收起');
            $userFieldUl.slideDown();
        }
    }

    /* 自定义字段模板下拉框 */
    function setDefinedFiled(){
        $.ajax({
            url:"<%=request.getContextPath()%>/workorder/queryTemplates?sessionKey="+ $.cookie("sessionKey"),
            type:"post",
            dataType:"jsonp",
            data: {tempId : "${tempId}"} ,
            success : function(data){
                if(data.success){
                    var sub = data.rows;
                    var $definedfield = $("#definedfield");
                    for(var i=0;i<sub.length;i++){
                        $definedfield.append('<option value="' + sub[i].tempId + '">' + sub[i].tempName + '</option>');
                    }
                    var tempId = "${tempId}";
                    $definedfield.val(tempId);

                    var param = document.getElementById("definedfield");
                    chooseTemplate(param);
                }
            }
        });
    }

    //跳转到用户详情页面
    function goUserDetail(){
    	var userId = "${user.userId}";
    	var userName = "${user.userName}";
    	if(userId){
      	  var url="<%=request.getContextPath()%>/userManageMongo/userDetails?userId="+userId + '&t=' + new Date();
          parent.openTab(url,"user",userName,false);
    	}
    }

    function callOut(tel) {
        var value = $.trim(tel.replace(/^[^0-9]*/ig,""));
        if(!Tools.phoneCheck(value)) {
            notice.warning("外呼号码不合法，请检查电话号码!");
            return;
        }
        parent.callOut(value);
    }
</script>
</body>
</html>
