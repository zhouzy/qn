<template>
    <div>
        <!--标题头部-->
        <div class="customer-center__right-part-header">
            <el-row>
                <el-col :sm="8">
                    <el-breadcrumb separator="/" class="customer-center__breadcrumb">
                        <el-breadcrumb-item>我的资料</el-breadcrumb-item>
                    </el-breadcrumb>
                </el-col>
            </el-row>
        </div>

        <!--主要内容-->
        <div class="customer-center__main-content">
            <el-tabs v-model="curTabName" type="border-card" @tab-click="">
                <el-tab-pane label="基本信息" name="baseInfo">基本信息</el-tab-pane>
                <el-tab-pane label="修改密码" name="changePwd">修改密码</el-tab-pane>
            </el-tabs>
        </div>
    </div>
</template>

<script type="text/ecmascript-6">

    /**
     * @desc 我的资料组件
     * @author Lesty
     * @code-date 2017.5.19
     **/
    export default {
        name: 'MyInfo',
        data: function() {
            return {
                // 当前tab标签页name
                curTabName: 'baseInfo'
            };
        }
    }
</script>