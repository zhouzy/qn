<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>新建工单</title>
    <%@include file="/views/include/pageHeader.jsp"%>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/static/css/innerFrame.css">
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/script/lib/summernote/summernote.css">
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/static/css/order.css">
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/script/lib/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.css">
    <script src="<%=request.getContextPath()%>/script/lib/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
    <script src="<%=request.getContextPath()%>/script/lib/bootstrap-datetimepicker-master/js/locales/bootstrap-datetimepicker.zh-CN.js"></script>
    <script src="<%=request.getContextPath()%>/script/lib/summernote/summernote.js" ></script>
    <script src="<%=request.getContextPath()%>/script/lib/summernote/summernote-zh-CN.js" ></script>
    <script src="<%=request.getContextPath()%>/script/lib/PCASClass.js"></script>
</head>
<body>
<div class="left-side" data-status="0">
    <header class="head">
        <span>客户信息</span>
    </header>
    <div class="container-fluid info-panel">
        <div class="row">
            <div class="col-sm-12">
                <div class="list-group">
                    <div class="list-group-item" >
                        <div class="row-picture" id="userPic">
                            <img class="circle" src="${photoUrl}" alt="icon">
                        </div>
                        <div class="row-content">
                            <h4 class="list-group-item-heading">${user.userName}</h4>
                            <p class="list-group-item-text">状态<span class="status green" id="userStatus" style="margin-left: 5px;">正常</span></p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="row">
            <div class="col-sm-12">
                <div class="form-horizontal">
                    <div class="form-group">
                        <label class="control-label col-sm-4">邮箱：</label>
                        <div class="col-sm-8">
                            <span class="form-control-static">${user.email}</span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="control-label col-sm-4">手机：</label>
                        <div class="col-sm-8">
                            <span class="form-control-static">${user.telPhone}
                               <a onclick="callout('${user.telPhone}')" style="padding: 10px;"><i class="fa fa-phone"></i></a>
                            </span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="control-label col-sm-4">座机：</label>
                        <div class="col-sm-8">
                            <span class="form-control-static">${user.fixedPhone}</span>
                            <a onclick="callout('${user.fixedPhone}')" style="padding: 10px;"><i class="fa fa-phone"></i></a>
                        </div>
                    </div>
                    <div id="nikAndSign">
                        <div class="form-group">
                            <label class="control-label col-sm-4">客服昵称：</label>
                            <div class="col-sm-8">
                                <span class="form-control-static">${user.nickName}</span>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="control-label col-sm-4">客服签名：</label>
                            <div class="col-sm-8">
                                <span class="form-control-static">${user.signature}</span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="control-label col-sm-4">角色：</label>
                        
                        <div class="col-sm-8">
                              <span id="typeSelect" class="form-control-static"></span>
                         <!--    <select class="form-control" id="typeSelect" onchange="upTypeSelect()" data-name="userType">
                                <option value="1">客户</option>
                                <option value="2">客服</option>
                                <option value="3">管理员</option>
                            </select> -->
                        </div>
                    </div>
                    <div class="form-group" id="roleSelect" style="display:none">
                        <label class="control-label col-sm-4" id="roleLabel">角色权限：</label>
                        <div class="col-sm-8" >
                              <span id="secondType" class="form-control-static"></span>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="control-label col-sm-4">用户说明：</label>
                        <div class="col-sm-8">
                            <span class="form-control-static">${user.userDesc}</span>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="control-label col-sm-4">详细信息：</label>
                        <div class="col-sm-8">
                            <span class="form-control-static">${user.remark}</span>
                        </div>
                    </div>

                    <div class="form-group">
                        <div class="col-sm-12">
                            <a id="openOrClose" onclick="openOrClose()" class="btn btn-block btn-success btn-sm">展开</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="row">
            <div class="col-sm-12">
                <div id="userFieldUl" class="form-horizontal" style="display:none;">
                    <c:forEach items="${activeFieldList}" var="item">
                        <div class="form-group">
                            <label class="control-label col-sm-4">${item.name }：</label>
                            <c:choose>
                                <c:when test="${item.componentType=='1' || item.componentType=='2' || item.componentType=='6' || item.componentType=='7' || item.componentType=='8' || item.componentType=='9' || item.componentType=='10' || item.componentType=='11'}">
                                    <c:set value="${user[item.key]}" var="fieldKey" scope="request"></c:set>
                                    <div class="col-sm-8">
                                        <span class="form-control-static">${fieldKey}</span>
                                    </div>
                                </c:when>

                                <c:when test="${item.componentType=='3'}">
                                    <div class="col-sm-8">
                                        <c:set value="${user[item.key]}" var="fieldKey" scope="request"></c:set>
                                        <select id="${item.key}" class="form-control" data-name="${item.key}" disabled>
                                        	<option value="${fieldKey}">${fieldKey}</option>
                                        </select>
                                    </div>
                                </c:when>

                                <c:when test="${item.componentType=='4'}">
                                    <div class="col-sm-8">
                                        <div class="checkbox">
                                            <c:set var="checkIndex" value="0" />
                                            <c:forEach items="${item.candidateValue}" var="checkItems">
                                                <label style="cursor: not-allowed;">
                                                    <c:set var="isChecked" value=""/>
                                                    <c:if test="${checkItems == user[item.key][checkIndex]}">
                                                        <c:set var="isChecked" value="checked"/>
                                                        <c:set var="checkIndex" value="${checkIndex + 1}"/>
                                                    </c:if>

                                                    <input type="checkbox" value="${checkItems}" name="${item.key}" disabled="" ${isChecked}>${checkItems}
                                                </label>
                                            </c:forEach>
                                        </div>
                                    </div>
                                    <div class="checkFieldDiv checkbox">

                                    </div>
                                </c:when>
                            </c:choose>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </div>
    </div>
