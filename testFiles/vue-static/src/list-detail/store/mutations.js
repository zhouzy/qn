import Vue from 'vue'
import * as types from './mutation-types'

export default {
    // 设置已修改的名单字段对象集合
    [types.SET_MODIFY_FIELD]: (state, {key, value}) => {
        state.modifyFieldsObj[key] = value;
    },
    // 清空已修改的名单字段对象集合
    [types.EMPTY_MODIFY_OBJ]: (state) => {
        state.modifyFieldsObj = {};
    },
    // 初始化原始的字段数据
    [types.INIT_ORIGIN_MAP]: (state, originMap) => {
        state.initFieldsMap = _.clone(originMap);
        state.originFieldsMap = originMap;
    },
    // 设置原始的字段数据
    [types.SET_ORIGIN_MAP]: (state, {key, value}) => {
        state.originFieldsMap[key] = value;
    },
    // 设置最初的字段数据
    [types.SET_INIT_MAP]: (state, {key, value}) => {
        state.initFieldsMap[key] = value;
    },
    // 初始化联络历史列表
    [types.INIT_CONTACT_HISTORY_LIST]: (state, list) => {
        state.linkHistory = list;
    },
    // 初始化预约信息列表
    [types.INIT_RESERVE_LIST]: (state, list) => {
        state.reserveList = list;
    },
    // 初始化预约信息列表pager组件
    [types.INIT_RESERVE_PAGER]: (state, pager) => {
        state.reservePager = pager;
    },
    // 更新预约信息列表pager组件
    [types.UPDATE_RESERVE_PAGER]: (state, {page, pageSize, total}) => {
        state.reservePager.update(page, pageSize, total);
    }
}