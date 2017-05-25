<template>
    <div class="activity-create__main">
        <page-header :top-title="_activityName"></page-header>
        <div class="activity-create__container clearfix">
            <form action="" class="activity-create__container__form clearfix">
                <div class="col-md-12">
                    <div class="form-group clearfix">
                        <label class="control-label col-md-2 activity-create__container__label" for="activityName"><span class="activity-create__must">*</span>活动名称：</label>
                        <div class="col-md-6">
                            <input v-model="activityName" :disabled="isDisable" class="form-control col-md-6" type="text" id="activityName">
                        </div>
                    </div>
                    <div class="form-group clearfix">
                        <label class="control-label col-md-2 activity-create__container__label" for="activityDescrible">活动描述：</label>
                        <div class="col-md-6">
                            <textarea v-model="activityDescrible" :disabled="isDisable" class="form-control col-md-6" type="text" id="activityDescrible" rows="3"></textarea>
                        </div>
                    </div>
                    <div class="form-group clearfix">
                        <label class="control-label col-md-2 activity-create__container__label" for="status">活动状态：</label>
                        <div class="col-md-2">
                            <select v-model="status" class="form-control" name="status" id="status">
                                <option value="0">准备</option>
                                <option value="1">运行</option>
                                <option value="2">暂停</option>
                                <option value="3">停止</option>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="col-md-10 clearfix">
                    <div style="float: left;" class="form-group col-md-5">
                        <label class="control-label col-md-6 activity-create__container__label" for="displayNumber">外显示号码：</label>
                        <div class="col-md-6">
                            <select class="form-control" v-model="displayNumber" name="displayNumber" id="displayNumber">
                                <option value="">请选择</option>
                                <option v-for="item in displayNumArr" :value="item.displayNumber">{{item.displayNumber}}</option>
                            </select>
                        </div>
                    </div>
                    <div style="float: left;" class="form-group col-md-5">
                        <label class="control-label col-md-6 activity-create__container__label" for="distributeWay"><span class="activity-create__must">*</span>名单分配方式：</label>
                        <div class="col-md-6">
                            <select class="form-control" v-model="distributeWay" name="distributeWay" id="distributeWay">
                                <option value="">请选择</option>
                                <option value="0">管理员分配</option>
                                <!--<option value="1">手动获取</option>-->
                            </select>
                        </div>
                    </div>
                </div>
                <div class="col-md-10 clearfix">
                    <div style="float: left;" class="form-group col-md-5">
                        <label class="control-label col-md-6 activity-create__container__label" for="numberProtect"><span class="activity-create__must">*</span>号码保护：</label>
                        <div class="col-md-6">
                            <select v-model="numberProtect" class="form-control" name="numberProtect" id="numberProtect">
                                <option value="">请选择</option>
                                <option value="0">活动加密号码</option>
                                <option value="1">不保护</option>
                            </select>
                        </div>
                    </div>
                    <div style="float: left;" class="form-group col-md-5">
                        <label class="control-label col-md-6 activity-create__container__label" for="endTime"><span class="activity-create__must">*</span>活动到期时间：</label>
                        <div class="col-md-6 activity-create__div__end-time-container">
                            <input type="text" id="endTime" v-model="endTime">
                        </div>
                    </div>
                </div>
                <div class="col-md-10 clearfix">
                    <div style="float: left;" class="form-group col-md-5">
                        <label class="control-label col-md-6 activity-create__container__label" for="attachGroupName"><span class="activity-create__must">*</span>活动归属组：</label>
                        <div class="col-md-6">
                            <select @change="attachUserMessages = ''" v-model="attachGroupMessages" class="form-control" name="attachGroupName" id="attachGroupName">
                                <option value="">请选择</option>
                                <option v-for="item in allUserList" :value="item.groupId + ',' + item.groupName">{{item.groupName}}</option>
                            </select>
                        </div>
                    </div>
                    <div style="float: left;" class="form-group col-md-5">
                        <label class="control-label col-md-6 activity-create__container__label" for="attachUserName"><span class="activity-create__must">*</span>活动归属人：</label>
                        <div class="col-md-6">
                            <select v-model="attachUserMessages" class="form-control" name="attachUserName" id="attachUserName">
                                <option value="">请选择</option>
                                <option v-for="member in attachUserNameArr" :value="member.userId + ',' + member.userName">{{ member.userName }}</option>
                            </select>
                        </div>
                    </div>
                </div>
            </form>
            <div class="col-md-12 clearfix">
                <p class="col-md-2 activity-create__container__distribution-p-title activity-create__container__distribution-p"><span class="activity-create__must">*</span>选择活动执行者：</p>
                <div class="col-md-3">
                    <p class="activity-create__container__distribution-p">点击选择员工</p>
                    <div class="activity-create__distribution__list-container">
                        <div class="activity-create__distribution__list-searchbar-container">
                            <input v-model="searchKeyWord" placeholder="输入客服名称搜索" type="text" class="activity-create__distribution__list-searchbar">
                        </div>
                        <div class="activity-create__distribution__user-list">
                            <template v-if="searchKeyWord==''">
                                <ul class="activity-create__distribution__list-ul">
                                    <li class="activity-create__distribution__list-li" v-for="group in userList">
                                        <div class="activity-create__div__group-name text-nowrap" @dblclick="chooseGroup(group.groupId)">{{group.groupName}}</div>
                                        <ul class="activity-create__distribution__list-ul">
                                            <li @dblclick="chooseName"
                                                class="activity-create__distribution__list-li activity-create__distribution__list-li-second activity-create__li__hover user-not-select"
                                                v-for="member in group.members"
                                                :data = "member.userId+'-'+group.groupId"
                                            >{{member.userName}}</li>
                                        </ul>
                                    </li>
                                </ul>
                            </template>
                            <template v-else>
                                <ul class="activity-create__distribution__list-ul">
                                    <li @dblclick="chooseName"
                                        class="activity-create__distribution__list-li activity-create__li__hover user-not-select"
                                        v-for="item in searchArr"
                                        :data="item.userId+'-'+item.groupId"
                                    >{{item.userName}}<{{groupIdToName(item.groupId)}}></li>
                                </ul>
                            </template>
                        </div>
                    </div>
                </div>
                <div class="activity-create__distribution__middle-icons col-md-1">
                    <i class="fa fa-angle-double-left fa-1" aria-hidden="true"></i>
                    <br />
                    <i class="fa fa-angle-double-right fa-1" aria-hidden="true"></i>
                </div>
                <div class="col-md-3">
                    <p class="activity-create__container__distribution-p">已选择的员工</p>
                    <div class="activity-create__distribution__list-container activity-create__distribution__chosen-list-container">
                        <ul class="activity-create__distribution__list-ul">
                            <li class="activity-create__distribution__list-li activity-alter__distribution__list-li user-not-select"
                                v-for="item in resultList"
                                :data="item.userId+'-'+item.groupId"
                            >{{item.userName}}<{{groupIdToName(item.groupId)}}></li>
                        </ul>
                        <ul class="activity-create__distribution__list-ul">
                            <li @dblclick="chooseBack"
                                class="activity-create__distribution__list-li activity-create__li__hover user-not-select"
                                v-for="item in newAddArr"
                                :data="item.userId+'-'+item.groupId"
                            >{{item.userName}}<{{groupIdToName(item.groupId)}}{{item.groupId}}></li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
        <div class="activity-create__bottom-sidebar">
            <div class="activity-create__bottom-sidebar__container clearfix">
                <a class="activity-create__bottom-sidebar__left-button btn btn-raised btn-danger" href="#/control">取消</a>
                <a class="activity-create__bottom-sidebar__right-button btn btn-raised btn-success" @click="formSubmit" href="javascript:void(0)">提交</a>
            </div>
        </div>
    </div>
