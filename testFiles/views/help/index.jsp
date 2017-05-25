<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>知识库管理</title>
    <%@include file="/views/include/pageHeader.jsp"%>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/static/css/innerFrame.css">
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/static/css/help.css">
</head>
<body class=" pace-done">

<div id="left-part">
    <div class="main-contain">
        <header class="part-header">
            <div class="sidebar">知识库管理</div>
        </header>
        <div class="left-content">
            <div class="left-content-panel">
                <div class="left-content-panel-header">
                    <span id="docHeaderTitle" class="doc-head-title">全部文档</span>
                    <span id="docCount"></span>
                    <a href="javascript:void(0);" id="searchDoc" style="display: none;">搜索</a>
                    <a href="javascript:void(0);" id="addDoc" style="display: none;">+文档</a>
                </div>

                <ul class="page-tree" id="docTree"></ul>
            </div>
        </div>
    </div>

    <div class="toggle-btn-box">
        <button class="toggle-btn" id="leftToggleBtn"><i class="fa fa-angle-left" aria-hidden="true" style="font-size: 20px;"></i></button>
    </div>
</div>
<div id="right-part">
    <div id="docPart" style="height: 100%;">
        <header class="part-header">
            <div class="sidebar-right">
                <ul class="doc-title-nav" id="docTitleNavList"></ul>
                <div class="operations" id="operations">
                    <button type="button" class="btn btn-sm btn-raised btn-danger" onclick="deleteDoc();" data-word="delete" style="display: none;">删除</button>
                    <button type="button" class="btn btn-sm btn-raised btn-primary" onclick="goPublish('1');" data-word="edit" style="display: none;">编辑</button>
                </div>
            </div>
        </header>

        <div class="right-content" style="padding-left: 20px;padding-right: 20px;">
            <div id="docBox"></div>
            <ul class="attach-list" id="attachList"></ul>
        </div>
    </div>

    <iframe name="iframe" id="rightIframe" style="display:none" width="100%" height="100%" src="" frameborder="0" seamless></iframe>
