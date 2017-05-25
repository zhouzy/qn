/*
管理
maaser_wen
2017.2.17
*/

<template>
    <div class="activity-manage__root">
        <page-header :top-title="topTitle">
            <template slot="topContent">
                <a class="activity-manage__top-a" href="#/control/activity-create" v-if="this.$store.state.options['/teleActivity/addTeleActivity'] !== undefined">{{this.$store.state.options['/teleActivity/addTeleActivity']}}</a>
            </template>
        </page-header>
        <div class="tele-activity__right-contents">
            <query-panel
                    :is-show-toggle-btn="false"
                    v-on:query="queryFields"
                    v-on:clear="clearQueryCondition"
                    v-on:toggle-height="toggleHeight(arguments[0])">
                <template slot="defaultFieldList">
                    <div class="col-sm-6">
                        <div class="form-group">
                            <label for="activity" class="control-label col-sm-4">活动名称：</label>
                            <div class="col-sm-8">
                                <input v-model="activityName" id="activity" type="text" name="activity" class="form-control">
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label for="status" class="control-label col-sm-4">活动状态：</label>
                            <div class="col-sm-8">
                                <select class="form-control" v-model="activityStatus" name="status" id="status">
                                    <option value="">请选择</option>
                                    <option value="0">准备</option>
                                    <option value="1">运行</option>
                                    <option value="2">暂停</option>
                                    <option value="3">停止</option>
                                </select>
                            </div>
                        </div>
                    </div>
                </template>
            </query-panel>
            <query-table :result-total="resultTotal" :table-options="tableOptions" :result-list="resultList" :pagination="pagination" :loc-hash="locHash" v-on:page-update="queryActivity" :isResetPage="isResetPage"></query-table>
        </div>
        <tool-sidebar>
            <template slot="bottomContent">
                <div class="clearfix">
                    <div class="activity-manage__bottom-content__container">
                        <a class="activity-manage__bottom-content__button" href="#/control/activity-alter" v-if="this.$store.state.options['/teleActivity/updateTeleActivity'] !== undefined">{{this.$store.state.options['/teleActivity/updateTeleActivity']}}</a>
                        <a class="activity-manage__bottom-content__button" href="javascript:void(0)" @click="exportList" v-if="this.$store.state.options['/names/exportNames'] !== undefined">{{this.$store.state.options['/names/exportNames']}}</a>
                        <a class="activity-manage__bottom-content__button" href="javascript:void(0)" @click="importList" v-if="this.$store.state.options['importNameList'] !== undefined">{{this.$store.state.options['importNameList']}}</a>
                        <a class="activity-manage__bottom-content__button" href="#/control/import-foreign-call-list/assign-list" v-if="this.$store.state.options['distributionList'] !== undefined">{{this.$store.state.options['distributionList']}}</a>
                    </div>
                </div>
            </template>
        </tool-sidebar>
    </div>
</template>

