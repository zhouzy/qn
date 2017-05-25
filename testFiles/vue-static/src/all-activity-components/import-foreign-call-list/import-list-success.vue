<template>
    <div class="import-list-success">
        <pageHeader :topTitle="topTitle"></pageHeader>
        <div class="container-fluid import-list-success__main">
            <div class="panel import-list-success__content">
                <p class="text-center import-list-success__message">
                    为<span class="text-primary">{{activity}}</span>活动导入<span class="text-primary">{{batchName}}</span>名单
                    <br>
                    总计<span class="label label-primary">{{totalNum}}</span> 成功<span class="label label-success">{{importSuccessNum}}</span> 失败<span class="label label-danger">{{importFailNum}}</span>
                </p>
                <div class="text-center" v-show="importFailNum > 0">点击<a :href="failUrl" class="import-list-success__download">下载</a>失败详情</div>
                <div class="import-list-success__options">
                    <a href="javascript:void(0)" class="btn btn-xs btn-raised btn-primary pull-left" @click="returnList">返回列表</a>
                    <a href="#/control/import-foreign-call-list/assign-list" class="btn btn-xs btn-raised btn-primary pull-right">分配名单</a>
                </div>
            </div>
        </div>
    </div>
</template>
<script>
    import pageHeader from '../../lib-components/page-header.vue';
    export default{
        created:function () {
            let params=JSON.parse(this.$route.query.params);
            this.activity=this.$route.query.activity;
            this.batchName=this.$route.query.batchName;
            this.totalNum=params.totalNum;
            this.importSuccessNum=params.totalNum - params.importFailNum;
            this.importFailNum=params.importFailNum;
            this.failUrl=location.origin + '/' +params.resultFilePath;
        },
        data:function () {
            return{
                activity:'',
                batchName:'',
                totalNum:'',
                importSuccessNum:'',
                importFailNum:'',
                failUrl:''
            }
        },
        computed:{
            topTitle:function () {
                return '为'+ this.activity + '活动导入名单成功'; 
            }
        },
        methods:{
            returnList:function () {
                location.hash='/control';
            }
        },
        components: {pageHeader}
    }
</script>
<style lang="less" scoped>
    .import-list-success{
        height:100%;
    }
    .import-list-success__main{
        height:100%;
        margin-top: 10px;
        padding-bottom: 75px;
    }
    .import-list-success__content{
        height:100%;
        padding: 150px 30px 30px;
        position: relative;
    }
    .import-list-success__options{
        position: absolute;
        bottom: 30px;
        left: 30px;
        right: 30px;
    }
    .import-list-success__download:hover{
        text-decoration: underline;
    }
    .import-list-success__message{
        line-height: 30px;
        letter-spacing: 2px;
    }
</style>