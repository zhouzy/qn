<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@include file="/views/include/pageHeader.jsp"%>
<title>发布文档</title>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/static/css/innerFrame.css">
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/static/css/help.css">
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/script/lib/summernote/summernote.css">
    <style>
        .modal-content > .modal-footer .note-image-btn {
            color: #000;
            background-color: #ccc;
            opacity: .9;
        }
    </style>
</head>
<body style="background-color: #fff;">
<header class="part-header">
    <span>发布文档</span>
</header>
<div class="right-content">
    <div class="container-fluid">
        <div class="table-content">
            <div class="col-12 grid">
                <div class="publish">
                    <div class="main">
                        <div class="publish-title">
                            <label class="required" for="title">标题<span class="red">*</span></label>
                            <p><input type="text" id="title" /></p>
                        </div>
                        <div class="publish-content">
                            <label class="required">内容<span class="red">*</span></label>
                            <div class="md-editor" id="editor"></div>
                        </div>
                        <div class="form-horizontal">
                            <div class="form-group">
                                <div class="col-sm-12" id="uploadFilesList"></div>
                                <div class="col-sm-9">
                                    <form id="uploadForm" class="uploader col-sm-12" enctype="multipart/form-data">
                                        <input id="file" type="file" name="file" value=""/>
                                        <span id="uploadBtn" class="uploadBtn">上传文件</span>
                                        <span style="color:blue">上传文件类型可为jpeg、txt、doc、docx、excel、zip格式，大小不能超过<span style="color:red">2m</span>!</span>
                                    </form>
                                </div>
                                <div class="col-sm-3 text-right">
                                    <button type="button" class="btn btn-raised btn-default" onclick="cancelPublish();" style="margin: 0;">取消</button>
                                    <button type="button" class="btn btn-raised btn-success" onclick="publishDoc();" style="margin: 0;">保存</button>
                                </div>
                            </div>
                        </div>
                    </div>
                    <ul class="attach-list" id="attachList"></ul>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- 附件信息展示内容 -->
<script id="attach-detail" type="text/x-handlebars-template">
    <li data-file-new="{{fileNew}}" data-original-name="{{originalName}}" data-attach-id="{{attachmentId}}"><i class="fa fa-file" aria-hidden="true"></i><span>{{originalName}}</span> {{fileSize}}
        <a href="<%=request.getContextPath()%>/attachments/download?newFileName={{fileNew}}&relativePath={{relativePath}}">下载</a>
        <a href="javascript:void(0);" onclick="deleteAttach(this);" style="color: red;">删除</a>
    </li>
</script>

