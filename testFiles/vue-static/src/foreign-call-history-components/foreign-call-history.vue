<template>
    <div class="foreign-call-history">
        <page-header top-title="外呼历史">
        </page-header>
        <div>
            <div class="foreign-call-history__right-content-box">
                <query-panel v-on:clear="clearFields" v-on:query="queryFields">
                    <template slot="defaultFieldList">
                        <div class="col-sm-4">
                            <div class="form-group">
                                <label class="control-label col-sm-4">活动名称：</label>
                                <div class="col-sm-8">
                                    <input type="text" class="form-control" v-model="fields.activityName">
                                </div>
                            </div>
                        </div>
                        <div class="col-sm-4">
                            <div class="form-group">
                                <label class="control-label col-sm-4">呼叫结果：</label>
                                <div class="col-sm-8">
                                    <select v-model="fields.isConnected" class="form-control">
                                        <option value="1">已呼通</option>
                                        <option value="0">未呼通</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                        <div class="col-sm-4">
                            <div class="form-group">
                                <label class="control-label col-sm-4">电话号码：</label>
                                <div class="col-sm-8">
                                    <input type="text" class="form-control" v-model="fields.strDnis">
                                </div>
                            </div>
                        </div>
                        <div class="col-sm-4">
                            <div class="form-group">
                                <label class="control-label col-sm-4">客户姓名：</label>
                                <div class="col-sm-8">
                                    <input type="text" class="form-control" v-model="fields.userName">
                                </div>
                            </div>
                        </div>
                        <div class="col-sm-3">
                            <div class="form-group bs-form-group">
                                <label class="control-label col-sm-3">归属人:</label>
                                <div class="col-sm-9" style="margin-top: 8px">
                                    <select id="agentListSelectCustomer" style="width:120px" class="form-control"></select>
                                </div>
                            </div>
                        </div>
                        <!--<div class="col-sm-4 search-result__clear-left">
                            <input id="startTime" class="form-control" type="text" data-type="date" data-label="联系时间：" :value="fields.startTime">
                        </div>
                        <div class="col-sm-4">
                            <input id="endTime" class="form-control" type="text" data-type="date" data-label="至：" :value="fields.endTime">
                        </div>-->
                    </template>
                </query-panel>
                <searchResult :searchResult="searchResult" @page-update="updatePaper" :total="pagertotals" :isResetPage="isResetPage" @export-history="exportHistory"></searchResult>
            </div>
        </div>
    </div>
</template>
<script>
    // 页面顶部标题组件
    import pageHeader from '../lib-components/page-header.vue';
    // 查询表单组件
    import queryPanel from '../lib-components/query-panel.vue';
    // 查询结果组件
    import searchResult from './search-result.vue';

    export default {
        props: ['topTitle'],
        created: function () {
            let parentId = this.$route.query.parentId;
            this.$store.state.options = Tools.getPagePermission(parentId);
            // 进入页面马上查询
            this.updatePaper();
        },
        mounted: function () {
            let self = this;
            $('#startTime,#endTime').timeInput({
                value: '',
                format: "yyyy-MM-dd hh:mm:ss",
                HMS: true,
                change: function () {
                    self.fields[this.$element.attr('id')] = cri.formatDate(this.value(), 'yyyy-MM-dd HH:mm:ss');
                }
            });
            // 归属人下拉框
            $.get(location.origin + '/groupMongo/getAgentGroups',function(resp){
                if(resp.success){
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
                        var opName = $("#select2-agentListSelectCustomer-container").text();
                        if (opName === '全部') {
                            opName = ''
                        }
                        self.fields.opName = opName;
                    });
                }
            });
        },
        data: function () {
            return {
                isResetPage: 0, // 是否重置页数为1
                cacheQueryFields: {}, // 缓存查询参数
                fields: {
                    activityName: '',
                    isConnected  : '',
                    strDnis: '',
                    userName: '',
                    opName: '',
                    startTime: '',
                    endTime: ''
                },
                searchResult: [],
                pagertotals: ''
            }
        },
        methods: {
            clearFields: function () {
                let fields = this.fields;
                for(let key in fields){
                    if(fields.hasOwnProperty(key)){
                        fields[key] = '';
                    }
                }
                $('.select2-selection__rendered').text('全部').attr('title', '全部');
            },
            queryFields: function () {
                let fields = this.fields;
                this.cacheQueryFields = {};
                // 缓存查询参数
                let cacheQueryFields = this.cacheQueryFields;

                for(let item in fields){
                    if(fields.hasOwnProperty(item) && fields[item]){
                        cacheQueryFields[item] = fields[item];
                    }
                }
                // 号码格式验证
                let strDnis = fields.strDnis;
                if(strDnis.trim() !== ''){
                    let isLegal=Tools.phoneCheck(strDnis);
                    if(!isLegal){
                        return notice.danger('电话号码格式不正确！');
                    }
                }

                // 时间验证(结束时间不得早于开始时间)
                let startTime = new Date(fields.startTime);
                let endTime = new Date(fields.endTime);
                if(endTime < startTime){
                    return notice.danger('结束时间不得早于开始时间')
                }

                this.updatePaper();
                this.isResetPage = Math.random();
            },
            updatePaper: function (page = 1, pageSize = 10) {
                let self = this;
                let obj = JSON.parse(JSON.stringify(self.cacheQueryFields));
                obj.page = page;
                obj.rows = pageSize;
                this.axios({url:'/teleCommunicate/queryCommHistory',params:obj}).then(res => {
                    if(!res.data.success){
                        return notice.danger(res.data.msg);
                    }
                    self.searchResult = res.data.rows;
                    self.pagertotals = res.data.total;
                });
            },
            exportHistory: function () {
                let self = this;
                let obj = JSON.parse(JSON.stringify(self.cacheQueryFields));
                obj.isMine = '0'; // isMine("0"：外呼历史,"1"：我的外呼历史)
                this.axios({url:'/teleCommunicate/exportHistory/manage',params: obj}).then(res => {
                    if(!res.data.success){
                        return notice.danger(res.data.msg);
                    }
                    window.location.href = location.origin + res.data.rows;
                });
            }
        },
        // 注入子组件
        components: {pageHeader, queryPanel,searchResult}
    };
</script>
<style lang="less" scoped>
    .foreign-call-history{
        height: 100%;
        overflow: auto;
    }
    .foreign-call-history__right-content-box{
        height: 100%;
        overflow: auto;
    }
    .search-result__clear-left{
        clear: left;
    }
</style>