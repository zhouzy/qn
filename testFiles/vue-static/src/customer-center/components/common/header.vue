<template>
    <div class="header__root">
        <el-row :gutter="20">
            <el-col :sm="8">
                <div class="header__logo-box">
                    <img class="header__logo" alt="企业logo" :src="contextPath + '/static/images/logo.png'">
                </div>
            </el-col>
            <el-col :sm="{span: 8, offset:8}">
                <div class="header__user-info">
                    <el-dropdown trigger="click" @command="handleCommand">
                        <div class="el-dropdown-link header__user-photo-box">
                            <img alt="头像" :src="userPhoneUrl" class="header__user-photo">
                            <span class="header__user-name">{{userName}}</span>
                        </div>
                        <el-dropdown-menu slot="dropdown">
                            <el-dropdown-item command="logout"
                                              v-loading.fullscreen="isFullScreenLoading"
                                              element-loading-text="正在退出···">退出
                            </el-dropdown-item>
                        </el-dropdown-menu>
                    </el-dropdown>
                </div>
            </el-col>
        </el-row>
    </div>
</template>
<script type="text/ecmascript-6">
    /**
     * @desc 页面头部组件
     * @author Lesty
     * @code-date 2017.5.18
     **/
    export default {
        name: 'PageHeader',
        data: function () {
            return {
                // 上下文路径
                contextPath: INFO_G.contextPath,
                // 是否正在加载(全屏)
                isFullScreenLoading: false
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
            // 处理下拉菜单cmd
            handleCommand: function (cmd) {
                if(cmd === 'logout') {
                    // 显示loading
                    this.isFullScreenLoading = true;
                    this.logout().then(res => {
                        let data = res.data;
                        if(!data.success) {
                            return Promise.reject(new Error(data.msg));
                        }

                        // 跳转到登录页
                        window.location.href = this.contextPath + '/login';
                    }).catch(error => {
                        this.$message({
                            showClose: true,
                            type: 'error',
                            message: error.message
                        });
                    }).finally(() => {
                        setTimeout(() => {
                            // 隐藏loading
                            this.isFullScreenLoading = false;
                        }, 100);
                    });
                }
            },
            // 登出
            logout: function () {
                return this.axios.post('/logout');
            }
        }
    }
</script>
<style lang="less" scoped>
    @import "../../less/header.less";
</style>
