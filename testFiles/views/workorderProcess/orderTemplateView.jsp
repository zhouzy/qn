<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>工单流程管理详情</title>
    <%@include file="/views/include/pageHeader.jsp"%>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/static/css/innerFrame.css">
</head>
<body  class="container-fluid" style="overflow-x: hidden;">
    <ul class="breadcrumbs">
        <li><a href="<%=request.getContextPath()%>/workProcess/manager" target="_self">工单流程管理</a></li>
        <li>编辑:[${tempName}]</li>
    </ul>
    <div class="panel" style="padding:20px 10px;">
        <h5>流程名称：${tempName}</h5>
        <div style="padding-top: 10px;">
            <!-- 流程列表 -->
            <ul class="list-group" id="processList"></ul>
        </div>

        <div class="text-right">
            <button id="cancelBtn" class="btn btn-sm btn-raised">取消</button>
            <button id="submitBtn" class="btn btn-sm btn-raised btn-primary" style="margin-right:30px;">提交</button>
        </div>
    </div>
    <script id="process-list" type="text/x-handlebars-template">
        <li class="list-group-item" id="{{key}}" data-name="{{name}}" data-type="{{type}}" style="height: auto;">
            <div class="row">
                <span class="col-xs-12">{{name}}：</span>
            </div>
            <div class="row">
                <div class="col-md-4 " style="text-align: right;">是否生成工单：
                    <div class="radio radio-primary">
                        <label>
                            <input class="createOrder" name="createOrder{{key}}" value="1" {{createOrderCheckedYes}} type="radio">
                            是
                        </label>
                    </div>
                    <div class="radio radio-primary">
                        <label>
                            <input class="createOrder" name="createOrder{{key}}" value="0" {{createOrderCheckedNo}} type="radio">
                            否
                        </label>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-md-4" style="text-align: right;">是否自动分配：
                    <div class="radio radio-primary">
                        <label>
                            <input class="autoDistribute" name="autoDistribute{{key}}" value="1" {{autoDistributeCheckedYes}} type="radio">
                            是
                        </label>
                    </div>
                    <div class="radio radio-primary">
                        <label>
                            <input class="autoDistribute" name="autoDistribute{{key}}" {{autoDistributeCheckedNo}} value="0" type="radio">
                            否
                        </label>
                    </div>
                </div>
                <div class="col-md-4">
                    <label for="serviceGroup{{key}}" class="col-md-4 control-label">受理组:</label>

                    <div class="col-md-8">
                        <select id="serviceGroup{{key}}" name="serviceGroup" class="form-control" {{serviceDisabled}}>
                            <option value="">-- 选择受理组 --</option>
                        </select>
                    </div>
                </div>
                <div class="col-md-4">
                    <label for="customService{{key}}" class="col-md-4 control-label">受理人:</label>

                    <div class="col-md-8">
                        <select id="customService{{key}}" name="customService" class="form-control" {{serviceDisabled}}>
                            <option value="">-- 选择受理人 --</option>
                        </select>
                    </div>
                </div>
            </div>
        </li>
    </script>
