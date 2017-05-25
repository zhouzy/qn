import axios from 'axios';
import * as types from '../mutation-types';

/***
 * @desc 活动管理模块
 * @author Maaser
 * @codeDate 2017.3.6
 */

// 初始化state
const state = {
    // 活动详情
    activityDetails: {},
    // 包含名单分配信息的执行者列表
    executorList: [],
    // 复选框选中/当前新建的活动id
    checkSelect : "",
    // 活动管理页面查询的活动列表缓存
    activities : []
};

// store的计算属性
const getters = {
    // 活动ID
    activityId: function (state) {
        return state.checkSelect || '';
    }
};

// mutations
const mutations = {
    // 保存选择操作的活动ID
    [types.ACTIVITY_SELECT]: (state, checkSelect) => {
        state.checkSelect = checkSelect;
    },
    // 保存查询到的活动列表
    [types.ACTIVITY_SAVE]: (state, activities) => {
        state.activities = activities;
    },
    // 设置活动详情
    [types.SET_ACTIVITY_DETAILS]: (state, {activityDetails}) => {
        state.activityDetails = activityDetails;
    },
    // 覆盖执行者名单列表
    [types.COVER_EXECUTOR_LIST]: (state, {executorList}) => {
        state.executorList = executorList;
    }
};

// actions
const actions = {
    // 获取活动详情
    getActivityDetails: function({commit}, activityId) {
        return axios.get('/teleActivity/findActivityDetail', {
            params: {
                teleActivityId: activityId
            }
        }).then(res => {
            let data = res.data;
            if(!data.success) {
                notice.danger(data.msg);
                return;
            }

            let activityDetails = data.rows || {};

            // 设置活动详情
            commit(types.SET_ACTIVITY_DETAILS, {
                activityDetails
            });

            return activityDetails;
        });
    }
    // queryHistory: function ({commit}, url, urlParam) {
    //     axios.post(url, urlParam).then(res => {
    //         commit(types.ACTIVITY_SAVE, res.data.rows);
    //     })
    // }
};

export default {
    state,
    getters,
    actions,
    mutations
}