<script type="text/ecmascript-6">
    import queryPanel from '../lib-components/query-panel.vue';
    import pageHeader from '../lib-components/page-header.vue';
    import queryTable from './activity-manage/activity-manage-table.vue';
    import toolSidebar from './activity-manage/activity-manage-tool-sidebar.vue';
    import axios from  'axios';

    export default {
        props: ['topTitle'],
        created: function () {
            this.$store.commit('ACTIVITY_SELECT', "");
            // 查询操作权限
            let parentId = this.$route.query.parentId || '83';
            let optionsList = Tools.getPagePermission(parentId);
            // 将操作列表缓存到vuex里方便其他页面调用
            this.$store.state.options=optionsList;
        },
        data : function () {
            return {
                isResetPage: 0, // 重置页数为1
                cacheQueryFields: {}, // 缓存查询参数
                activityStatus: '',
                activityName: '',
                pagination: 'activity-manage-pagination',
                locHash: '#/activity/detail',
                tableOptions:{
                    tableSelect:'checkbox',
                    tableTitle: [
                        {'_key': 'activityName','_value': '活动名称', '_type': 'link'},
                        {'_key': 'statusStr','_value': '活动状态'},
                        {'_key': 'attachUserName','_value': '归属人'},
                        {'_key': 'attachGroupName', '_value': '归属组'},
                        {'_key': 'userCount', '_value': '员工人数'},
                        {'_key': 'nameCount', '_value': '名单数量'},
                        {'_key': 'notDistributeNameCount', '_value': '未分配名单数量'},
                        {'_key': 'totalExecute', '_value': '执行比例', '_type': 'progress'},
                        {'_key': 'totalConnect', '_value': '接通比例', '_type': 'progress'},
                        {'_key': 'createTime', '_value': '创建时间'},
                        {'_key': 'endTime', '_value': '到期时间'}
                    ]
                },
                resultList: [],
                resultTotal: 0
            };
        },
        methods: {
            queryFields: function () {
                // 缓存查询参数
                this.cacheQueryFields = {
                    activityName: this.activityName,
                    status: this.activityStatus
                };
                this.queryActivity();
                this.isResetPage = Math.random();
            },
            queryActivity: function (pageInfo) {
                let that = this;
                let urlJson = this.tools.jsonToUrlparam({
                    activityName: this.cacheQueryFields.activityName || '',
                    status: this.cacheQueryFields.status || '',
                    page : pageInfo?pageInfo[0]:1,
                    rows : pageInfo?pageInfo[1]:10
                });
                axios.post('/teleActivity/findAllTeleActivities',urlJson)
                    .then(function (response) {
                        that.resultList = response.data.rows;
                        that.$store.commit('ACTIVITY_SAVE', response.data.rows);
                        that.resultTotal = +response.data.total;
                    })
            },
            clearQueryCondition: function () {
                this.activityName = '';
                this.activityStatus = '';
            },
            exportList:function () {
                let id=this.$store.state.allActivity.checkSelect;
                this.axios.post('/names/exportNames',{teleActivityId:id}).then(function (response) {
                    window.location.href = location.origin + response.data.rows;
                });  
            },
            importList:function () {
                location.hash='/control/import-foreign-call-list/import-foreign-call-list?id='+this.$store.state.allActivity.checkSelect;
            }
        },
        components: {queryPanel, queryTable, pageHeader, toolSidebar}
    };
</script>

<style lang="less" scoped>
    .activity-manage__root{
        height: 100%;
        overflow: auto;
    }
    .activity-manage__top-a{
        display: block;
        margin-top:12px;
        width:105px;
        height:30px;
        line-height:30px;
        text-align: center;
        font-size:10px;
        border-radius: 2px;
        background: #009688;
        float: right;
        margin-right:20px;
        color: rgba(255,255,255, 0.84);
        -webkit-box-shadow: 0 2px 2px 0 rgba(0, 0, 0, 0.14), 0 3px 1px -2px rgba(0, 0, 0, 0.2), 0 1px 5px 0 rgba(0, 0, 0, 0.12);
        box-shadow: 0 2px 2px 0 rgba(0, 0, 0, 0.14), 0 3px 1px -2px rgba(0, 0, 0, 0.2), 0 1px 5px 0 rgba(0, 0, 0, 0.12);
    }
    .activity-manage__bottom-content__container{
        float: right;
    }
    .activity-manage__bottom-content__button{
        display: block;
        float: left;
        width:95px;
        height:30px;
        line-height:30px;
        text-align: center;
        margin: 15px 5px;
        font-size:10px;
        border-radius: 2px;
        background: #009688;
        color: rgba(255,255,255, 0.84);
        -webkit-box-shadow: 0 2px 2px 0 rgba(0, 0, 0, 0.14), 0 3px 1px -2px rgba(0, 0, 0, 0.2), 0 1px 5px 0 rgba(0, 0, 0, 0.12);
        box-shadow: 0 2px 2px 0 rgba(0, 0, 0, 0.14), 0 3px 1px -2px rgba(0, 0, 0, 0.2), 0 1px 5px 0 rgba(0, 0, 0, 0.12);
    }
</style>
