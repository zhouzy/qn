<template>
    <div class="panel name-list-info__root">
        <div class="panel-heading list-detail__panel-heading">
            <strong>名单资料</strong>
            <!--操作区域-->
            <div class="navbar-right name-list-info__btn-margin__reset">
                <button type="button" class="btn btn-xs btn-raised name-list-info__btn-margin-vertical__reset" @click="cancelEdit" v-show="isEdit">
                    <i class="fa fa-times"></i>取消
                </button>
                <button type="button"
                        class="btn btn-xs btn-raised btn-info name-list-info__btn-margin-vertical__reset"
                        :disabled="activityId === ''"
                        @click="togglePanel">
                    <i :class="['fa', isEdit ? 'fa-save': 'fa-edit']"></i>
                    {{isEdit ? '保存' : '编辑'}}
                </button>
                <button type="button"
                        class="btn btn-xs btn-raised btn-primary name-list-info__btn-margin-vertical__reset"
                        v-if="entry === 'myActivity'"
                        :disabled="!hasNextNameList"
                        @click="toNextList">
                    <i class="fa fa-arrow-circle-o-right"></i>{{isLastNameList ? '暂无下一名单' : '下一名单'}}
                </button>
<!--                <div class="dropdown" style="display: inline-block;">
                    <button id="dropOperating" class="btn btn-xs btn-raised dropdown-toggle name-list-info__btn-margin-vertical__reset" data-toggle="dropdown">
                        更多
                        <span class="caret"></span>
                    </button>
                    <ul class="dropdown-menu" role="menu" aria-labelledby="dropOperating">
                        <li>
                            <a>补录沟通小结</a>
                        </li>
                        <li>
                            <a class="red">删除客户</a>
                        </li>
                    </ul>
                </div>-->
            </div>
        </div>
        <!-- 名单字段 -->
        <div class="panel-body">
            <!--主要信息-->
            <div class="row" v-show="!isEdit">
                <div class="col-sm-3">
                    <div class="name-list-info__user-profile-box" @click="">
                        <img src="/static/images/avater/profile_small.jpg" alt="头像" title="头像" class="name-list-info__user-profile">
<!--                        <form><input type="file" name="user_photo" class="name-list-info__user-profile-input"></form>
                        <div class="name-list-info__change-profile-bg">
                            <i class="fa fa-camera name-list-info__camera" aria-hidden="true"></i>
                        </div>-->
                    </div>
                    <h4 class="name-list-info__major-info-box">姓名：{{originFieldsMap.userName}}</h4>
                </div>

                <div class="col-sm-3">
                    <div class="dropdown">
                        <h4 class="name-list-info__major-info-box">名单状态：</h4>
                        <strong class="name-list-info__status-btn green">{{originFieldsMap.status || '-'}}</strong>
