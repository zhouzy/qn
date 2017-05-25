<template>
    <div class="col-sm-3 field-static__field-box">
        <div class="form-group">
            <label class="col-sm-4 control-label">{{label}}</label>

            <div class="col-sm-8">
                <p class="form-control-static field-static__field-desc">
                    {{finalValue}}
                    <!--类型为电话，或者name为telPhone的，增加操作按钮-->
                    <span v-if="operable === true && (type === 'telephone' || name === 'telPhone' || name === 'fixedPhone') && value != ''">
                        <a href="" @click.prevent="callOut(teleNum)" class="field-static__operate-btn">
                            <i class="fa fa-phone"></i>
                        </a>
                        <a data-type="show" @click.prevent="sendNoteWin($event)" data-toggle="modal" data-target="#sendNoteModal" class="field-static__operate-btn">
                            <i class="fa fa-envelope"></i>
                        </a>
                    </span>
                </p>
            </div>
        </div>
    </div>
</template>

<script type="text/ecmascript-6">
    /**
     * @desc 静态字段信息组件
     * @author Lesty
     * @code-date 2017.3.18
     **/
    export default {
        props: {
            // 字段名称
            label: {
                type: String,
                required: true
            },
            // 字段唯一标识
            name: {
                required: true
            },
            // 字段值
            value: {
                default: ''
            },
            // 预约回呼id
            reserveId: {
                default: ''
            },
            // 是否可以执行打电话等操作
            operable: {
                default: false
            },
            // 字段类型
            type: {
                type: String,
                required: true
            }
        },
        created: function () {

        },
        data: function() {
            return {
                // 替换对照表
                ID_TO_NAME_MAP: {
                    serviceId: 'serviceName', // 归属人
                    telPhone: 'protectNum', // 电话号码
                    fixedPhone: 'protectFixed', // 座机
                    email: 'protectEmail', // 邮箱
                    serviceGroupId: 'serviceGroupName' // 归属组
                }
            };
        },
        computed: {
            // 最终结果
            finalValue: function () {
                let name = this.ID_TO_NAME_MAP[this.name];
                let result = this.value;

                if(name != null) {
                    result = this.$parent.originFieldsMap[name];
                }

                return Array.isArray(result) ? result.join(',') : result;
            },
            // 外呼时的电话号码
            teleNum: function() {
                return this.value;
            }
        },
        methods: {
            // 检测电话格式是否合法
            checkPhone: function (telPhone) {
                let errorMsg = '';

                if (telPhone === '') {
                    errorMsg = "电话号码不能为空-。-";
                } else if (!Tools.phoneCheck(telPhone)) { // 验证手机格式
                    errorMsg = "电话号码格式不合法-。-";
                }

                if (errorMsg !== '') {
                    notice.warning(errorMsg);
                    return false;
                }

                return true;
            },
            // 外呼
            callOut: function (telPhone) {
                // 检测电话格式是否合法
                if(!this.checkPhone(telPhone)) {
                    return;
                }

                let params = {
                    teleActivityId: this.$parent.activityId,
                    namesId: this.$parent.namesId,
                    disNumber: this.$parent.originFieldsMap.displayNumber
                };

                // 如果是从预约相关的入口进入的，则把参数传入callOut
                if(this.reserveId !== '') {
                    params.reserveId = this.reserveId;
                }

                top.callOut(telPhone, true, params);
            },
            // 发送短信
            sendNoteWin: function (event) {
                let telephone = this.teleNum;
                // 检测电话格式是否合法
                if(!this.checkPhone(telephone)) {
                    event.stopImmediatePropagation();
                    return;
                }

                var originObj = this.$parent.originFieldsMap;
                // 初始化短信弹窗
                sendNoteModal.init({
                    tel: telephone,
                    message: '',
                    receiver: originObj.userName,
                    sender: '',
                    commType: '0',
                    namesId: originObj.namesId,
                    teleActivityId: originObj.teleActivityId
                });
            }
        }
    }
</script>

<style lang="less" scoped>
    @import "../../less/fieldStatic.less";
</style>