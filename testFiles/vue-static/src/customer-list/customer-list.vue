/**
 * 活动名单列表
 * @Author zhouzy
 * @Date 2017.3.2
 */
<template>
    <div class="customer-list-grid container-fluid">
        <div class="row customer-list-grid__search-bar">
            <div class="col-md-9">
                <div class="form-horizontal">
                    <div class="row">
                        <div class="col-sm-3">
                            <div class="form-group">
                                <label class="control-label col-sm-4">客户姓名:</label>
                                <div class="col-sm-8">
                                    <input class="form-control" v-model="searchFormData.userName"/>
                                </div>
                            </div>
                        </div>
                        <div class="col-sm-3">
                            <agent-select v-on:change="agentChange" name="serviceId" :value="searchFormData.serviceId" label="归属人:"></agent-select>
                        </div>
                        <div class="col-sm-3">
                            <div class="form-group">
                                <label class="control-label col-sm-4">业务结果:</label>
                                <div class="col-sm-8">
                                    <select class="form-control" v-model="searchFormData.result">
                                        <option v-for="option in BUSINESS_STATUS_MAP" v-bind:value="option.value">{{option.text}}</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                        <div class="col-sm-3">
                            <div class="form-group">
                                <label class="control-label col-sm-4">呼叫结果:</label>
                                <div class="col-sm-8">
                                    <select class="form-control" v-model="searchFormData.isConnect">
                                        <option v-for="option in CONNECT_RESULT_ENUM" v-bind:value="option.value">{{option.text}}</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row collapse" id="customerSearchBarExtend">
                        <div class="col-sm-3" v-if="hasStatus">
                            <div class="form-group">
                                <label class="control-label col-sm-4">名单状态:</label>
                                <div class="col-sm-8">
                                    <select class="form-control" v-model="searchFormData.status">
                                        <option value="">全部</option>
                                        <option value="1">待分配</option>
                                        <option value="5">已分配</option>
                                        <option value="6">已呼叫</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                        <!-- 自定义字段 -->
                        <form ref="customFields">
                            <self-defining-field-bar :field-list="dropDownNameListField" v-on:formDataChange="setFormData"></self-defining-field-bar>
                        </form>
                    </div>
                </div>
            </div>
            <div class="col-md-3 text-right">
                <a id="customerSearchBarExtendBtn" class="btn btn-xs btn-link" data-toggle="collapse"
                   href="#customerSearchBarExtend" aria-expanded="false">
                    <i class="fa fa-caret-down"></i>更多
                </a>
                <a href="javascript:void(0)" class="btn btn-xs btn-raised" @click="clear">清空</a>
                <button class="btn btn-xs btn-primary btn-raised" @click="query">查询</button>
            </div>
        </div>
        <div class="row customer-list-grid__table">
            <div class="text-right">
                <div class="dropdown">
                    <button class="btn btn-xs btn-default dropdown-toggle" id="colSelectBtn" type="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="true" style="border: 1px solid #eee;"> 自定义列<span class="caret"></span></button>
                    <ul class="dropdown-menu dropdown-menu-right" aria-labelledby="colSelectBtn">
                        <li v-for="item in nameListField">
                            <label><input type="checkbox" :value="item.key" v-model="colSelectList">{{item.name}}</label>
                        </li>
                    </ul>
                </div>
            </div>
            <table id="customerGrid"></table>
            <button class="btn btn-raised btn-primary text-right customer-list__export-btn btn-xs" @click="exportCustomer(1)" v-if="hasResult">导出全部客户名单</button>
        </div>
        <transition name="slide">
            <div class="bottom-collapse-toolbar show" v-if="hasSelected">
                <button id="deleteBtn" type="button" class="btn btn-raised left-btn btn-dark" @click="clearSelection">清空选择</button>
                <button class="btn btn-raised btn-primary" @click="exportCustomer(2)">导出选中客户名单</button>
                <button id="editBtn" type="button" class="btn btn-raised btn-danger" @click="recycle">回收</button>
            </div>
        </transition>
    </div>
