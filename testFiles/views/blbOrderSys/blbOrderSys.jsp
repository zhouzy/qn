<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<html>
<head>
    <meta charset="UTF-8">
    <title>订单信息</title>
    <%@include file="/views/include/pageHeader.jsp" %>
    <%@page import="org.apache.commons.lang.StringUtils" %>
    <%@page import="java.util.*" %>
    <%@page import="com.mongodb.DBObject" %>
    <%@page import="com.channelsoft.ems.user.po.DatEntUserPo" %>
    <%@page import="com.channelsoft.ems.communicate.constant.CommSource" %>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/script/lib/summernote/summernote.css">
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/static/css/innerFrame.css">   
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/static/css/blbOrderSys.css">
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/static/css/e3293c2acd190ccbe6c6431b13b34494.css">  
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/script/lib/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.css">
    <script src="<%=request.getContextPath()%>/script/lib/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
    <script src="<%=request.getContextPath()%>/script/lib/bootstrap-datetimepicker-master/js/locales/bootstrap-datetimepicker.zh-CN.js"></script>
    <script src="<%=request.getContextPath()%>/script/lib/summernote/summernote.js"></script>
    <script src="<%=request.getContextPath()%>/script/lib/summernote/summernote-zh-CN.js"></script>
    <script src="<%=request.getContextPath()%>/script/lib/PCASClass.js"></script>
</head>
<body>

