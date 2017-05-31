<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>用户详情</title>
    <%@include file="/views/include/pageHeader.jsp" %>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/script/lib/summernote/summernote.css">
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/static/css/innerFrame.css">
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/static/css/customDetail.css">
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/static/css/e3293c2acd190ccbe6c6431b13b34494.css">
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/script/lib/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.css">
    <script src="<%=request.getContextPath()%>/script/lib/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
    <script src="<%=request.getContextPath()%>/script/lib/bootstrap-datetimepicker-master/js/locales/bootstrap-datetimepicker.zh-CN.js"></script>
    <script src="<%=request.getContextPath()%>/script/lib/summernote/summernote.js"></script>
    <script src="<%=request.getContextPath()%>/script/lib/summernote/summernote-zh-CN.js"></script>
    <script src="<%=request.getContextPath()%>/script/lib/PCASClass.js"></script>
</head>
<body>
<div id="right-part">
    <div class="right-content">
        <div class="container-fluid">
            <div class="row" id="userInfoId">
                <div class="col-lg-12 col-md-12">
                    <div class="panel" id="top">
                        <div class="panel-heading">用户资料
                            <div class="btn-group pull-right" style="margin:-7px 0 0 0;">
                                <button type="button" class="btn btn-primary" id="toggleEditUserBtn" style="display: none;"><i class="fa fa-edit"></i>编辑</button>
                                <div class="btn-group">
                                    <button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
                                        更多
                                        <span class="caret"></span>
                                    </button>
                                    <ul class="dropdown-menu" role="menu">
                                        <li>
                                            <c:if test="${isTanPing == '1'}">
                                                <a id="createWf" href="javascript:void(0);" onclick="newwork('isTanPing');">创建工单</a>
                                            </c:if>
                                            <c:if test="${isTanPing == '0'}">
                                                <a id="createWf" href="javascript:void(0);" onclick="newwork();">创建工单</a>
                                            </c:if>
                                        </li>
                                        <li>
                                            <a id="pwdSet" data-toggle="modal" onclick="goSetPwd();" data-target="#setPwdModal">密码设置</a>
                                        </li>
                                        <li>
                                            <a id="merge" data-toggle="modal" onclick="goMerge();" data-target="#userMerge">合并用户</a>
                                        </li>
                                        <li>
                                            <a data-toggle="modal" onclick="goMake();" data-target="#bckTrckingModal">补录沟通小结</a>
                                        </li>
                                        <li>
                                            <a id="del" class="red" onclick="goDel()">删除用户</a>
                                        </li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                        <!-- 编辑用户字段 -->
                        <div class="panel-body">
                            <div class="row">
                                <div class="col-lg-12 col-md-12">
                                    <div class="user-info">
                                        <a class="user-avatar" id="avatar">
                                            <img id="userPhoto" src="${photoUrl}" alt="" title="修改头像">
                                            <form><input type="file" name="user_photo" id="user_photo"></form>
                                        </a>
                                        <h4>
                                            姓名:<input id="name" class="ember-view ember-text-field" type="text" onchange="update(this.id,'text')" data-name="userName">
                                        </h4>
                                        <div class="drop-btn-default">
                                            <div id="status" class="dropdown">
                                                <a id="dLabel" data-target="#" data-toggle="dropdown" data-role="button"
                                                   aria-haspopup="true" aria-expanded="false">
                                                    状态<span class="status green">正常</span>
                                                </a>
                                                <ul class="dropdown-menu" aria-labelledby="dLabel" id="otherStatus">
                                                    <li><a>状态<span class="status red">停用</span></a></li>
                                                    <li><a>状态<span class="status blue">未审核</span></a></li>
                                                </ul>
                                            </div>
                                            <!-- 遮罩层 -->
                                            <div id="wrap" class="wrap"> </div>
                                        </div>
                                        <!-- 分配客服组 -->
                                        <div class="group-label div-user-right">
                                            <div id="groupName"></div>
                                            <a id="assign" data-toggle="modal" data-target="#assignAgent">分配归属组</a>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-lg-12 col-md-12 form-horizontal" id="showUserField"> </div>
                                <div class="col-lg-12 col-md-12 form-horizontal" id="userFieldUlUp" style="display:none;"> </div>
                            </div>
                        </div>
                        <!-- 显示用户字段 -->
                        <div class="panel-body" id="hideUserField" style="display:none;">
                            <div class="col-lg-12 col-sm-12"></div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-lg-12 col-md-12">
                    <div class="panel tab">
                        <div class="panel-heading">
                            <ul class="nav nav-tabs tab-list" role="tablist">
                                <li role="presentation" class="active">
                                    <a href="#communicateInfoId" role="tab" data-toggle="tab">联络历史</a>
                                </li>
                                <li role="presentation" id="workOrders">
                                    <a href="#workInfoId" id="workOrder" role="tab" data-toggle="tab">工单（<span>0</span>）</a>
                                </li>
                                <li role="presentation" id="distributionWO">
                                    <a href="#workInfoId" role="tab" data-toggle="tab" id="distributionWOs">分配工单（<span></span>）</a>
                                </li>
                            </ul>
                        </div>
                        <div class="panel-body tab-content ">
                            <div class="tab-pane active" role="tabpanel" id="communicateInfoId">
                                <div class="link-history" id="goutong">
                                    <!-- 联络历史 -->
                                    <div class="history-list" id="contactHistory"></div>
                                    <div id="chPagination" style="margin-right: 23px;"></div>
                                </div>
                            </div>
                            <div class="tab-pane" role="tabpanel" id="workInfoId">
                                <!-- 用户工单列表页 -->
                                <%@include file="/views/userManage/modal/orderListModal.jsp" %>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="row" id="blbWorkInfoId" style="display:none">
                <div class="col-lg-12 col-md-12">
                    <div class="panel" id="BLBWorkInfoId">
                        <!-- 博乐宝订单列表页 -->
                        <%@include file="/views/userManage/modal/blbOrderModal.jsp" %>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- 发送短信弹窗 -->
<%@include file="/views/userManage/modal/sendNoteModal.jsp" %>

<!-- 工单列表 -->
<%@include file="/views/userManage/userEditWf.jsp" %>

<!-- 分配客服组弹窗 -->
<%@include file="/views/userManage/modal/assignAgentModal.jsp" %>

<!-- 编辑用户角色/权限弹窗 -->
<%@include file="/views/userManage/modal/rolePermissionModal.jsp" %>

<!-- 设置密码弹窗 -->
<%@include file="/views/userManage/modal/setPwdModal.jsp" %>

<!-- 合并用户弹窗 -->
<%@include file="/views/userManage/modal/userMergeModal.jsp" %>

<!-- 删除客户 -->
<%@include file="/views/userManage/modal/deleteUserModal.jsp" %>

<!-- 删除客服/管理员 -->
<%@include file="/views/userManage/modal/deleteAgentModal.jsp" %>

<!-- 补录沟通小结 -->
<%@include file="/views/userManage/modal/bckTrckingModal.jsp" %>

<%--归属客服组或归属客服弹出框--%>
<%@include file="/views/customManager/chooseServiceGroup.jsp" %>

