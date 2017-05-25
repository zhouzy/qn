<template>
    <div class="contact-history-phone__root">
        <div class="row" style="font-size: 15px;">
            <div class="col-sm-3">
                <i class="fa fa-phone contact-history-phone__type-icon"></i>
                {{contactInfo.createTime}}
            </div>
            <div class="col-sm-7">
                <p v-show="!isOpen">{{content || '此次联络暂无沟通小结'}}</p>
            </div>
            <div class="col-sm-2">
                <i :class="[isOpen ? 'fa-chevron-circle-up' : 'fa-chevron-circle-down']" class="fa contact-history-phone__toggle-icon" @click="toggleDetailBox"></i>
            </div>
        </div>
        <div class="row">
            <transition name="contact-history-phone__toggle">
                <div class="col-sm-10" v-show="isOpen">
                    <div class="row contact-history-phone__detail-box">
                        <div class="col-sm-10">
                            <textarea v-model="content"
                                      placeholder="请输入沟通小结···"
                                      rows="3"
                                      :readonly="isReadonly"
                                      class="contact-history-phone__content-textarea">
                            </textarea>
                        </div>
                        <div class="col-sm-2">
                            <button class="btn btn-xs btn-raised btn-primary" v-if="!isReadonly" @click="saveContent">保存</button>
                        </div>
                        <div class="col-sm-4 contact-history-phone__info-box">
                            <label class="contact-history-phone__label">归属：</label>
                            <span class="contact-history-phone__static-text">{{contactInfo.commType != null ? CONTACT_TYPE_MAP[contactInfo.commType] : '客户'}}</span>
                        </div>
                        <div class="col-sm-4 contact-history-phone__info-box" v-if="contactInfo.activityName != null">
                            <label class="contact-history-phone__label">活动名称：</label>
                            <span class="contact-history-phone__static-text">{{contactInfo.activityName}}</span>
                        </div>
                        <div class="col-sm-4 contact-history-phone__info-box">
                            <label class="contact-history-phone__label">呼叫类型：</label>
                            <span class="contact-history-phone__static-text">{{CONTACT_SOURCE_MAP[contactInfo.source]}}</span>
                        </div>
                        <div class="col-sm-4 contact-history-phone__info-box">
                            <label class="contact-history-phone__label">主叫：</label>
                            <span class="contact-history-phone__static-text">{{callerNum}}</span>
                        </div>
                        <div class="col-sm-4 contact-history-phone__info-box">
                            <label class="contact-history-phone__label">被叫：</label>
                            <span class="contact-history-phone__static-text">{{calledNum}}</span>
                        </div>
                        <div class="col-sm-4 contact-history-phone__info-box">
                            <label class="contact-history-phone__label">呼叫时间：</label>
                            <span class="contact-history-phone__static-text">{{contactInfo.createTime}}</span>
                        </div>
                        <div class="col-sm-4 contact-history-phone__info-box">
                            <label class="contact-history-phone__label">接机时间：</label>
                            <span class="contact-history-phone__static-text">{{contactInfo.startTime}}</span>
                        </div>
                        <div class="col-sm-4 contact-history-phone__info-box">
                            <label class="contact-history-phone__label">处理坐席：</label>
                            <span class="contact-history-phone__static-text">{{contactInfo.opName}}</span>
                        </div>
                        <div class="col-sm-4 contact-history-phone__info-box">
                            <label class="contact-history-phone__label">通话时长：</label>
                            <span class="contact-history-phone__static-text">{{contactInfo.commTime}}s</span>
                        </div>
                        <div class="col-sm-4 contact-history-phone__info-box">
                            <label class="contact-history-phone__label">是否接听：</label>
                            <span class="contact-history-phone__static-text">{{contactInfo.isConnected}}</span>
                        </div>
                        <div class="col-sm-12 contact-history-phone__info-box">
                            <label class="contact-history-phone__label">通话录音：</label>
                            <template v-if="audioSrcList.length > 0">
                                <div class="contact-history-phone__audio-box" v-for="src in audioSrcList" v-if="/.(mp3|wav)$/i.test(src)">
                                    <iframe scrolling="no" width="100%" height="100%" :src="contextPath + '/communicate/playAudio?audioSrc=' + src" seamless frameborder="0"></iframe>
                                </div>
                            </template>
                            <template v-else>
                                <span class="contact-history-phone__static-text">暂无录音</span>
                            </template>
                        </div>

                        <!--loading遮罩层-->
                        <block-loading loading-desc="保存中···" ref="blockLoading"></block-loading>
                    </div>
                </div>
            </transition>
        </div>
    </div>
