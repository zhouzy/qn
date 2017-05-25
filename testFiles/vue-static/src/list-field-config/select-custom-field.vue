<template>
    <div class="select-custom-field__root">
        <page-header>
            <!--将顶部区域附加内容通过具名slot进行分发-->
            <ul slot="topContent" class="list-field-config__breadcrumbs">
                <li class="list-field-config__breadcrumbs-item">
                    <router-link to="/list-field-config" active-class="list-field-config__router-link-active">{{topTitle}}</router-link>
                </li>
                <li class="list-field-config__breadcrumbs-item">
                    <router-link to="/list-field-config/select-custom-field" active-class="list-field-config__router-link-active">选择字段类型</router-link>
                </li>
            </ul>
        </page-header>

        <div class="select-custom-field__main container-fluid">
            <div class="panel">
                <div class="select-custom-field__panel-box">
                    <div class="select-custom-field__panel-section">
                        <h4 class="select-custom-field__panel-section-title">文本框</h4>
                        <div class="select-custom-field__panel-section-content">
                            <a class="btn btn-sm btn-raised btn-primary pull-right" href="" @click.prevent="selectType('1')">选择此字段</a>
                            <input value="文本框里的文字" type="text"
                                   class="select-custom-field__panel-section-input select-custom-field__panel-section__focus">
                            <p class="select-custom-field__panel-section-des">
                                文本框字段可以填写少量的文字
                            </p>
                        </div>
                    </div>
                    <div class="select-custom-field__panel-section">
                        <h4 class="select-custom-field__panel-section-title">文本区域</h4>
                        <div class="select-custom-field__panel-section-content">
                            <a class="btn btn-sm btn-raised btn-primary pull-right" href="" @click.prevent="selectType('2')">选择此字段</a>
                            <textarea
                                      class="select-custom-field__panel-section-textarea select-custom-field__panel-section__focus">文本区域里的文字</textarea>
                            <p class="select-custom-field__panel-section-des">
                                文本区域字段可以填写多行文字及说明
                            </p>
                        </div>
                    </div>
                    <div class="select-custom-field__panel-section">
                        <h4 class="select-custom-field__panel-section-title">下拉菜单</h4>
                        <div class="select-custom-field__panel-section-content">
                            <a class="btn btn-sm btn-raised btn-primary pull-right" href="" @click.prevent="selectType('3')">选择此字段</a>
                            <select class="select-custom-field__panel-section-select select-custom-field__panel-section__focus">
                                <option>男</option>
                                <option>女</option>
                            </select>
                            <p class="select-custom-field__panel-section-des">
                                基本的下拉菜单字段，可以设置多个下拉选项
                            </p>
                        </div>
                    </div>
                    <div class="select-custom-field__panel-section">
                        <h4 class="select-custom-field__panel-section-title">复选框</h4>
                        <div class="select-custom-field__panel-section-content">
                            <a class="btn btn-sm btn-raised btn-primary pull-right" href="" @click.prevent="selectType('4')">选择此字段</a>
                            <label class="select-custom-field__panel-section-checkbox">
                                <input type="checkbox">
                                产品设计
                            </label>
                            <label class="select-custom-field__panel-section-checkbox">
                                <input type="checkbox">
                                产品交互
                            </label>
                            <label class="select-custom-field__panel-section-checkbox">
                                <input type="checkbox">
                                产品技术
                            </label>
                            <label class="select-custom-field__panel-section-checkbox">
                                <input type="checkbox">
                                产品战略
                            </label>
                            <p class="select-custom-field__panel-section-des">复选框字段可以设置多个能同时选中的选项</p>
                        </div>
                    </div>
                    <div class="select-custom-field__panel-section">
                        <h4 class="select-custom-field__panel-section-title">数字</h4>
                        <div class="select-custom-field__panel-section-content">
                            <a class="btn btn-sm btn-raised btn-primary pull-right" href="" @click.prevent="selectType('6')">选择此字段</a>
                            <input value="123456" type="number"
                                   class="select-custom-field__panel-section-input select-custom-field__panel-section__focus">
                            <p class="select-custom-field__panel-section-des">这里仅可以填写数字</p>
                        </div>
                    </div>
                    <div class="select-custom-field__panel-section">
                        <h4 class="select-custom-field__panel-section-title">小数</h4>
                        <div class="select-custom-field__panel-section-content">
                            <a class="btn btn-sm btn-raised btn-primary pull-right" href="" @click.prevent="selectType('7')">选择此字段</a>
                            <input value="34.56" type="number"
                                   class="select-custom-field__panel-section-input select-custom-field__panel-section__focus">
                            <p class="select-custom-field__panel-section-des">这里仅可以填写小数</p>
                        </div>
                    </div>
                    <div class="select-custom-field__panel-section">
                        <h4 class="select-custom-field__panel-section-title">正则匹配字段</h4>
                        <div class="select-custom-field__panel-section-content">
                            <a class="btn btn-sm btn-raised btn-primary pull-right" href="" @click.prevent="selectType('8')">选择此字段</a>
                            <input value="A-Za-z[1234567890]" type="text"
                                   class="select-custom-field__panel-section-input select-custom-field__panel-section__focus">
                            <p class="select-custom-field__panel-section-des">
                                这里可以设置固定的正则匹配规则来限定文本框填写的内容
                            </p>
                        </div>
                    </div>
                    <div class="select-custom-field__panel-section">
                        <h4 class="select-custom-field__panel-section-title">电话号码</h4>
                        <div class="select-custom-field__panel-section-content">
                            <a class="btn btn-sm btn-raised btn-primary pull-right" href="" @click.prevent="selectType('9')">选择此字段</a>
                            <input type="number" value=""
                                   class="select-custom-field__panel-section-input select-custom-field__panel-section__focus">
                            <p class="select-custom-field__panel-section-des">
                                这里可以设置手机号和座机号(只要是数字，且位数为7,8,11,12位其中一个都可以)</p>
                        </div>
                    </div>
                    <div class="select-custom-field__panel-section">
                        <h4 class="select-custom-field__panel-section-title">时间输入框</h4>
                        <div class="select-custom-field__panel-section-content">
                            <a class="z1 btn btn-sm btn-raised btn-primary pull-right" href="" @click.prevent="selectType('10')">选择此字段</a>
                            <input type="text"
                                   class="select-custom-field__panel-section-datetime select-custom-field__panel-section__focus select-custom-field__panel-section-input"
                                   id="datetimepicker">
                            <p class="select-custom-field__panel-section-des">
                                这里可以日期时间
                            </p>
                        </div>
                    </div>
                    <div class="select-custom-field__panel-section">
                        <h4 class="select-custom-field__panel-section-title">省市区</h4>
                        <div class="select-custom-field__panel-section-content">
                            <a class="btn btn-sm btn-raised btn-primary pull-right" href="" @click.prevent="selectType('11')">选择此字段</a>
                            <select name="province_s" id="Company_province"
                                    class="select-custom-field__panel-section-pcas select-custom-field__panel-section__focus"></select>
                            <select name="city_s" id="Company_city"
                                    class="select-custom-field__panel-section-pcas select-custom-field__panel-section__focus"></select>
                            <select name="area_s" id="Company_area"
                                    class="select-custom-field__panel-section-pcas select-custom-field__panel-section__focus"></select>
                            <p class="select-custom-field__panel-section-des">可以设置省市地区信息</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>