</template>
<script type="text/ecmascript-6">
    import config from '../lib-js/config';
    import selfDefiningFieldBar from '../lib-components/self-defining-field-bar.vue';
    import agentSelect from '../lib-components/agent-select.vue';
    import axios from 'axios';
    export default{
        props  : ['refresh', 'teleActivityId', 'activityName'],
        created: function () {
            var self = this;
            $.post(this.selfDefiningFieldUrl).then(function (resp) {
                // 如果数据库存储已选择的项，则替换默认项
                if (resp.rows.length > 0) {
                    let arr            = resp.rows;
                    self.colSelectList = [];
                    for (let i = 0, ilen = arr.length; i < ilen; i++) {
                        if (arr[i].checked) {
                            self.colSelectList.push(arr[i].key);
                        }
                    }
                }

                self.nameListField         = resp.rows;
                self.dropDownNameListField = _.filter(resp.rows, function (item) {
                    if (item.key === 'status') {
                        self.hasStatus = true;
                    }
                    item.isRequired = false;
                    //剔除最近联络时间输入框和归属组
                    return item.key !== 'userName'
                        && item.key !== 'isConnect'
                        && item.key !== 'serviceId'
                        && item.key !== 'result'
						&& item.key !== 'latestCntTime'
						&& item.key !== 'serviceGroupId'
                        && item.key !== 'status';
                });
                self.initGrid();
            });
        },
        mounted : function () {
            var $btn = $("#customerSearchBarExtendBtn");
            $("#customerSearchBarExtend").on("hidden.bs.collapse", function () {
                $btn.html('<i class="fa fa-caret-down"></i>更多');
            }).on("shown.bs.collapse", function () {
                $btn.html('<i class="fa fa-caret-down"></i>收起');
            });
        },

        data : function () {
            return {
                cacheQueryFields: {}, // 缓存查询参数
                hasStatus: false,
                searchFormData       : {
                    status: '',
                    teleActivityId: this.teleActivityId,
                    userName      : "", //用户名称
                    serviceId     : "", //归属人
                    result        : "", //业务结果 1
                    isConnect     : ""  //呼叫结果 1
                },
                colSelectList        : ['userName', 'result', 'telPhone', 'serviceId'],
                nameListField        : [],
                dropDownNameListField: [],//传递给自定义字段搜索区域
                selfDefiningFieldUrl : config.ORIGIN_URL + '/names/getNameListField',
                BUSINESS_STATUS_MAP : _.map(config.BUSINESS_STATUS_MAP, function (text, value) {
                    return {
                        value: value,
                        text : text
                    }
                }),
                CONNECT_RESULT_ENUM  : _.map(config.IS_CONNECT_MAP, function (text, value) {
                    return {
                        value: value,
                        text : text
                    }
                }),
                grid                 : null,
                hasResult            : false, // 是否有查询结果
                hasSelected          : false // 是否有勾选项
            };
        },
        methods : {
            setFormData   : function (data) {
                this.searchFormData[data.key] = data.value;
            },
            clear         : function () {
                this.$refs.customFields.reset();
                let searchFormData = this.searchFormData;
                for (let item in searchFormData) {
                    if (searchFormData.hasOwnProperty(item) && item !== 'teleActivityId') {
                        searchFormData[item] = '';
                    }
                }
            },
            query         : function () {
                // 缓存查询参数
                this.cacheQueryFields = {};
                let fields = this.searchFormData;
                let cacheQueryFields = this.cacheQueryFields;
                for(let item in fields){
                    if(fields.hasOwnProperty(item) && fields[item]){
                        cacheQueryFields[item] = fields[item].trim();
                    }
                }
            	//把某些字段 字符串类型转换成整形
            	if(this.cacheQueryFields.callNum !== "" && this.cacheQueryFields.callNum !== undefined){
            		this.cacheQueryFields.callNum = +this.cacheQueryFields.callNum;
                }

                this.grid.reload({"condition": JSON.stringify(_.extend({"teleActivityId": this.teleActivityId}, this.cacheQueryFields))});
            },
            initGrid      : function () {
                let self    = this;
                var columns = [];

                //如果nameListField 已经加载 就从nameListField 和 自定义列 筛选出表格的头,否则使用默认的头
                if (this.nameListField.length) {
                    _.each(this.colSelectList, function (item) {
                        _.each(this.nameListField, function (field) {
                            if (field.key === item) {
                                columns.push({
                                    title: field.name,
                                    field: field.key,
                                    width: 100
                                });
                            }
                        });
                    }.bind(this));
                }

                else {
                    columns = [
                        {title: "姓名", field: "userName",width:'100'},
                        {title: "归属人", field: "serviceId",width:'100'},
                        {title: "业务结果", field: "result",width:'100'},
                        {title: "手机", field: "telPhone",width:'100'}
                    ];
                }

                // 排序columns
                let sortColumns = [];
                self.nameListField.forEach(function (itemName) {
                    columns.forEach(function (itemColumns) {
                        if (itemName.key === itemColumns.field) {
                            sortColumns.push(itemColumns);
                        }
                    })
                });

                // 将 serviceGroupId / serviceId 换成相应的 name
                columns.map(function (item) {
                    if (item.field === 'serviceGroupId') {
                        item.field = 'serviceGroupName'
                    }
                    if(item.field === 'serviceId'){
                        item.field = 'serviceName'
                    }
                    let fieldsWidth = ['telPhone','fixedPhone','email','userDesc','remark','latestCntTime']; // 调整字段的宽度
                    if (fieldsWidth.indexOf(item.field) !== -1) {
                        item.width = 160
                    }

                });
                this.grid = $("#customerGrid").datagrid({
                    url        : config.ORIGIN_URL + '/names/queryNamesByCondition',
                    param      : {condition:JSON.stringify(_.extend({teleActivityId:this.teleActivityId},this.searchFormData))},
                    columns    : sortColumns,
                    pagination : true,
                    checkBox   : true,
                    rowNum     : false,
                    pageSize   : 30,
                    ajaxDone: function(data) {
                        // 更改 hasResult 的状态
                        self.hasResult = data.rows.length > 0;
                        data.rows = data.rows.map(item => {
                            item.userName = '<a class="customer-list-grid__a__table-link" onclick="openNameDetails(\'' + item.namesId + '\',\'' + item.userName + '\',event)">' + item.userName + '</a>';
                            item.isConnect = window.ACT_CONFIG.IS_CONNECT_MAP[item.isConnect];
                            item.status = window.ACT_CONFIG.NAME_LIST_STATUS_MAP[item.status];
                            item.result = window.ACT_CONFIG.BUSINESS_STATUS_MAP[item.result];
                            return item;
                        });
                        return data;
                    },
                    onChange: function () {
                        self.hasSelected = self.grid.getSelected().length > 0;
                    }
                });
            },
            // 回收
            recycle : function () {
                let self        = this;
                let arrSelected = this.grid.getSelected();
                for (let i = 0, len = arrSelected.length; i < len; i++) {
                    arrSelected[i] = arrSelected[i].namesId;
                }
                $.ajax({
                    url    : location.origin + '/names/recycleNameList',
                    type   : 'post',
                    data   : {
                        teleActivityId: this.teleActivityId,
                        recycleType: 'nameList', // 回收类型: {'nameList': '名单', 'agent': '员工', 'batch': '批次'}
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
            // 导出客户
            exportCustomer: function (tag) {
                let params = {
                    tag: tag, // 1: 全部 2: 选中
                    sub: 1, // 1: 名单 2: 员工 3: 批次
                    info: {},
                };
                params.info.teleActivityId = this.teleActivityId;
                if(params.tag === 2){
                    let ids = this.grid.getSelected().map(function (item) {
                        return item.namesId;
                    });
                    params.idsjson = ids.join(',');
                }else {
                    params.info = JSON.parse(JSON.stringify(this.cacheQueryFields));
                    params.info.teleActivityId = this.teleActivityId;
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
        watch     : {
            colSelectList: function (newVal) {
                let self = this;
                //保存当前客户自定义列信息
                $.ajax({
                    url    : location.origin + '/names/checkField',
                    data   : {
                        checkedKeys: newVal.join(',')
                    },
                    success: function (data) {
                        if (data.success) {
                            self.initGrid();
                        }
                    }
                })
            },
            refresh: function (newVal) {
                this.query();
            }
        },
        components: {
        	selfDefiningFieldBar,
            "agent-select":agentSelect
        }
    }
</script>
<style lang="less" scoped>

    .customer-list-grid__search-bar {
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
    &:hover {
        background-color: #eff4f5;
        color: #000;
    }
    }
    input[type=checkbox] {
        margin: 0 5px;
    }
    &>.dropdown-menu {
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
    .customer-list-grid__a__table-link{
        color: #009688;
    }
    .customer-list__export-btn{
        margin-top: -70px;
    }
</style>
<style>
    .td-content {
        white-space: nowrap;
        text-overflow: ellipsis;
        overflow: hidden;
    }
</style>
