import Vue from 'vue'
import Router from 'vue-router'

/***
 * @desc vue-router实例,各相关路由归类组合成一个chunk进行打包并异步惰性加载
 * @author Lesty
 * @codeDate 2017.3.10
 */

// 安装路由功能
Vue.use(Router);

/*
 * @desc 活动管理路由相关组件
 * */
// 活动管理组件
const allActivity = resolve => require.ensure([], () => resolve(require('@/all-activity-components/activity-manage.vue')), 'all-activity');
// 创建活动组件
const createActivity = resolve => require.ensure([], () => resolve(require('@/all-activity-components/activity-create.vue')), 'all-activity');
// 修改活动组件
const alterActivity = resolve => require.ensure([], () => resolve(require('@/all-activity-components/activity-alter.vue')), 'all-activity');
// 活动详情组件
const activityDetail = resolve => require.ensure([], () => resolve(require('@/activity-detail/activity-detail.vue')), 'all-activity');

/*
* @desc 名单字段配置路由相关组件
* */
// require.ensure 是 Webpack 的特殊语法，用来设置 code-split point
// 名单字段配置组件
const listFieldConfig = resolve => require.ensure([], () => resolve(require('@/list-field-config/list-field-config.vue')), 'list-field-config');
// 添加自定义字段组件
const selectCustomField = resolve => require.ensure([], () => resolve(require('@/list-field-config/select-custom-field.vue')), 'list-field-config');
// 编辑自定义字段组件
const editCustomField = resolve => require.ensure([], () => resolve(require('@/list-field-config/edit-custom-field.vue')), 'list-field-config');

/*
 * @desc 外呼历史路由相关组件
 * */
// 外呼历史组件
const foreignCallHistory = resolve => require.ensure([], () => resolve(require('@/foreign-call-history-components/foreign-call-history.vue')), 'foreign-call-history');
// 我的外呼历史组件
const myForeignCallHistory = resolve => require.ensure([], () =>resolve(require('@/my-foreign-call-history/my-foreign-call-history.vue')), 'my-foreign-call-history');

/*
 * @desc 预约管理路由相关组件
 * */
// 预约管理组件
const reservationManage = resolve => require.ensure([], () => resolve(require('@/reservation-manage/reservation-list.vue')), 'reservation-manage');

/*
 * @desc 我的预约路由相关组件
 * */
// 我的预约组件
const myReservation = resolve => require.ensure([], () => resolve(require('@/my-reservation-components/my-reservation.vue')), 'my-reservation');

/*
 * @desc 活动统计路由相关组件
 * */
// 活动统计组件
const activityStatistics = resolve => require.ensure([], () => resolve(require('@/activity-statistics/activity-statistics.vue')), 'activity-detail');

/*
 * @desc 导入外呼名单路由相关组件
 * */
// 导入外呼名单组件
const importForeignCallList = resolve => require.ensure([], () => resolve(require('@/all-activity-components/import-foreign-call-list/import-foreign-call-list.vue')), 'import-list');
// 导入名单完成
const importListSuccess = resolve => require.ensure([], () => resolve(require('@/all-activity-components/import-foreign-call-list/import-list-success.vue')), 'import-list');
// 分配名单组件
const assignList = resolve => require.ensure([], () => resolve(require('@/all-activity-components/import-foreign-call-list/assign-list.vue')), 'import-list');
// 分配名单完成组件
const assignListOver = resolve => require.ensure([], () => resolve(require('@/all-activity-components/import-foreign-call-list/assign-list-over.vue')), 'import-list');


/*
 * @desc 我的呼叫活动名单路由相关组件
 * */
// 我的呼叫活动名单组件
const myActivity = resolve => require.ensure([], () => resolve(require('@/my-activity/my-activity.vue')), 'my-activity');
// 我的呼叫活动详情
const myActivityDetail = resolve => require.ensure([], () => resolve(require('@/my-activity/my-activity-detail.vue')), 'my-activity');

// 定义路由
const routes = [
    {
        path: '/reservation-manage',
        component: reservationManage
    }, {
        path: '/my-reservation',
        component: myReservation
    }, {
        path: '/control',
        component: allActivity
    }, {
        path: '/control/activity-create',
        component: createActivity
    }, {
        path: '/control/activity-alter',
        component: alterActivity
    }, {
        path: '/foreign-call-history',
        component: foreignCallHistory
    }, {
        path: '/my-foreign-call-history',
        component: myForeignCallHistory
    }, {
        path: '/list-field-config',
        component: listFieldConfig
    }, {
        path: '/list-field-config/select-custom-field',
        component: selectCustomField
    }, {
        path: '/list-field-config/edit-custom-field',
        component: editCustomField
    }, {
        path: '/activity/detail',
        component: activityDetail
    }, {
        path: '/control/import-foreign-call-list/import-foreign-call-list',
        component: importForeignCallList
    }, {
        path: '/control/import-foreign-call-list/import-list-success',
        component: importListSuccess
    }, {
        path: '/control/import-foreign-call-list/assign-list',
        component: assignList
    }, {
        path: '/control/import-foreign-call-list/assign-list-over',
        component: assignListOver
    }, {
        path: '/activity-statistics',
        component: activityStatistics
    }, {
        path: '/my-activity/detail',
        component: myActivityDetail
    }, {
        path: '/my-activity',
        component: myActivity
    }
];

//配置路由
export default new Router({
    mode : 'hash',
    routes
})