<!--                        <strong id="dropStatus" class="name-list-info__status-btn green" data-toggle="dropdown">正常</strong>

                        <ul class="dropdown-menu" aria-labelledby="dropStatus">
                            <li><a>状态：<span class="name-list-info__status-btn blue">未审核</span></a></li>
                            <li><a>状态：<span class="name-list-info__status-btn red">停用</span></a></li>
                        </ul>-->
                    </div>
                </div>

                <div class="col-sm-3">
                    <h4 class="name-list-info__major-info-box">是否已进行客户关联：</h4>
                    <strong class="name-list-info__status-btn" :class="[hasRelatedCustomer ? 'green' : 'red']">{{hasRelatedCustomer ? '是' : '否'}}</strong>
                </div>
            </div>

            <!--展示面板-->
            <div class="form-horizontal" v-show="!isEdit">
                <!--基本字段-->
                <div class="row">
                    <!--生成静态字段信息-->
                    <template v-for="field in baseFieldsList" v-if="field.key !== 'userName'">
                        <field-static :label="field.name + ':'"
                                      :name="field.key"
                                      :value="originFieldsMap[field.key]"
                                      :operable="callOperable"
                                      :reserve-id="reserveId"
                                      :type="FIELD_TYPE_MAP[field.componentType].desc">
                        </field-static>
                    </template>
                </div>

                <!--更多字段-->
                <div class="row collapse" id="moreFieldsList">
                    <!--生成静态字段信息-->
                    <template v-for="field in moreFieldsList"  v-if="field.key !== 'userName'">
                        <field-static :label="field.name + ':'"
                                      :name="field.key"
                                      :value="originFieldsMap[field.key]"
                                      :operable="callOperable"
                                      :type="FIELD_TYPE_MAP[field.componentType].desc">
                        </field-static>
                    </template>
                </div>

                <!--展开/收起按钮-->
                <div class="row name-list-info__toggle-box" v-if="moreFieldsList.length > 0">
                    <div class="col-sm-12">
                        <button class="btn btn-xs btn-block btn-info"
                                type="button"
                                data-toggle="collapse"
                                data-target="#moreFieldsList"
                                :aria-expanded="isOpen"
                                @click.prevent="toggleOpenStatus">{{isOpen ? '收起' : '展开'}}
                        </button>
                    </div>
                </div>
            </div>

            <!--编辑面板-->
            <div class="form-horizontal" v-show="isEdit">
                <div class="row">
                    <template v-for="field in listFieldsList">
                        <edit-panel-field :fields-map="originFieldsMap"
                                          :type="FIELD_TYPE_MAP[field.componentType].desc"
                                          :user-type="userType"
                                          width="3"
                                          :label="field.name"
                                          :options="field.candidateValue"
                                          :pattern="FIELD_TYPE_MAP[field.componentType].pattern"
                                          :value="originFieldsMap[field.key]"
                                          :name="field.key"
                                          :isRequired="field.isRequired">
                        </edit-panel-field>
                    </template>
                </div>
            </div>
        </div>

        <!--loading遮罩层-->
        <block-loading loading-desc="正在保存资料···" ref="blockLoading"></block-loading>
    </div>
</template>

