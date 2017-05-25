<template>
    <li class="list-field-config__clear field-info-item__root">
        <div id="userName" :class="[{'field-info-item__text-unactive': !isActive}, 'col-sm-2']">{{fieldInfo.name}}</div>
        <div class="col-md-2 field-info-item__text-unactive">{{fieldInfo.componentTypeStr}}</div>
        <div class="col-md-2 field-info-item__text-unactive">{{fieldInfo.defineType}}</div>
        <div class="col-md-1 field-info-item__text-unactive">{{fieldInfo.isRequiredStr}}</div>
        <div class="col-md-2 field-info-item__text-unactive">{{typeDesc}}
<!--            <select class="list-field-config__select" disabled>
                <option>名单自定义字段</option>
                <option>客户自定义子弹</option>
            </select>-->
        </div>
        <div class="col-md-3" style="text-align: right">
            <!--对默认字段和非默认字段区别处理-->
            <!--特殊处理客户字段-->
            <template v-if="fieldInfo.isDefault || typeDesc === '客户字段'">
                <a class="list-field-config__section-btn" href="javascript:void(0);" disabled>无法编辑</a>
            </template>
            <template v-else>
                <template v-if="isActive">
                    <a class="list-field-config__section-btn danger" href="" @click.prevent="changeField('unactive-field')">停用</a>
                    <a class="list-field-config__section-btn" href="" @click.prevent="editField">编辑</a>
                </template>
                <template v-else>
                    <a class="list-field-config__section-btn danger" href="" @click.prevent="changeField('delete-field')">删除</a>
                    <a class="list-field-config__section-btn success" href="" @click.prevent="changeField('active-field')">启用</a>
                    <a class="list-field-config__section-btn" href="" @click.prevent="editField">编辑</a>
                </template>
            </template>
        </div>
    </li>
</template>
<script type="text/ecmascript-6">
    /**
     * @desc 字段信息组件
     * @author Lesty
     * @code-date 2017.2.24
     **/
    module.exports = {
        props: {
            // 字段信息
            fieldInfo: {
                type: Object,
                required: true,
                default: {}
            },
            // 是否启用
            isActive: {
                type: Boolean,
                default: false
            },
            // 字段类型描述
            typeDesc: {
                type: String,
                default: ''
            }
        },
        data: function () {
            return {
            };
        },
        methods: {
            // 改变字段(启用、停用、删除)
            changeField: function (type) {
                this.$emit(type, this.fieldInfo.key);
            },
            // 编辑字段
            editField: function() {
                this.$emit('edit-field', this.fieldInfo.key);
            }
        }
    };
</script>

<style lang="less" scoped>
    .field-info-item__text-unactive {
        color: #888;
    }
    .field-info-item__root{
        cursor: move;
    }
</style>