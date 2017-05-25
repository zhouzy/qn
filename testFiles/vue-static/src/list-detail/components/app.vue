<template>
    <div id="listDetailApp" class="list-detail__root">
        <div class="container-fluid">
            <!--名单资料-->
            <div class="row">
                <div class="col-sm-12">
                    <name-listInfo :names-id="namesId"
                                   :contact-history-id="contactHistoryId"
                                   :reserve-id="reserveId"
                                   :entry="entry"
                                   :user-type="userType">
                    </name-listInfo>
                </div>
            </div>

            <!--业务记录-->
            <div class="row" v-if="isCallScreen">
                <div class="col-sm-12">
                    <business-record :names-id="namesId"
                                     :contact-history-id="contactHistoryId"
                                     :reserve-id="reserveId">
                    </business-record>
                </div>
            </div>

            <!--联络历史/预约信息-->
            <div class="row">
                <div class="col-lg-12 col-md-12">
                    <div class="panel tab">
                        <!--从预约相关入口打开详情页时，优先显示预约信息列表-->
                        <div class="panel-heading">
                            <ul class="nav nav-tabs tab-list" role="tablist">
                                <li role="presentation" :class="{active: reserveId === ''}">
                                    <a href="#communicateInfoId" class="list-detail__nav-tab-title" role="tab" data-toggle="tab">联络历史</a>
                                </li>
                                <li role="presentation" :class="{active: reserveId !== ''}">
                                    <a href="#reservationListId" class="list-detail__nav-tab-title" role="tab" data-toggle="tab">预约信息</a>
                                </li>
                            </ul>
                        </div>
                        <div class="panel-body tab-content">
                            <div class="tab-pane" :class="{active: reserveId === ''}" role="tabpanel" id="communicateInfoId">
                                <tab-content-link-history :custom-id="customId"
                                                          :contact-id="contactHistoryId"
                                                          ref="linkHistory">
                                </tab-content-link-history>
                            </div>
                            <div class="tab-pane" :class="{active: reserveId !== ''}" role="tabpanel" id="reservationListId">
                                <tab-content-reservation-list :custom-id="customId"
                                                              :is-call-screen="isCallScreen">
                                </tab-content-reservation-list>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script type="text/ecmascript-6">
    // 单资料组件
    import NameListInfo from './name-list-info.vue';
    // 业务记录组件
    import BusinessRecord from './business-record.vue';
    // 标签页内容
    import tabContentLinkHistory from './tab-contents/tab-content-link-history.vue';
    import tabContentReservationList from './tab-contents/tab-content-reservation-list.vue';

    /**
     * @desc 名单详情组件
     * @author Lesty
     * @code-date 2017.3.18
     **/
    export default {
        name: 'ListDetail',
        created: function () {
            // 初始化值
            this.namesId = Tools.getSearchParamValue(null, 'namesId');
            this.contactHistoryId = Tools.getSearchParamValue(null, 'commId');
            this.reserveId = Tools.getSearchParamValue(null, 'reserveId');
            this.entry = Tools.getSearchParamValue(null, 'entry');
/*            this.contactHistoryId = '123';
            this.reserveId = '321';*/
            // 判断是否为弹屏
            if(this.contactHistoryId !== '') {
                this.isCallScreen = true;
            }
        },
        data: function() {
            return {
                // 名单ID
                namesId: '',
                // 联络历史ID
                contactHistoryId: '',
                // 预约回呼id
                reserveId: '',
                // 名单详情入口
                entry: '',
                // 用户类型
                userType: USER_G.userType,
                // 是否为弹屏
                isCallScreen: false
            };
        },
        computed: {
            // 客户id
            customId: function () {
                return this.$store.state.initFieldsMap.customId;
            }
        },
        components: {
            NameListInfo,
            BusinessRecord,
            tabContentLinkHistory,
            tabContentReservationList
        }
    }
</script>

<style lang="less" scoped>
    @import "../less/listDetail.less";
</style>