<template>
    <div class="assign-list">
        <pageHeader>
            <!--将顶部区域附加内容通过具名slot进行分发-->
            <div slot="topContent">
                为<strong slot="topContent">{{activityName}}</strong>活动分配名单
            </div>
        </pageHeader>

        <div class="container-fluid assign-list__main">
            <div class="panel assign-list__panel">
                <div class="row">
                    <div class="col-sm-offset-1 col-sm-11">
                        <div class="row">
                            <div class="col-sm-2">活动名称：</div>
                            <p class="col-sm-4">{{activityName}}</p>
                        </div>
                        <div class="row">
                            <div class="col-sm-2">活动描述：</div>
                            <p class="col-sm-5" style="margin-bottom: 0">{{activityDesc}}</p>
                        </div>
                        <hr>
                        <div class="row">
                            <div class="col-sm-12">要参加分配的批次：</div>
                            <div class="col-sm-12 assign-list__batch-list">
                                <!--批次数量大于0则显示-->
                                <label class="assign-list__batch-list-item assign-list__font-weight-normal"
                                       v-for="batch in toAssignedBatchesArr"
                                       v-if="batch.totalUnAllot > 0">
                                    <input type="checkbox" v-model="selectedBatchesArr" :value="batch.batchId" @change="changeSelectedListCount($event, batch.totalUnAllot)">
                                    <span class="assign-list__batch-name">{{batch.batchName}}({{batch.totalUnAllot}})</span>
                                </label>
                            </div>
                            <div class="col-sm-12">已选中名单客户总数：<strong style="color: #4caf50;">{{selectedListCount}}</strong></div>
                        </div>

                        <hr>

                        <div class="row">
                            <div class="col-sm-12" style="margin-bottom: 10px;">
                                <span class="assign-list__title-to-middle" style="margin-right: 20px;">分配后剩余名单数量：<strong style="color: #a94442;">{{remainListCount}}</strong></span>
                                <button class="btn btn-xs btn-raised btn-info assign-list__margin__reset" @click.prevent="equallyDistributed">平均分配</button>
                            </div>
                            <div class="col-sm-12">执行者列表({{executorList.length}})：</div>
                            <div class="col-sm-4">
                                <ul class="assign-list__remain-list-of-lists">
                                    <li class="row">
                                        <label class="col-sm-offset-1 col-sm-4 assign-list__font-weight-normal">执行者</label>
                                        <label class="col-sm-offset-2 col-sm-4 assign-list__font-weight-normal">分配数量</label>
                                    </li>
                                    <li class="row assign-list__remain-list-of-lists-item"
                                        v-for="executor in executorList">
                                        <label class="col-sm-offset-1 col-sm-4 assign-list__remain-list-name assign-list__font-weight-normal">{{executor.userName}}</label>
                                        <div class="col-sm-offset-2 col-sm-4">
                                            <input class="assign-list__remain-list-input assign-list__font-weight-normal"
                                                   type="number"
                                                   min="0"
                                                   :max="executor.num + remainListCount"
                                                   v-model.number="executor.num">
                                        </div>
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-sm-6">
                        <a class="btn btn-sm btn-raised assign-list__margin__reset" href="#/control">取消</a>
                    </div>
                    <div class="col-sm-6 text-right">
                        <button class="btn btn-sm btn-raised btn-primary assign-list__margin__reset" @click.prevent="submitAssignedList">分配名单</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>
