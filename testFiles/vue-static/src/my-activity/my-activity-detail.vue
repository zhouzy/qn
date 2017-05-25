<template>
    <div class="my-activity-detail-container">
        <page-header :top-title="activityName">
            <template slot="topContent">
                <div class="text-right my-activity-detail__dropdown-menu">
                    <div class="dropdown">
                        <button class="btn btn-default dropdown-toggle" id="colSelectBtn" type="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="true" style="border: 1px solid #eee;"> 自定义列<span class="caret"></span> </button>
                        <ul class="dropdown-menu dropdown-menu-right" aria-labelledby="colSelectBtn">
                            <li v-for="item in nameListField">
                                <label><input type="checkbox" :value="item.key" v-model="colSelectList">{{item.name}}</label>
                            </li>
                        </ul>
                    </div>
                </div>
            </template>
        </page-header>
        <div class="row container-fluid">
            <div class="my-activity-detail-root">
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
                                    <div class="form-group">
                                        <label class="control-label col-sm-4">业务状态:</label>
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
            </div>
            <div class="my-activity-detail__table-container">
                <table id="customerGrid"></table>
            </div>
            <div class="manage-tool-sidebar__container" :class="{ 'manage-tool-sidebar__container__show' : toolSideBar_IsShow, 'manage-tool-sidebar__container__full-screen':!leftMenuOpen}">
                <button @click="clearSelect" class="my-activity-detail__btn__bottom-clear btn btn-raised">清除选择</button>
                <div class="my-activity-detail__btn__bottom-right">
                    <select @change="changeResult" :class="[{'btn-disabled': isRunStatus},'my-activity-detail__select__bottom-right']" v-model="nameResult" name="" id="" :disabled="isRunStatus">
                        <option v-for="item in nameResultList" :value="item.value">{{item.text}}</option>
                    </select>
                </div>
            </div>
        </div>
        <addReservationModal :isOpen="openReservationModal" v-on:doAdd="addReservation" v-on:cancelAdd="cancelAdd"></addReservationModal>
    </div>
</template>

