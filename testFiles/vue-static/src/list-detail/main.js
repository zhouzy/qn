/**
 * @desc 名单详情
 * @author Lesty
 * @codeDate 2017.3.16
 **/
import Vue from 'vue';
// vuex实例
import store from './store';

import axios from 'axios';
// 使axios支持finally
require('promise.prototype.finally').shim();

// 工具方法
import tools from '@/lib-js/lib.js';
// 常量及相关配置数据
import config from '@/lib-js/config.js';

// app组件
import App from './components/app.vue'


Vue.config.debug = true;//开启错误提示

// axios配置
axios.defaults.baseURL = location.origin;
// 禁止IE ajax缓存
axios.defaults.headers.get['If-Modified-Since'] = 'Mon, 26 Jul 1997 05:00:00 GMT';
axios.defaults.headers.get['Cache-Control'] = 'no-cache';
axios.defaults.headers.get['Pragma'] = 'no-cache';
// 原型属性注入
Vue.prototype.tools = tools;
Vue.prototype.axios = axios;
// 全局常量注入
window.ACT_CONFIG = config;

// 创建根实例并注入路由
const listDetailApp = new Vue({
    // 挂载元素
    el : "#listDetailApp",
    // 注入vuex实例Store
    store,
    template: '<App/>',
    // 注入子组件
    components: {App}
});