<template>
    <div id="customerCenterApp" class="customer-center__root">
        <page-header class="customer-center__header"></page-header>
        <div class="customer-center__main-content">
            <left-sidebar class="customer-center__sidebar"></left-sidebar>
            <div class="customer-center__right-part">
                <transition name="fade" mode="out-in">
                    <router-view></router-view>
                </transition>
            </div>
        </div>
    </div>
</template>

<script type="text/ecmascript-6">
    // 页面头部组件
    import PageHeader from './components/common/header.vue';
    // 侧边栏组件
    import LeftSidebar from './components/common/sidebar.vue';

    /**
     * @desc 客户中心组件
     * @author Lesty
     * @code-date 2017.5.17
     **/
    export default {
        name: 'CustomerCenterApp',
        created: function () {
            // 设置用户头像地址
            this.$store.commit('SET_USER_PHOTO', INFO_G.userPhotoUrl);
            // 设置用户名
            this.$store.commit('SET_USER_NAME', INFO_G.userName);
        },
        data: function() {
            return {

            };
        },
        components: {
            PageHeader,
            LeftSidebar
        }
    }
</script>

<style lang="less">
    @import "./less/customer-center.less";
</style>