<script type="text/ecmascript-6">
    // 静态字段信息组件
    import FieldStatic from './list-fields/field-static.vue';
    // 编辑面板字段组件
    import EditPanelField from './edit-panel-field.vue';
    // loading遮罩层组件
    import BlockLoading from '@/lib-components/block-loading.vue';
    import queryString from 'queryString';

    /**
     * @desc 名单资料组件
     * @author Lesty
     * @code-date 2017.3.24
     **/
    export default {
        name: 'NameListInfo',
        props: {
            // 名单ID
            namesId: {
                required: true
            },
            // 联络历史ID
            contactHistoryId: {
                default: ''
            },
            // 预约回呼id
            reserveId: {
                default: ''
            },
            // 名单详情入口
            entry: {
                default: ''
            },
            // 用户类别
            userType: {
                type: String,
                default: '2' // 默认是坐席
            }
        },
        created: function () {
            this.regEvent();

            // 并发获取名单字段列表和对应数据
            this.refreshListFieldsData(this.namesId).then(() => {
                // 获取下一个名单字段信息
                this.getNextNameList(this.namesId, this.serviceId, this.activityId).then(res => {
                    let data = res.data;
                    if(!data.success) {
                        return Promise.reject(new Error(data.msg));
                    }

                    if(data.rows != null) {
                        this.nextNamesId = data.rows.namesId;
                    } else { // 已是最后一个名单
                        this.nextNamesId = '';
                        this.isLastNameList = true;
                    }
                }).catch(error => {
                    notice.danger(error.message);
                });

                // 获取归属人列表
                this.getExecutorList(this.activityId).then((res) => {
                    let data = res.data;
                    if(!data.success) {
                        return Promise.reject(new Error(data.msg));
                    }

                    // 获取归属人列表
                    this.serviceList = data.rows.map((item) => {
                        return {
                            name: item.userName,
                            value: item.userId
                        };
                    });

                    // 获取归属组列表
                    this.serviceGroupList = data.rows.map((item) => {
                        return {
                            name: item.groupName,
                            value: item.groupId
                        };
                    });
                }).catch(error => {
                    notice.danger(error.message);
                });
            }).catch(error => {
                notice.danger(error.message);
            });
        },
        data: function() {
            return {
                // 下一个名单ID
                nextNamesId: '',
                // 归属人ID
                serviceId: '',
                // 活动ID
                activityId: '',
                // 客户id
                customId: '',
                // 是否处于编辑状态
                isEdit: false,
                // 展示面板是否展开
                isOpen: false,
                // 用于展示的基础字段数量
                BASE_FIELD_AMOUNT: 8,
                // 字段类型map
                FIELD_TYPE_MAP: window.ACT_CONFIG.FIELD_TYPE_MAP,
                // 名单字段列表
                listFieldsList: [],
                // 归属组列表
                serviceGroupList: [],
                // 归属人列表
                serviceList: [],
                // 需要手动进行值替换的字段列表
                needChangeFieldsList: ['status', 'result', 'isConnect', 'latestCntTime'],
                // 所有名单字段组件
                fieldComponents: [],
                // 是否是最后一个名单
                isLastNameList: false,
                // 编辑时不合法的字段名称
                illegalLabel: ''
            };
        },
        computed: {
            // 是否可以执行打电话等操作
            callOperable: function() {
                return USER_G.userId === this.serviceId;
            },
            // 原始的字段数据(key-value)
            originFieldsMap: function () {
                return this.$store.state.originFieldsMap;
            },
            // 基础字段列表
            baseFieldsList: function() {
                let len = this.listFieldsList.length;

                if(this.BASE_FIELD_AMOUNT < len) {
                    let result = [];
                    let tempInfo = null;
                    let count = 0;

                    for(let i = 0; count < this.BASE_FIELD_AMOUNT; i++) {
                        tempInfo = this.listFieldsList[i];

                        result.push(tempInfo);
                        // 已在主要信息中展示的字段不在展示面板中显示
                        if(tempInfo.key !== 'userName') {
                            count++;
                        }
                    }

                    return result;
                } else {
                    return this.listFieldsList;
                }
            },
            // 更多字段列表
            moreFieldsList: function() {
                return this.listFieldsList.slice(this.baseFieldsList.length, this.listFieldsList.length);
            },
            // 是否有下一名单
            hasNextNameList: function () {
                return this.nextNamesId !== '';
            },
            // 是否关联客户
            hasRelatedCustomer: function () {
                return this.originFieldsMap.relatedCustom === true;
            }
        },
        methods: {
            // 刷新名单字段相关数据
            refreshListFieldsData: function (namesId) {
                // 并发获取名单字段列表和对应数据
                return this.axios.all([this.getOriginFieldsMap(namesId), this.getListFieldsList()]).then(this.axios.spread((fieldsMapRes, fieldsListRes) => {
                    let fieldsMapData = fieldsMapRes.data;
                    let fieldsListData = fieldsListRes.data;

                    if(!fieldsMapData.success) {
                        return Promise.reject(new Error(fieldsMapData.msg));
                    } else if(!fieldsListData.success) {
                        return Promise.reject(new Error(fieldsListData.msg));
                    }

                    // 初始化原始字段值
                    this.initOriginFieldsMap(fieldsMapData.rows || {});
                    // 设置最初的字段数据
                    this.setInitFieldsMap('result', fieldsMapData.rows.result || '0');
                    // 设置归属人ID
                    this.serviceId = this.originFieldsMap.serviceId;
                    // 设置活动id
                    this.activityId = this.originFieldsMap.teleActivityId;
                    // 设置客户id
                    this.customId = this.originFieldsMap.customId;

                    // 修改原始字段值
                    this.changeOriginFieldsValue();

                    if(Array.isArray(fieldsListData.rows)) {
                        // 移除不在下方显示的字段
                        this.listFieldsList = fieldsListData.rows.filter((item) => {
                            return item.key !== 'status';
                        });
                    }
                }));
            },
            // 获取原始的字段数据
            getOriginFieldsMap: function (namesId) {
                return this.$store.dispatch('getOriginFieldsMap', namesId);
            },
            // 初始化原始的字段数据
            initOriginFieldsMap: function (originMap) {
                this.$store.commit('INIT_ORIGIN_MAP', originMap);
            },
            // 设置原始的字段数据
            setOriginFieldsMap: function (key, value) {
                this.$store.commit('SET_ORIGIN_MAP', {
                    key,
                    value
                });
            },
            // 设置原始的字段数据
            setInitFieldsMap: function (key, value) {
                this.$store.commit('SET_INIT_MAP', {
                    key,
                    value
                });
            },
            // 获取名单字段列表
            getListFieldsList: function () {
                return this.axios.get('/names/getNameListField');
            },
            // 获取归属人列表
            getExecutorList: function (activityId) {
                return this.axios.get('/exeUser/findExeUserList', {
                    params: {
                        teleActivityId: activityId
                    }
                });
            },
            // 获取下一个名单字段信息
            getNextNameList: function (namesId, serviceId, activityId) {
                return this.axios.get('/names/getNextNames', {
                    params: {
                        namesId,
                        serviceId,
                        teleActivityId: activityId
                    }
                });
            },
            // 电话接通调用（更新相关信息）
            updateCallResult: function (namesId, contactHistoryId) {
                return this.axios.post('/teleCommunicate/connectComm', queryString.stringify({
                    namesId,
                    commId: contactHistoryId
                }));
            },
            // 修改原始字段值
            changeOriginFieldsValue: function () {
                this.needChangeFieldsList.forEach((name) => {
                    // 字段value
                    let value = this.originFieldsMap[name];
                    // 最终结果
                    let result = value;

                    if(name === 'status') { // 名单状态
                        result = window.ACT_CONFIG.NAME_LIST_STATUS_MAP[value] || '异常状态';
                    } else if(name === 'result') { // 业务状态
                        result = window.ACT_CONFIG.BUSINESS_STATUS_MAP[value] || '异常结果';
                    } else if(name === 'isConnect') { // 呼叫结果
                        result = window.ACT_CONFIG.IS_CONNECT_MAP[value] || '异常结果';
                    } else if(name === 'latestCntTime') { // 最近联络时间
                        result = value || '无';
                    }

                    this.setOriginFieldsMap(name, result);
                });
            },
            // 跳到下一个名单页面
            toNextList: function () {
                // 移除commId查询字符串
                let searchStr = location.search.replace((/^(commId=([^&]*&)|([^&]*)$)|&(commId=[^&]*)/i), '');
                // 替换namesId
                location.search = searchStr.replace(`namesId=${this.namesId}`, `namesId=${this.nextNamesId}`);
            },
            // 切换展示面板状态
            toggleOpenStatus: function () {
                this.isOpen = !this.isOpen;
            },
            // 切换展示/编辑面板
            togglePanel: function () {
                if(this.isEdit) { // 切换到展示页(保存)
                    // 更新修改过的字段
                    this.updateModifiedFields();
                } else { // 切换到编辑页
                    // 重置表单为初始值
                    this.resetForm();
                    this.isEdit = true;
                }
            },
            // 取消编辑
            cancelEdit: function () {
                this.isEdit = false;

                // 重置表单为初始值
                this.resetForm();
                // 清空已修改的名单字段对象集合
                this.$store.commit('EMPTY_MODIFY_OBJ');
            },
            // 字段值修改
            fieldChange: function (key, value) {
                this.$store.commit('SET_MODIFY_FIELD', {
                    key: key,
                    value: value
                });
            },
            // 更新修改过的字段
            updateModifiedFields: function () {
                // 验证所有字段
                if(!this.validateFields()) {
                    notice.warning(`<${this.illegalLabel}>字段尚未填写完善，请继续完善表单！`);
                    return;
                }

                // 显示loading
                this.$refs.blockLoading.$emit('load-show');
                this.$store.dispatch('updateModifiedFields', {
                    namesId: this.namesId,
                    activityId: this.activityId,
                    customId: this.customId
                }).then(this.refreshListFieldsData).then(() => {
                    this.isEdit = false;
                }).catch(error => {
                    notice.danger(error.message);
                }).finally(() => {
                    // 隐藏loading
                    this.$refs.blockLoading.$emit('load-hide');
                });
            },
            // 验证所有字段
            validateFields: function () {
                let comp = null;
                for(let i = 0, iLen = this.fieldComponents.length; i < iLen; i++) {
                    comp = this.fieldComponents[i];
                    if(!comp.validate()) {
                        this.illegalLabel = comp.label || '';
                        return false;
                    }
                }

                return true;
            },
            // 重置表单为初始值
            resetForm: function() {
                this.fieldComponents.forEach(field => {
                    field.reset();
                });
            },
            // 监听事件
            regEvent: function () {
                // 如果是弹屏页面(联络历史id不为空)
                if(this.contactHistoryId !== '') {
                    // 监听电话接通事件
                    window.addEventListener('message', (event) => {
                        let origin = event.origin || event.originalEvent.origin;
                        if(origin !== location.origin || event.source !== top) {
                            return;
                        }

                        // 电话已接通
                        if(event.data.phoneStatus === 'connected') {
                            // 电话接通调用（更新相关信息）
                            this.updateCallResult(this.namesId, this.contactHistoryId).then(res => {
                                let data = res.data;
                                if(!data.success) {
                                    return Promise.reject(new Error(data.msg));
                                }

                                let rows = data.rows;

                                // 更新展示面板的状态数据
                                if(rows.names != null) {
                                    this.setOriginFieldsMap('isConnect', window.ACT_CONFIG.IS_CONNECT_MAP[rows.names.isConnect] || '异常结果');
                                    //this.setOriginFieldsMap('result', window.ACT_CONFIG.BUSINESS_STATUS_MAP[rows.names.result] || '异常结果');
                                    //this.setInitFieldsMap('result', rows.names.result || '0');
                                }

                                if(rows.history != null) {
                                    // 更新联络历史中的相关状态
                                    let self = this;
                                    this.$store.state.linkHistory.map(function (item) {
                                        if(item.commId === self.contactHistoryId){
                                            item.isConnected = window.ACT_CONFIG.IS_CONNECT_MAP[rows.history.isConnected] || '异常结果';
                                            item.bussinessStatus = window.ACT_CONFIG.BUSINESS_STATUS_MAP[rows.history.bussinessStatus] || '异常结果';
                                        }
                                    })
                                }
                            }).catch(error => {
                                notice.danger(error.message);
                            });
                        }
                    }, false);
                }

                // 字段添加
                this.$on('add-field', (fieldComp) => {
                    if(fieldComp) {
                        this.fieldComponents.push(fieldComp);
                    }
                });

                // 字段移除
                this.$on('remove-field', (fieldComp) => {
                    if (fieldComp) {
                        this.fieldComponents.splice(this.fieldComponents.indexOf(fieldComp), 1);
                    }
                });

                // 字段值改变
                this.$on('field-change', this.fieldChange);
            }
        },
        components: {
            FieldStatic,
            EditPanelField,
            BlockLoading
        }
    }
</script>

<style lang="less" scoped>
    @import "../less/listDetail.less";
    @import "../less/nameListInfo.less";
</style>

<style lang="less">
    @import '../less/editField.less';
</style>