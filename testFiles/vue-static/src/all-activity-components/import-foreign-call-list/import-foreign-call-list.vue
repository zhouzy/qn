<template>
    <div class="import-foreign-call-list">
        <pageHeader :topTitle="pageHeader"></pageHeader>
        <div class="container-fluid">
            <div class="panel import-foreign-call-list__main">
                <form class="import-foreign-call-list__form">
                    <div class="import-foreign-call-list__row">
                        <label class="import-foreign-call-list__label col-sm-2 text-right">活动名称：</label>
                        <span class="import-foreign-call-list__name">{{activity}}</span>
                    </div>
                    <div class="import-foreign-call-list__row">
                        <label class="import-foreign-call-list__label col-sm-2 text-right">活动描述：</label>
                        <p class="import-foreign-call-list__des col-sm-10">{{description}}</p>
                    </div>
                    <div class="import-foreign-call-list__row clearfix">
                        <label class="import-foreign-call-list__label col-sm-2 text-right">已导入批次：</label>
                        <span v-for="batch in batchNames" class="badge import-foreign-call-list__badge">{{batch}}</span>
                    </div>
                    
                    <div class="import-foreign-call-list__row">
                        <label class="import-foreign-call-list__label col-sm-2 text-right">批次名称：</label>
                        <input type="text" placeholder="请输入批次名称" class="import-foreign-call-list__input" name="batchName" v-model="batchName">
                    </div>
                    <div>
                        <label class="import-foreign-call-list__label col-sm-2 text-right">名单来源：</label>
                        <label class="import-foreign-call-list__label"><input type="radio" v-model="sourceType" name="listSource" value="sourceFile">
                            文件导入
                        </label>
                        <label class="import-foreign-call-list__label"><input type="radio" v-model="sourceType" name="listSource" value="sourceCustom">
                            从客户筛选
                        </label>
                        <label class="import-foreign-call-list__label"><input type="radio" v-model="sourceType" name="listSource" value="sourceActivity">
                            从现有活动筛选
                        </label>
                    </div>
                    <div class="import-foreign-call-list__row" v-show="sourceType==='sourceFile'">
                        <label class="import-foreign-call-list__label col-sm-2 text-right"></label>
                        <input type="file" accept=".XLS,.xlsx" name="fileImport" value="选择" class="import-foreign-call-list__upload" @change="upload">
                        <a href="javascript:void(0)" class="import-foreign-call-list__download" @click="download">点击下载导入模板</a>
                    </div>

                    <!-- 使用客户筛选器导入外呼名单 -->
                    <div class="import-foreign-call-list__row" v-show="sourceType==='sourceCustom'">
                        <label class="import-foreign-call-list__label col-sm-2 text-right"></label>
                        <template>
                        <el-select v-model="selectFilter" name="filter" filterable>
                            <el-option v-for="item in cstFilters" :label="item.title" :value="item.conditionId">
                                <span style="float:left">{{item.title}}</span>
                                <span style="float:right">{{item.num}}</span>
                            </el-option>
                        </el-select>
                        </template>
                    </div>

                    <!-- 使用活动筛选器导入外呼名单 -->
                    <div class="import-foreign-call-list__row" v-show="sourceType==='sourceActivity'">
                        <label class="import-foreign-call-list__label col-sm-2 text-right"></label>
                        <el-select v-model="fromTeleActivityId" :on-change="selectActivity()" filterable>
                            <el-option v-for="item in allActivity" :label="item.activityName" :value="item.teleActivityId"> </el-option>
                        </el-select>
                        <el-select v-model="result" :on-change="selectResult()">
                            <el-option v-for="item in businessList" :label="item.label" :value="item.value"></el-option>
                        </el-select>
                        <span>名单数量</span><span class="badge import-foreign-call-list__badge">{{nameNumber}}</span>
                    </div>
                    <div class="import-foreign-call-list__row clearfix">
                        <button type="button" class="btn btn-xs btn-raised pull-left" @click="cancelSubmit">取消</button>
                        <button type="submit" class="btn btn-xs btn-raised btn-primary pull-right" v-bind:class="{disabled:submiting}" @click.prevent="submit">提交 </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</template>
