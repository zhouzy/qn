<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div id="rolePermission" class="modal fade bs-example-modal-sm" data-backdrop="static">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" id="rolePermissionClose" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
                <span class="modal-title">编辑用户角色/权限</span>
            </div>

            <div class="modal-body">
                <div class="container-fluid">
                    <div class="row">
                        <div class="col-sm-10 col-sm-offset-1">
                            <form class="form-horizontal">
                                <div class="form-group">
                                    <label for="secondType1" class="control-label">角色权限</label>
                                    <select class="form-control" id="secondType1"></select>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-raised btn-default btn-sm" id="rolePermissionCancel" data-dismiss="modal">取消</button>
                <button type="button" class="btn btn-raised btn-primary btn-sm" id="rolePermSubmit">提交</button>
            </div>
        </div>
    </div>
</div>
<script>
    /*
     * @author Lesty
     * @codeDate 2016.7.14
     * @desc 创建一个全局对象，暴露相应接口，避免全局污染
     * @latest Lesty 2016.8.17
     * */
    var rolePermissionModal = (function() {
        /*
        * @author Lesty
        * @codeDate 2016.7.16
        * @desc 初始化窗口
        * @rows Array [角色数据]
        * */
        function init(rows) {
            // 初始化表单数据
            initForm(rows);
            // 注册事件
            regEvent();

            $("#rolePermission").modal('show');
        }

        // 根据角色数据初始化表单
        function initForm(rows) {
            var $secondType1 = $("#secondType1"),
                // 临时Option数据
                sub = null;

            // 清空选择框
            $secondType1.empty();
            // 生成选项
            for (var j = 0, len = rows.length; j < len; j++) {
                sub = rows[j];
                // 生成option
                $secondType1.append('<option value="' + sub.id + '">' + sub.name + '</option>');
            }
        }

        /**
         * 编辑用户角色/权限弹窗
         */
        function roleSubmit() {
            var curRoleId = $("#secondType1").val();
            var userType = UserType.get();
            var userInfos = JSON.stringify({
                userType: userType,
                roleId: curRoleId,
                userId: USER_G.userId,
                entId: USER_G.entId
            });

            $.post("<%=request.getContextPath()%>/userManageMongo/updateUser", {
                userInfos: userInfos
            }, function(data) {
                if(!data.success) {
                    // 用户角色还原
                    UserType.set('3');
                    notice.danger(data.msg);
                    return;
                }

                // 修改角色类别为坐席
                UserType.set('2');
                // 修改用户权限
                RoleId.set(curRoleId);
                // 初始化权限
                initUserPermission(userType);
                // 聚焦角色权限
                $('#roleId').focus();
            }, 'json');
            $("#rolePermission").modal('hide');
        }


        /*
        * @desc [取消坐席权限分配]
        * */
        function roleCancel() {
            // 取消分配后，角色肯定是管理员(不可能是创始人，目前没人能修改创始人角色)
            RoleId.visible(false);
            // 还原用户角色
            UserType.set("3");
            // 关闭modal
            $("#rolePermission").modal('hide');
        }

        /*
         * @desc 注册事件
         * */
        function regEvent() {
            // 判断之前是否已经注册过事件，如果注册过了就跳过
            if(typeof arguments.callee.regFlag != 'string') {
                arguments.callee.regFlag = 'reg';

                // 关闭窗口
                $('#rolePermissionClose, #rolePermissionCancel').on('click', roleCancel);

                // 提交表单
                $('#rolePermSubmit').on('click', roleSubmit);
            }
        }

        return {
            init: init
        };
    })();
</script>

