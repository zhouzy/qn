/**
* 活动批次列表
*
* @Author zhouzy
* @Date 2017.3.20
*/
<template>
    <div class="batch-list-grid container-fluid">
        <div class="row data-grid__search-bar">
            <div class="col-md-9">
                <div class="form-horizontal">
                    <div class="row">
                        <div class="col-sm-3">
                            <div class="form-group">
                                <label class="control-label col-sm-4">批次名称:</label>
                                <div class="col-sm-8">
                                    <input class="form-control" v-model="searchFormData.batchName"/>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-3 text-right">
                <a href="javascript:void(0)" class="btn btn-xs btn-raised" @click="clear">清空</a>
                <button class="btn btn-xs btn-primary btn-raised" @click="query">查询</button>
            </div>
        </div>
        <div class="row batch-list-grid__table">
            <table id="batchListGrid"></table>
            <button class="btn btn-xs btn-raised btn-primary batch-list__export-btn" @click="exportCustomer(1)">导出全部批次名单</button>
        </div>
        <transition name="slide">
            <div class="bottom-collapse-toolbar show" v-if="hasSelected">
                <button type="button" class="btn btn-raised left-btn btn-dark" @click="clearSelection">清空选择</button>
                <button class="btn btn-raised btn-primary" @click="exportCustomer(2)">导出选中批次名单</button>
                <button type="button" class="btn btn-raised btn-danger" @click="recycle">回收</button>
            </div>
        </transition>
    </div>
</template>

<script type="text/ecmascript-6">
    import config from '../lib-js/config';
    import axios from 'axios';
    export default{
        props  : ['refresh' ,'teleActivityId'],
        created: function () {
        },
        mounted: function () {
            this.initGrid();
        },
        data   : function () {
            return {
                cacheQueryFields: {}, // 缓存查询参数
                searchFormData: {
                    batchName: ""
                },
                grid          : null,
                hasSelected   : false // 是否有勾选项
            };
        },
        methods: {
            clear         : function () {
                this.searchFormData.batchName = '';
            },
            query         : function () {
                // 缓存查询参数
                this.cacheQueryFields = {};
                let fields = this.searchFormData;
                let cacheQueryFields = this.cacheQueryFields;
                for(let item in fields){
                    if(fields.hasOwnProperty(item) && fields[item]){
                        cacheQueryFields[item] = fields[item];
                    }
                }
                this.grid.reload(_.extend({"teleActivityId": this.teleActivityId}, this.searchFormData));
            },
            initGrid      : function () {
                let self    = this;
                let columns = [
                    {title: "批次名称", field: "batchName"},
                    {title: "名单总数", field: "totalAllot"},
                    {title: "未分配数量", field: "notDistributeNameCount"},
                    {title: "成单数", field: "totalDeal"},
                    {title: "执行数", field: "execute2total"},
                    {title: "接通/总数", field: "connect2total"},
                    {title: "呼叫次数", field: "totalCallNum"},
                ];

                this.grid = $("#batchListGrid").datagrid({
                    url       : config.ORIGIN_URL + '/names/countNamesByBatch',
                    param     : _.extend({teleActivityId: this.teleActivityId}, this.searchFormData),
                    columns   : columns,
                    pagination: true,
                    checkBox  : true,
                    rowNum    : false,
                    pageSize  : 30,
                    onChange  : function () {
                        self.hasSelected = self.grid.getSelected().length > 0;
                    },
					ajaxDone : function(data){
						_.each(data.rows,function(item){
							item.execute2total = item.totalExecute + "/" + item.totalAllot;
							item.connect2total = item.totalConnect + "/" + item.totalAllot;
						});
						return data;
					}
                });
            },
            // 回收
            recycle       : function () {
                let self        = this;
                let arrSelected = this.grid.getSelected();
                for (let i = 0, len = arrSelected.length; i < len; i++) {
                    arrSelected[i] = arrSelected[i].batchId;
                }
                $.ajax({
                    url    : location.origin + '/names/recycleNameList',
                    type   : 'post',
                    data   : {
                        teleActivityId: this.teleActivityId,
                        recycleType: 'batch', // 回收类型: {'nameList': '名单', 'agent': '员工', 'batch': '批次'}
                        ids        : arrSelected.join(',')
                    },
                    success: function (data) {
                        if (data.success) {
                            self.grid.reload();
                            notice.info('回收' + data.rows.complete + '个，未回收' + data.rows.uncomplete + '个');
                        }
                    }
                })
            },
            clearSelection: function () {
                this.grid.clearSelected();
                this.hasSelected = false;
            },
            // 导出批次
            exportCustomer: function (tag) {
                let params = {
                    tag: tag, // 1: 全部 2: 选中
                    sub: 3, // 1: 名单 2: 员工 3: 批次
                    info: {},
                };
                params.info.teleActivityId = this.teleActivityId;
                if(params.tag === 2){
                    let ids = this.grid.getSelected().map(function (item) {
                        return item.batchId;
                    });
                    params.idsjson = ids.join(',');
                }else {
                    params.info.batchName = this.cacheQueryFields.batchName;

                }
                params.info = JSON.stringify(params.info);
                $.ajax({
                    type: 'post',
                    url: '/names/exportNamesByCustom',
                    data: params,
                    success: function (data) {
                        if(!data.success){
                            return notice.danger(data.msg);
                        }
                        window.location.href = location.origin + data.rows;
                    }
                })
            }
        },
        watch: {
            refresh: function (newVal) {
                this.query()
            }
        }
    }
</script>

<style lang="less" scoped>
    .batch-list__export-btn{
        margin-top: -70px;
    }
    .data-grid__search-bar {
        padding-bottom: 15px;
        margin-bottom: 10px;
        //border-bottom: 1px solid #f2f2f2;
    }

    .grid .grid-view {
        border-top: none;
    }

    .dropdown {

    label {
        display: inline-block;
        padding: 10px 0 0 8px;
        width: 100%;
        height: 100%;
        margin-bottom: 0;
        vertical-align: top;

        white-space: nowrap;
        cursor: pointer;

    &
    :hover {
        background-color: #eff4f5;
        color: #000;
    }

    }
    input[type=checkbox] {
        margin: 0 5px;
    }

    &
    >
    .dropdown-menu {
        height: 300px;
        overflow: auto;
    }

    .dropdown-menu li {
        height: 40px;
    }

    }
    .slide-enter-active, .slide-leave-active {
        transition: all .5s;
    }

    .slide-enter, .slide-leave-active {
        bottom: -60px;
    }
</style>