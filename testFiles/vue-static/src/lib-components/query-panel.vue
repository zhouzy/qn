<template>
    <div class="container-fluid query-panel__main">
        <div class="row">
            <div class="col-sm-12">
                <div class="query-panel__condition-box" :style="conditionBoxStyle">
                    <div class="col-sm-9">
                        <div class="row">
                            <div class="form-horizontal" id="queryList">
                                <!--默认字段控件列表内容分发区域-->
                                <slot name="defaultFieldList"></slot>
                                <!--自定义字段控件列表内容分发区域-->
                                <slot name="customFieldList"></slot>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-3" style="margin-top: 5px;">
                        <div class="row">
                            <div class="col-sm-4" v-if="isShowToggleBtn">
                                <a href="javascript:void(0)" class="btn btn-xs" @click="toggleHeight">
                                    <span>{{isOpen ? '收起' : '更多'}}</span>
                                    <i :class="isOpen ? toggleIconToUpClass : toggleIconToDownClass"></i>
                                </a>
                            </div>
                            <div :class="['col-sm-8', 'text-right', {'col-sm-offset-4': !isShowToggleBtn}]">
                                <a href="javascript:void(0);" @click="clear" class="btn btn-xs btn-raised" style="margin-right: 10px;">清空</a>
                                <a href="javascript:void(0);" @click="query" class="btn btn-xs btn-raised btn-primary">查询</a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>
<script type="text/ecmascript-6">
    /**
     * @desc 查询表单组件
     * @author Lesty
     * @code-date 2017.2.18
     **/
    module.exports = {
        props: {
            // 是否显示切换按钮
            isShowToggleBtn: {
                type: Boolean,
                default: true
            }
        },
        data: function () {
            return {
                // 切换按钮是否已展开
                isOpen: false,
                // 切换按钮待展开样式
                toggleIconToDownClass: ['fa', 'fa-caret-down'],
                // 切换按钮待收起样式
                toggleIconToUpClass: ['fa', 'fa-caret-up'],
                // 查询栏样式
                conditionBoxStyle: {
                    height: '56px'
                }
            };
        },
        methods: {
            // 查询
            query: function () {
                this.$emit('query');
            },
            // 清空查询条件
            clear: function () {
                this.$emit('clear');
            },
            // 展开收起按钮
            toggleHeight: function () {
                this.isOpen = !this.isOpen;

                // 根据展开/收起状态，控制查询框高度样式
                if(this.isOpen) {// 展开状态
                    this.conditionBoxStyle.height = 'auto';
                } else { // 收起状态
                    this.conditionBoxStyle.height = '56px';
                }

                this.$emit('toggle-height', this.isOpen);
            }
        }
    };
</script>

<style lang="less" scoped>
    .query-panel__main {
        margin-top: 10px;
    }

    .query-panel__condition-box {
        position: relative;
        margin-bottom: 15px;
        padding-bottom: 15px;

        background-color: #fff;
        border-radius: 4px;

        overflow: hidden;
    }
</style>