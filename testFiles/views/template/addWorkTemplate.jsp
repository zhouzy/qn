<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
    <title>添加工单自定义分类</title>
    <%@include file="/views/include/pageHeader.jsp" %>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/static/css/selfField.css">
    <%--<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/static/css/userField.css">--%>
</head>

<body>
 <div class="container-fluid">
     <ul class="breadcrumbs">
         <li>
             <a target="_self" href="<%=request.getContextPath()%>/workTemplate/workTemplates">工单自定义分类</a>
         </li>
         <li>添加</li>
     </ul>
     <div class="panel">
            <form target="_self" method="post" id="fieldForm">
                <div class="kf5-section">
                    <div class="field t-col">
                        <!-- <h4 class="ln">对客服</h4> -->
                        <div class="t-col-content">
                           <h5> 显示标题</h5>
                           <input name="tempName" id="UserField_agent_title" maxlength="255" type="text">
                           <p class="hint">显示的标题</p>
                        </div>
                    </div>
                 </div>

                 <!--操作栏   -->
                 <div class="field field-operation">
                    <a onclick="cancel()" class="btn-sm btn-red ml0" href="javascript:void(0);" target="_self" >取消</a>
                    <input type="button" id="submitBtn" class="btn-sm btn-green fr" onclick="addTemplate()" value="提交">
                 </div>

           </form>
     </div>
</div>

  <script type="text/javascript">
  /* 添加工单模板 */
  function addTemplate(){
	  /* 标题不能为空 */
	  if($("#UserField_agent_title").val()==""){
		  notice.warning("显示标题（客服） 不可为空白.");
		  return false;
	  }
      
	  /* 避免连续点击重复提交 */
	  $("#submitBtn").attr("disabled","disabled");
          $.ajax({
              url: "<%=request.getContextPath()%>/workTemplate/addWorkTemp",
              type:"post",
              dataType: 'json',
              data: $("#fieldForm").serialize(),
              success: function (data) {
                  if (data.success) {
                	  /* 返回字段管理界面 */
                	  var title=data.rows;
                	  notice.success("工单自定义字段：" + title + "&nbsp;" + " 创建成功！");
                	  location.href="<%=request.getContextPath()%>/workTemplate/workTemplates"; 
                  }else {
                      /* notice.warning("添加工单自定义字段失败！"); */
                	  notice.warning(data.msg);
                	  $("#submitBtn").removeAttr("disabled");
                  }
              }
          });
  }
  
	/* 返回模板列表页 */
	function cancel(){
		location.href="<%=request.getContextPath()%>/workTemplate/workTemplates"; 
	}
	
  </script>
 </body>
</html>
