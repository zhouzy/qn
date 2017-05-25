/**
 * 预约管理-所有预约列表
 *
 * @Author zhouzy
 * @Date 2017.3.20
 */
<template>
    <div class="reservation-list-grid">
        <page-header topTitle="预约管理"></page-header>
        <div class="container-fluid tele-activity__right-content">
            <div class="row">
                <div class="col-md-12">
                    <div class="col-md-12 data-grid__search-bar">
                        <div class="col-md-9">
                            <div class="form-horizontal">
                                <div class="row">
                                    <div class="col-sm-4">
                                        <div class="form-group">
                                            <label class="control-label col-sm-3">姓名:</label>
                                            <div class="col-sm-9">
                                                <input class="form-control" v-model="searchFormData.userName"/>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-sm-4">
                                        <div class="form-group">
                                            <label class="control-label col-sm-3">状态:</label>
                                            <div class="col-sm-9">
                                                <select class="form-control" v-model="searchFormData.status">
                                                    <option v-for="option in RESERVATION_STATUS_ENUM" v-bind:value="option.value">{{option.text}}</option>
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-sm-4">
                                        <div class="form-group" v-bind:class="{'has-error':validateTelPhone}">
                                            <label class="control-label col-sm-3">电话号码:</label>
                                            <div class="col-sm-9">
                                                <input class="form-control" v-model="searchFormData.telPhone"/>
                                                <span v-if="validateTelPhone" class="help-block">请输入正确的电话号码</span>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-sm-4">
                                        <div class="form-group">
                                            <label class="control-label col-sm-3">预约时间:</label>
                                            <div class="col-sm-9 time-input-container">
                                                <input id="startTime" class="form-control"/>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-sm-4">
                                        <div class="form-group" v-bind:class="{'has-error':validateEndTime}">
                                            <label class="control-label col-sm-3">至:</label>
                                            <div class="col-sm-9 time-input-container">
                                                <input id="endTime" class="form-control"/>
                                                <span v-if="validateEndTime" class="help-block">结束时间不能在开始时间之前</span>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-sm-4">
                                        <agent-select label="创建人:" name="creatorId" :value="searchFormData.creatorId" v-on:change="onAgentChange"></agent-select>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3 text-right">
                            <a href="javascript:void(0)" class="btn btn-xs btn-raised" @click="clear">清空</a>
                            <button class="btn btn-xs btn-primary btn-raised" @click="query">查询</button>
                        </div>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-md-12">
                    <div class="col-md-12 reservation-list-grid__table">
                        <table id="grid"></table>
                    </div>
                </div>
            </div>
        </div>
        <transition name="slide">
            <div class="bottom-collapse-toolbar show" v-if="hasSelected">
                <button class="btn btn-sm btn-raised btn-dark"    @click="clearSelection">清空选择</button>
                <a class="btn btn-sm btn-raised btn-primary" data-toggle="modal" data-target="#editReserve" v-if="this.$store.state.options['/appointment/edit/manage'] !== undefined">{{this.$store.state.options['/appointment/edit/manage']}}</a>
                <button class="btn btn-sm btn-raised btn-danger"  @click="deleteItem" v-if="this.$store.state.options['/appointment/delete/manage'] !== undefined">{{this.$store.state.options['/appointment/delete/manage']}}</button>
                <button class="btn btn-sm btn-raised btn-primary" @click="updateStatus(1)" v-if="isCompleteBtn">已完成</button>
                <button class="btn btn-sm btn-raised btn-primary" @click="updateStatus(0)" v-else>未完成</button>
            </div>
        </transition>
        <div id="editReserve" class="modal fade">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                        <strong class="modal-title">预约回访</strong>
                    </div>
                    <div class="modal-body">
                        <form class="form-horizontal" onsubmit="return false;">
                            <div class="row">
                                <div class="col-sm-10">
                                    <input id="newReserveTime" name="newReserveTime" type="text" class="form-control" data-label="预约时间">
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-sm-10">
                                    <div class="form-group">
                                        <label for="reserveReason" class="col-sm-4 control-label">预约原因</label>
                                        <div class="col-sm-8">
                                            <textarea id="reserveReason" v-model="editReason" name="newReserveReason" class="form-control" rows="3"></textarea>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </form>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-raised btn-default btn-sm" data-dismiss="modal" @click="this.hasSelected=true">取消</button>
                        <button type="button" class="btn btn-raised btn-primary btn-sm" @click="doUpdate">更新</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script type="text/ecmascript-6">
	import pageHeader from '../lib-components/page-header.vue';
	import agentSelect from '../lib-components/agent-select.vue';
    import config from '../lib-js/config';
    import axios from 'axios';
    export default{
        props : ['teleActivityId'],
        created: function () {
            // 查询操作权限
            let parentId = this.$route.query.parentId || '83';
            let optionsList = Tools.getPagePermission(parentId);
            // 将操作列表缓存到vuex里方便其他页面调用
            this.$store.state.options=optionsList;
        },
        mounted : function () {
        	let self = this;
            this.initGrid();
            $("#startTime").timeInput({
                HMS : true,
                value : "",
				format : "yyyy-MM-dd HH:mm:ss",
            	change : function(){
                	let _t = cri.formatDate(this.value(),"yyyy-MM-dd HH:mm:ss");
                	self.searchFormData.startTime = _t;
                }
            });
			$("#endTime").timeInput({
				HMS : true,
				value : "",
				format : "yyyy-MM-dd HH:mm:ss",
				change : function(){
					let _t = cri.formatDate(this.value(),"yyyy-MM-dd HH:mm:ss");
					self.searchFormData.endTime = _t;
				}
			});

			var reserveTime = $("#newReserveTime").timeInput({
				HMS : true,
				value : "",
				format : "yyyy-MM-dd HH:mm:ss",
				change : function(){
					let _t = cri.formatDate(this.value(),"yyyy-MM-dd HH:mm:ss");
					self.editTime = _t;
				}
            });

			//监听编辑框打开事件，设置预约时间
			$('#editReserve').on('show.bs.modal', function (e) {
				if(self.selected.appointmentTime){
					reserveTime.value(cri.string2Date(self.selected.appointmentTime));
					self.editTime = self.selected.appointmentTime;
                }
                else{
                    let newDate = new Date();
					reserveTime.value(newDate);
					self.editTime = cri.formatDate(newDate,'yyyy-MM-dd HH:mm:ss')
                }
                if(self.selected.reason){
					self.editReason = self.selected.reason;
                }
                else{
					self.editReason = "";
                }
			});
        },
        data : function () {
        	let _statusMap = _.map(config.RESERVATION_STATUS_MAP, function (text, value) {
                return {
                    value: value,
                    text : text
                }
            });
        	_statusMap.unshift({
            	value : 'all',
                text  : '全部'
            });

            return {
                isCompleteBtn: true, //预约【完成】【未完成】按钮
                searchFormData : {
					userName  : "", //名单姓名
                    status    : "", //名单
                    telPhone  : "", //名单电话
                    creatorId : "", //坐席ID
                    startTime : "", //开始时间
                    endTime   : ""  //结束时间
                },
                grid          : null,
                hasSelected   : false, //是否有勾选项,
				selected      : null,  //客户选择项
				editReason    : "",    //编辑框预约原因
                editTime      : "",    //编辑框预约时间
				RESERVATION_STATUS_ENUM : _statusMap
            };
        },
        methods: {
            clear : function () {
            	for(let p in this.searchFormData){
            		this.searchFormData[p] = "";
                }
				$("#startTime").val("");
				$("#endTime").val("");
            },
            query : function () {
            	if(this.validateTelPhone){
            	    notice.warning("电话号码格式不正确!");
                    return;
                }
                if(this.validateEndTime){
					notice.warning("结束时间不能在开始时间之前!");
					return;
                }
                let req = _.cloneDeep(this.searchFormData);
				if(this.searchFormData.status === "all"){
                    req.status = "";
				}
                this.grid.reload(_.extend({"teleActivityId": this.teleActivityId}, req));
            },

            onAgentChange : function(_p){
            	this.searchFormData.creatorId = _p.value;
            },

            initGrid : function () {
                let self    = this;
                let columns = [
                    {title: "姓名", field: "userNameLink", width: 100},
                    {title: "呼叫活动", field: "activityName", width: 100},
                    {title: "预约时间", field: "appointmentTime", width: 160},
                    {title: "电话号码", field: "protectNumLink", width: 160},
                    {title: "创建人", field: "creatorName", width: 100},
                    {title: "状态", field: "statusStr", width: 100},
                    {title: "预约原因", field: "reason", width: 160},
					{title: "创建时间", field: "createTime", width: 160}
                ];

                this.grid = $("#grid").datagrid({
                    url       : config.ORIGIN_URL + '/appointment/queryAppointment',
                    param     : _.extend({teleActivityId: this.teleActivityId}, this.searchFormData),
                    columns   : columns,
                    pagination: true,
                    checkBox  : false,
                    rowNum    : false,
                    pageSize  : 30,
                    onChange  : function () {
						let selected = self.grid.getSelected();
                        self.hasSelected = selected.length > 0;
                        self.selected = selected[0];
                        if (self.selected.status === '0') {
                            self.isCompleteBtn = true;
                        }else {
                            self.isCompleteBtn = false;
                        }
                    },
					ajaxDone : function(data){
                    	_.each(data.rows,function(item){
                    		let _p = JSON.stringify({
                    			namesId   : item.namesId,
                                reserveId : item.appointmentId
                            });
                    		let _c = JSON.stringify({
                    			namesId        : item.namesId,
                                reserveId      : item.appointmentId,
                                telPhone       : item.telPhone,
								teleActivityId : item.teleActivityId,
                                disNumber      : item.displayNumber
                            });
                    		item.statusStr = config.RESERVATION_STATUS_MAP[item.status];
                    		item.userNameLink = '<a href="javascript:void(0)" onclick=\'openNameDetailsTab('+ _p +',event)\'>' + item.userName + '</a>';
                            // 预约管理中，创建这条预约的创建人才能呼叫
                    		if (item.creatorId == USER_G.userId) {
                                item.protectNumLink = '<a href="javascript:void(0)" onclick=\'openCallTab('+ _c +',event)\'>' + item.protectNum + '</a>';
                            }else {
                                item.protectNumLink = '<a href="javascript:void(0)" style="color: #666">' + item.protectNum + '</a>';
                            }
                        });
						return data;
					}
                });
            },
            //清除选择
            clearSelection: function () {
                debugger;
                this.grid.clearSelected();
                this.hasSelected = false;
            },
            //改变选择的所有预约的状态
            changeStatus : function(status){
            	if(this.selected.length){
                    this.selected.status = status;
                    this.updateItem(this.selected);
                }
            },
            doUpdate : function(){
            	if(!this.editReason){
            		notice.warning('请指定预约原因');
            		return ;
                }
                if(!this.editTime){
					notice.warning('请指定预约时间');
					return ;
                }
                if(this.editTime < cri.formatDate(new Date(),'yyyy-MM-dd HH:mm:ss')){
					notice.warning('预约时间不能在当前时间之前！');
					return ;
                }
            	this.selected.reason = this.editReason;
            	this.selected.appointmentTime = this.editTime;
            	this.updateItem(this.selected, (resp) => {
            		if(resp.success){
						$("#editReserve").modal('hide');
						this.hasSelected = false;
                    }
                });
            },

            //修改预约信息
            updateItem : function(item,cb){
            	let self = this;
            	var req = {
					appointmentId   : item.appointmentId,
					appointmentTime : item.appointmentTime,
					status          : item.status,
					reason          : item.reason
                };
				$.post(config.ORIGIN_URL + '/appointment/edit/manage',req,function(resp){
					if(resp.success){
						notice.success('修改预约信息成功!');
						self.initGrid();
                    }
                    else{
						notice.danger('修改预约信息失败,请重试!');
                    }
                    cb && cb(resp);
                });
            },

            //修改预约状态
            updateStatus : function(status){
            	let item = this.selected;
            	item.status = status;
            	this.updateItem(item);
            	this.hasSelected = false;
            },

            //删除预约
            deleteItem : function(){
                $.post(config.ORIGIN_URL + '/appointment/delete/manage',{id:this.selected.appointmentId},function(resp){
                	if(resp.success){
                		notice.success('该预约已经成功删除');
                	    this.initGrid();
                    }
                    else{
                		notice.danger('该预约删除失败,请重试！');
                    }
                }.bind(this));
                this.hasSelected = false;
            }

        },
        computed : {
        	validateTelPhone : function(){
				return this.searchFormData.telPhone && !cri.isPhoneNo(this.searchFormData.telPhone)
            },
			validateEndTime : function(){
        		if(this.searchFormData.startTime && this.searchFormData.endTime){
					return this.searchFormData.startTime > this.searchFormData.endTime;
                }
                else{
        			return false;
                }
            }
        },
		components: {pageHeader,"agent-select":agentSelect}
    }
</script>
<style lang="less">
    .td-content {
        text-overflow: ellipsis;
        overflow: hidden;
        white-space: nowrap;
    }
    .reservation-list-grid__table{
        .grid .grid-view {
            border-top: none;
        }
    }
    .time-input-container{
        .col-sm-8{
            width:100%;
        }
    }
    .reservation-list-grid__table .table{
        table-layout: fixed;
    }
</style>
<style lang="less" scoped>
    .reservation-list-grid{
        height: 100%;
    }

    .data-grid__search-bar {
        position: relative;
        margin: 15px 0;
        background-color: #fff;
        border-radius: 4px;
        overflow: hidden;
    }
    .reservation-list-grid__table{
        background-color: #fff;
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
            &:hover {
                background-color: #eff4f5;
                color: #000;
            }
        }
        input[type=checkbox] {
            margin: 0 5px;
        }
        & > .dropdown-menu {
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
    #editReserve{
        z-index:2000;
    }
</style>