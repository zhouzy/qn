/**
 * 坐席数据
 * select2Data 用于select2插件使用
 */
import axios from 'axios';
import * as types from '../mutation-types';
export default {
	state : {
		agentGroups : []
	},
	getters : {
		select2Data : state => {
			let select2Data = [{text:'全部',id:'-1'}];
			_.each(state.agentGroups,function(item){
				select2Data.push({
					text : item.groupName,
					children : _.map(item.members,function(op){
						return {
							id : op.userId,
							text : op.userName
						}
					})
				});
			});
			return select2Data;
		}
	},
	actions : {
		fetchAgentList ({commit}){
			return axios.post(location.origin + '/groupMongo/getAgentGroups').then((resp)=>{
				if(resp.data.success){
					commit(types.SET_AGENT_LIST,resp.data.rows);
				}
			});
		}
	},
	mutations:{
		[types.SET_AGENT_LIST] (state,list){
			state.agentGroups = list;
		}
	}
}