</div>
<div class="right-side">
    <header class="head">
        <span>工单信息</span>
    </header>
    <div class="right-content" style="padding:0 7px;">
        <div class="container-fluid top-info" style="padding:10px 15px;">
            <div class="row">
                <div class="col-sm-4">
                    <label class="col-sm-5 text-right">工单电话：</label>
                    <span class="read-only">${callPhone}</span>
                <span id="fa-telphone" style="position: absolute;margin-top:-13px;">
                  <a class="btn btn-xs btn-primary" onclick="callout('${callPhone}')"><i class="fa fa-phone"></i></a>
                </span>
                </div>
                <div class="col-sm-4">
                    <label class="col-sm-6">来电归属地：</label>
                    <span class="read-only">${callArea}</span>
                </div>
            </div>
        </div>
        <div class="main-info container-fluid">
            <div class="form-horizontal row">
                <div class="form-group col-sm-4">
                    <input id="customId" type="hidden">
                    <label for="orderTpl" class="control-label col-sm-6">工单模板：</label>
                    <div class="col-sm-6">
                        <select id="orderTpl" name="orderTpl" class="form-control" onchange="chooseOrderTpl(this.value)"></select>
                    </div>
                </div>
            </div>
            <div id="fieldList" class="row form-horizontal">
                <div id="pushTitle" class="publish-title"></div>
                <div class="form-group">
                    <label for="orderBig" class="control-label col-sm-2">工单大类：</label>
                    <div class="col-sm-4">
                        <input type="text" class="form-control" id="orderBig" >
                    </div>
                </div>
            </div>
            <%@include file="content.jsp" %>
        </div>
    </div>
</div>

<div id="bottom-bar" class="show" >
    <div class="form-inline service-box" id="serviceBox">
        <label>
            <input type="checkbox" id="distributeBtn"> 分配给
        </label>
        <select id="serviceGroup" name="serviceGroupName" class="form-control" disabled></select>
        <select id="customService" name="customServiceName" class="form-control" disabled>
               <option value="" disabled selected hidden>-- 选择受理人 --</option>
        </select>
    </div>
    <div class="btn-group dropup btn-box" id="lidiv">
        <button id="submitFun" data-href="0" type="button" class="btn btn-raised btn-danger" >创建为<span id="submitStr">尚未受理</span></button>
        <button id = "buttonSmall" type="button" class="btn btn-raised btn-danger dropdown-toggle border-le" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" >
            <span class="caret"></span>
            <span class="sr-only">Toggle Dropdown</span>
        </button>
        <ul class="dropdown-menu" >
            <li class="dropdown-header">创建新工单</li>
            <li role="separator" class="divider"></li>
            <li><a data-href="1">创建为<span class="status status1">受理中</span></a></li>
            <li><a data-href="2">创建为<span class="status status2">等待回复</span></a></li>
            <li><a data-href="3">创建为<span class="status status3">已解决</span></a></li>
            <li><a data-href="4">创建为<span class="status status4">待回访</span></a></li>
        </ul>
    </div>
</div>

