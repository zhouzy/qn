<template>
    <div class="batch-statistics-table">
        <table class="table table-striped">
            <thead>
                <tr>
                    <th>批次名称</th>
                    <th>名单总数</th>
                    <th>分配员工数量</th>
                    <th>成单数</th>
                    <th>无效名单数</th>
                    <th>未呼通名单数</th>
                    <th>已拒绝名单数</th>
                    <th>需跟进名单数</th>
                </tr>
            </thead>
            <tbody>
                <tr v-for="batchInfo in statisticsList">
                    <td>{{batchInfo.batchName}}</td>
                    <td>{{batchInfo.totalAllot}}</td>
                    <td>{{batchInfo.totalServiceUser}}</td>
                    <td>{{batchInfo.totalDeal}}</td>
                    <td>{{batchInfo.totalInvalid}}</td>
                    <td>{{batchInfo.totalNotConnect}}</td>
                    <td>{{batchInfo.totalReject}}</td>
                    <td>{{batchInfo.totalFollowUp}}</td>
                </tr>
            </tbody>
            <tfoot>
            <tr>
                <td colspan="20">
                    <button class="btn btn-xs btn-raised btn-primary" @click="exportStatistic">导出批次统计</button>
                </td>
            </tr>
            </tfoot>
        </table>
    </div>
</template>

<script type="text/ecmascript-6">
    /**
     * @desc 批次统计table组件
     * @author Lesty,wly
     * @code-date 2017.4.22
     **/
    export default{
        name: 'BatchStatisticsTable',
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
                return this.$store.state.activityStatistics.batchStatisticsList;
            }
        },
        watch: {

        },
        methods: {
            // 导出批次统计
            exportStatistic: function () {
                let params = this.$store.state.activityStatistics.batchStatisticsQueryFields;
                this.axios({url: '/statistics/exportCountByBatch',
                    params: {
                    teleActivityId: params.activityId,
                    batchId: params.batchId
                }}).then(res => {
                    if (!res.data.success) {
                        return notice.danger(res.data.msg);
                    }
                    window.location.href = location.origin + res.data.rows;
                });
            }
        }
    }
</script>

<style lang="less" scoped>
    .batch-statistics-table {
        padding: 15px;
    }
</style>