</template>

<script type="text/ecmascript-6">
    import pageHeader from '../lib-components/page-header.vue';
    import axios from 'axios';
    import queryString from 'queryString'

    export default {
        created: function () {
            let that = this;
            that._activity = (that.$store.state.allActivity.activities.filter(el => el.teleActivityId == that.$store.state.allActivity.checkSelect))[0];
            that._activityName = that._activity.activityName;
            that.activityName = that._activity.activityName;
            that.activityDescrible = that._activity.activityDescrible;
            that.displayNumber = that._activity.displayNumber;
            that.distributeWay = that._activity.distributeWay;
//            that.maxNumberByDay = that._activity.maxNumberByDay;
            that.numberProtect = that._activity.numberProtect;
            that.resultList = that._activity.executeUsers;
            that.endTime = that._activity.endTime;
            that.status = that._activity.status;
            this.request().then(() => {
                that.attachGroupMessages = that._activity.attachGroupId+","+that._activity.attachGroupName;
                that.attachUserMessages = that._activity.attachUserId+","+that._activity.attachUserName;
                that.resultList.forEach(el => {
                    that.userList.map(item => {
                        let index = item.members.findIndex(key => key.userId == el.userId);
                        if (index != -1){
                            item.members = [...item.members.slice(0, index),...item.members.slice(index+1)];
                        }
                    })
                })
            });
            this.getDisplayNum();
        },
        data: function () {
            return {
                _activity:{},
                isDisable: false,
                chosenList: [],
                formTitles: {},
                autoChecked: false,
                userList: [],
                allUserList: [],
                resultList: [],
                searchKeyWord: '',
                displayNumArr: [],
                displayNumber: '',
                endTime: '',
                speechIdArr: [],
                speechId: '',
                distributeWay: '',
                status: '',
//                maxNumberByDay: '',
                numberProtect: '',
                activityName: '',
                activityDescrible: '',
                attachGroupMessages: '',
                attachUserMessages: '',
                formList: new FormData(),
                isSubmitted: false,
                formTitleList: {
                    activityName: '活动名称',
                    activityDescrible: '活动描述',
                    displayNumber: '外显示号码',
                    speechId: '话术',
                    distributeWay: '名单分配方式',
//                    maxNumberByDay: '当日最大获取数',
                    numberProtect: '号码保护',
                    attachGroupName: '活动归属组',
                    attachUserName: '活动归属人'
                },
                newAddArr: [],
                _activityName: ''
            }
        },
        computed:{
            formData: function () {
                return {
                    teleActivityId: this.$store.state.allActivity.checkSelect,
                    displayNumber: this.displayNumber,
                    distributeWay: this.distributeWay,
                    status: this.status,
//                    maxNumberByDay: this.maxNumberByDay,
                    numberProtect: this.numberProtect,
                    activityName: this.activityName,
                    activityDescrible: this.activityDescrible,
                    attachGroupId: this.attachGroupMessages.split(',')[0],
                    attachGroupName: this.attachGroupMessages.split(',')[1] || '', // undefined 没有toString方法，导致报错
                    attachUserId: this.attachUserMessages.split(',')[0],
                    attachUserName: this.attachUserMessages.split(',')[1] || '',
                    autoShowSpeech: this.autoChecked === true ? 1 : 0,
                    endTime: this.endTime,
                    executeUsers: (this.resultList.concat(this.newAddArr)).map(el => {return {'userId':el.userId,'userName':el.userName,'groupId': el.groupId, 'groupName': this.groupIdToName(el.groupId)}})
                };
            },
            necessaryItem:function () {
                return {
                    activityName: this.activityName,
                    distributeWay: this.distributeWay,
//                    maxNumberByDay: this.maxNumberByDay,
                    numberProtect: this.numberProtect,
                    attachGroupName: this.attachGroupMessages.split(',')[1] || '', // undefined 没有toString方法，导致报错
                    attachUserName: this.attachUserMessages.split(',')[1] || '',
                    autoShowSpeech: this.autoChecked === true ? 1 : 0,
                    endTime: this.endTime
                }
            },
            attachUserNameArr : function () {
                if ((this.allUserList.filter(key => key.groupId == this.formData.attachGroupId))[0]){
                    return (((this.allUserList.filter(key => key.groupId == this.formData.attachGroupId))[0]).members);
                }
            },
            searchArr: function () {
                let searchArr = [];
                let re = new RegExp(this.searchKeyWord);
                this.userList.forEach(el => {
                    el.members.forEach(el => {
                        if(re.test(el.userName)){
                            searchArr.push(el);
                        }
                    })
                });

                return searchArr;
            }
        },
        methods: {
            chooseName: function (e) {
                let _data = e.target.getAttribute('data').split("-");
                let _group = this.userList.filter(el => el.groupId == _data[1])[0];
                let index = _group.members.findIndex(el => el.userId == _data[0]);
                this.newAddArr.push(_group.members[index]);
                this.userList.map(el => {
                    let index = el.members.findIndex(key => key.userId === _data[0]);
                    if (index!=-1){
                        el.members = [...el.members.slice(0, index),...el.members.slice(index+1)];
                    }
                })
            },
            chooseGroup: function (groupId) {
                let self = this;
                self.userList.forEach(function (item,index) {
                    if (item.groupId === groupId) {
                        self.newAddArr = self.newAddArr.concat(item.members);
                        item.members.forEach(function(item){
                            self._delFormLeftByUserId(item.userId);
                        });
                        item.members = [];
                        return false;
                    }
                });
            },
            chooseBack:function (e) {
                let _data = e.target.getAttribute('data').split("-");
                let index = this.newAddArr.findIndex(el => el.userId == _data[0]);
                this.allUserList.forEach(el => {
                    let _index = el.members.findIndex(el => el.userId == _data[0]);
                    if(_index!=-1){
                        let _groupId = el.groupId;
                        let _m = this.userList.filter(el => el.groupId == _groupId)[0].members;
                        //如果存在的话就不回写到原有数组中
                        if(_m.findIndex(el => el.userId === _data[0]) < 0){
                            _m.push(el.members[_index]);
                        }
                    }
                });
                this.newAddArr = [...this.newAddArr.slice(0, index),...this.newAddArr.slice(index+1)];
            },
            groupIdToName:function (groupId) {
                let _list = this.userList.filter(item => item.groupId === groupId);
                return _list.length > 0 ? _list[0].groupName : "";
            },
            _delFormLeftByUserId : function(_userId){
                if(_userId){
                    this.userList.forEach(el => {
                        el.members = el.members.filter(el => el.userId !== _userId);
                    });
                }
            },
            request: function () {
                let that = this;
                let urlparse = {
                    rows: -1,
                    entId: localStorage.getItem('entId')
                };
                let form = (function () {
                    let form = new FormData();
                    for (let item in urlparse){
                        form.append(item, urlparse[item]);
                    }
                    return form;
                }());
                return axios.post('/groupMongo/getAgentGroups', form)
                    .then(function (response) {
                        that.allUserList = JSON.parse(JSON.stringify(response.data.rows.concat()));
                        that.userList = response.data.rows;
                    });
            },
            formSubmit: function () {
                let str = '';
                this.isSubmitted = true;
                for (let key in this.necessaryItem){
                    if (this.necessaryItem[key].toString().trim() == ""){
                        str = this.formTitleList[key];
                    }
                }
                if (!str){
                    str = (function(endTime){
                        let date = (new Date(endTime)).valueOf();
                        let nowDate = Date.now().valueOf();
                        return date > nowDate ? '': '活动到期时间';
                    }(this.endTime));
                }
                if (!str){
                    let that = this;
                    axios.post('/teleActivity/updateTeleActivity', queryString.stringify({info: JSON.stringify(this.formData)}))
                        .then(function (response) {
                            if (response.data.success){
                                location.hash='#/control';
                            }else{
                                notice.danger(response.data.msg);
                                that.isSubmitted = false;
                            }
                        }).catch(function (err) {
                        notice.danger(err);
                        that.isSubmitted = false;
                    })
                }else{
                    notice.danger(`表单信息：${str}格式不正确，请确认后再提交！`);
                    let that = this;
                    setTimeout(function () {
                        that.isSubmitted = false;
                    },500);
                }
            },
            getDisplayNum: function () {
                let that = this;
                axios.post('displayNumber/findAllDisplayNumber')
                    .then(function (response) {
                        that.displayNumArr = response.data.rows;
                    })
            }
        },
        mounted: function () {
            var self = this;
            $('#endTime').timeInput({
                format: "yyyy-MM-dd hh:mm:ss",
                HMS: true,
                value: self.endTime,
                change: function () {
                    self.endTime = cri.formatDate(this.value(), 'yyyy-MM-dd HH:mm:ss');
                }
            });
        },
        components: { pageHeader }
    }
