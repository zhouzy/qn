<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div id="assignAgent" class="modal fade bs-example-modal-sm" data-backdrop="static">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <span class="modal-title">分配归属组</span>
            </div>
            <div class="modal-body" id="agentGroup"></div>
            <div class="modal-footer">
                <button type="button" class="btn btn-raised btn-default btn-sm" data-dismiss="modal">取消</button>
                <button type="button" class="btn btn-raised btn-primary btn-sm" id="assignSubmit">提交</button>
            </div>
        </div>
    </div>
</div>
<script>
    var assignAgentModal = function(){
        /**
         * 分配客服组
         */
        $("#assignSubmit").click(function (){
            var newGroupId = [];
            var userId = USER_G.userId;
            var agentId = USER_G.loginName;
            var creatorId = "${creatorId}";
            var creatorName = "${creatorName}";
            $("#agentGroup input[type=checkbox]:checked").each(function() {
                newGroupId.push($(this).attr("id"));
            });

            if(groupId || newGroupId){
                $.post("<%=request.getContextPath()%>/usrManage/assignAgent?groupId="+groupId+"&newGroupId="+newGroupId+
                        "&agentId="+agentId+"&creatorId="+creatorId+"&creatorName="+creatorName+"&userId="+userId, assignCallBack, 'json');
            }
            else{
                $("#assignAgent").modal('hide');
            }
        });

        /**
         * 分配客服组回调函数
         */
        function assignCallBack(data){
            if(data.success){
                notice.success("分配归属组成功!");
                $("#assignAgent").modal('hide');

                /* 查询所属客服组 */
                Group.init();
            }else{
                notice.danger(data.msg);
            }
        }


        return {
            render:function(groupId,agentGroupList){
                var $agentGroup = $("#agentGroup").empty();
                var l = agentGroupList.length;
                var checkbox = [];
                for(var i=0;i<l;i++){
                    var agentGroup = agentGroupList[i];
                    var el='<label class="checkbox-inline"><input type="checkbox" name="'+agentGroup.groupName+'" id="'+agentGroup.groupId+'">'+agentGroup.groupName+'</label>';
                    for(var j=0;j<groupId.length;j++){
                        if(agentGroup.groupId==groupId[j]){
                            el='<label class="checkbox-inline"><input type="checkbox" checked=true name="'+agentGroup.groupName+'" id="'+agentGroup.groupId+'">'+agentGroup.groupName+'</label>';
                        }
                    }
                    checkbox.push(el);
                }
                $agentGroup.append(checkbox);
            }
        };
    }();
</script>