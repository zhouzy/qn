<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@include file="/views/include/pageHeader.jsp"%>
<title></title>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/static/css/innerFrame.css">
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/static/css/help.css">
</head>
<body style="background-color: #fff;">
<header class="part-header">
    <span>搜索</span>
</header>
<div class="right-content" style="font-weight: normal; color: #777;">
    <div class="container-fluid">
        <div class="row">
            <div class="col-sm-10 search-box">
                <input class="search-input" id="searchInput" type="text" placeholder="请输入搜索内容"><button class="search-btn" id="searchBtn">搜索</button>
                <i class="fa fa-filter filter-icon" aria-hidden="true" id="filterIcon"></i>
            </div>
        </div>

        <div class="row">
            <div class="col-sm-12">
                <div class="search-tool" id="tools" style="display: none;">
                    <div class="tool-box">
                        <label for="creator">创建人：</label>
                        <select id="creator" name="creator">
                            <option>丁兆伟</option>
                            <option>战狼</option>
                        </select>
                    </div>
                    <div class="tool-box">
                        <label>创建时间：</label>
                        <div class="btn-group" data-word="create">
                            <button class="btn btn-xs btn-primary" data-range="today">今天</button>
                            <button class="btn btn-xs btn-primary" data-range="week">本周</button>
                            <button class="btn btn-xs btn-primary" data-range="month">本月</button>
                            <button class="btn btn-xs btn-primary" data-range="custom">自定义时间</button>
                        </div>
                        <div class="form-inline time-search-form" style="display: none;">
                            <input id="createStartTime" type="text" name="createStartTime" data-type="datetimepicker" data-label="从">
                            <span>—</span>
                            <input id="createEndTime" type="text" name="createEndTime" data-type="datetimepicker">
                            <button class="btn btn-xs btn-raised btn-primary">确定</button>
                        </div>
                    </div>
                    <div class="tool-box">
                        <label>更新时间：</label>
                        <div class="btn-group" data-word="update">
                            <button class="btn btn-xs btn-primary" data-range="today">今天</button>
                            <button class="btn btn-xs btn-primary" data-range="week">本周</button>
                            <button class="btn btn-xs btn-primary" data-range="month">本月</button>
                            <button class="btn btn-xs btn-primary" data-range="custom">自定义时间</button>
                        </div>
                        <div class="form-inline time-search-form" style="display: none;">
                            <input id="updateStartTime" type="text" name="updateStartTime" data-type="datetimepicker" data-label="从">
                            <span>—</span>
                            <input id="updateEndTime" type="text" name="updateEndTime" data-type="datetimepicker">
                            <button class="btn btn-xs btn-raised btn-primary">确定</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-sm-12" id="resultList">
            <div class="col-sm-12" style="margin-left: 10px;">请输入关键字开始检索</div>
        </div>
        <div class="col-sm-12">
            <div id="pagination" style="text-align: left;display: none;"></div>
        </div>
    </div>
</div>

<!-- 搜索结果内容展示 -->
<script id="result-detail" type="text/x-handlebars-template">
    <div class="col-sm-12 search-result">
        <div class="result-title">
            <a href="javascript:void(0);" data-doc-id="{{docId}}">{{title}}</a>
            <span>{{author}} • {{createTime}} • 创建</span>
        </div>
        <p>{{{content}}}</p>
    </div>
</script>