<div>
    <div class="panel-body">
        <div class="col-xs-12" style="height: 60px;overflow: hidden;background: #fff;border-bottom:3px solid #eee;margin-bottom:10px;padding-bottom:30px;" id="searchBox">
            <form id="searchForm">
        <div class="row form-horizontal col-xs-12">
            <div class="col-sm-3" style="height: 45px;">
                <input id="dorderdate" class="form-control" type="text" name="dorderdate" data-type="date" data-label="订单日期">
            </div>
            <div class="col-sm-3" style="height: 45px;">
                <div class="form-group"><div class="form-group"><label class="control-label col-sm-4 text-nowrap">SN号</label><div class="col-sm-8"><div class="input-group"><input id="cinvsn" type="text" name="cinvsn" class="form-control"></div></div></div></div>
            </div>
            <div class="col-sm-3" style="height: 45px;">
                <div class="form-group"><div class="form-group"><label class="control-label col-sm-4 text-nowrap">交易编号</label><div class="col-sm-8"><div class="input-group"><input id="ctranh" type="text" name="ctranh" class="form-control"></div></div></div></div>
            </div>
            <div class="col-sm-3" style="height: 45px;">
                <button class="btn btn-xs btn-link" id="moreBtn">更多<i class="fa fa-angle-double-down" aria-hidden="true"></i></button>
                <button class="btn btn-xs btn-raised" id="resetBtn">清空</button>
                <button class="btn btn-xs btn-raised btn-primary" id="searchBtn">查询</button>
            </div>
            <div class="col-sm-3" style="height: 45px;">
                <div class="form-group"><div class="form-group"><label class="control-label col-sm-4 text-nowrap">客户编码</label><div class="col-sm-8"><div class="input-group"><input id="cuscode" type="text" name="cuscode" class="form-control"></div></div></div></div>
            </div>          
            <div class="col-sm-3" style="height: 45px;">
                <div class="form-group"><div class="form-group"><label class="control-label col-sm-4 text-nowrap">客户名称</label><div class="col-sm-8"><div class="input-group"><input id="cusname" type="text" name="cusname" class="form-control"></div></div></div></div>
            </div>
            <div class="col-sm-3" style="height: 45px;">
                <div class="form-group"><div class="form-group"><label class="control-label col-sm-4 text-nowrap">销售订单号</label><div class="col-sm-8"><div class="input-group"><input id="cordercode" type="text" name="cordercode" class="form-control"></div></div></div></div>
            </div>
            <div class="col-sm-3" style="height: 45px;">
                <div class="form-group"><div class="form-group"><label class="control-label col-sm-4 text-nowrap">发货单号</label><div class="col-sm-8"><div class="input-group"><input id="cdispcode" type="text" name="cdispcode" class="form-control"></div></div></div></div>
            </div>
            <div class="col-sm-3" style="height: 45px;">
                <div class="form-group"><div class="form-group"><label class="control-label col-sm-4 text-nowrap">出库单号</label><div class="col-sm-8"><div class="input-group"><input id="cckcode" type="text" name="cckcode" class="form-control"></div></div></div></div>
            </div>          
            <div class="col-sm-3" style="height: 45px;">
                <input id="dckdate" class="form-control" type="text" name="dckdate" data-type="date" data-label="出库日期">
            </div>           
            <div class="col-sm-3" style="height: 45px;">
                <div class="form-group"><div class="form-group"><label class="control-label col-sm-4 text-nowrap">存货编码</label><div class="col-sm-8"><div class="input-group"><input id="cinvcode" type="text" name="cinvcode" class="form-control"></div></div></div></div>
            </div>
            <div class="col-sm-3" style="height: 45px;">
                <div class="form-group"><div class="form-group"><label class="control-label col-sm-4 text-nowrap">存货名称</label><div class="col-sm-8"><div class="input-group"><input id="cinvname" type="text" name="cinvname" class="form-control"></div></div></div></div>
            </div>
            <div class="col-sm-3" style="height: 45px;">
                <div class="form-group"><div class="form-group"><label class="control-label col-sm-4 text-nowrap">规格型号</label><div class="col-sm-8"><div class="input-group"><input id="cinvstd" type="text" name="cinvstd" class="form-control"></div></div></div></div>
            </div>
            <div class="col-sm-3" style="height: 45px;">
                <div class="form-group"><div class="form-group"><label class="control-label col-sm-4 text-nowrap">数量</label><div class="col-sm-8"><div class="input-group"><input id="iquantity" type="text" name="iquantity" class="form-control"></div></div></div></div>
            </div>
            <div class="col-sm-3" style="height: 45px;">
                <div class="form-group"><div class="form-group"><label class="control-label col-sm-4 text-nowrap">单价</label><div class="col-sm-8"><div class="input-group"><input id="iprice" type="text" name="iprice" class="form-control"></div></div></div></div>
            </div>
            <div class="col-sm-3" style="height: 45px;">
                <div class="form-group"><div class="form-group"><label class="control-label col-sm-4 text-nowrap">收货人姓名</label><div class="col-sm-8"><div class="input-group"><input id="ckhname" type="text" name="ckhname" class="form-control"></div></div></div></div>
            </div>
            <div class="col-sm-3" style="height: 45px;">
                <div class="form-group"><div class="form-group"><label class="control-label col-sm-4 text-nowrap">联系电话</label><div class="col-sm-8"><div class="input-group"><input id="cphone" type="text" name="cphone" class="form-control"></div></div></div></div>
            </div>
            <div class="col-sm-3" style="height: 45px;">
                <div class="form-group"><div class="form-group"><label class="control-label col-sm-4 text-nowrap">收货人省</label><div class="col-sm-8"><div class="input-group"><input id="cprovince" type="text" name="cprovince" class="form-control"></div></div></div></div>
            </div>
            <div class="col-sm-3" style="height: 45px;">
                <div class="form-group"><div class="form-group"><label class="control-label col-sm-4 text-nowrap">收货人市</label><div class="col-sm-8"><div class="input-group"><input id="scity" type="text" name="scity" class="form-control"></div></div></div></div>
            </div>
            <div class="col-sm-3" style="height: 45px;">
                <div class="form-group"><div class="form-group"><label class="control-label col-sm-4 text-nowrap">收货人区</label><div class="col-sm-8"><div class="input-group"><input id="cdistrict" type="text" name="cdistrict" class="form-control"></div></div></div></div>
            </div>
            <div class="col-sm-3" style="height: 45px;">
                <div class="form-group"><div class="form-group"><label class="control-label col-sm-4 text-nowrap">收货人地址</label><div class="col-sm-8"><div class="input-group"><input id="caddress" type="text" name="caddress" class="form-control"></div></div></div></div>
            </div>
            </div>

            </form>

        </div>
        <div class="sub-switch-body">
            <div class="body">                
                <table class="table footable" cellspacing="0" cellpadding="0" id="BLBOrderGrid" data-page-size="10" style="background: #fff;font-size:14px;">
                    <thead>
                    <tr class="order">
                        <th>订单日期</th>
                        <th>SN号</th>
                        <th>订单号</th>
                        <th>购买渠道</th>
                        <th>物流单号</th>
                        <th>商品名称</th>
                        <th>价格</th>
                        <th>收货人姓名</th>
                        <th>联系电话</th>
                        <th>收货地址</th>
                    </tr>
                    </thead>
                    <tbody></tbody>
                    <tfoot>
                    <tr>
                        <td colspan="11">
                            <div id="BLBOrderPagination"></div>
                        </td>
                    </tr>
                    </tfoot>
                </table>
            </div>
        </div>
    </div>
</div>

<script id="table-tr-template-blb" type="text/x-handlebars-template">
    <tr class="ember-view">
        <td>{{dorderdate}}</td>
        <td>{{cinvsn}}</td>
        <td>{{cordercode}}</td>
        <td>{{cusname}}</td>
        <td>{{cckcode}}</td>
        <td>{{cinvname}}</td>
		<td>{{iprice}}</td>
        <td>{{ckhname}}</td>
        <td>{{cphone}}</td>
        <td>{{caddress}}</td>
        <td class="title"><a>详情</a></td>
    </tr>
</script>

