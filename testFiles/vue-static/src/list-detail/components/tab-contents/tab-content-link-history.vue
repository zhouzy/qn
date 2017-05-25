<template>
    <div class="tab-content-link-history">
        <div class="tab-content-link-history__contact-detail-box">
            <contact-history-phone v-for="contactInfo in linkHistoryList"
                                   :is-readonly="contactInfo.commId === contactId"
                                   :contact-info="contactInfo">
            </contact-history-phone>
        </div>
        <div id="pagination" v-show="linkHistoryList.length > 0"></div>

        <p v-if="linkHistoryList.length === 0" style="text-align: center;">联络历史空空如也~</p>
    </div>
</template>
<script type="text/ecmascript-6">
    // 联络历史item组件
    import ContactHistoryPhone from '../contact-types/contact-history-phone.vue';

    /**
     * @desc 联络历史列表组件
     * @author Lesty
     * @code-date 2017.4.27
     **/
    export default {
        name: 'TabContentLinkHistory',
    	props : {
            customId: {
                required: true
            },
            contactId: {
                default: ''
            }
        },
        data : function () {
            return {
                pager: null
            }
        },
        watch: {
            customId: function (newVal) {
                if(newVal !== '') {
                    // 分页请求
                    this.updatePager();
                }
            }
        },
        computed: {
    	    // 联络历史表单数据
            linkHistoryList: function () {
                return this.$store.state.linkHistory;
            }
        },
        created: function () {

        },
        mounted: function () {
            // 初始化分页控件
            this.pager = new cri.Pager($('#pagination'),{
                page: 1,
                pageSize: 10,
                onPage: (page, pageSize) => {
                    this.updatePager(page, pageSize);
                }
            });
        },
        methods: {
            // 分页请求
            updatePager: function (page = 1, pageSize = 10) {
                this.axios({
                    url: '/teleCommunicate/queryNamesCommHistory',
                    params: {page: page, rows: pageSize, customId: this.customId}
                }).then(res => {
                    let data = res.data;
                    if(!data.success){
                        return data.msg;
                    }

                    // 初始化联络历史列表
                    this.$store.commit('INIT_CONTACT_HISTORY_LIST', data.rows || []);

                    // 更新分页样式
                    this.pager.update(page, pageSize, data.total);
                });
            }
        },
        components: {
            ContactHistoryPhone
        }
    }
</script>

<style scoped>
    .tab-content-link-history__contact-detail-box {
        width: 94%;
        margin-left: 3%;
    }
</style>