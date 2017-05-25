<template>
    <div class="sidebar__root">
        <el-menu mode="vertical"
                 :default-active="onRoutes"
                 class="el-menu-vertical-demo"
                 router>
            <el-menu-item-group title="个人中心">
                <el-menu-item v-for="menu in menus" :index="menu.path"><i :class="['sidebar__icon', menu.iconClass]"></i>{{menu.title}}</el-menu-item>
            </el-menu-item-group>
        </el-menu>
    </div>
</template>
<script type="text/ecmascript-6">
    /**
     * @desc 侧边栏组件
     * @author Lesty
     * @code-date 2017.5.18
     **/
    export default {
        name: 'Sidebar',
        data: function () {
            return {
                // 上下文路径
                contextPath: INFO_G.contextPath,
                // 菜单列表(这个可以优化，比如增加组标题，以及subMenu)
                menus: [
                    {
                        path: 'my-order',
                        title: '我的工单',
                        iconClass: 'fa fa-file-text-o'
                    },
                    {
                        path: 'my-info',
                        title: '我的资料',
                        iconClass: 'fa fa-user-circle-o'
                    }
                ]
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
            },
            // 当前路由路径
            onRoutes: function() {
                return this.$route.path.replace('/','');
            }
        },
        methods:{

        }
    }
</script>
<style lang="less" scoped>
    @import "../../less/sidebar.less";
</style>
