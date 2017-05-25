<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="row form-horizontal" id="pushContent" style="display:none;margin-top:25px;">
    <div class="form-group col-sm-12" id="contentGroup">
        <label class="col-sm-2 text-right control-label">问题描述:</label>
        <div class="col-sm-10">
            <div class="md-editor" id="editor"></div>
        </div>
        <div class="col-sm-10 col-sm-offset-2"><span class="help-block">请输入问题描述</span></div>
    </div>
</div>
<div class="row form-horizontal" style="margin-top:15px;">
    <div class="col-sm-12 form-group">
        <label class="control-label text-right col-sm-2">附件上传:</label>
        <div class="col-sm-10" >
            <form id="uploadForm" class="uploader col-sm-12" enctype="multipart/form-data">
                <input id="file" type="file" name="file" value="" style = "display:none"/>
                <span id="uploadBtn" class="uploadBtn">上传文件</span>
                <span style="color:blue">上传文件类型可为jpeg、txt、doc、docx、excel、zip格式，大小不能超过<span style="color:red">2m</span>!</span>
            </form>
        </div>
    </div>
</div>
<script>
   
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
            ],
            callbacks: {
                onFocus: function() {
                    $('#contentGroup').removeClass('has-error').find('.help-block').hide();
                }
            }});

        if("${sessionId}"!=""){
            if("${source}"=="5"||"${source}"=="6"){
                $("#wfTitle").val("${title}");
                $("#editor").code("${content}");
            }
        }
        
        $("#uploadBtn").on("click",function(){
        	$('#file').click();
        });
        $('#file').on('change',function(){
            var that = this;

            // 判断文件大小
            if(that.files[0].size > 2097152) {
                notice.warning('上传文件大小不能超过2M');
                // 清空file值，使得选择同一个文件也可以触发chagne事件
                that.value = '';
                return false;
            }

            var fd = new FormData($('#uploadForm')[0]);
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
    });
    //获取上传附件的信息
    function getAttachments(){
    	 var attachMentList = [];
    	 $('#uploadForm').parent().find(".file-list-item")
    	           .each(function(){
    				 attachMentList.push($(this).data("fileInfo"));
    			 });
        return JSON.stringify(attachMentList);
    }
</script>