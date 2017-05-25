<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>门户登陆</title>
    <link rel="icon" type="image/x-icon" href="<%=request.getContextPath()%>/${faviconUrl}" />
    <%@include file="/views/include/pageHeader.jsp"%>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/static/css/normalize.css">
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/static/css/enter.css">

    <style type="text/css">
    	#pwdDiv .btn_main[disabled]{
    		cursor: not-allowed;
    		background: #d8d4d4;
    	}

        #helpBtn {
            display: none !important;
        }
    </style>
</head>
<body>
<header class="head">
    <div class="wrap hader-inner clearfix">
        <div class="logo">
            <img src="<%=request.getContextPath()%>/${logoUrl}" />
        </div>
    </div>
</header>
<main>
    <section class="content content__center">
        <!-- 用户登录 -->
        <div class="SignIn-1" id="loginDiv">
            <div class="form-login-box">
                <form action="<%=request.getContextPath()%>/login" onsubmit="return toValidateLogin()" method="post">
                    <input type="hidden" value="" name="entId" id="UserLoginForm_endId"/>
                    <div>
                        <label for="UserLoginForm_username" class="login-label">登录账号</label>
                        <input class="text username login-control" placeholder="登录账号" id="UserLoginForm_username" name="loginName" type="text" />
                    </div>
                    <div>
                        <label for="UserLoginForm_password" class="login-label">密码</label>
                        <input class="text password login-control" placeholder="密码" id="UserLoginForm_password" name="password"  type="password" />
                    </div>
                    <div id="extensionTypeBox">
                        <label for="extensionType" class="login-label">分机类型</label>
                        <select class="login-control" id="extensionType" name="extensionType" onchange="extensionTypeChange(this);">
                            <option value="1">软电话</option>
                            <option value="2">固话&手机</option>
                            <option value="3">SIP电话</option>
                        </select>
                    </div>
                    <div id="telNumBox" style="display: none;">
                        <label for="telNum" class="login-label">手机或固话号码</label>
                        <input class="text login-control" id="telNum" type="text" name="telNum" placeholder="使用固话号码时请输入区号">
                    </div>
                    <div id="SIPBox" style="display: none;">
                        <label for="sipNum" class="login-label">SIP电话</label>
                        <input class="text login-control sip-input" id="sipNum" type="text" name="sipNum" placeholder="请输入sip号码">
                        <div class="sip-type-box">
                            <label class="sip-type-label">
                                <input type="radio" name="sipUseCphone" value="1" checked>SIP软电话
                            </label>
                            <label class="sip-type-label">
                                <input type="radio" name="sipUseCphone" value="0">SIP硬件电话
                            </label>
                        </div>
                    </div>
                    <p class="login-to-right">
                        <input class="checkbox" id="rmCheckBox" name="rememberMe"  value="1" type="checkbox">
                        <label for="rmCheckBox">在本机记住我，下次自动登录</label>
                    </p>
                    <p class="login-to-right" style="color:red;" id="errMsg">${errMsg}</p>
                    <input class="submit-btn" type="submit" name="yt0" value="登录">
                    <input type="hidden" name="phoneNum" id="phoneNum">
                </form>
            </div>
            <div class="form-login-box tc">
                <a href="javascript:void(0);" onclick="goForgetPwd()">没有密码？忘记密码？</a>
            </div>
        </div>

        <!-- 忘记密码 -->
        <div class="SignIn-2" id="pwdDiv" style="display: none;">
            <div class="form-login-box">
                <form class="yw0">
                    <p>请输入您的注册邮箱，我们会发送邮件让您设置密码</p>
                    <div>
                        <label class="login-label">邮箱地址</label>
                        <input class="text username login-control" placeholder="邮箱地址" name="User[username]" id="emailPwd" type="text" />
                    </div>
                    <div>
                        <label class="login-label">验证码</label>
                        <input class="text captcha_field login-control" placeholder="验证码" name="User[code]" id="picCodePwd" type="text" />
                        <p class="code-pic login-to-right">
                            <img id="verificationCodeImgPwd" src="<%=request.getContextPath()%>/CheckCodeServlet" alt="" />
                            <a id="yw1_button" href="javascript:void(0);" onclick="updatePwdCode()">刷新验证码</a>
                        </p>
                    </div>
                    <input class="btn_main submit-btn" type="button" name="yt0" onclick="goResetPwd()" value="提交" />
                </form>
            </div>
            <div class="form-login-box tc">
                如果您已有账号，<a href="javascript:void(0);" onclick="goLogin()">请登录以追踪您提交的问题</a>
            </div>
        </div>
        <!--用户注册 -->
        <div class="SignIn-3" id="registDiv" style="display: none;">
            <div class="form-login-box">
                <form id="member-form">
                    <div>
                        <label for="email">邮箱账号</label>
                        <input class="text username" placeholder="邮箱账号" id="email" name="email"  type="text" />
                    </div>
                    <div>
                        <label for="nickName">昵称</label>
                        <input class="text username" placeholder="你的昵称" id="nickName" name="nickName"  type="text"  />
                    </div>
                    <div>
                        <label for="picCode">输入验证码</label>
                        <input class="text captcha_field" placeholder="验证码" name="picCode" id="picCode" type="text"  />
                        <div class="code-pic">
                            <img id="verificationCodeImg" class="yw0" src="<%=request.getContextPath()%>/CheckCodeServlet" alt="" />
                            <a id="yw0_button" href="javascript:void(0);" onclick="updateCode()">看不清，换一张</a>
                        </div>
                    </div>
                    <input class="btn_main" type="button" name="yt0" value="注册" onclick="registerBase()" />
                </form>
            </div>
            <div class="form-login-box tc">
                如果您已有账号，<a href="javascript:void(0);" onclick="goLogin()">请登录以追踪您提交的问题</a>
            </div>
            <!-- 注册后跳转页面   -->
            <form style="display:none" action="<%=request.getContextPath()%>/userMongo/regSuccess" id="registJump" method="post">
                <input type="text" id="emailForJump" name="email" />
                <input type="text" id="nickForJump" name="nickName" />
                <input type="text" id="codeForJump" name="code" />
            </form>
        </div>
    </section>
    <div class="operations-group">
        <div class="operation-box">
            <div class="icon-box download" id="goDownloadBtn" title="下载">
                <i class="fa fa-download" aria-hidden="true"></i>
            </div>
            <span>下载</span>
        </div>
        <div class="operation-box">
            <div class="icon-box help" id="goHelpBtn" title="帮助">
                <i class="fa fa-question-circle-o" aria-hidden="true"></i>
            </div>
            <span>帮助</span>
        </div>
    </div>
