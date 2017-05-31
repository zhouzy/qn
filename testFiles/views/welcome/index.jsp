<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <title>首页下载页</title>
    <link href="<%=request.getContextPath()%>/static/css/welcome.css" type="text/css" rel="stylesheet"/>
</head>
<body>
    <div class="top-bar">
        <a href="<%=request.getContextPath()%>/"><img src="<%=request.getContextPath()%>/static/images/logo.png" class="logo"></a>
    </div>
    <div class="swapper-container">
        <div id="cphoneBox" class="content">
            <div class="left-part">
                <div class="part-header">
                    <img src="<%=request.getContextPath()%>/static/images/welcome/cphone-title.png">
                </div>
                <div class="part-body">
                    急速下载，一键安装<br/>
                    赋予网页多渠道能力
                </div>
                <div class="part-footer">
                    <a class="btn btn-download" href="" id="cphoneDownId">
                        <img src="<%=request.getContextPath()%>/static/images/welcome/Cphone.png">
                        CPhone下载
                    </a>
                </div>
            </div>
            <div class="right-part">
                <div class="response-img">
                    <img src="<%=request.getContextPath()%>/static/images/welcome/1-body.png">
                </div>
            </div>
        </div>
        <div id="appBox" class="content">
            <div class="left-part">
                <div class="response-img">
                    <img src="<%=request.getContextPath()%>/static/images/welcome/2-body.png">
                </div>
            </div>
            <div class="right-part">
                <div class="part-header">
                    <img src="<%=request.getContextPath()%>/static/images/welcome/cdesk-app-title.png">
                </div>
                <div class="part-body">
                    多渠道，强整合，便捷操作<br/>
                    及时响应，解决多变需求
                </div>
                <div class="part-footer">
                    <a class="btn btn-download" href="javascript:window.open('${iosUrl}')">
                        <img src="<%=request.getContextPath()%>/static/images/welcome/ios.png">
                        APP Store 下载</a>
                    <a class="btn btn-download" href="javascript:window.open('${androidUrl}')">
                        <img src="<%=request.getContextPath()%>/static/images/welcome/android.png">
                        Android 下载</a>
                </div>
                <div class="qrcode-img" ><img alt="" height="160" width="160" src="<%=request.getContextPath()%>/static/images/qrCode.jpg"></div>
            </div>
        </div>
        <div class="swapper-btns">
            <a id="cphoneBoxBtn" href="#" class="swapper-btn active"></a>
            <a id="appBoxBtn" href="#" class="swapper-btn"></a>
        </div>
    </div>
<script src="<%=request.getContextPath()%>/script/lib/jquery/dist/jquery.js" ></script>
<script>
    var timer = null;
    var swapper = function(){
        var $box = $("#appBox");
        var width = $box.width();
        $box[0].style = 'transform:translateX(' + width + 'px);';
    };

    $(function() {
    	swapper();

        var cphoneUrl="${cphoneUrl}" || "http://<%=request.getServerName()%>:<%=request.getServerPort()%>/tools/CPhoneSetup.exe";

        $('#cphoneDownId').attr('href', cphoneUrl);
        
        $("#appBoxBtn").click(function(){
            if(!$(this).is('.active')){
                var $box = $("#cphoneBox"),$appBox = $('#appBox'),width = $box.width();
                $box.css('transform','translateX(' + (-width) + 'px)');
                $appBox.css('transform','translateX('+ (-width) +'px)');
                $("#cphoneBoxBtn,#appBoxBtn").toggleClass('active');
                if(timer){
                    clearTimeout(timer);
                    timer = window.setTimeout(swap,10*1000);
                }
            }
        });

        $("#cphoneBoxBtn").click(function(){
            if(!$(this).is('.active')) {
                var $box = $("#cphoneBox"), $appBox = $('#appBox'), width = $box.width();
                $box.css('transform', 'translateX(' + 0 + 'px)');
                $appBox.css('transform', 'translateX(' + 0 + 'px)');
                $("#cphoneBoxBtn,#appBoxBtn").toggleClass('active');
                if(timer){
                    clearTimeout(timer);
                    timer = window.setTimeout(swap,10*1000);
                }
            }
        });

        var swap = function(){
            if(!$('#cphoneBoxBtn').is('.active')){
                $("#cphoneBoxBtn").click();
            }
            else{
                $("#appBoxBtn").click();
            }
            if(timer){
                clearTimeout(timer);
            }
            timer = window.setTimeout(swap,10*1000);
        };

        timer = window.setTimeout(swap,10*1000);
    });
</script>
</body>
</html>