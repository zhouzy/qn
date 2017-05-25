<template>
    <div class="edit-custom-field__root">
        <page-header>
            <!--将顶部区域附加内容通过具名slot进行分发-->
            <ul slot="topContent" class="list-field-config__breadcrumbs">
                <li class="list-field-config__breadcrumbs-item">
                    <a href="#/list-field-config" class="list-field-config__router-link-active">{{topTitle}}</a>
                </li>
                <!--如果是添加，则显示该导航-->
                <template v-if="changeType === 'add'">
                    <li class="list-field-config__breadcrumbs-item">
                        <a href="#/list-field-config/select-custom-field" class="list-field-config__router-link-active">选择字段类型</a>
                    </li>
                </template>

                <li class="list-field-config__breadcrumbs-item">
                    <a href="javascript:void(0);" class="list-field-config__router-link-active">{{changeType === 'add' ? '添加' : '编辑'}}:[{{fieldTypeName}}]</a>
                </li>
            </ul>
        </page-header>

        <div class="edit-custom-field__main container-fluid">
            <div class="panel">
                <div class="edit-custom-field__content">
                    <div class="edit-custom-field__section-common">
                        <h4 class="edit-custom-field__section-common-title">显示标题</h4>
                        <input type="text" class="edit-custom-field__section-common-input field__focus" v-model.trim="commonField.name">
                        <p class="edit-custom-field__des">在客户信息页上显示的标题</p>
                        <label class="edit-custom-field__section-common-checkbox"><input type="checkbox" v-model="commonField.isRequired"> 是否必填</label>
                        <h4 class="edit-custom-field__section-common-title">描述（可选）</h4>
                        <textarea class="edit-custom-field__section-common-textarea edit-custom-field__field__focus" v-model.trim="commonField.remark"></textarea>
                        <p class="edit-custom-field__des">该字段在客户信息页上的描述信息</p>
                    </div>
                    <!--添加特殊选项时显示-->
                    <div class="edit-custom-field__panel-section" v-if="fieldTypeDesc === 'select' || fieldTypeDesc === 'checkbox'">
                        <h4 class="edit-custom-field__panel-section-title">{{fieldTypeDesc === 'select' ? '下拉菜单选项' : '复选框选项'}}</h4>
                        <div class="edit-custom-field__panel-section-content">
                            <ul class="edit-custom-field__panel-section-lists">
                                <li class="edit-custom-field__panel-section-lists-item" v-for="(item, $index) in fieldItemArr">
                                    <input type="text" placeholder="请输入选项内容" class="edit-custom-field__panel-section-input edit-custom-field__field__focus" :value="item" v-on:input.lazy="fieldItemArr[$index] = $event.target.value">
                                    <a href="javascript:void(0);" class="edit-custom-field__panel-section-remove" @click="fieldItemArr.splice($index,1)">-</a>
                                </li>
                            </ul>
                            <a href="javascript:void(0);" class="edit-custom-field__panel-section-add" @click="fieldItemArr.push('')"><span class="edit-custom-field__panel-section-addicon">+</span> 添加下拉菜单选项</a>
                        </div>
                    </div>
                    <!-- 添加正则匹配字段时显示 -->
                    <div class="edit-custom-field__panel-section" v-else-if="fieldTypeDesc === 'regexp'">
                        <h4 class="edit-custom-field__panel-section-title">正则匹配字段</h4>
                        <div class="edit-custom-field__panel-section-content">
                            <h4 class="edit-custom-field__section-common-title">请在这里输入正则表达式的规则</h4>
                            <input type="text" class="edit-custom-field__panel-section-input edit-custom-field__field__focus" :value="fieldItemArr[0]" v-on:input.lazy="fieldItemArr.splice(0, 1, $event.target.value)">
                            <p class="edit-custom-field__des">例如qq号码：^[1-9]\d{4,9}$ <a href="javascript:void(0)" @click="searchRegexp">查看更多常用正则表达式范例</a></p>
                        </div>
                    </div>
                    <!-- 添加日期时间输入框时显示 -->
                    <div class="edit-custom-field__panel-section" v-else-if="fieldTypeDesc === 'datetime'">
                        <h4 class="edit-custom-field__panel-section-title">日期时间格式</h4>
                        <div class="edit-custom-field__panel-section-content">
                            <select class="edit-custom-field__panel-section-select edit-custom-field__field__focus" :value="fieldItemArr[0]" v-on:input.lazy="fieldItemArr.splice(0, 1, $event.target.value)">
                                <option value="yyyy/MM/dd hh:mm:ss">年/月/日  时:分:秒</option>
                                <option value="yyyy-MM-dd hh:mm:ss">年-月-日  时:分:秒</option>
                                <option value="yyyy/MM/dd">年/月/日</option>
                                <option value="yyyy-MM-dd">年-月-日</option>
                            </select>
                        </div>
                    </div>
                    <div class="edit-custom-field__panel-section-operation">
                        <a class="btn btn-sm btn-raised" :href="cancelHref">取消</a>
                        <a class="btn btn-sm btn-raised btn-primary" href="javascript:void(0)" @click="submitField">提交</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>
