<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <%@include file="/views/include/pageHeader.jsp"%>
    <script src="<%=request.getContextPath()%>/script/lib/PCASClass.js"></script>
    <title>企业信息</title>
</head>
<body>
<div class="container-fluid">
    <div class="row">
        <div class="col-md-12">
        <div class="panel">
            <div class="bg-danger text-center" style="padding:15px;margin-bottom:15px;">
                <p>请如实填写以下信息，它将作为我们向您提供服务的重要依据，我们务必会对您的资料保密。</p>
            </div>
            <form id="yw0" action="#" method="post" class="form-horizontal">
                <input name="entId" type="hidden" value="${entVo.entId}" />
                <div class="form-group">
                    <label class="control-label col-md-2" for="Company_name">公司名称</label>
                    <div class="col-md-9">
                        <input name="entName" class="form-control" id="Company_name" type="text" value="${entVo.entName}" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-md-2" for="Company_industry">行业</label>
                    <div class="col-md-9">
                        <select name="industry" class="form-control" id="Company_industry">
                            <option value="0">--请选择行业--</option>
                            <option value="1">教育</option>
                            <option value="2">娱乐/艺术</option>
                            <option value="3">金融/保险</option>
                            <option value="4">医疗/保健</option>
                            <option value="5">制造业</option>
                            <option value="6">电讯/媒体</option>
                            <option value="7">广告/市场</option>
                            <option value="8">小型企业支持</option>
                            <option value="9">咨询/顾问</option>
                            <option value="10">房地产</option>
                            <option value="11">零售业</option>
                            <option value="12">互联网/IT</option>
                            <option value="13">旅游业</option>
                            <option value="14">公共事业</option>
                            <option value="15">非盈利组织</option>
                            <option value="16">其他</option>
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-md-2" for="Company_scale">规模</label>
                    <div class="col-md-9">
                        <select name="scale" class="form-control" id="Company_scale">
                            <option value="1">5人以下</option>
                            <option value="2">5-19人</option>
                            <option value="3">20-99人</option>
                            <option value="4">100-499人</option>
                            <option value="5">500人以上</option>
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-md-2" for="Company_admin_name">联系人</label>
                    <div class="col-md-9">
                        <input name="contactUser" class="form-control" id="Company_admin_name" type="text" value="${entVo.contactUser}" />
                        <p class="help-block">请填写真实的联系人姓名，以便我们必要时能及时联系你</p>
                    </div>
                </div>
                <div class="form-group">
                    <label class="control-label col-md-2" for="Company_province">省市区</label>
                    <div class="col-md-3">
                        <select name="province" class="form-control" id="Company_province"></select>
                    </div>
                    <div class="col-md-3">
                        <select name="city" class="form-control" id="Company_city"></select>
                    </div>
                    <div class="col-md-3">
                        <select name="area" class="form-control" id="Company_area"></select>
                    </div>
                </div>
                <div class="form-group">
                    <label for="Company_address" class="control-label col-md-2">地址</label>
                    <div class="col-md-9">
                        <input name="address" class="form-control" id="Company_address" type="text" value="${entVo.address}" />
                        <p class="help-block">请精确至街道，方便我们邮寄发票或礼品</p>
                    </div>
                </div>
                <div class="form-group">
                    <label for="Company_mailcode" class="control-label col-md-2">邮政编码</label>
                    <div class="col-md-9">
                        <input class="form-control" name="zipCode" id="Company_mailcode" type="text" value="${entVo.zipCode}" />
                    </div>
                </div>
                <div class="form-group">
                    <div class="col-md-8 col-md-offset-3 text-right">
                        <button class="btn btn-sm btn-success btn-raised" type="button" name="yt0" value="提交" onclick="onSubmit();">提交</button>
                    </div>
                </div>
            </form>
        </div>
        </div>
    </div>
</div>
<script type="text/javascript">
    $(function(){
        $("#Company_industry").val('${entVo.industry}');
        $("#Company_scale").val('${entVo.scale}');
        new PCAS("province","city","area","${entVo.province}","${entVo.city}","${entVo.area}");
    });

    function onSubmit() {
        $.post("<%=request.getContextPath()%>/ent/update", $("#yw0").serialize(), updateCallBack, 'json');
    }

    function updateCallBack(data) {
        if (data.success) {
            notice.alert(data.msg);
            window.location.href = '<%=request.getContextPath()%>/cloud/company';
        } else {
            notice.alert(data.msg,"alert-danger");
        }
    }
</script>
</body>
</html>
