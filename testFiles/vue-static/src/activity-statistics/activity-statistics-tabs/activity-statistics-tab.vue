<template>
    <div class="activity-statistics-tab">
        <div class="row">
            <!--活动筛选器-->
            <div class="col-sm-4">
                <div class="row activity-statistics-tab__select-box">
                    <label class="col-sm-4 activity-statistics-tab__label">选择活动:</label>
                    <div class="col-sm-8">
                        <select class="activity-statistics-tab__select" name="teleActivityId"></select>
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
                        <label class="col-sm-4 activity-statistics-tab__label">开始时间：</label>
                        <input type="text" id="ASTStartTime" data-name="startTime">
                    </div>
                    <div class="col-sm-6">
                        <label class="col-sm-4 activity-statistics-tab__label">结束时间：</label>
                        <input type="text" id="ASTEndTime" data-name="endTime">
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>
<script type="text/ecmascript-6">
    /**
     * @desc 活动统计tab组件
     * @author Lesty,wly
     * @code-date 2017.4.22
     **/
    export default{
        name: 'ActivityStatisticsTab',
        created:function () {
            // 初始化函数
            this.debounceQueryASL = _.debounce(this.queryActivityStatisticsList, 500, {maxWait: 2000});

            // 查询活动统计列表
            this.debounceQueryASL(this.searchParams);
        },
        mounted:function(){
            let $el = $(this.$el);
            let self = this;

            $el.find('#ASTStartTime, #ASTEndTime').timeInput({
                format: 'yyyy-MM-dd hh:mm:ss',
                HMS: true,
                value: '',
                change: function () {
                    let date = this.value();

                    // 根据返回date类型设置相应time值
                    if(date instanceof Date) {
                        date = +date;
                    } else {
                        date = '';
                    }

                    self.searchParams[this.$element.attr('data-name')] = date;

                    // 检测自定义时间是否合法
                    if(!self.isTimeIllegal(self.searchParams.startTime, self.searchParams.endTime)) { // 不合法
                        self.searchParams[this.$element.attr('data-name')] = '';
                        this.$element.val('');

                        return notice.warning('开始时间不能晚于结束时间！');
                    }


                    // 查询活动统计列表
                    self.debounceQueryASL(self.searchParams);
                }
            });

            this.activitySelectJQ = $el.find("select[name=teleActivityId]");
        },
        data:function () {
            return {
                // 所有活动选择框元素
                activitySelectJQ: null,
                // 查询参数
                searchParams: {
                    // 活动ID
                    activityId: '',
                    // 开始时间(时间戳)
                    startTime: '',
                    // 截止时间(时间戳)
                    endTime: ''
                },
                // 日期类型
                dateType:'',
                // 防抖动-查询活动统计列表
                debounceQueryASL: null,
                dateClass:'activity-statistics-tab__btn btn btn-xs',
                dateActiveClass:'btn btn-xs btn-raised btn-primary'
            }
        },
        computed: {
            // 符合select2插件格式的所有活动列表
            select2AllActList: function() {
                return [{text:'全部',id:''}].concat(this.$store.getters.select2AllActList);
            }
        },
        watch: {
            // 符合select2插件格式的所有活动列表
            select2AllActList: function (newVal) {
                this.activitySelectJQ.select2({
                    placeholder: '输入活动名称进行筛选',
                    // 提供清空按钮
                    allowClear: true,
                    data : newVal,
                    language : "zh-CN"
                }).on('select2:select select2:unselect', _.debounce(this.handleActivitySelect, 200, {maxWait: 1000}));
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
            // 查询活动统计列表
            queryActivityStatisticsList: function(params, page, pageSize) {
                this.$store.dispatch('queryActivityStatisticsList', params).catch(error => {
                    notice.danger(error.message);
                });
                // 缓存查询参数
                this.$store.commit('CACHE_ACTIVITY_FIELDS', this.searchParams);
            },
            // 处理活动选择
            handleActivitySelect: function (event) {
                if(event.type === 'select2:unselect') { // 清空选择(查全部)
                    this.searchParams.activityId = '';
                } else  { // 选择某一项
                    this.searchParams.activityId = event.params.data.id;
                }

                // 查询活动统计列表
                this.queryActivityStatisticsList(this.searchParams);
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
                        $('#ASTStartTime, #ASTEndTime').val('');
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


                // 防抖动-查询活动统计列表
                this.debounceQueryASL(this.searchParams);
            }
        }
    }
</script>
<style lang="less">
    .activity-statistics-tab{
        padding: 0 15px 15px 15px;
    }
    .activity-statistics-tab__btn{
        border: 1px solid #a9a9a9;
    }
    .activity-statistics-tab__label{
        margin: 10px 0 0;

        font-size: 12px;
        text-align: right;
    }

    .activity-statistics-tab__select-box {
        margin-top: 10px;
    }

    .activity-statistics-tab__select{
        width: 100%;
        height:28px;
        border: 0;
        border-bottom: 1px solid #aaa;
        border-radius: 0;
    }
</style>