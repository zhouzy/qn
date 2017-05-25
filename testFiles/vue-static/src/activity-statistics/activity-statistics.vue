<template>
    <div class="activity-statistics">
        <pageHeader topTitle="外呼活动统计"></pageHeader>
        <div class="container-fluid">
            <div class="panel" style="position: relative;">
                <div class="activity-statistics__search">
                    <ul class="nav nav-tabs">
                        <li :class="{'activity-statistics__tabs__active' : activeIndex == 0}">
                            <a href="javascript:void(0)" class="activity-statistics__tab" @click="toggleTab(0)">活动统计</a>
                        </li>
                        <li :class="{'activity-statistics__tabs__active' : activeIndex == 1}">
                            <a href="javascript:void(0)" class="activity-statistics__tab" @click="toggleTab(1)">个人业绩</a>
                        </li>
                        <li :class="{'activity-statistics__tabs__active' : activeIndex == 2}">
                            <a href="javascript:void(0)" class="activity-statistics__tab" @click="toggleTab(2)">批次统计</a>
                        </li>
                    </ul>
                    <!--避免重新渲染-->
                    <keep-alive>
                        <component :is="tabView"></component>
                    </keep-alive>
                </div>
                <block-loading loading-desc="努力加载数据中···" ref="blockLoading"></block-loading>
            </div>
            <div class="panel">
                <component :is="tableView"></component>
            </div>
        </div>
    </div>
</template>
<script type="text/ecmascript-6">
    // loading遮罩层组件
    import BlockLoading from '@/lib-components/block-loading.vue';
    import pageHeader from '../lib-components/page-header.vue';
    import activityStatisticsTab from '../activity-statistics/activity-statistics-tabs/activity-statistics-tab.vue';
    import personalPerformanceTab from '../activity-statistics/activity-statistics-tabs/personal-performance-tab.vue';
    import batchStatisticsTab from '../activity-statistics/activity-statistics-tabs/batch-statistics-tab.vue';
    import activityStatisticsTable from '../activity-statistics/activity-statistics-tables/activity-statistics-table.vue';
    import personalPerformanceTable from '../activity-statistics/activity-statistics-tables/personal-performance-table.vue';
    import batchStatisticsTable from '../activity-statistics/activity-statistics-tables/batch-statistics-table.vue';
    export default{
        name: 'ActivityStatistics',
        created: function() {
            // 清空vuex里相关的统计列表
            this.$store.commit('INIT_ACTIVITY_STATISTICS', []);
            this.$store.commit('INIT_PERSONAL_PERFORMANCE', []);
            this.$store.commit('INIT_BATCH_STATISTICS', []);
        },
        mounted: function() {
            // 获取所有活动列表
            this.getAllActivityList();
        },
        data: function () {
            return {
                activeIndex:0,
                tabs: ['activityStatisticsTab','personalPerformanceTab','batchStatisticsTab'],
                tables:['activityStatisticsTable','personalPerformanceTable','batchStatisticsTable'],
                tabView:'activityStatisticsTab',
                tableView: 'activityStatisticsTable'
            }
        },
        methods:{
            toggleTab:function (i) {
                this.activeIndex=i;
                this.tabView=this.tabs[i];
                this.tableView=this.tables[i];
            },
            // 获取所有活动列表
            getAllActivityList: function () {
                // 显示loading
                this.$refs.blockLoading.$emit('load-show');
                this.$store.dispatch('getAllActivityList').catch(error => {
                    notice.danger(error.message);
                }).finally(() => {
                    // 隐藏loading
                    this.$refs.blockLoading.$emit('load-hide');
                });
            },
        },
        components: {
            BlockLoading,
            pageHeader,
            activityStatisticsTab,
            personalPerformanceTab,
            batchStatisticsTab,
            activityStatisticsTable,
            personalPerformanceTable,
            batchStatisticsTable
        }
    }
</script>
<style lang="less" scoped>
    .activity-statistics__search {
        margin-top: 10px;
    }

    .activity-statistics__tab {
        color: rgba(255, 255, 255, 0.843137) !important;
    }

    .activity-statistics__tabs__active {
        background: rgba(255, 255, 255, .1);
    }
</style>