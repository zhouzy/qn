<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<style>
#serviceGroupModal th {
    text-align: center;
}

#serviceGroupModal tr {
    text-align: center;
}
</style>
<!-- 客户归属客服组弹窗 -->
<div id="serviceGroupModal" class="modal fade bs-example-modal-sm" data-backdrop="static">
<div class="modal-dialog">
    <div class="modal-content">
        <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span
                    aria-hidden="true">&times;</span></button>
            <span class="modal-title">选择归属组</span>
        </div>
        <div class="modal-body">
            <table class="table" cellspacing="0" cellpadding="0" id="grid-serviceGroup"
                   style="table-layout:fixed;display:none;">
                <thead>
                <tr class="order" id="userTableTr">
                    <th width="20"></th>
                    <th width="500">归属组名称</th>
                    <!-- <th width="100">技能组</th>
                    <th width="140">电话</th>
                    <th width="150">邮箱</th>
                    <th width="150">创建时间</th> -->
                </tr>
                </thead>
                <tbody></tbody>
                <tfoot>
                <tr id="paginationTR">
                    <td colspan="8">
                        <div id="paginationServiceGroup"></div>
                    </td>
                </tr>
                </tfoot>
            </table>
            <table class="table" cellspacing="0" cellpadding="0" id="grid-service"
                   style="table-layout:fixed;display:none;">
                <thead>
                <tr class="order" id="userTableTr">
                    <th width="20"></th>
                    <th width="500">姓名</th>
                    <!-- <th width="100">技能组</th>
                    <th width="140">电话</th>
                    <th width="150">邮箱</th>
                    <th width="150">创建时间</th> -->
                </tr>
                </thead>
                <tbody></tbody>
                <tfoot>
                <tr id="paginationTR">
                    <td colspan="8">
                        <div id="paginationService"></div>
                    </td>
                </tr>
                </tfoot>
            </table>
        </div>
        <div class="modal-footer">
            <button type="button" class="btn btn-raised btn-default btn-sm" data-dismiss="modal">取消</button>
            <button type="button" class="btn btn-raised btn-danger btn-sm" onclick="clearGroup();"
                    data-dismiss="modal">清空
            </button>
            <button type="button" class="btn btn-raised btn-primary btn-sm" onclick="chooseServiceGroup()">确定
            </button>
        </div>
    </div>
</div>
</div>

<!-- 客户归属客服组 -->
<script id="table-tr-template-serviceGroup" type="text/x-handlebars-template">
<tr id="userFieldRows" onclick="userFieldRowsClick(this);">
    <td><input type="radio" name="choosed" onchange="rdChange($(this).closest('#userFieldRows'));"></td>
    <td style="display:none">{{groupId}}</td>
    <td style="display:none">{{userLabel}}</td>
    <td data-prop="groupName" class="user">
        <span>{{groupName}}</span>
    </td>
</tr>
</script>

<!-- 客户归属客服 -->
<script id="table-tr-template-service" type="text/x-handlebars-template">
<tr id="userFieldRows" onclick="userFieldRowsClick(this);">
    <td><input type="radio" name="choosed" onchange="rdChange($(this).closest('#userFieldRows'));"></td>
    <td style="display:none">{{userId}}</td>
    <td style="display:none">{{userLabel}}</td>
    <td data-prop="userName" class="user">
        <span>{{userName}}</span>
    </td>
</tr>
</script>

<script>
//选择归属客服组或归属客服时所选中的行
var choosedTr = null;
//记录是否是归属客服的选择
var isService = false;
//当选择了归属客服组后将缓存该客服组下的坐席以选择归属客服
var members = null;
//归属客服组input组件jquery筛选字符串
var serviceGourpJq = "#serviceGroupName";
//归属客服input组件jquery筛选字符串
var serviceJq = "#serviceName";

/*
 * 列表中的单选按钮点击事件处理（缓存所选的行）
 */
function rdChange(tr) {
    choosedTr = tr;
}

function userFieldRowsClick(that) {
    $this = that;
    $("#userFieldRows input").each(function () {
        $(this).prop('checked', false);
    });
    $(($($this).find('input'))[0]).prop('checked', true);
    rdChange($($this));
}

/*
 * 点击归属客服组或归属客服输入框事件处理
 */
function getDataTableServiceGroup(that, isDetails, isEdit) {
    doCancel();
    choosedTr = null;
    isService = false;
    if (isDetails) {
        $("#serviceGroupModal .modal-title").text($(that).data("label"));
    } else {
        $("#serviceGroupModal .modal-title").text($(that).data("name"));
    }
    if (isEdit) {
        serviceGourpJq = "#serviceGroupNameEdit";
        serviceJq = "#serviceNameEdit";
    }
    var name = $(that).attr("name");
    var param = {page: 1, rows: 10, entId: '${entId}'};
    //根据点击的输入框的name属性来判断是客服组还是客服
    if (name == 'serviceName') {
        if (!$(serviceGourpJq).val()) {
            notice.warning('请先选择归属组！');
            return;
        }
        isService = true;
        getTableDataService(param, '');
    } else {
        var url = "<%=request.getContextPath()%>/groupMongo/getAgentGroups";
        getTableDataService(param, url);
    }
}


