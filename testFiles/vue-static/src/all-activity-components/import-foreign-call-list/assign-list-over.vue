<template>
    <div class="assign-list-over">
        <pageHeader>
            <!--将顶部区域附加内容通过具名slot进行分发-->
            <div slot="topContent">
                完成<strong slot="topContent">{{activityName}}</strong>活动名单导入
            </div>
        </pageHeader>

        <div class="container-fluid assign-list-over__main">
            <div class="panel assign-list-over__panel">
                <div class="row" style="text-align: center;">
                    <div class="col-sm-offset-3 col-sm-6">
                        <p>
                            <i class="fa fa-check-circle assign-list-over__over-icon" aria-hidden="true"></i>
                            <strong>{{activityName}}</strong>活动名单分配完成
                        </p>
                        <p>执行者总数：<strong style="color: #a94442;">{{executorList.length}}</strong></p>
                        <p>分配名单总数：<strong style="color: #a94442;">{{assignedListAmount}}</strong></p>

                        <hr>

                        <ul class="assign-list-over__executor-lists">
                            <li class="row">
                                <strong class="col-sm-offset-1 col-sm-4">执行者</strong>
                                <strong class="col-sm-offset-2 col-sm-4">分配名单数量</strong>
                            </li>
                            <li class="row assign-list-over__executor-lists-item"
                                v-for="executor in executorList">
                                <span class="col-sm-offset-1 col-sm-4">{{executor.userName}}</span>
                                <span class="col-sm-offset-2 col-sm-4">{{executor.num}}</span>
                            </li>
                        </ul>
                    </div>
                </div>

                <div class="row" style="text-align: center;">
                    <div class="col-sm-offset-3 col-sm-6">
                        <a class="btn btn-sm btn-raised btn-primary" href="#/control">完成</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>
<script type="text/ecmascript-6" lang="babel">
    // 页面顶部标题组件
    import pageHeader from '../../lib-components/page-header.vue';

    export default{
        created: function () {

        },
        data: function () {
            return {
                // 活动ID
                activityId: this.$store.state.allActivity.checkSelect,
                // 活动名称
                activityName: this.$store.state.allActivity.activityDetails.activityName,
                // 执行者列表
                executorList: this.$store.state.allActivity.executorList
            }
        },
        computed: {
            assignedListAmount: function() {
                let sum = 0;
                this.executorList.forEach((item) => sum += +item.num);

                return sum;
            }
        },
        methods: {

        },
        components: {pageHeader}
    }
</script>
<style lang="less" rel="stylesheet/less" scoped>
    /*btn-sm的高度*/
    @btn-sm-height: 28px;
    
    .assign-list-over {
        height: 100%;
        overflow: auto;
    }

    .assign-list-over__main {
        margin-top: 10px;
    }

    .assign-list-over__panel {
        padding: 15px;
        overflow: hidden;
    }

    .assign-list-over__over-icon {
        margin-right: 6px;

        font-size: 22px;
        color: #4caf50;
        vertical-align: middle;
    }

    .assign-list-over__executor-lists {
        padding-left: 0;
        list-style-type: none;
    }

    .assign-list-over__executor-lists-item {
        padding: 6px 0;
    }

    .assign-list-over__executor-lists-item:hover {
        background-color: #f5f5f5;
    }
</style>
