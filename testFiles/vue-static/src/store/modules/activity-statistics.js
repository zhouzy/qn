import * as types from '../mutation-types'
import axios from 'axios'
/**
 * @desc 批次统计模块
 * @author Lesty,wly
 * @code-date 2017.4.22
 **/
// initial state
const state = {
    // 所有活动列表
    allActivityList: [],
    // 活动统计列表
    activityStatisticsList: [],
    // 个人业绩列表
    personalPerformanceList: [],
    // 批次统计列表
    batchStatisticsList: [],
    // 活动统计查询参数
    activityStatisticsQueryFields: {},
    // 个人业绩统计查询参数
    personalPerformanceQueryFields: {},
    // 批次统计查询参数
    batchStatisticsQueryFields: {},

    activityResult: [],
    activityTotal: '',
    batchResult: [],
    batchTotal: '',
    personalPerformanceResult: [],
    personalPerformanceTotal: ''
};

// getters
const getters = {
    // 符合select2插件格式的所有活动列表
    select2AllActList: state => {
        return state.allActivityList.map(item => {
            return {
                text: item.activityName,
                id: item.teleActivityId
            };
        });
    }
};

// actions
const actions = {
    // 获取所有活动列表
    getAllActivityList ({commit}) {
        return axios.get('/teleActivity/listAllTeleActivity').then(res => {
            let data = res.data;
            if(!data.success) {
                return Promise.reject(new Error(data.msg));
            }

            commit('INIT_ALL_ACTIVITY', data.rows || []);
        });
    },
    // 查询活动统计列表
    queryActivityStatisticsList ({commit}, {activityId, startTime, endTime}) {
        return axios.get('/statistics/teleActivitiesStatistics', {
            params: {
                teleActivityId: activityId,
                startTime,
                endTime
            }
        }).then(res => {
            let data = res.data;
            if(!data.success) {
                return Promise.reject(new Error(data.msg));
            }

            let list = data.rows || [];
            // 为列表项增加开始时间和截止时间
            // 初始化活动统计列表
            commit('INIT_ACTIVITY_STATISTICS', list.map(item => {
                item.startTime = startTime !== '' ? cri.formatDate(new Date(startTime), 'yyyy-MM-dd hh:mm:ss') : startTime;
                item.endTime = endTime !== '' ? cri.formatDate(new Date(endTime), 'yyyy-MM-dd hh:mm:ss') : endTime;

                return item;
            }));
        });
    },

    // 查询个人业绩统计列表
    queryPersonalPerformanceList ({commit}, {activityId, serviceId, startTime, endTime}) {
        return axios.get('/statistics/serviceUserStatistics', {
            params: {
                teleActivityId: activityId,
                serviceId,
                startTime,
                endTime
            }
        }).then(res => {
            let data = res.data;
            if(!data.success) {
                return Promise.reject(new Error(data.msg));
            }

            let list = data.rows || [];
            // 为列表项增加开始时间和截止时间
            // 初始化个人业绩统计列表
            commit('INIT_PERSONAL_PERFORMANCE', list.map(item => {
                item.startTime = startTime !== '' ? cri.formatDate(new Date(startTime), 'yyyy-MM-dd hh:mm:ss') : startTime;
                item.endTime = endTime !== '' ? cri.formatDate(new Date(endTime), 'yyyy-MM-dd hh:mm:ss') : endTime;

                return item;
            }));
        });
    },

    // 查询批次统计列表
    queryBatchStatisticsList ({commit}, {activityId, batchId}) {
        return axios.get('/statistics/countActivityByBatch', {
            params: {
                teleActivityId: activityId,
                batchId
            }
        }).then(res => {
            let data = res.data;
            if(!data.success) {
                return Promise.reject(new Error(data.msg));
            }

            // 初始化批次统计列表
            commit('INIT_BATCH_STATISTICS', data.rows || []);
        });
    }
};

// mutations
const mutations = {
    // 初始化所有活动列表
    [types.INIT_ALL_ACTIVITY] (state, list) {
        state.allActivityList = list;
    },
    // 初始化活动统计列表
    [types.INIT_ACTIVITY_STATISTICS] (state, list) {
        state.activityStatisticsList = list;
    },
    // 初始化个人业绩统计列表
    [types.INIT_PERSONAL_PERFORMANCE] (state, list) {
        state.personalPerformanceList = list;
    },
    // 初始化批次统计列表
    [types.INIT_BATCH_STATISTICS] (state, list) {
        state.batchStatisticsList = list;
    },
    // 缓存活动统计查询参数
    [types.CACHE_ACTIVITY_FIELDS] (state, params) {
        state.activityStatisticsQueryFields = params
    },
    // 缓存个人业绩查询参数
    [types.CACHE_PERFORMANCE_FIELDS] (state, params) {
        state.personalPerformanceQueryFields = params
    },
    // 缓存批次统计查询参数
    [types.CACHE_BACH_FIELDS] (state, params) {
        state.batchStatisticsQueryFields = params
    },

    [types.ACTIVITY_RESULT] (state, { activityResult }) {
        state.activityResult = activityResult
    },

    [types.ACTIVITY_TOTAL] (state, { activityTotal }) {
        state.activityTotal = activityTotal
    },

    [types.BATCH_RESULT] (state, { batchResult }) {
        state.batchResult = batchResult
    },

    [types.BATCH_TOTAL] (state, { batchTotal }) {
        state.batchTotal = batchTotal
    },

    [types.PERSONAL_PERFORMANCE_RESULT] (state, { personalPerformanceResult }) {
        state.personalPerformanceResult = personalPerformanceResult
    },

    [types.PERSONAL_PERFORMANCE_TOTAL] (state, { personalPerformanceTotal }) {
        state.personalPerformanceTotal = personalPerformanceTotal
    }
};

export default {
    state,
    getters,
    actions,
    mutations
}
