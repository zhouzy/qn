<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div id="massSMSModal" class="modal fade bs-example-modal-sm" data-backdrop="static">
    <div class="modal-dialog" style="width:600px;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <span class="modal-title">发送短信</span>
            </div>
            <div class="modal-body">
                <div class="container-fluid" >
                    <div class="row">
                        <form id="sendNoteForm" class="form-horizontal">
                            <div class="form-group">
                                <label class="control-label col-sm-4" for="custPhone">客户电话：(必填)</label>
                                <div class="col-sm-7">
                                    <textarea rows="2" class="form-control" name="custPhone" id="custPhone" required placeholder="输入手机号码,多个号码以英文分号分割"></textarea>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="control-label col-sm-4" for="noteTempId">短信模板：(必填)</label>
                                <div class="col-sm-7">
                                    <select id="noteTempId" name="tempId" class="form-control" required></select>
                                </div>
                            </div>
                            <div class="form-group textarea-list">
                                <label class="control-label col-sm-4" for="noteContent">短信内容：(必填)</label>
                                <div class="col-sm-8">
                                    <textarea rows="5" cols="47" name="noteContent" id="noteContent" class="form-control" required></textarea>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-raised btn-default btn-sm" data-dismiss="modal">取消</button>
                <button type="button" class="btn btn-raised btn-primary btn-sm" id="sendNoteSubmit">发送短信</button>
            </div>
        </div>
    </div>
</div>
<script>
    /*
     * @author Lesty
     * @codeDate 2016.10.9
     * @desc 创建一个全局对象，暴露相应接口，避免全局污染
     * */
    var massSMSModal = (function(){
        // 短信模板数据
        var tempData = null;

        function init(tel) {
            // 初始化表单组件
            initModule(tel);

            // 注册事件
            regEvent();
        }

        /*
         * @author Lesty
         * @codeDate 2016.10.9
         * @desc 初始化表单组件
         * */
        function initModule(tel) {
            $("#custPhone").val(tel);

            $("#noteContent").val("");

            $.ajax({
                url: "<%=request.getContextPath()%>/note/getTempByStatus",
                type: "post",
                dataType: "json",
                data: {
                    entId: '${entId}',
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
                $noteContent.val("");
            } else {
                for (var j = 0; j < tempData.length; j++) {
                    if (id == tempData[j].tempId) {
                        $noteContent.val(tempData[j].noteContent);
                    }
                }
            }
        }

        // 提交表单
        function sendNoteSubmit() {
            var $sendNoteForm = $('#sendNoteForm');
            var validator = $sendNoteForm.validator();
            if (!validator.validate()) {
                return;
            }

            var param = $sendNoteForm.formValue();
            var str = JSON.stringify(param);
            $.ajax({
                url: "<%=request.getContextPath()%>/notedetail/sendMassNote",
                type: "post",
                dataType: "json",
                data: {
                    entId: '${entId}',
                    info: str,
                    tempName: $("#noteTempId").find("option:selected").text()
                },
                success: function (data) {
                    if (data.success) {
                        notice.success("短信已发送！");
                        $("#massSMSModal").modal('hide');
                    } else {
                        $("#massSMSModal").modal('hide');
                        notice.danger("短信发送失败！" + data.msg);
                    }
                }
            });
        }

        /*
         * @desc 注册事件
         * */
        function regEvent() {
            // 判断之前是否已经注册过事件，如果注册过了就跳过
            if(typeof arguments.callee.regFlag != 'string') {
                arguments.callee.regFlag = 'reg';

                // 提交表单
                $('#sendNoteSubmit').on('click', sendNoteSubmit);

                // 短信模板改变
                $('#noteTempId').on('change', tempChange);
            }
        }

        return {
            init: init
        };
    })();
</script>