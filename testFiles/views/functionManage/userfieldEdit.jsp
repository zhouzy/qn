<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>客户自定义字段</title>
    <%@include file="/views/include/pageHeader.jsp"%>
    <link href="<%=request.getContextPath()%>/static/css/selfField.css" type="text/css" rel="stylesheet">
	<%--<link href="<%=request.getContextPath()%>/static/css/ef3763efa8e67025e2caf0ced6deb474.css" type="text/css" rel="stylesheet">--%>
</head>
<body>
	<div class="container-fluid">
        <input type="hidden" id="UserField_type" name="UserField[type]" value="checkboxlist">
        <ul class="breadcrumbs">
            <li><a href="<%=request.getContextPath()%>/userField/userfields" target="_self">客户自定义字段</a></li>
            <li>编辑字段:[${field.componentTypeStr}]</li>
        </ul>
		<div class="panel">
			<form id="yw0" target="_self">

				<div class="kf5-section">
					<div class="field t-col">
						<!-- <h4 class="ln">对客服</h4> -->
						<div class="t-col-content">
							<h5>
								<label for="UserField_agent_title">显示标题</label>
							</h5>
							<input type="text" value="${field.name}" maxlength="255" id="UserField_agent_title" name="agentTitle">

                            <p class="hint">在用户信息页上显示给客服的标题</p>

                            <h5>
								<label><input type="checkbox" name="isRequired" data-isRequired="${field.isRequired}"> 是否必填项</label>
							</h5>

							<h5>
								<label for="UserField_description">描述（可选）</label>
							</h5>
							<textarea id="UserField_description"
								name="description">${field.remark}</textarea>
							<p class="hint">该字段在客户信息页上的描述信息</p>
						</div>
					</div>
					<div class="field t-col" style="display:none" id="multiItems">
						<h4 class="ln">${tcolTitle}</h4>
						<div class="t-col-content" id="dropdownItems">
							<ul id="select-area" class="select-area">
							</ul>
							<a onclick="addItem();" class="add-conditions" href="javascript:void(0);" target="_self">
								<c:if test="${field.componentType=='4'}">添加复选框选项</c:if>
							</a>
						</div>
						<div class="t-col-content" id="regularItems">
                    		<h5>请在这里输入正则表达式的规则</h5>
                    		<input type="text" value="" id="UserField_items" name="userFieldItems">
                    		<p class="hint">例如qq号码：^[1-9]\d{4,9}$
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
		         
					<div class="field field-operation">
						<a onclick="delField()" class="btn btn-red ml0" href="javascript:void(0);" target="_self">删除</a>
						 <a onclick="formSubmit();" class="btn btn-green fr" href="javascript:void(0);" target="_self">提交</a>
					</div>
				</div>
			</form>
		</div>
		<div class="ps-scrollbar-x-rail">
			<div class="ps-scrollbar-x"></div>
		</div>
		<div class="ps-scrollbar-y-rail">
			<div class="ps-scrollbar-y"></div>
		</div>
	</div>
<script type="text/javascript">
	var index = 0;
	var order = 0;
	function createItem(key, value) {
		index++;
		return "<li id='index"+ index+ "'><input id='UserField_items_"+ index
				+ "_key' type='text' name='userFieldItems'"+ " value='"+ key
				+ "' placeholder='请输入选项内容'><a href='javascript:void(0);'"
				+" class='remove' onclick='delItem("+ index + ");'></a></li>";
	}
	function delItem(index) {
		$("#index" + index).remove();
	}
	function addItem() {
		var item = createItem("", "");
		$("#select-area").append(item);
		$("#select-area input:last").trigger("focus");
	}
	$(function(){
		if("${type}" == "10"){
			var candiV = '${candidate}';
			$("#datetimepicker").show();
			if(candiV){
				$("#datetimeformat").val(candiV);
			}
		} else{
			$("#datetimepicker").remove();
		}
		
		var multp="${multp}";
		if(multp=="true"){
			if("${contentNum}"=="0"){
				$("#regularItems").remove();
				initialDropItems();
				$("#multiItems").show();
			}else{
				$("#dropdownItems").remove();
				initialRegularItems();
				$("#multiItems").show();
			}
		}else{
			$("#multiItems").remove();
		}
		var $checkbox = $('input[type=checkbox][name=isRequired]');
        if($checkbox.attr('data-isRequired') === 'true'){
            $checkbox.prop('checked',true);
        }
	});

	function initialDropItems(){
		var candidate=JSON.parse('${candidate}');
		for(var item in candidate){
			var i = createItem(candidate[item],null);
			$("#select-area").append(i);
		}
	}
	function initialRegularItems(){
		$("#UserField_items").val(decodeURIComponent('${candidate}'));
	}
	
	function formSubmit(){
		var param={};
		var multi=false;
		$("form input[type=text]").each(function(){
			var nowV = param[$(this).attr('name')];
			if(nowV){
				multi=true;
				if(typeof(nowV)=="object"){
					param[$(this).attr('name')].push($(this).val().trim());
				}else{
					param[$(this).attr('name')]=[nowV,$(this).val().trim()];
				}
			}else{
				param[$(this).attr('name')]=$(this).val().trim();
			}
		});
		$("form textarea").each(function(){
			param[$(this).attr('name')]=$(this).val();
		});
        $("form input[type=checkbox][name=isRequired]").each(function(){
            var $this = $(this);
            if($this.prop('checked')){
                param[this.name] = 'true';
            }
            else{
                param[this.name] = 'false';
            }
        });

		if("${multp}"=="true"){
			var array=param["userFieldItems"];
			if(hasRepeat(array)){
				notice.warning("选项不能有重复！");
				return ;
			}
			var json={};
			if(multi==true){
				for(var i=0;i<array.length;i++){
					json[""+i]=array[i];
				}
			}else{
				json['0']=array;
			}
			param["userFieldItems"]=JSON.stringify(json);
		}

        //10 表示 时间输入框
		if("${type}" == "10"){
			var datefValue = $("#datetimeformat").val();
			if(datefValue == "" || datefValue == null){
				notice.warning("请选择时间格式");
				return ;
			} else {
				param["userFieldItems"]=JSON.stringify({
	                "0":datefValue
	            });
			}
        }
        //8 表示 正则表达式
        if("${type}" == "8"){
            var candidateValue = encodeURIComponent($("#UserField_items").val());
            param["userFieldItems"] = JSON.stringify({"0":candidateValue});
        }
		param.type="${type}";
		
		$.post("<%=request.getContextPath()%>/userField/goEdit/${field.key}",param,changeCallBack,'json');
	}
	function changeCallBack(data){
		if(data.success){
			notice.success(data.msg);
		}else{
			notice.warning(data.msg);
			return ;
		}
		location.href="<%=request.getContextPath()%>/userField/userfields";
	}
	/* 判断数组中是否有重复选项 */
	function hasRepeat(array){
		if( (typeof array) == 'object' ){
			for(var i = 0;i<array.length-1;i++){
				for(var j = i+1;j<array.length;j++){
					if(array[i] == array[j]){
						return true;
					}
				}
			}
		}
		return false;
	}
	
	function delField(){
		if (!confirm("确定要删除该字段吗？删除后不可恢复！")){
			return;
		}
		var url = "<%=request.getContextPath()%>/userField/change/delete/${field.key}";
		$.post(url,null,changeCallBack,'json');
	}
</script>

</body>
</html>
