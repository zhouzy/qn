/**
 * @desc 相关配置项以及常量
 * @author Lesty
 * @codeDate 2017.3.2
 **/

// 基础url地址
const ORIGIN_URL = location.origin;

// 工单状态对照表
const ORDER_STATUS_MAP = {
    '-1': {
        text: '全部',
        type: '',
        color: ''
    },
    '0': {
        text: '尚未受理',
        type: 'danger',
        color: ''
    },
    '1': {
        text: '受理中',
        type: 'warning',
        color: ''
    },
    '2': {
        text: '等待回复',
        type: 'primary',
        color: ''
    },
    '3': {
        text: '已解决',
        type: 'success',
        color: ''
    },
    '4': {
        text: '已关闭',
        type: 'gray',
        color: ''
    },
    '5': {
        text: '其它',
        type: '',
        color: ''
    },
    '6': {
        text: '待回访',
        type: 'gray',
        color: 'rgba(186, 216, 22, 0.4)'
    }
};

// 沟通结果
const CONNECT_RESULT_ENUM = {
	"1" : "呼通",
	"0" : "未呼通"
};

// 字段类型对照表
const FIELD_TYPE_MAP = {
	"1" : {name: '文本框',  desc: 'text', pattern: ''}, // 文本框
	"2" : {name: '文本区域',desc: 'textArea', pattern: ''}, // 文本区域
	"3" : {name: '下拉菜单',desc: 'select', pattern: ''}, // 下拉菜单
	"4" : {name: '复选框',  desc: 'checkbox', pattern: ''}, // 复选框
	"5" : {name: '单选框',  desc: 'radio', pattern: ''}, // 单选框
	"6" : {name: '数字',    desc: 'number', pattern: '^-?\\d+$'}, // 数字
	"7" : {name: '小数',    desc: 'float', pattern: '^-?\\d+\\.\\d+$'}, // 小数
	"8" : {name: '正则匹配字段', desc: 'regexp', pattern: ''}, // 正则匹配字段
	"9" : {name: '电话号',  desc: 'telephone', pattern: '^\\d{7,8}$|^\\d{11,13}$'}, // 电话号
	"10": {name: '时间输入框', desc: 'datetime', pattern: ''}, // 时间输入框
	"11": {name: '省市区',  desc: 'pca', pattern: ''} // 省市区
};

// 名单状态对照表
const NAME_LIST_STATUS_MAP = {
    '1': '待分配',
    '5': '已分配',
    '6': '已呼叫'
};

// 业务状态对照表
const BUSINESS_STATUS_MAP = {
    '0': '未联系到',
    '1': '跟进',
    '2': '预约回呼',
    '5': '成单',
    '7': '已购买',
    '8': '无效名单',
    '9': '拒绝'
};

// 是否呼通状态对照表
const IS_CONNECT_MAP = {
    '99': '未呼叫',
    '1': '已呼通',
    '0': '未呼通'
};

// 预约状态对照表
const RESERVATION_STATUS_MAP = {
	"0" : "未完成",
	"1" : "已完成"
};

// 联络历史归属类型对照表
const CONTACT_TYPE_MAP = {
    '0': '名单',
    '1': '客户'
};

// 联络渠道对照表
const CONTACT_SOURCE_MAP = {
    '0' : '网页表单',
    '1' : 'IM',
    '2' : 'API接口',
    '3' : '邮件',
    '4' : '手机端',
    '5' : '电话呼入',
    '6' : '电话呼出',
    '7' : '微信',
    '8' : '视频',
    '9' : '电话留言',
    '10': '漏话',
    '11': '发送短信'
};

export default {
    ORDER_STATUS_MAP,
	CONNECT_RESULT_ENUM,
	FIELD_TYPE_MAP,
    NAME_LIST_STATUS_MAP,
    BUSINESS_STATUS_MAP,
    IS_CONNECT_MAP,
    ORIGIN_URL,
	RESERVATION_STATUS_MAP,
    CONTACT_TYPE_MAP,
    CONTACT_SOURCE_MAP
}