</main>
<%--<footer class="enter__root">
    <p class="enter__detail-paragraph">
        青牛（北京）技术有限公司<br>
        客服电话：010-11686844
    </p>
</footer>--%>
<script type="text/javascript">
    $(function () {
        if ('${regist}' == "yes") {
            goRegisterUser();
        }
        else {
            $('#pwdDiv,#registDiv').hide();
        }

        getEntId();
        regEvent();
    });

    // 切换分机类型
    function extensionTypeChange(ele) {
        var type = ele.value;
        var $telNumBox = $('#telNumBox');
        var $SIPBox = $('#SIPBox');

        // 清空输入框内容
        $('#telNum').val('');
        $('#sipNum').val('');
        $('#errMsg').text('');

        if(type === '1') { // 软电话
            $telNumBox.hide();
            $SIPBox.hide();
        } else if(type === '2') { // 手机或者固话
            $SIPBox.hide();
            $telNumBox.show();
        } else if(type === '3') { // SIP号码
            $telNumBox.hide();
            $SIPBox.show();
        }
    }

    function getEntId() {
        var hostName = location.host;
        var entId = hostName.substring(0, hostName.indexOf("."));
        $("#UserLoginForm_endId").val(entId);
    }

    function goResetPwd() {
        $("#pwdDiv").find('.btn_main').prop("disabled", true);
        $(this).attr("disabled", "disabled");
        var $emailPwd = $('#emailPwd'),
                emailPwdValue = $emailPwd.val(),
                $picCodePwd = $("#picCodePwd"),
                picCodePwdValue = $picCodePwd.val();
        if (Tools.mailCheck(emailPwdValue) === false) {
            notice.warning("请输入正确的邮箱格式！");
            return;
        }
        if (emailPwdValue == "" || picCodePwdValue == "") {
            showRedBorder($('#emailPwd,#picCodePwd'));
            return;
        }
        var param = {
            email: emailPwdValue,
            picCode: picCodePwdValue
        };
        $.post("<%=request.getContextPath()%>/userMongo/forgetPwd", param, forgetCallBack);
    }

    function forgetCallBack(data) {
        var $pwdDiv = $('#pwdDiv');

        if (data.success === true) {
            notice.success(data.msg);
        } else {
            notice.danger(data.msg || "找回密码失败，请重试!");
            updatePwdCode();
            $pwdDiv.find(".btn_main").prop("disabled", false);
        }
    }

    function goForgetPwd() {
        updatePwdCode();
        $('#loginDiv,#pwdDiv,#registDiv').hide();
        $('#pwdDiv').show();
        $('.SignIn-1 h2').html("忘记密码");
    }

    function goRegisterUser() {
        updateCode();
        if ('${email}' != null) {
            $("#registDiv #email").val('${email}');
        }
        $('#loginDiv,#pwdDiv,#registDiv').hide();
        $('#registDiv').show();
        $('.SignIn-1 h2').html("用户注册");
    }

    function goLogin() {
        $('#loginDiv,#pwdDiv,#registDiv').hide();
        $('#loginDiv').show();
        $('.SignIn-1 h2').html("用户登录");
    }

    function updateCode() {
        document.getElementById("verificationCodeImg").src = "<%=request.getContextPath()%>/CheckCodeServlet" + "?id=" + new Date().getTime();
    }

    function updatePwdCode() {
        document.getElementById("verificationCodeImgPwd").src = "<%=request.getContextPath()%>/CheckCodeServlet" + "?id=" + new Date().getTime();
    }

    function registerBase() {
        var $email = $("#email"),
                email = $email.val(),
                $picCode = $('#picCode'),
                picCode = $picCode.val(),
                $nickName = $('#nickName').val(),
                nickName = $nickName.val();
        if (Tools.mailCheck(email) === false) {
            notice.warning("请输入正确的邮箱格式！");
            return;
        }
        if (email == "" || picCode == "" || nickName == "") {
            showRedBorder($('#email,#picCode,#nickName'));
            return;
        }

        var param = {
            email: email,
            nickName: nickName,
            picCode: picCode
        };
        $.post("<%=request.getContextPath()%>/userMongo/registerBase", param, baseCallBack);
    }

    var showRedBorder = function ($e) {
        $e.each(function () {
            var $input = $(this);
            if ($input.val() === "") {
                $input.css('border', 'solid 2px red');
                window.setTimeout(function ($i) {
                    return function () {
                        $i.css('border', 'none');
                    };
                }($input), 150);
            }
        });
    };

    function baseCallBack(data) {
        if (data.success) {
            notice.alert(data.msg);
            $("#emailForJump").val($("#email").val());
            $("#nickForJump").val($("#nickName").val());
            $("#codeForJump").val(data.rows);
            $("#registJump").submit();
        } else {
            notice.warning(data.msg);
            updateCode();
        }
    }

    // 验证登录信息
    function toValidateLogin() {
        var userName = $('#UserLoginForm_username').val();
        var $errMsg = $('#errMsg');
        var errMsg = '';

        if (!userName) {
            errMsg = '请输入登录账号';
        }

        var pwd = $('#UserLoginForm_password').val();
        if (!pwd) {
            errMsg = '请输入密码';
        }

        // 分机类型
        var extensionType = $('#extensionType').val();
        // 最终需要的分机号码
        var $phoneNum = $('#phoneNum');

        var $telNum = $('#telNum');
        var $sipNum = $('#sipNum');
        var telNum = $telNum.val().trim();
        var sipNum = $sipNum.val().trim();

        if(extensionType === '2') {
            if(telNum === '') {
                errMsg = '手机或固话号码值不能为空';
            } else if(/^[0-9]*$/.test(telNum) === false) {
                errMsg = '手机或固话号码值只能是数字';
            }
        } else if(extensionType === '3') {
            if(sipNum === '') {
                errMsg = 'SIP电话值不能为空';
            } else if(/^[0-9]*$/.test(sipNum) === false) {
                errMsg = 'SIP电话值只能是数字';
            }
        }

        if(errMsg != '') {
            $errMsg.text(errMsg);
            return false;
        }

		/**
		 * PSTN和SIP电话，北京多渠道是根据我们提供的分机号码前缀来确定的，如果前缀是"tel:"那么会使用PSTN
		 * 如果是"sip:"那么会使用sip分机，然后再根据sip分机类型来确定是使用sip软电话或者sip硬件电话
		 */
        // 根据号码类型拼接成phoneNum发送到后端(为了不修改现网的后端，做的临时解决方案)
        if(telNum !== '') {
            $phoneNum.val('tel:' + telNum);
        } else if(sipNum !== '') {
            $phoneNum.val('sip:' + sipNum);
        }
    }

    function regEvent() {
        $('#goHelpBtn').on('click', function() {
            $('#helpBtn').click();
        });

        $('#goDownloadBtn').on('click', function() {
            window.location.href = '<%=request.getContextPath()%>/welcome';
        });
    }
</script>
<%-- 开发环境公网地址 --%>
<script src='${IM_ROOT}/IM.js'></script>
<script>
    window.onload = function(){
        IM.init({ useLocal : false,entId:'${ccodEntId}',skillGroupId:'${skillId}',type:'IM',customPriority : '1000'});
    };
</script>
</body>
</html>