<template>
    <div class="list-field-config__root">
        <page-header>
            <!--将顶部区域附加内容通过具名slot进行分发-->
            <ul slot="topContent" class="list-field-config__breadcrumbs">
                <li class="list-field-config__breadcrumbs-item">
                    <router-link to="/list-field-config" active-class="list-field-config__router-link-active">{{topTitle}}</router-link>
                </li>
            </ul>
        </page-header>

        <div class="container-fluid list-field-config__main">
            <div class="panel list-field-config__section-contain">
                <!--启用的字段-->
                <div class="list-field-config__section-box">
                    <header class="list-field-config__section-header list-field-config__header__reset list-field-config__clear">
                        <h5 class="list-field-config__section-title active list-field-config__h5__reset">启用的字段（{{activeList.length}}）</h5>
                        <a class="list-field-config__section-btn fr success" href="#/list-field-config/select-custom-field" style="margin-right: 23px;">添加自定义字段</a>
                    </header>
                    <draggable :list="activeList" element="ul" @end="dragSort" class="list-field-config__field-list list-field-config__ul__set">
                        <template v-for="fieldInfo in activeList">
                            <field-info-item
                                    :field-info="fieldInfo"
                                    :is-active="true"
                                    type-desc="名单字段"
                                    v-on:delete-field="changeField('delete', arguments[0])"
                                    v-on:unactive-field="changeField('deactive', arguments[0])"
                                    v-on:active-field="changeField('active', arguments[0])"
                                    v-on:edit-field="editField(arguments[0])"></field-info-item>
                        </template>
                    </draggable>
                </div>
                <!--客户字段-->
<!--                <div class="list-field-config__section-box">
                    <header class="list-field-config__section-header list-field-config__header__reset list-field-config__clear">
                        <h5 class="list-field-config__section-title unactive list-field-config__h5__reset">客户字段（{{custommerFieldNameList.length}}）</h5>
                    </header>
                    <ul class="list-field-config__field-list list-field-config__ul__set">
                        <template v-for="fieldInfo in custommerFieldNameList">
                            <field-info-item
                                    :field-info="fieldInfo"
                                    :is-active="false"
                                    type-desc="客户字段"
                                    v-on:delete-field="changeField('delete', arguments[0])"
                                    v-on:unactive-field="changeField('deactive', arguments[0])"
                                    v-on:active-field="changeField('active', arguments[0])"
                                    v-on:edit-field="editField(arguments[0])"></field-info-item>
                        </template>
                    </ul>
                </div>-->
                <!--未启用的字段-->
                <div class="list-field-config__section-box">
                    <header class="list-field-config__section-header list-field-config__header__reset list-field-config__clear">
                        <h5 class="list-field-config__section-title unactive list-field-config__h5__reset">未启用的字段（{{deactiveNameList.length}}）</h5>
                    </header>
                    <ul class="list-field-config__field-list list-field-config__ul__set">
                        <template v-for="fieldInfo in deactiveNameList">
                            <field-info-item
                                    :field-info="fieldInfo"
                                    :is-active="false"
                                    type-desc="名单字段"
                                    v-on:delete-field="changeField('delete', arguments[0])"
                                    v-on:unactive-field="changeField('deactive', arguments[0])"
                                    v-on:active-field="changeField('active', arguments[0])"
                                    v-on:edit-field="editField(arguments[0])"></field-info-item>
                        </template>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</template>
<script type="text/ecmascript-6">
    // 页面顶部标题组件
    import pageHeader from '../lib-components/page-header.vue';
    // 字段信息组件
    import fieldInfoItem from './field-info-item.vue';
    // 拖拽组件
    import draggable from 'vuedraggable';

    /**
     * @desc 名单字段配置组件
     * @author Lesty
     * @code-date 2017.2.21
     **/
    export default {
        props: ['topTitle'],
        created: function() {
            // 刷新字段列表
            this.refreshFieldList();
        },
        methods: {
            // 改变字段(启用、停用、删除)
            changeField: function (type, fieldKey) {
                // 删除字段时做出提示
                if(type !== "delete" || confirm("确定要删除该字段吗？删除后字段不可恢复！")) {
                    $.post(this.CHANGE_URL + type + '/' + fieldKey).then(data => {
                        if(!(data.success)) {
                            notice.danger(data.msg);
                            return;
                        }

                        notice.success("操作成功!");

                        // 刷新字段列表
                        this.refreshFieldList();
                    });
                }
            },
            // 编辑字段
            editField: function(fieldKey) {
                location.hash = '#/list-field-config/edit-custom-field?changeType=edit&fieldKey=' + fieldKey;
            },
            // 刷新字段列表
            refreshFieldList: function() {
                $.post(location.origin + '/namelist/queryField').then(data => {
                    let rows = data.rows;
                    if(!(data.success)) {
                        notice.danger(data.msg);
                        return;
                    }

                    this.activeList = rows.activeList;
                    this.deactiveNameList = rows.deactiveNameList;
                    /*this.custommerFieldNameList = rows.custommerFieldNameList;*/
                });
            },
            // 排序
            dragSort:function () {
                let list=this.activeList;
                let ids='';
                for(var i=0,len=list.length;i<len;i++){
                    ids+=list[i].key+',';
                }
                $.ajax({
                    url:location.origin + '/namelist/ajax',
                    data:{type:'sort',ids:ids},
                    success:function (data) {
                        if(data.success){
                            notice.success(data.msg);
                        }else{
                            notice.warning(data.msg);
                        }
                    }
                })
            }
        },
        data: function () {
            return {
                // 未启用的列表
                deactiveNameList: [],
                // 客户自定义列表
                /*custommerFieldNameList: [],*/
                // 启用的列表
                activeList: [],
                CHANGE_URL: location.origin + '/namelist/change/'
            };
        },
        // 注入子组件
        components: {pageHeader, fieldInfoItem, draggable}
    };
