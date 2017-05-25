<template>
    <div class="panel business-record__root">
        <div class="panel-heading list-detail__panel-heading">
            <strong>业务记录</strong>
        </div>

        <div class="panel-body">
            <div class="form-horizontal">
                <!--选项区域-->
                <div class="row business-record__section-box">
                    <div class="col-sm-3">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">业务状态:</label>
                            <div class="col-sm-8">
                                <select name="businessStatus" class="form-control" v-model="contentFormData.businessStatus">
                                    <option v-for="(desc, status) in businessStatusMap" :value="status">{{desc}}</option>
                                </select>
                            </div>
                        </div>
                    </div>

                    <div class="col-sm-3">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">保存操作:</label>
                            <div class="col-sm-8" style="margin-top: 5px">
                                <div class="checkbox">
                                    <label style="font-size: 12px;color: #646464;">
                                        <!--业务状态为预约回呼时，将该checkbox设为不可操作并默认勾选-->
                                        <input type="checkbox"
                                               v-model="isSaveAsReserve"
                                               true-value="1"
                                               false-value="0"
                                               :disabled="contentFormData.businessStatus === '2'"
                                               style="margin-right: 4px;">保存为预约回呼
                                    </label>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-sm-3">
                        <div v-show="isSaveAsReserve === '1'">
                            <input name="reserveTime" v-model="reserveTime" data-label="预约时间:">
                        </div>
                    </div>

                    <div class="col-sm-3 text-right">
                        <div class="col-sm-12">
                            <button class="btn btn-raised btn-xs btn-primary" @click.prevent="saveContent">保存</button>
                        </div>
                    </div>
                </div>

                <!--沟通小结-->
                <div class="row business-record__section-box">
                    <div class="col-sm-12">
                        <label class="col-sm-1">沟通小结:</label>

                        <div class="col-sm-11">
                            <textarea name="content"
                                      class="business-record__field-ctrl"
                                      placeholder="请输入沟通小结···"
                                      v-model="contentFormData.content"
                                      rows="4"></textarea>
                        </div>
                    </div>

                    <div class="col-sm-12" v-if="isReserveCall">
                        <div class="col-sm-offset-1 col-sm-11">
                            <div class="checkbox">
                                <label>
                                    <input type="checkbox"
                                           v-model="isSetStatusOver"
                                           true-value="1"
                                           false-value="0"
                                           style="margin-right: 4px;">此通话为<strong style="color: #000;">预约回呼</strong>，设置预约回呼状态为完成
                                </label>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <block-loading loading-desc="保存中···" ref="blockLoading"></block-loading>
    </div>
</template>