<script>
    //接收自定义字段的key值
    var field=[];
    /* 接收自定义字段的key对应的type */
    var fieldType={};
    // 所有字段信息
    var fieldInfoList = [];
    // 省市区字段key
    var areaFieldKeys=[];
    /* 自定义字段格式校验 */
    var check_bool = {};
    $(function() {
    	/*初始化基本验证器*/
    	 window.BaseValidate = function(){
    		      return {
    		    	  /*验证是否是电话号码*/
    		    	   isPhone:function(num){
    		               return (/^91|901|1[3|4|5|7|8]\d{9}$/.test($.trim(num)));
    		    	   },
    			  /*验证是否是固话*/
    			   isTel:function(num){
    		          return (/^(([0\+]\d{2,3}-)?(0\d{2,3})-)(\d{7,8})(-(\d{3,}))?$/.test($.trim(num))); 
    			   }
    		       }
    		    }();
        setOrderTpl();
        $("#customId").val("${customId}");

        
        if("${user.userType}"=="1"){
            $("#typeSelect").text("客户");
        }else if("${user.userType}"=="2"){
            $("#typeSelect").text("客服");
        }else if("${user.userType}"=="3"){
            $("#typeSelect").text("管理员");
        }

        if("${user.userType}"=="2"){
            var parentId="${user.userType}";
            $.post("<%=request.getContextPath()%>/usrManage/secondLevel?parentId="+parentId, secondLevelCallBack, 'json');
        }
        else{
            $("#roleSelect").css("display","none");
        }

        if("${user.userType}"!="1"){
            var userId="${user.userId}";
            var loginName="${user.loginName}";
            $("#nikAndSign").css("display","block");
            $("#groupName1").css("display","block");
            //查询所属客服组
            $.post("<%=request.getContextPath()%>/usrManage/belongGroup?userId="+userId+"&loginName="+loginName, belongGroupCallBack, 'json');
        }
        else{
            $("#nikAndSign").css("display","none");
            $("#groupName1").css("display","none");
        }

        var $userStatus = $("#userStatus");
        if("${user.userStatus}"=="9") { // 如果用户已被删除
            $userStatus.removeClass().addClass("status red").html("已删除");
            $('#userPic').on('click', function() {
                notice.warning('该用户已被删除，无法查看用户详情!');
            });
        } else { // 没被删除的用户
            $('#userPic').on('click', goUserDetail);
            if("${user.userStatus}"=="1"){
                $userStatus.removeClass().addClass("status green").html("正常");
            }
            else if("${user.userStatus}"=="2"){
                $userStatus.removeClass().addClass("status red").html("暂停");
            }
            else if("${user.userStatus}"=="3"){
                $userStatus.removeClass().addClass("status blue").html("未审核");
            }
        }


        $('#distributeBtn').on('change', function() {
            // 如果选中
            if($(this).prop('checked') === true) {
                $('#serviceGroup').prop('disabled', false);
                // 如果客服已经选过了，则可操作
                if($('#customService').val() !== "" && $('#customService').val() != null) {
                    $('#customService').prop('disabled', false);
                }
            } else {
                // 如果取消选中
                // 所有选项框都不可操作
                //默认选中第一个
                $('#serviceGroup').prop('selectedIndex', 0);
                $('#customService').prop('selectedIndex', 0);
                
                $('#serviceBox select').prop('disabled', true);
            }
        });

        $('#customService').on('change',function(){
        	if($.trim($('#customService').find("option:selected").text()) == ""){
        		$('#customService').prop('selectedIndex', 0);
        	}
        });
        $('#serviceGroup').on('change', function() {
            $.ajax({
                url:"<%=request.getContextPath()%>/userApi/queryGroupAgent",
                type:"post",
                dataType:"json",
                data: {groupId: $(this).val(), entId: "${entId}"},
                success : function(data){
                    var serviceList = data.rows[0].agentList,
                        html = '<option value="" disabled selected hidden>-- 选择受理人--</option>';

                    if(serviceList) {
                        for(var i = 0, len = serviceList.length; i < len; i++) {
                            html += '<option value="' + serviceList[i].userId +'">' + serviceList[i].userName +'</option>';
                        }
                    }
                    
                    // 清空客服下拉框，并添加新的数据
                    // 让客服选项框变为可选
                    $('#customService').empty().append(html).prop('disabled', false);
                }
            });
        });

        $("#bottom-bar .dropdown-menu li a").on("click",function(){
            var spanStyleText = [{style:'status status0',text:'尚未处理'},{style:'status status1',text:'受理中'},{style:'status status2',text:'等待回复'},{style:'status status3',text:'已解决'},{style:'status status4',text:'待回访'}];
            var $submitFun = $("#submitFun");
            var $this = $(this);
            var thisHref = $this.attr("data-href");
            var submitHref = $submitFun.attr("data-href");
            var thisStyleText = spanStyleText[parseInt(submitHref)];
            $submitFun.attr("data-href",thisHref).find("span").text(spanStyleText[parseInt(thisHref)].text);
            $this.attr("data-href",submitHref).find("span").text(thisStyleText.text).attr("class",thisStyleText.style);
            $("#lidiv").removeClass("open");
            submit(thisHref);
        });

        $("#submitFun").click(function(){
            submit($(this).attr("data-href"));
        });
        
        
        if($("#phone").val()){
        	$("#fa-telphone").css("display","inline-block");
        }
        if($("#fixedPhone").val()){
        	$("#fa-fixedPhone").css("display","inline-block");
        }
        
    });

    /* 工单模板下拉框 */
    function setOrderTpl(){
        $.ajax({
           url:"http://<%=request.getServerName()%>:"+parent.workBasePath+"/workorder/queryTemplate?sessionKey="+ $.cookie("sessionKey"),
           // url:"http://<%=request.getServerName()%>:8090/workorder/workorder/queryTemplate?sessionKey="+ $.cookie("sessionKey"),
            type:"post",
            dataType:"jsonp",
            data: "",
            success : function(data){
                if(data.success){
                    var sub = data.rows,
                        $orderTpl = $("#orderTpl");
                    // 添加选项
                    for(var i = 0, len = sub.length; i < len; i++){
                        $orderTpl.append('<option value="' + sub[i].tempId + '">' + sub[i].tempName + '</option>');
                    }
                    //默认选中第一条数据
                    $orderTpl.prop('selectedIndex', 0);
                    //加载第一个模板
                    chooseOrderTpl($orderTpl.val());
                }
            }
        });
    }

    /*
     * @author Lesty
     * @codeDate 2016.6.9
     * @desc [根据选择的模板id切换模板列表]
     * */
    function chooseOrderTpl(tempId) {
        if (tempId != null && tempId !== "") {
            $.ajax({
               url:"http://<%=request.getServerName()%>:"+parent.workBasePath+"/workorder/queryTemplateField?sessionKey="+ $.cookie("sessionKey"),
                type:"post",
                dataType:"jsonp",
                data: {tempId: tempId},
                success : function(data){
                    if(data.success){
                        orderForm.render(data.rows);
                    }
                }
            });
        }
    }

    function getOrderTitle(){
 		var title="${user.userName}_${user.telPhone}";
   		return title;		
    }
    /**
     * 工单表单
     */
    var orderForm = function(){
        var $form = $('#fieldList');
        var _createFormGroup = function(nodeType,attrs,label,options){
            var $group = $('<div class="form-group col-sm-4"></div>'),
                $e,
                $label = $('<label class="control-label col-sm-6">'+label+'：</label>'),
                inputWidth = 'col-sm-6';
            if(nodeType == 'INPUT'){
                $e = $('<input class="form-control"/>');
            }
            else if(nodeType == 'SELECT'){
                $e = $('<select class="form-control"></select>');
                if(options){
                    for(var i in options){
                        $e.append('<option value="' + options[i].value + '">' + options[i].text + '</option>');
                    }
                }
            }
            else if(nodeType == 'TEXTAREA'){
                $group.removeClass('col-sm-4').addClass('col-sm-12').attr('data-comp-type', 'textarea');
                $label.removeClass('col-sm-6').addClass('col-sm-2');
                $e = $('<textarea class="form-control"></textarea>');
                $group.append($e);
                inputWidth = 'col-sm-10';
            }
            else if(nodeType == 'CHECKBOX'){
                $e = $('<div class="checkbox"></div>');
                if(options){
                    if(options.length > 4) {
                        $group.removeClass('col-sm-4').addClass('col-sm-12');
                        $label.removeClass('col-sm-6').addClass('col-sm-2');
                        inputWidth = "col-sm-10";
                    } else if(options.length > 2) {
                        $group.removeClass('col-sm-4').addClass('col-sm-6');
                        $label.removeClass('col-sm-6').addClass('col-sm-4');
                        inputWidth = "col-sm-8";
                    }
                    for(var i in options){
                        $e.append('<label><input type="checkbox" value="' + options[i].value + '" />'+options[i].text + '</label');
                    }
                }
            }
            if(nodeType != 'CHECKBOX'){
                for(var k in attrs){
                    $e.attr(k,attrs[k]);
                }
               	if(nodeType == "INPUT" && attrs.id == "title"){
           		    $e.attr("placeholder",getOrderTitle());
              	}
            }
            else{
                var $input = $e.find('input');
                for(var j in attrs){
                    $input.attr(j,attrs[j]);
                }
            }
            $group.append($label,$('<div class="'+ inputWidth +'"></div>').append($e));
            return $group;
        };
        /**
         * @author Lesty
         * @codeDate 2016.6.9
         * @desc [根据字段数据创建相应组件]
         * @rowData Object [服务器返回的，包含field数组对象(所有需要显示的字段)和group数组(客服组)对象的数据]
         */
        function createOrderMainInfo(rowData) {
            var $fieldList = $('#fieldList'), // 字段列表元素
                fieldList = rowData.field, // 字段列表数据
                html = '', // 动态添加的html
                tmpField = null,
                tmpKey = '',
                tmpName = '',
                groupList = rowData.group || [],
                i = 0,
                len = 0;
            field=[];
            fieldType={};
            fieldInfoList = fieldList;
            // 初始化表单
            $fieldList.children('.form-group').not("#addressInfo,#pushTitle").remove();

            $('#pushTitle').empty();
            $('#pushContent').hide();

            // 设置所有字段
            for(var j = 0, fLen = fieldList.length; j < fLen; j++) {
                html = '';
                tmpField = fieldList[j];
                tmpKey   = tmpField.key;
                tmpName  = tmpField.name;
                var type = tmpField.componentType;
                var validateAttr = {};
                if(tmpField.isRequired){
                    validateAttr.required = true;
                    tmpName += '<span style="color: red">*</span>';
                }

                //根据字段的不同类型，展示不同控件
                if(type === '1') { // 文本框
                    if(tmpKey === "title") {
                        validateAttr.required = false;
                        var _$t = _createFormGroup('INPUT',$.extend(validateAttr,{id:tmpKey,name:tmpKey, type:'text'}),tmpName);
                        _$t.removeClass('col-sm-4').addClass('col-sm-12');
                        _$t.find('label.col-sm-6').removeClass('col-sm-6').addClass('col-sm-2');
                        _$t.find('div.col-sm-6');
                        $('#pushTitle').append(_$t);
                        continue;
                    } else {
                        html = _createFormGroup('INPUT',$.extend(validateAttr,{name:tmpKey,id:tmpKey}),tmpName);
                    }
                }
                else if(type === '2') { // 文本区域textarea
                    if(tmpKey !== 'queDesc') {
                        validateAttr.required = true;
                        html = _createFormGroup('TEXTAREA',$.extend(validateAttr,{name:tmpKey}),tmpName);
                    }
                    else {
                        $('#pushContent').show();
                        continue;
                    }
                }
                else if(type === '3') { // 下拉菜单select
                	 var options = [];
                	 //工单优先级
                	 if(tmpKey === "priority") {
                		 options.push({value:"1",text:"低"});
                		 options.push({value:"2",text:"中"});
                		 options.push({value:"3",text:"高"});
                		 options.push({value:"4",text:"紧急"});
                	 } else {
                         options.push({value: '', text: ' - '});
                         for(i = 0, len = tmpField.candidateValue.length; i < len; i++) {
                             options.push({value:tmpField.candidateValue[i],text:tmpField.candidateValue[i]});
                         }
                	 }
                    
                    html = _createFormGroup('SELECT',$.extend(validateAttr,{name:tmpKey,id:tmpKey}),tmpName,options);
                }
                else if(type === '4') { // 复选框 checkbox
                    var op = [];
                    for(i=0, len = tmpField.candidateValue.length;i<len;i++){
                        op.push({value:fieldList[j].candidateValue[i],text:fieldList[j].candidateValue[i]});
                    }
                    html = _createFormGroup('CHECKBOX',$.extend(validateAttr,{name:tmpKey}),tmpName,op);
                }
                else if(type === '5') { // 单选框 radio
                    continue;
                }
                else if(type === '6') { // 数字 number
                    validateAttr.role = 'number';
                    html = _createFormGroup('INPUT',$.extend(validateAttr,{name:tmpKey,id:tmpKey,"data-name":tmpKey,"data-field":tmpName,role:'number'}),tmpName);
                }
                else if(type === '7') { // 小数 float
                    validateAttr.role = 'number';
                    html = _createFormGroup('INPUT',$.extend(validateAttr,{name:tmpKey,id:tmpKey,"data-name":tmpKey,"data-field":tmpName,role:'number'}),tmpName);
                }
                else if(type === '8') { // 正则表达式匹配
                    validateAttr.role = 'text';
                    tmpField.candidateValue && tmpField.candidateValue.length && (validateAttr.pattern = tmpField.candidateValue[0]);
                    html = _createFormGroup('INPUT',$.extend(validateAttr,{name:tmpKey,id:tmpKey,"data-name":tmpKey,"data-field":tmpName,"data-type":fieldList[j].componentType}),tmpName);
                }
                else if(type === '9') { // 电话号码
                    validateAttr.role = 'tel';
                    html = _createFormGroup('INPUT',$.extend(validateAttr,{name:tmpKey,id:tmpKey,"data-name":tmpKey,"data-field":tmpName}),tmpName);
                }
                else if(type === '10') { // 时间输入框
                    html = $('<input />').attr('name',tmpKey).attr('id',tmpKey).attr('role', 'timeInput').data('name',tmpKey).data('label',tmpName + "：").prop('required', tmpField.isRequired);
                    tmpField.candidateValue && tmpField.candidateValue.length && html.data('format',tmpField.candidateValue[0]);
                }
                else if(type === '11') { // 省市区
                    html = '<div class="form-group col-sm-12">' +
                        '<label class="control-label col-sm-2">' + tmpName + ' : </label>' +
                        '<div class="col-sm-2">' +
                            '<select class="form-control" name="province_' + tmpKey + '" id="Company_province" + tmpKey></select>' +
                        '</div>' +
                        '<div class="col-sm-2">' +
                            '<select class="form-control" name="city_' + tmpKey + '" id="Company_city" + tmpKey></select>' +
                        '</div>' +
                        '<div class="col-sm-2">' +
                            '<select class="form-control" name="area_' + tmpKey + '" id="Company_area" + tmpKey></select>' +
                        '</div>' +
                        '<input type="hidden" name="' + tmpKey + '" id="' + tmpKey + '" data-name='+tmpKey+' data-field="'+tmpKey+'"/>' +
                    '</div>';
                    areaFieldKeys.push(tmpKey);
                }
                field.push(tmpKey);
                fieldType[tmpKey]=fieldList[j].componentType;
                $fieldList.append(html);
                if(type === '10'){
                    var $input = html.timeInput({
                        format:html.data('format')
                    });
                    var $inputGroup = html.closest('.form-group').addClass('col-sm-6');
//                    $inputGroup.find('label.col-sm-4').removeClass('col-sm-4').addClass('col-sm-6');
//                    $inputGroup.find('div.col-sm-8').removeClass('col-sm-8').addClass('col-sm-6');
                } else if (type === '11') {
                	new PCAS("province_" + tmpKey,"city_" + tmpKey,"area_" + tmpKey);
                    if(validateAttr.required){
                        $fieldList.find('#Company_province' + tmpKey + ',#Company_city' + tmpKey + ',#Company_area' + tmpKey).attr('required',true);
                    }
                }
            }

            // 设置客服组
            html = '<option value="" disabled selected hidden>-- 选择受理组 --</option>';
            for(i = 0, len = groupList.length; i < len; i++) {
                    html += '<option value="' + groupList[i].groupId +'">' + groupList[i].groupName +'</option>';
               }
            
            $('#serviceGroup').empty().append(html);
        }

        var _validator;
        var _createValidator = function(){
            return $form.validator({
                validateOnBlur:false
            });
        };

        var _formValue = function(){
        	$title = $("#title");
        	if(!$title.val()){
        		/**
        		$orderValue = $("#orderTpl").find("option:selected").text();
        		if(!$orderValue){
        			$orderValue = $("#orderTpl option").eq(0).text();
        		}
        		if(!$orderValue){
        			$orderValue = "未知工单标题";
        		}
        		 $title.val($("#orderTpl").find("option:selected").text());
        		 */
        		 var title=getOrderTitle();
        		 if(!title){
        			 title = "未知工单标题";
        		 }
        		 $title.val(title);
        	}
            return $form.formValue();
        };

        return {
            render:function(data){
            	areaFieldKeys = [];
                createOrderMainInfo(data);
                _validator = _createValidator();

                $('#fieldList > div.form-group').not('[data-comp-type=textarea]').css({
                    height: '48px'
                });

                $('#fieldList > div[data-comp-type=textarea]').css({
                    height: '96px'
                });
            },
            validate:function(){
                var editor = $.trim($("<p>" + $("#editor").code() + "</p>").text());
                if(editor.length){ // 如果问题描述不为空
                    // 隐藏问题描述错误提示框
                    $('#contentGroup').removeClass('has-error').find('.help-block').hide();
                    // 验证省市区
                    for (var i = 0; i < fieldInfoList.length; i++) {
                        var fieldInfo = fieldInfoList[i];
                        if (fieldInfo.componentType == "11") {
                            if (fieldInfo.isRequired) {
                                var key = fieldInfo.key;
                                var p = $("select[name=province_" + key + "]").val();
                                var c = $("select[name=city_" + key + "]").val();
                                var a = $("select[name=area_" + key + "]").val();
                                if (p == "") {
                                    notice.warning(fieldInfo.name + ' 省不能为空!');
                                    return false;
                                }
                                if (c == "") {
                                    notice.warning(fieldInfo.name + ' 市不能为空!');
                                    return false;
                                }
                                if (a == "") {
                                    notice.warning(fieldInfo.name + ' 区不能为空!');
                                    return false;
                                }
                            }
                        } else if(fieldInfo.componentType == '4') { // cri中对复选框的validator与bootstrap冲突，需要特殊判断
                            if (fieldInfo.isRequired) {
                                if(!$('#fieldList').find('input[name=' + fieldInfo.key +']').is(':checked')) {
                                    notice.warning(fieldInfo.name + ' 不能为空!');
                                    return false;
                                }
                            }
                        } else if(!_validator.validate($('#' + fieldInfo.key))){
                            $('#' + fieldInfo.key).focus();
                            notice.warning('工单信息未填写完善，请检查-。-');
                            return false;
                        }
                    }

                    return true;
                }
                else{ // 问题描述为空的时候
                    $('#contentGroup').addClass('has-error').find('.help-block').show();
                    notice.warning('问题描述不能为空!');
                    $('.note-editable.panel-body').focus();
                    return false;
                }
            },
            getValue:function(){
                var param = _formValue();
                param.queDesc = $.trim($($("#editor").code()).text());
                for (var i = 0; i < areaFieldKeys.length; i++) {
                	var key = areaFieldKeys[i];
                	var area = $("select[name=province_" + key + "]").val() + ","
        			+ $("select[name=city_" + key + "]").val() + "," + $("select[name=area_" + key + "]").val();
                	param[key] = area;
                }

                // 获取所有checkbox的值
                var test = {};
                $("#fieldList input[type=checkbox]").each(function () {
                    test[this.name] || (test[this.name] = []);
                    if ($(this).prop('checked')) {
                        test[this.name].push($(this).attr('value'));
                    }
                });

                // 将参数合并到param中
                $.extend(param, test);

                return param;
            }
        };
    }();

    /**
     * 提交数据
     */
    function submit(type){
    	if(type=="4"){
    		type="5";//这里的4就是待回访工单，即5
    	}
        var customServiceName = $("#customService").val();
        var $body = $("body");

        if(!orderForm.validate()){
            return;
        }

        if(type == "3" && !customServiceName){
            notice.warning('<p>当工单状态为已解决时受理人不能为空</p>');
            return;
        }

        if($body.data("status")=="1"){
            return;
        }
        $body.data("status","1");

        //判断是否有受理客服
        if(type == "0" && customServiceName){
            setSubmitAttr("1","受理中");
        }

        if($("#orderTpl").val() == "") {
            notice.warning('检测不到当前工单模板类别');
            return;
        }

        var param = $.extend(orderForm.getValue(),{
            sessionId:'${sessionId}',
            ccodEntId:'${ccodEntId}',
            ccodAgentId:'${ccodAgentId}',
            creatorEmail : '${user.email}',

            //企业ID
            entId : "${entId}",
            //创建ID
            creatorId : "${userId}",
            //创建人名称
            creatorName : "${userName}",
            //工单来源
            source : "${source}",
    		//优先级
			priority : $("#priority").val(),
            //是否为座席操作（1：是，0：否）
            isAgent : "1",
            /* isPublicReply:isPublicReply+"", */
            //获取上传的附件
            attachment:getAttachments(),
            //工单状态
            status : type,
            /* 客户的Id */
            customId : $("#customId").val(),
            /* 客户的Name */
            customName : "${customName}",
            customPhone : "${customPhone}",
            callArea : "${callArea}",
            workPhone : "${callPhone}",
            /* 模板Id */
            tempId : $("#orderTpl").val(),
            /* 模板名 */
            tempName : $("#orderTpl").find("option:selected").text(),

            //客服组ID及名称
            serviceGroupId : $("#serviceGroup").val(),
            serviceGroupName : ($("#serviceGroup").find('option:selected').val() === '') ? "" : $("#serviceGroup").find("option:selected").text(),

            //受理客服ID及名称
            customServiceId : $("#customService").val(),
            customServiceName : ($("#customService").find('option:selected').val() === '') ? "" : $("#customService").find("option:selected").text(),
        });

        /* 根据提交的工单类型添加相应的参数 */
        if(type=="1"){
        	param["assignId"]="${userId}";      	
        	param["assignName"]="${userName}";
        }else if(type=="3"){
         	param["solveId"]="${userId}";      	
        	param["solveName"]="${userName}";
        }else if(type=="4"){
         	param["closeId"]="${userId}";      	
        	param["closeName"]="${userName}";
        }
        console.log('[CDesk] 提交工单,req=' + JSON.stringify(param));
        $('#lidiv').css('pointer-events','none');
        $.ajax({
            url : "http://<%=request.getServerName()%>:"+parent.workBasePath+"/workorder/webcreate?sessionKey="+ $.cookie("sessionKey"),
            // url : "http://<%=request.getServerName()%>:8090/workorder/workorder/webcreate?sessionKey="+ $.cookie("sessionKey"),
            type : "post",
            dataType : 'jsonp',
            data:{info:encodeURI(JSON.stringify(param))},
            success:function(data) {
                $body.data("status","0");
                if(data.success) {
                    notice.alert(" 工单数据提交成功！");
                    $("#copyMailAddr").val("");
                    $("#title").val("");
                    $("#editor").code("<p><br></p>");
                    $('#distributeBtn').prop('checked',false),
                    $('#serviceGroup').prop('selectedIndex', 0);
                    $('#customService').prop('selectedIndex', 0);
                    $("#my-dropzone").empty().append("<div class='dz-default dz-message'><span>点击此处进行上传</span></div>");
                    $("#fileGroup").empty();

                    //由IM窗口创建工单并成功后，需要回调IMRefreshOrderList函数刷新工单列表视图
                    console.log('[cdesk] 回调刷新工单列表函数,userId:'+param.customId);
                    parent.IMRefreshOrderFunc(param.customId);

                    var customId=param.customId;
                    var url = "<%=request.getContextPath()%>/order/detail?workId=" + data.rows.workId+"&customId="+customId;
                    var title = "#" + data.rows.workId + "-" + data.rows.title;
                    
                    // 标记为要关闭的页面
                    parent.toBeCloseTab();
                    parent.openTab(url,"order",title,false);
                  
                    //location.reload();
                    //$('#lidiv').css('pointer-events','auto');
                    
                    // 关闭被标记页面
                    parent.closeBeCloseTab();
                }
                else {
                    notice.danger("工单数据提交失败:"+data.msg);
                    $('#lidiv').css('pointer-events','auto');
                }
            }
        });
    }

    //设置提交按钮的显示值和调用方法
    function setSubmitAttr(status, statusStr) {
        var spanStyleText = [{style:'status status0',text:'尚未受理'},{style:'status status1',text:'受理中'},{style:'status status2',text:'等待回复'},{style:'status status3',text:'已解决'},{style:'status status4',text:'待回访'}],
            $s            = $("#submitFun"),
            submitH       = $s.attr("data-href");

        if(submitH != status){
            var $a = $s.siblings('ul').find('a[data-href='+status+']');
            var thisStyleText = spanStyleText[parseInt(submitH)];
            $a.attr("data-href",submitH).find("span").text(thisStyleText.text).attr("class",thisStyleText.style);
            $s.attr("data-href",status).find("span").text(statusStr);
        }
    }

    /* 自定义字段输入内容展开或收起 */
    function openOrClose(){
        var $userFieldUl = $("#userFieldUl");
        var $button = $("#openOrClose");
        if($userFieldUl.is(':visible')){
            $button.text('展开');
            $userFieldUl.slideUp();
        }
        else{
            $button.text('收起');
            $userFieldUl.slideDown();
        }
    }

    /* 所属客服组回调函数 */
    function belongGroupCallBack(data){
        var spanHtml="";
        if(data.rows.length!=0){
            for(var i=0;i<data.rows.length;i++){
                spanHtml+="<span>"+data.rows[i].groupName+"</span>";
            }
        }
        $("#groupName1").empty().append(spanHtml);
    }

    function chooseWfStatus(){
        var status = $("#wfStatus>option:selected").val();
        var statusStr = $("#wfStatus>option:selected").text();
        setSubmitAttr(status, statusStr);
    }
    
    /*电话外呼功能 */
    function callout(tel){
    	var value = $.trim(tel.replace(/^[^0-9]*/ig,""));
        if(!Tools.phoneCheck(value)) {
            notice.warning("外呼号码不合法，请检查电话号码!");
            return;
        }

        parent.callOut(value);
    }
    /* 二级下拉框回调函数 */
    function secondLevelCallBack(data) {
        if (data.success) {
            $("#roleSelect").css("display", "block");
            var $secondType = $("#secondType");
            for (var j = 0; j < data.rows.length; j++) {
                var sub = data.rows[j];
                if ("${user.roleId}" == sub.id) {
                    $secondType.text(sub.name);
                }
            }
        } else {
            notice.danger(data.msg);
        }
    }
    
    //跳转到用户详情页面
    function goUserDetail(){
    	var userId = "${user.userId}";
    	var userName = "${user.userName}";
    	if(userId){
      	  var url="<%=request.getContextPath()%>/userManageMongo/userDetails?userId="+userId + '&t=' + new Date();
          parent.openTab(url,"user",userName,false);
    	}
    }
</script>
</body>
</html>