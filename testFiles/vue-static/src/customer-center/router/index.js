import Vue from 'vue'
import Router from 'vue-router'

/***
 * @desc vue-router实例,各相关路由归类组合成一个chunk进行打包并异步惰性加载
 * @author Lesty
 * @codeDate 2017.5.17
 */

// 安装路由功能
Vue.use(Router);

/*
* @desc 我的工单相关组件
* */
// require.ensure 是 Webpack 的特殊语法，用来设置 code-split point
// 我的工单组件
const MyOrder = resolve => require.ensure([], () => resolve(require('customerCenter/components/my-order/my-order.vue')), 'my-order');
// 提交工单组件
const CommitOrder = resolve => require.ensure([], () => resolve(require('customerCenter/components/my-order/commit-order.vue')), 'my-order');

/*
 * @desc 我的资料相关组件
 * */
// 我的资料组件
const MyInfo = resolve => require.ensure([], () => resolve(require('customerCenter/components/my-info/my-info.vue')), 'my-info');


// 定义路由
const routes = [
    {
        path: '/',
        redirect: '/my-order'
    },
    {
        path: '/my-order',
        component: MyOrder
    },
    {
        path: '/commit-order',
        component: CommitOrder
    },
    {
        path: '/my-info',
        component: MyInfo
    },
];

//配置路由
export default new Router({
    mode : 'hash',
    routes
})