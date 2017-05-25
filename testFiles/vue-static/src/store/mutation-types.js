/***
 * @desc 所有mutation的名称定义(共用)
 * @author Lesty
 * @codeDate 2017.3.2
 */

/*
* @desc 根级别相关mutation定义
* */
// 设置左侧菜单栏展开状态
export const SET_OPEN_STATUS = 'SET_OPEN_STATUS';

/*
 * @desc 活动管理相关mutation定义
 * */
export const ACTIVITY_SELECT = 'ACTIVITY_SELECT';
export const ACTIVITY_SAVE = 'ACTIVITY_SAVE';
// 设置活动详情
export const SET_ACTIVITY_DETAILS = 'SET_ACTIVITY_DETAILS';
// 覆盖执行者名单列表
export const COVER_EXECUTOR_LIST = 'COVER_EXECUTOR_LIST';

/*
 * @desc 外呼历史相关mutation定义
 * */
// 刷新外呼历史数据
export const REFRESH_HISTORY = 'REFRESH_HISTORY';


/*
 * @desc 名单配置相关mutation定义
 * */

/*
* @desc 活动统计相关 mutation 定义
* */
// 初始化所有活动列表
export const INIT_ALL_ACTIVITY = 'INIT_ALL_ACTIVITY';
// 初始化活动统计列表
export const INIT_ACTIVITY_STATISTICS = 'INIT_ACTIVITY_STATISTICS';
// 初始化个人业绩统计列表
export const INIT_PERSONAL_PERFORMANCE = 'INIT_PERSONAL_PERFORMANCE';
// 初始化批次统计列表
export const INIT_BATCH_STATISTICS = 'INIT_BATCH_STATISTICS';

// 缓存活动统计查询参数
export const CACHE_ACTIVITY_FIELDS = 'CACHE_ACTIVITY_FIELDS';
// 缓存个人业绩查询参数
export const CACHE_PERFORMANCE_FIELDS = 'CACHE_PERFORMANCE_FIELDS';
// 缓存批次统计查询参数
export const CACHE_BACH_FIELDS = 'CACHE_BACH_FIELDS';

export const ACTIVITY_RESULT = 'ACTIVITY_RESULT';
export const ACTIVITY_TOTAL = 'ACTIVITY_TOTAL';
export const BATCH_RESULT = 'BATCH_RESULT';
export const BATCH_TOTAL = 'BATCH_TOTAL';
export const PERSONAL_PERFORMANCE_RESULT = 'PERSONAL_PERFORMANCE_RESULT';
export const PERSONAL_PERFORMANCE_TOTAL = 'PERSONAL_PERFORMANCE_TOTAL';
export const SET_AGENT_LIST = "SET_AGENT_LIST";