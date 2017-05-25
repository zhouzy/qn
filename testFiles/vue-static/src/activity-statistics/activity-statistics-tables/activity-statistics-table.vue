<template>
    <div class="activity-statistics-table">
        <table class="table table-striped">
            <thead>
                <tr>
                    <th>活动名称</th>
                    <th>开始时间</th>
                    <th>结束时间</th>
                    <th>名单总量</th>
                    <th>分配员工数量</th>
                    <th>外呼数</th>
                    <th>接通数</th>
                    <th>成单总量</th>
                    <th>成单率</th>
                </tr>
            </thead>
            <tbody>
                <tr v-for="activityInfo in statisticsList">
                    <td>{{activityInfo.activityName}}</td>
                    <td>{{activityInfo.startTime || '-'}}</td>
                    <td>{{activityInfo.endTime || '-'}}</td>
                    <td>{{activityInfo.namesTotal}}</td>
                    <td>{{activityInfo.distributeServiceTotal}}</td>
                    <td>{{activityInfo.callNumTotal}}</td>
                    <td>{{activityInfo.connectTotal}}</td>
                    <td>{{activityInfo.namesOrderTotal}}</td>
                    <td>{{getOrderSuccessRate(activityInfo.namesOrderTotal, activityInfo.namesTotal)}}</td>
                </tr>
            </tbody>
            <tfoot>
                <tr>
                    <td colspan="20">
                        <button class="btn btn-xs btn-raised btn-primary" @click="exportStatistic">导出活动统计</button>
                    </td>
                </tr>
            </tfoot>
        </table>
    </div>
</template>

<script type="text/ecmascript-6">
    /**
     * @desc 活动统计table组件
     * @author Lesty,wly
     * @code-date 2017.4.22
     **/
    export default{
        name: 'ActivityStatisticsTable',
        created:function () {

        },
        mounted:function(){

        },
        data:function () {
            return {

            }
        },
        computed: {
            statisticsList: function() {
                return this.$store.state.activityStatistics.activityStatisticsList;
            }
        },
        watch: {

        },
        methods:{
            // 获取成功接单率(成单总数/名单总数)
            getOrderSuccessRate: function(orderSuccessMount, namesTotal) {
                orderSuccessMount = parseInt(orderSuccessMount, 10);
                namesTotal = parseInt(namesTotal, 10);
                // 如果名单总数是0，成单率设为0
                if(namesTotal === 0) {
                    return '0%';
                }

                return ((orderSuccessMount/namesTotal) * 100).toFixed(2) + '%';
            },
            // 导出活动统计
            exportStatistic: function () {
                let params = this.$store.state.activityStatistics.activityStatisticsQueryFields;
                this.axios({url: '/statistics/ExportActivitiesStatistics',
                    params: {
                        teleActivityId: params.activityId,
                        startTime: params.startTime,
                        endTime: params.endTime
                    }}).then(res => {
                    if (!res.data.success) {
                        return notice.danger(res.data.msg);
                    }
                    window.location.href = location.origin +res.data.rows;
                });
            }
        }
    }
</script>

<style lang="less" scoped>
    .activity-statistics-table{
        padding: 15px;
    }
</style>