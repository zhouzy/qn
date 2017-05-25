<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<%@page import = "com.channelsoft.ems.field.po.UserDefinedFiedPo" %>
<%@page import = "org.apache.commons.lang.StringUtils" %>
<%@page import = "com.mongodb.DBObject" %>

<div id="userMerge" class="modal fade bs-example-modal-sm" data-backdrop="static">
    <div class="modal-dialog">
        <div class="modal-content" style="width: 465px;">
            <div class="modal-header">
                <button type="button" class="close" id="mergeClose" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <span class="modal-title">合并用户</span>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" style="margin-left:-10px;overflow:auto;">
                    <ul class="merge-user" style="margin-left:-15px">
                        <li class="fl">
                            <img src="${photoUrl}">
                            <h4>${user.userName}</h4>
                            <p>&lt;${user.loginName }&gt;</p>
                        </li>
                        <img class="link-img" src="<%=request.getContextPath()%>/static/images/lianjie.png">
                        <li class="fr">
                            <img  src="<%=request.getContextPath()%>/static/images/avater/profile_small.jpg">
                            <h4>未选择</h4>
                            <p></p>
                        </li>
                    </ul>
                    <div class="merge-input" >
                        <input placeholder="请输入目标用户的姓名或者登录名" id="user-search" class="form-control" type="text" style="margin-bottom:0px;" autocomplete="off">
                        <input type="text" id="userIdForMerge" style="display:none;"/>
                        <div id="forSelected" style="display:none;">
                        </div>
                    </div>
                    <div class="alert merge-alert" style="color:black;">
                        <span class="orange glyphicon glyphicon-exclamation-sign" aria-hidden="true"></span>
                        当两个账号合并之后，保留目标用户的邮箱地址，
                        <%=
                        StringUtils.isNotBlank((String)((DBObject)request.getAttribute("user")).get("userName"))?
                                ((DBObject)request.getAttribute("user")).get("userName"):
                                ((DBObject)request.getAttribute("user")).get("email")
                        %>的工单（
                        <span class="_ticket">-</span>）、文档（
                        <span class="_post">-</span>）将会移至目标用户
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-raised btn-default btn-sm" id="mergeCancel" data-dismiss="modal">取消</button>
                <button type="button" class="btn btn-raised btn-primary btn-sm" id="confirmMerge">确认合并</button>
            </div>
        </div>
    </div>