<script>
    var BLBOrderListModal = (function () {
        var paramCache = {};
        // 如果传入url则代替默认的url
        function init(url) {

            getOrderData({
            	info:JSON.stringify($("#searchForm").formValue()),
                page: 1,
                rows: 5
            },url);
        }

        /**
         * 初始化分页
         */
        var pager = new cri.Pager($("#BLBOrderPagination"), {
            page: 1,
            pageSize: 5,
            total: 0,
            onPage: function (page, pageSize) {
                $.extend(paramCache, {page: page, rows: pageSize});  
                
                /* getOrderData(paramCache); */               
                changePage({page: page, rows: pageSize});
            }
        });

        //分页，从后台保存的结果集中进行分页，不再重新调用查询接口
        var changePage = (function () {
            return function (param,url) {
                $.ajax({
                    url: url || "<%=request.getContextPath()%>/integrations/changePage",
                    dataType: 'json',
                    data: param,
                    success: function (data) {
                        if (!data.success) {
                            notice.danger(data.msg);
                            return;
                        }                       
                        createTable(data.rows, data.total);
                        
                        pager.update(param.page, param.rows, data.total);
                        $.extend(paramCache, param);
                    }
                });
            }
        })();
        
        /**
         * 向后台请求数据-订单
         */
        var getOrderData = (function () {
            return function (param,url) {
                $.ajax({
                    url: url || "<%=request.getContextPath()%>/integrations/searchBLBOrder",
                    dataType: 'json',
                    data: param,
                    success: function (data) {
                        if (!data.success) {
                            notice.danger(data.msg);
                            return;
                        }                       
                        createTable(data.rows, data.total);
                        
                        pager.update(param.page, param.rows, data.total);
                        $.extend(paramCache, param);
                    }
                });
            }
        })();

        //生成表格
        var createTable = (function () {
            var trTemp = Handlebars.compile($("#table-tr-template-blb").html());
            //订单数据表格
            var $orderTable = $("#BLBOrderGrid");
            // 暂无数据表格
            var $noDataTable = $('#noBLBOrderGrid');
            
            return function (tableData, count) {            	
                var html = [];
                var order = null;
                var trArray = [];
                // 遍历订单列表
                for (var i = 0, len = tableData.length; i < len; i++) {
                    order = tableData[i];                   
                    trArray.push(order);                  
                }
                createTr(trArray, trTemp, html);

                $orderTable.find("tbody").empty().append(html);
            };
        })();

        //生成行数据
        function createTr(trArray, trTemp, html) {
            if (trArray.length != 0) {
                for (var i = 0; i < trArray.length; i++) {
                    var $tr = $(trTemp(trArray[i]));
                    $tr.data("row", i);  
                    
                    var $a = $tr.find("a");
                    $a.data("data", trArray[i]);
                    
                    $a.click(function () {
                        var data = $(this).data("data");

                        var url = "<%=request.getContextPath()%>/integrations/blbOrderDetail?cphone="+data.cphone+"&cordercode="+data.cordercode+"&cinvcode="+data.cinvcode;
                        var title = "订单信息";
                        top.openTab(url, "order", title, false);
                        //window.location.href=url;
                    });
                    
                    html.push($tr);
                }
            }
        }

        return {
            init: init
        };
    })();

    $(function(){
        // 显示or隐藏"订单搜索面板"
        $("#moreBtn").click(function (e) {
            e.preventDefault();
            if($(this).hasClass("isMore")) {
                $("#searchBox").animate({height: "60px"}, 500);
                $(this).html('更多<i class="fa fa-angle-double-down"></i>');
            }else{
                $("#searchBox").animate({height:"303px"},500);
                $(this).html('收起<i class="fa fa-angle-double-up"></i>');
            }
            $(this).toggleClass("isMore");
        });
        $("#moreBtn").click(); //默认收起

        //重置搜索选项
        $("#resetBtn").click(function (e) {
            e.preventDefault();
            $("#searchForm")[0].reset();
        })

        //初始化时间控件
        $("#dorderdate").timeInput({
            format: 'yyyy/M/d',
            HMS: false
        });
        $("#dckdate").timeInput({
            format: 'yyyy/M/d',
            HMS: false
        });

        //搜索订单
        $("#searchBtn").click(function (event) {
            event.preventDefault();
            var paramSearch=JSON.stringify($("#searchForm").formValue());
            <%-- var urlSearch="<%=request.getContextPath()%>/integrations/searchBLBOrder?info=" + encodeURIComponent(paramSearch); --%>
            if(paramSearch!=null){
            	 var urlSearch="<%=request.getContextPath()%>/integrations/searchBLBOrder";
                 BLBOrderListModal.init(urlSearch);
            }
        });

        //label样式修改
        $("#searchForm label").addClass("text-nowrap");
        $("#searchForm .timeInputGroup span").addClass("hide");
    });

</script>
</body>
</html>
