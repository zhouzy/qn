<template>
    <div class="tab-content-link-history">
        <!--新增预约弹窗-->
        <div id="newReserve" class="modal fade">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" @click="resetNewReserveForm" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                        <strong class="modal-title">预约回访</strong>
                    </div>
                    <div class="modal-body">
                        <form class="form-horizontal">
                            <div class="row">
                                <div class="col-sm-10">
                                    <input id="newReserveTime" v-model="newReserveTime" name="newReserveTime" type="text" class="form-control" data-label="预约时间">
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-sm-10">
                                    <div class="form-group">
                                        <label for="newReserveReason" class="col-sm-4 control-label">预约原因</label>

                                        <div class="col-sm-8">
                                            <textarea id="newReserveReason" v-model="newReserveReason" name="newReserveReason" class="form-control" rows="3"></textarea>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </form>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-raised btn-default btn-sm" @click="resetNewReserveForm" data-dismiss="modal">取消</button>
                        <button type="button" class="btn btn-raised btn-primary btn-sm" @click="submitNewReserveFrom">预约</button>
                    </div>
                    <block-loading loading-desc="保存预约信息···" ref="blockLoading"></block-loading>
                </div>
            </div>
        </div>
        <!--按钮操作区域-->
        <div class="row">
            <div class="col-sm-12">
                <a class="btn btn-sm btn-raised btn-primary"
                   data-toggle="modal"
                   v-if="isCallScreen"
                   data-target="#newReserve">新增预约
                </a>
            </div>
        </div>
        <!--预约信息列表-->
        <table class="table grid table-striped">
            <thead>
            <tr>
                <th>预约时间</th>
                <th>活动名称</th>
                <th>电话号码</th>
                <th>创建人</th>
                <th>创建时间</th>
                <th>联系时间</th>
                <th>预约状态</th>
                <th>预约原因</th>
            </tr>
            </thead>
            <tbody>
            <tr v-for="item in reserveList">
                <td>{{item.appointmentTime}}</td>
                <td>{{item.activityName}}</td>
                <td>{{item.protectNum}}</td>
                <td>{{item.creatorName}}</td>
                <td>{{item.createTime}}</td>
                <td>{{item.contactTime}}</td>
                <td>{{RESERVATION_STATUS_MAP[item.status]}}</td>
                <td>{{item.reason}}</td>
            </tr>
            </tbody>
            <tfoot>
                <tr>
                    <td colspan="20" v-show="reserveList.length > 0">
                        <div id="reservePagination" class="pull-right"></div>
                    </td>
                </tr>
            </tfoot>
        </table>

        <p class="text-center" v-if="reserveList.length === 0">预约信息空空如也~</p>
    </div>
</template>
<script type="text/ecmascript-6">
    // loading遮罩层组件
    import BlockLoading from '@/lib-components/block-loading.vue';
    import querystring from 'querystring';

    export default {
        name: 'TabContentReservationList',
        props: {
            customId: {
                required: true
            },
            // 是否为弹屏
            isCallScreen: {
                default: false
            }
        },
        mounted: function () {
            let $input = $('#newReserveTime');
            $input.timeInput({
                format: 'yyyy-MM-dd hh:mm:ss',
                HMS: true,
                value: this.newReserveTime,
                change: () => {
                    this.newReserveTime = $input.val();
                }
            });

            // 初始化分页控件
            let pager = new cri.Pager($('#reservePagination'), {
                page: 1,
                pageSize: 10,
                onPage: (page, pageSize) => {
                    this.getReserveList(this.queryReserveParamCache, page, pageSize);
                }
            });
            // 初始化预约信息列表pager组件
            this.$store.commit('INIT_RESERVE_PAGER', pager);
        },
        data: function() {
            return {
                // 新增预约时间
                newReserveTime: '',
                // 新增预约原因
                newReserveReason: '',
                // 预约状态对照表
                RESERVATION_STATUS_MAP: window.ACT_CONFIG.RESERVATION_STATUS_MAP,
                // 查询预约信息的参数缓存
                queryReserveParamCache: {}
            };
        },
        watch: {
            customId: function (newVal) {
                if(newVal !== '') {
                    // 初始化预约信息列表
                    this.getReserveList({
                        customId: this.customId
                    }, 1, 10);
                }
            }
        },
        computed: {
            // 活动截止时间
            activityEndTime: function() {
                return this.$store.state.initFieldsMap.endTime;
            },
            // 预约信息列表
            reserveList: function () {
                return this.$store.state.reserveList;
            }
        },
        methods: {
            // 检测预约时间是否合法
            isTimeIllegal: function (time) {
                let curTime = +new Date();
                let reserveTime = +new Date(time);
                let endTime = +new Date(this.activityEndTime);

                // 预约时间必须晚于当前时间(这里弄了1分钟，避免误差)
                // 预约时间必须早于活动截止时间
                return (reserveTime - curTime > 60 * 1000) && (reserveTime < endTime);
            },
            // 重置新增预约表单
            resetNewReserveForm: function() {
                this.newReserveTime = '';
                this.newReserveReason = '';
            },
            // 新增预约表单
            submitNewReserveFrom: function () {
                // 表单验证
                if(this.newReserveTime === '') { // 不能为空
                    notice.warning('预约时间不能为空！');
                    return;
                } else if(!this.isTimeIllegal(this.newReserveTime)) { // 检测预约时间是否合法
                    notice.warning('预约时间必须晚于当前时间并且早于活动截止时间(' + this.activityEndTime + ')！');
                    return;
                }

                // 显示loading
                this.$refs.blockLoading.$emit('load-show');
                this.axios.post('/appointment/addAppointment', querystring.stringify({
                    appointmentTime: this.newReserveTime,
                    reason: this.newReserveReason,
                    namesId: this.$store.state.initFieldsMap.namesId,
                    teleActivityId: this.$store.state.initFieldsMap.teleActivityId
                })).then(res => {
                    let data = res.data;
                    if(!data.success) {
                        return Promise.reject(new Error(data.msg));
                    }

                    notice.success('成功新增预约！');
                    $('#newReserve').modal('hide');
                    this.resetNewReserveForm();
                }).then(() => {
                    this.getReserveList({
                        customId: this.customId
                    }, 1, 10);
                }).catch(error => {
                    notice.danger(error.message);
                }).finally(() => {
                    // 隐藏loading
                    this.$refs.blockLoading.$emit('load-hide');
                });
            },
            // 获取预约信息列表
            getReserveList: function(param, page = 1, pageSize = 10) {
                // 缓存参数
                this.queryReserveParamCache = param;

                this.$store.dispatch('getReserveList', {
                    param,
                    page,
                    pageSize
                }).catch(error => {
                    notice.danger(error.message);
                });
            }
        },
        components: {
            BlockLoading
        }
    }
</script>