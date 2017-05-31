<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>编辑工单筛选器</title>
    <%@include file="/views/include/pageHeader.jsp"%>
    <%--<link href="<%=request.getContextPath()%>/static/css/userField.css" type="text/css" rel="stylesheet">--%>
    <link href="<%=request.getContextPath()%>/static/css/selfField.css" type="text/css" rel="stylesheet">
</head>
<body>
<div class="container-fluid">
    <ul class="breadcrumbs">
        <li><a href="<%=request.getContextPath()%>/queryWorkCondition/getIndex" target="_self">工单筛选器</a></li>
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
                <div id="defaultWorkFieldUl">
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label for="tempId" class="control-label col-sm-4">
                                <span class="row">工单模板：</span>
                            </label>
                            <div class="col-sm-8">
                                <select class="form-control" id="tempId" name="tempId"></select>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label for="telPhone" class="control-label col-sm-4">
                                <span class="row">客户手机：</span>
                            </label>
                            <div class="col-sm-8">
                                <input id="telPhone" type="text" name="telPhone" class="form-control">
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
                            <label for="workId" class="control-label col-sm-4">
                                <span class="row">工单编号：</span>
                            </label>
                            <div class="col-sm-8">
                                <input id="workId" type="text" name="workId" class="form-control">
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label for="workPhone" class="control-label col-sm-4">
                                <span class="row">工单电话：</span>
                            </label>
                            <div class="col-sm-8">
                                <input id="workPhone" type="text" name="workPhone" class="form-control">
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label for="status" class="control-label col-sm-4">
                                <span class="row">工单状态：</span>
                            </label>
                            <div class="col-sm-8">
                                <select class="form-control" id="status" name="status" multiple style="height: 56px;">
                                    <option value="" selected>所有状态</option>
                                    <option value="0">尚未受理</option>
                                    <option value="1">受理中</option>
                                    <option value="2">等待回复</option>
                                    <option value="3">已解决</option>
                                    <option value="4">已关闭</option>
                                    <option value="5">待回访</option>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label for="Work_serviceGroupId" class="control-label col-sm-4">
                                <span class="row">受理组：</span>
                            </label>
                            <div class="col-sm-8">
                                <select id="Work_serviceGroupId" name="serviceGroupId" class="form-control">
                                    <option value="">-- 选择受理组 --</option>
                                    <option value="_blank_">-- 值为空 --</option>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label for="Work_customServiceId" class="control-label col-sm-4">
                                <span class="row">受理人：</span>
                            </label>
                            <div class="col-sm-8">
                                <select id="Work_customServiceId" name="customServiceId" class="form-control">
                                    <option value="">-- 选择受理人 --</option>
                                    <option value="_blank_">-- 值为空 --</option>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label for="Work_creatorId" class="control-label col-sm-4">
                                <span class="row">创建人：</span>
                            </label>
                            <div class="col-sm-8">
                                <select id="Work_creatorId" name="creatorId" class="form-control">
                                    <option value="">-- 选择创建人 --</option>
                                    <option value="_blank_">-- 值为空 --</option>
                                </select>
                            </div>
                        </div>
                    </div>

                    <div class="col-sm-4">
                        <div class="form-group">
                            <label for="priority" class="control-label col-sm-4">
                                <span class="row">优先级：</span>
                            </label>
                            <div class="col-sm-8">
                                <select class="form-control" id="priority" name="priority">
                                    <option value="-1">所有</option>
                                    <option value="1">低</option>
                                    <option value="2">中</option>
                                    <option value="3">高</option>
                                    <option value="4">紧急</option>
                                </select>
                            </div>
                        </div>
                    </div>
                    <!-- 分隔符 -->
                    <span class="col-sm-12" style="height: 0;"></span>
                    <div class="col-sm-6">
                        <input id="orderCreateFrom" type="text" name="orderCreateFrom" data-type="date" data-label="工单创建时间：">
                    </div>
                    <div class="col-sm-6">
                        <input id="orderCreateTo" type="text" name="orderCreateTo" data-type="date" data-label="至：">
                    </div>
                    <div class="col-sm-6">
                        <input id="orderOverFrom" type="text" name="orderOverFrom" data-type="date" data-label="工单结束时间：">
                    </div>
                    <div class="col-sm-6">
                        <input id="orderOverTo" type="text" name="orderOverTo" data-type="date" data-label="至：">
                    </div>
                </div>
                <div id="customWorkFieldUl" style="display: none"></div>
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
                    <option value="" selected>-- 全部 --</option>
                    <option value="_blank_">-- 值为空 --</option>
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
                        <span><select class="form-control" data-label="{{name}}" data-field-type="pca" name="province_{{key}}" id="Work_province{{key}}" style="box-shadow: none;"></select></span>
                    </div>
                    <div class="col-sm-4">
                        <span><select class="form-control" data-field-type="pca" name="city_{{key}}" id="Work_city{{key}}" style="box-shadow: none;"></select></span>
                    </div>
                    <div class="col-sm-4">
                        <span><select class="form-control" data-field-type="pca" name="area_{{key}}" id="Work_area{{key}}" style="box-shadow: none;"></select></span>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <input type="hidden" name='Work{{key}}' id="{{key}}">
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
    var $fields = $('#defaultWorkFieldUl');

    var $allDates = $("#orderCreateFrom, #orderCreateTo, #orderOverFrom, #orderOverTo");

    // 设置工单模板下拉选项
    workTplInit();

    // 初始化受理客服组
    serviceGroupInit();

    // 创建人初始化
    creatorInit();

    if(isEdit()) { // 如果是编辑页面
        // 控件赋值
        $fields.find('input, select, textarea').not('#tempId').each(function() {
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

    // 设置控件高度
    $fields.children('div').css({
        height: '55px'
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

        $('#Work_serviceGroupId').html(optionsHtml).val(CONDITION_G.serviceGroupId).change();
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

        $('#Work_creatorId').html(optionsHtml).val(CONDITION_G.creatorId);
    });
}

/**
 * @desc 设置工单模板下拉选项
 */
function workTplInit() {
    $.ajax({
        url: '<%=request.getContextPath()%>/workorder/queryTemplate?sessionKey=' + $.cookie("sessionKey"),
        type: "post",
        dataType: "jsonp",
        data: "",
        success: function (data) {
            if (data.success) {
                var sub = data.rows,
                        optionsHtml = '<option value="-1" selected>所有模板</option>',
                        $tempId = $("#tempId"),
                        tempId = CONDITION_G.tempId != null ? CONDITION_G.tempId : '-1';

                // 添加选项
                for (var i = 0, len = sub.length; i < len; i++) {
                    optionsHtml += '<option value="' + sub[i].tempId + '">' + sub[i].tempName + '</option>';
                }

                // 赋值并手动触发change事件
                $tempId.html(optionsHtml).val(tempId).change();
            }
        }
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

/**
 * @desc 多选下拉框对象
 * @author Lesty
 */
function MultipleSelect(id, valueArr) {
    this.id = id;
    this.$ele = $('#' + id);

    if(valueArr) {
        this.set(valueArr);
    }
}

MultipleSelect.prototype.set = function(valueArr) {
    valueArr = Array.isArray(valueArr) ? valueArr : [];

    this.$ele.val(valueArr);
};

MultipleSelect.prototype.get = function() {
    var valueArr = [];
    this.$ele.children('option:selected').each(function() {
        valueArr.push(this.value);
    });

    return valueArr;
};

/**
 * @desc [注册事件]
 */
function regEvent() {
    // 模板改变时，获取相应自定义字段
    $('#tempId').on('change', function() {
        var tempId = this.value;
        if(tempId == null) {
            notice.danger('模板id获取失败-。-');
            return;
        }
        if(tempId !== '-1') {
            getCustomizeFieldListData({tempId: tempId});
        } else {
            $('#customWorkFieldUl').empty();
        }
    });

    // 取消保存筛选器，并返回上一级
    $('#cancelBtn').on('click', function() {
        // 这里使用js的click事件，因为jquery触发器不会触发元素默认事件(而是触发你绑定的事件)
        // @latest Lesty 2016.9.21
        $('.breadcrumbs').find('li:eq(0) > a')[0].click();
    });

    $('#cleanBtn').on('click', function() {
        var $conditionList = $("#conditionList");
        // 清空所有控件内容
        $conditionList.find('input, textarea').val('');
        $conditionList.find('select').prop('selectedIndex', 0);
        // 触发工单模板change事件
        $('#tempId').change();
        $('#Work_serviceGroupId').change();
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
        param.orderCreateFrom = $("#orderCreateFrom").val() === '' ? '' : +new Date($("#orderCreateFrom").val())+'';
        param.orderCreateTo = $("#orderCreateTo").val() === '' ? '' : +new Date($("#orderCreateTo").val())+'';
        param.orderOverFrom = $("#orderOverFrom").val() === '' ? '' : +new Date($("#orderOverFrom").val())+'';
        param.orderOverTo = $("#orderOverTo").val() === '' ? '' : +new Date($("#orderOverTo").val())+'';

        // 生成多选下拉框对象
        var statusSelect = new MultipleSelect('status');
        // 拼接特定形式
        param.status = {
            '$in': statusSelect.get()
        };

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

        var url = '<%=request.getContextPath()%>/queryWorkCondition/addCondition';
        // 如果是编辑页面，增加key参数，修改url路径
        if(isEdit()) {
            sendData.conditionId = filterObj.conditionId;
            url = '<%=request.getContextPath()%>/queryWorkCondition/editCondition';
        }

        $.post(url, sendData, function(data) {
            if(data.success) {
                notice.success("工单筛选器 [" + title + "] 保存成功！");
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
    $('#Work_serviceGroupId').on('change', function() {
        var $serviceId = $('#Work_customServiceId');
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
    return function(param){
        $.ajax({
            url: "<%=request.getContextPath()%>/workorder/queryTemplateField?sessionKey="+ $.cookie("sessionKey"),
            type: "post",
            dataType: 'jsonp',
            data: param,
            success: function(data) {
                if(!(data.success)) {
                    notice.danger(data.msg);
                    return;
                }

                if(data.rows != null) {
                    createCustomizeFieldList(data.rows.field);
                }
            }
        });
    }
})();

/*
 * @author Lesty
 * @codeDate 2016.8.6
 * @desc [创建/刷新自定义字段列表]
 * @tableData Array [自定义字段列表数据]
 * */
var createCustomizeFieldList = (function(){
    var $fieldList = $('#customWorkFieldUl');

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
        pcasInit('Work', PCAKeys);

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
    /* 手机格式校验 */
    var telPhone = $("#telPhone").val().trim();
    if (telPhone != "") {
        if (!Tools.phoneCheck(telPhone)) {
            notice.warning('客户手机格式不正确！');
            return false;
        }
    }

    /* 工单电话校验 */
    var workPhone = $("#workPhone").val().trim();
    if (workPhone != "") {
        if (!Tools.phoneCheck(workPhone)) {
            notice.warning('工单电话格式不正确！');
            return false;
        }
    }

    var orderCreateFromStr = $("#orderCreateFrom").val();
    var orderCreateToStr = $("#orderCreateTo").val();

    var orderOverFromStr = $("#orderOverFrom").val();
    var orderOverToStr = $("#orderOverTo").val();

    try {
        orderCreateFromStr = new Date(orderCreateFromStr).getTime();
        orderCreateToStr = new Date(orderCreateToStr).getTime();

        orderOverFromStr = new Date(orderOverFromStr).getTime();
        orderOverToStr = new Date(orderOverToStr).getTime();
    } catch (e) {
        notice.warning("时间格式不正确-。-");
        return false;
    }
    if (orderCreateFromStr > orderCreateToStr) {
        notice.warning("工单创建时间:起始与截止时间范围不正确-。-");
        return false;
    }

    if (orderOverFromStr > orderOverToStr) {
        notice.warning("工单结束时间:起始与截止时间范围不正确-。-");
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
    var $regFieldList = $('#customWorkFieldUl input[data-reg]').not('[data-type=datetimepicker]');
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
    var $container = $('#customWorkFieldUl');

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
                height: '55px'
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
