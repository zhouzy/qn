<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>添加工单自定义字段</title>
    <%@include file="/views/include/pageHeader.jsp"%>
    <%--<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/static/css/ef3763efa8e67025e2caf0ced6deb474.css">--%>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/static/css/selfField.css">
</head>

<body>
<div class="container-fluid">
    <ul class="breadcrumbs">
        <li>
            <a target="_self" href="<%=request.getContextPath()%>/workTemplate/workTemplates">工单自定义分类</a>
        </li>
        <li>
            <a target="_self" href="<%=request.getContextPath()%>/workTemplate/edit?tempId=${tempId}">编辑:[${template.tempName}]</a>
        </li>
        <li>添加字段:[<span id="span1"></span>]</li>
    </ul>
    <div class="panel">
        <form target="_self" method="post" id="fieldForm">
            <input value="STRING" name="type" id="type" type="hidden">
            <input value="false" name="isRequired" id="required" type="hidden">
            <input name="componentType" id="componentType" type="hidden">
            <input name="defaultValue" id="defaultValue" type="hidden">
            <input name="candidateValue" id="candidateValue" type="hidden">
            <input name="tempId" id="tempId" type="hidden" value="${tempId}">

            <div class="kf5-section">
                <div class="field t-col">
                    <div class="t-col-content">
                        <h5> 显示标题</h5>
                        <input name="name" id="UserField_agent_title" maxlength="255" type="text">
                        <h5><input name="checkbox" id="UserField_agent_required" maxlength="255" type="checkbox"> 是否必填</h5>
                        <h5> 描述（可选）</h5>
                        <textarea name="remark" id="UserField_description"></textarea>
                    </div>
                </div>

            </div>

            <!-- 添加下拉菜单或复选框时显示 -->
            <div class="field t-col" style="display:none" id="dropdownlist">
                <h4 class="ln">下拉菜单的选项</h4>
                <div class="t-col-content">
                    <ul class="select-area" id="select-area">
                        <li id="index1">
                            <input id="items_1" name="UserField[items][1][key]" value="" placeholder="请输入选项内容" type="text">
                            <a target="_self" href="javascript:void(0);" class="remove" onclick="delItem(1);"></a>
                        </li>
                    </ul>
                    <a id="a1" target="_self" href="javascript:void(0);" class="add-conditions" onclick="addItem();"></a>
                </div>
            </div>

            <!-- 添加正则匹配字段时显示 -->
            <div class="field t-col" style="display:none" id="customized">
                <h4 class="ln">正则匹配字段</h4>
                <div class="t-col-content">
                    <h5>请在这里输入正则表达式的规则</h5>
                    <input name="UserField[items]" id="Customized_items" type="text">
                    <p class="hint">
                        例如qq号码：^[1-9]\d{4,9}$
                        <a onclick="window.open(&quot;<%=request.getContextPath()%>/userField/regularExpression/&quot;,&quot;newwindow&quot;,&quot;height=500,width=550,top=0,left=0,toolbar=no,menubar=no,scrollbars=no, resizable=no,location=no, status=no&quot;) ;">
                            查看更多常用正则表达式范例</a>
                    </p>
                </div>
            </div>

            <!-- 添加日期时间输入框时显示 -->
            <div class="field t-col" style="display:none" id="datetimepicker">
                <h4 class="ln">日期时间格式</h4>
                <div class="t-col-content">
                    <select id="datetimeformat"  name="dateformat" style="letter-spacing: 4px">
                        <option value="yyyy/MM/dd hh:mm:ss" selected = "selected">年/月/日  时:分:秒</option>
                        <option value="yyyy-MM-dd hh:mm:ss">年-月-日  时:分:秒</option>
                        <option value="yyyy/MM/dd">年/月/日</option>
                        <option value="yyyy-MM-dd">年-月-日</option>
                    </select>
                </div>
            </div>

            <!--操作栏   -->
            <div class="field field-operation">
                <input type="button" id="submitbutton" class="btn-sm btn-green fr" onclick="addType()" value="提交">
            </div>
        </form>
    </div>
</div>

