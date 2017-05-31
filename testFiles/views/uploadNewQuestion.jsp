<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>提交新工单</title>
    <%@include file="/views/include/pageHeader.jsp"%>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/static/css/normalize.css">
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/static/css/activity.css">
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/script/lib/summernote/summernote.css">

	<script src="<%=request.getContextPath()%>/script/lib/summernote/summernote.js" ></script>
    <script src="<%=request.getContextPath()%>/script/lib/summernote/summernote-zh-CN.js" ></script>
    <style>
        .cur-title {
            margin: 10px 0 30px;
            font-size: 19px;
            color: #333;
        }
    </style>
</head>
<body>

<header class="head">
    <div class="wrap header-inner">
        <div class="logo">
            <img src="<%=request.getContextPath()%>/static/images/logo.png" />
        </div>
        <nav class="header-nav">
        	<ul class="header-nav-list">
            	<li>
            	   <a class="J_menuItem" href="<%=request.getContextPath()%>/activity/my">我的工单</a>
                </li>
                <li>
                    <a href="<%=request.getContextPath()%>/newquestion/index">提交新工单</a>
                </li>
                 <li>
                   <%-- <a href="<%=request.getContextPath()%>/login">退出</a> --%>
                   <a id="logoutBtn" href="javascript:void(0);">退出</a>
                 </li>
            </ul>
            <div class="user-nav">
            	<% if (request.getAttribute("user") != null) { %>
                <div class="dropdown profile-element">
                    <a data-toggle="dropdown" class="dropdown-toggle user" href="#">
                        <span class="avatar">
                            <img alt="image" class="img-circle" src="${photoUrl}" width="60px"/>
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

<main>
    <header class="main-header">
        <div class="wrap">
            <div class="cur-title">提交新工单</div>
        </div>
    </header>
    <section class="content">
        <div class="wrap">
            <section class="content-main">
                <div class="form-ui" onsubmit="return false">

                    <div class="form-group">
                        <label class="control-label">标题<span>*</span></label>
                        <input maxlength="120" type="text" class="form-control" id='title'>
                    </div>
<!-- 
                    <div class="form-group label-floating">
                        <label class="control-label">手机号码 <span>*</span></label>
                        <input maxlength="32" size="20" type="text" class="form-control">
                    </div>
 -->
                    <div class="form-section">
                        <label class="control-label" style="color: #646464; margin-bottom: 15px;">问题描述 <span>*</span></label>
                        <!-- 文本输入框 -->
                         <div>
                         	 <div></div>
                             <div class="md-editor" id="editor"></div>
                         </div>
                    </div>
                    <div class="form-section">
                        <div  class="uploader">
			            <div id="fileGroup"></div>
				            <form action="/"
			                  class="dropzone"
			                  enctype="multipart/form-data"
			                  id="my-dropzone"
			                  method="post">
            				</form>
       					 </div>
                    </div>
                    <input type="submit" value="提交" class="btn btn-raised btn-success" onclick="sumbits()">
                </div>
            </section>
        </div>
    </section>
</main>

</body>
<script type="text/javascript">
/* $(function(){
	$("#editor").summernote({
    	lang:"zh-CN",
    	height: 150,
    	toolbar:[
    		 ['style', ['style','bold', 'italic', 'underline', 'clear']],
    	     ['font', ['strikethrough', 'superscript', 'subscript','hr']],
    	     ['fontsize', ['fontsize']],
    	     ['color', ['color']],
    	     ['para', ['ul', 'ol', 'paragraph']],
    	     ['height', ['height']],
    	    ]});

}); */
$(function(){
	//富文本框编辑
	$("#editor").summernote({
		lang:"zh-CN",
		height: 200,
		toolbar:[
			['style', ['style','bold', 'italic', 'underline', 'clear']],
			['font', ['strikethrough', 'superscript', 'subscript','hr']],
			['fontsize', ['fontsize']],
			['color', ['color']],
			['para', ['ul', 'ol', 'paragraph','table']],
			['height', ['height','redo','undo']],
		]});
	//附件上传处理
	Dropzone.options.myDropzone = {
		//指定上传图片的路径
		url: "<%=request.getContextPath()%>/attachments/upload",
		//添加上传取消和删除预览图片的链接，默认不添加
		addRemoveLinks: true,

		//关闭自动上传功能，默认会true会自动上传
		autoProcessQueue: true,
         
		//添加区域提示信息
		dictDefaultMessage: "点击此处进行上传",
		
		sending: function(file, xhr, formData) {
		      formData.append("userId", "${userId}");
		      formData.append("userName","${userName}");
		    },
		init: function () {
			myDropzone = this; // closure
			var fileDesc;
			//当上传完成后的事件，接受的数据为JSON格式
			this.on("complete", function (data) {
				if (this.getUploadingFiles().length === 0 && this.getQueuedFiles().length === 0) {
					var res = eval('(' + data.xhr.responseText + ')');
					if (res.success) {
						var $fileDetail = $("<input type='text' class='file' style='display:none'>");
						$fileDetail.attr("id",fileDesc);
						$fileDetail.val(res.rows[0].fileNew).data("fileInfo",res.rows[0]);
						$("#fileGroup").append($fileDetail);
						notice.alert(res.msg,"alert-success");
					}
					else {
						notice.alert(res.msg,'alert-danger');
					}
				}
			});
			this.on("addedfile",function(file){
				fileDesc = file.lastModified;
			});
			//删除图片的事件，当上传的图片为空时，使上传按钮不可用状态
			this.on("removedfile", function (file) {
				if(file != null){
					$.post("<%=request.getContextPath()%>/attachments/delete",{"newFileName":$("#"+file.lastModified).val()},function(data){
						if(data.success){
							$("#"+file.lastModified).remove();
							notice.alert(data.msg,"alert-success");
						}else{
							notice.alert(data.msg,'alert-danger');
						}
					});
				}
			});
		}
	};
});

//获取上传附件的信息
function getAttachments(){
	var attachement=[];
	$("#fileGroup .file").each(function(){
		var data = $(this).data("fileInfo");
		attachement.push(JSON.stringify(data));
	});
	return "["+attachement.join(",")+"]";
}
</script>
<script type="text/javascript">
//点击提交
function sumbits(){
//	alert($('#title').val());
	var text="";
	if(!$.trim( $('#title').val() )){
		text = text+"<p>标题不能为空</p>";
	}
	if(!$.trim($($("#editor").code()).text())){
		text = text+"<p>问题描述不能为空</p>";
	}
	if(text!=""){
		notice.danger(text);
		return;
	}
 	var params=$.extend(
			{content:$('#editor').code()},
			{title:$('#title').val()},
			{creatorId:"${user.userId}"},
			{creatorName:"${user.userName}"},
			{creatorEmail:"${user.email}"},
			{customId:"${user.userId}"},
			{customName:"${user.userName}"},
			{entId:'${enterpriseid}'},
			{source:'0'},
			{issue:$('#editor').code()},
			{serviceGroupId:''},
			{serviceGroupName:''},
			{customServiceId:''},
			{customServiceName:''},
			//获取上传的附件
			{attachment:getAttachments()}
			);
	var info = encodeURI(JSON.stringify(params));
//	alert(params);
	$.ajax({
		url:"<%=request.getContextPath()%>/workorder/webcreate?sessionKey=${user.sessionKey}",
        dataType : 'jsonp',
		data:{info:info},
		success:function(data){
			if(data.success){
				notice.success("创建成功");
				location.href="<%=request.getContextPath()%>/activity/my";
				
			}else{
				notice.danger("创建失败");
			}
		}
	}) 
}
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
</html>