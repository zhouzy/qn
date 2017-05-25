// Promise的polyfill
require('es6-promise').polyfill();

import Vue from 'vue'
import Vuex from 'vuex'
import * as actions from './actions'
import mutations from './mutations'

/***
 * @desc vuex实例
 * @author Lesty
 * @codeDate 2017.3.16
 */

Vue.use(Vuex);

const state = {
    // 联络历史表单数据
    linkHistory: [],
    // 预约信息列表
    reserveList: [],
    // 预约信息列表pager组件
    reservePager: null,
    // 修改的字段对象
    modifyFieldsObj: {},
    // 最初的字段数据(后台发过来的数据，前端没进行过值改变)
    initFieldsMap: {},
    // 原始的字段数据(key-value)
    originFieldsMap: {}
};

export default new Vuex.Store({
  state,
  actions,
  mutations
})