<script>
    import pageHeader from '../../lib-components/page-header.vue';
    import config from '../../lib-js/config';
    export default{
        created: function () {
            let self = this;
            let id = this.$route.query.id;
            let url = location.origin + '/teleActivity/findActivityDetail';
            this.teleActivityId = id;
            $.ajax({
                url: url,
                data: {teleActivityId: id},
                success: function (data) {
                    if (!data.success) {
                        notice.danger(data.msg);
                        return;
                    }
                    self.activity = data.rows.activityName;
                    self.description = data.rows.activityDescrible;
                    let batches=data.rows.batches;
                    for(let i=0,len=batches.length;i<len;i++){
                        self.batchNames.push(batches[i].batchName);
                    }
                }
            });
            this.queryConditionList();
            this.queryAllActivity();
        },
        data: function () {
            var _bsList = Object.keys(config.BUSINESS_STATUS_MAP).map(function(item){
                return {
                    value : item,
                    label : config.BUSINESS_STATUS_MAP[item]
                };
            });
            _bsList.unshift({
                value : '-1',
                label : '所有'
            });
            return {
                businessList : _bsList,
                allActivity : [],
                fromTeleActivityId : '',
                result : '-1',          //名单状态
                nameNumber:0,           //根据活动筛选出的名单数量

                activity: '',
                description: '',
                batchNames:[],
                teleActivityId: '',
                batchName:'',
                hasFile:false,          //是否选择了文件，不选择无法上传

                submiting:false,        //是否正在提交

                sourceType:"sourceFile",//名单导入方式默认为文件导入
                selectFilter : '',      //客户名单筛选器ID
                cstFilters : []         //待选的客户名单筛选器
            }
        },
        computed: {
            pageHeader: function () {
                return '为' + this.activity + '活动导入外呼名单';
            }
        },
        methods: {
            download: function () {
                this.axios.post('nameImport/downloadNameTemplet').then(res => {
                    if (!res.data.success) {
                        return notice.danger(res.data.msg);
                    }
                    window.location.href = location.origin + '/' + res.data.rows;
                });
            },
            //上传图片
            upload: function (e) {
                if(e.target.value!==''){
                    this.hasFile=true;
                }else{
                    this.hasFile=false;
                }
            },

            //提交
            submit: function (e) {
                let id = this.teleActivityId;
                let formobj =  e.target.form;
                let formdata = new FormData(formobj);
                formdata.append('teleActivityId',id);
                if(this.batchName== ''){
                    notice.warning('请输入批次名称');
                    return;
                }
                if(this.sourceType === "sourceFile"){
                    if(!this.hasFile){
                        notice.warning('请上传文件');
                        return;
                    }
                    this.submitSourceFile(formdata);
                }
                else if(this.sourceType === "sourceCustom"){
                    if(!this.selectFilter){
                        notice.warning('请选择一个客户筛选器');
                        return;
                    }
                    this.submitSourceCst();
                }
                else if(this.sourceType === "sourceActivity"){
                    if(!this.fromTeleActivityId){
                        notice.warning('请选择一个活动');
                        return;
                    }
                    if(this.nameNumber === "0" || this.nameNumber === 0){
                        notice.warning('导入名单不能为空');
                        return;
                    }
                    this.submitSourceAct(formdata);
                }
            },

            //使用文件方式导入名单提交
            submitSourceFile : function(formData){
                var self = this;
                let url = location.origin + '/nameImport/upload';
                this.submiting = true;
                return $.ajax({
                    url: url,
                    type: 'POST',
                    cache: false,
                    data: formData,
                    processData: false,
                    contentType: false,
                    success : function(data){
                        self.submiting = false;
                        if (!data.success) {
                            notice.danger(data.msg);
                            return;
                        }
                        location.hash='/control/import-foreign-call-list/import-list-success?params='+JSON.stringify(data.rows)+'&activity='+self.activity +'&batchName='+self.batchName+'&sourceType='+self.sourceType;
                    }
                });
            },

            //使用客户来源方式导入名单提交
            submitSourceCst : function(){
                this.submiting = true;
                var self = this;
                var param = {
                    batchName : this.batchName,
                    teleActivityId : this.teleActivityId,
                    conditionId : this.selectFilter
                };
                $.post(location.origin + '/nameImport/uploadFromCustom',param).then(function(data){
                    self.submiting = false;
                    if (!data.success) {
                        notice.danger(data.msg);
                        return;
                    }
                    location.hash='/control/import-foreign-call-list/import-list-success?params='+JSON.stringify(data.rows)+'&activity='+self.activity +'&batchName='+self.batchName+'&sourceType='+self.sourceType;
                });
            },

            //使用活动筛选名单的方式导入名单提交
            submitSourceAct : function(){
                this.submiting = true;
                var self = this;
                var result = this.result === "-1" ? "" : this.result;
                var param = {
                    batchName : this.batchName,
                    toTeleActivityId : this.teleActivityId,
                    fromTeleActivityId : this.fromTeleActivityId,
                    result : result
                };
                $.post(location.origin + '/nameImport/importFromExistNames',param).then(function(data){
                    self.submiting = false;
                    if (!data.success) {
                        notice.danger(data.msg);
                        return;
                    }
                    location.hash='/control/import-foreign-call-list/import-list-success?params='+JSON.stringify(data.rows)+'&activity='+self.activity +'&batchName='+self.batchName+'&sourceType=' + self.sourceType;
                });
            },

            /**
             * 查询所有的客户筛选器
             */
            queryConditionList : function(){
                $.post(location.origin + '/queryUserCondition/queryConditionList?',{isDefault:'-2',isMore:'0'},function(resp){
                    if(resp.success){
                        var _cstFilterer = resp.rows;
                        _cstFilterer.forEach(function(item){
                            _.extend(item,item.condition);
                        });
                        this.cstFilters = _cstFilterer;
                    }
                }.bind(this));
            },

            /**
             * 查询所有的活动
             */
            queryAllActivity : function(){
                var self = this;
                $.post(location.origin + '/teleActivity/findAllActivitiesOnlyShowName?',{},function(resp){
                    if(resp.success){
                        resp.rows.splice(resp.rows.findIndex(function(item){
                            return item.teleActivityId === self.teleActivityId;
                        }),1);
                        this.allActivity = resp.rows;
                    }
                }.bind(this));
            },

            /**
             * 根据活动ID和业务状态ID查询该活动下对应状态的所有名单
             */
            queryNumber : function(){
                var self = this;
                var result = this.result === "-1" ? "" : this.result;
                $.post(location.origin + '/names/queryNamesCountByResult',{teleActivityId:this.fromTeleActivityId,result:result}).then(function(resp){
                    if(resp.success){
                        self.nameNumber = resp.msg;
                    }
                });
            },

            //选择活动业务状态后查询名单数量
            selectActivity : function(){
                this.queryNumber();
            },

            //选择活动业务状态后查询名单数量
            selectResult : function(){
                if(this.fromTeleActivityId){
                    this.queryNumber();
                }
            },

            //取消提交
            cancelSubmit:function () {
                location.hash='/control';
            }
        },
        components: {pageHeader}
    }
</script>
<style lang="less" scoped>
    .import-foreign-call-list__main {
        background: #fff;
        margin-top: 10px;
        padding: 30px;
    }

    .import-foreign-call-list__row {
        margin-bottom: 10px;
    }

    .import-foreign-call-list__label {
        font-weight: lighter;
        font-size: 14px;
        color: #374051;
    }
    .import-foreign-call-list__badge{
        margin-right:5px;
        font-size: 12px;
        font-weight: normal;
        background: #009688;
    }
    .import-foreign-call-list__des {
        display: inline-block;
        margin: 0;
        padding: 0;
        vertical-align: top;
    }
    .import-foreign-call-list__form{
        width: 900px;
    }
    .import-foreign-call-list__input {
        width: 300px;
        height: 24px;
        padding: 0 5px;
        border: 1px solid #a9a9a9;
        border-radius: 2px;
        font-size: 14px;
    }

    .import-foreign-call-list__upload {
        display: inline-block;
    }

    .import-foreign-call-list__download {
        font-size: 14px;
    }

    .import-foreign-call-list__download:hover {
        text-decoration: underline;
    }
    .green-text{
        display:inline-block;
        color: #296b4f;
        margin:0 5px;
    }
</style>
