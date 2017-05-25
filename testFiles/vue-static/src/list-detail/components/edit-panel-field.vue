<script type="text/ecmascript-6">
    // input字段组件
    import FieldInput from './list-fields/field-input.vue';
    // textarea字段组件
    import FieldTextarea from './list-fields/field-textarea.vue';
    // 下拉菜单组件
    import FieldSelect from './list-fields/field-select.vue';
    // checkbox字段组件
    import FieldCheckbox from './list-fields/field-checkbox.vue';
    // 时间输入框字段组件
    import FieldTimeInput from './list-fields/field-time-input.vue';
    // 省市区字段组件
    import FieldPca from './list-fields/field-pca.vue';

    /**
     * @desc 编辑面板字段渲染组件
     * @author Lesty
     * @code-date 2017.3.18
     **/
    export default {
        props: {
            // 字段信息对照表
            fieldsMap: {
                type: Object,
                default: function () {
                    return {};
                }
            },
            // 字段类型
            type: {
                type: String,
                required: true
            },
            // 用户类别
            userType: {
                type: String,
                default: '2' // 默认是坐席
            },
            // 组件宽度
            width: {},
            // 字段名称
            label: {
                type: String,
                required: true
            },
            // 下拉列表/复选框选项
            options: {},
            // 输入内容正则
            pattern: {
                default: ''
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
        data: function() {
            return {
            };
        },
        computed: {

        },
        methods: {
            // 对需要保护字段进行转换，并返回Boolean
            // true: 字段转换成功 false: 字段不需要转换
            protectFieldChange: function (name, componentConfig) {
                // 转换列表
                let CHANGE_MAP = {
                    telPhone: 'protectNum',
                    fixedPhone: 'protectFixed',
                    email: 'protectEmail'
                };
                let fieldsMap = this.fieldsMap;

                // 受保护的字段名
                let protectName = '';
                if(name in CHANGE_MAP) {
                    protectName = CHANGE_MAP[name];

                    componentConfig.props.name = CHANGE_MAP[name];
                    componentConfig.props.value = fieldsMap[protectName];
                    componentConfig.props.isDisabled = true;
                    return true;
                }

                return false;
            }
        },
        components: {
            FieldInput,
            FieldSelect,
            FieldTextarea,
            FieldCheckbox,
            FieldTimeInput,
            FieldPca
        },
        render: function (h) {
            // 组件名称
            let componentName = 'div';
            // 组件配置项
            let componentConfig = {
                // 组件props
                props: {
                    width: this.width,
                    // 字段名称
                    label: this.label,
                    // 字段值
                    value: this.value,
                    // 字段name属性
                    name: this.name,
                    isRequired: this.isRequired,
                    isDisabled: this.isDisabled
                }
            };

            let fieldsMap = this.fieldsMap;
            let name = this.name;
            let type = this.type;
            /*
            * 对公共禁止修改的字段做处理(目前是不展示)
            * @last Lesty 2017.4.11
            * */
            if(name === 'status' || name === 'result' || name === 'isConnect'
                    || name === 'latestCntTime' || name === 'callNum') {
                // 手动修改字段类型
                type = 'text';
                componentConfig.props.isDisabled = true;
                return false;
            }

            /*
             * 登录角色为坐席且名单受保护时，对特殊字段做处理(目前是不展示)
             * 坐席能修改客户姓名、详细信息、备注信息以及自定义字段
             * 没保护的情况下，坐席还可以修改手机、座机、邮箱
             * numberProtect - '1'： 不保护 '0': 保护(后端这么规定的)
             * */
            if(this.userType === '2' && this.fieldsMap.numberProtect === '0') {
                // 判断字段是否需要进行保护转换
                // 并采取相应处理
                if(this.protectFieldChange(name, componentConfig)) {
                    return false;
                }
            }

            if(name === 'serviceId') { // 归属人做特殊处理(下拉框，选项)
                componentName = 'field-select';
                componentConfig.props.options = this.$parent.serviceList;
                componentConfig.props.isDisabled = true;
                return false;
            } else if(name === 'serviceGroupId') { // 归属组
                componentName = 'field-select';
                componentConfig.props.options = this.$parent.serviceGroupList;
                componentConfig.props.isDisabled = true;
                return false;
            } else if(name === 'telPhone' || name === 'fixedPhone') { // 手机，座机
                componentName = 'field-input';
                componentConfig.props.pattern = window.ACT_CONFIG.FIELD_TYPE_MAP['9'].pattern;
            } else if(name === 'email') { // 邮箱
                componentName = 'field-input';
                componentConfig.props.pattern = '^(\\w)+(\\.\\w+)*@(\\w)+((\\.\\w+)+)$';
            } else {
                if(type === 'text' || type === 'number' || type === 'float'
                        || type === 'regexp' || type === 'telephone') { // 文本输入框,数字,小数,正则,电话号
                    let pattern = this.pattern;
                    let placeholder = '';

                    if(type === 'text') {
                        placeholder = '请输入文本';
                    } else if(type === 'number') {
                        placeholder = '请输入整数';
                    } else if(type === 'float') {
                        placeholder = '请输入小数';
                    } else if(type === 'regexp') {
                        pattern = this.options[0];
                        placeholder = '请输入文本(正则)';
                    } else if(type === 'telephone') {
                        placeholder = '请输入电话号码';
                    }

                    componentName = 'field-input';
                    componentConfig.props.pattern = pattern;
                    componentConfig.props.placeholder = placeholder;
                } else if(type === 'select') { // 下拉框
                    componentName = 'field-select';
                    componentConfig.props.options = this.options;
                } else if(type === 'textArea') { // 文本区域
                    componentName = 'field-textarea';
                    componentConfig.props.width = '12';
                } else if(type === 'checkbox') { // 复选框
                    componentName = 'field-checkbox';
                    componentConfig.props.options = this.options || [];
                } else if(type === 'datetime') { // 时间输入框
                    componentName = 'field-time-input';
                    componentConfig.props.pattern = this.options[0];
                } else if(type === 'pca') { // 省市区
                    componentName = 'field-pca';

                    let pName = 'province_' + name;
                    let aName = 'city_' + name;
                    let cName = 'area_' + name;

                    componentConfig.props.options = {
                        province: fieldsMap[pName],
                        city: fieldsMap[cName],
                        area: fieldsMap[aName]
                    };

                    componentConfig.props.perfix = 'ListDetail';
                }
            }

            return h(componentName, componentConfig);
        }
    }
</script>