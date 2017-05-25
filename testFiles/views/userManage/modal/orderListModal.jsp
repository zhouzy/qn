<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
        <div class="sub-switch-body" id="sorts">
            <div class="body">
                <div class="sub-switch-menu" id="oStatus">
                    <ul>
                        <li id="allStatus" class="active" data-status="-1"><a id="allStatuss">全部</a></li>
                        <li id="unAccept" style="display:none" data-status="0"><a id="unAccepts">尚未受理</a></li>
                        <li id="accept" style="display:none" data-status="1"><a id="accepts">受理中</a></li>
                        <li id="waitReply" style="display:none" data-status="2"><a id="waitReplys">等待回复</a></li>
                        <li id="resolve" style="display:none" data-status="3"><a id="resolves">已解决</a></li>
                        <li id="close" style="display:none" data-status="4"><a id="closes">已关闭</a></li>
                        <li id="visite" style="display:none" data-status="5"><a id="visites">待回访</a></li>
                    </ul>
                </div>

                <div class="sub-switch-menu" id="oStatus1" style="display:none">
                    <ul>
                        <li id="allStatus1" class="active" data-status="-1"><a id="allStatuss1">全部</a></li>
                        <li id="unAccept1" style="display:none" data-status="0"><a id="unAccepts1">尚未受理</a></li>
                        <li id="accept1" style="display:none" data-status="1"><a id="accepts1">受理中</a></li>
                        <li id="waitReply1" style="display:none" data-status="2"><a id="waitReplys1">等待回复</a></li>
                        <li id="resolve1" style="display:none" data-status="3"><a id="resolves1">已解决</a></li>
                        <li id="close1" style="display:none" data-status="4"><a id="closes1">已关闭</a></li>
                        <li id="visite1" style="display:none" data-status="5"><a id="visites1">待回访</a></li>
                    </ul>
                </div>

                <div class="sub-switch-menu" id="noOrderGrid" style="display: none">
                    <strong style="font-size: 16px;">当前工单空空如也!</strong>
                </div>

                <table class="table footable" cellspacing="0" cellpadding="0" id="orderGrid" data-page-size="10">
                    <thead>
                    <tr class="order">
                        <th data-sort-ignore="true" class="footable-first-column"><input type="checkbox" id="allSelect"></th>
                        <th>编号</th>
                        <th>标题</th>
                        <th>工单发起人</th>
                        <th>创建日期</th>
                        <th>受理组</th>
                        <th>受理人</th>
                        <th>状态</th>
                        <th>工单模板</th>
                    </tr>
                    </thead>
                    <tbody></tbody>
                    <tfoot>
                    <tr>
                        <td colspan="30">
                            <div id="orderPagination"></div>
                        </td>
                    </tr>
                    </tfoot>
                </table>
            </div>
        </div>
<div id="toolbar">
    <button id="deleteBtn" type="button" class="btn btn-raised left-btn btn-danger">删除</button>
    <button id="cancelBtn" type="button" class="btn btn-raised btn-default">清除选择</button>
</div>
<script id="table-tr-template" type="text/x-handlebars-template">
    <tr class="ember-view" data-workId='{{workId}}'>
        <td> <input class="ember-view ember-checkbox table-checkbox" type="checkbox"> </td>
        <td>{{workId}}</td>
        <td class="title"><a>{{title}}</a></td>
        <td>{{creatorName}}</td>
        <td>{{createDate}}</td>
        <td>{{serviceGroupName}}</td>
        <td>{{customServiceName}}</td>
        
        <td><span class="{{#equal status '0'}}status orange{{/equal}}{{#equal status '1'}}status red{{/equal}}{{#equal status '2'}}status blue{{/equal}}{{#equal status '3'}}status green{{/equal}}{{#equal status '4'}}status black{{/equal}}{{#equal status '5'}}status black{{/equal}}">{{statusStr}}</span></td>
		<td>{{tempName}}</td>
    </tr>
</script>

