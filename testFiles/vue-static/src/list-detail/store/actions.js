import * as types from './mutation-types';
import axios from 'axios';
import querystring from 'querystring';

// 更新修改过的名单字段
export const updateModifiedFields = ({state, commit}, {namesId, activityId, customId}) => {
    // 判断值为空就不发送
    if(Tools.isEmptyObj(state.modifyFieldsObj)) {
        return Promise.reject(null);
    }

    return axios.post('/names/updateNamesDetail', querystring.stringify({
        info: JSON.stringify(state.modifyFieldsObj),
        teleActivityId: activityId,
        namesId,
        customId
    })).then(res => {
        let data = res.data;
        if(!data.success) {
            return Promise.reject(new Error(data.msg));
        }

        // 清空已修改的名单字段对象集合
        commit(types.EMPTY_MODIFY_OBJ);

        return namesId;
    });
};

// 获取原始的字段数据
export const getOriginFieldsMap = ({state}, namesId) => {
    return axios.get('/names/getNamesDetail', {
        params: {
            namesId
        }
    });
};

// 获取预约信息列表
export const getReserveList = ({commit}, {param, page, pageSize}) => {
    return axios.get('/appointment/queryNamesAppointment', {
        params: {
            customId: param.customId,
            page,
            rows: pageSize
        }
    }).then(res => {
        let data = res.data;
        if(!data.success) {
            return Promise.reject(new Error(data.msg));
        }

        // 初始化预约信息列表
        commit('INIT_RESERVE_LIST', data.rows || []);
        // 更新预约信息列表pager组件
        commit('UPDATE_RESERVE_PAGER', {
            page,
            pageSize,
            total: data.total
        });
    });
};