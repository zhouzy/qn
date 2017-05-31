<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>编辑客户筛选器</title>
    <%@include file="/views/include/pageHeader.jsp"%>
    <link href="<%=request.getContextPath()%>/static/css/selfField.css" type="text/css" rel="stylesheet">
    <%--<link href="<%=request.getContextPath()%>/static/css/ef3763efa8e67025e2caf0ced6deb474.css" type="text/css" rel="stylesheet">--%>
</head>
<body>
<div class="container-fluid">
    <ul class="breadcrumbs">
        <li><a href="<%=request.getContextPath()%>/queryUserCondition/getIndex" target="_self">客户筛选器</a></li>
        <li>
            <c:if test="${edit == '0'}">
                添加筛选器
            </c:if>
            <c:if test="${edit == '1'}">
                编辑筛选器:[${condition.title}]
            </c:if>
        </li>
    </ul>

    <div class="panel">
        <div class="form-horizontal">
            <div class="row" style="border-bottom: 1px solid #bdbdbd;">
                <div class="col-sm-4">
                    <div class="form-group">
                        <label for="filterName" class="control-label col-sm-4">筛选器名称<span style="color: red;position: absolute;">*</span>：</label>
                        <div class="col-sm-8">
                            <input id="filterName" type="text" name="filterName" class="form-control" value="${condition.title}" required>
                        </div>
                    </div>
                </div>
            </div>
            <div class="row" id="conditionList">
                <div id="defaultUserFieldUl">
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label for="telPhone" class="control-label col-sm-4">
                                <span class="row">电话：</span>
                            </label>
                            <div class="col-sm-8">
                                <input id="telPhone" type="text" name="telPhone" class="form-control">
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label for="email" class="control-label col-sm-4">
                                <span class="row">邮箱：</span>
                            </label>
                            <div class="col-sm-8">
                                <input id="email" type="email" name="email" class="form-control">
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label for="loginName" class="control-label col-sm-4">
                                <span class="row">登陆账号：</span>
                            </label>
                            <div class="col-sm-8">
                                <input id="loginName" type="text" name="loginName" class="form-control">
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label for="serviceGroupId" class="control-label col-sm-4">
                                <span class="row">归属组：</span>
                            </label>
                            <div class="col-sm-8">
                                <select id="serviceGroupId" name="serviceGroupId" class="form-control">
                                    <option value="">-- 选择归属组 --</option>
                                    <option value="_blank_">- 值为空 -</option>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label for="serviceId" class="control-label col-sm-4">
                                <span class="row">归属人：</span>
                            </label>
                            <div class="col-sm-8">
                                <select id="serviceId" name="serviceId" class="form-control">
                                    <option value="">-- 选择归属人 --</option>
                                    <option value="_blank_">- 值为空 -</option>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label for="creatorId" class="control-label col-sm-4">
                                <span class="row">创建人：</span>
                            </label>
                            <div class="col-sm-8">
                                <select id="creatorId" name="creatorId" class="form-control">
                                    <option value="">-- 选择创建人 --</option>
                                    <option value="_blank_">- 值为空 -</option>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label for="userStatus" class="control-label col-sm-4">
                                <span class="row">客户状态：</span>
                            </label>
                            <div class="col-sm-8">
                                <select class="form-control" id="userStatus" name="userStatus">
                                    <option value="-1" selected>所有状态</option>
                                    <option value="1">正常</option>
                                    <option value="3">未审核</option>
                                    <option value="4">停用</option>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label for="userName" class="control-label col-sm-4">
                                <span class="row">用户姓名：</span>
                            </label>
                            <div class="col-sm-8">
                                <input id="userName" type="text" name="userName" class="form-control">
                            </div>
                        </div>
                    </div>
                    <div style="width: 100%;float:left;"></div>
                    <div class="col-sm-6">
                        <input id="customCreateFrom" type="text" name="createTime1" data-type="date" data-label="客户创建时间：">
                    </div>
                    <div class="col-sm-6">
                        <input id="customCreateTo" type="text" name="createTime2" data-type="date" data-label="至：">
                    </div>
                    <div class="col-sm-6">
                        <input id="latestCntTimeFrom" type="text" name="latestCntTimeFrom" data-type="date" data-label="最近联络时间：">
                    </div>
                    <div class="col-sm-6">
                        <input id="latestCntTimeTo" type="text" name="latestCntTimeTo" data-type="date" data-label="至：">
                    </div>
                    <div class="col-sm-6">
                        <input id="updateTimeFrom" type="text" name="updateTimeFrom" data-type="date" data-label="最近更新时间：">
                    </div>
                    <div class="col-sm-6">
                        <input id="updateTimeTo" type="text" name="updateTimeTo" data-type="date" data-label="至：">
                    </div>
                </div>
                <div id="customUserFieldUl" style="display: none"></div>
            </div>
            <div class="row">
                <div class="col-sm-offset-6 col-sm-6" id="allBtns" style="text-align: right">
                    <a href="javascript:void(0)" class="btn"
                       id="cancelBtn" style="color: #777"> 取 消 </a>
                    <a href="javascript:void(0)" class="btn btn-danger"
                       id="cleanBtn"> 清 空 </a>
                    <a href="javascript:void(0)" class="btn btn-primary"
                       id="saveBtn"> 保 存 </a>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- 1:字符串 -->
