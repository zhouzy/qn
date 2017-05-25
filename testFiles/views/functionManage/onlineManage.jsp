<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>在线用户管理</title>
    <%@include file="/views/include/pageHeader.jsp"%>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/static/css/innerFrame.css">
    <link href="<%=request.getContextPath()%>/static/css/search.css" rel="stylesheet">
</head>

<body>
<div class="container-fluid">
    <h2>
        <form class="form-inline search-sm" style="position: absolute;right: 20px;top: 12px;" method="post" action="javascript:fastSearch()">
            <div class="form-group">
                <div class="input-group">
                    <span class="input-group-addon"><i class="fa fa-search"></i></span>
                    <input type="search" class="form-control col-md-8" placeholder="快捷搜索" id="fastSearch" >
                </div>
            </div>
        </form>
    </h2>
    <div class="row" id="rightContainer">
        <div class="col-md-12">
            <div class="panel" style="padding: 10px 15px;">
                <table class="table" cellspacing="0" cellpadding="0" id="grid" style="table-layout:fixed;">
                    <thead>
                    <tr class="order" id="userTableTr">
                        <th width="40"><input class="ember-view ember-checkbox all-checkbox" type="checkbox" id="allSelect"> </th>
                        <th width="180">账号</th>
                        <th width="150">用户名</th>
                        <th width="150">登录IP</th>
                        <th width="150">登录时间</th>
                    </tr>
                    </thead>
                    <tbody></tbody>
                    <tfoot>
                    <tr id="paginationTR">
                        <td colspan="5"><div id="pagination" class="text-right"></div></td>
                    </tr>
                    </tfoot>
                </table>
            </div>
    </div>
    <div id="toolbar">
        <button id="deleteBtn" type="button" class="btn btn-raised left-btn btn-danger">强制退出</button>
        <button id="cancelBtn" type="button" class="btn btn-raised btn-default btn-dark" onclick="cancel()">取消操作</button>
    </div>
</div>

<!-- 删除客户 -->
<div id="deleteModal" class="modal fade bs-example-modal-sm" data-backdrop="static">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <span class="modal-title">强制退出</span>
            </div>
            <div class="modal-body">
                <div class="container-fluid">
                    <div class="row">
                        <div class="col-sm-10 col-sm-offset-1">
                            <form class="form-horizontal">
                                <div class="form-group">
                                    <span>注意 </span>
                                </div>
                                <div class="form-group">
                                    <p>
                                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                        是否将所选账号<span class="red">强制退出？</span>
                                    </p>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-raised btn-primary btn-sm" onclick="deleteSubmit()" id="deleteSubmit">确认</button>
                <button type="button" class="btn btn-raised btn-default btn-sm" data-dismiss="modal" onclick="cancel()">取消</button>
            </div>
        </div>
    </div>
</div>

<!-- 在线用户模板 -->
<script id="table-tr-template" type="text/x-handlebars-template">
    <tr class="ember-view">
        <td><input class="ember-view ember-checkbox table-checkbox" type="checkbox"></td>
        <td style="display:none">{{id}}</td>
        <td>{{loginName}}</td>
        <td>{{userName}}</td>
        <td>{{loginIp}}</td>
        <td>{{loginTime}}</td>
    </tr>
</script>

<script>
    $(function(){
        getTableData({page:1,rows:10});
    });

    /**
     * 向后台请求数据
     */
    var getTableData = (function(){
        var paramCache = {};
        /**
         * 初始化分页
         */
        var pager = new cri.Pager($("#pagination"),{
            page:1,
            pageSize:10,
            total:0,
            onPage:function(page,pageSize){
                $.extend(paramCache,{page:page,rows:pageSize});
                getTableData(paramCache);
            }
        });
        return function(param,url){
            $.ajax({
                url:"<%=request.getContextPath()%>/onlineManage/query",
                dataType:'json',
                data:param,
                success:function(data){
                    if(!data.success){
                        notice.alert(data.msg);
                    }

                    $("input[type=checkbox]").prop("checked",false);
                    $("#toolbar").removeClass("show");
                    if(data.rows){
                        createTable(data.rows);
                    }
                    pager.update(param.page,param.rows,data.total);
                    $.extend(paramCache,param);
                }
            });
        }
    })();

    /**
     * 刷新表格
     */
    var createTable = (function(){
        var trTemp = Handlebars.compile($("#table-tr-template").html());
        var $table = $("#grid");

        return function(tableData, type){
            var html = [];
            for(var i= 0,len=tableData.length; i<len;i++){;
                var $tr = $(trTemp(tableData[i]));
                $tr.data("data",tableData[i]);

                html.push($tr);
            }
            $table.find("tbody").empty().append(html);

            $table.find("input[type=checkbox]").change(function(){
                var $t = $(this).parent();
                if($t.is("th")){
                    $table.find("td input[type=checkbox]").prop("checked",$(this).prop("checked"));
                }
                var length = $table.find('td input[type=checkbox]:checked').length;

                if(!$t.is("th")){
                    if(tableData.length==length){
                        $("#allSelect").prop("checked",true);
                    }
                    else{
                        $("#allSelect").prop("checked",false);
                    }
                }
                if($table.find('td input[type=checkbox]:checked').length){
                    $("#toolbar").addClass("show");
                }
                else{
                    $("#toolbar").removeClass("show");
                }
            });
        };
    })();

    /**
     * 删除行数据
     */
    $("#deleteBtn").click(function deleteRow(){
        var trArr = [];
        $("#grid td input[type=checkbox]:checked").each(function(){
            var $tr = $(this).closest("tr");
            trArr.push($tr.data("data").id);
        });
        if(trArr.length > 0){
            $("#deleteModal").modal('show');
        }
    });

    /* 确定强制退出 */
    function deleteSubmit(){
        var trArr = [];
        $("#grid td input[type=checkbox]:checked").each(function(){
            var $tr = $(this).closest("tr");
            trArr.push($tr.data("data").id);
        });

        $.ajax({
            url : "<%=request.getContextPath()%>/onlineManage/delete?ids="+trArr,
            type : "post",
            dataType : "json",
            data : {},
            success : function (data) {
                if (data.success) {
                    var url="<%=request.getContextPath()%>/onlineManage/query";
                    getTableData({page:1,rows:10},url);
                    $("#toolbar").removeClass("show");
                    $("#deleteModal").modal('hide');
                    notice.success("退出成功！");
                } else {
                    notice.danger("退出失败！"+data.msg);
                }
            }
        });
    }

    /* 取消按钮 */
    function cancel(){
        $("#grid input[type=checkbox]").each(function(){
            $(this).attr("checked",false);
        });
        $("#toolbar").removeClass("show");
    }

    /* 快捷搜索 */
    function fastSearch(){
        var url="<%=request.getContextPath()%>/onlineManage/query";
        var fastSearch=$("#fastSearch").val();

        $("#allSelect").prop("checked",false);
        $("#toolbar").removeClass("show");

        getTableData({page:1,rows:10,fastSearch:fastSearch},url);
    }
</script>
</body>
</html>
