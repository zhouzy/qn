import * as types from './mutation-types'

/***
 * @desc 根级别的actions
 * @author Lesty
 * @codeDate 2017.3.2
 */

// 测试用，清空外呼历史数据
export const clearHistoryList = ({commit}) => {
    commit(types.REFRESH_HISTORY, {
        historyList: []
    });
};