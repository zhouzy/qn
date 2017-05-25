// Promise的polyfill
require('es6-promise').polyfill();

import Vue from 'vue'
import Vuex from 'vuex'
import * as actions from './actions'
import mutations from './mutations'

/***
 * @desc vuex实例
 * @author Lesty
 * @codeDate 2017.5.17
 */

Vue.use(Vuex);

const state = {
    // 用户头像地址
    userPhoneUrl: '',
    // 用户名
    userName: ''
};

export default new Vuex.Store({
  state,
  actions,
  mutations
})
