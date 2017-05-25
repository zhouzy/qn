<template>
    <div class="search-result container-fluid">
        <div class="search-result__box">
            <table class="table grid table-striped">
                <thead>
                <tr>
                    <th>客户</th>
                    <th>联络时间</th>
                    <th>业务状态</th>
                    <th>活动名称</th>
                    <th>电话号码</th>
                    <th>沟通小结</th>
                    <th>是否接通</th>
                    <!--<th>预约时间</th>-->
                </tr>
                </thead>
                <tbody>
                <tr v-for="item in searchResult">
                    <td><a href="javascript:void(0)" :onclick.stop="'openNameDetails(' + '\'' + item.namesId + '\',\'' + item.userName + '\',' + 'event' +')'">{{item.userName}}</a></td>
                    <td>{{item.startTime}}</td>
                    <td>{{item.bussinessStatus}}</td>
                    <td>{{item.activityName}}</td>
                    <td v-if="userType == 3">{{item.strDnis}}</td>
                    <td v-else>{{item.protectNum}}</td>
                    <td>{{item.content}}</td>
                    <td>{{item.isConnected}}</td>
                    <!--<td>{{item.endTime}}</td>-->
                </tr>
                </tbody>
                <tfoot>
                <tr>
                    <td colspan="10" v-show="searchResult.length > 0">
                        <div class="pull-left">
                            <a href="javascript:void(0)" class="pull-left btn btn-xs btn-raised btn-primary" @click="exportHistory" v-if="this.$store.state.options['/teleCommunicate/exportHistory/my']">{{this.$store.state.options['/teleCommunicate/exportHistory/my']}}</a>
                        </div>
                        <div id="pagination" class="pull-right"></div>
                    </td>
                    <td colspan="10">
                        <p class="text-center" v-show="searchResult.length <= 0">此页面空空如也~~</p>
                    </td>
                </tr>
                </tfoot>
            </table>
        </div>
    </div>
</template>
<script>
    export default {
        props  : ['searchResult', 'total', 'isResetPage'],
        data   : function () {
            return {
                pager: null,
                userType: USER_G.userType
            }
        },
        watch  : {
            total: function (newVal) {
                let pager   = this.pager;
                pager.update(pager.page, pager.pageSize, newVal);
            },
            isResetPage: function () {
                let pager = this.pager;
                pager.update(1,pager.options.pageSize,pager.options.total);
            }
        },
        methods: {
            exportHistory: function () {
                this.$emit('export-history');
            }
        },
        mounted: function () {
            let self   = this;
            let pager  = new cri.Pager($("#pagination"), {
                page    : 1,
                pageSize: 10,
                onPage  : function (page, pageSize) {
                    self.$emit('page-update', page, pageSize);
                    pager.update(page, pageSize, self.total);
                }
            });
            this.pager = pager;
        }
    }
</script>
<style lang="less" scoped>
    th {
        font-weight: normal;
    }

    .search-result__box {
        padding: 15px;
        background: #fff;
        border-radius: 4px;
    }
</style>
