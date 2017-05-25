<template>
    <div class="personal-performance-tab">
        <div class="row">
            <!--活动筛选器-->
            <div class="col-sm-4">
                <div class="row personal-performance-tab__select-box">
                    <label class="col-sm-4 personal-performance-tab__label">选择活动:</label>
                    <div class="col-sm-8">
                        <select class="personal-performance-tab__select" name="teleActivityId"></select>
                    </div>
                </div>
            </div>
            <!--员工筛选器-->
            <div class="col-sm-4">
                <div class="row personal-performance-tab__select-box">
                    <label class="col-sm-4 personal-performance-tab__label">选择员工:</label>
                    <div class="col-sm-8">
                        <select class="personal-performance-tab__select" name="serviceId"></select>
                    </div>
                </div>
            </div>
            <!--按钮操作组-->
            <div class="col-sm-4">
                <div class="row">
                    <button :class="[dateType === 'today' ? dateActiveClass : dateClass]" @click="chooseDateType('today')">今天</button>
                    <button :class="[dateType === 'yesterday' ? dateActiveClass : dateClass]" @click="chooseDateType('yesterday')">昨天</button>
                    <button :class="[dateType === 'month' ? dateActiveClass : dateClass]" @click="chooseDateType('month')">近一月</button>
                    <button :class="[dateType === 'custom' ? dateActiveClass : dateClass]" @click="chooseDateType('custom')">自定义</button>
                </div>
            </div>
        </div>

        <div class="row">
            <!--自定义时间输入框-->
            <div class="col-sm-8">
                <div class="row" v-show="dateType == 'custom'">
                    <div class="col-sm-6">
                        <label class="col-sm-4 personal-performance-tab__label">开始时间：</label>
                        <input type="text" id="PPTStartTime" data-name="startTime">
                    </div>
                    <div class="col-sm-6">
                        <label class="col-sm-4 personal-performance-tab__label">结束时间：</label>
                        <input type="text" id="PPTEndTime" data-name="endTime">
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>
<script type="text/ecmascript-6">
    /**
     * @desc 个人业绩统计tab组件
     * @author Lesty,wly
     * @code-date 2017.4.25
     **/
    export default{
        name: 'PersonalPerformanceTab',
        created:function () {
            // 初始化函数
            this.debounceQueryPPL = _.debounce(this.queryPersonalPerformanceList, 500, {maxWait: 2000});
        },
        mounted:function(){
            let $el = $(this.$el);
            let self = this;

            $el.find('#PPTStartTime, #PPTEndTime').timeInput({
                format: 'yyyy-MM-dd hh:mm:ss',
                HMS: true,
                value: '',
                change: function () {
                    self.searchParams[this.$element.attr('data-name')] = +this.value();

                    // 检测自定义时间是否合法
                    if(!self.isTimeIllegal(self.searchParams.startTime, self.searchParams.endTime)) { // 不合法
                        self.searchParams[this.$element.attr('data-name')] = '';
                        this.$element.val('');

                        return notice.warning('开始时间不能晚于结束时间！');
                    }


                    // 查询个人业绩统计列表
                    self.debounceQueryPPL(self.searchParams);
                }
            });

            this.activitySelectJQ = $el.find("select[name=teleActivityId]");
            this.serviceSelectJQ = $el.find("select[name=serviceId]");

            // 活动必须选中一个，不能为空
            // 默认查询第一个活动的全部员工业绩
            this.activitySelectJQ.select2({
                placeholder: '输入活动名称进行筛选',
                data: this.select2AllActList,
                language: "zh-CN"
            }).on('select2:select select2:unselect', _.debounce(this.handleActivitySelect, 200, {maxWait: 1000})).trigger('select2:select');
        },
        data:function () {
            return {
                // 所有活动选择框元素
                activitySelectJQ: null,
                // 活动对应员工选择框
                serviceSelectJQ: null,
                // 符合select2插件格式的员工列表
                select2ServiceList: [],
                // 查询参数
                searchParams: {
                    // 活动ID
                    activityId: '',
                    // 员工ID
                    serviceId: '',
                    // 开始时间(时间戳)
                    startTime: '',
                    // 截止时间(时间戳)
                    endTime: ''
                },
                // 日期类型
                dateType:'',
                // 防抖动-查询个人业绩统计列表
                debounceQueryPPL: null,
                dateClass:'activity-statistics-tab__btn btn btn-xs',
                dateActiveClass:'btn btn-xs btn-raised btn-primary'
            }
        },
        computed: {
            // 所有活动列表
            allActivityList: function () {
                return this.$store.state.activityStatistics.allActivityList;
            },
            // 符合select2插件格式的所有活动列表
            select2AllActList: function() {
                return this.$store.getters.select2AllActList;
            }
        },
        methods:{
            // 检测自定义时间是否合法
            isTimeIllegal: function (startTime, endTime) {
                // 任何一个为空，则表示不限制，可以查询
                if(startTime === '' || endTime === '') {
                    return true;
                }

                // 开始时间必须早于结束时间
                return endTime - startTime > 0;
            },
            // 通过活动ID过滤员工列表
            filterServiceListByActId: function (activityId) {
                for(let i = 0, iLen = this.allActivityList.length; i < iLen; i++) {
                    if(this.allActivityList[i].teleActivityId === activityId) {
                        return this.allActivityList[i].executeUsers;
                    }
                }

                return [];
            },
            // 查询个人业绩统计列表
            queryPersonalPerformanceList: function(params, page, pageSize) {
                this.$store.dispatch('queryPersonalPerformanceList', params).catch(error => {
                    notice.danger(error.message);
                });
                // 缓存查询参数
                this.$store.commit('CACHE_PERFORMANCE_FIELDS', this.searchParams);
            },
            // 初始化员工选择下拉框插件
            initServiceSelect2: function (data) {
                this.serviceSelectJQ.select2({
                    placeholder: '输入员工名称进行筛选',
                    // 提供清空按钮
                    allowClear: true,
                    data: data,
                    language: "zh-CN"
                }).on('select2:select select2:unselect', _.debounce(this.handleServiceSelect, 200, {maxWait: 1000}));
            },
            // 处理活动选择
            handleActivitySelect: function (event) {
                let activityId = this.activitySelectJQ.val();
                this.searchParams.serviceId = '';

                if(event.type === 'select2:unselect') { // 清空选择(查全部)
                    this.searchParams.activityId = '';
                    this.select2ServiceList = [];
                } else  { // 选择某一项
                    this.searchParams.activityId = activityId;
                    this.select2ServiceList = this.filterServiceListByActId(activityId).map(item => {
                        return {
                            text: item.userName,
                            id: item.userId
                        };
                    });
                }

                // 如果初始化过，则移除员工下拉框插件
                if(this.serviceSelectJQ.data('select2') != null) {
                    this.serviceSelectJQ.off('select2:select select2:unselect').select2('destroy').empty();
                }
                // 初始化员工选择下拉框插件
                this.initServiceSelect2([{text:'全部',id:''}].concat(this.select2ServiceList));

                // 查询个人业绩统计列表
                this.queryPersonalPerformanceList(this.searchParams);
            },
            // 处理员工选择
            handleServiceSelect: function (event) {
                if(event.type === 'select2:unselect') { // 清空选择(查全部)
                    this.searchParams.serviceId = '';
                } else  { // 选择某一项
                    this.searchParams.serviceId = event.params.data.id;
                }

                // 查询个人业绩统计列表
                this.queryPersonalPerformanceList(this.searchParams);
            },
            // 选择时间类型
            chooseDateType: function (type) {
                let self = this;
                let now = new Date();
                let startDate = '',
                        endDate = '';

                // 根据用户点击按钮来设置相应时间和按钮样式(选中/取消选中)
                if(type === this.dateType) { // 如果点击已选中的按钮
                    this.dateType = '';
                    self.searchParams.startTime = '';
                    self.searchParams.endTime = '';
                } else {
                    this.dateType = type;
                    if(type === 'custom') { // 如果选中的是自定义时间
                        $('#PPTStartTime, #PPTEndTime').val('');
                        self.searchParams.startTime = '';
                        self.searchParams.endTime = '';
                        return;
                    }

                    switch (type) {
                        case 'today':
                            startDate = cri.formatDate(now, 'yyyy-MM-dd');
                            endDate = startDate;
                            break;
                        case 'yesterday':
                            startDate = cri.formatDate(new Date(now.getTime() - 24 * 3600 * 1000), 'yyyy-MM-dd');
                            endDate = startDate;
                            break;
                        case 'month':
                            startDate = cri.formatDate(new Date(now.getTime() - 30 * 24 * 3600 * 1000), 'yyyy-MM-dd');
                            endDate = cri.formatDate(now, 'yyyy-MM-dd');
                            break;
                    }

                    self.searchParams.startTime = +cri.string2Date(startDate + ' 00:00:00');
                    self.searchParams.endTime = +cri.string2Date(endDate + ' 23:59:59');
                }


                // 防抖动-查询个人业绩统计列表
                this.debounceQueryPPL(this.searchParams);
            }
        }
    }
</script>
<style lang="less">
    .personal-performance-tab{
        padding: 0 15px 15px 15px;
    }

    .personal-performance-tab__select-box {
        margin-top: 10px;
    }

    .personal-performance-tab__label{
        margin: 10px 0 0;

        font-size: 12px;
        text-align: right;
    }
    .personal-performance-tab__select{
        width: 100%;
        height:28px;
        border: 0;
        border-bottom: 1px solid #aaa;
        border-radius: 0;
    }

    .personal-performance-tab__btn{
        border: 1px solid #a9a9a9;
    }

</style>