import * as types from './mutation-types'

/***
 * @desc 根级别的mutations
 * @author Lesty
 * @codeDate 2017.3.2
 */

export default {
    // 设置左侧菜单栏展开状态
    [types.SET_OPEN_STATUS]: (state, status) => {
        state.leftMenuIsOpen = status;
    }
};
