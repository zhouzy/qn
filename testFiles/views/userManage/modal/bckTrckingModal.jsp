<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div id="bckTrckingModal" class="modal fade bs-example-modal-sm" data-backdrop="static">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" id="bckTrckClose" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <span class="modal-title">添加沟通记录</span>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" id="makeCommMenly">
                    <%--<div class="form-group row">--%>
                        <%--<label class="control-label col-sm-2">渠道：</label>--%>
                        <%--<div class="col-sm-10">--%>
                            <%--<select class="form-control" name="source">--%>
                                <%--<option value="0">网页表单</option>--%>
                                <%--<option value="1">IM</option>--%>
                                <%--<option value="2">API接口</option>--%>
                                <%--<option value="3">邮件</option>--%>
                                <%--<option value="4">手机端</option>--%>
                                <%--<option value="5">电话呼入</option>--%>
                                <%--<option value="6">电话呼出</option>--%>
                                <%--<option value="7">微信</option>--%>
                                <%--<option value="8">视频</option>--%>
                            <%--</select>--%>
                        <%--</div>--%>
                    <%--</div>--%>

                    <div class="row">
                        <div class="col-sm-8" style="margin-left: -26px;">
                            <input id="begin_date" type="text" name="startTimeStr" class="form-control" data-label="开始时间：">
                        </div>
                    </div>

                    <div class="form-group row">
                        <label class="control-label col-sm-2">沟通小结：</label>
                        <div class="col-sm-10">
                            <textarea class="form-control" name="content" rows="3" id="common_content"></textarea>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-raised btn-default btn-default btn-sm" data-dismiss="modal">取消</button>
                <button type="button" id="bckTrckSubmit" class="btn btn-raised btn-primary btn-sm">提交</button>
            </div>
        </div>
    </div>
</div>
<script>
    /*
     * @author Lesty
     * @codeDate 2016.7.14
     * @desc 创建一个全局对象，暴露相应接口，避免全局污染
     * */
    var bckTrckingModal = (function() {
        // 提交表单后需要执行的外部函数
        // 在回调函数里调用
        var refreshCallBack = null;

        // 初始化表单
        function init(callback) {
            refreshCallBack = callback;

            // 重置控件
            var $makeCommMenly = $("#makeCommMenly");
            $makeCommMenly.find("textarea[name=content]").val("");
            $makeCommMenly.find("select[name=source]").prop("selectedIndex", 0);
            $("#begin_date").val('');

            /*
             * 只需要初始化一次的方法放这里
             * */
            if(typeof arguments.callee.initFlag != 'string') {
                arguments.callee.initFlag = 'init';
                // 初始化表单组件
                initModule();

                // 注册事件
                regEvent();
            }
        }

        /*
        * @author Lesty
        * @codeDate 2016.7.14
        * @desc 初始化表单组件
        * */
        function initModule() {
            // 判断之前是否已经注册过事件，如果注册过了就跳过
            if(typeof arguments.callee.regFlag != 'string') {
                arguments.callee.regFlag = 'reg';

                $("#begin_date").timeInput({
                    format:"yyyy-MM-dd hh:mm:ss",
                    HMS:true,
                    value: ''
                });
            }
        }


        // 提交补录表单
        function makeComm() {
            var startTimeStr = $("#begin_date").val();
            startTimeStr = new Date(startTimeStr).getTime();

            var form = $("#makeCommMenly").formValue();
            form.startTimeStr = startTimeStr;
            form.source = '0';
            form.userId = USER_G.userId;
            form.userName = USER_G.userName;
            form.loginName = USER_G.loginName;

            $.post("<%=request.getContextPath()%>/communicate/saveComm", form, makeBack, "json");
        }

        // 补录工单回调
        function makeBack(data){
            if(data.success) {
                notice.success(data.msg);
                // 点击关闭按钮，关闭当前窗口
                $("#bckTrckClose").click();

                // 调用外部刷新函数
                refreshCallBack({
                    page: 1,
                    rows: 5
                });
            } else {
                notice.success(data.msg);
            }
        }

        /*
         * @author Lesty
         * @codeDate 2016.7.14
         * @desc 注册事件
         * */
        function regEvent() {
            // 提交表单
            $('#bckTrckSubmit').on('click', function() {

                // 沟通记录的开始时间和内容不能为空
                if ($('#begin_date').val().trim() === '') {
                    return notice.danger('时间不能为空');
                }
                if ($('#common_content').val().trim() === '') {
                    return notice.danger('沟通小结不能为空');
                }

                makeComm();
            });
        }

        return {
            init: init,
            regEvent: regEvent
        };
    })();
</script>

