<template>
    <div class="personal-performance-table">
        <table class="table table-striped">
            <thead>
                <tr>
                    <th>员工名称</th>
                    <th>开始时间</th>
                    <th>结束时间</th>
                    <th>名单总量</th>
                    <th>外呼数</th>
                    <th>接通数</th>
                    <th>接通率</th>
                    <th>成单数</th>
                    <th>成单率</th>
                    <!--<th>总通话时长</th>-->
                </tr>
            </thead>
            <tbody>
                <tr v-for="activityInfo in statisticsList">
                    <td>{{activityInfo.serviceName || '未知员工'}}</td>
                    <td>{{activityInfo.startTime || '-'}}</td>
                    <td>{{activityInfo.endTime || '-'}}</td>
                    <td>{{activityInfo.namesTotal}}</td>
                    <td>{{activityInfo.callNumTotal}}</td>
                    <td>{{activityInfo.connectTotal}}</td>
                    <td>{{getRate(activityInfo.connectTotal, activityInfo.callNumTotal)}}</td>
                    <td>{{activityInfo.namesOrderTotal}}</td>
                    <td>{{getRate(activityInfo.namesOrderTotal, activityInfo.namesTotal)}}</td>
                </tr>
            </tbody>
            <tfoot>
            <tr>
                <td colspan="20">
                    <button class="btn btn-xs btn-raised btn-primary" @click="exportStatistic">导出个人业绩</button>
                </td>
            </tr>
            </tfoot>
        </table>
    </div>
</template>

<script type="text/ecmascript-6">
    /**
     * @desc 个人业绩统计table组件
     * @author Lesty,wly
     * @code-date 2017.4.25
     **/
    export default{
        name: 'PersonalPerformanceTable',
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
                return this.$store.state.activityStatistics.personalPerformanceList;
            }
        },
        watch: {

        },
        methods:{
            // 获取**率(成单率:成单总数/名单总数, 接通率:接通数/外呼数)
            getRate: function(successMount, total) {
                successMount = parseInt(successMount, 10);
                total = parseInt(total, 10);
                // 对总数为0做特殊处理
                if(total === 0) {
                    return '0%';
                }

                return ((successMount/total) * 100).toFixed(2) + '%';
            },
            // 导出个人业绩统计
            exportStatistic: function () {
                let params = this.$store.state.activityStatistics.personalPerformanceQueryFields;
                this.axios({url: '/statistics/ExportServiceUserStatistics',
                    params: {
                        teleActivityId: params.activityId,
                        serviceId: params.serviceId,
                        startTime: params.startTime,
                        endTime: params.endTime
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
    .personal-performance-table {
        padding: 15px;
    }
</style>