</div>
<!-- 文章树 -->
<script id="page-tree" type="text/x-handlebars-template">
    <li class="clear-fix" data-tree-id="{{docId}}" data-doc-level="{{docLevel}}">
        <div class="page-icon">
            {{#if hasChild}}
            <i class="fa fa-angle-right" aria-hidden="true"></i>
            {{else}}
            <i class="circle" aria-hidden="true"></i>
            {{/if}}
        </div>
        <div class="page-title">
            {{#if hasChild}}
            <a href="javascript:void(0);" title="{{title}}">{{title}}</a>
            <span>({{childSize}})</span>
            {{else}}
            <a href="javascript:void(0);" title="{{title}}">{{title}}</a>
            {{/if}}
        </div>
    </li>
</script>
<!-- 文章展示内容 -->
<script id="doc-detail" type="text/x-handlebars-template">
    <div class="doc-info">
        <h4>{{title}}</h4>
        <div class="detail"><span>{{author}}</span> • 发表于：<span>{{createTime}}</span> • 更新于：<span>{{updateTime}}</span></div>
        <hr>
    </div>
    <p class="doc-content">{{{content}}}</p>
</script>

<!-- 附件信息展示内容 -->
<script id="attach-detail" type="text/x-handlebars-template">
    <li><i class="fa fa-file" aria-hidden="true"></i><span>{{originalName}}</span> {{fileSize}} <a href="<%=request.getContextPath()%>/attachments/download?newFileName={{fileNew}}&relativePath={{relativePath}}">下载</a></li>
</script>

<script>
    // 需要初始化时定位到的文档ID
    var DOC_ID = '${docId}';
    $(function() {
        // 权限菜单按钮控制隐藏或者显示
        permissionControl();
        // 获取文档总数并修改
        getAllDocsCount();
        // 初始化文档树
        initDocTree();

        // 注册事件
        regEvent();
    });

    /**
     * @desc [权限菜单按钮控制隐藏或者显示]
     */
    var permissionControl = (function() {
        var $operations = $('#operations');
        // 页面权限菜单对应的url与按钮元素的对照表
        var pageUrlObj = {
            'help/document/deleteDocument': $operations.children('button[data-word=delete]'),
            'help/partition/editDoc': $operations.children('button[data-word=edit]'),
            'help/document/addDoc': $('#addDoc'),
            'help/document/search': $('#searchDoc')
        };

        return function() {
            // 获取页面权限菜单数组
            var pagePermissionArr = top.PERMISSION_MENU_G.getPagePermission(Tools.getSearchParamValue(null, 'permissionId'));
            var tmpObj = null;

            // 控制菜单元素(按钮)的显示
            for(var i = 0, len = pagePermissionArr.length; i < len; i++) {
                tmpObj = pagePermissionArr[i];

                if(tmpObj.url in pageUrlObj) {
                    pageUrlObj[tmpObj.url].show();
                }
            }
        };
    })();

    // 初始化文档树(parentId为0)
    function initDocTree() {
        getDocTreeData({
            parentId: '0'
        }, null, function() {
            $('#docHeaderTitle').click();
        }).then(function() {
            // 如果需要一开始就定位到某一篇文档
            if(DOC_ID !== '') {
                // 获取文章所在位置同级及以上的节点树并生成
                createParAndSibDocData({
                    docId: DOC_ID
                });
            }
        });
    }

    // 获取文档总数并修改
    function getAllDocsCount() {
        $.post('<%=request.getContextPath()%>/help/document/queryDocCount', function(data) {
            if (data.success) {
                $('#docCount').text('(' + data.total + ')');
            } else {
                notice.warning(data.msg);
            }
        });
    }

    /*
     * @desc 获取文档树数据
     * @$beAppendedEle 要被添加子节点的元素，默认为#docTree
     * */
    function getDocTreeData(param, $beAppendedEle, callback) {
        return $.ajax({
            url: "<%=request.getContextPath()%>/help/document/queryDocByParentId",
            dataType: 'json',
            data: param,
            success: function(data) {
                if(!(data.success)) {
                    notice.danger(data.msg);
                    return;
                }

                if(data.rows != null) {
                    createDocTree(data, $beAppendedEle, callback);
                }
            }
        });
    }

    // 生成文章节点树
    var createDocTree = (function () {
        var pageTreeTpl = Handlebars.compile($("#page-tree").html());

        return function(data, $beAppendedEle, callback) {
            var rows = data.rows;
            var $li = null;
            var tmpData = null;
            var html = [];

            // 非一级节点时，需要额外添加的ul元素
            var $ul = null;
            // 生成节点树的父节点，默认为#docTree
            var $parent = $('#docTree');

            for(var i = 0, len = rows.length; i < len; i++) {
                tmpData = rows[i];
                // 判断是否有子节点
                tmpData.hasChild = tmpData.childSize > 0;
                $li = $(pageTreeTpl(tmpData));
                html.push($li);
            }

            // 如果要被添加子节点的元素$beAppendedEle存在
            // 需要特别添加Ul元素，并且父节点就是$beAppendedEle
            if($beAppendedEle != null) {
                $ul = $('<ul class="page-tree"></ul>');
                $parent = $beAppendedEle;
                // 替换html
                html = $ul.append(html);
                // 移除原有的节点树
                $parent.children('ul.page-tree').remove();
                // 移除原有标题的个数，添加新的标题个数
                $parent.find('.page-title:eq(0) > span').remove();
                $parent.children('.page-title').append('<span>(' + data.total + ')</span>');
            } else {
                $parent.empty();
            }

            $parent.append(html);

            if(typeof callback === 'function') {
                callback();
            }

            if($ul != null) {
                return $ul;
            } else {
                return $parent;
            }
        };
    })();

    /*
     * @desc 获取文档详情
     * */
    function getDocDetail(param) {
        $.post("<%=request.getContextPath()%>/help/document/queryByDocId", param, function(data) {
            if(!(data.success)) {
                notice.danger(data.msg);
                return;
            }

            if(data.rows != null) {
                createDocDetail(data.rows);
            }
        });
    }

    // 生成文章详情页
    var createDocDetail = (function () {
        var docDetailTpl = Handlebars.compile($("#doc-detail").html());
        var $docBox = $('#docBox');

        return function(rows) {
            var html = [];
            var $detail = $(docDetailTpl(rows));

            html.push($detail);
            $docBox.empty().append(html);
            $('#operations').show();

            iframeVisible(false);
        };
    })();

    // 创建文档顶部导航链接
    function createTopDocNav($ele) {
        var $docTitleNavList = $('#docTitleNavList');
        // 所有标题的html文档
        var titleArr = [];
        // 标题元素
        var $title = $ele.children('.page-title');
        var title = '';

        // 一直遍历到一级标题
        while($title.length > 0) {
            title = $title.children('a').text();
            titleArr.push('<li><a href="javascript:void(0);" title="' + title + '" onclick="toTitleByDocId(' + $title.closest('li.clear-fix').attr('data-tree-id') + ')">' + title + '</a></li>');
            $title = $title.closest('ul.page-tree').prev('.page-title');
        }

        // 反序数组
        titleArr.reverse();

        $docTitleNavList.html(titleArr);
    }

    // 左侧树结构根据文章id定位到相应节点
    function toTitleByDocId(docId) {
        docId = docId.toString();
        var $docTree = $('#docTree');

        // 点击目标文章标题，打开详情页面
        $docTree.find('li[data-tree-id=' + docId + '] > .page-title > a').click().focus();
    }

    // 获取附件列表
    function getAttachList(param) {
        $.post("<%=request.getContextPath()%>/help/document/getAttachment", param, function(data) {
            if(!(data.success)) {
                notice.danger(data.msg);
                return;
            }

            if(data.rows != null) {
                createAttachList(data.rows);
            }
        });
    }

    // 生成附件列表
    var createAttachList = (function() {
        var attachTpl = Handlebars.compile($("#attach-detail").html());
        var $attachList = $('#attachList');

        return function(rows) {
            var html = [];
            var tmpData = null;

            for(var i = 0, len = rows.length; i < len; i++) {
                tmpData = rows[i];
                tmpData.fileSize = Tools.getFileSize(tmpData.size);
                html.push($(attachTpl(tmpData)));
            }

            $attachList.html(html);
        };
    })();

    /*
     * @desc 获取文章所在位置同级及以上的节点树并生成
     * */
    function createParAndSibDocData(param) {
        $.ajax({
            url: "<%=request.getContextPath()%>/help/document/getParAndSibDoc",
            dataType: 'json',
            data: param,
            success: function(data) {
                var rows = data.rows;
                if(!(data.success)) {
                    notice.danger(data.msg);
                    return;
                }

                if(rows != null) {
                    // 获取一级节点id
                    var parentId = data.rows[0].docId;
                    var $docTree = $('#docTree');

                    if(rows[0].childSize > 0 && rows[0].child && rows[0].child.length > 0) {
                        // 递归生成文章树
                        makeTreeRecursion(rows[0].child, $docTree.find('li[data-tree-id=' + parentId + ']'));
                    }

                    // 点击目标文章标题，打开详情页面
                    toTitleByDocId(param.docId);
                }
            }
        });
    }

    /**
     * @desc 递归生成文章树
     * @author Lesty
     * @codeDate 2016.10.29
     * @list Array 子节点数据
     * @$beAppendedEle Object 要被添加子节点的JQuery元素
     */
    function makeTreeRecursion(list, $beAppendedEle) {
        var node = null;
        var $parent = null;

        var $icon = $beAppendedEle.find('.page-icon:eq(0) i');

        // 修改父文档标题样式
        if(list.length > 0) { // 如果有子文档
            $beAppendedEle.data('hasSend', true);
            $icon.removeClass().addClass('fa fa-angle-down');
        }

        // 在父元素下生成一层文章树并获取子节点所在的ul元素
        $parent = createDocTree({
            rows: list,
            total: list.length
        }, $beAppendedEle);

        for (var i = 0, len = list.length; i < len; i++) {
            node = list[i];

            // 如果某个节点的子元素存在，继续迭代生成子节点
            if (node.childSize > 0 && node.child && node.child.length > 0) {
                // 获取要被添加子节点的JQuery元素
                $beAppendedEle = $parent.find('li[data-tree-id=' + node.docId + ']');
                // 递归
                makeTreeRecursion(node.child, $beAppendedEle);
            }
        }
    }

    // 删除文档
    function deleteDoc() {
        var $activeTitle = $('#docTree').find('a.active');
        var $li = $activeTitle.closest('li');
        var docName = $('#docBox').find('.doc-info > h4').text();
        // 提示语句(默认没有子文档)
        var confirmSentence = '确认删除文章《' + docName + '》吗？';

        // 如果有子文档，修改提示语句内容
        if($activeTitle.next('span').text().trim() !== '') {
            confirmSentence += '(注意：删除该文章后，其下全部子文章都将被删除且不可恢复！)';
        }

        if(confirm(confirmSentence)) {
            $.post('<%=request.getContextPath()%>/help/document/deleteDocument', {
                docId: $li.attr('data-tree-id')
            }, function(data) {
                if (data.success) {
                    notice.success('成功删除文档《' + docName + '》！');

                    // 父UL元素，包含所有本级节点
                    var $parentUL = $li.closest('ul.page-tree');
                    // 父级LI元素，也就是父节点文档
                    var $parentDocLI = null;
                    // 标题icon
                    var $icon = null;
                    var $span = null;
                    var spanText = '';
                    // 截取spanText括号中间的数字
                    var curCount = 0;

                    // 获取文档总数并修改
                    getAllDocsCount();

                    // 将hasSend标志设为null，以便点击展开图标时，可以发送请求
                    // 修改图标样式
                    if($parentUL.attr('id') === 'docTree') {
                        // 初始化文档
                        initDocTree();
                    } else {
                        $parentDocLI = $li.parents('li:eq(0)');
                        $icon = $parentDocLI.find('.page-icon:eq(0) i');
                        $span = $parentDocLI.find('.page-title:eq(0) > span');
                        spanText = $span.text();
                        curCount = parseInt(spanText.substring(1, spanText.length - 1), 10);

                        $parentDocLI.data('hasSend', null);
                        // 修改父文档标题样式
                        if(curCount === 1) { // 父文档如果只有一个子文档
                            // 修改父文档标题样式为叶子节点
                            $span.remove();
                            // 移除ul
                            $parentUL.remove();
                            $icon.removeClass().addClass('circle');
                            $parentDocLI.find('.page-title:eq(0) > a').click();
                        } else {
                            $icon.removeClass().addClass('fa fa-angle-right').click();
                        }
                    }
                } else {
                    notice.warning(data.msg);
                }
            });
        }
    }

    // 添加文档之后的回调函数
    function addDocCallBack() {
        var $a = $('#docTree').find('a.active');

        // 获取文档总数并修改
        getAllDocsCount();

        if($a.length === 0) { // 当前处于根节点--全部文档
            initDocTree();
        } else {
            // 将hasSend标志设为null，以便点击展开图标时，可以发送请求
            // 修改图标样式
            $a.closest('li').data('hasSend', null).find('.page-icon:eq(0) i').removeClass().addClass('fa fa-angle-right').click();
        }

        iframeVisible(false);
    }

    // 编辑文档之后的回调函数(title: 修改后的title，用来更新左侧当前标题)
    function editDocCallBack(title) {
        var $a = $('#docTree').find('a.active');

        if($a.length === 0) { // 当前处于根节点--全部文档
            $('#docHeaderTitle').click();
        } else {
            // 点击标题，重新加载文章
            $a.attr('title', title).text(title).click();
        }

        iframeVisible(false);
    }

    // 跳到发布页面(isEdit: 0-添加 1-编辑)
    function goPublish(isEdit) {
        var $a = $('#docTree').find('a.active');
        var docId = '';

        if($a.length === 0) { // 当前处于根节点，全部文档
            docId = '0';
        } else {
            docId = $a.closest('li').attr('data-tree-id');
        }

        $('#rightIframe').attr("src","<%=request.getContextPath()%>/knowledge/goPublish?isEdit=" + isEdit +"&docId=" + docId);

        iframeVisible(true);
    }

    // 控制iframe隐藏显示并移除beforeunload事件
    function iframeVisible(status) {
        if(status) {
            $('#rightIframe').show();
            $('#docPart').hide();
        } else {
            var frame = window.frames[0];
            // 销毁iframe的绑定事件
            frame.removeEventListener("beforeunload", frame.checkPageContent);

            $('#docPart').show();
            $('#rightIframe').attr('src', '').hide();
        }
    }

    function regEvent() {
        var $docTree = $('#docTree');

        // 左侧菜单展开/收起按钮
        $('#leftToggleBtn').on('click', (function() {
            var isOpen = true;
            var $body = $('body');
            var $leftToggleIcon = $('#leftToggleBtn').children('i');

            return function(event) {
                event.preventDefault();

                $body.toggleClass('left-is-closed');
                // 根据左侧菜单打开状态，修改按钮类
                if(isOpen) {
                    $leftToggleIcon.removeClass('fa-angle-left').addClass('fa-angle-right');
                } else {
                    $leftToggleIcon.removeClass('fa-angle-right').addClass('fa-angle-left');
                }

                isOpen = !isOpen;
            };
        })());

        $('#docHeaderTitle').on('click', function() {
            $(this).addClass('active');
            $('#docTree').find('a.active').removeClass('active');

            createDocDetail({
                author: "管理员",
                content: "欢迎使用知识库管理功能",
                createTime: "2016-10-1 11:11:11",
                title: "全部文档",
                updateTime: "2016-10-1 11:11:11"
            });

            $('#operations').hide();
        });

        // 事件委托，监听展开/收起按钮事件
        $docTree.on('click', '.page-icon > i', function() {
            var $_my = $(this);
            var $li = $_my.closest('li');
            var $childTree = $li.children('.page-tree');
            var treeId = $li.attr('data-tree-id');

            if($_my.hasClass('circle')) {
                return false;
            }

            // 点击按钮展开时
            // 使用hasSend标志位，确保请求只发送一次(如果需要刷新，通过将hasSend手动设为null，可以再次发送请求)
            if($_my.hasClass('fa-angle-right')) {
                // 如果hasSend标志位为空
                // 则说明还未请求过子节点数据
                if($li.data('hasSend') == null) {
                    $li.data('hasSend', true);
                    getDocTreeData({
                        parentId: treeId
                    }, $li);
                }

                $childTree.slideDown();
            } else { // 收起按钮时
                $childTree.slideUp();
            }

            // 切换按钮图标
            $_my.toggleClass('fa-angle-right fa-angle-down');
        });

        // 事件委托，监听标题点击事件
        $docTree.on('click', '.page-title > a', function() {
            var $_my = $(this);
            var $li = $_my.closest('li');
            var treeId = $li.attr('data-tree-id');

            $('#docHeaderTitle').removeClass('active');
            $('#docTree').find('a.active').removeClass('active');
            $_my.addClass('active');

            createTopDocNav($li);

            // 获取文档详情
            getDocDetail({
                docId: treeId
            });

            // 获取附件列表
            getAttachList({
                docId: treeId
            });
        });

        // 添加文章
        $('#addDoc').on('click', function() {
            var $a = $('#docTree').find('a.active');
            // 默认为根节点，全部文档(0)
            var docLevel = 0;

            if($a.length > 0) { // 如果点击了文档列表
                docLevel = parseInt($a.closest('li').attr('data-doc-level'), 10);
            }

            if(docLevel < 6) {
                goPublish('0');
            } else {
                notice.warning('该层级无法添加子文档，知识库文档层级不能超过6级-。-');
            }
        });

        // 搜索
        $('#searchDoc').on('click', function() {
            $('#rightIframe').attr("src", "<%=request.getContextPath()%>/help/document/goSearch");
            iframeVisible(true);
        });
    }
</script>

</body>
</html>