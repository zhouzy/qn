<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<div id="addUserModal" class="modal fade bs-example-modal-sm" data-backdrop="static" style ="overflow:auto;">
    <div class="modal-dialog" style="width:900px;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <span class="modal-title">添加新客户</span>
            </div>
            <div class="modal-body">
                <div class="container-fluid" >
                    <form id="formId" class="row form-horizontal" autocomplete="off">
                        <!-- 角色权限 -->
                        <div class="form-group col-md-6" style="display: none">
                            <p class="help-block" style="text-align: right; top: -15px; right: 30px;">普通用户是外部提交工单的用户角色</p>
                            <label for="typeSelect" class="control-label col-md-4"><span style="color:red">*</span>用户角色:</label>
                            <div class="col-md-8">
                                <select class="form-control" name="userType" id="typeSelect"></select>
                            </div>
                        </div>

                        <div class="col-md-6 form-group" id="secondTypeGroup" style="display:none;">
                            <label for="secondType" class="control-label col-md-4" style="float:left;display:none">角色权限:<span style="color:red">*</span></label>
                            <div class="col-md-8">
                                <select class="form-control" id="secondType"></select>
                            </div>
                        </div>
                        <div style="display:none">
                            <input type="text" class="form-control" name="roleId" id="roleId">
                        </div>
                        <!-- 账号密码(必填) -->
                        <div class="col-md-6 form-group">
                            <label class="control-label col-md-4">登录账号：<span style="color:red">*</span></label>
                            <div class="col-md-8">
                                <input type="text" class="form-control" name="lgNm" id="lgNm" placeholder="建议使用邮箱或手机号">
                            </div>
                        </div>
                        <div class="col-md-6 form-group">
                            <input type="password" style="display:none;">
                            <label class="col-md-4 control-label">密码：<span style="color:red">*</span></label>
                            <div class="col-md-8">
                                <input type="text" class="form-control" name="loginPwd" id="passWord"  placeholder="请设置客户初始密码" autocomplete="off">
                            </div>
                        </div>
                        <!-- 客户归属客服组 -->
                        <div class="col-md-6 form-group">
                            <label class="control-label col-md-4">归属组：</label>
                            <div class="col-md-8">
                                <input type="text" class="form-control" data-name = "归属组" name="serviceGroupName" id="serviceGroupName" onfocus="$(this).blur();" onclick="getDataTableServiceGroup(this);" data-target="#serviceGroupModal" placeholder="请点击选择归属组">
                            </div>
                        </div>
                        <!-- 客户归属客服 -->
                        <div class="col-md-6 form-group">
                            <label class="control-label col-md-4">归属人：</label>
                            <div class="col-md-8">
                                <input type="text" class="form-control" data-name = "归属人" name="serviceName" id="serviceName" onfocus="$(this).blur();" onclick="getDataTableServiceGroup(this);" data-backdrop="false" data-target="#serviceGroupModal" placeholder="请点击选择归属人">
                            </div>
                        </div>

                        <!-- 其他信息(可选) -->
                        <div class="col-md-6 form-group">
                            <label class="control-label col-md-4">邮箱:</label>
                            <div class="col-md-8">
                                <input type="email" class="form-control" name="email" id="inputPassword3" placeholder="">
                            </div>
                        </div>

                        <!-- 客户姓名(必填) -->
                        <div class="col-md-6 form-group">
                            <label class="control-label col-md-4">客户姓名:<span id="star" style="color:red;display:none">*</span></label>
                            <div class="col-md-8">
                                <input type="text" class="form-control" name="usrNm" id="addUsrNm"  >
                            </div>
                        </div>

                        <div class="col-md-6 form-group">
                            <label class="control-label col-md-4">手机:</label>
                            <div class="col-md-8">
                                <input type="text" class="form-control" name="telPhone" id="addUserPhone"  >
                            </div>
                        </div>
                        <div class="col-md-6 form-group">
                            <label class="control-label col-md-4">座机:</label>
                            <div class="col-md-8">
                                <input type="text" class="form-control" name="fixedPhone" id="fixedPhone" placeholder="">
                            </div>
                        </div>
                        <div class="col-md-6 form-group">
                            <label class="control-label col-md-4">客户说明:</label>
                            <div class="col-md-8">
                                <input type="text" class="form-control" name="uDesc" id="uDesc">
                            </div>
                        </div>
                        <div class="col-md-6 form-group">
                            <label class="control-label col-md-4">详细信息:</label>
                            <div class="col-md-8">
                                <input type="text" class="form-control" name="remark" id="remark" placeholder="">
                            </div>
                        </div>
                        <!-- 自定义字段-->
                        <div class="col-md-12">
                            <a id="openOrClose" data-state="open" class="btn btn-sm btn-block unfold text-center">展开</a>
                        </div>

                        <div id="userFieldUl" style="display: none;">
                        </div>
                    </form>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-raised btn-default btn-sm" data-dismiss="modal">取消</button>
                <button type="button" class="btn btn-raised btn-primary btn-sm" id="addUserSubmit">提交</button>
            </div>
        </div>
    </div>
