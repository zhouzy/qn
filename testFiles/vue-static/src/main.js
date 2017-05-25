/**
 * 电销外呼APP
 * Author zhouzy
 * Date   2017/2/10
 */
import Vue from 'vue';
// vue-router实例
import router from './router'
// vuex实例
import store from './store'

import axios from 'axios';
// 使axios支持finally
require('promise.prototype.finally').shim();

// 工具方法
import tools from './lib-js/lib.js';
// 常量及相关配置数据
import config from './lib-js/config.js';

// 左侧菜单组件
import leftMenu from '@/lib-components/left-menu.vue';
// element UI框架
import ElementUI from 'element-ui'
// css样式需要单独引用
import 'element-ui/lib/theme-default/index.css'

Vue.use(ElementUI);
Vue.config.debug = true;//开启错误提示

// axios配置
axios.defaults.baseURL = location.origin;
axios.interceptors.request.use(function (config) {
    if(config.hideLoading !== true) {
        Tools.loadingBox.show();
    }

    return config;
});
axios.interceptors.response.use(function (response) {
    Tools.loadingBox.hide();
    return response;
});
// 原型属性注入
Vue.prototype.tools = tools;
Vue.prototype.axios = axios;
// 全局常量注入
window.ACT_CONFIG = config;

// 创建根实例并注入路由
const teleActivityApp = new Vue({
    // 挂载元素
    el : "#teleActivityApp",
    // 注入路由
    router : router,
    // 注入vuex实例Store
    store,
    data: {
        // 右侧部分顶部标题名
        rightTopTitle: ''
    },
    computed: {
        // 左侧切换按钮是否展开
        isLeftOpen: function() {
            return store.state.leftMenuIsOpen;
        }
    },
    methods: {
        /**
         * @desc select-menu事件触发时调用，修改右侧部分标题名
         **/
        selectMenu: function(menuTitle) {
            this.rightTopTitle = menuTitle;
        }
    },
    // 注入子组件
    components: {leftMenu}
});
