<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>添加第三方集成</title>
    <%@include file="/views/include/pageHeader.jsp" %>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/static/css/selfField.css">
    <%--<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/static/css/userField.css">--%>
</head>
<body>
<div class="container-fluid">
    <ul class="breadcrumbs">
        <li>
            <a target="_self" href="<%=request.getContextPath()%>/integrations/index">第三方集成管理</a>
        </li>
        <li>添加第三方集成</li>
    </ul>
    <div class="panel">
        <form id="fieldForm">
            <div class="kf5-section">
                <div class="field t-col" style="margin-bottom: 0;padding-bottom: 20px;">
                    <div>
                        <h5 class="pull-left" style="width:100px;line-height:36px;">标题<span style="color:red;">*</span></h5>
                        <input name="integrationName" id="integrationName" maxlength="255" type="text">
                    </div>
                </div>
            </div>

            <div class="kf5-section">
                <div class="field t-col" style="margin-bottom: 0;padding-bottom: 20px;">
                    <div>
                        <h5 class="pull-left" style="width:100px;line-height:36px;">集成链接<span style="color:red;">*</span></h5>
                        <input name="integrationUrl" id="integrationUrl" maxlength="255" type="text">
                    </div>
                </div>
            </div>
            <!--操作栏   -->
            <div class="field field-operation text-right" style="padding-top: 20px;">
                <a onclick="cancel()" class="btn" href="javascript:void(0);" target="_self" style="width: 75px;color:#fff;background: #888;">取消</a>
                <input type="button" id="submitBtn" class="btn" onclick="addTemplate()" value="保存" style="width: 75px;color: #fff;background: #009688;">
            </div>
        </form>
    </div>
</div>

<script type="text/javascript">
    /* 添加集成工具模板 */
    function addTemplate(){
        /* 标题不能为空 */
        var linkURL= $("#integrationUrl").val();
        var linkName= $("#integrationName").val();
        var pattern = /^((https|http|ftp|rtsp|mms)?:\/\/)[^\s]+/;
        if(linkName==""){
            notice.warning("请输入标题!");
            return false;
        }
        if(linkURL==""){
            notice.warning("请输入集成链接!");
            return false;
        }
        if(!pattern.test(linkURL)){
            $("#integrationUrl").val("http://" + linkURL);
        }
        /* 避免连续点击重复提交 */
        $("#submitBtn").attr("disabled","disabled");
        $.ajax({
            url: "<%=request.getContextPath()%>/integrations/addIntegration",
            type:"post",
            dataType: 'json',
            data: $("#fieldForm").serialize(),
            success: function (data) {
                if (data.success) {
                    /* 返回工具管理界面 */
                    var title=linkName;
                    notice.success("第三方工具：" + title + "&nbsp;" + " 集成成功！");
                    location.href="<%=request.getContextPath()%>/integrations/index";
                }else {
                    /* notice.warning("添加集成工具失败！"); */
                    notice.warning(data.msg);
                    $("#submitBtn").removeAttr("disabled");
                }
            }
        });
    }

    /* 返回模板列表页 */
    function cancel(){
        location.href="<%=request.getContextPath()%>/integrations/index";
    }

</script>
</body>
</html>
