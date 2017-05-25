<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>批量导入工单</title>
    <%@include file="/views/include/pageHeader.jsp" %>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/static/css/importIndex.css">
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/script/lib/ajaxFileUpload/ajaxfileupload.css">
    <script src="<%=request.getContextPath()%>/script/lib/ajaxFileUpload/ajaxfileupload.js"></script>
</head>
<body>
<div class="container-fluid" style="margin-top: 70px;">
    <h4>批量导入工单</h4>
    <div class="panel" style="padding: 20px">
        <div class="tab-content">
            <!-- 批量导入工单-->
            <div role="tabpanel" class="tab-pane active" id="home">
                <div class="section-pt">
                    <div class="form-horizontal" style="padding: 0 15px;">
                        <div class="form-group">
                            <label class="control-label col-md-2">选择导入的模板：</label>
                            <div class="col-md-10" id="wotemp"></div>
                        </div>
                        <div class="form-group">
                            <label for="fileImportWo" class="control-label col-md-2">选择文件导入：</label>
                            <div class="col-md-8">
                                <input type="text" readonly="false" class="form-control" placeholder="请选择文件上传...">
                                <input type="file" id="fileImportWo" name="fileImportWo" multiple="">
                            </div>
                        </div>
                        <div class="field t-col" style="display:none" id="callBack">
                            <h4>
                                <label>导入结果</label>
                            </h4>
                            <h4>
                                <a href="#" onclick="downloadResult()">下载结果文件</a>
                            </h4>

                            <div class="t-col-content">
                                <ol>
                                    <li>共计<span class="hint" id="totalNum" style="color: red"></span>条记录，用时<span
                                            class="hint" id="time" style="color: red"></span>秒
                                    </li>
                                    <li>成功导入<span class="hint" id="importSuccessNum" style="color: red"></span>条记录</li>

                                    <li>导入失败<span class="hint" id="importFailNum" style="color: red"></span> 条记录</li>
                                    <li>导入失败记录列表：</li>
                                </ol>
                                <ol id="failList">

                                </ol>
                            </div>
                        </div>
                    </div>
                    <div class="field field-operation">
                        <!--  <input type="submit" name="yt0" onclick="download()" value="下载模板"> -->
                        <button class="btn btn-sm btn-raised" onclick="cancelImport()">取消</button>
                        <button class="btn btn-sm btn-raised btn-primary" onclick="importSubmit()">导入</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    $(function () {
        setWorkOrderTemp();
    });

    /* 工单模板复选框 */
    function setWorkOrderTemp() {
        $.ajax({
            url: "http://<%=request.getServerName()%>:" + top.workBasePath + "/workorder/queryTemplate?sessionKey=" + $.cookie("sessionKey"),
            type: "post",
            dataType: "jsonp",
            data: "",
            success: function (data) {
                if (data.success) {
                    var sub = data.rows,
                        $tempId = $("#wotemp"),
                        ordersHtml = '';

                    // 添加选项
                    for (var i = 0, len = sub.length; i < len; i++) {
                        ordersHtml += ' <label class="order-label"><input type="checkbox" checked name="tempType" value="' + sub[i].tempId + '">' + sub[i].tempName + '</label>';
                        //$tempId.append('<p><input type="checkbox" checked  name="tempType" value="' + sub[i].tempId + '"/>' + sub[i].tempName + '</p>');
                    }

                    $tempId.empty().append(ordersHtml);
                }
            }
        });
    }

    function importSubmit() {
        var arr = new Array();
        var items = document.getElementsByName("tempType");
        for (var i = 0; i < items.length; i++) {
            if (items[i].checked) {
                arr.push(items[i].value);
            }
        }
        $("input[type='submit']").attr("disabled", true);
        $.ajaxFileUpload({
            
        	url : "<%=request.getContextPath()%>/userImport/uploadWorkOrder",// url  
            secureuri: false,
            fileElementId: 'fileImportWo',// 上传控件的id
            dataType: 'json',
            data: {tempType: arr}, // 其它请求参数
            success: function (data, status) {
             
                importSubmitCallBack(data);
                var file = $("#fileImportWo").prev(); ;
                file.val("");
            },
            handleError: function (data, status, e) {
                
                notice.warning("导入失败");
            },
            error: function (data, status, e) {
            
                console.dir(e);
            }
        });
    }

    var resultFilePath;
    function importSubmitCallBack(data) {
    	$("input[type='submit']").removeAttr("disabled");
        if (data.success == true) {
            resultFilePath = data.rows.resultFilePath;
            document.getElementById("callBack").style.display = "";
            $("#totalNum").html(data.rows.totalNum);
            $("#time").html(data.rows.time);
            $("#importSuccessNum").html(data.rows.importSuccessNum);
   
            $("#importFailNum").html(data.rows.importFailNum);
            var items = data.rows.failList;
            var html = "";
            for (var i = 0; i < items.length; i++) {
                html += "<li>" + items[i] + "</li>"
            }
            $("#failList").html(html);
        } else {
            notice.warning(data.msg);
        }
    }

    function download() {
        <%-- 	window.open('<%=request.getContextPath()%>/userImport/download'); --%>
    }
    function downloadResult() {
       window.open('<%=request.getContextPath()%>/userImport/downResultExcel?resultFilePath='+encodeURI(resultFilePath));
    }

    function cancelImport() {
        parent.$('#rightIframe').hide();
        parent.$("#right-part").find('.right-content').show();
    }
</script>
</body>
</html>