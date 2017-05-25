/**
 * 添加预约弹出面板
 * 中余
 * 2017/5/7 15:30
 */
<template>
    <div id="addReservationModal" class="modal fade">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" @click="cancelAdd" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <strong class="modal-title">添加预约回访</strong>
                </div>
                <div class="modal-body">
                    <form class="form-horizontal" onsubmit="return false;">
                        <div class="row">
                            <div class="col-sm-10">
                                <input name="reserveTime" type="text" class="form-control" data-label="预约时间">
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-sm-10">
                                <div class="form-group">
                                    <label class="col-sm-4 control-label">预约原因</label>
                                    <div class="col-sm-8">
                                        <textarea v-model="reason" name="newReserveReason" class="form-control" rows="3"></textarea>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-raised btn-default btn-sm" @click="cancelAdd">取消</button>
                    <button type="button" class="btn btn-raised btn-primary btn-sm" @click="doAdd">添加</button>
                </div>
            </div>
        </div>
    </div>
</template>
<script type="text/ecmascript-6">
    import config from '../lib-js/config';
    export default{
        props : ['isOpen'],
        data : function(){
            return {
                reserveTime : "",
                reason : ""
            }
        },
        mounted : function(){
            var that = this;
            $("#addReservationModal").modal({show:false});
            $("#addReservationModal").find('input[name=reserveTime]').timeInput({
                HMS : true,
                format : 'yyyy-MM-dd HH:mm:ss',
                change : function(){
                    that.reserveTime = this.$element.val();
                }
            });
        },
        methods : {
            show : function(){
                $("#addReservationModal").modal('show');
            },
            hide : function(){
                $("#addReservationModal").modal('hide');
            },
            cancelAdd : function(){
                this.$emit('cancelAdd');
            },
            reset : function(){
                $("#addReservationModal").find('input[name=reserveTime]').val("");
                this.reason = "";
                this.reserveTime = "";
            },

            doAdd : function(){
                if(!this.reserveTime){
                    notice.danger("请指定预约时间!");
                    return;
                }
                else if(this.reserveTime <= cri.formatDate(new Date(),'yyyy-MM-dd HH:mm:ss')){
                    notice.danger("预约时间必须在当前时间之后!");
                    return;
                }
                else{
                    this.$emit('doAdd',{
                        reserveTime : this.reserveTime,
                        reason      : this.reason
                    });
                }
            }
        },
        watch : {
            "isOpen" : function(){
                if(this.isOpen){
                    this.show();
                    this.reset();
                }
                else{
                    this.hide();
                }
            }
        }
    }
</script>
