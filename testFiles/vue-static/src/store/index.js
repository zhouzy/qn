// Promise的polyfill
require('es6-promise').polyfill();
import Vue from 'vue'
import Vuex from 'vuex'
import * as getters from './getters'
import mutations from './mutations'
import * as actions from './actions'
// 外呼历史模块
import foreignCallHistory from './modules/foreign-call-history'
// 活动管理模块
import allActivity from './modules/all-activity'
// 活动统计模块
import activityStatistics from './modules/activity-statistics'
// 坐席组坐席列表
import agentGroup from './modules/agent-group-tree'

/***
 * @desc vuex实例
 * @author Lesty
 * @codeDate 2017.3.10
 */

// 安装vuex功能
Vue.use(Vuex);

// 配置vuex仓库
export default new Vuex.Store({
    state: {
        options: {},
        // 外呼活动左侧菜单切换按钮是否打开
        leftMenuIsOpen: true
    },
    getters,
    mutations,
    actions,
    modules: {
        foreignCallHistory,
        allActivity: allActivity,
        activityStatistics,
		agentGroup
    }
})