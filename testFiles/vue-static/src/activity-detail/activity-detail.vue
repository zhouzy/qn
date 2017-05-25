/**
 * 活动详情
 * zhouzy
 * 2017/02/28
 */
<template>
    <div class="tele-activity">
        <page-header :topTitle="teleActivity.activityName"> </page-header>
        <div class="tele-activity__right-content">
            <div class="container-fluid">
                <div class="row">
                    <div class="col-sm-12">
                        <div class="panel panel-default">
                            <div class="tele-activity-form form-horizontal clearfix">
                                <div class="col-sm-3">
                                    <div class="form-group">
                                        <label class="col-sm-4 control-label">活动创建时间:</label>
                                        <div class="col-sm-8">
                                            <p class="form-control-static">{{teleActivity.createTime}}</p>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-sm-3">
                                    <div class="form-group">
                                        <label class="control-label col-sm-4">活动归属人:</label>
                                        <div class="col-sm-8">
                                            <p class="form-control-static">{{teleActivity.attachUserName}}</p>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-sm-3">
                                    <div class="form-group">
                                        <label class="control-label col-sm-4">活动归属组:</label>
                                        <div class="col-sm-8">
                                            <p class="form-control-static">{{teleActivity.attachGroupName}}</p>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-sm-2">
                                    <div class="form-group">
                                        <label class="col-sm-4 control-label">当前状态:</label>
                                        <div class="col-sm-8">
                                            <p class="form-control-static">{{teleActivity.statusStr}}</p>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-sm-1">
                                    <a id="activityDetailExtendBtn" class="collapse-btn btn btn-xs btn-link" data-toggle="collapse" href="#activityDetailExtend" >
                                        <i class="fa fa-caret-down"></i>更多
                                    </a>
                                </div>
                                <div class="collapse clearfix" id="activityDetailExtend">
                                    <div class="col-sm-3">
                                        <div class="form-group">
                                            <label class="col-sm-4 control-label">名单数量:</label>
                                            <div class="col-sm-8">
                                                <p class="form-control-static">{{teleActivity.nameCount}}</p>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-sm-3">
                                        <div class="form-group">
                                            <label class="col-sm-4 control-label">员工数量:</label>
                                            <div class="col-sm-8">
                                                <p class="form-control-static">{{teleActivity.userCount}}</p>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-sm-3">
                                        <div class="form-group">
                                            <label class="col-sm-4 control-label">执行/总数:</label>
                                            <div class="col-sm-8">
                                                <p class="form-control-static">{{teleActivity.totalExecute}}/{{teleActivity.nameCount}}</p>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-sm-3">
                                        <div class="form-group">
                                            <label class="col-sm-4 control-label">接通/总数:</label>
                                            <div class="col-sm-8">
                                                <p class="form-control-static">{{teleActivity.totalConnect}}/{{teleActivity.nameCount}}</p>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-sm-3">
                                        <div class="form-group">
                                            <label class="col-sm-4 control-label">呼叫次数:</label>
                                            <div class="col-sm-8">
                                                <p class="form-control-static">{{teleActivity.totalCallNum}}</p>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-sm-12">
                                        <div class="form-group">
                                            <label class="col-sm-1 control-label">活动描述:</label>
                                            <div class="col-sm-11">
                                                <p class="form-control-static">{{teleActivity.activityDescrible}}</p>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-sm-12">
                        <div class="panel panel-default tab">
                            <div class="panel-heading">
                                <ul class="nav nav-tabs tab-list">
                                    <li class="presentation active"><a href="#list-table" role="tab" data-toggle="tab" aria-expanded="false" @click="refresh('refreshCustomer')">名单</a></li>
                                    <li class="presentation"><a href="#agent-table" role="tab" data-toggle="tab" aria-expanded="false" @click="refresh('refreshAgent')">员工</a></li>
                                    <li class="presentation"><a href="#batch-table" role="tab" data-toggle="tab" aria-expanded="false" @click="refresh('refreshBatch')">批次</a></li>
                                </ul>
                            </div>
                            <div class="panel-body tab-content">
                                <div class="tab-pane active" id="list-table">
                                    <customer-list :teleActivityId="teleActivity.teleActivityId" :activityName="teleActivity.activityName" :refresh="refreshCustomer"></customer-list>
                                </div>
                                <div class="tab-pane" id="agent-table">
                                    <agent-list :teleActivityId="teleActivity.teleActivityId" ref="agentList" :refresh="refreshAgent"></agent-list>
                                </div>
                                <div class="tab-pane" id="batch-table">
                                    <batch-list :teleActivityId="teleActivity.teleActivityId" ref="batchList" :refresh="refreshBatch"></batch-list>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
    import queryPanel from '../lib-components/query-panel.vue';
    import pageHeader from '../lib-components/page-header.vue';
    import customerList from '../customer-list/customer-list.vue';
	import agentList from '../agent-list/agent-list.vue';
	import batchList from '../batch-list/batch-list.vue';

    export default {
        props: ['teleActivityId'],
        created : function(){
        	var _id = this.$route.query.teleActivityId || this.teleActivityId;
        	this.teleActivity = _.find(this.$store.state.allActivity.activities,function(activity){
        		return activity.teleActivityId === _id;
            }) || {};
        },
        mounted : function(){
        	var $btn = $("#activityDetailExtendBtn");
        	$("#activityDetailExtend").on("hidden.bs.collapse",function(){
        	    $btn.html('<i class="fa fa-caret-down"></i>更多');
            }).on("shown.bs.collapse",function(){
				$btn.html('<i class="fa fa-caret-down"></i>收起');
            });
        },
        data : function () {
            return {
                activeTab: 'refreshCustomer', // 当前显示的是 名单/员工/批次 默认是名单
                refreshCustomer: '', // 是否刷新名单
                refreshAgent: '', // 是否刷新员工
                refreshBatch: '', // 是否刷新名单
				teleActivity : {}
            };
        },
        methods: {
            refresh: function (param) {
                if (this.activeTab !== param) {
                    this[param] = Math.random();
                    this.activeTab = param;
                }
            }
        },
        components: {
        	"page-header"  : pageHeader,
            "customer-list": customerList,
            "agent-list"   : agentList,
			"batch-list"   : batchList
        }
    };
</script>

<style lang="less" scoped>
    .tele-activity{
        height : 100%;
        position: relative;
        padding-top:55px;
    }
    .tele-activity>*:first-child{
        position:absolute;
        top:0;
        left:0;
        right:0;
    }

    .tele-activity-form{
        word-break: break-all;
        margin-top:15px;
        padding-top: 15px;
        padding-bottom:15px;
        .form-group{
            label.control-label {
                line-height:normal;
                font-size:12px;
                margin-top:0;
            }
        }
    }

    .nav-tabs.tab-list {
        li {
            a{
                color : rgba(0,0,0,0.9)!important;
                &:hover{
                    color: #21d376!important;
                }
            }
        }
    }

    .collapse-btn {
        margin-top:6px;
    }
</style>