/**
 * 初始化分页
 */
var pager1 = new cri.Pager($("#paginationServiceGroup"), {
    page: 1,
    pageSize: 10,
    total: 0,
    onPage: function (page, pageSize) {
        var userStatus = "";
        var url = "<%=request.getContextPath()%>/groupMongo/getAgentGroups";
        getTableDataService({page: page, rows: pageSize, entId: '${entId}'}, url);
    }
});
var pager2 = new cri.Pager($("#paginationService"), {
    page: 1,
    pageSize: 10,
    total: 0,
    onPage: function (page, pageSize) {
        <%-- var userStatus="";
        var url="<%=request.getContextPath()%>/userManageMongo/queryAgent"; --%>
        getTableDataService({page: page, rows: pageSize, entId: '${entId}'}, '');

    }
});
/**
 * 向后台请求数据或展示缓存的坐席
 */
var getTableDataService = (function () {
    var pager = null;
    return function (param, url) {
        var dataLen = 0;

        //处理归属客服选择的情况
        if (isService) {
            if (members == null) {
                notice.warning("客服列表缓存失败，请重新选择归属组！");
                return;
            }

            pager = pager2;
            dataLen = members.length;

            var start = (param.page - 1) * param.rows;
            var end = start + param.rows;

            if (end > dataLen) {
                end = dataLen;
            }

            var memberShow = [];
            for (var i = start; i < end; i++) {
                memberShow.push(members[i]);
            }
            createTableService(memberShow);
            pager.update(param.page, param.rows, dataLen);
        }
        //处理归属客服组选择的情况
        else {
            pager = pager1;

            $.post(url, param, function (data) {
                dataLen = data.total;

                // 数据加载完成，按钮可点击
                $(serviceGourpJq).prop('disabled', false);

                createTableService(data.rows);
                pager.update(param.page, param.rows, dataLen);
            });
        }
    }
})();


var trTemp1 = Handlebars.compile($("#table-tr-template-serviceGroup").html());
var trTemp2 = Handlebars.compile($("#table-tr-template-service").html());
/*
 * 创建表格
 */
var createTableService = (function () {
    var trTemp = null;
    var $table = null;
    return function (tableData, type) {
        if (isService) {
            trTemp = trTemp2;
            $table = $("#grid-service");
        } else {
            trTemp = trTemp1;
            $table = $("#grid-serviceGroup");
        }
        var html = [];
        for (var i = 0, len = tableData.length; i < len; i++) {
            var $tr = $(trTemp(tableData[i]));
            $tr.data("data", tableData[i]);
            html.push($tr);
        }
        $table.find("tbody").empty().append(html);
        $table.css("display", "block");
        $("#serviceGroupModal").modal('show');
        //$("#addUserModal").modal('hide');

    };
})();

// 清空归属客服组
function clearGroup() {
    if (isService == false) { // 清空客服组
        $(serviceGourpJq).val('');
        $(serviceGourpJq).data("serviceGroupId", '');
        $(serviceGourpJq).change();
    }

    // 清空客服
    $(serviceJq).val('');
    $(serviceJq).data("serviceId", '');
    $(serviceJq).change();
}

/*
 * 处理 '确定' 按钮的点击事件
 */
function chooseServiceGroup() {
    var name = "", ID = "";
    //未选择归属客服组或客服则退出
    if (choosedTr == null) {
        if (isService) {
            notice.warning("请选择归属人");
        } else {
            notice.warning("请选择归属组");
        }
        return;
    }
    //获取所选的客服组或客服的json对象
    var dataH = $(choosedTr).data("data");
    if (isService) {
        name = dataH.userName;
        ID = dataH.userId;
        $(serviceJq).val(name);
        $(serviceJq).data("serviceId", ID);
        $(serviceGourpJq).change();
        $(serviceJq).change();
    } else {
        members = dataH.members;
        name = dataH.groupName;
        ID = dataH.groupId;

        $(serviceGourpJq).val(name);
        $(serviceGourpJq).data("serviceGroupId", ID);
        //每次重新选择归属客服组后清除归属客服
        $(serviceJq).val('');
        $(serviceJq).data("serviceId", '');
        $(serviceGourpJq).change();
        $(serviceJq).change();
        //$("#serviceName").attr("data-target","#serviceGroupModal");
    }
    $("#grid-serviceGroup").css("display", "none");
    $("#grid-service").css("display", "none");
    $("#serviceGroupModal").modal('hide');
}
/*
 * 隐藏两个表格
 */
function doCancel() {
    $("#grid-serviceGroup").css("display", "none");
    $("#grid-service").css("display", "none");
    serviceGourpJq = "#serviceGroupName";
    serviceJq = "#serviceName";
}

function initGroupMembers(groupId) {
    if (!groupId) {
        return;
    }
    var param = {groupId: groupId};
    var url = "<%=request.getContextPath()%>/groupMongo/getAgentsByGroup";
    $.post(url, param, function (data) {
        if (data.success) {
            members = data.rows;
        } else {
            notice.warning(data.msg);
        }

    });
}
</script>