<script id="custom-field-comp-1" type="text/x-handlebars-template">
    <div class="col-sm-4">
        <div class="form-group">
            <label class="control-label col-sm-4">
                <span class="row">{{name}}：</span>
            </label>
            <div class="col-sm-8">
                <input id="{{key}}" type="text" name="{{key}}" class="form-control" data-label="{{name}}" value="{{ownValue}}">
            </div>
        </div>
    </div>
</script>
<!-- 2:文本框 -->
<script id="custom-field-comp-2" type="text/x-handlebars-template">
    <div class="col-sm-4" data-comp-type="textarea">
        <div class="form-group">
            <label class="control-label col-sm-4">
                <span class="row">{{name}}：</span>
            </label>
            <div class="col-sm-8">
                <textarea class="form-control" name="{{key}}" id="{{key}}" rows="4" data-label="{{name}}">{{ownValue}}</textarea>
            </div>
        </div>
    </div>
</script>
<!-- 3:下拉框 -->
<script id="custom-field-comp-3" type="text/x-handlebars-template">
    <div class="col-sm-4">
        <div class="form-group">
            <label class="control-label col-sm-4">
                <span class="row">{{name}}：</span>
            </label>
            <div class="col-sm-8">
                <select class="form-control" id="{{key}}" name="{{key}}" data-label="{{name}}">
                    <option value="" selected>-</option>
                    <option value="_blank_">-值为空-</option>
                    {{#each candidateValue}}
                    <option value="{{this}}">{{this}}</option>
                    {{/each}}
                </select>
            </div>
        </div>
    </div>
</script>
<!-- 4:复选框 -->
<script id="custom-field-comp-4" type="text/x-handlebars-template">
    <%--    {{#if covered}}
        <div class="col-sm-12">
            <div class="form-group">
                <label class="control-label col-sm-2" style="padding-right: 20px;">{{name}}</label>
                <div class="col-sm-10 checkbox" style="padding-left: 10px;">
                    {{#each candidateValue}}
                    <label>
                        <input type="checkbox" value="{{this}}" name="{{../key}}" data-label="{{../name}}">{{this}}
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
                        <input type="checkbox" value="{{this}}" name="{{../key}}" data-label="{{../name}}">{{this}}
                    </label>
                    {{/each}}
                </div>
            </div>
        </div>
        {{/if}}--%>
</script>
<!-- 5:未定 -->
<script id="custom-field-comp-5" type="text/x-handlebars-template">

</script>
<!-- 6:数字 -->
<script id="custom-field-comp-6" type="text/x-handlebars-template">
    <div class="col-sm-4">
        <div class="form-group">
            <label class="control-label col-sm-4">
                <span class="row">{{name}}：</span>
            </label>
            <div class="col-sm-8">
                <input id="{{key}}" type="text" name="{{key}}" class="form-control" data-reg="^-?\d+$" data-label="{{name}}" value="{{ownValue}}">
            </div>
        </div>
    </div>
</script>
<!-- 7:小数 -->
<script id="custom-field-comp-7" type="text/x-handlebars-template">
    <div class="col-sm-4">
        <div class="form-group">
            <label class="control-label col-sm-4">
                <span class="row">{{name}}：</span>
            </label>
            <div class="col-sm-8">
                <input id="{{key}}" type="text" name="{{key}}" class="form-control" data-reg="^-?\d+\.\d+$" data-label="{{name}}" value="{{ownValue}}">
            </div>
        </div>
    </div>
</script>
<!-- 8:正则表达式 -->
<script id="custom-field-comp-8" type="text/x-handlebars-template">
    <div class="col-sm-4">
        <div class="form-group">
            <label class="control-label col-sm-4">
                <span class="row">{{name}}：</span>
            </label>
            <div class="col-sm-8">
                <input id="{{key}}" type="text" name="{{key}}" class="form-control" data-reg="{{reg}}" data-label="{{name}}" value="{{ownValue}}">
            </div>
        </div>
    </div>
</script>
<!-- 9:电话号码 -->
<script id="custom-field-comp-9" type="text/x-handlebars-template">
    <div class="col-sm-4">
        <div class="form-group">
            <label class="control-label col-sm-4">
                <span class="row">{{name}}：</span>
            </label>
            <div class="col-sm-8">
                <input id="{{key}}" type="text" name="{{key}}" class="form-control" data-reg="{{reg}}" data-label="{{name}}" value="{{ownValue}}">
            </div>
        </div>
    </div>
</script>
<!-- 10:时间输入框 -->
<script id="custom-field-comp-10" type="text/x-handlebars-template">
    <%--    <div class="col-sm-6">
            <input id="{{key}}" type="text" name="{{key}}" data-label="{{name}}" data-type="datetimepicker" data-reg="{{reg}}" data-field="{{name}}" data-name="{{key}}" value="{{ownValue}}">
        </div>--%>
</script>
<!-- 11:省市区 -->
<script id="custom-field-comp-11" type="text/x-handlebars-template">
    <div class="col-sm-10">
        <div class="form-group">
            <label class="control-label col-sm-2" style="padding-right: 20px;">{{name}}：</label>

            <div class="col-sm-10">
                <div class="row">
                    <div class="col-sm-4">
                        <span><select class="form-control" data-label="{{name}}" data-field-type="pca" name="province_{{key}}" id="Custom_province{{key}}" style="box-shadow: none;"></select></span>
                    </div>
                    <div class="col-sm-4">
                        <span><select class="form-control" data-field-type="pca" name="city_{{key}}" id="Custom_city{{key}}" style="box-shadow: none;"></select></span>
                    </div>
                    <div class="col-sm-4">
                        <span><select class="form-control" data-field-type="pca" name="area_{{key}}" id="Custom_area{{key}}" style="box-shadow: none;"></select></span>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <input type="hidden" name='Custom{{key}}' id="{{key}}">
</script>

<script src="<%=request.getContextPath()%>/script/lib/PCASClass.js"></script>

<script type="text/javascript">
// 筛选器对象
var filterObj = ${condition};
// 当前筛选器的条件取值(全局)
var CONDITION_G = {};
// 归属客服组下相应的客服名称
var SERVICE_NAME_G = {};
// 如果是编辑页面
if(isEdit()) {
    CONDITION_G = JSON.parse(filterObj.query);
}

/**
 * @author Lesty
 * @codeDate 2016.9.29
 */
$(function () {
    // 默认字段初始化(赋值)
    defaultFieldInit();

    // 获取自定义字段列表
    getCustomizeFieldListData();

    // 注册事件
    regEvent();
});

function isEdit() {
    return '${edit}' === '1';
}

/**
 * @desc 默认字段初始化
 */
function defaultFieldInit() {
    // 默认字段
    var $fields = $('#defaultUserFieldUl');

    var $allDates = $("#customCreateFrom, #customCreateTo, #latestCntTimeFrom, #latestCntTimeTo, #updateTimeFrom, #updateTimeTo");

    // 初始化初始化归属客服组
    serviceGroupInit();
    // 初始化创建人列表
    creatorInit();

    if(isEdit()) { // 如果是编辑页面
        // 控件赋值
        $fields.find('input, select, textarea').not('#serviceGroupId, #serviceId, #creatorId').each(function() {
            var value = CONDITION_G[this.name];

            if($(this).attr('data-type') === "date") { // 如果是时间控件
                value = new Date(parseInt(value, 10));
                // 判断时间取值并赋值
                $(this).timeInput({
                    format: "yyyy-MM-dd hh:mm:ss",
                    HMS: true,
                    value: (isNaN(value) ? '' : value)
                });
            } else {
                $(this).val(value);
            }
        });
    } else { // 如果是添加页面
        $allDates.timeInput({
            format:"yyyy-MM-dd hh:mm:ss",
            HMS:true,
            value: ''
        });
    }

    // 设置控件偏移量
    $allDates.closest('div.col-sm-6').css({
        'margin-left': '-18px'
    });
}

/**
 * @desc 初始化归属客服组
 */
function serviceGroupInit() {
    // 参数rows为-1时，获取全部，而不分页
    $.post('<%=request.getContextPath()%>/groupMongo/getAgentGroups', {
        rows: -1
    }, function(data) {
        var rows = data.rows;
        var group = null;
        var optionsHtml = '<option value="" selected>-- 选择归属组 --</option><option value="_blank_">- 值为空 -</option>';
        for(var i = 0, len = rows.length; i < len; i++) {
            group = rows[i];
            // 增加options选项
            optionsHtml += '<option value="' + group.groupId + '">' + group.groupName +'</option>';
            // 缓存数据到全局客服组-客服对象
            SERVICE_NAME_G[group.groupId] = group.members;
        }

        $('#serviceGroupId').html(optionsHtml).val(CONDITION_G.serviceGroupId).change();
    });
}

/**
 * @desc 创建人初始化
 */
function creatorInit() {
    $.post('<%=request.getContextPath()%>/userManageMongo/findAgentsForCondition', function(data) {
        var rows = data.rows;
        var creator = null;
        var optionsHtml = '<option value="">-- 选择创建人 --</option><option value="_blank_">- 值为空 -</option>';
        for(var i = 0, len = rows.length; i < len; i++) {
            creator = rows[i];
            // 增加options选项
            optionsHtml += '<option value="' + creator.userId + '">' + creator.userName +'</option>';
        }

        $('#creatorId').html(optionsHtml).val(CONDITION_G.creatorId);
    });
}

/*
 * @desc 省市区字段初始化
 * @prefix String [id前缀，避免冲突]
 * @PCAKeys Array [包含所有省市区字段key的数组]
 * */
function pcasInit(prefix, PCAKeys) {
    //省市区字段初始化
    var pcaKey = '';
    var pcaArr = [];

    for(var i = 0, len = PCAKeys.length; i < len; i++) {
        pcaKey = PCAKeys[i];

        pcaArr[0] = CONDITION_G['province_' + pcaKey];
        pcaArr[1] = CONDITION_G['city_' + pcaKey];
        pcaArr[2] = CONDITION_G['area_' + pcaKey];

        new PCAS("#" + prefix +"_province" + pcaKey,"#" + prefix + "_city" + pcaKey,"#" + prefix + "_area" + pcaKey, pcaArr[0], pcaArr[1], pcaArr[2]);
    }
}

/*
 * @desc 获取所有省市区字段值
 * @prefix String [id前缀，为了使每个页面的id不冲突]
 * @return Object [包含key,value的省市区对象]
 * */
function getPCASObject(prefix){
    var $fields = $("#customUserFieldUl").find('select[data-field-type=pca]');
    var PCAObject = {};
    var fieldValue = '';
    var province  = '';
    var city = '';
    var area = '';


    $fields.each(function () {
        PCAObject[this.name.split('_')[1]] = 1;
    });

    for(var fieldKey in PCAObject) {
        province = $('#' + prefix + '_province'+fieldKey).val();
        city = $('#' + prefix + '_city'+fieldKey).val();
        area = $('#' + prefix + '_area'+fieldKey).val();
        // 获取合并值
        if(province !== '') {
            fieldValue = (province + ',' + city + ',' + area).replace(/,+$/g, "");
        } else {
            fieldValue = '';
        }

        PCAObject[fieldKey] = fieldValue;
    }

    return PCAObject;
}

/**
 * @desc [注册事件]
 */
function regEvent() {
    // 取消保存筛选器，并返回上一级
    $('#cancelBtn').on('click', function() {
        // 这里使用js的click事件，因为jquery触发器不会触发元素默认事件(而是触发你绑定的事件)
        // @latest Lesty 2016.9.21
        $('.breadcrumbs').find('li:eq(0) > a')[0].click();
    });

    $('#cleanBtn').on('click', function() {
        var $conditonList = $("#conditionList");
        // 清空所有控件内容
        $conditonList.find('input, textarea').val('');
        $conditonList.find('select').prop('selectedIndex', 0);
        $('#serviceGroupId').change();
    });

    // 保存筛选器
    $('#saveBtn').on('click', function() {
        // 阻止a标签默认跳转
        event.preventDefault();
        var title = $('#filterName').val().trim();
        var sendData = {
            title: title
        };

        // 所有默认字段格式检测
        // 所有自定义字段格式检测
        if(!allDefaultFieldCheck() || !allCustomizeFieldCheck()) {
            return false;
        }

        // 设置特殊参数
        var param = $("#conditionList").formValue();
        param.createTime1 = $("#customCreateFrom").val() === '' ? '' : +new Date($("#customCreateFrom").val())+'';
        param.createTime2 = $("#customCreateTo").val() === '' ? '' : +new Date($("#customCreateTo").val())+'';
        param.latestCntTimeFrom = $("#latestCntTimeFrom").val() === '' ? '' : +new Date($("#latestCntTimeFrom").val())+'';
        param.latestCntTimeTo = $("#latestCntTimeTo").val() === '' ? '' : +new Date($("#latestCntTimeTo").val())+'';
        param.updateTimeFrom = $("#updateTimeFrom").val() === '' ? '' : +new Date($("#updateTimeFrom").val())+'';
        param.updateTimeTo = $("#updateTimeTo").val() === '' ? '' : +new Date($("#updateTimeTo").val())+'';

        // 去除查询条件的首位空格
        for(var p in param) {
            if(param.hasOwnProperty(p) && typeof param[p] === 'string') {
                param[p] = param[p].trim();
            }
        }
        // 增加属性
        sendData.queryJson = JSON.stringify(param);

        // 验证通过，保存按钮不可点击(待请求完成后可点击)
        var $btns = $('#allBtns').children('a');
        $btns.addClass('disabled');

        var url = '<%=request.getContextPath()%>/queryUserCondition/addCondition';
        // 如果是编辑页面，增加key参数，修改url路径
        if(isEdit()) {
            sendData.conditionId = filterObj.conditionId;
            url = '<%=request.getContextPath()%>/queryUserCondition/editCondition';
        }

        $.post(url, sendData, function(data) {
            if(data.success) {
                notice.success("客户筛选器 [" + title + "] 保存成功！");
                // 跳转页面
                $('.breadcrumbs').find('li:eq(0) > a')[0].click();
            } else {
                notice.danger(data.msg);
                // 按钮可点击
                $btns.removeClass('disabled');
            }
        });
    });

    // 改变归属客服组
    $('#serviceGroupId').on('change', function() {
        var $serviceId = $('#serviceId');
        // 获取相应客服组下的客服列表
        var data = SERVICE_NAME_G[this.value] || [];
        var member = null;
        var optionsHtml = '<option value="" selected>-- 选择归属人 --</option><option value="_blank_">- 值为空 -</option>';
        for(var i = 0, len = data.length; i < len; i++) {
            member = data[i];
            // 增加options选项
            optionsHtml += '<option value="' + member.userId + '">' + member.userName +'</option>';
        }

        $serviceId.html(optionsHtml).val(CONDITION_G.serviceId);
        CONDITION_G.serviceId = null;
        if($serviceId.val() == null) {
            $serviceId.prop('selectedIndex', 0);
        }
    });
}

/*
 * @author Lesty
 * @codeDate 2016.11.21
 * @desc [获取自定义字段列表数据]
 * */
var getCustomizeFieldListData = (function(){
    return function (){
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

/*
 * @author Lesty
 * @codeDate 2016.11.21
 * @desc [创建/刷新自定义字段列表]
 * @tableData Array [自定义字段列表数据]
 * */
var createCustomizeFieldList = (function(){
    var $fieldList = $('#customUserFieldUl');

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
            $fieldList.empty();
            return;
        }

        // 遍历数据生成自定义字段列表
        for(var i = 0, len = list.length; i < len; i++) {
            field = list[i];
            // 取到当前自定义字段的值
            field.ownValue = CONDITION_G[field.key];
            if(field.default === true) {
                continue;
            }
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
        pcasInit('Custom', PCAKeys);

        $fieldList.show();
    }
})();

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
    var fieldTemp = Handlebars.compile($('#custom-field-comp-' + data.componentType).html());
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
 * @desc 所有默认字段格式检测
 * @return true:格式正确 false:格式错误
 * */
function allDefaultFieldCheck() {
    /* 邮箱格式校验 */
    var email = $("#email").val().trim();
    if (email != "") {
        if (!Tools.mailCheck(email)) {
            notice.warning("邮箱格式不正确！");
            return false;
        }
    }

    /* 手机格式校验 */
    var telPhone = $("#telPhone").val().trim();
    if (telPhone != "") {
        if (!Tools.phoneCheck(telPhone)) {
            notice.warning('电话格式不正确！');
            return false;
        }
    }

    var customCreateFromStr = $("#customCreateFrom").val();
    var customCreateToStr = $("#customCreateTo").val();
    var latestCntTimeFromStr = $("#latestCntTimeFrom").val();
    var latestCntTimeToStr = $("#latestCntTimeTo").val();
    var updateTimeFromStr = $("#updateTimeFrom").val();
    var updateTimeToStr = $("#updateTimeTo").val();


    try {
        customCreateFromStr = new Date(customCreateFromStr).getTime();
        customCreateToStr = new Date(customCreateToStr).getTime();
        latestCntTimeFromStr = new Date(latestCntTimeFromStr).getTime();
        latestCntTimeToStr = new Date(latestCntTimeToStr).getTime();
        updateTimeFromStr = new Date(updateTimeFromStr).getTime();
        updateTimeToStr = new Date(updateTimeToStr).getTime();
    } catch (e) {
        notice.warning("时间格式不正确");
        return false;
    }
    if (customCreateFromStr > customCreateToStr) {
        notice.warning("客户创建时间:起始与截止时间范围不正确-。-");
        return false;
    }
    if (latestCntTimeFromStr > latestCntTimeToStr) {
        notice.warning("最近联络时间:起始与截止时间范围不正确-。-");
        return false;
    }
    if (updateTimeFromStr > updateTimeToStr) {
        notice.warning("最近更新时间:起始与截止时间范围不正确-。-");
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

/*
 * @desc 所有自定义字段格式检测
 * @return true:格式正确 false:格式错误
 * */
function allCustomizeFieldCheck() {
    // 需要正则验证的自定义字段(日期除外)
    var $regFieldList = $('#customUserFieldUl input[data-reg]').not('[data-type=datetimepicker]');
    // 一个字段
    var $regField = null;
    var value = '';
    var reg = null;
    var label = '';

    // 遍历正则字段
    for(var i = 0, len = $regFieldList.length; i < len; i++) {
        // 获取当前字段
        $regField = $($regFieldList[i]);
        // 取值
        value = $regField.val().trim();
        reg = $regField.data('reg');
        // 字段不匹配正则，则提示错误并return
        if(value !== '' && customizeFieldCheck(value, reg) === false) {
            label = $regField.data('label');
            notice.warning(label + ' 格式不正确！');
            return false;
        }
    }

    return true;
}

/**
 * 用户自定义字段模块
 */
var userFieldModule = function(){
    var $container = $('#customUserFieldUl');

    var _validator = function(){
        return $container.validator();
    };

    // 初始化下拉框
    function selectInit() {
        $container.find('select').val(function () {
            return CONDITION_G[this.id];
        });
    }

    return {
        render:function(){
            selectInit();

            $container.children('div').not('[data-comp-type=textarea]').css({
                height: '48px'
            });

            $container.children('div[data-comp-type=textarea]').css({
                height: '96px'
            });
        },
        _validator: _validator
    };
}();
</script>
</body>
</html>
