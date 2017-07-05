<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>短信群发</title>
    <%@include file="/views/include/pageHeader.jsp"%>
        <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/script/lib/dropzone/dropzone.css"/>
    <link data-origin-file="innerFrame.css" rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/static/css/innerFrame.css">
    <link data-origin-file="noteMass.css" rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/static/css/noteMass.css">
    <link data-origin-file="note.css" rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/static/css/note.css">
</head>
<body>
<div class="note-contain-wrapper">
    <header class="part-header">
        <span>短信群发</span>
    </header>
    <div class="right-content">
        <div class="right-content-panel container-fluid">
            <div class="row">
                <div class="col-sm-12">
                    <div class="panel" style="background-color: #fff; padding: 20px;">
                        <div id="sendNoteForm" class="form-horizontal">
                            <div class="form-group">
                                <label class="control-label col-sm-2" for="noteTempId">短信模板：(必填)</label>

                                <div class="col-sm-6">
                                    <select id="noteTempId" name="tempId" class="form-control"></select>
                                </div>
                            </div>

                            <div class="form-group textarea-list">
                                <label class="control-label col-sm-2" for="noteContent">短信内容：(必填)</label>

                                <div class="col-sm-6">
                                    <textarea rows="5" cols="47" name="noteContent" id="noteContent" placeholder="输入短信内容" required></textarea>
                                </div>
                            </div>

                            <div class="form-group textarea-list">
                                <label class="control-label col-sm-2" for="custPhone">客户电话：(必填)</label>

                                <div class="col-sm-8">
                                    <textarea rows="6" cols="47" name="custPhone" id="custPhone" placeholder="输入手机号码,多个号码以英文分号分割" required></textarea>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-sm-offset-8 col-sm-2 text-right">
                                <button type="button" class="btn btn-raised btn-primary btn-sm" id="sendNoteSubmit">发送短信</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
<script type="text/javascript">
    var tempData = null;
    $(function () {
        initModule("");
        $('#noteTempId').on('change', tempChange);

        /**初始化短信模板**/
        function initModule(tel) {
            var finalPhone = "";
            if (tel.length > 11) {
                finalPhone = tel.substring(tel.length - 1 - 10, tel.length);
                if (finalPhone.match("^1[0-9]{10}$")) {
                    $("#custPhone").val(finalPhone);
                } else {
                    $("#custPhone").val("");
                }

            } else if (tel.length == 11 && tel.match("^1[0-9]{10}$")) {
                finalPhone = tel;
                $("#custPhone").val(finalPhone);
            } else {
                $("#custPhone").val("");
            }
            $("#noteContent").val("").attr("readonly", false);

            $.ajax({
                url: "<%=request.getContextPath()%>/note/getTempByStatus",
                type: "post",
                dataType: "json",
                data: {
                    entId: "${entId}",
                    status: 1
                },
                success: function (data) {
                    if (data.success) {
                        var optionsHtml = "<option value='-1'>自定义</option>";

                        tempData = data.rows;

                        for (var i = 0; i < tempData.length; i++) {
                            optionsHtml += "<option value='" + tempData[i].tempId + "'>" + tempData[i].tempName + "</option>"
                        }

                        // 生成option列表
                        $("#noteTempId").html(optionsHtml);
                    } else {
                        notice.danger(data.msg);
                    }
                }
            });
        }

        //模板选择改变  短信内容响应变化
        function tempChange() {
            var $noteContent = $('#noteContent');
            var id = $("#noteTempId").val();
            if (id == -1) {
                $noteContent.val("").prop("readonly", false);
            } else {
                for (var j = 0; j < tempData.length; j++) {
                    if (id == tempData[j].tempId) {
                        $noteContent.val(tempData[j].noteContent).prop("readonly", false);
                    }
                }
            }
        }

        !function () {
            // 提交表单
            $('#sendNoteSubmit').on('click', sendNoteSubmit);
            //事件处理函数
            // 提交表单
            function sendNoteSubmit() {
                var validator = $('#sendNoteForm').validator();
                if (!validator.validate()) {
                    return;
                }
                var param = $("#sendNoteForm").formValue();
                var str = JSON.stringify(param);
                $.ajax({
                    url: "<%=request.getContextPath()%>/notedetail/sendMassNote",
                    type: "post",
                    dataType: "json",
                    data: {
                        entId: "${entId}",
                        info: str,
                        tempName: $("#noteTempId").find("option:selected").text()
                    },
                    success: function (data) {
                        if (data.success) {
                            notice.success(data.msg);
                            $("#custPhone").val("");
                            $("#noteContent").val("");
                            //初始化模板数据
                            initModule("");
                        } else {
                            $("#sendNoteModal").modal('hide');
                            notice.danger("发送失败！" + data.msg);
                        }
                    }
                });
            }
        }();
    });
</script>
</html>