</script>
<style lang="less">
    .activity-create__container__label{
        text-align: right;
        padding-top:8px;
    }
    .activity-create__main{
        height:100%;
        overflow: auto;
        position: relative;
        padding-bottom:40px;
    }
    .activity-create__container{
        margin: 5px 10px 0 10px;
        padding: 30px 0px;
        background: #fff;
    }
    .activity-create__container__distribution-p-title{
        text-align: right;
        line-height: 1.07142857;
        margin: 16px 0 0 0;
    }
    .activity-create__container__distribution-p{
        color: #646464;
        word-break: break-all;
        font-size: 12px;
        font-weight: 400;
        text-indent:10px;
    }
    .activity-create__distribution__list-container{
        border:1px solid #bbb;
    }
    .activity-create__distribution__list-searchbar-container{
        padding:5px;
        font-size:12px;
    }
    .activity-create__must{
        color: red;
    }
    .activity-create__distribution__list-searchbar{
        height: 30px;
        padding: 5px 10px 5px 10px;
        width: 95%;
        line-height: 25px;
        border-radius: 15px;
        outline: none;
        border: 1px solid #c6c6c6;
        font-size:12px;
    &::placeholder{
         font-size:12px !important;
     }
    &:focus{
         border:1px solid #21d376;
         -webkit-box-shadow: inset 0 1px 1px rgba(0, 0, 0, 0.075), 0 0 8px rgba(82, 168, 236, 0.6);
         -moz-box-shadow: inset 0 1px 1px rgba(0, 0, 0, 0.075), 0 0 8px rgba(82, 168, 236, 0.6);
         box-shadow: inset 0 1px 1px rgba(0, 0, 0, 0.075), 0 0 8px rgba(82, 168, 236, 0.6);
     }
    }
    .activity-create__distribution__user-list{
        border-top: 1px solid #BBBBBB;
        height: 240px;
        overflow: auto;
    }
    .activity-create__distribution__middle-icons{
        text-align: center;
        padding-top:120px;
    }
    .activity-create__div__group-name{
        height:40px;
        line-height:40px;
        background: #f5f5f5;
        font-size:14px;
        font-weight:bold;
        text-overflow: ellipsis;
        overflow: hidden;
    }
    .activity-create__distribution__list-ul{
        padding-left:0;
    }
    .activity-create__distribution__list-li{
        list-style:none;
        font-size:12px;
        text-indent:8px;
        cursor: pointer;
    }
    .activity-create__li__hover{
        width:100%;
        height: 30px;
        line-height: 30px;
        word-break: break-all;
        text-overflow: ellipsis;
        white-space: nowrap;
        overflow: hidden;
    &:hover{
         background: #21d376;
         color: #fff;
     }
    }
    .activity-create__distribution__list-li-second{
        text-indent:30px;
    }
    .activity-create__bottom-sidebar{
        width:100%;
        height:30px;
    }
    .activity-create__distribution__chosen-list-container{
        overflow: auto;
        height: 280px;
    }
    .activity-create__bottom-sidebar__left-button{
        float: left;
        margin-left: 10px;
    }
    .activity-create__bottom-sidebar__right-button{
        float: right;
        margin-right:10px;
    }
    .activity-create__bottom-sidebar__container{
        margin:0 10px;
        padding:15px 0;
        background: #fff;
        overflow: hidden;
    }
    #endTime{
        width: 100%;
    }
    input#endTime + span{
        display: none;
    }
    .activity-create__div__end-time-container div{
        width: 100% !important;
        padding: 0 !important;
    }
    .activity-alter__distribution__list-li{
        background: #ccc;
        width:100%;
        height: 30px;
        line-height: 30px;
        word-break: break-all;
        text-overflow: ellipsis;
        white-space: nowrap;
        overflow: hidden;
    }
</style>
