<template>
    <div :class="[widthClassName]">
        <div :class="['form-group', {'has-error': hasError}]">
            <slot name="label">
                <label class="col-sm-1 control-label">{{label}}
                    <span class="edit-field__require-flag" v-if="isRequired">*</span>
                </label>
            </slot>

            <div class="col-sm-11">
                <div class="row">
                    <div class="col-sm-3" @change="handleChange('province')">
                        <select class="form-control"
                                v-model="pValue"
                                :name="pName"
                                :disabled="isDisabled">
                        </select>
                    </div>
                    <div class="col-sm-3" @change="handleChange('city')">
                        <select class="form-control"
                                v-model="cValue"
                                :name="cName"
                                :disabled="isDisabled">
                        </select>
                    </div>
                    <div class="col-sm-3" @change="handleChange('area')">
                        <select class="form-control"
                                v-model="aValue"
                                :name="aName"
                                :disabled="isDisabled">
                        </select>
                    </div>
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
     * @desc 省市区字段组件
     * @author Lesty
     * @code-date 2017.3.23
     **/
    export default {
        name: 'FieldPca',
        props: {
            // 组件宽度
            width: {},
            // 字段名称
            label: {
                type: String,
                required: true
            },
            // 前缀(用于避免命名冲突)
            prefix: {
                default: ''
            },
            // 省市区选项值
            options: {
                default: function () {
                    return {
                        province: '',
                        city: '',
                        area: ''
                    };
                }
            },
            // 字段值
            value: {},
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
            new PCAS(this.pName, this.cName, this.aName, this.pValue, this.cValue, this.aValue);
        },
        beforeDestroy: function() {
            this.dispatch('NameListInfo', 'remove-field', this);
        },
        data: function() {
            return {
                // 最终值
                pValue: this.options.province,
                cValue: this.options.city,
                aValue: this.options.area,
                // 省名字
                pName: this.prefix + 'province_' + this.name,
                // 市名字
                cName: this.prefix + 'city_' + this.name,
                // 区名字
                aName: this.prefix + 'area_' + this.name,
                // 组件宽度样式
                widthClassName: 'col-sm-' + (this.width == null || '12'),
                // 输入框格式是否正确
                hasError: false,
                // 提示信息
                helpInfo: ''
            };
        },
        computed: {
            // 省市区合并字段
            finalValue: function() {
                return [this.pValue, this.cValue, this.aValue].join(',').replace(/,+$/g, "");
            }
        },
        methods: {
            handleChange: function (type) {
                // 验证输入内容
                if(!this.validate()) { // 不合法
                    return;
                }

                if(type === 'province') {
                    this.cValue = '';
                    this.aValue = '';
                    // 级联变化
                    this.dispatch('NameListInfo', 'field-change', ['province_' + this.name, this.pValue]);
                    this.dispatch('NameListInfo', 'field-change', ['city_' + this.name, this.cValue]);
                } else if(type === 'city') {
                    this.aValue = '';
                    this.dispatch('NameListInfo', 'field-change', ['city_' + this.name, this.cValue]);
                }

                // 不论哪个字段(省/市/区)改变，都会触发这2个变化
                this.dispatch('NameListInfo', 'field-change', ['area_' + this.name, this.aValue]);
                this.dispatch('NameListInfo', 'field-change', [this.name, this.finalValue]);
            },
            reset: function() {
                this.hasError = false;
                this.pValue = this.options.province;
                this.cValue = this.options.city;
                this.aValue = this.options.area;

                this.$nextTick(() => {
                    // 手动触发事件变化
                    document.getElementsByName(this.pName)[0].onchange();
                    document.getElementsByName(this.cName)[0].onchange();
                });
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