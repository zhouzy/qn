<template>
    <div class="header__root">
        <el-row :gutter="20">
            <el-col :sm="8">
                <el-breadcrumb separator="/">
                    <el-breadcrumb-item :to="{ path: '/my-order' }">我的工单</el-breadcrumb-item>
                </el-breadcrumb>

            </el-col>
            <el-col :sm="{span: 8, offset: 8}">
                <el-button>默认按钮</el-button>
                <el-button type="primary">主要按钮</el-button>
                <el-button type="text">文字按钮</el-button>
                <el-button-group>
                    <el-button type="primary" icon="edit"></el-button>
                    <el-button type="primary" icon="share"></el-button>
                    <el-button type="primary" icon="delete"></el-button>
                    <el-button type="primary" icon="delete"></el-button>
                </el-button-group>
            </el-col>
        </el-row>
    </div>
</template>
<script type="text/ecmascript-6">
    /**
     * @desc 右侧页面头部组件
     * @author Lesty
     * @code-date 2017.5.18
     **/
    export default {
        name: 'RightHeader',
        data: function () {
            return {
                // 上下文路径
                contextPath: INFO_G.contextPath
            }
        },
        computed:{
            // 用户头像地址
            userPhoneUrl: function() {
                return this.$store.state.userPhoneUrl;
            },
            // 用户头像地址
            userName: function() {
                return this.$store.state.userName;
            }
        },
        methods:{
            handleCommand: function (cmd) {

            }
        }
    }
</script>
<style lang="less" scoped>
    @import "../../less/header.less";
</style>