<script type="text/ecmascript-6">
    // 页面顶部标题组件
    import pageHeader from '../lib-components/page-header.vue';

    export default{
        props: ['topTitle'],
        // 实例创建完成，数据观测配置完成后调用
        created: function() {
            // 获取当前路由的查询参数
            let queryObj = this.$route.query;

            this.changeType = queryObj.changeType;
            // 根据修改类型做不同处理
            if(queryObj.changeType === 'add') {
                this.fieldType = queryObj.fieldType;

                // 如果是时间控件，则修改默认值
                if(this.fieldType === '10') {
                    this.fieldItemArr = ['yyyy/MM/dd hh:mm:ss'];
                }
            } else {
                this.fieldKey = queryObj.fieldKey;

                // 获取字段原有信息
                $.post(ACT_CONFIG.ORIGIN_URL + '/namelist/getNameListFieldInfo', {
                    field: this.fieldKey
                }).then(data => {
                    if(!(data.success)) {
                        notice.danger(data.msg);
                        return;
                    }

                    let rows = data.rows;

                    this.fieldType = rows.componentType;
                    this.fieldItemArr = rows.candidateValue || [''];
                    this.commonField.name = rows.name;
                    this.commonField.isRequired = rows.isRequired;
                    this.commonField.remark = rows.remark;
                });
            }
        },
        data : function () {
            return {
                // 字段类型对照表
                FIELD_TYPE_MAP: window.ACT_CONFIG.FIELD_TYPE_MAP,
                // 当前页修改的类型(添加-add/编辑-edit)
                changeType: 'add',
                // 修改的字段类型
                fieldType: '1',
                // 字段的唯一标识
                fieldKey: '',
                // 通用字段
                commonField:{
                    name: '',
                    isRequired: false,
                    remark: ''
                },
                // 特殊字段选项列表
                fieldItemArr: ['']
            };
        },
        computed: {
            // 字段类型名称(中文)
            fieldTypeName: function() {
                return this.FIELD_TYPE_MAP[this.fieldType].name;
            },
            // 字段类型描述
            fieldTypeDesc: function() {
                return this.FIELD_TYPE_MAP[this.fieldType].desc;
            },
            // 返回按钮的href链接
            cancelHref: function () {
                if(this.changeType === 'add') {
                    return '#/list-field-config/select-custom-field';
                } else {
                    return '#/list-field-config';
                }
            },
            // 提交的接口
            submitUrl: function() {
                if(this.changeType === 'add') {
                    return location.origin + '/namelist/addDefinedField';
                } else {
                    return location.origin + '/namelist/goEdit/' + this.fieldKey;
                }
            }
        },
        methods:{
            // 数组去重
            uniqueArr: function(arr) {
                return Array.from(new Set(arr));
            },
            // 移除元素的空值
            removeEmptyValue: function (arr) {
                return arr.filter(item => item.trim() !== '');
            },
            // 对不同类型做检测
            checkField: function (fieldTypeDesc) {
                if(fieldTypeDesc === 'select' || fieldTypeDesc === 'checkbox') { // 下拉框，复选框
                    this.fieldItemArr = this.removeEmptyValue(this.fieldItemArr);

                    if(this.fieldItemArr.length === 0) {
                        this.fieldItemArr.push('');
                        notice.warning('需要至少一个不为空的选项！');
                        return false;
                    }

                    // 英文逗号校验
                    for(let i = 0, iLen = this.fieldItemArr.length; i < iLen; i++) {
                        if(this.fieldItemArr[i].indexOf(',') !== -1) {
                            notice.warning('选项里不能包含英文逗号，请使用中文逗号替代！');
                            return false;
                        }
                    }
                } else if(fieldTypeDesc === 'regexp') { // 正则

                } else if(fieldTypeDesc === 'telephone') { // 电话
                    this.fieldItemArr = ['^\\d{7,8}$|^\\d{11,13}$'];
                } else if(fieldTypeDesc === 'datetime') { // 日期

                } else {
                    this.fieldItemArr = [];
                }

                return true;
            },
            // 提交字段
            submitField: function () {
                // 选项去重
                this.fieldItemArr = this.uniqueArr(this.fieldItemArr);

                // 标题判空
                if(this.commonField.name === '') {
                    return notice.warning('标题不能为空！');
                }

                // 对不同类型做检测
                if(!this.checkField(this.fieldTypeDesc)) {
                    return false;
                }

                let param = {
                    componentType: this.fieldType,
                    name: this.commonField.name,
                    isRequired: this.commonField.isRequired,
                    remark: this.commonField.remark,
                    candidateValueList: this.fieldItemArr
                };

                $.post(this.submitUrl, param).then(data => {
                    if(!(data.success)) {
                        notice.danger(data.msg);
                        return;
                    }

                    location.hash = '#/list-field-config';
                });
            },
            searchRegexp:function () {
                let url=location.origin + '/userField/regularExpression';
                window.open(url,"newwindow","height=500,width=550,top=0,left=0,toolbar=no,menubar=no,scrollbars=no, resizable=no,location=no, status=no");
            }
        },
        // 注入子组件
        components: {pageHeader}
    }