</div>
<script>
    /*
    * @author Lesty
    * @codeDate 2016.7.13
    * @desc 创建一个全局对象，暴露相应接口，避免全局污染
    * */
    var userMergeModal = (function() {
        var preValue = "";

        // 初始化(重置内容)窗口
        function init() {
            $(".merge-user .fr h4").html("未选择");
            $(".merge-user .fr p").html("");
            $(".merge-user .fr img").attr("src","<%=request.getContextPath()%>/static/images/avater/profile_small.jpg");
            $(".merge-input div#forSelected").html("");
            $(".merge-input div#forSelected").hide();
            $(".merge-input input").val("");
            $(".merge-input input#userIdForMerge").val("");

            // 注册事件
            regEvent();
        }

        // 取消合并
        function mergeCancel(){
            preValue = "";
        }

        // 确认合并
        function userMerge(){
            if(!$(".merge-user .fr p").text()){
                notice.warning("尚未选择要合并的用户");
                return;
            }

            var param = {
                userMergeId: USER_G.userId,
                userTargetId: $(".merge-input input#userIdForMerge").val()
            };

            $.post("<%=request.getContextPath()%>/userManageMongo/mergeUser", param, mergeCallBack, 'json');
        }

        function addDivForSelected(userName,userId,loginName,photoUrl){
            var html="<div><span>"+userName+"&lt;"+loginName+"&gt;"+"</span><span style='display:none;'>"+photoUrl+
                    "</span><span style='display:none;'>"+userId+"</span></div>";
            $(".merge-input div#forSelected").append(html);
        }

        // 根据value选择相应用户
        function selectUser(value){
            // 对应value用户是否存在标志
            var exist = false;

            // 遍历所有用户信息
            $(".merge-input div#forSelected div").each(function(){
                // 用户信息(用户名和邮箱)
                var text = $(this).find("span").eq(0).text().trim();
                if(text.indexOf(value) >= 0){
                    $(this).show();
                    exist = true;
                } else {
                    $(this).hide();
                }
            });

            if(!exist) {
                $(".merge-input div#forSelected").hide();
            } else {
                $(".merge-input div#forSelected").show();
            }
        }

        function makeBackColor(){
            $(".merge-input div#forSelected div").each(function(){
                $(this).mouseover(function(){
                    $(this).css("background-color","gray");
                });
                $(this).mouseout(function(){
                    $(this).css("background-color","");
                });
            });
        }

        /*
        * @desc 为每个元素绑定点击事件
        * */
        function makeClick(){
            // 事件委托
            $(".merge-input div#forSelected").on('click', 'div', function() {
                var loginName = "",
                    userName = "",
                    imgUrl = "",
                    userId = "",
                    text = "",
                    pre = -1;

                text = $(this).text();
                pre = text.indexOf("<");

                while(pre >= 0) {
                    if(text.substring(pre + 1).indexOf("<") >= 0) {
                        pre = pre + 1 + text.substring(pre+1).indexOf("<");
                    } else {
                        break;
                    }
                }

                loginName = text.substring(pre+1).split(">")[0];
                userName = text.substring(0,pre);
                imgUrl = $(this).find("span").eq(1).text();
                userId = $(this).find("span").eq(2).text();

                $(".merge-input div#forSelected").hide();
                $(".merge-input input").val(loginName);
                $(".merge-input input#userIdForMerge").val(userId);
                $(".merge-user .fr h4").html(userName);
                $(".merge-user .fr p").html("&lt;"+loginName+"&gt;");
                $(".merge-user .fr img").attr("src",imgUrl);
            });
        }

        function ordinaryBack(data) {
            if(data.success) {
                // 用户数据
                var users = data.rows,
                    // 可选择的用户(元素)
                    $selectedEle = $(".merge-input div#forSelected");

                if(users.length > 0){
                    var userId = 0,
                        loginName = "",
                        photoUrl = "",
                        userName = "";

                    // 清空可选用户区域
                    $selectedEle.empty();
                    for(var i = 0; i < users.length; i++){
                        userId = users[i].userId;
                        loginName = users[i].loginName;
                        photoUrl = users[i].photoUrl;
                        userName = users[i].userName;

                        addDivForSelected(userName, userId, loginName, photoUrl);
                    }

                    makeBackColor();
                    makeClick();

                    if(data.msg.length > 3){
                        selectUser(data.msg);
                    }else{
                        $selectedEle.show();
                    }
                }
            }else{
                if(data.msg){
                    notice.danger(data.msg);
                }else{
                    notice.danger("返回数据有错");
                }
            }
        }

        // 合并回调
        function mergeCallBack(data) {
            if(data.success){
                notice.success(data.msg);

                // 关闭当前标签页(用户详情tab)
                parent.closeThisTab();
            }else{
                notice.danger(data.msg);
            }
        }

        /*
        * @author Lesty
        * @codeDate 2016.7.13
        * @desc 注册事件
        * */
        function regEvent() {
            // 判断之前是否已经注册过事件，如果注册过了就跳过
            if(typeof arguments.callee.regFlag != 'string') {
                arguments.callee.regFlag = 'reg';

                // 根据输入的信息实时查找用户
                $("#user-search").on("input", function(){
                    // 消除输入信息的间隙
                    var value = this.value.split(" ").join(""),
                        // 可选择的用户(元素)
                        $selectedEle = $(".merge-input div#forSelected");

                    if(value.length > 1){
                        var start = value.substring(0,2);
                        if(preValue != start){
                            preValue = start;

                            // 隐藏
                            $selectedEle.hide().empty();

                            var param = {
                                "value": start,
                                "loginName": USER_G.loginName,
                                "all": value
                            };

                            $.post("<%=request.getContextPath()%>/userManageMongo/queryOrdinary", param, ordinaryBack, 'json');
                        } else {
                            selectUser(value);
                        }
                    } else {
                        $selectedEle.hide();
                    }
                });

                // 关闭窗口
                $('#mergeClose').on('click', function() {
                    mergeCancel();
                });

                // 取消合并
                $('#mergeCancel').on('click', function() {
                    mergeCancel();
                });

                // 确认合并
                $('#confirmMerge').on('click', function() {
                    userMerge();
                });
            }
        }

        return {
            init: init,
            regEvent: regEvent
        };
    })();
</script>

