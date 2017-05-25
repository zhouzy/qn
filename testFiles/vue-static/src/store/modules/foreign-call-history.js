import * as types from '../mutation-types';
import axios from 'axios';

/***
 * @desc 外呼历史模块
 * @author Lesty
 * @codeDate 2017.3.2
 */

// 初始化state
const state = {
    // 历史列表
    historyList: []
};

// store的计算属性
const getters = {
    historyList: state => state.historyList
};

// actions(可执行异步操作)
const actions = {
    // 查询历史列表
    query: ({commit}, param) => {
        axios.post(ACT_CONFIG.ORIGIN_URL + '/teleActivity/findAllTeleActivities', this.tools.jsonToUrlparam(param))
            .then(response => {
                let data = response.data;
                if (!data.success) {
                    notice.danger(data.msg);
                }

                const historyList = data.rows;
                // 刷新历史列表
                commit(types.REFRESH_HISTORY, {
                    historyList
                });
            })
            .catch(error => {
                notice.danger(error.config);
            });
    }
};

// mutations(类似于事件)
const mutations = {
    // 刷新历史列表
    [types.REFRESH_HISTORY]: (state, {historyList}) => {
        state.historyList = historyList;
    }
};

export default {
  state,
  getters,
  actions,
  mutations
}