<script id="history-list-template" type="text/x-handlebars-template">
    <div class="form-group listContainer">
        <form class="messageNone" style="display:none;">
            <input name="sessionId" value="{{sessionId}}"/>
            <input name="ccodEntId" value="{{ccodEntId}}"/>
            <input name="ccodAgentId" value="{{ccodAgentId}}"/>
        </form>
        <div class="list-bar">
            <div class="fa"></div>
            <div class="list-time" style="background:#fff;padding-right:10px;">{{createTime}}</div>
            <div class="list-line" style="width: calc(100% - 80px);position: absolute;top: 10px;display:none;"></div>
            <div class="neirong-list" style="width: calc(100% - 400px);"><span>{{content}}</span></div>
            <div class="append">
                {{#if isHideAddOrderBtn}}
                <a>补录工单</a>
                {{/if}}
            </div>
            <div class="icon">
                <a class="fa fa-chevron-circle-down"></a>
            </div>
        </div>
        <div class="text-list" style="display:none;">
            {{#equal source '11'}}
            <div class="textarea-list">
                <textarea disabled="disabled">{{content}}</textarea>
            </div>
            {{else}}
            <div class="textarea-list">
                <textarea>{{content}}</textarea>
            </div>
            {{/equal}}

            <%--IM消息--%>
            <div class="new-message" style="display:none;">
                <div class="chatting">
                    <div class="chakan-long" style="margin-right:10px;"><a>< 查看更多 ></a></div>
                    <div class="chatting-text">
                        暂无消息
                    </div>
                </div>
            </div>

            <%--短信消息--%>
            <div class="short-message phone-message" style="display:none;">
                <ul>
                    <li>
                        <div>
                            <label>客户号码:</label>
                            <span>{{strAni}}</span>
                        </div>
                    </li>
                    <li>
                        <div>
                            <label>发送时间:</label>
                            <span>{{createTime}}</span>
                        </div>
                    </li>
                    <li>
                        <div>
                            <label>处理坐席:</label>
                            <span>{{opName}}</span>
                        </div>
                    </li>
                </ul>
            </div>

            <%--电话--%>
            <div id="phone-parent">
                <div class="phone-message" id="phone-message" style="display:none;">
                    <ul>
                        <li>
                            <div>
                                <label>归属:</label>
                                <span>{{commTypeDesc}}</span>
                            </div>
                            <div>
                                {{#if sessionId}}
                                <label>呼叫时间:</label>
                                {{else}}
                                <label>补录时间:</label>
                                {{/if}}
                                <span>{{createTime}}</span>
                            </div>
                            <div>
                                <label>通话时长:</label>
                                <span>{{commTime}}s</span>
                            </div>
                        </li>
                        <li>
                            <div>
                                <label>主叫:</label>
                                <span>{{strAni}}</span>
                            </div>
                            <div>
                                <label>接机时间:</label>
                                <span>{{startTime}}</span>
                            </div>
                            <div>
                                <label>是否接听:</label>
                                <span>{{isConnected}}</span>
                            </div>
                        </li>
                        <li>
                            <div>
                                <label>被叫:</label>
                                <span>{{strDnis}}</span>
                            </div>
                            <div>
                                <label>处理坐席:</label>
                                <span>{{opName}}</span>
                            </div>
                            <div>
                                <label>呼叫类型:</label>
                                <span>{{callType}}</span>
                            </div>
                        </li>
                    </ul>
                    {{#if sessionId}}
                    <div class="row">
                        <%--<div class="col-sm-2">--%>
                        <div style="padding-left: 15px;float: left;">
                            <label>通话录音:</label>
                        </div>
                        <div class="col-sm-10 audio-phone" style="padding-left: 0"></div>
                    </div>
                    {{/if}}
                </div>
            </div>
        </div>
    </div>
</script>
<script id="comm-IM-temp-left" type="text/x-handlebars-template">
    <div style="float:left">
        <div class="leftCN-comm"></div>
        <div class="leftBox-comm">
            <span>{{text}}</span>
        </div>
    </div>
    <br/><br/>
</script>
<script id="comm-IM-temp-right" type="text/x-handlebars-template">
    <div style="float:right">
        <div class="rightCN-comm"></div>
        <div class="rightBox-comm">
            <span>{{text}}</span>
        </div>
    </div>
    <br/><br/>
</script>
<script type="text/javascript" src="<%=request.getContextPath()%>/script/lib/ajaxFileUpload/ajaxupload.3.5.js"></script>
<script>
    $(function () {
        // 获取并设置坐席客服权限下拉框数据
        RoleId.setOptions(${roleListJson});
        initUserEditPanel(userFieldList);
        initUserShowPanel(userFieldList);

        UserType.init();
        RoleId.init();

        LoginName.init();
        AgentId.init();
        ServiceGroupName.init();
        ServiceName.init();

        $("#toggleEditUserBtn").click(function(){
            var _isEditing = false;//当前是否为编辑客户信息模式
            var $showUserField = $("#showUserField");
            var $userFieldUlUp = $("#userFieldUlUp");
            return function(){
                if(_isEditing){
                    // 如果用户没做修改，则不提交
                    if($.isEmptyObject(USER_MODIFY_FIELD)) {
                        //切换到显示客户信息模式
                        $showUserField.empty();
                        $userFieldUlUp.hide();

                        initUserShowPanel(userFieldList);
                        $showUserField.show();
                        $("#toggleEditUserBtn").html('<i class="fa fa-edit"></i>编辑');
                    } else {
                        $("#toggleEditUserBtn").html('<i class="fa fa-refresh fa-spin"></i>正在保存...');
                        //如果修改了用户详情，保存最新的值
                        updateUserInfo(USER_MODIFY_FIELD).then(function(data){
                            if(data.success){
                                //切换到显示客户信息模式
                                $showUserField.empty();
                                $userFieldUlUp.hide();

                                //考虑到input可以修改为空串，此处不可用extend
                                for(var f in USER_MODIFY_FIELD){
                                    USER_G[f] = USER_MODIFY_FIELD[f];
                                }
                                USER_MODIFY_FIELD = {};

                                initUserShowPanel(userFieldList);
                                $showUserField.show();
                                $("#toggleEditUserBtn").html('<i class="fa fa-edit"></i>编辑');
                            }
                            else{
                                //保存客户详情失败,进行提示
                                console.error(data.msg);
                                notice.danger(data.msg);
                                $("#toggleEditUserBtn").html('<i class="fa fa-save"></i>保存');
                            }
                        });
                    }
                }
                else{
                    //切换到编辑客户信息模式
                    $userFieldUlUp.show();
                    $showUserField.hide();
                    $("#toggleEditUserBtn").html('<i class="fa fa-save"></i>保存');
                }
                _isEditing = !_isEditing;
            }
        }());

        // 用户信息初始化
        userModel.render();
        // 用户自定义字段渲染
        userFieldModule.render();
        //初始化用户状态显示
        Status.init(USER_G.userStatus);
        // 权限控制
        initUserPermission(UserType.get());

        // 获取联络历史表格数据
        getContactHistoryTableData({
            page: 1,
            rows: 5
        });

        // 工单列表初始化
        orderListModal.init();
        //是否是博乐宝企业
        if (USER_G.entId == "${BlueProEntId}") {
            if (USER_G.userType == '1') {// 客户
                $("#blbWorkInfoId").show();
                $("#blbOrderLi").show();
                //电话号码是否为空
                if (USER_G.telPhone != '' && USER_G.telPhone != null) {
                    //客户订单列表初始化
                    BLBOrderListModal.init();
                } else {
                    $("#BLBOrderGrid").hide();
                    $('#noBLBOrderGrid').show();
                }
            } else {// 坐席
                if (USER_G.telPhone != '' && USER_G.telPhone != null) {
                    //客户订单列表初始化
                    BLBOrderListModal.init();
                } else {
                    $("#blbWorkInfoId").hide();
                    $("#blbOrderLi").hide();
                }
            }
        } else {
            $("#blbWorkInfoId").hide();
            $("#blbOrderLi").hide();
        }
    });

    var USER_G = ${userJson};
    //对USER进行修改过的字段
    var USER_MODIFY_FIELD = {};
    var userFieldList = ${activeFieldListJson};
    // 移除客户自定义字段
    userFieldList = userFieldList.filter(function (item) {
        return item.isDefault === true;
    });

    /**
     * 生成客户信息编辑面板
     * @param userFieldList
     */
    function initUserEditPanel(userFieldList) {
        var $fieldList = [];
        for (var i = 0, len = userFieldList.length; i < len; i++) {
            var f = userFieldList[i];
            //1:字符串 2:文本框 3:下拉框 4:复选框 6:数字 7:小数 8:正则表达式 9:电话号码 10:时间输入框 11:地址选择器
            var Reg = {
                "6": "^-?\\d+$",
                "7": "^-?\\d+\\.\\d+$"
            };
            var type = f.componentType,
                    label = f.name,
                    isRequired = f.isRequired,
                    key = f.key,
                    candidate = f.candidateValue,
                    value = USER_G[key];
            var $col = $('<div class="col-sm-3 field-box"></div>');
            if (type == "1" || type == "6" || type == "7" || type == "8" || type == "9" || type == "10") {
                var $input = $('<input>').attr({
                    id: key,
                    type: "text",
                    "data-label": label,
                    "data-required": isRequired,
                    "data-name": key
                }).val(value);

                if (type == "6" || type == "7") {
                    $input.attr("data-reg", Reg[type]);
                }
                if (type == "8" || type == "9") {
                    $input.attr("data-reg", decodeURIComponent(candidate));
                }
                if (type == "10") {
                    $input.attr("data-type", "datetimepicker");
                }
                $col.append($input);
            }
            else if (type == "2") {
                $col.attr('class', 'col-sm-12');
                var $formGroup = $('<div class="form-group"></div>');
                var $label = $('<label class="control-label col-sm-1">' + label + '</label>');
                var $textarea = $('<textarea class="form-control" rows="4"></textarea>').attr({
                    id: key,
                    "data-label": label,
                    "data-required": isRequired,
                    "data-name": key
                });
                $textarea.change(function () {
                    update(this.id, "textarea");
                });
                $textarea.val(value);

                $formGroup.append($label, $('<div class="col-sm-11"></div>').append($textarea));
                $col.append($formGroup);
            }
            else if (type == "3") {
                var $select = $('<select class="form-control"></select>').attr({
                    id: key,
                    "data-required": isRequired,
                    "data-name": key
                }).append('<option value="">-</option>').append(candidate.map(function (opt) {
                    return '<option value="' + opt + '">' + opt + '</option>';
                }));

                // 角色做特殊处理
                if(key === 'userType') {
                    // 用户角色option内容
                    UserType.createOptions($select);
                } else {
                    $select.change(function () {
                        updateSelect(this.id);
                    });
                }

                // 赋值
                $select.val(value);

                var $formGroup = $('<div class="form-group"></div>');
                $formGroup.append('<label class="control-label col-sm-4">' + label + '</label>');
                $formGroup.append($('<div class="col-sm-8"></div>').append($select));
                $col.append($formGroup);
            }
            else if (type == "4") {
                $col.attr('class', 'col-sm-12');
                var $formGroup = $('<div class="form-group"></div>');
                var $div = $('<div class="col-sm-11 checkbox"></div>');
                candidate.forEach(function (item) {
                    var $input = $('<input type="checkbox"/>').attr({
                        value: item,
                        name: key,
                        "data-required": isRequired
                    });

                    // 复选框赋值
                    if(Array.isArray(value)) {
                        var isChecked = false;
                        for(var x = 0, xLen = value.length; x < xLen; x++) {
                            if(item === value[x]) {
                                isChecked = true;
                                break;
                            }
                        }

                        if(isChecked) {
                            $input.prop('checked', true);
                        }
                    }

                    $input.change(function () {
                        updateCheckBox(this);
                    });
                    $label = $('<label></label>');
                    $label.append($input, item);
                    $div.append($label);
                });
                $formGroup.append('<label class="control-label col-sm-1">' + label + '</label> ', $div);
                $col.append($formGroup);
            }

            else if (type == "11") {
                $col.attr('class', 'col-sm-12');
                var $formGroup = $('<div class="form-group"></div>').append('<label class="control-label col-sm-1">' + label + '</label>');
                var $pWrapper  = $('<div class="col-sm-3" data-field-type="pca" onchange="updatePCA(this)"></div>');
                var $province  = $('<select class="form-control"></select>');
                var provinceId = "Company_province" + key;
                var cityId = "Company_city" + key;
                var areaId = "Company_area" + key;
                $province.attr({
                    id: provinceId,
                    "name": 'province_' + key,
                    "data-required": isRequired
                });
                $pWrapper.append($province);
                var $cWrapper = $('<div class="col-sm-3" data-field-type="pca" onchange="updatePCA(this)"></div>');
                var $city = $('<select class="form-control"></select>');
                $city.attr({
                    id: cityId,
                    "name": 'city_' + key,
                    "data-required": isRequired
                });
                $cWrapper.append($city);
                var $aWrapper = $('<div class="col-sm-3" data-field-type="pca" onchange="updatePCA(this)"></div>');
                var $area = $('<select class="form-control"></select>');
                $area.attr({
                    id: areaId,
                    "name": 'area_' + key,
                    "data-required": isRequired
                });

                $aWrapper.append($area);
                $formGroup.append($pWrapper, $cWrapper, $aWrapper);
                $col.append($formGroup);
            }
            $fieldList.push($col);
        }
        $("#userFieldUlUp").append($fieldList);
    }

    /**
     * 显示客户信息显示面板
     * @param userFieldList
     */
    function initUserShowPanel(userFieldList){
        var $fieldList = [];
        for (var i = 0, len = userFieldList.length; i < len; i++) {
            var f = userFieldList[i];
            var key = f.key;
            var type = f.componentType;
            var options = f.candidateValue;
            var value = USER_G[key];
            var $col = $('<div class="col-sm-3 field-box"></div>');
            var $formGroup = $('<div class="form-group" style="position:relative;"></div>');


            // 角色权限转换成对应中文展示
            if(key === 'roleId') {
                /**
                 * 后端没对管理员的角色权限字段做控制，前端进行处理
                 */
                if(UserType.get() === '3') { // 管理员
                    if(USER_G.founder === '1') { // 如果founder字段存在且为1，则为创始人
                        value = '创始人';
                    } else {
                        value = '管理员';
                    }
                } else { // 坐席(这里不可能是客户，因为客户是不存在roleId字段的)
                    value = RoleId.getOptionName(RoleId.get());
                }
            }

            // 角色类别转换成对应中文展示
            if(key === 'userType') {
                value = UserType.getOptionName(UserType.get());
            }

            value = value || "";
            var $label = '<label class="col-sm-4 control-label">' + f.name + '</label>';
            var $static = $('<div class="col-sm-8"><p class="form-control-static">' + value + '</p></div>');
            // 手机号码
            $col.append($formGroup.append($label,$static));
            if(key === "fixedPhone" || key === "telPhone" || type === "9"){
                if(USER_G[key]) {
                    $static.children('p.form-control-static').append('<span style="margin-left: 8px;">' +
                            '<a data-type="show" onclick="callOut(this, event)" style="padding:0 5px;"><i class="fa fa-phone"></i></a>' +
                            '<a data-type="show" onclick="sendNoteWin(this, event)" data-toggle="modal" data-target="#sendNoteModal" style="padding: 0 5px;"><i class="fa fa-envelope"></i></a></span>');
                }
            }
            $fieldList.push($col);
        }
        if ($fieldList.length > 8) {
            var $row1 = $('<div class="row"></div>');
            $row1.append($fieldList.slice(0, 8));
            var $collapse = $('<div class="row collapse" id="collapseContent"></div>');
            $collapse.append($fieldList.slice(8));
            var $collapseBtn = $('<a data-toggle="collapse" style="display:block;width:100%;text-align:center;" data-parent="#userFieldUlUp" href="#collapseContent" aria-expanded="false" aria-controls="">更多<i class="fa fa-angle-double-down"></i></a>');
            $collapse.on('hidden.bs.collapse', function () {
                $collapseBtn.html('更多<i class="fa fa-angle-double-down"></i>');
            });
            $collapse.on('shown.bs.collapse', function () {
                $collapseBtn.html('收起<i class="fa fa-angle-double-up"></i>');
            });
            $("#showUserField").append($row1, $collapse,$collapseBtn);
        }
        else {
            $("#showUserField").append($fieldList);
        }
    }

    /**
     * 更新用户详情
     * return Promise
     */
    function updateUserInfo(userModifyField){
        var userInfos = JSON.stringify($.extend({
            userId: USER_G.userId,
            entId: USER_G.entId
        },userModifyField));
        return $.post("<%=request.getContextPath()%>/userManageMongo/updateUser",{userInfos: userInfos});
    }
    /**
     * @desc 更新省市区
     * @latest Lesty 2016.8.10
     * @div Object [要更新的元素对象的父元素]
     */
    function updatePCA(div) {
        var fieldKey = $(div).children('select')[0].name.split('_')[1];

        var province = $('#Company_province' + fieldKey).val();
        var city = $('#Company_city' + fieldKey).val();
        var area = $('#Company_area' + fieldKey).val();
        var fieldValue = '';

        if (province !== "") {
            // 删除末尾逗号(市或区为空时)
            fieldValue = (province + "," + city + "," + area).replace(/,+$/g, "");
        }

        // 必填项为空则报错
        if ($('#Company_province' + fieldKey).prop('required') === true && fieldValue === "") {
            var label = $(div).closest('.form-group').addClass('has-error').find('label.control-label').text();
            notice.warning(label + '是必填项！不能为空-。-');
            return;
        } else { // 移除错误提示类
            $(div).closest('.form-group').removeClass('has-error');
        }

        USER_MODIFY_FIELD[fieldKey] = fieldValue;
        USER_MODIFY_FIELD['province_' + fieldKey] = province;
        USER_MODIFY_FIELD['city_' + fieldKey] = city;
        USER_MODIFY_FIELD['area_' + fieldKey] = area;
    }

    /*
     * @desc 更新复选框
     * @ele String [需要更新的输入框元素name]
     * */
    function updateCheckBox(ele) {
        var $ele = $(ele);
        var obj = {};
        var name = ele.name;

        obj[name] = [];

        // 获取checkbox数组值
        $ele.closest('.checkbox').find('input[name=' + ele.name + ']').each(function () {
            if ($(this).prop('checked')) {
                obj[name].push($(this).val());
            }
        });

        if (ele.required === true && obj[name].length === 0) {
            var label = $ele.closest('.form-group').addClass('has-error').find('label.control-label').text();
            notice.warning(label + '是必填项！不能为空-。-');
            return;
        } else {
            $ele.closest('.form-group').removeClass('has-error');
        }
        USER_MODIFY_FIELD[name] = obj[name];
    }

    /**
     * @desc [改变用户角色时，进行相关权限控制，目前只有创始人能进行角色权限控制]
     * @latest Lesty 2016.8.17
     */
    function updateUserType() {
        // 设置用户角色
        UserType.set($('#userType').val());

        var userType = UserType.get();
        var userInfos = JSON.stringify({
            userType: userType,
            roleId: userType,
            userId: USER_G.userId,
            entId: USER_G.entId
        });

        if (userType === "3") { // 切换为管理员
            $.post("<%=request.getContextPath()%>/userManageMongo/updateUser", {
                userInfos: userInfos
            }, function (data) {
                if (!data.success) { // 修改失败
                    // 用户角色还原
                    UserType.set('2');
                    notice.danger(data.msg);
                    return;
                }

                // 修改角色类别为管理员(3)
                UserType.set('3');
                // 初始化权限
                initUserPermission(userType);
            }, 'json');

        } else if (userType === "2") { // 切换为坐席
            // 生成角色权限Options并显示初始化角色权限弹窗
            RoleId.createOptions(true);
        }
    }

    /**
     * 输入框onchange
     */
    function update(inputId) {
        // 自定义字段控件
        var $input = $('#' + inputId),
            reg = $input.data('reg'),
            labelName = $input.data('label'),
            inputKey = $input.data('name'),
            inputVal = $input.val().trim();

        // 获取字段信息
        var field = {};
        field[inputKey] = inputVal;

        // 用户信息
        var userInfos = JSON.stringify($.extend(field, {
            userId: USER_G.userId,
            entId: USER_G.entId
        }));
        if (inputId == "loginName") {
            // 验证登录账号
            if (inputVal != "") { // 不为空，则判断账号是否存在
                $("#toggleEditUserBtn").addClass("disabled");
                $.post("<%=request.getContextPath()%>/userManageMongo/existsLoginName?userInfos=" + userInfos).then(checkLoginNameCallBack).done(function(){
                    $("#toggleEditUserBtn").removeClass("disabled");
                });
            }
            else {
                notice.warning("登录账号不能为空！");
            }
        }
        else if (inputId == "telPhone") {
            //手机格式校验
            if (inputVal) {
                // 角色为客户(1)则验证手机格式，否则不验证
                if (UserType.get() === '1' && !Tools.phoneCheck(inputVal)) {
                    notice.warning(labelName + "格式不正确！");
                    return;
                }
                else {
                    //合法，则判断手机号是否已被使用
                    $("#toggleEditUserBtn").addClass("disabled");
                    $.post("<%=request.getContextPath()%>/userManageMongo/existsPhone1?userInfos=" + userInfos + "&telPhone=" + inputVal, existsPhoneCallBack, 'json').done(function(){
                        $("#toggleEditUserBtn").removeClass("disabled");
                    });
                }
            }
            else { // 为空，就更新(置空)
                USER_MODIFY_FIELD[inputId] = "";
            }
        }
        else if (inputId == "email") {
            // 验证邮箱格式
            if (inputVal != "") { // 不为空
                if (!Tools.mailCheck(inputVal)) { // 格式不合法
                    notice.warning(labelName + "格式不正确！");
                    return;
                }
                $("#toggleEditUserBtn").addClass("disabled");
                $.post("<%=request.getContextPath()%>/userManageMongo/existsEmail?entId=" + USER_G.entId + "&email=" + inputVal + "&userId=" + USER_G.userId).then(function(data){
                    if (data.success) {
                        USER_MODIFY_FIELD[inputId] = inputVal;
                    }
                    else {
                        notice.danger(data.msg);
                    }
                    $("#toggleEditUserBtn").removeClass("disabled");
                });
            } else { // 为空，就更新(置空)
                USER_MODIFY_FIELD[inputId] = "";
            }
        }
        //修改用户姓名
        else if(inputId == "name"){
            if(inputVal){
                updateUserInfo({userName:inputVal}).then(function(data){
                    if(!data.success){
                        //保存客户详情失败,进行提示
                        console.error(data.msg);
                        notice.danger(data.msg);
                    }
                    else{
                        USER_G.userName = inputVal;
                    }
                });
            }
            else{
                $input.val(USER_G.userName);
                notice.warning("姓名不能为空");
            }
        }
        else {
            // 验证座机格式
            if (inputId == 'fixedPhone') {
                // 不为空则判断格式 为空或格式合法，则直接发请求
                if (inputVal != "") {
                    // 角色为客户(1)则验证手机格式，否则不验证
                    if (UserType.get() === '1' && !Tools.phoneCheck(inputVal)) {
                        notice.warning(labelName + '格式不正确！');
                        return;
                    }
                }
            }
            else if (inputId == 'serviceGroupName') { // 归属客服组
                field.serviceGroupId = ServiceGroupName.getId();
                USER_MODIFY_FIELD.serviceGroupId = ServiceGroupName.getId();
            }
            else if (inputId === 'serviceName') { // 归属客服
                field.serviceId = ServiceName.getId();
                USER_MODIFY_FIELD.serviceId = ServiceName.getId();
            }

            if ($input.prop('required') && inputVal === '') {
                notice.warning(labelName + "是必填字段！不能为空-。-");
                return;
            }

            // 验证自定义字段合法性
            if (inputVal !== '' && $input.data('type') !== 'datetimepicker') {
                if (customizeFieldCheck(inputVal, reg) === false) {
                    notice.warning(labelName + "格式不正确！");
                    return;
                }
            }

            USER_MODIFY_FIELD[inputId] = inputVal;
        }
    }

    /*
     * @author Lesty
     * @codeDate 2016.8.5
     * @desc 自定义字段格式检测
     * @value String [字段的值]
     * @reg String [对应的正则表达式]
     * @return true:格式正确 false:格式错误
     * */
    function customizeFieldCheck(value, reg) {
        if (reg != null) {
            return new RegExp(reg).test(value);
        }
        else {
            return true;
        }
    }

    /**
     * 更新回调函数
     */
    function updateCallBack(data) {
        if (!data.success) {
            notice.danger(data.msg);
        }
    }

    // 检查登录名回调函数
    function checkLoginNameCallBack(data) {
        if(!data.success) {
            notice.warning(data.msg);
            return;
        }

        var loginName = $("#loginName").val().trim();

        USER_MODIFY_FIELD.loginName = loginName;
    }

    // 号码是否已存在回调函数
    function existsPhoneCallBack(data) {
        if (!data.success) {
            notice.warning(data.msg);
            return;
        }

        var telPhone = $("#telPhone").val().trim();

        if (telPhone === "") {
            USER_MODIFY_FIELD.phoneBinded = "0";
        }

        USER_MODIFY_FIELD.telPhone = telPhone;
    }

    /**
     * 普通下拉框onchange事件
     */
    function updateSelect(data) {
        var $select = $("#" + data);
        var key = $select.data("name");
        var value = $select.val();

        // 必填项为空则报错
        if ($select.prop('required') === true && value === "") {
            var label = $select.closest('.form-group').addClass('has-error').find('label.control-label').text();
            notice.warning(label + '是必填项！不能为空-。-');
            return;
        } else { // 移除错误类
            $select.closest('.form-group').removeClass('has-error');
        }

        // 更新全局修改字段信息
        USER_MODIFY_FIELD[key] = value;
    }

    // 已分配客服组id数据
    var groupId = [];

    /**
     * 用户字段表单
     */
    var userModel = function (user) {
        return {
            render: function () {
                $("#name").val(user.userName);
                $("#avatar").hover(function () {
                    $(this).addClass("hover");
                }, function () {
                    $(this).removeClass("hover");
                });
            }
        };
    }(USER_G);

    /**
     * 用户自定义字段模块
     */
    var userFieldModule = function () {
        var $container = $('#userFieldUlUp');

        function setRequiredEle() {
            $container.find('[data-required]').each(function () {
                var $this = $(this);
                if ($this.attr('data-required') === 'true') {
                    $this.prop('required', true);
                }
            });

            // 必填字段label追加红色星号
            $container.find('[required]').closest('.form-group').find('.control-label').append('<span style="color: red;position: absolute;">*</span>');
        }

        /*
         * @desc 自定义字段输入框框初始化
         * */
        function inputInit() {
            var $datetimepicker = $container.find('input[data-type=datetimepicker]');

            $container.find('input[type=text][data-name]').not('[data-type=datetimepicker]').each(function () {
                var $input = $(this);
                $input.input({
                    onChange: function () {
                        update(this.$element.attr('id'));
                    }
                });
            });

            if ($datetimepicker.length) {
                $datetimepicker.each(function () {
                    var $input = $(this),
                            dateformat = $(this).attr('data-reg'),
                            label = $input.attr('data-label');
                    var isHMS = /hh|ss/.test(dateformat);
                    $input.timeInput({
                        format: dateformat,
                        HMS: isHMS,
                        label: label,
                        value: $input.val(),
                        change: function () {
                            update(this.$element.attr('id'));
                        }
                    });
                });
            }
        }

        /*
         * @desc 自定义字段复选框初始化
         * */
        function checkBoxInit() {
            // 暂时用jstl解决初始化问题
        }

        /*
         * @desc 省市区字段初始化
         * */
        function PCAInit() {
            //省市区字段初始化
            var $pcaGroup = $('#userFieldUlUp [data-field-type=pca], #userFieldUlDown [data-field-type=pca]');
            $pcaGroup.each(function () {
                var fieldKey = $(this).find('select')[0].name.split('_')[1];
                if(USER_G[fieldKey]){
                    var pcaArr = USER_G[fieldKey].split(',');
                    var province = pcaArr[0];
                    var city = pcaArr[1];
                    var area = pcaArr[2];
                    new PCAS("province_" + fieldKey, "city_" + fieldKey, "area_" + fieldKey, province, city, area);
                }
                else{
                    new PCAS("province_" + fieldKey, "city_" + fieldKey, "area_" + fieldKey);
                }
            });
        }

        /**
         * @desc 初始化客服组相关字段
         * */
        function initServiceGroupInput() {
            // 归属客服
            var $serviceInput = $("#serviceName");
            // 归属客服组
            var $serviceGroupInput = $("#serviceGroupName");

            // 打开的页面不是客户就返回
            if (UserType.get() !== '1') {
                return;
            }

            $serviceInput.attr({
                "name": "serviceName",
                "data-target": "#serviceGroupModal"
            });

            $serviceGroupInput.attr({
                "name": "serviceGroupName",
                "data-target": "#serviceGroupModal"
            });

            $serviceInput.click(function () {
                getDataTableServiceGroup(this, true);
            });

            $serviceGroupInput.click(function () {
                // 为避免重复点击，先设为不可操作，请求成功后可操作
                ServiceGroupName.disabled(true);
                getDataTableServiceGroup(this, true);
            });

            initGroupMembers(USER_G.serviceGroupId);
        }

        return {
            render: function () {
                inputInit();
                checkBoxInit();
                PCAInit();
                initServiceGroupInput();

                setRequiredEle();
            }
        };
    }();

    /**
     * 是否为管理员
     */
    var isAdmin = function () {
        return "${userType1}" == '3';//当前账号所属角色 1:客户 2:坐席 3:管理员
    };

    /**
     * 是否为创始人
     */
    var isFounder = function () {
        return "${isFounder}" == '1';//是否为创始人 1:是 0:否
    };

    /**
     * 是否查看自己的资料
     */
    var isOpenSelf = function () {
        return "${userId1}" == USER_G.userId;
    };

    /*
     * @author Lesty
     * @codeDate 2016.8.16
     * @desc 用户角色对象
     * */
    var UserType = (function () {
        var $userType = null;
        var options = [
            {id: '1', name: '客户'},
            {id: '2', name: '客服'},
            {id: '3', name: '管理员'}
        ];

        function init() {
            $userType = $('#userType');
        }

        function get() {
            return USER_G.userType;
        }

        function set(userType) {
            $userType.val(userType);
            USER_G.userType = userType;
        }

        /*
         * @desc 根据state设置用户角色是否可操作
         * */
        function disabled(state) {
            $userType.prop('disabled', state);
        }

        /*
         * @desc [生成下拉框]
         * @$ele Object [一个jQuery对象，如果存在，则为改元素生成下拉框，否则默认为$userType]
         * */
        function createOptions($ele) {
            var tempData = null;
            var optionsHtml = '';

            $ele = $ele || $userType;
            // 生成角色权限
            for(var i = 0, len = options.length; i < len; i++) {
                tempData = options[i];
                optionsHtml += '<option value="' + tempData.id + '">' + tempData.name + '</option>';
            }

            $ele.empty().html(optionsHtml).on('change', updateUserType);
        }

        /*
         * @desc [获取对应名称]
         * @userType String [角色类别ID]
         * */
        function getOptionName(userType) {
            var tempData = null;

            for(var i = 0, len = options.length; i < len; i++) {
                tempData = options[i];
                if(userType === tempData.id) {
                    return tempData.name;
                }
            }

            return '';
        }

        return {
            init: init,
            get: get,
            set: set,
            disabled: disabled,
            getOptionName: getOptionName,
            createOptions: createOptions
        };
    })();

    /**
     * 角色权限对象
     * @author Lesty
     * @codeDate 2016.8.16
     */
    var RoleId = (function () {
        // 角色权限select框
        var $roleId = null;
        // 整个角色权限字段
        var $roleIdField = null;
        // 角色权限的下拉框option数组对象
        var options = [];

        function init() {
            // 角色权限select框
            $roleId = $('#roleId');
            // 整个角色权限字段
            $roleIdField = $roleId.closest('.field-box');
        }

        function get() {
            return USER_G.roleId;
        }

        function set(roleId) {
            $roleId.val(roleId);
            USER_G.roleId = roleId;
        }

        /*
         * @desc 根据state设置角色权限是否可操作
         * */
        function disabled(state) {
            $roleId.prop('disabled', state);
        }

        /*
         * @desc 根据state设置角色权限隐藏或显示
         * */
        function visible(state) {
            state === true ? $roleIdField.show() : $roleIdField.hide();
        }

        /*
         * @desc 根据数据生成角色权限下拉框
         * @rows Array [角色权限数据]
         * @toModal Boolean [true: 初始化权限编辑窗口]
         * */
        function resetRoleId(rows, toModal) {
            // 临时Option数据
            var sub = null;

            // 清空选择框
            $roleId.empty();
            // 生成选项
            for (var j = 0, len = rows.length; j < len; j++) {
                sub = rows[j];
                $roleId.append('<option value="' + sub.id + '">' + sub.name + '</option>');
            }

            if (toModal) {
                // 初始化权限编辑窗口
                rolePermissionModal.init(rows);
            } else {
                // 选择自身对应的选项(如果没有，则select内容为空白)
                $roleId.val(USER_G.roleId);
            }
        }

        /*
         * @desc [获取坐席客服权限下拉框数据]
         * @roleOptions Array [角色权限数组]
         * */
        function setOptions(roleOptions) {
            options = roleOptions;
        }

        /*
         * @desc [生成坐席客服权限下拉框]
         * @toModal Boolean [true: 初始化权限编辑窗口]
         * */
        function createOptions(toModal) {
            // 生成角色权限
            resetRoleId(options, toModal);
            //显示角色权限
            visible(true);
        }

        /*
         * @desc [获取权限ID对应名称]
         * @roleId String [权限ID]
         * */
        function getOptionName(roleId) {
            var tempData = null;

            for(var i = 0, len = options.length; i < len; i++) {
                tempData = options[i];
                if(roleId === tempData.id) {
                    return tempData.name;
                }
            }

            return '';
        }

        return {
            init: init,
            get: get,
            set: set,
            disabled: disabled,
            visible: visible,
            setOptions: setOptions,
            createOptions: createOptions,
            getOptionName: getOptionName
        };
    })();

    /*
     * @author Lesty
     * @codeDate 2016.8.16
     * @desc 用户状态对象
     * */
    var Status = (function () {
        // 所有span状态
        var $statusSpans = $('#status').find('span.status');
        // 下拉框status列表
        var $wrap = $('#wrap');
        // 状态对照表
        var _status = {
            "1": ['status green', '正常'],
            "3": ['status blue', '未审核'],
            "4": ['status red', '停用'],
            "9": ['status red', '已删除']
        };

        function init(status) {
            /*
             * 每次都需要初始化的方法放这里
             * */
            // 设置当前用户状态
            if (!statusCheck(status)) {
                notice.warning('状态码不正确，用户状态初始化失败!');
                return;
            } else if (status === '9') {
                notice.warning('该用户已被删除!');
            }

            set(status);

            /*
             * 只需要初始化一次的方法放这里
             * */
            if (typeof arguments.callee.initFlag != 'string') {
                arguments.callee.initFlag = 'init';
                // 注册事件
                regEvent();
            }
        }

        function get() {
            return USER_G.userStatus;
        }

        function set(status) {
            USER_G.userStatus = status;

            var i = 1;
            // 更新当前状态以及状态下拉框内容
            for (var code in _status) {
                if (status == code) { // 当前状态
                    $($statusSpans[0]).removeClass().addClass(_status[code][0]).text(_status[code][1]).data('status', code);
                } else { // 下拉框内容
                    $($statusSpans[i]).removeClass().addClass(_status[code][0]).text(_status[code][1]).data('status', code);
                    i++;
                }
            }
        }

        function statusCheck(status) {
            return (status in _status);
        }

        /*
         * @desc 根据state设置用户状态是否可操作
         * */
        function disabled(state) {
            // 通过隐藏和显示遮罩层实现disabled操作
            state === true ? $wrap.show() : $wrap.hide();
        }

        // 更新用户状态
        function changeStatus(status) {
            set(status);

            var userInfos = "{'userStatus':'" + status + "','userId':'" + USER_G.userId + "','entId':'" + USER_G.entId + "'}";
            $.post("<%=request.getContextPath()%>/userManageMongo/updateUser?userInfos=" + userInfos, function (data) {
                if (data.success) {
                    notice.success("状态更新成功!");
                } else {
                    notice.danger('服务器提示您：更新用户状态失败!');
                }
            }, 'json');
        }

        function regEvent() {
            // 用户状态切换事件
            $("#otherStatus").find('li').on('click', function (event) {
                var status = $(this).find('span.status').data('status');
                if (!statusCheck(status)) {
                    notice.warning('状态码不正确，切换用户状态失败!');
                    event.stopPropagation();
                    return;
                }

                changeStatus(status);
            });
        }

        return {
            init: init,
            get: get,
            set: set,
            disabled: disabled
        };
    })();

    /*
     * @author Lesty
     * @codeDate 2016.8.16
     * @desc 客服组对象
     * */
    var Group = (function () {
        // 当前所在客服组
        var $groupName = $('#groupName');
        // 分配客服组按钮
        var $assignGroup = $('#assign');

        function init() {
            /*
             * 每次都需要初始化的方法放这里
             * */
            //查询所属客服组
            $.post("<%=request.getContextPath()%>/usrManage/belongGroup?userId=" + USER_G.userId + "&loginName=" + USER_G.loginName, createCurGroups, 'json');

            /*
             * 只需要初始化一次的方法放这里
             * */
            if (typeof arguments.callee.initFlag != 'string') {
                arguments.callee.initFlag = 'init';
                // 注册事件
                regEvent();
            }
        }

        /*
         * @desc 创建用户当前所属客服组
         * */
        function createCurGroups(data) {
            if (!data.success) {
                notice.warning('获取所属客服组失败！');
                return;
            }

            var rows = data.rows;
            var spanHtml = '';
            // 清空全局客服组id数组
            groupId.length = 0;

            // 生成当前所属客服组
            for (var i = 0, len = rows.length; i < len; i++) {
                groupId.push(rows[i].groupId);
                spanHtml += '<span class="label label-default" style="margin-left: 5px;">' + rows[i].groupName + "</span>";
            }

            // 如果有用户组，则显示用户组提示
            if(len > 0) {
                spanHtml = "用户组:" + spanHtml;
            }

            $groupName.html(spanHtml);
        }

        /*
         * @desc 根据state设置分配客服组按钮隐藏或显示
         * */
        function visible(state) {
            state === true ? $assignGroup.show() : $assignGroup.hide();
        }

        /*
         * @desc 获取并创建全部客服组
         * */
        function createAllGroup() {
            $.post("<%=request.getContextPath()%>/group/allGroups", function (data) {
                if (data.success) {
                    assignAgentModal.render(groupId, data.rows);
                }
                else {
                    notice.danger('获取可选客户组信息失败!');
                }
            }, 'json');
        }

        // 事件注册
        function regEvent() {
            // 分配客服组
            $assignGroup.on('click', createAllGroup);
        }

        return {
            init: init,
            visible: visible
        };
    })();

    /*
     * @author Lesty
     * @codeDate 2016.8.16
     * @desc 登录账号对象
     * */
    var LoginName = (function () {
        var $loginName = null;

        function init() {
            $loginName = $('#loginName');
        }

        function get() {
            return USER_G.loginName;
        }

        function set(name) {
            $loginName.val(name);
            USER_G.loginName = name;
        }

        /*
         * @desc 根据state设置用户角色是否只读
         * */
        function readonly(state) {
            $loginName.prop('readonly', state);
        }

        return {
            init: init,
            get: get,
            set: set,
            readonly: readonly
        };
    })();

    /*
     * @desc [坐席工号]
     * */
    var AgentId = (function () {
        var $agentId = null;
        // 整个坐席工单控件字段
        var $agentIdField = null;

        function init() {
            $agentId = $('#agentId');
            // 整个坐席工单控件字段
            $agentIdField = $agentId.closest('.field-box');
        }

        function get() {
            return USER_G.agentId;
        }

        function set(id) {
            $agentId.val(id);
            USER_G.agentId = id;
        }

        /*
         * @desc 根据state设置是否只读
         * */
        function readonly(state) {
            $agentId.prop('readonly', state);
        }

        /*
         * @desc 根据state设置控件隐藏或显示
         * */
        function visible(state) {
            state === true ? $agentIdField.show() : $agentIdField.hide();
        }

        return {
            init: init,
            get: get,
            set: set,
            readonly: readonly,
            visible: visible
        }
    })();

    /*
     * @desc [归属客服组]
     * */
    var ServiceGroupName = (function () {
        var $serviceGroup = null;
        // 整个控件字段
        var $serviceGroupField = null;

        function init() {
            $serviceGroup = $('#serviceGroupName');
            // 整个控件字段
            $serviceGroupField = $serviceGroup.closest('.field-box');
        }

        function getName() {
            return $serviceGroup.val();
        }

        function getId() {
            return $serviceGroup.data('serviceGroupId');
        }

        function disabled(state) {
            $serviceGroup.prop('disabled', state);
        }

        /*
         * @desc 根据state设置控件隐藏或显示
         * */
        function visible(state) {
            state === true ? $serviceGroupField.show() : $serviceGroupField.hide();
        }

        return {
            init: init,
            getName: getName,
            getId: getId,
            disabled: disabled,
            visible: visible
        }
    })();

    /*
     * @desc [归属客服]
     * */
    var ServiceName = (function () {
        var $service = null;
        // 整个控件字段
        var $serviceField = null;

        function init() {
            $service = $('#serviceName');
            // 整个控件字段
            $serviceField = $service.closest('.field-box');
        }

        function getName() {
            return $service.val();
        }

        function getId() {
            return $service.data('serviceId');
        }

        function disabled(state) {
            $service.prop('disabled', state);
        }

        /*
         * @desc 根据state设置控件隐藏或显示
         * */
        function visible(state) {
            state === true ? $serviceField.show() : $serviceField.hide();
        }

        return {
            init: init,
            getName: getName,
            getId: getId,
            disabled: disabled,
            visible: visible
        }
    })();

    /**
     * @desc 编辑/保存切换按钮
     */
    var ToggleEditUserBtn = (function() {
        var $toggleEditUserBtn = $('#toggleEditUserBtn');

        /*
         * @desc 根据state设置控件隐藏或显示
         * */
        function visible(state) {
            state === true ? $toggleEditUserBtn.show() : $toggleEditUserBtn.hide();
        }

        return {
            visible: visible
        };
    })();

    var size = "";

    /*
     * @author Lesty
     * @codeDate 2016.7.22
     * @desc [创建/刷新联络历史表格]
     * @tableData Array [联络历史数据]
     * */
    var createContactHistoryTable = (function () {
        var lsTemp = Handlebars.compile($("#history-list-template").html());
        var $table = $('#contactHistory');

        return function (tableData) {
            var rows = tableData ? tableData : [];
            var html = [];
            // 一条数据
            var $li = null;
            // 联络历史图标
            var $icon = null;

            // 没有联络历史
            if (rows.length <= 0) {
                $table.empty().append("<strong style='font-size: 15px'>当前联络历史空空如也!</strong>");
                return;
            }

            var tempInfo = null;
            // 遍历数据生成联络历史
            for (var i = 0, len = rows.length; i < len; i++) {
                tempInfo = rows[i];

                // 判断归属类型'0': 名单，'1': 客户
                // 考虑到旧数据存的是null，做特殊判断
                // @lesty 2017/5/7
                if(tempInfo.commType === '0') { // 名单，隐藏补录工单按钮
                    tempInfo.isHideAddOrderBtn = false;
                    tempInfo.commTypeDesc = '名单';
                } else { // 客户
                    tempInfo.isHideAddOrderBtn = true;
                    tempInfo.commTypeDesc = '客户';
                }

                // 初始化
                $li = $(lsTemp(tempInfo));
                $icon = $($($li.find("div.list-bar")[0]).find("div")[0]);
                // 没有沟通小结
                if (!tempInfo.content) {
                    $($li.find("div.neirong-list")[0]).find("span").empty().append("此次联络暂无沟通小结");
                }
                // 判断联络类型
                switch (tempInfo.source) {
                    case "1":
                        $icon.addClass("fa-im");
                        var msgDiv = $($li.find("div.new-message")[0]);
                        msgDiv.css("display", "block");
                        initIMMessage(msgDiv, tempInfo.message);
                        break;
                    case "3":
                        $icon.addClass("fa-envelope-o");
                        break;
                    case "5":
                    case "6":
                        $icon.addClass("fa-phone");
                        $li.find("div#phone-message").show();
                        break;
                    case "7":
                        $icon.addClass("fa-weixin");
                        $li.find("div.new-message").show();
                        break;
                    case "8":
                        $icon.addClass("fa-video-camera");
                        break;
                    case "9":
                        $icon.addClass("fa-wpforms");
//                        $li.find("div.phone-message").show();
                        break;
                    case "10":
                        $icon.addClass("fa-whatsapp");
                        break;
                    case "11":
                        $icon.addClass("fa-comment-o");
                        $li.find(".short-message").show();
                        break;
                    default:
                        $icon.addClass("fa-clipboard");
                }

                //上（下）拉图标点击事件初始化
                $li.find("div.icon").click((function () {
                    var commId = tempInfo.commId;

                    return function () {
                        upDownToggle(commId, this);
                    }
                })());

                // 如果是弹屏页，且是当前联络历史
                if ('${isTanPing}' === '1' && tempInfo.commId == '${commId}') {
                    $li.find("div.append").find("a").text("创建工单");
                }

                //补录工单按钮点击事件初始化
                $li.find("div.append").click((function () {
                    var param = tempInfo.param;
                    return function () {
                        newworkParam(param);
                    }
                })());

                //（下拉框）沟通小结框里的值改变事件初始化
                $li.find(".textarea-list > textarea").on("change", (function () {
                    var commId = tempInfo.commId;

                    return function () {
                        var $_my = $(this);
                        submitContent(commId, $_my);
                    };
                }()));
                // 添加一条数据
                html.push($li);
            }

            // 创建表格
            $table.empty().append(html);
        }
    })();

    /*
     * @author Lesty
     * @codeDate 2016.7.22
     * @desc [获取联络历史表格数据]
     * @param Object [包括pager更新所需参数]
     * */
    var getContactHistoryTableData = (function () {
        var paramCache = {};

        // 初始化分页
        var pager = new cri.Pager($("#chPagination"), {
            page: 1,
            pageSize: 5,
            total: 0,
            onPage: function (page, pageSize) {
                $.extend(paramCache, {page: page, rows: pageSize});
                getContactHistoryTableData(paramCache);
            }
        });
        return function (param) {
            $.ajax({
                url: "<%=request.getContextPath()%>/communicate/getCommsByUserId",
                dataType: 'json',
                data: {
                    userId: USER_G.userId,
                    page: param.page,
                    rows: param.rows
                },
                success: function (data) {
                    if (!(data.success)) {
                        notice.danger(data.msg);
                        return;
                    }

                    if (data.rows != null) {
                        createContactHistoryTable(data.rows);
                    }
                    // 更新分页栏
                    pager.update(param.page, param.rows, data.total);
                    // 合并对象
                    $.extend(paramCache, param);
                }
            });
        }
    })();

    /*
     * @desc 保存沟通小结
     * */
    function submitContent(commId, $textAreaEle) {
        // 沟通小结内容
        var content = $textAreaEle.val();
        $.post("<%=request.getContextPath()%>/communicate/saveContent", {
            commId: commId,
            content: content
        }, function (data) {
            if (data.success) {
                var $listContainer = $textAreaEle.closest('.listContainer');
                notice.success(data.msg);
                // 替换单行沟通小结
                $listContainer.find('.neirong-list > span').text(content);
                // 点击收起按钮
                $listContainer.find('div.icon').click();
            } else {
                notice.danger(data.msg);
            }
        }, 'json');
    }

    /*
     * @desc [根据flag判断能否修改个人信息]
     * @flag Boolean [true/不传: 能修改，false: 不能]
     * */
    function canModifyInfo(flag) {
        var $top = $("#top");
        // 基本信息中的头像
        var $avatar = $('#avatar');
        // 只读元素
        var $toReadOnlyEles = $top.find('input, textarea').not('[type=file], [type=checkbox]');
        // 不可操作元素
        var $toDisabledEles = $top.find('input[type=checkbox], input[type=file], select');
        var $dateEles = $top.find('input[data-type=datetimepicker]').closest('.timeInputGroup').find('input, button');
        if (flag === false) {
            $toReadOnlyEles.prop('readonly', true);
            $toDisabledEles.prop('disabled', true);
            $dateEles.prop('disabled', true);
            // 移除头像的hover事件
            $avatar.off('mouseenter mouseleave');
        } else {
            $toReadOnlyEles.prop('readonly', false);
            $toDisabledEles.prop('disabled', false);
            $dateEles.prop('disabled', false);
        }
    }

    /*
     * @desc 根据登录的账号(权限)以及打开的资料页面，设置详情页面的展示方式，常用操作
     * @notice 没有把握，请勿轻易修改该函数，修改请留下修改日期及修改人姓名-。-
     * @userType String [当前打开页面的用户类别]
     * @latest Lesty 2016.10.28
     * */
    var initUserPermission = function (userType) {
        // **任何角色都不可修改的字段
        var $readOnlyEles = $('#createTime, #latestCntTime, #updateTime');
        // 合并用户
        var $merge = $('#merge');
        // 修改密码
        var $pwdSet = $('#pwdSet');
        // 删除用户
        var $del = $('#del');
        // 分配工单tab
        var $distributionWO = $("#distributionWO");

        // 用户角色不可操作
        UserType.disabled(true);
        // 角色权限隐藏
        RoleId.visible(false);
        // 状态可以更改
        Status.disabled(false);
        // 分配客服组按钮隐藏
        Group.visible(false);
        // 登录账号只读
        LoginName.readonly(true);
        // 坐席工号只读
        AgentId.readonly(true);
        // 隐藏客户归属客服组
        ServiceGroupName.visible(false);
        // 隐藏客户归属客服
        ServiceName.visible(false);
        // 默认隐藏编辑按钮
        ToggleEditUserBtn.visible(false);
        // 合并用户操作隐藏
        $merge.hide();
        // 显示修改密码
        $pwdSet.show();
        // 隐藏删除用户
        $del.hide();
        // 隐藏分配工单tab
        $distributionWO.hide();
        // 设置只读元素
        $readOnlyEles.prop('readonly', true);

        // 只有打开是客户时，才显示合并用户操作，才会显示归属客服组以及归属客服
        // 补录沟通小结、创建工单，任何类别角色都有
        // 删除用户按照权限来判断(不能操作自己信息，然后创始人>管理员>坐席>客户)
        // 修改密码能操作自己，并且权限低于自己的
        // 分配工单tab只有坐席和管理员有
        // 只有客户的登录账号可以被修改，坐席和管理员不能被修改
        // @new 2016.12.28 任何角色都能编辑客户
        if (userType === "1") { // 打开的是客户页面
            // 可以修改登录账号
            LoginName.readonly(false);
            // 隐藏坐席工号
            AgentId.visible(false);
            // 显示客户归属客服组
            ServiceGroupName.visible(true);
            // 显示客户归属客服
            ServiceName.visible(true);
            // 显示编辑按钮
            ToggleEditUserBtn.visible(true);
            $merge.show();
        } else {
            // 隐藏用户角色中的[客户]选项
            $('#userType > option[value="1"]').hide();
            // 查询所属客服组
            Group.init();
            // 显示坐席工号
            AgentId.visible(true);
            // 显示分配工单tab
            $distributionWO.css("display", "inline-block");
        }

        // 按照权限来判断(不能操作自己信息，然后创始人>管理员>坐席>客户)
        // 用户角色和权限类型比较特殊，客户的角色都不能变更
        // 只有创始人能修改管理员和坐席的角色
        if (isFounder()) { // 如果本人是创始人
            // 显示编辑按钮
            ToggleEditUserBtn.visible(true);
            Group.visible(true);
            if (isOpenSelf()) { // 如果打开的是自己的页面
                Status.disabled(true);
            } else {
                UserType.disabled(false);
                $del.show();
                if (userType === "3") { // 管理员(这里可能是创始人)
                    // do nothing
                } else if (userType === "2") { // 坐席
                    RoleId.createOptions(false);
                } else if (userType === "1") { // 客户
                    UserType.disabled(true);
                    Group.visible(false);
                }
            }
        } else if (isAdmin()) { // 如果本人是管理员(非创始人)
            if (isOpenSelf()) { // 如果打开的是自己的页面
                Status.disabled(true);
                // 显示编辑按钮
                ToggleEditUserBtn.visible(true);
            } else {
                $del.show();
                if (userType === "3") { // 管理员(这里可能是创始人)
                    Status.disabled(true);
                    canModifyInfo(false);
                    // 隐藏修改密码以及删除用户操作
                    $pwdSet.hide();
                    $del.hide();
                } else if (userType === "2") { // 坐席
                    RoleId.createOptions(false);
                    Group.visible(true);
                    // 显示编辑按钮
                    ToggleEditUserBtn.visible(true);
                } else if (userType === "1") { // 客户
                    // do nothing
                }
            }
        } else if ("${userType1}" == "2") { // 如果本人是坐席
            if (isOpenSelf()) { // 如果打开的是自己的页面
                Status.disabled(true);
                RoleId.createOptions(false);
                RoleId.disabled(true);
                // 显示编辑按钮
                ToggleEditUserBtn.visible(true);
            } else {
                if (userType === "3") { // 管理员(这里可能是创始人)
                    Status.disabled(true);
                    $pwdSet.hide();
                    canModifyInfo(false);
                } else if (userType === "2") { // 坐席
                    Status.disabled(true);
                    $pwdSet.hide();
                    canModifyInfo(false);
                    RoleId.createOptions(false);
                    RoleId.disabled(true);
                } else if (userType === "1") { // 客户
                    $del.show();
                }
            }
        }
    };


    // 头像上传
    var bg_upload = new AjaxUpload($("#user_photo"), {
        action: "<%=request.getContextPath()%>/userManageMongo/changePhoto",
        name: "image",
        onSubmit: function (file, ext) {
            if (!(ext && /^(jpg|png|jpeg|gif)$/.test(ext))) {
                notice.warning("仅支持JPG, PNG 或 GIF 格式文件上传");
                return false;
            }
        },
        data: {userId: USER_G.userId},
        onComplete: function (file, response) {
            if (response) {
                var data = eval("(" + response + ")");
                if (data.success === true) {
                    notice.success(data.msg);
                    //刷新头像显示
                    $("#userPhoto").attr("src", data.rows);

                    //更新右上角头像
                    top.refUserPhoto(data.rows, USER_G.userId);
                } else {
                    notice.danger(data.msg);
                }
            }
        }
    });

    /*
     * @desc [把用户信息带入给创建工单页面]
     * @isTanPing String ['isTanPing': 当前页面是弹屏页]
     * */
    function newwork(isTanPing) {
        if (isTanPing === 'isTanPing') { // 当前是弹屏页
            // 获取弹屏信息并传到创建工单页
            isTanPing = '${commparam}';
            isTanPing = encodeURI(isTanPing);
            parent.newwork("", "", "", isTanPing);
        } else {
            var curEmail = USER_G.email;
            var curUserId = USER_G.userId;
            var curUserName = USER_G.userName;
            parent.newwork(curEmail, curUserId, curUserName, "");
        }
    }

    // 补录工单
    function newworkParam(param) {
        param = encodeURI(param);
        parent.newwork("", "", "", param);
    }

    // 用户合并
    function goMerge() {
        userMergeModal.init();
    }

    // 补录沟通小结
    function goMake() {
        bckTrckingModal.init(getContactHistoryTableData);
    }

    // 修改密码
    function goSetPwd() {
        setPwdModal.init();
    }

    // 删除用户
    function goDel() {
        if (UserType.get() === '1') { // 删除客户
            deleteUserModal.init(USER_G.userName);
        } else { // 其他
            deleteAgentModal.init(USER_G.userName);
        }
    }

    //发送短信弹窗
    function sendNoteWin(ele, event) {
        event.preventDefault();
        var $_my = $(ele);
        var telPhone = '';
        var errorMsg = '';

        var type = $_my.attr('data-type');
        if(type === 'edit') {
            telPhone = $_my.closest('.form-group').find('input').val().trim();
        } else {
            telPhone = $_my.closest('.form-group').find('.form-control-static').text().trim();
        }

        if (telPhone === '') {
            errorMsg = "电话号码不能为空-。-";
        } else if (UserType.get() === '1' && !Tools.phoneCheck(telPhone)) { // 角色为客户(1)则验证手机格式，否则不验证
            errorMsg = "电话号码格式不合法-。-";
        }

        if (errorMsg != '') {
            $('#sendNoteModal').modal('hide');
            notice.warning(errorMsg);
            event.stopImmediatePropagation();
            return;
        }

        // 初始化短信弹窗
        sendNoteModal.init(telPhone);
    }

    /*
     * @desc [软电话外呼]
     * */
    function callOut(ele, event) {
        event.preventDefault();
        var $_my = $(ele);
        var telPhone = '';
        var errorMsg = '';

        var type = $_my.attr('data-type');
        if(type === 'edit') {
            telPhone = $_my.closest('.form-group').find('input').val().trim();
        } else {
            telPhone = $_my.closest('.form-group').find('.form-control-static').text().trim();
        }

        if (telPhone === '') {
            errorMsg = "电话号码不能为空-。-";
        } else if (UserType.get() === '1' && !Tools.phoneCheck(telPhone)) { // 角色为客户(1)则验证手机格式，否则不验证
            errorMsg = "电话号码格式不合法-。-";
        }
        if (errorMsg !== '') {
            notice.warning(errorMsg);
            return;
        }
        parent.callOut(telPhone);
    }

    // 联络历史上（下）拉图标点击事件处理函数
    // @latest Lesty 2016.7.22
    function upDownToggle(commId, that) {
        var $this = $(that);
        // 一条联络历史
        var $contactHistory = $this.closest('.listContainer');
        // 下拉内容区域
        var tog = $contactHistory.find("div.text-list")[0];
        //如果是弹屏且本条联络历史则更新信息
        if (commId == '${commId}' && $($(that).children("a")[0]).hasClass("fa-chevron-circle-down")) {
            $.ajax({
                url: "<%=request.getContextPath()%>/communicate/getCommByCommId",
                dataType: 'json',
                data: {
                    commId: commId
                },
                success: function (data) {
                    if (!(data.success)) {
                        notice.danger(data.msg);
                    } else {
                        if (data.rows) {
                            var lsTemp = Handlebars.compile($("#history-list-template").html());
                            var $li = $(lsTemp(data.rows));
                            $li.find("div#phone-message").css("display", "block");
                            $contactHistory.find("div#phone-parent").empty().append($li.find("div#phone-message"));

                        }
                    }
                }
            });
        }

        // 单行沟通小结
        var textContent = $contactHistory.find("div.neirong-list")[0];
        // 下拉上拉图标
        var $iconLink = $($(that).children("a")[0]);

        // 改变图标
        $iconLink.toggleClass("fa-chevron-circle-down fa-chevron-circle-up");

        if ($iconLink.hasClass("fa-chevron-circle-up")) { // 内容展开处理
            // 隐藏单行沟通小结文字
            $(textContent).find("span").hide();

            // 如果电话基本信息区域显示，则获取录音
            if ($contactHistory.find("div#phone-message").css("display") == "block" && $contactHistory.find('.audio-phone').length !== 0) {
                //初始化录音播放控件和下载录音链接
                initAudioAndDownload($contactHistory);
            }
        } else { // 内容上拉处理
            // 显示单行沟通小结文字
            $(textContent).find("span").show();
        }
        // 显示或隐藏下拉内容区域
        $(tog).slideToggle();
    }

    //初始化录音播放控件和下载录音链接
    function initAudioAndDownload($contactHistory) {
        // 获取表单参数(seesionId,ccodEntId等)
        var form = $contactHistory.find("form").formValue();
        //获取通话录音地址并赋值给audio标签
        $.post("<%=request.getContextPath()%>/communicate/getRecordUrl", form, function (data) {
            var html = "";

            if (data.success) {
                var value = data.rows || [];
                // 文件判断正则
                var reg = /.(mp3|wav)$/i;
                // iframe路径
                var src = '';

                // 如果录音存在
                if (value.length > 0) {
                    for (var i = 0, len = value.length; i < len; i++) {
                        html += '';
                        // 文件格式必须为mp3/wav类型
                        // --Lesty 2016.7.22
                        if (reg.test(value[i]) === true) {
                            src = '<%=request.getContextPath()%>/communicate/playAudio?audioSrc=' + encodeURI(value[i]);
                            html += '<div class="audio-box"><iframe scrolling="no" width="100%" height="100%" src="' + src + '" seamless frameborder="0"></iframe></div>';
                        } else {
                            html += "<div><span>录音格式不正确,格式需为mp3或者wav</span></div>";
                        }
                    }
                } else {
                    html = "<span>录音资源不存在-。-</span>";
                }
            } else {
                html = "<span>" + "暂无录音-。-" + "</span>";
            }

            // 生成代码
            $contactHistory.find('.audio-phone').empty().append(html);
        }, 'json');
    }
</script>
<script>
    /**
     * 展示IM沟通消息
     */
    function initIMMessage(msgDiv, msgList) {
        if (!msgList) {
            return;
        }
        var msgContent = $(msgDiv.find("div.chatting-text")[0]);
        var jsonList = eval("(" + msgList + ")");
        msgDiv.find("div.chatting").css("padding-left", "0px");
        msgDiv.find("div.chatting").css("padding-right", "0px");
        msgContent.empty();
        for (var id in jsonList) {
            msgContent.css("padding-left", "10px");
            msgContent.css("padding-right", "10px");
            msgContent.css("overflow", "auto");
            msgContent.css("max-height", "200px");
            if (jsonList[id].direction == "recv") {
                var leftTemp = Handlebars.compile($("#comm-IM-temp-left").html());
                msgContent.append(leftTemp(jsonList[id]));
            } else {
                var rightTemp = Handlebars.compile($("#comm-IM-temp-right").html());
                msgContent.append(rightTemp(jsonList[id]));
            }
        }
    }
</script>
</body>
</html>