</script>
<style lang="less" scoped>
    .edit-custom-field__root {
        height: 100%;
        overflow: auto;
    }
    .edit-custom-field__main{
        margin-top: 10px;
    }
    .edit-custom-field__content{
        padding: 50px 0;
        font-weight: normal;
        max-width:950px;
    }
    .edit-custom-field__section-common{
        width: 600px;
        margin-left: 180px;
    }
    .edit-custom-field__field__focus:focus {
        border-color: #009688;
    }
    .edit-custom-field__des{
        color: #888;
    }
    .edit-custom-field__section-common-title {
        font-size: 14px;
        font-weight: normal;
    }
    .edit-custom-field__section-common-input{
        height: 30px;
        width: 400px;
        border: 1px solid #a9a9a9;
        padding: 0 10px;
    }
    .edit-custom-field__section-common-checkbox{
        cursor: pointer;
        color: #333;
    }
    .edit-custom-field__section-common-textarea{
        height: 150px;
        width: 600px;
        padding: 10px;
        resize: none;
    }
    .edit-custom-field__panel-section{
        border-top: 1px solid #eee;
        padding: 15px;
        overflow: hidden;
    }
    .edit-custom-field__panel-section-title{
        font-size: 14px;
        font-weight: normal;
        float: left;
        width: 165px;
    }
    .edit-custom-field__panel-section-content{
        float: left;
        width: 720px;
    }
    .edit-custom-field__panel-section-lists{
        list-style-type: none;
        background: #fff;
        margin:0;

        border: 1px solid #a9a9a9;
        padding: 15px;
    }
    .edit-custom-field__panel-section-lists-item{
        margin-bottom: 5px;
    }
    .edit-custom-field__panel-section-lists-item:hover{
        background: #eff4f5;
    }
    .edit-custom-field__panel-section-input{
        padding-left: 10px;
        width: 300px;
        height:30px;
        border:1px solid #a9a9a9;
    }
    .edit-custom-field__panel-section-remove{
        float: right;
        height: 30px;
        line-height: 30px;
        text-align: center;
        width: 30px;
        background: none 0 0 repeat scroll rgb(255, 89, 95);
        border-radius: 100%;
        color: #fff;
        font-size: 22px;
    }
    .edit-custom-field__panel-section-addicon{
        display: inline-block;
        height: 20px;
        line-height: 20px;
        text-align: center;
        width: 20px;
        background: #009688;
        border-radius: 100%;
        color: #fff;
        font-size: 14px;
        margin: 5px;
    }
    .edit-custom-field__panel-section-add:hover{
        text-decoration: underline;
    }
    .edit-custom-field__panel-section-select{
        width: 175px;
        height:30px;
        border:1px solid #a9a9a9;
        letter-spacing: 4px;
    }
    .edit-custom-field__panel-section-operation{
        margin-left: 180px;
    }
</style>