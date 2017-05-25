<template>
    <div class="container-fluid activity-manage-table__main">
        <div class="row">
            <div class="col-sm-12">
                <div class="activity-manage-table__container-box clearfix">
                    <div class="col-sm-12">
                        <table class="activity-manage-table__table-box">
                            <thead>
                                <tr class="activity-manage-table__thead__tr">
                                    <th v-if="tableOptions.tableSelect"></th>
                                    <th v-for="item in tableOptions.tableTitle" class="activity-manage-table__th" :class="getClassName(item._key)">
                                        <div class="activity-manage-table__blank-cell">{{item._value}}</div>
                                    </th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr class="activity-manage-table__tbody__tr" v-for="result in myResultList">
                                    <td class="activity-manage-table__select-td" v-if="tableOptions.tableSelect">
                                        <div class="activity-manage-table__blank-cell">
                                            <template v-if="tableOptions.tableSelect === 'radio'">
                                                <input name="activity-manage__radio" type="radio">
                                            </template>
                                            <template v-else-if="tableOptions.tableSelect === 'checkbox'">
                                                <input :checked="result.teleActivityId == isChecked" @click="chooseCheckbox" :value="result.teleActivityId" type="checkbox">
                                            </template>
                                        </div>
                                    </td>
                                    <td class="activity-manage-table__tbody__td" v-for="item in tableOptions.tableTitle">
                                        <template v-if="item._type === 'progress'">
                                            <div class="activity-manage-table__progress-box__bg">
                                                <div class="activity-manage-table__progress-box__bg-div" :title="(result[item._key]/(result.nameCount||1)*100).toFixed(2)+'%'">
                                                    <div :style="{ width: result[item._key]/(result.nameCount||1)*110 + 'px' }" class="activity-manage-table__progress-box__masking"></div>
                                                </div>
                                            </div>
                                        </template>
                                        <template v-else-if="item._type === 'link'">
                                            <div class="activity-manage-table__blank-cell">
                                                <a class="activity-manage-table__a" :href="locHash + '?teleActivityId='+ result.teleActivityId+'&status=' + result.status">{{ result[item._key] }}</a>
                                            </div>
                                        </template>
                                        <template v-else>
                                            <div class="activity-manage-table__blank-cell">
                                                {{ result[item._key] }}
                                            </div>
                                        </template>
                                    </td>
                                </tr>
                            </tbody>
                            <tfoot>
                            <tr>
                                <td colspan="30" >
                                    <div :id="pagination" class="activity-manage-table__pagination">
                                        <a href="javascript:void(0)" class="btn btn-sm btn-raised btn-primary fl" id="export" style="margin-top: 23px;display: none;">导出结果</a>
                                    </div>
                                </td>
                            </tr>
                            </tfoot>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script type="text/ecmascript-6">
    /**
     * @desc 表格组件
     * @author Maaser
     * @code-date 2017.2.20
     **/
    module.exports = {
        props: [
            'tableOptions','resultList','pagination','locHash','resultTotal','isResetPage'
        ],
        mounted: function() {
            let that = this;

            let pager = new cri.Pager($("#"+that.pagination), {
                page: 1,
                pageSize: 10,
                onPage: function (page, pageSize) {
                    that.onPageToQuery(page, pageSize);
                    pager.update(page, pageSize, that.resultTotal);
                }
            });
            this.pager = pager;
            pager.options.onPage(1, 10);
        },
        data:function () {
            return {
                checkedSelect: ""
            }
        },
        computed: {
            myResultList: function () {
                return this.resultList;
            },
            isChecked: function () {
                    return this.$store.state.allActivity.checkSelect||0;
            }
        },
        methods: {
            getClassName: function (item_name) {
                return "activity-manage-table__container-box__" + item_name;
            },
            chooseCheckbox: function (e) {
                this.checkedSelect = this.checkedSelect == e.target.value ? "" : e.target.value;
                this.$store.commit('ACTIVITY_SELECT', this.checkedSelect);
            },
            onPageToQuery: function (page, pageSize) {
                this.$emit('page-update', [page,pageSize]);
            }
        },
        watch: {
            resultTotal: function(){
                this.pager.update(this.pager.options.page, this.pager.options.pageSize,this.resultTotal);
            },
            isResetPage: function () {
                let pager = this.pager;
                pager.update(1,pager.options.pageSize,pager.options.total);
            }
        }
    };
</script>

<style lang="less" scoped>
    .activity-manage-table__main{
        margin-top:10px;
    }
    .activity-manage-table__container-box{
        margin-bottom: 20px;
        background: #fff;
        width: 100%;
        overflow-x: auto;
    }
    .activity-manage-table__table-box{
        table-layout: auto;
        width:100%;
    }
    .activity-manage-table__thead__tr,.activity-manage-table__tbody__tr{
        height:45px;
    }
    .activity-manage-table__tbody__tr{
        &:nth-child(even) .activity-manage-table__tbody__td{
             background: #f5f5f5;
         }
        &:hover{
             background: #F9FFF9;
         }
    }
    .activity-manage-table__select-td{
        background: none;
        width:30px;
    }
    .activity-manage-table__tbody__td{
        border-top: 1px solid #ddd;
        text-align: center;
        white-space: nowrap;
    }
    .activity-manage-table__a{
        text-align: center;
        line-height:100%;
        color:#009688;
    }
    .activity-manage-table__th{
        border-bottom: 2px solid #ddd;
        text-align: center;
    }
    .activity-manage-table__blank-cell{
        padding:8px;
    }
    .activity-manage-table__progress-box__bg{
        width:114px;
        margin: auto;
    }
    .activity-manage-table__progress-box__bg-div{
        margin:2px;
        border: 1px solid #bbb;
        height:10px;
    }
    .activity-manage-table__progress-box__masking{
        background: #29b6f6;
        height:100%;
    }
    .activity-manage-table__pagination{
        float: right;
    }
</style>