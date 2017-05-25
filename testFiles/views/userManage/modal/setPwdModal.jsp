<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div id="setPwdModal" class="modal fade bs-example-modal-sm" data-backdrop="static">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <span class="modal-title">密码/安全设置</span>
            </div>
            <div class="modal-body">
                <form class="form-horizontal">
                    <ul>
                        <li>
                            <div>
                                <div class="form-group">
                                    <label class="control-label">新密码<span class="red">*</span></label>
                                    <input type="password" id="password"  class="form-control">
                                </div>
                                <div>
                                    <span id="password_strength" class="weak medium strong"></span>
                                    <p class="hint">当前系统密码设置强度：<span>中</span> - 密码由数字和英文字母混合组成即可</p>
                                </div>
                                <p class="hint">如不需要修改密码，请留空</p>
                            </div>
                        </li>
                    </ul>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-raised btn-default btn-default btn-sm" data-dismiss="modal">取消</button>
                <button type="button" class="btn btn-raised btn-primary btn-sm" id="setPwdSubmit">提交</button>
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
    var setPwdModal = (function() {
        // 初始化表单
        function init() {
            // 注册事件
            regEvent();
        }

        /**
         * 修改密码
         */
        function modifyPwd() {
            var loginPwd = $("#password").val();
            var emailPwd = loginPwd;
            if (loginPwd != "") {
                var userInfos = "{'loginPwd':'" + loginPwd + "','emailPwd':'" + emailPwd + "','userId':'" + USER_G.userId + "','entId':'" + USER_G.entId +"'}";
                $.post("<%=request.getContextPath()%>/userManageMongo/setPwd?userInfos=" + userInfos, modifyPwdCallBack, 'json');
            }
            else {
                $("#setPwdModal").modal('hide');
            }
        }

        /**
         * 修改密码回调函数
         */
        function modifyPwdCallBack(data) {
            if (data.success) {
                notice.success("密码安全更新成功！");
                $("#setPwdModal").modal('hide');
            } else {
                notice.warning(data.msg);
            }
        }

        /*
         * @author Lesty
         * @codeDate 2016.7.14
         * @desc 注册事件
         * */
        function regEvent() {
            // 判断之前是否已经注册过事件，如果注册过了就跳过
            if(typeof arguments.callee.regFlag != 'string') {
                arguments.callee.regFlag = 'reg';

                // 删除普通用户
                $('#setPwdSubmit').on('click', modifyPwd);
            }
        }

        return {
            init: init
        };
    })();
</script>
