/**
 * 坐席列表
 * 包含外呼统计信息
 * @Author zhouzy
 * @Date 2017.3.20
 */
<template>
    <div class="agent-list-grid container-fluid">
        <div class="row agent-list-grid__search-bar">
            <div class="col-md-9">
                <div class="form-horizontal">
                    <div class="row">
                        <div class="col-sm-3">
                            <agent-select v-on:change="agentChange" name="serviceId" :value="searchFormData.serviceId" label="员工名称:"></agent-select>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-3 text-right">
                <a href="javascript:void(0)" class="btn btn-xs btn-raised" @click="clear">清空</a>
                <button class="btn btn-xs btn-primary btn-raised" @click="query">查询</button>
            </div>
        </div>
        <div class="row customer-list-grid__table">
            <table id="agentListGrid"></table>
            <button class="btn btn-raised btn-primary text-right agent-list__export-btn btn-xs" @click="exportCustomer(1)" v-if="true">导出全部员工名单</button>
        </div>
        <transition name="slide">
        <div class="bottom-collapse-toolbar show" v-if="hasSelected">
            <button id="deleteBtn" type="button" class="btn btn-raised left-btn btn-dark" @click="clearSelection">清空选择</button>
            <button class="btn btn-raised btn-primary" @click="exportCustomer(2)">导出选中员工名单</button>
            <button id="editBtn" type="button" class="btn btn-raised btn-danger" @click="recycle">回收</button>
        </div>
        </transition>
    </div>
</template>

<script type="text/ecmascript-6">
    import config from '../lib-js/config';
    import axios from 'axios';
	import agentSelect from '../lib-components/agent-select.vue';

	export default{
        props : ['refresh', 'teleActivityId'],
        created : function(){
        },
        mounted : function () {
			this.initGrid();
        },
        data : function(){
            return {
                cacheQueryFields: {}, // 缓存查询参数
                searchFormData : {
                    serviceId : ""
                },
                grid : null,
                hasSelected: false // 是否有勾选项
            };
        },
        methods : {
            clear : function () {
            	this.searchFormData.serviceId = "";
                //$('.select2-selection__rendered').text('全部').attr('title', '全部');
            },
            query : function(){
                // 缓存查询参数
                this.cacheQueryFields = {};
                let fields = this.searchFormData;
                let cacheQueryFields = this.cacheQueryFields;
                for(let item in fields){
                    if(fields.hasOwnProperty(item) && fields[item]){
                        cacheQueryFields[item] = fields[item];
                    }
                }
				this.grid.reload(_.extend({"teleActivityId":this.teleActivityId},this.searchFormData));
            },
            initGrid : function(){
                let self = this;
                let columns = [
                    {title:"员工名称",field:"serviceName"},
                    {title:"分配数量",field:"totalAllot"},
                    {title:"成单数",  field:"totalDeal"},
                    {title:"执行数",  field:"execute2total"},
					{title:"接通/总数",field:"connect2total"},
					{title:"呼叫次数",field:"totalCallNum"}
                ];

				this.grid = $("#agentListGrid").datagrid({
					url        : config.ORIGIN_URL + '/names/countNamesByExeUser',
					param      : _.extend({teleActivityId:this.teleActivityId},this.searchFormData),
					columns    : columns,
					pagination : true,
					checkBox   : true,
					rowNum     : false,
                    pageSize   : 30,
                    onChange   : function () {
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
            recycle: function () {
                let self = this;
                let arrSelected = this.grid.getSelected();
                for (let i = 0, len = arrSelected.length; i < len; i++) {
                    arrSelected[i] = arrSelected[i].serviceId;
                }
                $.ajax({
                    url: location.origin + '/names/recycleNameList',
                    type: 'post',
                    data: {
                        teleActivityId: this.teleActivityId,
                        recycleType: 'agent', // 回收类型: {'nameList': '名单', 'agent': '员工', 'batch': '批次'}
                        ids: arrSelected.join(',')
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
            // 导出员工
            exportCustomer: function (tag) {
                let params = {
                    tag: tag, // 1: 全部 2: 选中
                    sub: 2, // 1: 名单 2: 员工 3: 批次
                    info: {},
                };
                params.info.teleActivityId = this.teleActivityId;
                if(params.tag === 2){
                    let ids = this.grid.getSelected().map(function (item) {
                        return item.serviceId;
                    });
                    params.idsjson = ids.join(',');
                }else {
                    params.info.serviceId = this.cacheQueryFields.serviceId;
                }
                this.axios({
                    url: '/names/exportNamesByCustom',
                    params: params
                }).then(function (res) {
                    if(!res.data.success){
                        return notice.danger(res.data.msg);
                    }
                    window.location.href = location.origin + res.data.rows;
                })
            },
			//改变归属人下拉框的值，回调
			agentChange : function(p){
				this.searchFormData.serviceId = p.value;
			}
        },
        watch: {
            refresh: function (newVal) {
                this.query();
            }
        },
		components: {
			"agent-select":agentSelect
		}

    }
</script>

<style lang="less" scoped>
    .agent-list__export-btn{
        margin-top: -70px;
    }
    .agent-list-grid__search-bar{
        padding-bottom:15px;
        margin-bottom:10px;
        //border-bottom:1px solid #f2f2f2;
    }
    .grid .grid-view{
        border-top:none;
    }
    .dropdown{
        label{
            display: inline-block;
            padding: 10px 0 0 8px;
            width: 100%;
            height: 100%;
            margin-bottom: 0;
            vertical-align: top;

            white-space: nowrap;
            cursor: pointer;
            &:hover {
                background-color: #eff4f5;
                color: #000;
            }
        }
        input[type=checkbox]{
            margin: 0 5px;
        }

        &>.dropdown-menu {
            height: 300px;
            overflow: auto;
        }

        .dropdown-menu li{
            height: 40px;
        }
    }

    .bs-form-group{
        margin-top:7px;
        label.control-label{
            margin-top:0;
        }
    }

    .slide-enter-active, .slide-leave-active {
        transition: all .5s;
    }
    .slide-enter, .slide-leave-active {
        bottom: -60px;
    }
</style>