</template>
<script type="text/ecmascript-6">
    // loading遮罩层组件
    import BlockLoading from '@/lib-components/block-loading.vue';
    import querystring from 'querystring';

    /**
     * @desc 联络历史phone组件
     * @author Lesty
     * @code-date 2017.4.27
     **/
    export default {
        name: 'ContactHistoryPhone',
    	props : {
            // 联络历史信息
            contactInfo: {
                type: Object,
                default: function() {
                    return {};
                }
            },
            // 是否只读
            isReadonly: {
                type: Boolean,
                default: false
            }
        },
        created: function () {
        },
        data : function () {
            return {
                // 上下文路径
                contextPath: USER_G.contextPath,
                // 联络历史ID
                contactId: this.contactInfo.commId,
                // 沟通小结
                content: this.contactInfo.content,
                // 主叫号码
                callerNum: '',
                // 被叫号码
                calledNum: '',
                // 切换按钮是否打开
                isOpen: false,
                // 录音列表
                audioSrcList: [],
                // 联络渠道对照表
                CONTACT_SOURCE_MAP: window.ACT_CONFIG.CONTACT_SOURCE_MAP,
                // 联络历史归属类型对照表
                CONTACT_TYPE_MAP: window.ACT_CONFIG.CONTACT_TYPE_MAP
            }
        },
        computed: {
            // 沟通小结(中间变量)
            infoContent: function() {
                return this.contactInfo.content;
            },
            // 呼叫类型(中间变量)
            infoCallType: function () {
                return this.contactInfo.callType;
            }
        },
        watch: {
            // 沟通小结(中间变量)
            infoContent: function (newVal) {
                this.content = newVal;
            },
            // 呼叫类型(中间变量)
            infoCallType: {
                handler: function(newVal) {
                    let contactInfo = this.contactInfo;

                    // 判断主叫和被叫号码是否需要加密
                    if(newVal === 'CallTypeOutbound') { // 外呼
                        this.callerNum = contactInfo.strAni;
                        this.calledNum = contactInfo.protectNum;
                    } else { // 呼入
                        this.callerNum = contactInfo.protectNum;
                        this.calledNum = contactInfo.strDnis;
                    }
                },
                immediate: true
            }
        },
        methods: {
            // 切换详情信息box
            toggleDetailBox: function () {
                if(this.isOpen === false && this.audioSrcList.length === 0) { // 关闭 => 打开，且没有录音时
                    // 获取录音列表
                    this.getRecordList();
                }

                this.isOpen = !this.isOpen;
            },
            // 获取录音列表
            getRecordList: function() {
                this.axios.get('/communicate/getRecordUrl', {
                    params: {
                        sessionId: this.contactInfo.sessionId,
                        ccodEntId: this.contactInfo.ccodEntId,
                        ccodAgentId: this.contactInfo.ccodAgentId
                    }
                }).then(res => {
                    let data = res.data;

                    if(!data.success) {
                        return;
                    }

                    this.audioSrcList = data.rows || [];
                }).catch(error => {
                    notice.danger(error.message);
                });
            },
            // 保存沟通小结
            saveContent: function() {
                // 显示loading
                this.$refs.blockLoading.$emit('load-show');
                this.axios.post('/communicate/saveContent', querystring.stringify({
                    commId: this.contactId,
                    content: this.content
                })).then(res => {
                    let data = res.data;
                    if(!data.success) {
                        return Promise.reject(new Error(data.msg));
                    }

                    notice.success('保存沟通小结成功！');
                }).catch(error => {
                    notice.danger(error.message);
                }).finally(() => {
                    // 隐藏loading
                    this.$refs.blockLoading.$emit('load-hide');
                });

            }
        },
        components: {BlockLoading}
    }
</script>

<style scoped>
    .contact-history-phone__root {
        margin-bottom: 30px;
    }

    .contact-history-phone__type-icon {
        font-size: 26px;
        color: #999;
        margin-right: 20px;
    }

    .contact-history-phone__toggle-icon {
        font-size: 20px;
        color: #65C593;

        cursor: pointer;
    }

    .contact-history-phone__toggle-icon:hover {
        color: #009688;
    }

    .contact-history-phone__detail-box {
        position: relative;
        padding-left: 26px;
        margin-top: 15px;
    }

    .contact-history-phone__content-textarea {
        width: 100%;
        padding: 10px;
        border: 1px solid #ccc;
        border-radius: 5px;
        resize: both;
    }

    .contact-history-phone__content-textarea:hover {
        border-color: #999;
    }

    .contact-history-phone__content-textarea:focus {
        border-color: #777;
    }

    .contact-history-phone__info-box {
        margin-bottom: 10px;
    }

    .contact-history-phone__label {
        font-size: 12px;
        color: #999;
    }

    .contact-history-phone__static-text {
        font-size: 13px;
        color: #000;
    }

    .contact-history-phone__audio-box {
        height: 50px;
        margin-bottom: 10px;
    }

    .contact-history-phone__toggle-enter-active {
        transition: opacity .5s ease;
    }

    .contact-history-phone__toggle-leave-active {
        transition: opacity .2s ease;
    }

    .contact-history-phone__toggle-enter, .contact-history-phone__toggle-leave-active {
        opacity: 0;
    }
</style>