<script type="text/javascript">
    var i = 1;
    var checklist = [];

    $(function () {
        if ("${type}" == "text") {
            $("#span1").html("文本框");
            $("#componentType").val("1");
        } else if ("${type}" == "textarea") {
            $("#span1").html("文本区域");
            $("#componentType").val("2");
        } else if ("${type}" == "dropdownlist") {
            $("#span1").html("下拉菜单");
            $("#a1").html("添加下拉菜单选项");
            $("#componentType").val("3");
            $("#dropdownlist").show();
        } else if ("${type}" == "checkboxlist") {
            $("#span1").html("复选框");
            $("#a1").html("添加复选框选项");
            $("#componentType").val("4");
            $("#dropdownlist").show();
        } else if ("${type}" == "number_int") {
            $("#span1").html("数字");
            $("#componentType").val("6");
        } else if ("${type}" == "number_float") {
            $("#span1").html("小数");
            $("#componentType").val("7");
        } else if ("${type}" == "customized") {
            $("#span1").html("正则匹配字段");
            $("#componentType").val("8");
            $("#customized").show();
        } else if ("${type}" == "phoneNum") {
            $("#span1").html("电话号码");
            $("#componentType").val("9");
        } else if ("${type}" == "datetimepicker") {
            $("#span1").html("时间输入框");
            $("#componentType").val("10");
            $("#datetimepicker").show();
        } else if ("${type}" == "area") {
            $("#span1").html("省市区");
            $("#componentType").val("11");
        }
        $("#UserField_agent_required").click(function () {
            $("#required").val("" + $("#UserField_agent_required").prop("checked"));
        });
    });

    /* 添加复选框选项 */
    function addItem() {
        var spanHtml = "";
        i = i + 1;
        spanHtml += '<li id="index' + i + '")><input id="items_' + i + '" name="" value="" placeholder="请输入选项内容" type="text">' +
                '<a target="_self" href="javascript:void(0);" class="remove" onclick="delItem(' + i + ');" ></a></li>';
        $("#select-area").append(spanHtml);
    }

    /* 移除复选框选项 */
    function delItem(data) {
        i = i - 1;
        $("#index" + data).remove();
    }

    /* 添加用户自定义字段 */
    function addType() {
        var $title = $("#UserField_agent_title");
        $title.val($title.val().trim());

        /* 标题不能为空 */
        if ($title.val() == "") {
            notice.warning("显示标题（客服） 不可为空白.");
            return false;
        }

        checklist = [];
        if ("${type}" == "checkboxlist" || "${type}" == "dropdownlist") {
            $("#dropdownlist input[type=text]").each(function () {
                if ($(this).val().trim() != "") {
                    checklist.push($(this).val());
                }
            });

            if (hasRepeat(checklist)) {
                notice.warning("选项不能有重复！");
                return;
            }
            var json = {};
            for (var i = 0; i < checklist.length; i++) {
                json[i + ""] = checklist[i];
            }

            $("#candidateValue").val(JSON.stringify(json));
        }
        if ("${type}" == "customized") {
            checklist[0] = $("#Customized_items").val();

            var json = {};
            for (var i = 0; i < checklist.length; i++) {
                json[i + ""] = checklist[i];
            }
            $("#candidateValue").val(JSON.stringify(json));
        }

        if ("${type}" === "datetimepicker") {
            $("#candidateValue").val(JSON.stringify({
                "0": $("#datetimeformat").val()
            }));
        }

        /* 电话自定义字段 */
        if ("${type}" == "phoneNum") {
            /* 		   匹配格式：11位手机号
             3-4位区号，7-8位直播号码，1-4位分机号码
             如：12345678901,1234-12345678-1234 */

            checklist[0] = "((\\d{11})|^((\\d{7,8})|(\\d{4}|\\d{3})-(\\d{7,8})|(\\d{4}|\\d{3})-(\\d{7,8})-(\\d{4}|\\d{3}|\\d{2}|\\d{1})|(\\d{7,8})-(\\d{4}|\\d{3}|\\d{2}|\\d{1}))$)";
            var json = {};

            json[0] = checklist[0];
            $("#candidateValue").val(JSON.stringify(json));
        }


        /* 候选项不能为空（若有） */
        if (("${type}" == "checkboxlist" || "${type}" == "dropdownlist" || "${type}" == "customized") && $("#candidateValue").val() == "") {
            notice.warning("选项不可为空白");
            return false;
        }

        /* 避免连续点击重复提交 */
        $("#submitbutton").prop("disabled", true);
        $.post("<%=request.getContextPath()%>/workTemplate/addDefinedField", $("#fieldForm").serialize(), function (data) {
            if (data.success) {
                /* 返回字段管理界面 */
                var title = data.rows;
                var tempId = "${tempId}";
                notice.success("字段" + title + "创建成功！");
                location.href = "<%=request.getContextPath()%>/workTemplate/edit?tempId=" + tempId;
            } else {
                notice.warning(data.msg);
                $("#submitbutton").prop("disabled", false);
            }
        });
    }

    /* 判断数组中是否有重复选项 */
    function hasRepeat(array) {
        if ((typeof array) == 'object') {
            for (var i = 0; i < array.length - 1; i++) {
                for (var j = i + 1; j < array.length; j++) {
                    if (array[i] == array[j]) {
                        return true;
                    }
                }
            }
        }
        return false;
    }
</script>
</body>
</html>
