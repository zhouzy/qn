<template>
    <div :class="['edit-field__field-box', widthClassName]">
        <div :class="['form-group', {'has-error': hasError}]">
            <slot name="label">
                <label class="col-sm-4 control-label">{{label}}
                    <span class="edit-field__require-flag" v-if="isRequired">*</span>
                </label>
            </slot>

            <div class="col-sm-8">
                <select class="form-control"
                        v-model="finalValue"
                        :name="name"
                        :required="isRequired"
                        :disabled="isDisabled"
                        @change="handleChange">
                    <option value="">-</option>
                    <option v-for="item in finalOptions" :value="item.value">{{item.name}}</option>
                </select>

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
     * @desc 下拉菜单组件
     * @author Lesty
     * @code-date 2017.3.21
     **/
    export default {
        name: 'FieldSelect',
        props: {
            // 组件宽度
            width: {},
            // 字段名称
            label: {
                type: String,
                required: true
            },
            // 下拉列表选项
            options: {
                type: Array,
                required: true
            },
            // 字段值
            value: {
                default: ''
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
                // 组件宽度样式
                widthClassName: 'col-sm-' + (this.width == null || '3'),
                // 输入框格式是否正确
                hasError: false,
                // 提示信息
                helpInfo: ''
            };
        },
        computed: {
            finalOptions: function() {
                return this.options.map((item) => {
                    return typeof item === 'object' ? item : {
                        name: item,
                        value: item
                    };
                });
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
                if(this.isRequired === true && value === '') {
                    this.helpInfo = '必填字段不能为空';
                    this.hasError = true;
                    return false;
                } else if( value === '') { // 为空，则不进行验证，否则用户无法清空非必填项
                    this.hasError = false;
                    return true;
                }

                this.hasError = false;
                return true;
            }
        }
    }
</script>