<script type="text/ecmascript-6">
    import pageHeader from '../lib-components/page-header.vue';
    import queryPanel from '../lib-components/query-panel.vue';
    import queryTable from '../all-activity-components/activity-manage/activity-manage-table.vue';
    import axios from 'axios';
    import selfDefiningFieldBar from '../lib-components/self-defining-field-bar.vue';
    import addReservationModal from '../reservation-manage/add-reservation-modal.vue';
    import toolSidebar from '../all-activity-components/activity-manage/activity-manage-tool-sidebar.vue';
    import config from '../lib-js/config';
    import querystring from 'querystring';
    export default{
        props: ['topTitle'],
        created: function () {
            // 归属人下拉框
            let self = this;
            $.get(location.origin + '/groupMongo/getAgentGroups',function(resp){
                if(resp.success){
                    self.agentList = resp.rows;
                    var select2Data = [{text:'全部',id:'-1'}];
                    _.each(resp.rows,function(item){
                        select2Data.push({
                            text : item.groupName,
                            children : _.map(item.members,function(op){
                                return {
                                    id : op.userId,
                                    text : op.userName
                                }
                            })
                        });
                    });
                    $("#agentListSelectCustomer").select2({
                        data : select2Data,
                        language: "zh-CN"
                    }).on("select2:select",function(){
                        var val = $("#agentListSelectCustomer").val();
                        if(val === "-1"){
                            val = "";
                        }
                        self.searchFormData.serviceId = val;
                    });

                    $.post(self.selfDefiningFieldUrl).then(function (resp) {
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

                        // 不展示的字段Map表
                        let hiddenFieldsMap = {
                            userName: '1',
                            isConnect: '1',
                            result: '1',
                            latestCntTime: '1',
                            serviceGroupId: '1',
                            status: '1',
                            serviceId: '1'
                        };

                        // 如果是坐席且该活动是受保护的，则隐藏受保护字段
                        if(USER_G.userType === '2' && self.isProtected === '0') {
                            hiddenFieldsMap.telPhone = '1';
                            hiddenFieldsMap.fixedPhone = '1';
                            hiddenFieldsMap.email = '1';
                        }
                        self.dropDownNameListField = _.filter(resp.rows, function (item) {
                            if (item.key === 'status') {
                                self.hasStatus = true;
                            }
                            item.isRequired = false;


                            // 剔除不展示字段
                            return hiddenFieldsMap[item.key] !== '1';
                        });
                        self.initGrid();
                    });
                }
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
        data: function () {
            return {
                isRunStatus: this.$route.query.status != '1', // 是否处于运行状态 '1'
                hasStatus: false,
                teleActivityId: this.$route.query.teleActivityId,
                myActivitySelect: '',
                searchFormData : {
                    userName       : "", //用户名称
                    resultDesc     : "", //业务状态
                    telPhone       : "", //电话号码
                    callNum        : "", //呼叫次数
                    isConnect      : "", //呼叫结果
                    result         : "", //沟通结果
                },
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
                selfDefiningFieldUrl : config.ORIGIN_URL + '/names/getNameListField',
                resultList: [],
                nameListField: [],
                dropDownNameListField: [],
                colSelectList: ['userName','result','telPhone','callNum','isConnect'],
                isSelected: [],
                nameResult: "",
                namesId : "",
                customId: '',
                nameResultList: [
                    {value: "0", text: "未联系到"},
                    {value: "1", text: "跟进"},
                    {value: "2", text: "预约回呼"},
                    {value: "5", text: "成单"},
                    {value: "7", text: "已购买"},
                    {value: "8", text: "无效名单"},
                    {value: "9", text: "拒绝"}
                ],
                agentList : [],
                openReservationModal : false //显示添加预约模态窗口
            }
        },
        computed: {
            thisActivity: function () {
                return this.$store.state.allActivity.activities.filter(el => el.teleActivityId == this.teleActivityId);
            },
            // 活动是否受保护(加密) '1': 不保护，'0': 保护
            isProtected: function () {
                return (this.thisActivity)[0].numberProtect;
            },
            activityName: function () {
                return (this.thisActivity)[0].activityName;
            },
            activities: function () {
                return this.$store.state.allActivity.activities;
            },
            toolSideBar_IsShow: function () {
                return this.isSelected.length;
            },
            leftMenuOpen: function () {
                return this.$store.state.leftMenuIsOpen;
            }
        },
        methods: {
            clearSelect: function () {
                this.grid.clearSelected();
                this.isSelected = this.grid.getSelected();
            },
            clearFields: function () {
                this.$refs.customFields.reset();
                for(let item in this.searchFormData){
                    this.searchFormData[item] = "";
                }
            },
            clear: function () {
                this.$refs.customFields.reset();
                let searchFormData = this.searchFormData;
                for (let item in searchFormData) {
                    if (searchFormData.hasOwnProperty(item) && item !== 'teleActivityId') {
                        searchFormData[item] = '';
                    }
                }
                $('#select2-agentListSelectCustomer-container').text('全部').attr('title', '全部');
            },
            setFormData : function(data){
                this.searchFormData[data.key] = data.value;
            },
            initGrid : function(){
                let columns = [];
                let that = this;
                //如果nameListField 已经加载 就从nameListField 和 自定义列 筛选出表格的头,否则使用默认的头
                if(this.nameListField.length){
                    _.each(this.colSelectList,function(item){
                        _.each(this.nameListField,function(field){
                            if(field.key === item){
                                columns.push({
                                    title : field.name,
                                    field : field.key
                                });
                            }
                        });
                    }.bind(this));
                }
                else{
                    columns = [
                        {title:"客户姓名",field:"userName"},
                        {title:"业务状态",field:"result"},
                        {title:"电话号码",field:"telPhone"},
                        {title:"呼叫次数",field:"callNum"},
                        {title:"呼叫结果",field:"isConnect"}
                    ];
                }

                // 排序columns
                let sortColumns = [];
                that.nameListField.forEach(function (itemName) {
                    columns.forEach(function (itemColumns) {
                        if (itemName.key === itemColumns.field) {
                            sortColumns.push(itemColumns);
                        }
                    })
                });

                // 修改字段宽度
                sortColumns.map(function (item) {
                    let fieldsWidth = ['telPhone','fixedPhone','email','userDesc','remark','latestCntTime']; // 调整字段的宽度
                    if (fieldsWidth.indexOf(item.field) !== -1) {
                        item.width = 160
                    }else {
                        item.width = 100
                    }
                });

                let timeNow = new Date().getTime();
                this.grid = $("#customerGrid").datagrid({
                    url        : config.ORIGIN_URL + '/names/queryMyNames' + '?time=' + timeNow,
                    param      : {condition:JSON.stringify(_.extend({teleActivityId:this.teleActivityId},this.searchFormData))},
                    columns    : sortColumns,
                    pagination : true,
                    checkBox   : false,
                    rowNum     : false,
                    ajaxDone   : function(data){
                    	data.rows = _.map(data.rows,function(item){
                            let detailParamsString = JSON.stringify({
                                namesId: item.namesId,
                                title: item.userName,
                                entry: 'myActivity'
                            });
                            item.userName = '<a class="my-activity-detail__a__table-link" onclick=\'openNameDetailsTab(' + detailParamsString + ', event)\'>' + item.userName + '</a>';
                            let showNum = USER_G.userType == 3 ? item.telPhone : item.protectNum;
                            if (that.$route.query.status === '1') {
                                item.telPhone = `<a class="my-activity-detail__a__table-link" onclick="openCall('${item.telPhone}','${item.teleActivityId}','${item.namesId}','${item.displayNumber}',event)">${showNum}</a>`;
                            }else {
                                item.telPhone = `<a class="my-activity-detail__a__table-link" style="color: #666;">${showNum}</a>`;
                            }
                            item.isConnect = window.ACT_CONFIG.IS_CONNECT_MAP[item.isConnect];
                            item.status = window.ACT_CONFIG.NAME_LIST_STATUS_MAP[item.status];
                            item.result = window.ACT_CONFIG.BUSINESS_STATUS_MAP[item.result];
                            item.fixedPhone = USER_G.userType == 3 ? item.fixedPhone : item.protectFixed;
                            item.email = USER_G.userType == 3 ? item.email : item.protectEmail;
                            item.serviceId = item.serviceName;
                            item.serviceGroupId = item.serviceGroupName;
                    		return item;
                        });
                    	return data;
                    },
                    onChange : function () {
                        that.isSelected = this.getSelected();
                    },
                    onSelected: function () {
                        that.nameResult = (that.nameResultList.filter(el => el.text == (this.getSelected())[0].result))[0].value;
                        that.namesId = (this.getSelected())[0].namesId;
                        that.customId = (this.getSelected())[0].customId;
                    }
                });
            },
            query : function(){
                if(this.searchFormData.callNum !== "" && this.searchFormData.callNum !== undefined){
                    this.searchFormData.callNum = +this.searchFormData.callNum;
                }
                this.grid.reload({ "condition":JSON.stringify(_.extend({"teleActivityId":this.teleActivityId},this.searchFormData))});
            },
            changeResult : function () {
                var selected = this.grid.getSelected();
                if(selected.length){
                    //如果是预约回呼，则弹出添加预约窗口，如果保存了预约，就修改结果为预约回呼，否则下拉框回到上一个状态
                    if(this.nameResult === "2"){
                        this.openReservationModal = true;
                    }
                    else if(this.nameResult !== this._getValueByResultText()){
                        let that = this;
                        this.axios.post('/names/updateNamesDetail', querystring.stringify({
                            info : JSON.stringify({result: that.nameResult}),
                            teleActivityId: that.teleActivityId,
                            namesId : that.namesId,
                            customId: that.customId
                        })).then(function (res) {
                            that.grid.reload({ "condition":JSON.stringify(_.extend({"teleActivityId":that.teleActivityId},that.searchFormData))});
                            that.isSelected = [];
                        });
                    }
                }
            },
            //添加预约
            addReservation : function(reservation){
                let that = this;
                this.axios.post('/appointment/addAppointment', querystring.stringify({
                    appointmentTime: reservation.reserveTime,
                    reason: reservation.reason,
                    namesId: this.isSelected[0].namesId,
                    teleActivityId: this.teleActivityId
                })).then(function(){
                    return that.axios.post('/names/updateNamesDetail', querystring.stringify({
                        info : JSON.stringify({result: '2'}),
                        teleActivityId: that.teleActivityId,
                        namesId : that.namesId,
                        customId: that.customId
                    }));
                }).then(function (res) {
                    that.grid.reload({ "condition":JSON.stringify(_.extend({"teleActivityId":that.teleActivityId},that.searchFormData))});
                    that.isSelected = [];
                    that.openReservationModal = false;
                });
            },
            //取消添加预约
            cancelAdd : function(){
                console.log('取消添加预约');
                //取消添加预约，重置下拉框的选项
                if(this.isSelected.length){
                    this.nameResult = this._getValueByResultText();
                }
                this.openReservationModal = false;
            },
            //获取表格选择项业务状态的value
            _getValueByResultText: function(){
                return (this.nameResultList.filter(el => el.text == (this.isSelected)[0].result))[0].value;
            }
        },
        watch : {
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
            }
        },
        components: { pageHeader,queryPanel,queryTable,selfDefiningFieldBar,toolSidebar,addReservationModal}
    }
</script>

<style lang="less">
    .td-content {
        text-overflow: ellipsis;
        overflow: hidden;
        white-space: nowrap;
    }
    .my-activity-detail-container{
        padding: 0 15px;
        height:100%;
        overflow: auto;
    }
    .my-activity-detail-root{
        margin-top:10px;
        background: #fff;
        padding: 0 15px;
    }
    .my-activity-detail__dropdown-menu{
        float: right;
    }
    .my-activity-detail__btn__bottom-clear{
        float: left;
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
    .my-activity-detail__table-container{
        margin-top:20px;
        padding: 0 15px;
        background: #fff;

        td {
            width: 140px;
        }
    }
    .manage-tool-sidebar__container{
        height:60px;
        font-size:14px;
        background: #fff;
        padding:0 15px;
        position: fixed;
        z-index: 9;
        bottom: -70px;
        left: 300px;
        right:0;
        box-shadow: 0 -1px 3px rgba(0, 0, 0, 0.15);
         -webkit-transition: all ease 0.4s;
         -moz-transition: all ease 0.4s;
         -o-transition: all ease 0.4s;
        transition: all ease 0.4s;
    }
    .manage-tool-sidebar__container__show{
        bottom: 0;
    }
    .manage-tool-sidebar__container__full-screen{
        left: 0;
    }
    .my-activity-detail__btn__bottom-right{
        float: right;
        height: 30px;
        width: 150px;
        margin: 15px 0;
    }
    .btn-disabled {
        cursor: not-allowed;
    }
    .my-activity-detail__select__bottom-right{
        width: 100%;
        height: 100%;
    }
    .my-activity-detail__a__table-link{
        color: #009688;
    }
    .selected .my-activity-detail__a__table-link{
        color: #fff;
    }
</style>
