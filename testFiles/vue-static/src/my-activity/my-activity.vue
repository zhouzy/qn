<template>
    <div class="my-activity-container">
        <page-header :top-title="topTitle"></page-header>
        <div class="container-fluid">
            <div class="my-activity-root">
                <div class="my-activity-root__select__status-container">
                    <select v-model="status" class="my-activity-root__select__status" name="" id="">
                        <option class="my-activity-root__option__status" value="">全部</option>
                        <option class="my-activity-root__option__status" value="0">准备</option>
                        <option class="my-activity-root__option__status" value="1">运行</option>
                        <option class="my-activity-root__option__status" value="2">暂停</option>
                        <option class="my-activity-root__option__status" value="3">停止</option>
                    </select>
                </div>
                <query-table v-on:page-update="queryMyActivity" :result-total="resultTotal" :table-options="tableOptions" :result-list="resultList" :pagination="pagination" :loc-hash="locHash"></query-table>
            </div>
        </div>
    </div>
</template>

<script type="text/ecmascript-6">
    import pageHeader from '../lib-components/page-header.vue';
    import queryTable from '../all-activity-components/activity-manage/activity-manage-table.vue';
    import axios from 'axios';

    export default{
        props: ['topTitle'],
        data: function () {
            return {
                pagination: "my-activity-pagination",
                resultList: [],
                status: '',
                locHash: '#/my-activity/detail',
                tableOptions:{
                    tableSelect:'',
                    tableTitle: [
                        {'_key': 'activityName','_value': '活动名称', '_type': 'link'},
                        {'_key': 'attachGroupName', '_value': '归属组'},
                        {'_key': 'statusStr','_value': '活动状态'},
                        {'_key': 'nameCount', '_value': '名单数量'},
                        {'_key': 'totalExecute', '_value': '执行比例', '_type': 'progress'},
                        {'_key': 'totalConnect', '_value': '接通比例', '_type': 'progress'},
                        {'_key': 'createTime', '_value': '创建时间'},
                        {'_key': 'endTime', '_value': '到期时间'}
                    ]
                },
                resultTotal: 0
            }
        },
        methods: {
            queryMyActivity: function (pageInfo) {
                let that = this;
                let urlparam = {
                    status: this.status,
                    page: pageInfo?pageInfo[0]:1,
                    rows: pageInfo?pageInfo[1]:10
                };
                axios.post("teleActivity/findMyTeleActivities", this.tools.jsonToUrlparam(urlparam)).then(function (response) {
                    that.resultList = response.data.rows;
                    that.$store.commit('ACTIVITY_SAVE', response.data.rows);
                    that.resultTotal = +response.data.total;
                });
            }
        },
        watch: {
            status: function () {
                this.queryMyActivity();
            }
        },
        components: { pageHeader,queryTable }
    }
</script>

<style lang="less">
    .my-activity-container{
        height:100%;
        overflow: auto;
    }
    .my-activity-root{
        margin-top:10px;
        background: #fff;
        .my-activity-root__select__status-container{
             padding:10px;
            .my-activity-root__select__status{
                height:28px;
                line-height:28px;
                font-size:12px;
                padding-left:15px;
                border-radius: 5px;
                width:98px;
                border:1px solid #bbb;
            }
         }
    }
</style>