<script id="tooltip-template" type="text/x-handlebars-template">
    <div class="tip-content panel panel-default">
        <div class="tip-header panel-heading">
            <span class="col-12"># {{workId}}</span><span class="tip-order-state">{{statusStr}}</span>
        </div>
        <div class="tip-row panel-body">
            <div class="container-fluid">
                <div class="row">
                    <strong class="col-xs-12" style="font-size: 14px;">工单详情:</strong>
                </div>
                <div class="row">
                    <span class="col-xs-3">标题</span><div class="col-xs-9">{{title}}</div>
                </div>
                <div class="row">
                    <span class="col-xs-3">时间</span><div class="col-xs-9">{{createDate}}</div>
                </div>
                <div class="row">
                    <span class="col-xs-3">发起人</span><div class="col-xs-9">{{customName}}</div>
                </div>
            </div>
            {{#if recentReply}}
                <div class="container-fluid">
                    <div class="row">
                        <strong class="col-xs-12" style="font-size: 14px;">最新回复:</strong>
                    </div>
                    <div class="row">
                        <span class="col-xs-3">内容</span><div class="col-xs-9">{{recentReply.content}}</div>
                    </div>
                    <div class="row">
                        <span class="col-xs-3">回复人</span><div class="col-xs-9">{{recentReply.updatorName}}</div>
                    </div>
                </div>
            {{/if}}
        </div>
    </div>
</script>

<script>
    /*
     * @author Lesty
     * @codeDate 2016.8.8
     * @desc 创建一个全局对象，暴露相应接口，避免全局污染
     * */
    var orderListModal = (function () {
        var orderStatus = "-1";
        var STATUS_ARR = ["尚未受理", "受理中", "等待回复", "已解决", "已关闭", "待回访"];
        var paramCache = {};

        function init() {
            /*
             * 每次都需要初始化的方法放这里
             * */
            if (USER_G.userType == "1") {
                $("#distributionWO").hide();
            }

            getOrderData({
                customId: USER_G.userId,
                userType: USER_G.userType,
                status: orderStatus,
                page: 1,
                rows: 10
            });

            // 获取分配工单总数
            getAssignTotal();

            /*
             * 只需要初始化一次的方法放这里
             * */
            if (typeof arguments.callee.initFlag != 'string') {
                arguments.callee.initFlag = 'init';

                // 注册事件
                regEvent();
            }
        }

        /**
         * 初始化分页
         */
        var pager = new cri.Pager($("#orderPagination"), {
            page: 1,
            pageSize: 10,
            total: 0,
            onPage: function (page, pageSize) {
                $.extend(paramCache, {page: page, rows: pageSize});
                if ($("#workOrders").attr("class") == "active") {
                    getOrderData(paramCache);
                }
                if ($("#distributionWO").attr("class") == "active") {
                    getAssignedOrderData(paramCache);
                }
            }
        });


        /* 获取被分配工单的总数 */
        function getAssignTotal() {
            $.ajax({
                url: "http://<%=request.getServerName()%>:" + parent.workBasePath + "/queryWorkOrderInfo/queryAssignToMe?sessionKey=" + $.cookie("sessionKey"),
                dataType: 'jsonp',
                data: {customServiceId: USER_G.userId, status: orderStatus, page: 1, rows: 10},
                success: function (data) {
                    if (data.success) {
                        $("#distributionWOs").children('span').text(data.total);
                    } else {
                        notice.danger(data.msg);
                    }
                }
            });
        }

        /**
         * 向后台请求数据-工单
         */
        var getOrderData = (function () {
            return function (param) {
                $.ajax({
                    url: "http://<%=request.getServerName()%>:" + parent.workBasePath + "/queryWorkOrderInfo/queryCreatorAllWorkOrder?sessionKey=" + $.cookie("sessionKey"),
                    dataType: 'jsonp',
                    data: param,
                    success: function (data) {
                        if (!data.success) {
                            notice.danger(data.msg);
                            return;
                        }

                        // 全部工单
                        if ($("#allStatus").hasClass("active") === true) {
                            createAllStatusTable(data.rows.list, data.total, data.rows, "");
                        } else { // 其他状态工单
                            createOneStatusTable(data.rows.list);
                        }

                        pager.update(param.page, param.rows, data.total);
                        $.extend(paramCache, param);
                    }
                });
            }
        })();

        /**
         * 向后台请求数据-分配工单
         */
        var getAssignedOrderData = (function () {

            return function (param) {
                $.ajax({
                    url: "http://<%=request.getServerName()%>:" + parent.workBasePath + "/queryWorkOrderInfo/queryAssignToMe?sessionKey=" + $.cookie("sessionKey"),
                    dataType: 'jsonp',
                    data: param,
                    success: function (data) {
                        if (!data.success) {
                            notice.danger(data.msg);
                            return;
                        }

                        // 全部工单
                        if ($("#allStatus1").hasClass("active") === true) {
                            createAllStatusTable(data.rows.list, data.total, data.rows, "1");
                        } else { // 其他状态工单
                            createOneStatusTable(data.rows.list);
                        }

                        pager.update(param.page, param.rows, data.total);
                        $.extend(paramCache, param);
                    }
                });
            }
        })();

        /**
         * 刷新表格-工单
         */
        var createAllStatusTable = (function () {
            var trTemp = Handlebars.compile($("#table-tr-template").html());
            var tooltipTemp = Handlebars.compile($("#tooltip-template").html(), {
                noEscape: true
            });
            // 工单表格
            var $orderTable = $("#orderGrid");
            // 暂无数据表格
            var $noDataTable = $('#noOrderGrid');

            /*
            * @latest Lesty
            * @tableData Array [工单数据]
            * @count Number 工单总数
            * @rows Object [后台返回的rows数据，包含各个状态工单数量以及工单数据]
            * @orderFlag String [大的工单类别标志位，"": 工单，"1": 分配给我的工单]
            * */
            return function (tableData, count, rows, orderFlag) {
                var html = [];
                // 一条工单数据
                var order = null;
                // 状态码
                var status = -1;

                // 尚未受理
                var noAccept = [];
                // 受理中
                var accept = [];
                // 等待回复
                var waitingForCustom = [];
                // 已解决
                var resolve = [];
                // 已关闭
                var close = [];
                // 待回访
                var visite = [];
                // 工单大类标志位
                var flag = typeof orderFlag === "string" ? orderFlag : "";

                // 设置标题
                if(flag === '') {
                    $("#workOrder").children('span').text(count);
                } else if(flag === '1'){
                    $('#distributionWOs').children('span').text(count);
                }

                // 判断数量是否为空
                if (count == "0") {
                    $orderTable.hide();
                    $noDataTable.show();
                } else {
                    $orderTable.show();
                    $noDataTable.hide();
                }

                // 遍历数据
                for (var i = 0, len = tableData.length; i < len; i++) {
                    order = tableData[i];
                    status = parseInt(order.status);

                    // 确定工单状态描述
                    if (!isNaN(status)) {
                        order.statusStr = STATUS_ARR[status];
                    } else {
                        order.statusStr = "-";
                    }

                    /**
                     * 根据工单状态，将数据导入相应数组
                     * @latest Lesty 2017.1.11
                     */
                    if (status === 0) { // 尚未受理
                        noAccept.push(order);
                    } else if (status === 1) { // 受理中
                        accept.push(order);
                    } else if (status === 2) { // 等待回复
                        waitingForCustom.push(order);
                    } else if (status === 3) { // 已解决
                        resolve.push(order);
                    } else if (status === 4) { // 已关闭
                        close.push(order);
                    } else if (status === 5) { // 待回访
                        visite.push(order);
                    }
                }

                /**
                 * 设置大分类标签数量并生成行数据
                 */
                if (rows.noaccept) {
                    $("#unAccepts" + flag).text("尚未受理（" + rows.noaccept + "）");
                    $("#unAccept" + flag).show();
                } else
                    $("#unAccept" + flag).hide();
                if (noAccept.length) {
                    html.push('<tr><th colspan="9">尚未受理</th><tr>');
                }
                createTr(noAccept, trTemp, tooltipTemp, html);

                if (rows.accept) {
                    $("#accepts" + flag).text("受理中（" + rows.accept + "）");
                    $("#accept" + flag).show();
                } else {
                    $("#accept" + flag).hide();
                }
                if (accept.length) {
                    html.push('<tr><th colspan="9">受理中</th><tr>');
                }
                createTr(accept, trTemp, tooltipTemp, html);

                if (rows.waitingforcutom) {
                    $("#waitReplys" + flag).text("等待回复（" + rows.waitingforcutom + "）");
                    $("#waitReply" + flag).show();
                } else
                    $("#waitReply" + flag).hide();
                if (waitingForCustom.length) {
                    html.push('<tr><th colspan="9">等待回复</th><tr>');
                }
                createTr(waitingForCustom, trTemp, tooltipTemp, html);

                if (rows.resolve) {
                    $("#resolves" + flag).text("已解决（" + rows.resolve + "）");
                    $("#resolve" + flag).show();
                } else
                    $("#resolve" + flag).hide();
                if (resolve.length) {
                    html.push('<tr><th colspan="9">已解决</th><tr>');
                }
                createTr(resolve, trTemp, tooltipTemp, html);

                if (rows.close) {
                    $("#closes" + flag).text("已关闭（" + rows.close + "）");
                    $("#close" + flag).show();
                } else
                    $("#close" + flag).hide();
                if (close.length) {
                    html.push('<tr><th colspan="9">已关闭</th><tr>');
                }
                createTr(close, trTemp, tooltipTemp, html);

                // 刘蕊鹏的英语水平666
                // visite后台这么设的，前端只能跟上
                // @latest Lesty 2016.8.8
                if (rows.visite) {
                    $("#visites" + flag).text("待回访（" + rows.visite + "）");
                    $("#visite" + flag).show();
                } else
                    $("#visite" + flag).hide();
                if (visite.length) {
                    html.push('<tr><th colspan="9">待回访</th><tr>');
                }
                createTr(visite, trTemp, tooltipTemp, html);

                $orderTable.find("tbody").html(html);

                $orderTable.find("input[type=checkbox]").change(function () {
                    var $t = $(this).parent();
                    // 获取勾选按钮数量
                    var checkedCount = $orderTable.find('td input[type=checkbox]:checked').length;

                    if ($t.is("th")) { // 点击的是全选按钮
                        $orderTable.find("td input[type=checkbox]").prop("checked", $(this).prop("checked"));
                    } else {
                        if (tableData.length == checkedCount) {
                            $("#allSelect").prop("checked", true);
                        }
                        else {
                            $("#allSelect").prop("checked", false);
                        }
                    }

                    if (checkedCount) {
                        $("#toolbar").addClass("show");
                    }
                    else {
                        $("#toolbar").removeClass("show");
                    }
                });
            };
        })();

        var getSelected = function () {
            var data = [];
            $("#orderGrid").find('td input[type=checkbox]').each(function () {
                if ($(this).prop("checked")) {
                    var workId = $(this).closest("tr").attr("data-workId");
                    data.push(workId);
                }
            });

            return data;
        };

        /* 点击工单分类显示 */
        var createOneStatusTable = (function () {
            var trTemp = Handlebars.compile($("#table-tr-template").html());
            var tooltipTemp = Handlebars.compile($("#tooltip-template").html());
            var $orderTable = $("#orderGrid");

            return function (tableData) {
                var html = [];
                var order = null;
                // 保存有效数据(status合法)
                var ordersArr = [];

                // 遍历工单列表
                for (var i = 0, iLen = tableData.length; i < iLen; i++) {
                    order = tableData[i];

                    if (order.status == orderStatus) {
                        order.statusStr = STATUS_ARR[order.status];
                        ordersArr.push(order);
                    }
                }

                html.push('<tr><th colspan="9">' + ordersArr[0].statusStr + '</th><tr>');
                createTr(ordersArr, trTemp, tooltipTemp, html);

                $orderTable.find("tbody").html(html);

                $orderTable.find("input[type=checkbox]").change(function () {
                    var $t = $(this).parent();
                    // 获取勾选按钮数量
                    var checkedCount = $orderTable.find('td input[type=checkbox]:checked').length;

                    if ($t.is("th")) { // 点击的是全选按钮
                        $orderTable.find("td input[type=checkbox]").prop("checked", $(this).prop("checked"));
                    } else {
                        if (tableData.length == checkedCount) {
                            $("#allSelect").prop("checked", true);
                        }
                        else {
                            $("#allSelect").prop("checked", false);
                        }
                    }

                    if (checkedCount) {
                        $("#toolbar").addClass("show");
                    }
                    else {
                        $("#toolbar").removeClass("show");
                    }
                });
            };
        })();

        /* 根据不同的受理状态归类产生行数据 */
        function createTr(trArray, trTemp, tooltipTemp, html) {
            if (trArray.length != 0) {
                for (var i = 0; i < trArray.length; i++) {
                    var $tr = $(trTemp(trArray[i]));
                    $tr.data("row", i);
                    var $a = $tr.find("a");
                    var $tip = $(tooltipTemp(trArray[i]));

                    switch (trArray[i].status) {
                        case "0":
                            $tip.find(".tip-order-state").addClass("orange");
                            break;
                        case "1":
                            $tip.find(".tip-order-state").addClass("red");
                            break;
                        case "2":
                            $tip.find(".tip-order-state").addClass("blue");
                            break;
                        case "3":
                            $tip.find(".tip-order-state").addClass("green");
                            break;
                        case "4":
                            $tip.find(".tip-order-state").addClass("black");
                            break;
                        case "5":
                            $tip.find(".tip-order-state").addClass("black");
                            break;
                        default:
                            $tip.find(".tip-order-state").addClass("red");
                    }
                    $a.tooltipster({
                        content: $tip,
                        theme: 'tooltipster-shadow'
                    });
                    $a.data("data", trArray[i]);

                    $a.click(function () {
                        var data = $(this).data("data");

                        var url = "<%=request.getContextPath()%>/order/detail?workId=" + data.workId;
                        var title = "#" + data.workId + "-" + data.title;
                        parent.openTab(url, "order", title, false);
                    });
                    if (!$a.text()) {
                        $a.parent().css("cursor", "pointer");
                        $a.parent().click(function () {
                            $(this).find("a").click();
                        });
                    }

                    html.push($tr);
                }
            }
        }

        function goDelete(idStr) {
            var param = {};
            param.deleteId = idStr;

            if (confirm("确定要删除选中的工单？")) {
                $.ajax({
                    url: "http://<%=request.getServerName()%>:" + parent.workBasePath + "/queryWorkOrderInfo/deleteWorkOrder?sessionKey=" + $.cookie("sessionKey"),
                    dataType: 'jsonp',
                    data: param,
                    success: function (data) {
                        if (data.success) {
                            notice.success("工单数据删除成功！");
                            $("#toolbar").removeClass("show");
                            if ($("#workOrders").prop("class") == "active") {
                                $("#workOrders").click();
                            }
                            if ($("#distributionWO").prop("class") == "active") {
                                $("#distributionWO").click();
                            }
                        } else {
                            notice.danger("工单数据删除失败！");
                        }
                    }
                });
            }
        }

        // 事件注册
        function regEvent() {
            var $oStatus = $('#oStatus');
            var $oStatus1 = $('#oStatus1');

            /* 工单分类li */
            $oStatus.on('click', 'li', function() {
                var $_my = $(this);
                $("#allSelect").prop("checked", false);
                $("#toolbar").removeClass("show");

                $oStatus.find('li').removeClass("active");
                $_my.addClass("active");

                orderStatus = $_my.attr('data-status');

                getOrderData({
                    customId: USER_G.userId,
                    userType: USER_G.userType,
                    status: orderStatus,
                    page: 1,
                    rows: 10
                });
                $("#grid").show();
            });

            /* 分配工单分类li */
            $oStatus1.on('click', 'li', function() {
                var $_my = $(this);
                $("#allSelect").prop("checked", false);
                $("#toolbar").removeClass("show");

                $oStatus1.find('li').removeClass("active");
                $_my.addClass("active");

                orderStatus = $_my.attr('data-status');

                getAssignedOrderData({
                    customServiceId: USER_G.userId,
                    status: orderStatus,
                    page: 1,
                    rows: 10
                });
                $("#grid").show();
            });

            /* 分配工单受理状态分类li */
            $("#workOrders, #distributionWO").click(function () {
                //分配工单
                if($(this).is('#distributionWO')){
                    $oStatus.hide();
                    $("#oStatus1").show();
                    $("#allStatus1").click();
                }
                //全部工单
                else{
                    $oStatus.show();
                    $("#oStatus1").hide();
                    $("#allStatus").click();
                }
            });

            $("#orderGrid").find('th input[type=checkbox]').click(function () {
                $("#orderGrid").find('td input[type=checkbox]').prop("checked", $(this).prop("checked"));
            });

            //添加删除按钮事件
            $("#deleteBtn").click(function () {
                goDelete(getSelected().join(","));
            });

            //添加清空按钮事件
            $("#cancelBtn").click(function () {
                $("input[type=checkbox]").prop("checked", false);
                $("#toolbar").removeClass("show");
            });
        }

        return {
            init: init
        };
    })();
 </script>
