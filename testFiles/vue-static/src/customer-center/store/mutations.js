import Vue from 'vue'
import * as types from './mutation-types'

export default {
    // 设置用户头像地址
    [types.SET_USER_PHOTO]: (state, url) => {
        state.userPhoneUrl = url;
    },
    // 设置用户名
    [types.SET_USER_NAME]: (state, userName) => {
        state.userName = userName;
    }
}