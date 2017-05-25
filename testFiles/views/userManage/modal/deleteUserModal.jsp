<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div id="deleteUserModal" class="modal fade bs-example-modal-sm" data-backdrop="static">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <span class="modal-title">删除用户</span>
            </div>
            <div class="modal-body">
                <div class="container-fluid">
                    <div class="row">
                        <div class="col-sm-10 col-sm-offset-1">
                            <form class="form-horizontal">
                                <div class="form-group">
                                    <span>注意 </span>
                                </div>
                                <div class="form-group" id="delSingleUser">
                                    <p>
                                        是否确认删除用户
                                        <span class="green" id="delUser"></span>
                                        ？删除后，跟此用户
                                        <span class="red">相关工单</span>
                                        和
                                        <span class="red">文档</span>
                                        会被一起删除，且
                                        <span class="red">无法恢复</span>
                                        ，请慎重操作！
                                    </p>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-raised btn-primary btn-sm" id="deleteUserSubmit">确认删除</button>
                <button type="button" class="btn btn-raised btn-default btn-sm" data-dismiss="modal">取消</button>
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
    var deleteUserModal = (function() {
        // 初始化表单
        function init(userName) {
            // 注册事件
            regEvent();
            // 设置名称
            $("#delUser").text(userName);
            $("#deleteUserModal").modal('show');
        }

        /* 删除普通用户 */
        function deleteUserSubmit() {
            var ids = USER_G.userId;
            var entId = USER_G.entId;

            $.post("<%=request.getContextPath()%>/userManageMongo/deleteUser?ids=" + ids + "&entId=" + entId, deleteCallBack, 'json');
        }

        /* 删除用户回调函数 */
        function deleteCallBack(data) {
            if (data.success) {
                notice.success("用户删除成功！");

                $("#deleteUserModal").modal('hide');
                parent.closeThisTab();

                location.href = "<%=request.getContextPath()%>/usrManage/list";
            } else {
                notice.danger(data.msg);
            }
        }

        /*
         * @desc 注册事件
         * */
        function regEvent() {
            // 判断之前是否已经注册过事件，如果注册过了就跳过
            if(typeof arguments.callee.regFlag != 'string') {
                arguments.callee.regFlag = 'reg';

                // 删除普通用户
                $('#deleteUserSubmit').on('click', deleteUserSubmit);
            }
        }

        return {
            init: init
        };
    })();

</script>
