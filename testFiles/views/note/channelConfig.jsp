<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>短信渠道配置</title>
    <%@include file="/views/include/pageHeader.jsp"%>
    <link data-origin-file="innerFrame.css" rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/static/css/innerFrame.css">
    <link data-origin-file="note.css" rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/static/css/note.css">
    <link data-origin-file="note-config.css" rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/static/css/note-config.css">
    <link data-origin-file="block-loading.css" rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/static/css/block-loading.css">
</head>
<body>
<div class="note-contain-wrapper">
    <header class="part-header">
        <span>短信渠道配置</span>
    </header>
    <div class="right-content">
        <div class="right-content-panel container-fluid">
            <div class="row">
                <div class="col-sm-12">
                    <div class="panel">
                        <div class="panel-body" style="position: relative;">
                            <%--展示区域--%>
                            <div class="row" id="showBox">
                                <div class="col-sm-12">
                                    <div class="togglebutton form-group">
                                        <label class="control-label">
                                            短信渠道(开/关)：
                                            <input type="checkbox" id="channelToggleBtn">
                                        </label>
                                    </div>
                                </div>

                                <div class="col-sm-12">
                                    <label class="control-label">
                                        短信渠道已配置账号：<span id="curCountText" class="note-config__count-text"></span>
                                    </label>
                                    <button class="btn btn-xs btn-raised btn-primary" id="editBtn" disabled>修改</button>
                                </div>
                            </div>

                            <%--编辑区域--%>
                            <div class="form-horizontal" id="editBox" style="display: none;">
                                <div class="row">
                                    <p class="col-sm-12">
                                        短信渠道已配置账号：<span id="editCurCountText" class="note-config__count-text">暂未配置</span>
                                    </p>
                                    <div class="col-sm-12">
                                        短信渠道配置：
                                    </div>
                                </div>

                                <div class="form-group col-sm-12">
                                    <label class="pull-left control-label">账号(必填)：</label>
                                    <div class="col-sm-6">
                                        <input type="text" class="form-control" id="account" name="account" required>
                                    </div>
                                </div>
                                <div class="form-group col-sm-12">
                                    <label class="pull-left control-label">密码(必填)：</label>
                                    <div class="col-sm-6">
                                        <input type="password" class="form-control" id="password" name="password" required autocomplete="new-password">
                                    </div>
                                </div>

                                <div class="form-group col-sm-12">
                                    <div class="pull-left">
                                        <button class="btn btn-raised btn-xs" id="cancelBtn">取消</button>
                                    </div>
                                    <div class="col-sm-6" style="padding-right: 0">
                                        <button class="btn btn-raised btn-xs btn-primary col-sm-offset-4 pull-right" id="submitBtn">提交</button>
                                    </div>
                                </div>
                            </div>

                            <%--配置成功--%>
                            <div class="note-config__alert-box panel setting-success" id="successAlertBox">
                                <i class="fa fa-times close"></i>
                                <div>
                                    <i class="fa fa-check success"></i> 短信渠道配置成功
                                </div>
                                <div class="message"></div>
                            </div>
                            <%--配置失败--%>
                            <div class="note-config__alert-box panel setting-fail" id="failAlertBox">
                                <i class="fa fa-times close"></i>
                                <div>
                                    <i class="fa fa-times fail"></i> 短信渠道配置失败
                                </div>
                                <div class="message"></div>
                            </div>

                            <%--遮罩层--%>
                            <div class="block-loading__root" id="blockLoading" style="display: none;">
                                <div class="block-loading__spinner-box">
                                    <div class="block-loading__spinner-wave-dots"></div>
                                    <p class="block-loading__loading-desc">努力加载中···</p>
                                </div>
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
    // 当前类型(编辑/添加)，全局
    var curType_G = 'add';
    // 配置信息(全局)
    var configInfo_G = {};
    $(function() {

        // 遮罩层
        var $blockLoading = $('#blockLoading');

        $blockLoading.show();
        // 获取短信渠道配置信息
        getChannelConfig().done(function(data) {
            if(!data.success) {
                return notice.danger(data.msg);
            }

            var rows = data.rows;

            // 根据返回值，判断是添加还是编辑
            if(rows == null) { // 为null，不存在数据，则添加
                curType_G = 'add';
                $('#showBox').hide();
                $('#editBox').show();
            } else { // 有数据，则编辑
                curType_G = 'edit';
                configInfo_G.configId = rows.SMSConfigId;
                configInfo_G.account = rows.apName;
                configInfo_G.password = rows.apPassword;
                configInfo_G.openStatus = rows.status;

                toShowBox(rows.apName);
                // 修改切换样式并触发相应事件(不发请求)
                $('#channelToggleBtn').prop('checked', rows.status === '1').trigger('change', [true]);
            }
        }).always(hideBlockLoading);

        // 注册事件
        regEvent();
    });

    // 获取短信渠道配置信息
    function getChannelConfig() {
        return $.get('<%=request.getContextPath()%>/SMSConfig/findSMSConfig');
    }

    // 添加短信渠道配置信息
    function addChannelConfig(account, password) {
        return $.post('<%=request.getContextPath()%>/SMSConfig/addSMSConfig', {
            account: account,
            password: password
        }).done(function (data) {
            if(!data.success) {
                return showAlertBox('fail', '失败原因：' + data.msg);
            }

            showAlertBox('success', '成功为短信渠道添加账号：' + account);
        });
    }

    // 更新短信渠道配置信息
    function updateChannelConfig(configId, account, password, openStatus, isUpdateSwitch) {
        var param = {
            SMSConfigId: configId,
            account: account,
            password: password,
            status: openStatus,
            // 是否只修改开关
            isUpdateSwitch: isUpdateSwitch || '0'
        };

        // 移除没有传的字段
        Object.keys(param).forEach(function(item) {
            if(param[item] == null) {
                delete param[item];
            }
        });

        return $.post('<%=request.getContextPath()%>/SMSConfig/updateSMSConfig', param).done(function (data) {
            if(!data.success) {
                return showAlertBox('fail', '失败原因：' + data.msg);
            }

            if(param.isUpdateSwitch === '1') {
                return;
            }

            // 成功提示
            showAlertBox('success', '成功为短信渠道修改账号：' + account);

            configInfo_G.account = param.account;
            configInfo_G.password = param.password;

            // 切换到展示页面
            toShowBox(param.account);
        });
    }

    // 显示相应type和text的提示框
    function showAlertBox(type, text) {
        var $alertBox = null;
        // 确定提示框类型
        if(type === 'success') {
            $alertBox = $('#successAlertBox');
        } else {
            $alertBox = $('#failAlertBox');
        }

        $alertBox.show().find('.message').text(text);
    }

    // 切换到展示页面
    function toShowBox(account) {
        $('#showBox').show();
        $('#editBox').hide();

        $('#curCountText').text(account);
    }

    // 切换到编辑页面
    function toEditBox(account, password) {
        $('#showBox').hide();
        $('#editBox').show();

        $('#editCurCountText').text(account);
        $('#account').val(account);
        $('#password').val(password);
    }

    // 隐藏遮罩层
    function hideBlockLoading() {
        $('#blockLoading').hide();
    }

    // 注册事件
    function regEvent() {
        // 关闭弹出框
        var $closeBox = $('.note-config__alert-box .close');
        // 短信渠道开关
        var $channelToggleBtn = $('#channelToggleBtn');
        // 修改按钮
        var $editBtn = $('#editBtn');
        // 提交按钮
        var $submitBtn = $('#submitBtn');
        // 取消按钮
        var $cancelBtn = $('#cancelBtn');
        // 防抖动更新配置
        var debounceUpdateConfig = _.debounce(updateChannelConfig, 1000, {maxWait: 4000});

        // 关闭弹出框
        $closeBox.on('click', function () {
            $(this).parent('.note-config__alert-box').hide();
        });

        // 短信渠道开关change事件
        $channelToggleBtn.on('change', function(event, isByTrigger) {
            // 是否打开
            var isOpen = this.checked;

            if(isOpen === true) { // 打开
                $editBtn.prop('disabled', false);
            } else {
                $editBtn.prop('disabled', true);
            }

            // 如果是手动触发，则不发请求
            if(isByTrigger) {
                return;
            }

            // 防抖动更新配置
            debounceUpdateConfig(configInfo_G.configId, null, null, isOpen === true ? '1' : '0', '1');
        });

        // 修改按钮点击事件
        $editBtn.on('click', function () {
            toEditBox(configInfo_G.account, configInfo_G.password);
        });

        // 取消按钮点击事件
        $cancelBtn.on('click', function () {
            $('#showBox').show();
            $('#editBox').hide();
        });

        // 提交按钮点击事件
        $submitBtn.on('click', function () {
            var $blockLoading = $('#blockLoading');
            var $account = $('#account');
            var $password = $('#password');

            if($account.val().trim() === '') {
                return notice.danger('账号不能为空！');
            }

            if($password.val().trim() === '') {
                return notice.danger('密码不能为空！');
            }

            $blockLoading.show();
            // 根据类型判断发送哪种请求(编辑/添加)
            if(curType_G === 'add') { // 添加
                addChannelConfig($account.val().trim(), $password.val().trim()).done(function() {
                    getChannelConfig().done(function(data) {
                        if(!data.success) {
                            return showAlertBox('fail', '失败原因：' + data.msg);
                        }

                        var rows = data.rows;

                        if(rows != null) {
                            curType_G = 'edit';
                            configInfo_G.configId = rows.SMSConfigId;
                            configInfo_G.account = rows.apName;
                            configInfo_G.password = rows.apPassword;
                            configInfo_G.openStatus = rows.status;

                            // 切换到展示页面
                            toShowBox(rows.apName);
                        }
                    })
                }).always(hideBlockLoading);
            } else {
                updateChannelConfig(configInfo_G.configId, $account.val().trim(), $password.val().trim()).always(hideBlockLoading);
            }
        });
    }
</script>
</html>