<script type="text/javascript">
    /**
     * @desc 搜索页面控制脚本
     * @author Lesty
     * @codeDate 2016.10.28
     */

    // 全局缓存查询参数默认结果长度50
    var paramCache_g = {
        key: '',
        contentLen: 50
    };
    
    $(function() {
        // 初始化搜索工具
        initSearchTool();

        // 注册事件
        regEvent();
    });

    // 初始化搜索工具
    function initSearchTool() {
        // 获取所有创建人列表并生成
        getCreatorList();

        // 初始化时间控件
        $('#createStartTime, #createEndTime, #updateStartTime, #updateEndTime').timeInput({
            format: 'yyyy-MM-dd',
            HMS: false
        });
    }

    // 获取所有创建人列表并生成
    function getCreatorList() {
        $.post('<%=request.getContextPath()%>/help/document/getCreator', function(data) {
            if (data.success) {
                var optionsHtml = '<option value="">全部</option>';
                var rows = data.rows;
                var tmpData = null;

                for(var i = 0, len = rows.length; i < len; i++) {
                    tmpData = rows[i];
                    optionsHtml += '<option value="' + tmpData.userId + '">' + tmpData.userName + '</option>';
                }

                $('#creator').html(optionsHtml);
            } else {
                notice.warning(data.msg);
            }
        });
    }

    /*
     * @desc 获取结果列表
     * */
    var getResultList = (function () {
        // 初始化分页
        var pager = new cri.Pager($("#pagination"),{
            page:1,
            pageSize:6,
            total:0,
            onPage:function(page,pageSize){
                $.extend(paramCache_g,{page:page, rows:pageSize});
                getResultList(paramCache_g);
            }
        });

        // pager初始化total为0不起作用，需要手动update
        pager.update(1, 6, 0);

        return function(param) {
            // 合并对象
            $.extend(paramCache_g, param);
            // 请求
            $.ajax({
                url: "<%=request.getContextPath()%>/help/document/search",
                dataType: 'json',
                data: paramCache_g,
                success: function(data) {
                    if(!(data.success)) {
                        notice.danger(data.msg);
                        return;
                    }

                    if(data.rows != null) {
                        createResultList(data);
                    }

                    // 更新分页栏
                    pager.update(param.page, param.rows, data.total);
                }
            });
        };
    })();

    // 生成结果列表
    var createResultList = (function () {
        var resultDetailTpl = Handlebars.compile($("#result-detail").html());
        var $resultList = $('#resultList');
        return function(data) {
            var rows = data.rows;
            var $result = null;
            var tmpData = null;
            var html = [];

            if(rows.length === 0) {
                html.push('<div class="col-sm-12 search-result">很抱歉，对应筛选条件下没有找到与"<span style="color: #c00">' + paramCache_g.key + '</span>"相关的文档-。-</div>');
                $('#pagination').hide();
            } else {
                $('#pagination').show();
            }

            for(var i = 0, len = rows.length; i < len; i++) {
                tmpData = rows[i];

                $result = $(resultDetailTpl(tmpData));
                html.push($result);
            }

            $resultList.empty().append(html);
        };
    })();

    function regEvent() {
        var $searchTools = $('#tools');

        // 查询事件
        $('#searchBtn').on('click', function () {
            getResultList({
                key: $('#searchInput').val().trim(),
                page: 1,
                rows: 6
            });
        });

        // 监听回车事件
        $('#searchInput').on('keypress', function(event) {
            if(event.which.toString() === '13') {
                $('#searchBtn').click();
            }
        });

        // 筛选器按钮
        $('#filterIcon').on('click', function() {
            $(this).toggleClass('open');
            $('#tools').slideToggle();
        });

        // 创建人change
        $('#creator').on('change', function() {
            getResultList({
                creatorId: $(this).val(),
                page: 1,
                rows: 6
            });
        });

        // 创建时间，更新时间点击事件(事件委托)
        $searchTools.find('.btn-group').on('click', 'button', function() {
            var $_my = $(this);
            // 时间区间
            var range = $_my.attr('data-range');
            // 按钮组关键字
            var keyWord = $_my.closest('.btn-group').attr('data-word');
            // 自定义时间--区间栏
            var $customTimeEle = $_my.closest('.tool-box').children('.time-search-form');
            // 起始时间
            var startTime = null;
            // 结束时间
            var endTime = new Date();
            // 当前星期几(1-7对于星期一到星期天)
            var curDay = endTime.getDay() === 0 ? 7 : endTime.getDay();
            // 发送参数
            var param = {
                page: 1,
                rows: 6
            };

            // 切换自身active类
            $_my.toggleClass('active');
            // 移除兄弟元素active类
            $_my.siblings('button').removeClass('active');

            /*
            * 根据不同按钮区间确定相应起止时间段
            * */
            if(range === 'custom') { // 自定义时间
                $customTimeEle.slideToggle();
            } else { // 其他默认区间按钮
                $customTimeEle.slideUp();

                // 确定起止时间
                // 如果当前取消选中，则起止时间为空(即查询全部)
                if(!$_my.is('.active')) { // 查询全部
                    startTime = '';
                    endTime = '';
                } else{
                    if(range === 'today') { // 今天
                        startTime = cri.formatDate(endTime, 'yyyy-MM-dd');
                    } else if(range === 'week') { // 本周
                        startTime = cri.formatDate(new Date(+endTime - (curDay - 1)*60*60*24*1000), 'yyyy-MM-dd');
                    } else if(range === 'month') { // 本月
                        startTime = cri.formatDate(endTime, 'yyyy-MM-dd').substring(0, 8) + '01';
                    }

                    startTime = startTime + ' 00:00:00';
                    endTime = cri.formatDate(endTime, 'yyyy-MM-dd') + ' 23:59:59';
                }

                // 设置参数
                param[keyWord + 'StartTime'] = startTime;
                param[keyWord + 'EndTime'] = endTime;

                // 搜索
                getResultList(param);
            }
        });

        // 自定义时间查询事件
        $searchTools.find('.time-search-form > button').on('click', function() {
            var $timeInputs = $(this).closest('.time-search-form').find('input[data-role="timeInput"]');
            var startTimeEle = $timeInputs[0];
            var endTimeEle = $timeInputs[1];
            var param = {
                page: 1,
                rows: 6
            };

            var startTime = +new Date(startTimeEle.value);
            var endTime = +new Date(endTimeEle.value);

            if(endTime < startTime) {
                notice.danger('自定义时间起止时间不合法！请检查起止时间区间-。-');
                return false;
            }

            // 设置参数
            param[startTimeEle.name] = startTimeEle.value + ' 00:00:00';
            param[endTimeEle.name] = endTimeEle.value + ' 23:59:59';

            // 搜索
            getResultList(param);
        });

        // 点击搜索结果标题时，左侧定位到相应标题，并打开详情页
        $('#resultList').on('click', '.result-title > a', function() {
            var docId = $(this).attr('data-doc-id');
            // 获取该文章所在位置同级及以上的节点树
            parent.createParAndSibDocData({
                docId: docId
            });
        });
    }
</script>
</body>
</html>