<script src="<%=request.getContextPath()%>/script/lib/summernote/summernote.js" ></script>
<script src="<%=request.getContextPath()%>/script/lib/summernote/summernote-zh-CN.js" ></script>
<script type="text/javascript">
    $(document).ready(function(){
        var height = $('.right-content').height() - $('.publish-content').outerHeight(true) - $('.publish-title').outerHeight(true) - $('.form-horizontal').outerHeight(true) - 65 - 8 - 20;
        // 设置最小高度200
        height = height > 200 ? height : 200;
        var $editor = $("#editor");
        $editor.summernote({
            lang: "zh-CN",
            height: height,
            toolbar: [
                ['style', ['style', 'bold', 'italic', 'underline', 'clear']],
                ['font', ['strikethrough', 'superscript', 'subscript', 'hr']],
                ['fontsize', ['fontsize']],
                ['color', ['color']],
                ['para', ['ul', 'ol', 'paragraph', 'table']],
                ['height', ['height', 'redo', 'undo']],
                ['inset',['picture']]
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
                        var $ft = $('<div class="col-sm-2 file-list-item"><a src="#" class="file-name">'+fileInfo.originalName+'</a><span class="deleteBtn">X</span></div>');
                        $ft.data("fileInfo",fileInfo);
                        $ft.find('span.deleteBtn').click(function(){
                            $.post("<%=request.getContextPath()%>/attachments/delete",{"newFileName":fileInfo.fileNew},function(data){
                                if(data.success){
                                    $ft.remove();
                                    if(!$('#uploadFilesList').children().length){
                                        $('#uploadBtn').text('上传文件');
                                    }
                                }
                                else{
                                    notice.danger('删除附件失败!');
                                }
                            });
                        });
                        $('#uploadFilesList').append($ft);
                        $('#uploadBtn').text('继续上传文件');
                    }
                }
                else{
                    notice.danger('上传附件失败:'+res.message);
                }
            });
        });

        if ('${isEdit}' == "1") { // 当前是编辑
            // 初始化文章内容
            initDocDetail();
            // 获取附件列表
            getAttachList({
                docId: "${docId}"
            });
        }

        // 离开该页面时做的操作
        // 检查页面输入框内容(标题、内容和附件)是否已输入
        window.addEventListener("beforeunload", checkPageContent);
    });

    // 初始化文章内容
    function initDocDetail() {
        $.post("<%=request.getContextPath()%>/help/document/queryByDocId", {
            docId: "${docId}"
        }, function(data) {
            var rows = data.rows;
            if(!(data.success)) {
                notice.danger(data.msg);
                return;
            }

            if(rows != null) {
                $("#title").val(rows.title);
                $("#editor").code(rows.content);
            }
        });
    }

    // 获取附件列表
    function getAttachList(param) {
        $.post("<%=request.getContextPath()%>/help/document/getAttachment", param, function(data) {
            if(!(data.success)) {
                notice.danger(data.msg);
                return;
            }

            if(data.rows != null) {
                createAttachList(data.rows);
            }
        });
    }

    // 生成附件列表
    var createAttachList = (function() {
        var attachTpl = Handlebars.compile($("#attach-detail").html());
        var $attachList = $('#attachList');

        return function(rows) {
            var html = [];
            var tmpData = null;

            for(var i = 0, len = rows.length; i < len; i++) {
                tmpData = rows[i];
                tmpData.fileSize = Tools.getFileSize(tmpData.size);
                html.push($(attachTpl(tmpData)));
            }

            $attachList.html(html);
        };
    })();

    // 删除附件
    function deleteAttach(ele) {
        var $li = $(ele).closest('li');
        var fileNew = $li.attr('data-file-new');
        var originalName = $li.attr('data-original-name');

        if(confirm('确认删除附件《' + originalName + '》吗？删除操作立即成效且删除后不可恢复！')) {
            $.post("<%=request.getContextPath()%>/attachments/delete", {
                newFileName: fileNew
            }, function(data) {
                if(data.success) {
                    notice.success('删除附件成功！');
                    // 移除附件项
                    $li.remove();
                } else {
                    notice.danger(data.msg);
                }
            });
        }
    }

    //检查页面输入框内容(标题、内容和附件)是否已输入
    function checkPageContent(e) {
        var $attachs = $('#uploadFilesList').children('.file-list-item');
        var title = $("#title").val().trim();
        var content = $(".note-editable").text().trim();
        // 提示语句
        var confirmationMessage = "您确定要离开该页面么，系统可能不会保留您所做的更改！";
        if(title != '' || content != '' || $attachs.length > 0) {
            (e || window.event).returnValue = confirmationMessage; // Gecko and Trident
            return confirmationMessage; // Gecko and WebKit
        }
    }

    function publishDoc() {
        var title = $("#title").val().trim();
        var content = $(".note-editable").text().trim();
        var code = $("#editor").code();
        var isEmpty = $("#editor").summernote('isEmpty');

        if (title == "") {
            notice.warning("标题不能为空");
            return;
        }

        if(isEmpty){
            notice.warning("内容不能为空");
            return;
        }

        //当只有图片的时候不认为是空内容
        if (content == "" && code.indexOf('img') < 0) {
            notice.warning("内容不能为空");
            return;
        }

        var attachment = [];
        // 获取新上传附件的id
        $('#uploadFilesList').children('.file-list-item').each(function () {
            attachment.push($(this).data("fileInfo").attachmentId);
        });
        // 获取原有附件的id
        $('#attachList').children('li').each(function () {
            attachment.push($(this).attr("data-attach-id"));
        });

        var param = {
            attachment: attachment.join(','),
            content: $("#editor").code(),
            title: title
        };

        var docId = "${docId}";

        if ('${isEdit}' == "1") { // 当前是编辑
            param.docId = docId;
            $.post("<%=request.getContextPath()%>/help/partition/editDoc", param, editBack, "json");
        } else { // 当前是添加
            param.parentId = docId;
            $.post("<%=request.getContextPath()%>/help/document/addDoc", param, publishBack, "json");
        }
    }

    function cancelPublish() {
        var $attachs = $('#uploadFilesList').children('.file-list-item');
        var title = $("#title").val().trim();
        var content = $(".note-editable").text().trim();
        // 提示语句
        var confirmationMessage = "您确定要离开该页面么，系统可能不会保留您所做的更改！";
        // 离开页面标志
        var leaveFlag = false;
        if(title != '' || content != '' || $attachs.length > 0) {
            if(confirm(confirmationMessage)) {
                leaveFlag = true;
            }
        } else {
            leaveFlag = true;
        }

        if(leaveFlag === true) {
            // 刷新文档详情页，隐藏iframe并移除beforeunload事件
            parent.$('#docTree').find('a.active').click();
        }
    }

    function publishBack(data) {
        if (data.success) {
            notice.success('添加文档成功！');
            // 调用回调
            parent.addDocCallBack();
        } else {
            notice.warning(data.msg);
        }
    }

    /* 编辑文档回调 */
    function editBack(data) {
        if (data.success) {
            notice.success('编辑文档成功！');
            // 调用回调
            parent.editDocCallBack($("#title").val());
        } else {
            notice.warning(data.msg);
        }
    }

</script>
</body>
</html>