</body>
<script type="text/javascript">
    /**
     * @desc 工单流程管理-流程列表页面
     * @author Lesty
     * @codeDate 2016.11.10
     */    
    $(function () {
        orderForm.render();
    });

    /**
     * 工单流表单
     */
    var orderForm = (function () {
        // 归属客服组对应归属客服map
        var SERVICE_NAME = {};
        // 归属客服组对应option的html
        var SG_OPTIONS_HTML = '<option value="" selected>-- 选择受理组 --</option>';

        // 渲染表单
        function render() {
            serviceGroupInit();
        }
        /**
         * @author Lesty
         * @codeDate 2016.11.10
         * @desc [创建流程列表]
         */
        var createProcessList = (function() {
            var processListTpl = Handlebars.compile($("#process-list").html());
            var $processList = $('#processList');

            return function(rowData) {
                // 流程列表信息
                var processList = rowData.fieldInfo[0] && rowData.fieldInfo[0].list;
                var html = [];
                var $li = null;
                var tempData = null;

                //填充其它数据
                for (var i = 0, len = processList.length; i < len; i++) {
                    // 拼装临时数据
                    tempData = processList[i];
                    // 判断是否生成工单
                    if(tempData.isCreatorder === '0') { // 否
                        tempData.createOrderCheckedYes = '';
                        tempData.createOrderCheckedNo = 'checked';
                    } else { // 是
                        tempData.createOrderCheckedYes = 'checked';
                        tempData.createOrderCheckedNo = '';
                    }

                    // 判断是否自动分配客服组
                    if(tempData.isAutoDistribute === '0') { // 否
                        tempData.autoDistributeCheckedYes = '';
                        tempData.autoDistributeCheckedNo = 'checked';

                        tempData.serviceDisabled = 'disabled';
                    } else { // 是
                        tempData.autoDistributeCheckedYes = 'checked';
                        tempData.autoDistributeCheckedNo = '';

                        tempData.serviceDisabled = '';
                    }

                    $li = $(processListTpl(tempData));
                    // 生成受理客服组并赋值
                    $li.find('select[name=serviceGroup]').html(SG_OPTIONS_HTML).val(tempData.customerGroupId);
                    // 生成受理客服并赋值
                    createCustomService($li.find('select[name=serviceGroup]'), $li.find('select[name=customService]'), tempData.customerId);
                    // 添加一条数据
                    html.push($li);
                }

                $processList.html(html);
                // 注册事件
                regEvent();

                // 根据是否生成工单做出相应样式控制(disabled)
                $processList.find('.list-group-item').each(function() {
                    var $createOrderNot = $(this).find('.createOrder:eq(1)');
                    // 如果不生成工单
                    if($createOrderNot.prop('checked') === true) {
                        $createOrderNot.click();
                    }
                });
            };
        })();

        /**
         * @desc 初始化受理客服组
         */
        function serviceGroupInit() {
            // 参数rows为-1时，获取全部，而不分页
            $.post('<%=request.getContextPath()%>/groupMongo/getAgentGroups', {
                rows: -1
            }, function(data) {
                var rows = data.rows;
                var group = null;

                // 获取流程列表
                $.ajax({
                    url: "<%=request.getContextPath()%>/workProcess/query",
                    type: "post",
                    data: {
                        _id: '${_id}'
                    },
                    success: function (data) {
                        if (data.success) {
                            // 创建流程列表
                            data.rows && createProcessList(data.rows);
                        } else {
                            notice.danger(data.msg);
                        }
                    }
                });

                for(var i = 0, len = rows.length; i < len; i++) {
                    group = rows[i];
                    // 缓存全局options的HTML
                    SG_OPTIONS_HTML += '<option value="' + group.groupId + '">' + group.groupName +'</option>';
                    // 缓存数据到全局客服组-客服对象
                    SERVICE_NAME[group.groupId] = group.members;
                }
            });
        }

        // 创建受理坐席
        function createCustomService($serviceGroup, $customService, customServiceId) {
            // 获取相应客服组下的客服列表
            var data = SERVICE_NAME[$serviceGroup.val()] || [];
            var member = null;
            var optionsHtml = '<option value="" selected>-- 选择受理人 --</option>';
            for(var i = 0, len = data.length; i < len; i++) {
                member = data[i];
                // 增加options选项
                optionsHtml += '<option value="' + member.userId + '">' + member.userName +'</option>';
            }

            customServiceId = customServiceId != null ? customServiceId : '';
            $customService.html(optionsHtml).val(customServiceId);
        }

        // 获取表单数据
        function getValue() {
            var formValue = [];
            var $processList = $('#processList');
            var tempObj = null;

            // 遍历工单流程列表
            $processList.find('.list-group-item').each(function() {
                var $_my = $(this);

                tempObj = {
                    isCreatorder: $_my.find('.createOrder:eq(0)').prop('checked') ? '1' : '0',
                    isAutoDistribute: $_my.find('.autoDistribute:eq(0)').prop('checked') ? '1' : '0',
                    type: $_my.attr('data-type'),
                    key: $_my.attr('id'),
                    name: $_my.attr('data-name'),
                    customerGroupId: $_my.find('select[name=serviceGroup]').val(),
                    customerId: $_my.find('select[name=customService]').val()
                };

                formValue.push(tempObj);
            });

            return formValue;
        }

        // 更新表单
        function update() {
            var param = JSON.stringify({
                list: getValue()
            });

            $.post('<%=request.getContextPath()%>/workProcess/update', {
                jsonString: param,
                id: '${_id}',
                tempType:"${tempType}"
            }, function(data) {
                if (data.success) {
                    notice.success("提交成功！");
                    $('#cancelBtn').click();
                } else {
                    notice.danger(data.msg);
                }
            });
        }

        // 注册表单事件
        function regEvent() {
            var $processList = $('#processList');
            // 是否生成工单点击事件
            $processList.find('.createOrder').on('click', function() {
                var $_my = $(this);
                var $listItem = $_my.closest('.list-group-item');
                // 分配工单radio
                var $autoDistributeRadios = $listItem.find('.autoDistribute');

                if($_my.val() === '0') { // 选中否
                    // 分配radio重置为否且不可点击
                    $listItem.find('.autoDistribute:eq(1)').click();
                    $autoDistributeRadios.prop('disabled', true);
                } else {
                    $autoDistributeRadios.prop('disabled', false);
                }
            });

            // 是否自动分配radio点击事件
            $processList.find('.autoDistribute').on('click', function() {
                var $_my = $(this);
                // 受理客服组相关的下拉框
                var serviceSelects = $_my.closest('.list-group-item').find('select.form-control');

                if($_my.val() === '0') { // 选中否
                    serviceSelects.prop('disabled', true);
                } else {
                    serviceSelects.prop('disabled', false);
                }
            });

            // 归属客服组change事件
            $processList.find('select[name=serviceGroup]').on('change', function() {
                // 当前客服组select
                var $serviceGroup = $(this);
                // 当前客服select
                var $customService = $serviceGroup.closest('.list-group-item').find('select[name=customService]');

                createCustomService($serviceGroup, $customService);
            });

            // 提交按钮
            $('#submitBtn').on('click', update);

            // 取消按钮
            $('#cancelBtn').on('click', function() {
                // 跳转页面(点击导航栏倒数第二个)
                var $lis = $('.breadcrumbs > li:nth-last-of-type(2)');
                $lis.children('a')[0].click();
            })
        }

        return {
            render: render
        };
    })();
</script>
</html>