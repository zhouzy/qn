<template>
    <div class="my-order__root">
        <!--标题头部-->
        <div class="customer-center__right-part-header">
            <el-row>
                <el-col :sm="8">
                    <el-breadcrumb separator="/" class="customer-center__breadcrumb">
                        <el-breadcrumb-item>我的工单</el-breadcrumb-item>
                    </el-breadcrumb>

                    <el-button type="primary" size="small"><i class="fa fa-plus" aria-hidden="true"></i> 提交新工单</el-button>
                </el-col>
            </el-row>
        </div>

        <!--主要内容-->
        <div class="customer-center__main-content">
            <!--查询panel-->
            <div class="my-order__query-panel">
                <el-form label-width="100px">
                    <el-row :gutter="8">
                        <el-col :sm="6">
                            <el-form-item label="工单状态">
                                <el-select size="small" v-model="queryForm.status" placeholder="请选择工单状态">
                                    <el-option label="全部" value="-1"></el-option>
                                    <el-option label="尚未受理" value="0"></el-option>
                                    <el-option label="受理中" value="1"></el-option>
                                    <el-option label="等待回复" value="2"></el-option>
                                    <el-option label="已解决" value="3"></el-option>
                                    <el-option label="已关闭" value="4"></el-option>
                                </el-select>
                            </el-form-item>
                        </el-col>

                        <el-col :sm="{span: 6, offset: 12}">
                            <el-form-item style="text-align: right;">
                                <el-button type="primary" @click="queryOrderList" size="small">查询</el-button>
                                <el-button type="warning" @click="resetForm" size="small">重置</el-button>
                            </el-form-item>
                        </el-col>
                    </el-row>
                </el-form>
            </div>

            <div class="my-order__table-content">
                <el-table :data="orderList"
                          :stripe="true"
                          :border="true"
                          :highlight-current-row="true"
                          v-loading="isLoading"
                          element-loading-text="努力获取数据中···"
                          height="320">
                    <el-table-column label="编号" prop="workId"></el-table-column>
                    <el-table-column label="标题" prop="title"></el-table-column>
                    <el-table-column label="工单状态">
                        <template scope="scope">
                            <el-tag :type="ORDER_STATUS_MAP[scope.row.status].type" :color="ORDER_STATUS_MAP[scope.row.status].color">{{ORDER_STATUS_MAP[scope.row.status].text}}</el-tag>
                        </template>
                    </el-table-column>
                    <el-table-column label="工单创建日期" prop="createDate"></el-table-column>
                    <el-table-column label="受理组" prop="serviceGroupName"></el-table-column>
                    <el-table-column label="受理人" prop="customServiceName"></el-table-column>
                </el-table>

                <div class="my-order__pagination-box">
                    <!--分页-->
                    <el-pagination
                            @size-change="handleSizeChange"
                            @current-change="handlePageChange"
                            :current-page="pager.page"
                            :page-sizes="[5, 10, 15]"
                            :page-size="pager.size"
                            layout="total, sizes, prev, pager, next, jumper"
                            :total="pager.total">
                    </el-pagination>
                </div>
            </div>
        </div>
    </div>
</template>

<script type="text/ecmascript-6">
    import querystring from 'querystring';

    /**
     * @desc 我的工单组件
     * @author Lesty
     * @code-date 2017.5.17
     **/
    export default {
        name: 'MyOrder',
        created: function() {
            // 初始化函数
            this.debounceGetOrderList = _.debounce(this.getOrderList, 500, {maxWait: 2000});
        },
        // 由于遮罩层的ref属性，相关请求需要放到mounted里发送
        mounted: function () {
            // 获取工单列表
            this.queryOrderList();
        },
        data: function () {
            return {
                // 查询form数据
                queryForm: {
                    status: '-1'
                },
                // 缓存请求参数
                getOrderListParamsCache: {},
                // 工单列表
                orderList: [],
                // 分页对象
                pager: {
                    page: 1,
                    size: 10,
                    total: 0
                },
                // 表格是否正在加载
                isLoading: false,
                // 工单状态对照表
                ORDER_STATUS_MAP: window.ACT_CONFIG.ORDER_STATUS_MAP
            };
        },
        methods: {
            // 查询相应条件下的工单列表
            queryOrderList: function () {
                /*
                * 这里可以对表单做校验
                * @latest Lesty 2017.5.24
                * */

                // 获取工单列表
                this.debounceGetOrderList(this.queryForm);
            },
            // 重置表单
            resetForm: function() {
                this.queryForm.status = '-1';
            },
            // 获取工单列表
            getOrderList: function (param) {
                // 缓存请求参数
                this.getOrderListParamsCache = _.extend({}, param);

                // 显示loading
                this.isLoading = true;
                this.axios.get('/queryWorkOrderInfo/queryCreatorWorkOrder', {
                    params: {
                        status: param.status,
                        page: this.pager.page,
                        rows: this.pager.size
                    }
                }).then(res => {
                    let data = res.data;
                    if(!data.success) {
                        return Promise.reject(new Error(data.msg));
                    }

                    this.orderList = data.rows || [];
                    // 更新分页对象
                    this.updatePager({
                        total: data.total
                    });
                }).catch(error => {
                    this.$message({
                        showClose: true,
                        type: 'error',
                        message: error.message
                    });
                }).finally(() => {
                    setTimeout(() => {
                        // 隐藏loading
                        this.isLoading = false;
                    }, 500);
                });
            },
            // 更新分页对象
            updatePager: function (pager) {
                _.extend(this.pager, pager);
            },
            // 分页size改变
            handleSizeChange: function (size) {
                // 更新分页对象
                this.updatePager({
                    size: size
                });

                // 获取工单列表
                this.debounceGetOrderList(this.getOrderListParamsCache);
            },
            // 分页page改变
            handlePageChange: function (page) {
                // 更新分页对象
                this.updatePager({
                    page: page
                });

                // 获取工单列表
                this.debounceGetOrderList(this.getOrderListParamsCache);
            }
        }
    }
</script>

<style lang="less" scoped>
    @import "../../less/my-order.less";
</style>
