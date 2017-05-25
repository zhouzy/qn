<template>
    <div class="batch-statistics-tab">
        <div class="row">
            <!--活动筛选器-->
            <div class="col-sm-4">
                <div class="row batch-statistics-tab__select-box">
                    <label class="col-sm-4 batch-statistics-tab__label">选择活动:</label>
                    <div class="col-sm-8">
                        <select class="batch-statistics-tab__select" name="teleActivityId"></select>
                    </div>
                </div>
            </div>
            <!--活动筛选器-->
            <div class="col-sm-4">
                <div class="row batch-statistics-tab__select-box">
                    <label class="col-sm-4 batch-statistics-tab__label">选择批次:</label>
                    <div class="col-sm-8">
                        <select class="batch-statistics-tab__select" name="batchId"></select>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script type="text/ecmascript-6">
    /**
     * @desc 批次统计tab组件
     * @author Lesty,wly
     * @code-date 2017.4.22
     **/
    export default{
        name: 'BatchStatisticsTab',
        created: function () {
            // 获取所有批次列表
            this.getAllBatchList().then(() => {
                // 活动必须选中一个，不能为空
                // 默认查询第一个活动的全部批次
                this.activitySelectJQ.select2({
                    placeholder: '输入活动名称进行筛选',
                    data: this.select2AllActList,
                    language: "zh-CN"
                }).on('select2:select select2:unselect', _.debounce(this.handleActivitySelect, 200, {maxWait: 1000})).trigger('select2:select');
            });
        },
        mounted: function () {
            let $el = $(this.$el);

            this.activitySelectJQ = $el.find("select[name=teleActivityId]");
            this.batchSelectJQ = $el.find("select[name=batchId]");
        },
        data: function () {
            return {

                // 所有活动选择框元素
                activitySelectJQ: null,
                // 活动对应批次选择框
                batchSelectJQ: null,
                // 所有批次列表
                allBatchList: [],
                // 符合select2插件格式的批次列表
                select2BatchList: [],
                // 查询参数
                searchParams: {
                    // 活动ID
                    activityId: '',
                    // 批次ID
                    batchId: ''
                },
            }
        },
        computed: {
            // 符合select2插件格式的所有活动列表
            select2AllActList: function () {
                return this.$store.getters.select2AllActList;
            }
        },
        watch: {
        },
        methods: {
            // 获取所有批次列表
            getAllBatchList: function () {
                return this.axios.get('/batch/queryBatchByCondition').then(res => {
                    let data = res.data;
                    if(!data.success) {
                        return Promise.reject(new Error(data.msg));
                    }

                    this.allBatchList = data.rows || [];
                }).catch(error => {
                    notice.danger(error.message);
                });
            },
            // 通过活动ID过滤批次列表
            filterBatchListByActId: function (activityId) {
                return this.allBatchList.filter(item => {
                    return item.teleActivityId === activityId;
                });
            },
            // 查询批次统计列表
            queryBatchStatisticsList: function(params, page, pageSize) {
                this.$store.dispatch('queryBatchStatisticsList', params).catch(error => {
                    notice.danger(error.message);
                });
                // 缓存查询参数
                this.$store.commit('CACHE_BACH_FIELDS', this.searchParams);
            },
            // 初始化批次下拉框插件
            initBatchSelect2: function (data) {
                this.batchSelectJQ.select2({
                    placeholder: '输入批次名称进行筛选',
                    // 提供清空按钮
                    allowClear: true,
                    data: data,
                    language: "zh-CN"
                }).on('select2:select select2:unselect', _.debounce(this.handleBatchSelect, 200, {maxWait: 1000}));
            },
            // 处理活动选择
            handleActivitySelect: function (event) {
                let activityId = this.activitySelectJQ.val();
                this.searchParams.batchId = '';

                if(event.type === 'select2:unselect') { // 清空选择(查全部)
                    this.searchParams.activityId = '';
                    this.select2BatchList = [];
                } else  { // 选择某一项
                    this.searchParams.activityId = activityId;
                    this.select2BatchList = this.filterBatchListByActId(activityId).map(item => {
                        return {
                            text: item.batchName,
                            id: item.batchId
                        };
                    });
                }

                // 如果初始化过，则移除批次下拉框插件
                if(this.batchSelectJQ.data('select2') != null) {
                    this.batchSelectJQ.off('select2:select select2:unselect').select2('destroy').empty();
                }
                // 初始化批次下拉框插件
                this.initBatchSelect2([{text:'全部',id:''}].concat(this.select2BatchList));
                // 查询批次统计列表
                this.queryBatchStatisticsList(this.searchParams);
            },
            // 处理批次选择
            handleBatchSelect: function (event) {
                if(event.type === 'select2:unselect') { // 清空选择(查全部)
                    this.searchParams.batchId = '';
                } else  { // 选择某一项
                    this.searchParams.batchId = event.params.data.id;
                }

                // 查询批次统计列表
                this.queryBatchStatisticsList(this.searchParams);
            }
        }
    }
</script>

<style lang="less" scoped>
    .batch-statistics-tab{
        padding: 0 15px 15px 15px;
    }

    .batch-statistics-tab__select-box {
        margin-top: 10px;
    }

    .batch-statistics-tab__label{
        margin: 10px 0 0;

        font-size: 12px;
        text-align: right;
    }

    .batch-statistics-tab__select{
        width: 100%;
        height:28px;
        border: 0;
        border-bottom: 1px solid #aaa;
        border-radius: 0;
    }
</style>