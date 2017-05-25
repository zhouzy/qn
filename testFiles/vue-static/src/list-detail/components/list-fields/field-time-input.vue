<template>
    <div :class="['edit-field__field-box', widthClassName]">
        <input type="text"
               class="form-control"
               v-model.trim="finalValue"
               :id="name"
               :name="name"
               :data-label="label"
               :required="isRequired"
               :disabled="isDisabled">
    </div>
</template>

<script type="text/ecmascript-6">
    import emitter from '@/mixin/emitter.js';
    /**
     * @desc 时间输入框字段组件
     * @author Lesty
     * @code-date 2017.3.18
     **/
    export default {
        name: 'FieldTimeInput',
        props: {
            // 组件宽度
            width: {},
            // 字段名称
            label: {
                type: String,
                required: true
            },
            // 字段值
            value: {
                default: ''
            },
            // 时间控件正则
            pattern: {
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
        mounted: function () {
            let $input = $('#' + this.name);
            let pattern = this.pattern;

            let isHMS = /hh|ss/.test(pattern);
            $input.timeInput({
                format: pattern,
                HMS: isHMS,
                value: this.finalValue,
                change: () => {
                    this.finalValue = $input.val();
                    this.handleChange();
                }
            });

            // 对必填项做处理
            if(this.isRequired) {
                $input.closest('.form-group').find('.control-label').append('<span class="edit-field__require-flag">*</span>');
            }
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
                } else if(value === '') { // 为空，则不进行验证，否则用户无法清空非必填项
                    this.hasError = false;
                    return true;
                }

                this.hasError = false;
                return true;
            }
        }
    }
</script>