<script>
    // 页面顶部标题组件
    import pageHeader from '../lib-components/page-header.vue';

    export default{
        props: ['topTitle'],
        mounted: function () {
            $('#datetimepicker').timeInput({
                format: "yyyy-MM-dd hh:mm:ss"
            });
            new PCAS("province_s", "city_s", "area_s");
        },
        methods: {
            selectType: function (type) {
                location.hash = '#/list-field-config/edit-custom-field?changeType=add&fieldType=' + type;
            }
        },
        // 注入子组件
        components: {pageHeader}
    }
</script>
<style lang="less">
    .z1{
        position: relative;
        z-index:1;
    }
    .select-custom-field__panel-box{
        max-width: 950px;
    }
    .select-custom-field__root {
        height: 100%;
        overflow: auto;
    }

    .select-custom-field__main {
        margin-top: 10px;
    }

    .select-custom-field__panel-section {
        font-weight: normal;
        padding: 15px;
        overflow: hidden;
        border-bottom: 1px solid #eff4f5;
    }

    .select-custom-field__panel-section-title {
        font-size: 14px;
        font-weight: normal;
        float: left;
        width: 20%;
    }

    .select-custom-field__panel-section-content {
        float: right;
        width: 80%;
        background: #eff4f5;;
        padding: 15px;
    }

    .select-custom-field__panel-section-input {
        height: 30px;
        width: 400px;
        border: 1px solid #a9a9a9;
        padding: 5px;
    }

    .select-custom-field__panel-section-textarea {
        width: 400px;
        height: 100px;
        resize: none;
        padding:5px;
    }

    .select-custom-field__panel-section-datetime {
        width: 400px!important;
    }
    .select-custom-field__panel-section-datetime + span{
        display: none;
    }
    
    .select-custom-field__panel-section-pcas {
        width: 150px;
        height: 30px;
    }

    .select-custom-field__panel-section-select {
        height: 30px;
        border-color: #a9a9a9;
    }

    .select-custom-field__panel-section-checkbox {
        font-size: 14px;
        color: #333;
    }

    .select-custom-field__panel-section__focus:focus {
        border-color: #009688;
    }

    .select-custom-field__panel-section-des {
        padding-top: 5px;
        margin-bottom: 0;
        color: #999;
    }
</style>