</script>

<style lang="less">
    @link-color: #337ab7;
    @link-hover-color: #48b6d7;
    @active-color: #21d376;
    @unactive-color: #888;
    @danger-color: #d9534f;
    .list-field-config__root {
        height: 100%;
        overflow: auto;
    }

    .list-field-config__breadcrumbs {
        margin-bottom: 0;
        padding-left: 0;
        font-size: 16px;
        font-weight: normal;
    }

    .list-field-config__breadcrumbs-item {
        display: inline-block;
    }

    .list-field-config__breadcrumbs-item::after {
        color: #999;
        content: ">";
        margin: 0 5px;
    }

    .list-field-config__breadcrumbs-item:last-child::after {
        display: none;
    }

    .list-field-config__router-link-active {
        color: @link-color;
    }

    .list-field-config__router-link-active:hover {
        color: @link-hover-color;
    }

    .list-field-config__main {
        margin-top: 10px;
    }

    .list-field-config__section-contain {
        padding: 0 15px 15px 15px;
        overflow: hidden;
    }

    .list-field-config__section-box {
        margin-top: 15px;

    }

    .list-field-config__section-header {
        margin-bottom: 15px;
        font-size: 16px;
    }

    .list-field-config__header__reset {
        padding-left: 0;
    }

    .list-field-config__section-title {
        float: left;
        padding-left: 10px;
        border-left: 3px solid @active-color;
    }

    .list-field-config__section-title.active {
        border-left-color: @active-color;
    }

    .list-field-config__section-title.unactive {
        border-left-color: @unactive-color;
    }

    .list-field-config__h5__reset {
        font-weight: bold;
    }

    .list-field-config__clear::after {
        clear: both;
        content: ".";
        display: block;
        height: 0;
        visibility: hidden;
    }

    .list-field-config__section-btn {
        display: inline-block;
        padding: 3px 14px;

        font-size: 13px;
        font-weight: 400;
        line-height: 1.42857143;

        text-align: center;
        white-space: nowrap;
        vertical-align: middle;

        touch-action: manipulation;
        cursor: pointer;

        -webkit-user-select: none;
        -moz-user-select: none;
        -ms-user-select: none;
        user-select: none;

        background-image: none;

        border-radius: 4px;

        color: #444;
        border: 1px solid #d2d2d2;
    }

    .list-field-config__section-btn:hover {
        color: #fff;
        background-color: #444;
        border-color: transparent;
    }

    .list-field-config__section-btn[disabled],
    .list-field-config__section-btn.disabled {
        color: @unactive-color;
        cursor: not-allowed;
    }

    .list-field-config__section-btn.fr {
        float: right;
    }

    .list-field-config__section-btn.success {
        color: @active-color;
    }

    .list-field-config__section-btn.success:hover {
        color: #fff;
        background-color: @active-color;
    }

    .list-field-config__section-btn.danger {
        color: @danger-color;
        /*border: 1px solid @danger-color;*/
    }

    .list-field-config__section-btn.danger:hover {
        color: #fff;
        background-color: @danger-color;
    }

    .list-field-config__field-list {
        border-bottom: 1px solid #eef0f5;
        padding-bottom: 15px;
    }

    .list-field-config__ul__set {
        padding-left: 0;
        margin-bottom: 0;
        list-style: none;
    }

    .list-field-config__field-list > li {
        padding: 8px;
        line-height: 32px;

        font-size: 14px;
        font-weight: normal;
    }

    .list-field-config__field-list > li:hover {
        background: #eff4f5 none repeat scroll 0 0;
    }

    .list-field-config__select {
        height: 30px;
        border-radius: 4px;
    }

    .list-field-config__select.disabled,
    .list-field-config__select[disabled] {
        cursor: not-allowed;
    }
</style>