<script type="text/ecmascript-6">
    // loading遮罩层组件
    import BlockLoading from '@/lib-components/block-loading.vue';
    import querystring from 'querystring';

    /**
     * @desc 业务记录组件
     * @author Lesty
     * @code-date 2017.3.24
     **/
    export default {
        name: 'BusinessRecord',
        props: {
            // 名单ID
            namesId: {
                required: true
            },
            // 联络历史ID
            contactHistoryId: {
                required: true
            },
            // 预约回呼id
            reserveId: {
                default: ''
            }
        },
        created: function() {
            // 判断是否为预约回呼
            if(this.reserveId !== '') {
                this.isReserveCall = true;
                this.isSetStatusOver = '1';
            }
        },
        mounted: function () {
            let _my = this;

            $('input[name=reserveTime]').timeInput({
                HMS: true,
                format: 'yyyy-MM-dd hh:mm:ss',
                value: this.reserveTime,
                change: function () {
                    _my.reserveTime = this.$element.val();
                }
            });
        },
        data: function() {
            return {
                // 是否保存为预约回呼
                isSaveAsReserve: '0',
                // 是否设置回呼状态为完成
                isSetStatusOver: '0',
                // 是否为预约回呼弹屏
                isReserveCall: false,
                // 预约时间
                reserveTime: '',
                businessStatusMap: window.ACT_CONFIG.BUSINESS_STATUS_MAP,
                contentFormData: {
                    namesId: this.namesId,
                    commId: this.contactHistoryId,
                    // 沟通小结
                    content: '',
                    // 业务状态
                    businessStatus: '0'
                }
            };
        },
        computed: {
            // 最初的字段数据(后台发过来的数据，前端没进行过值改变)
            initFieldsMap: function () {
                return this.$store.state.initFieldsMap;
            },
            // 业务状态(中间变量)
            tempBusinessStatus: function() {
                return this.contentFormData.businessStatus;
            }
        },
        watch: {
            initFieldsMap: {
                handler: function (newVal) {
                    // 状态和编辑面板同步
                    this.contentFormData.businessStatus = newVal.result;
                },
                deep: true
            },
            tempBusinessStatus: function(newVal) {
                this.reserveTime = '';

                // 业务状态为预约回呼，则自动勾选保存为预约回呼checkbox
                // 否则取消勾选
                if(newVal === '2') {
                    this.isSaveAsReserve = '1';
                } else {
                    this.isSaveAsReserve = '0';
                }
            }
        },
        methods: {
            // 检测预约时间是否合法
            isTimeIllegal: function (time) {
                let curTime = +new Date();
                let reserveTime = +new Date(time);
                let endTime = +new Date(this.initFieldsMap.endTime);

                // 预约时间必须晚于当前时间(这里弄了1分钟，避免误差)
                // 预约时间必须早于活动截止时间
                return (reserveTime - curTime > 60 * 1000) && (reserveTime < endTime);
            },
            // 重置表单
            resetForm: function() {
                this.reserveTime = '';

                if(this.contentFormData.businessStatus !== '2') { // 如果不是预约回呼，则清空勾选状态
                    this.isSaveAsReserve = '0';
                }
            },
            // 保存沟通小结
            saveContent: function() {
                if(this.isSaveAsReserve === '1') { // 检测预约时间是否合法
                    if(this.reserveTime === '') {
                        notice.warning('预约时间不能为空！');
                        return;
                    }

                    if(!this.isTimeIllegal(this.reserveTime)) {
                        notice.warning('预约时间必须晚于当前时间并且早于活动截止时间(' + this.initFieldsMap.endTime + ')！');
                        return;
                    }
                }

                let param = _.extend({}, this.contentFormData, {
                    isRecall: this.isSaveAsReserve,
                    appointmentTime: this.reserveTime,
                    appointmentId: this.reserveId,
                    isStatusOver: ''
                });

                // 如果预约id不为空(预约回呼)，则修改预约状态(已完成/未完成)
                if(param.appointmentId !== '') {
                    param.isStatusOver = this.isSetStatusOver;
                }

                // 显示loading
                this.$refs.blockLoading.$emit('load-show');
                this.axios.post('/teleCommunicate/saveContent', querystring.stringify(param)).then(res => {
                    let data = res.data;
                    if(!data.success) {
                        return Promise.reject(new Error(data.msg));
                    }

                    // 刷新联络历史
                    this.$parent.$refs.linkHistory.updatePager();

                    notice.success('保存成功！');
                    // 重置表单
                    this.resetForm();

                    // 同步更新vuex里的数据
                    this.$store.commit('SET_ORIGIN_MAP', {
                        key: 'result',
                        value: this.businessStatusMap[param.businessStatus]
                    });
                    this.$store.commit('SET_INIT_MAP', {
                        key: 'result',
                        value: param.businessStatus
                    });
                }).then(() => {
                    // 如果存在预约id(预约回呼)，就会修改预约状态(已完成/未完成)，需要刷新预约信息
                    // 如果保存为预约回呼(新增操作)，也需要刷新预约信息
                    // 其他情况不刷新(优化)
                    if(param.isRecall === '1' || param.appointmentId !== '') {
                        this.$store.dispatch('getReserveList', {
                            param: {
                                namesId: this.namesId
                            },
                            page: 1,
                            pageSize: 10
                        });
                    }
                }).catch(error => {
                    notice.danger(error.message);
                }).finally(() => {
                    // 隐藏loading
                    this.$refs.blockLoading.$emit('load-hide');
                });

            }
        },
        components: {BlockLoading}
    }
</script>

<style lang="less" scoped>
    @import "../less/listDetail.less";
    @import "../less/businessRecord.less";
</style>