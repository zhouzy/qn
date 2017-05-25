<template>
    <div :class="['edit-field__field-box', widthClassName]">
        <div :class="['form-group', {'has-error': hasError}]">
            <slot name="label">
                <label :class="['control-label', labelClassName]">{{label}}
                    <span class="edit-field__require-flag" v-if="isRequired">*</span>
                </label>
            </slot>

            <div :class="[contentClassName]">
                <div class="checkbox">
                    <label v-for="item in options">
                        <input type="checkbox"
                               v-model="finalValue"
                               :value="item"
                               :name="name"
                               :required="isRequired"
                               :disabled="isDisabled"
                               @change="handleChange">{{item}}
                    </label>
                </div>
                <span class="help-block" v-show="hasError">
                    {{helpInfo}}
                </span>
            </div>
        </div>
    </div>
</template>

<script type="text/ecmascript-6">
    import emitter from '@/mixin/emitter.js';
    /**
     * @desc checkbox字段组件
     * @author Lesty
     * @code-date 2017.3.22
     **/
    export default {
        name: 'FieldCheckbox',
        props: {
            // 组件宽度
            width: {},
            // 字段名称
            label: {
                type: String,
                required: true
            },
            // 复选框选项
            options: {
                type: Array,
                default: function() {
                    return [];
                }
            },
            // 字段值
            value: {
                default: function() {
                    return [];
                }
            },
            // 字段name属性
            name: {
                type: String,
                required: true
            },
            isRequired: {
                type: Boolean
            },
            isDisabled: {
                type: Boolean
            }
        },
        mixins: [emitter],
        created: function() {
            this.dispatch('NameListInfo', 'add-field', this);
        },
        beforeDestroy: function() {
            this.dispatch('NameListInfo', 'remove-field', this);
        },
        data: function() {
            return {
                // 最终值
                finalValue: this.value,
                // 选项基础个数(小)，当大于该值时，控件宽度增加
                BASE_SMALL_NUM: 4,
                // 组件外层宽度样式
                widthClassName: 'col-sm-6',
                // label宽度样式
                labelClassName: 'col-sm-2',
                // 字段区域宽度样式
                contentClassName: 'col-sm-10',
                // 输入框格式是否正确
                hasError: false,
                // 提示信息
                helpInfo: ''
            };
        },
        watch: {
            options: {
                // 立即监听变化(以当前值触发回调)
                immediate: true,
                handler: function (newVal, oldVal) {
                    if(!Array.isArray(newVal)) {
                        return;
                    }

                    let len = newVal.length;

                    // 根据选项个数来确定组件样式
                    if(len > this.BASE_SMALL_NUM) {
                        this.widthClassName = 'col-sm-12';
                        this.labelClassName = 'col-sm-1';
                        this.contentClassName = 'col-sm-11';
                    } else {
                        this.widthClassName = 'col-sm-6';
                        this.labelClassName = 'col-sm-2';
                        this.contentClassName = 'col-sm-10';
                    }
                }
            }
        },
        methods: {
            handleChange: function () {
                // 验证输入内容
                if(!this.validate()) { // 不合法
                    return;
                }

                this.dispatch('NameListInfo', 'field-change', [this.name, this.finalValue]);
            },
            reset: function() {
                this.hasError = false;
                this.finalValue = this.value;
            },
            validate: function() {
                let value = this.finalValue;

                // 必填项判断
                if(this.isRequired === true && value.length === 0) {
                    this.helpInfo = '必填字段不能为空';
                    this.hasError = true;
                    return false;
                } else if(value.length === 0) { // 为空，则不进行验证，否则用户无法清空非必填项
                    this.hasError = false;
                    return true;
                }

                this.hasError = false;
                return true;
            }
        }
    }
</script>