</div>

<%--归属客服组或归属客服弹出框--%>
<%@include file="/views/customManager/chooseServiceGroup.jsp"%>

<!-- 1:字符串 -->
<script id="field-comp-1" type="text/x-handlebars-template">
    <div class="col-sm-6">
        <input id="{{key}}" type="text" name="{{key}}" data-label="{{name}}"  data-required="{{isRequired}}" data-name="{{key}}">
    </div>
</script>
<!-- 2:文本框 -->
<script id="field-comp-2" type="text/x-handlebars-template">
    <div class="col-sm-6" data-comp-type="textarea">
        <div class="form-group">
            <label class="control-label col-sm-4">{{name}}</label>
            <div class="col-sm-8">
                <textarea class="form-control" name="{{key}}" id="{{key}}" rows="4" data-required="{{isRequired}}" data-name="{{key}}" data-label="{{name}}"></textarea>
            </div>
        </div>
    </div>
</script>
<!-- 3:下拉框 -->
<script id="field-comp-3" type="text/x-handlebars-template">
    <div class="col-sm-6">
        <div class="form-group" >
            <label class="control-label col-sm-4">{{name}}</label>
            <div class="col-sm-8">
                <select class="form-control" id="{{key}}" name="{{key}}" data-name="{{key}}" data-required="{{isRequired}}" data-label="{{name}}">
                    <option value="">-</option>
                    {{#each candidateValue}}
                        <option value="{{this}}">{{this}}</option>
                    {{/each}}
                </select>
            </div>
        </div>
    </div>
</script>
<!-- 4:复选框 -->
<script id="field-comp-4" type="text/x-handlebars-template">
    {{#if covered}}
        <div class="col-sm-12">
            <div class="form-group">
                <label class="control-label col-sm-2" style="padding-right: 20px;">{{name}}</label>
                <div class="col-sm-10 checkbox" style="padding-left: 10px;">
                    {{#each candidateValue}}
                    <label>
                        <input type="checkbox" value="{{this}}" data-required="{{../isRequired}}" name="{{../key}}" data-label="{{../name}}">{{this}}
                    </label>
                    {{/each}}
                </div>
            </div>
        </div>
    {{else}}
        <div class="col-sm-6">
            <div class="form-group">
                <label class="control-label col-sm-4">{{name}}</label>
                <div class="col-sm-8 checkbox">
                    {{#each candidateValue}}
                    <label>
                        <input type="checkbox" value="{{this}}" data-required="{{../isRequired}}" name="{{../key}}" data-label="{{../name}}">{{this}}
                    </label>
                    {{/each}}
                </div>
            </div>
        </div>
    {{/if}}
</script>
<!-- 5:未定 -->
<script id="field-comp-5" type="text/x-handlebars-template">

</script>
<!-- 6:数字 -->
<script id="field-comp-6" type="text/x-handlebars-template">
    <div class="col-sm-6">
        <input id="{{key}}" type="text" name="{{key}}" data-label="{{name}}" data-reg="^-?\d+$" size="30" data-field="{{name}}" data-required="{{isRequired}}" data-name="{{key}}">
    </div>
</script>
<!-- 7:小数 -->
<script id="field-comp-7" type="text/x-handlebars-template">
    <div class="col-sm-6">
        <input id="{{key}}" type="text" name="{{key}}" data-label="{{name}}" data-reg="^-?\d+\.\d+$" data-field="{{name}}" data-required="{{isRequired}}" data-name="{{key}}">
    </div>
</script>
<!-- 8:正则表达式 -->
<script id="field-comp-8" type="text/x-handlebars-template">
    <div class="col-sm-6">
        <input id="{{key}}" type="text" name="{{key}}" data-label="{{name}}" data-reg="{{reg}}" data-field="{{name}}" data-required="{{isRequired}}" data-name="{{key}}">
    </div>
</script>
<!-- 9:电话号码 -->
<script id="field-comp-9" type="text/x-handlebars-template">
    <div class="col-sm-6">
        <input id="{{key}}" type="text" name="{{key}}" data-label="{{name}}" data-reg="{{reg}}" data-field="{{name}}" data-required="{{isRequired}}" data-name="{{key}}">
    </div>
</script>
<!-- 10:时间输入框 -->
<script id="field-comp-10" type="text/x-handlebars-template">
    <div class="col-sm-6">
        <input id="{{key}}" type="text" name="{{key}}" data-label="{{name}}" data-type="datetimepicker" data-reg="{{reg}}" data-field="{{name}}" data-required="{{isRequired}}" data-name="{{key}}">
    </div>
</script>
<!-- 11:省市区 -->
<script id="field-comp-11" type="text/x-handlebars-template">
    <div class="col-sm-12">
        <div class="form-group">
            <div class="col-sm-2" style="text-align: right">
                <label class="control-label">{{name}}</label>
            </div>

            <div class="col-sm-10">
                <div class="row">
                    <div class="col-sm-4">
                        <span><select class="form-control" data-field-type="pca"  name="province_{{key}}" id="AddUser_province{{key}}" data-label="{{name}}" data-required="{{isRequired}}" style="box-shadow: none;"></select></span>
                    </div>
                    <div class="col-sm-4">
                        <span><select class="form-control" data-field-type="pca" name="city_{{key}}" id="AddUser_city{{key}}" style="box-shadow: none;"></select></span>
                    </div>
                    <div class="col-sm-4">
                        <span><select class="form-control" data-field-type="pca" name="area_{{key}}" id="AddUser_area{{key}}" style="box-shadow: none;"></select></span>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <input type="hidden" name='AddUser{{key}}' id="{{key}}">
</script>
<script src="<%=request.getContextPath()%>/script/lib/PCASClass.js"></script>
<script>
    /*
     * @author Lesty
     * @codeDate 2016.8.6
     * @desc 创建一个全局对象，暴露相应接口，避免全局污染
     * */
    var addUserModal = (function() {
        function init() {
            /*
            * 每次都需要初始化的方法放这里
            * */
            // 重置表单
            resetForm();

            // 获取自定义字段
            getCustomizeFieldListData();

            /*
            * 只需要初始化一次的方法放这里
            * */
            if(typeof arguments.callee.initFlag != 'string') {
                arguments.callee.initFlag = 'init';

                /* 添加客户,根据权限动态加载客户类型 */
                setTypeSelect();

                // 注册事件
                regEvent();
            }
        }

        /*
        * @author Lesty
        * @codeDate 2016.8.6
        * @desc 重置表单
        * */
        function resetForm() {
            // 置空
            $("#formId input").val('');
            $("#formId select").val('');

            // 隐藏自定义字段
            if($('#openOrClose').data('state') === 'close') {
                openOrClose();
            }

            // 生成密码
            $("#passWord").val(Tools.createRandPwd(6));
        }

        /*
        * @desc 获取一条自定义字段的html
        * @data String [自定义字段数据]
        * @return Object [导入数据过后的html模板对象]
        * */
        function getOneField(data) {
            // 需要正则的componentType对象
            var regComps = {
                8: '8',
                9: '9',
                10: '10'
            };
            // 模板
            var fieldTemp = Handlebars.compile($('#field-comp-' + data.componentType).html());
            // 一条数据
            var $field = null;

            // 如果控件类型需要正则，则创建reg属性
            if(data.componentType in regComps) {
                data.reg = Array.isArray(data.candidateValue) ? data.candidateValue[0] : "";
            }

            // 复选框多于3个，则铺满一行
            if(data.componentType === '4' && data.candidateValue.length > 3) {
                data.covered = true;
            }

            // 生成数据
            $field = $(fieldTemp(data));

            return $field;
        }

        /*
        * @desc 省市区字段初始化
        * @prefix String [id前缀，避免冲突]
        * @PCAKeys Array [包含所有省市区字段key的数组]
        * */
        function pcasInit(prefix, PCAKeys) {
            //省市区字段初始化
            var pcaKey = '';
            for(var i = 0, len = PCAKeys.length; i < len; i++) {
                pcaKey = PCAKeys[i];
                new PCAS("#" + prefix +"_province" + pcaKey,"#" + prefix + "_city" + pcaKey,"#" + prefix + "_area" + pcaKey);
            }
        }

        /*
         * @author Lesty
         * @codeDate 2016.8.6
         * @desc [创建/刷新自定义字段列表]
         * @tableData Array [自定义字段列表数据]
         * */
        var createCustomizeFieldList = (function(){
            var $fieldList = $('#userFieldUl');

            return function(tableData) {
                var list = tableData ? tableData : [];
                var html = [];
                // 一个控件元素
                var $ele = null;
                // 一条数据
                var field = null;
                var PCAKeys = [];

                // 没有自定义字段
                if (list.length <= 0) {
                    $fieldList.empty().append("<strong style='font-size: 15px'>暂无自定义字段</strong>");
                    return;
                }

                // 遍历数据生成自定义字段列表
                for(var i = 0, len = list.length; i < len; i++) {
                    field = list[i];
                    // 保存省市区字段key用以初始化
                    if(field.componentType === '11') {
                        PCAKeys.push(field.key);
                    }

                    $ele = getOneField(field);
                    // 添加一条数据
                    html.push($ele);
                }

                // 创建表格
                $fieldList.empty().append(html);

                // 自定义字段渲染
                userFieldModule.render();

                // 省市区字段初始化
                pcasInit('AddUser', PCAKeys);

                // 绑定事件
//                $(':checkbox[required]').change(function(){
//                    var requiredCheckboxes = $(':checkbox[required]');
//                    if(requiredCheckboxes.is(':checked')) {
//                        requiredCheckboxes.removeAttr('required');
//                    } else {
//                        requiredCheckboxes.attr('required', 'required');
//                    }
//                });
            }
        })();

        /*
         * @author Lesty
         * @codeDate 2016.8.6
         * @desc [获取自定义字段列表数据]
         * */
        var getCustomizeFieldListData = (function(){
            return function(){
                $.ajax({
                    url: "<%=request.getContextPath()%>/newuserManage/getUsersFieldList",
                    dataType: 'json',
                    data: {
                    },
                    success: function(data) {
                        if(!(data.success)) {
                            notice.alert(data.msg);
                            return;
                        }

                        if(data.rows != null) {
                            createCustomizeFieldList(data.rows);
                        }
                    }
                });
            }
        })();

        // 添加客户,根据权限动态加载客户类型
        // @latest Lesty 2016.8.6
        function setTypeSelect(){
            // 选项内容HTML
            var optionHTML = '<option value="1" selected>客户</option>';

            $("#typeSelect").empty().append(optionHTML);
        }

        /*
        * @desc 获取所有省市区字段值
        * @prefix String [id前缀，为了使每个页面的id不冲突]
        * @return Object [包含key,value的省市区对象]
        * */
        function getPCASObject(prefix){
            var $fields = $("#userFieldUl").find('select[data-field-type=pca]');
            var PCAObject = {};
            var fieldKey = '';
            var fieldValue = '';
            var province  = '';
            var city = '';
            var area = '';


            $fields.each(function () {
                fieldKey = this.name.split('_')[1];
                province  = $('#' + prefix + '_province'+fieldKey).val();
                city = $('#' + prefix + '_city'+fieldKey).val();
                area = $('#' + prefix + '_area'+fieldKey).val();
                // 获取合并值
                if(province !== '') {
                    fieldValue = (province + ',' + city + ',' + area).replace(/,+$/g, "");
                } else {
                    fieldValue = '';
                }

                // 每个省市区字段field需要一个前缀做区分
                $("#" + prefix + fieldKey).val(fieldValue);
                // 但是传到后台时还是要传fieldKey,不能有前缀
                PCAObject[fieldKey] = fieldValue;
            });

            return PCAObject;
        }

        /*
         * @desc 所有默认字段格式检测
         * @return true:格式正确 false:格式错误
         * */
        function allDefaultFieldCheck() {
            /* 登录账号不能为空且不能全为空格 */
            var loginName = $("#lgNm").val().trim();
            if(loginName == ""){
                notice.warning("登录账号不能为空！");
                return false;
            }

            /* 密码必须大于等于6位且不能全为空格 */
            var password = $("#passWord").val().trim();
            if(password.length == 0) {
                notice.warning("密码不能为空！");
                return false;
            } else if(password.length < 6) {
                notice.warning("密码长度必须大于等于6位！");
                return false;
            }

            /* 邮箱格式校验 */
            var email = $("#inputPassword3").val().trim();
            if (email != "") {
                if (!Tools.mailCheck(email)) {
                    notice.warning("邮箱格式不正确！");
                    return false;
                }
            }

            /* 手机格式校验 */
            var $addUserPhone = $("#addUserPhone");
            $addUserPhone.val($addUserPhone.val().trim());
            var telPhone = $addUserPhone.val();
            if (telPhone != "") {
                if (!Tools.phoneCheck(telPhone)) {
                    notice.warning('手机格式不正确！');
                    return false;
                }
            }

            var fixedPhone = $("#fixedPhone").val().trim();
            /* 座机格式校验 */
            if (fixedPhone != "") {
                if (!Tools.phoneCheck(fixedPhone)) {
                    notice.warning('座机格式不正确！');
                    return false;
                }
            }

            return true;
        }

        /*
         * @desc 所有自定义字段格式检测
         * @return true:格式正确 false:格式错误
         * */
        function allCustomizeFieldCheck() {
            // 需要正则验证的自定义字段(日期除外)
            var $regFieldList = $('#userFieldUl input[data-reg]').not('[data-type=datetimepicker]');
            // 一个字段
            var $regField = null;
            var value = '';
            var reg = null;
            var label = '';

            // 必填的自定义字段
            var $requireFieldList = $('#userFieldUl').find('[required]');
            var $requireField = null;
            var v = userFieldModule._validator();

            // 错误提示
            var errMsg = '';
            var $errEle = null;

            // 遍历required字段
            for(var i = 0, len = $requireFieldList.length; i < len; i++) {
                $requireField = $($requireFieldList[i]);

                // cri中对复选框的validator与bootstrap冲突，需要特殊判断
                if($requireField.attr('type') === 'checkbox') {
                    // 如果一个都没选中
                    if(!$($requireField).closest('.checkbox').find('input[type=checkbox]').is(':checked')) {
                        $errEle = $requireField;
                        label = $errEle.closest('.form-group').find('label.control-label').text();
                        errMsg = label + ' 是必填项！';
                        break;
                    }
                } else if(!v.validate($requireField)) { // 验证不通过
                    $errEle = $requireField;
                    label = $errEle.closest('.form-group').find('label.control-label').text();
                    errMsg = label + ' 是必填项！';
                    break;
                }
            }

            // 遍历正则字段
            for(var i = 0, len = $regFieldList.length; i < len; i++) {
                // 获取当前字段
                $regField = $($regFieldList[i]);
                // 取值
                value = $regField.val().trim();
                reg = $regField.data('reg');
                // 字段不匹配正则，则提示错误并return
                if(value !== '' && customizeFieldCheck(value, reg) === false) {
                    $errEle = $regField;
                    label = $errEle.data('label');
                    errMsg = label + ' 格式不正确！';
                    break;
                }
            }

            // 如果有错误
            if(errMsg !== '') {
                // 展开自定义字段
                if($('#openOrClose').data('state') === 'open') {
                    openOrClose();
                }

                $errEle.focus();
                notice.warning(errMsg);
                return false;
            }

            return true;
        }

        /*
         * @desc 自定义字段格式检测
         * @value String [字段的值]
         * @reg String [对应的正则表达式]
         * @return true:格式正确 false:格式错误
         * */
        function customizeFieldCheck(value, reg) {
            if(reg != null) {
                // 正则
                var regular = new RegExp(reg);
                return regular.test(value);
            } else {
                return true;
            }
        }

        /**
         * 添加客户
         */
        function addUserSubmit(){
            // 客户角色
            var addType = $("#typeSelect").val();
            // 客户权限
            var $secondType = $("#secondType");
            // 根据客户权限和客户角色设置roleId
            if($secondType.val() == null){
                $("#roleId").val(addType);
            }else{
                $("#roleId").val($secondType.val());
            }

            // 所有默认字段格式检测
            // 所有自定义字段格式检测
            if(!allDefaultFieldCheck() || !allCustomizeFieldCheck()) {
                return false;
            }

            /* 检测登录账号是否重复 */
            var $lgNm = $("#lgNm");
            $lgNm.val($lgNm.val().trim());
            var loginName = $lgNm.val();
            if(checkLoginNames(loginName) === false){
                notice.warning("登录账号已存在！");
                return false;
            } else {
                // 检测手机是否已被使用
                var telPhone = $("#addUserPhone").val();
                if (telPhone !== '' && existPhone(telPhone) === false) {
                    notice.warning("手机号码已存在！");
                    return false;
                } else {
                    // 设置特殊参数
                    var param = $("#formId").formValue();
                    param.userDesc = param.uDesc;
                    param.loginName = param.lgNm;
                    param.userName = param.usrNm;
                    param.userType = '1';

                    //判断归属客服组和归属客服是否选择
                    /* if(!param.serviceGroupName){
                    	notice.warning('归属组不能为空');
                    	return false;
                    }
                    if(!param.serviceName){
                    	notice.warning('归属人不能为空');
                    	return false;
                    }
                    param.serviceGroupId = $("#serviceGroupName").data("serviceGroupId");
                    param.serviceId = $("#serviceName").data("serviceId");
                    if(!param.serviceGroupId || !param.serviceId){
                    	notice.warning('选择归属组或归属人出错');
                    	return false;
                    } */
                    param.serviceGroupId = $("#serviceGroupName").data("serviceGroupId");
                    param.serviceId = $("#serviceName").data("serviceId");

                    // 获取所有checkbox的值
                    var test = {};
                    $("#userFieldUl input[type=checkbox]").each(function () {
                        test[this.name] || (test[this.name] = []);
                        if ($(this).prop('checked')) {
                            test[this.name].push($(this).attr('value'));
                        }
                    });

                    // 获取所有省市区字段
                    var allPCA = getPCASObject('AddUser');

                    // 将参数合并到param中
                    $.extend(param, test, allPCA);

                    // 确认账号登录方式
                    var loginType = Tools.getAccountType(param.loginName);
                    var userInfos = JSON.stringify(param);

                    // 添加客户
                    $.ajax({
                        url: "<%=request.getContextPath()%>/userManageMongo/addUser",
                        type: "post",
                        dataType: "json",
                        data: {
                            entId: "${entId}",
                            userInfos: userInfos,
                            // 是否发送邮件提示(暂时先关闭该功能)
                            send: "false",
                            loginType: loginType
                        },
                        success: function (data) {
                            if (data.success) {
                                notice.success("客户创建成功！");
                                $("#addUserModal").modal('hide');
                                var userId = data.rows;
                                var userName = $("#lgNm").val();

                                // 打开客户详情页
                                var url = "<%=request.getContextPath()%>/userManageMongo/userDetails?userId=" + userId;
                                parent.openTab(url, "user", userName, false);
                            } else {
                                notice.danger("添加失败：" + data.msg);
                            }
                        },
                        error: function (xhr, status) {
                            notice.danger("添加失败：" + status);
                        }
                    });
                }
            }
        }

        /* 校验手机号码是否已存在 */
        function existPhone(telPhone) {
            var result = false;
            $.ajax({
                url: "<%=request.getContextPath()%>/userManageMongo/existsPhone1?telPhone=" + telPhone,
                type: "post",
                dataType: "json",
                async: false,
                data: {
                    userInfos: "{'telPhone':'" + telPhone + "','entId':'${entId}'}"
                },
                success: function (data) {
                    if (data.success) {
                        result = true;
                    } else {
                        result = false;
                    }
                }
            });

            return result;
        }

        /**
         * 客户自定义字段模块
         */
        var userFieldModule = function(){
            var $container = $('#userFieldUl');

            var _validator = function(){
                return $container.validator();
            };

            function setRequire() {
                $container.find('[data-required]').each(function(){
                    var $this = $(this);
                    if($this.attr('data-required') === 'true'){
                        $this.prop('required',true);
                    }
                });
            }

            /*
             * @desc 自定义字段输入框框初始化
             * */
            function inputInit() {
                var $datetimepicker = $container.find('input[data-type=datetimepicker]');

                $container.find('input[type=text][data-name]').not('[data-type=datetimepicker]').input();

                if($datetimepicker.length){
                    $datetimepicker.each(function(){
                        var $input = $(this),
                                dateformat = $(this).attr('data-reg'),
                                label = $input.attr('data-label');
                        var isHMS = /hh|ss/.test(dateformat);

                        $input.timeInput({
                            format:dateformat,
                            HMS:isHMS,
                            label:label
                        });
                    });
                }
            }

            return {
                render:function(){
                    setRequire();
                    inputInit();

                    $('#formId > div.col-sm-6, #userFieldUl > div').not('[data-comp-type=textarea]').css({
                        height: '52px'
                    });

                    $('#userFieldUl > div[data-comp-type=textarea]').css({
                        height: '104px'
                    });

                    // 必填字段label追加红色星号
                    $('#userFieldUl [required]').closest('.form-group').find('.control-label').append('<span style="color: red;">*</span>');
                },
                _validator: _validator
            };
        }();

        /* 自定义字段输入内容展开或收起 */
        function openOrClose(){
            // 当前要执行的状态
            var curState = $('#openOrClose').data('state');

            // 如果当前可以展开
            if(curState === 'open') {
                $('#openOrClose').text('收起');
                $('#openOrClose').data('state', 'close');
            } else {
                $('#openOrClose').text('展开');
                $('#openOrClose').data('state', 'open');
            }

            $("#userFieldUl").fadeToggle();
        }

        /* 校验登录账号是否已存在 */
        function checkLoginNames(name) {
            var result = false;
            $.ajax({
                url: "<%=request.getContextPath()%>/userManageMongo/checkLoginName?loginName=" + name,
                type: "post",
                dataType: "json",
                async: false,
                data: {
                    userInfos: "{'loginName':'" + name + "','entId':'${entId}'}",
                },
                success: function (data) {
                    if (data.success) {
                        result = true;
                    } else {
                        result = false;
                    }
                }
            });

            return result;
        }

        /*
         * @author Lesty
         * @codeDate 2016.8.6
         * @desc 注册事件
         * */
        function regEvent() {
            // 提交表单
            $('#addUserSubmit').on('click', addUserSubmit);

            // 展开或收起自定义字段
            $('#openOrClose').on('click', openOrClose);
        }

        return {
            init: init
        };
    })();
</script>