<script type="text/ecmascript-6">
    // 页面顶部标题组件
    import pageHeader from '../../lib-components/page-header.vue';
    import {mapActions} from 'vuex';

    export default{
        created: function () {
            // 获取活动详情
            this.getActivityDetails(this.activityId).then((activityDetails) => {
                this.activityName = activityDetails.activityName;
                this.activityDesc = activityDetails.activityDescrible;
            }).catch(error => {
                notice.danger('getActivityDetails请求出错：' + error);
            });
            // 获取执行者列表
            this.getExecutorList();
            let self = this;
            this.axios({
                url: '/names/queryUnAllotBatchs',
                params: {
                    teleActivityId: self.activityId
                }
            }).then(function (res) {
                self.toAssignedBatchesArr = res.data.rows;
            });
        },
        data: function () {
            return {
                // 活动ID
                activityId: this.$store.getters.activityId,
                // 活动名称
                activityName: '',
                // 活动描述
                activityDesc: '',
                // 参加分配的批次
                toAssignedBatchesArr: [],
                // 已选中的批次
                selectedBatchesArr: [],
                // 已选中名单总量
                selectedListCount: 0,
                // 执行者列表
                executorList: []
            }
        },
        computed: {
            // 剩余名单数量
            remainListCount: function () {
                let result = this.selectedListCount - this.hasAssignedListCount;

                return result;
            },
            // 已分配名单数量
            hasAssignedListCount: function () {
                let sum = 0;
                this.executorList.forEach(item => sum += +item.num);

                return sum;
            }
        },
        methods: {
            ...mapActions(['getActivityDetails']),
            // 获取执行者列表
            getExecutorList: function() {
                this.axios.get('/exeUser/findExeUserList', {
                    params: {
                        teleActivityId: this.activityId
                    }
                }).then(res => {
                    let data = res.data;
                    if(!data.success) {
                        notice.danger(data.msg);
                        return;
                    }

                    let rows = data.rows || [];

                    // 获取执行者列表
                    this.executorList = rows.map(item => {
                        return {
                            userId: item.userId,
                            num: 0,
                            userName: item.userName,
                            groupId: item.groupId,
                            groupName: item.groupName
                        };
                    });
                }).catch(error => {
                    notice.danger('[findActivityDetail]请求出错：' + error);
                });
            },
            // 修改已选中名单总量(增加/减少)
            changeSelectedListCount: function (event, count) {
                count = parseInt(count, 10);

                // 根据选中状态，增减名单总量
                if(event.target.checked === true) { // 增加
                    this.selectedListCount += count;
                } else { // 减少
                    this.selectedListCount -= count;
                }
            },
            // 平均分配名单总量
            equallyDistributed: function() {
                // 没有选中批次，则清空
                if(this.selectedListCount <= 0) {
                    this.executorList.forEach(item => item.num = 0);
                    return;
                }

                // 执行者列表长度
                let len = this.executorList.length;
                // 平均值
                let average = Math.floor(this.selectedListCount / len);
                // 余数
                let remainder = this.selectedListCount % len;

                // 如果已选中名单总数少于执行者数量(平均值向下取整为0)
                if(average === 0) {
                    // 从前往后依次分配1个，直到分配结束为止
                    this.executorList.forEach((item, index) => {
                        item.num = index > (this.selectedListCount - 1) ? 0 : 1;
                    });

                    return;
                }

                this.executorList.forEach((item, index) => {
                    item.num = index < remainder ? average + 1 : average;
                });
            },
            // 提交已分配名单
            submitAssignedList: function () {
                if(this.selectedBatchesArr.length === 0) {
                    notice.warning('请选择至少一个批次用于分配名单！');
                    return;
                }

                if(this.remainListCount < 0) {
                    notice.warning('分配名单总数超出已选中名单总数！');
                    return;
                } /*else if(this.remainListCount > 0) {
                    notice.warning('已选中批次名单数量必须全部分配！'); // 可以不全部分配，若需要全部分配则取消注释
                    return;
                }*/

                // 如果分配数量为空，则转换为0
                this.executorList.map(function (item) {
                   if(item.num ===''){
                       item.num = 0;
                   }
                });
                let params = {
                    batchIds: JSON.stringify(this.selectedBatchesArr),
                    userList: JSON.stringify(this.executorList),
                    teleActivityId: this.activityId
                };

                this.axios.post('/allotNames/allot', params).then(res => {
                    let data = res.data;
                    if(!data.success) {
                        notice.danger(data.msg);
                        return;
                    }

                    // 覆盖执行者名单列表
                    this.$store.commit('COVER_EXECUTOR_LIST', {
                        executorList: this.executorList
                    });

                    location.hash = '#/control/import-foreign-call-list/assign-list-over';
                }).catch(error => {
                    notice.danger('[findActivityDetail]请求出错：' + error);
                });
            }
        },
        components: {pageHeader}
    }
</script>
<style lang="less" scoped>
    /*btn-xs的高度*/
    @btn-xs-height: 26px;
    
    .assign-list {
        height: 100%;
        overflow: auto;
    }

    .assign-list__main {
        margin-top: 10px;
    }

    .assign-list__panel {
        padding: 15px;
        overflow: hidden;
    }

    .assign-list__batch-list {
        margin: 10px 0;
    }

    .assign-list__batch-list-item {
        margin-right: 20px;
        cursor: pointer;
    }

    .assign-list__batch-name {
        display: inline-block;
        width: 80px;

        color: #03a9f4;
        vertical-align: text-top;
        word-break: break-all;
    }

    .assign-list__title-to-middle {
        height: @btn-xs-height;
        line-height: @btn-xs-height;
    }

    .assign-list__margin__reset {
        margin: 0;
    }

    .assign-list__font-weight-normal {
        font-weight: normal;
    }
    
    .assign-list__remain-list-of-lists {
        padding-left: 0;
        list-style-type: none;
    }

    .assign-list__remain-list-of-lists-item {
        padding: 6px 0;
    }

    .assign-list__remain-list-of-lists-item:hover {
        background-color: #f5f5f5;
    }

    .assign-list__remain-list-name {
        word-break: break-all;
    }

    .assign-list__remain-list-input {
        padding-left: 6px;
        width: 50px;

        border: 1px solid #c8c8c8;
        border-radius: 4px;
    }

    .assign-list__remain-list-input:invalid {
        border-color: #C00000;
    }
</style>
