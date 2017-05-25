<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>主页</title>
    <link rel="icon" type="image/x-icon" href="<%=request.getContextPath()%>/${faviconUrl}" />
    <%@include file="/views/include/pageHeader.jsp"%>
    <link href="<%=request.getContextPath()%>/static/css/outerFrame.css" rel="stylesheet">
</head>
<body style="overflow-x: auto;overflow-y: hidden; min-width: 1366px;">
<header id="header">
    <nav class="navbar" role="navigation" style="margin-bottom: 0">
        <div class="container-fluid">
            <div class="nav navbar-nav navbar-left logo">
                <img id="mainLogo" />
            </div>
            <div class="nav navbar-nav" style="position: relative;">
                <ul class="header-tag-list" id="tagList">
                    <li class="icon-tab" title="新建客户" style="display: none;">
                        <a data-toggle="modal" onclick="toAddUserModal()" data-target="#addUserModal">
                            <span class="fa fa-user-plus" aria-hidden="true"></span>
                        </a>
                    </li>
                </ul>
                <div class="close-tip right" id="closeTip" onclick="hideCloseTip()" style="display: none;">
                    <div class="arrow"></div>
                    <div class="popover-title" style="display: none">Tab页关闭提醒</div>
                    <div class="popover-content">顶部tab标签超过最大数量,已关闭最左边标签！</div>
                </div>
            </div>
            <div class="collapse navbar-collapse navbar-right">
                <form role="search" class="nav navbar-nav navbar-form" method="post" action="javascript:goSearch('work');">
                    <div class="form-group">
                        <div class="input-group dropdown search-input-group">
                            <span class="input-group-addon"><i class="fa fa-search"></i></span>
                            <input type="text" placeholder="搜索" class="form-control" name="top-search" id="top-search" data-toggle="dropdown"  aria-haspopup="true" aria-expanded="false">
                            <ul class="dropdown-menu" style="width: 170px;" aria-labelledby="top-search">
                                <li><a onclick="goSearch('work')">在“工单”中搜索</a></li>
                                <li><a onclick="goSearch('user')">在“客户”中搜索</a></li>
                                <li><a onclick="goSearch('document')">在“知识库”中搜索</a></li>
                           </ul>
                        </div>
                    </div>
                </form>
                <ul class="nav navbar-nav icons ccodAgentStatus-initing">
                    <li id="setReadyToggle">
                        <div class="togglebutton">
                            <span id="currentStatus">准备中...</span>
                            <label>
                                <input type="checkbox">
                            </label>
                        </div>
                    </li>
                    <li id="phoneBtn"><i class="fa fa-phone"></i></li>
                    <li id="IMBtn"><i class="fa fa-comment" ></i><span class="notice-number" id="noticeNumber">0</span></li>
					<li id="restBtn" title="重置多渠道"><i class="fa fa-refresh" ></i></li>
                    <div class="status-text" id="ccodAgentStatus">
                        <span>正在加载多渠道资源</span>
                    </div>
                </ul>
                <div class="nav navbar-nav">
                    <div class="dropdown profile-element">
                        <a data-toggle="dropdown" class="dropdown-toggle user" href="#">
                            <span class="avatar">
                                <img alt="image" id="userPhotoId" class="img-circle" src="${photoUrl}" />
                            </span>
                            <span class="text-muted text-xs block username">${user.userName}<b class="caret"></b></span>
                        </a>
                        <ul class="dropdown-menu animated fadeInRight m-t-xs">
                            <li><a class="J_menuItem"  onclick="showUserDetail()">个人设置</a></li>
                            <li><a id="logoutBtn" href="javascript:void(0);">退出</a></li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </nav>
</header>
<div id="wrapper">
    <!--左侧导航开始-->
    <nav id="leftMenu" class="navbar-default navbar-static-side sidebar" role="navigation">
        <div class="sidebar-collapse">
            <ul class="nav sidebar-top left-menu">
            	<c:forEach items="${permissionList}" var="item">
            		<c:if test="${item.isTop == '1'}">
            			<li title="${item.name}">
		                    <a data-href="${item.url}" href="javascript:void(0);">
		                        <i class="fa menu${item.id}"></i>
		                        <span class="nav-label">${item.name}</span>
		                    </a>
		                </li>
            		</c:if>
            	</c:forEach>
            </ul>
            <ul class="nav sidebar-bottom left-menu">
                <c:forEach items="${permissionList}" var="item">
            		<c:if test="${item.isTop == '0'}">
            			<li title="${item.name}">
		                    <a data-href="${item.url}" href="javascript:void(0);">
		                        <i class="fa menu${item.id}"></i>
		                        <span class="nav-label">${item.name}</span>
		                    </a>
		                </li>
            		</c:if>
            	</c:forEach>
            </ul>
        </div>
    </nav>
    <!--左侧导航结束-->

    <!--右侧部分开始-->
    <div class="page-wrapper" id="content-main">
        <iframe name="iframe" id="rightContent" scrolling="no" frameborder="0" style="width: 100%;height: 100%"></iframe>
    </div>
    <!--右侧部分结束-->
</div>

<%--添加弹出框--%>
<%@include file="/views/addUserModal.jsp"%>

<%--IM TAB页内容--%>
<%@include file="/views/im/index.jsp"%>

<form id="switchUser" style="display:none" method="post" action="<%=request.getContextPath()%>/switchUser">
	<input type="text" name="loginName" id="loginNameSwitch" />
	<input type="text" name="loginPwd" id="loginPwdSwitch" />
</form> 
<script>
	$(function(){
    	initMainLogo();
        // 初始化全局权限菜单数组后再初始化页面，以免进入子页面时PERMISSION_MENU_G还没初始化
        initGlobalPermissionMenu(initMainPage);
		queryReservationThread.start();
    });
    localStorage.setItem('entId', '${user.ccodEntId}');
    localStorage.setItem('permissionControl', JSON.stringify(${permissionStr}));

    $.cookie("sessionKey",'${user.sessionKey}');
    var workBasePath="<%=request.getServerPort()%><%=request.getContextPath()%>";
    var locationStack = [];

    function initMainLogo(){
    	var flag = "${mainLogo}";
    	if(flag == ""){
    		$('#mainLogo').attr('src', "<%=request.getContextPath()%>/static/images/logo_hc1.png");
    	} else{
    		$('#mainLogo').attr('src', "<%=request.getContextPath()%>/" + flag);
    	}
    }

    // 全局的权限菜单对象
    var PERMISSION_MENU_G = (function() {
        // 权限菜单
        var permissionMenuArr = [];
        // 页面权限菜单对应的url与按钮元素的对照表
        // 控制台tab页不在这处理，而是根据左侧permissionList中是否存在控制台按钮而做判断
        var pageUrlObj = {
            'userManageMongo/addUser': $('#tagList').find('.fa-user-plus').closest('li')
        };

        /*
        * @desc 获取打开页面的权限菜单数组
        * @parentId String [父级菜单的权限id]
        * */
        function getPagePermission(parentId) {
            var tmpData = null;
            // 页面权限菜单
            var pagePermissionArr = [];

            for(var i = 0, len = permissionMenuArr.length; i < len; i++) {
                tmpData = permissionMenuArr[i];
                // 如果属于父级菜单，则保存权限
                if(tmpData.parentId === parentId) {
                    pagePermissionArr.push(tmpData);
                }
            }

            return pagePermissionArr;
        }

        function menuControl() {
            var tmpObj = null;

            // 控制菜单元素(按钮)的显示
            for(var i = 0, len = permissionMenuArr.length; i < len; i++) {
                tmpObj = permissionMenuArr[i];

                if(tmpObj.url in pageUrlObj) {
                    pageUrlObj[tmpObj.url].show();
                }
            }

            // 如果控制台按钮存在
            if($('#leftMenu').find('.left-menu .menu11').length > 0) {
                // 新建一个不可关闭的控制台tab页
                tabManager.open({
                    content:$("#wrapper").find('li a').eq(0).data('href'),
                    type:null,
                    title: '<span class="fa menu11" aria-hidden="true"></span>',
                    closeAble: false,
                    forceLoad:true
                });

                $('#tagList').find('li .menu11').closest('li').addClass('icon-tab').attr('title', '控制台首页');
            }
        }

        function set(arr) {
            permissionMenuArr = arr;
        }

        return {
            getPagePermission: getPagePermission,
            menuControl: menuControl,
            set: set
        };
    })();
    
    // 初始化主页面
    function initMainPage() {
        $("#wrapper").find('.left-menu > li > a').click(function(){
            var href = $(this).data("href");
            //IM菜单地址配置为空
            if(href==""){
                $("#IMBtn").click();
            }
            else{
                $('#content-main').find('iframe').hide();
                var $rc = $("#rightContent");
                if($rc.attr('src') !== href){
                    var ls = locationStack.length && locationStack[locationStack.length-1];
                    /**
                     * 如果是在左侧菜单的切换，则直接替换菜单url,
                     * 如果是在左侧菜单与tab页的切换，在url后面append地址
                     */
                    if(ls === 0 || /^id_\d+$/i.test(ls)){
                        //locationStack.push(href);
                    }
                    else{
                        locationStack[locationStack.length-1] = href;
                    }
                    //如果是打开的是首页，则可以强制刷新
                    if(href.indexOf('console/index?') > 0){
                        tabManager.open({
                            content:$("#wrapper").find('li a').eq(0).data('href'),
                            type:null,
                            title: '<span class="fa menu11" aria-hidden="true"></span>',
                            closeAble: false,
                            forceLoad:true
                        });
                        $('#tagList').find('li .menu11').closest('li').addClass('icon-tab').attr('title', '控制台首页');
					}
					else{
                        openTab(href, null, $(this).find('span').text(), false);
					}
                }
            }
        });

        window.setInterval(checkLoginName,1000*60);
    }

	// 检查是否在别处登录
    function checkLoginName(){
		$.ajax({
            url: "<%=request.getContextPath()%>/sso/checkLoginName",
            success: function (data) {
                if (!data.success) {
                   // notice.warning(data.msg);
                    alert(data.msg);
                    window.location.href = '<%=request.getContextPath()%>';
                }
            },
            dataType: 'json',
            global: false
        });
	}

    /**
     * 创建工单成功后，刷新对应用户的工单列表
     */
    var IMRefreshOrderFunc = function(userId){
        var $custom = $("#IMWindowContainer .right-container").find('[userid='+userId+']');
        var pager = $custom.find('[data-id=paginationLately]').data('pager');
        pager &&pager._page(1);
    };
    var tabManager = function(){
        var MAX_LENGTH = 10;
        var $tabList = $('#tagList');
        var $contentContainer = $("#content-main");

        var isUserDetail = function(url){
        	return /userManageMongo\/userDetails|communicate\/goComm/.test(url);
        };
        
        var isOrderDetail = function(url){
        	return /order\/detail/.test(url);
        };

        // 快捷搜索
        var isQuickSearch = function(url){
            return /msearch/.test(url);
        };

        // 是否打开知识库页面
        var isDocDetail = function(url){
            return /help\/index/.test(url);
        };

        // 是否为名单详情
        var isNamesDetail = function(url){
        	return /teleActivity\/detail/.test(url);
		};

        var isEqual = function(c1,c2){
            if(c1 instanceof jQuery && c2 instanceof jQuery){
                return c1.is(c2);
            }
            else{
                if(isUserDetail(c2) && isUserDetail(c1)){
                	var userId1 = c2.match(/userId=\w+/) || [];
                    var userId2 = c1.match(/userId=\w+/) || [];
                    if(userId1.length && userId2.length){
                        return userId1[0] === userId2[0];
                    }
                    else{
                    	return false;
                    }
                }
                else if(isOrderDetail(c2) && isOrderDetail(c1)){
                    var workId1 = c2.match(/workId=\w+/) || [];
                    var workId2 = c1.match(/workId=\w+/) || [];
                    if(workId1.length && workId2.length){
                        return workId1[0] === workId2[0];
                    }
                    else{
                        return false;
                    }
                }
                else if((isQuickSearch(c2) && isQuickSearch(c1)) || (isDocDetail(c2) && isDocDetail(c1))) {
                    return true;
                }
                //判断是否打开的是同一个名单
                else if(isNamesDetail(c2) && isNamesDetail(c1)){
					var namesId1 = c1.match(/namesId=\w+/) || [];
                    var namesId2 = c2.match(/namesId=\w+/) || [];
                    if(namesId1.length && namesId2.length){
                        return namesId1[0] === namesId2[0];
                    }
                    else{
                        return false;
                    }
				}
                else{
                    return c1 === c2;
                }
            }
        };

        var Tab = function(options){
            var timeShame = +new Date();
            this._id = 'id_' + timeShame;
            this._contentId = 'contentId_' + timeShame;
            this.$tab = null;
            this.$content = null;

            var defaultOptions = {
                title:'New Tab',
                content:'#',
                forceLoad:false,
                closeAble:true,
                isIframe:true,
                onTabClose:null,
				onLoad : null,
                type:null//order:工单 user:客户 im:多渠道
            };
            this.options = $.extend(defaultOptions,options);
            this._create();
            this.focus();
            var self = this;
            this.$tab.click(function(){
                self.focus();
            });
        };

        Tab.prototype = {
            _create:function(){
                var self  = this,
                    op    = this.options,
                    title = op.title,
                    type  = op.type,
                    closeAble = op.closeAble;

                var $tab = this.$tab = $('<li class="tag"><a>' + title + '</a></li>');

                // 如果title不是span标签就添加到提示属性里
                if(title.indexOf('<span') === -1) {
                    $tab.attr('title', title);
                }

                type && $tab.addClass('tag-' + type);
                $tab.attr('id',this._id);
                if(closeAble){
                    var $closeBtn = $('<i class="fa fa-close"></i>');
                    $tab.addClass('close-able').append($closeBtn);
                    $closeBtn.click(function(){
                        self.closeTab();
                    });
                }
                $tabList.append($tab);
                this._load();
            }
            ,closeTab:function(){
                this.options.onTabClose && this.options.onTabClose.call(this);
                this.$tab.remove();
                this.$content.remove();
            }
            ,_load:function(){
                var id = this._contentId,
                    $container = $contentContainer,
                    content = this.options.content,
                    isFormServer = true,
                    that = this;
                //jQuery
                if(content instanceof jQuery){
                    isFormServer = false;
                }
                //HTML
                else if(/^<\w+>.*/g.test(content)){
                    isFormServer = false;
                }
                if(isFormServer){
                    if(this.options.isIframe){
                        var $iframe = this.$content = $('<iframe name="iframe" width="100%" height="100%" src="'+content+'" frameborder="0" seamless id="'+id+'"></iframe>');
                        var iframeNode = $iframe[0];
                        if(iframeNode.attachEvent){
                            iframeNode.attachEvent("onload", function(){
                                that.options.onLoad && that.options.onLoad.call();
                            });
                        }
                        else {
                            iframeNode.onload = function(){
                                that.options.onLoad && that.options.onLoad.call();
                            };
                        }
                        $container.append($iframe);
                    }
                    else{
                        var $div = $('<div></div>').attr('id',id).load(this.options.content,function(){
                            that.options.onLoad && that.options.onLoad.call();
                        });
                        $container.append($div);
                        this.$content = $div;
                    }
                }
                else{
                    var $div = $('<div></div>').attr('id',id).append(content);
                    $container.append($div);
                    this.options.onLoad && this.options.onLoad.call();
                    this.$content = $div;
                }
            }
            ,getContent:function(){
                return this.options.content;
            }
            ,focus:function(){
                $tabList.find('li.active').removeClass('active');
                this.$tab.addClass('active');
                if(this.options.forceLoad){
                    var title = this.options.title;
                    var $tab = this.$tab;

                    // 修改tab页名称
                    $tab.find('a').html(title);
                    // 如果title不是span标签就添加到提示属性里
                    if(title.indexOf('<span') === -1) {
                        $tab.attr('title', title);
                    }

                    this.$content.remove();
                    this._load();
                    this.options.forceLoad = false;
                }
                $contentContainer.children().hide();
                this.$content.show();
            }
        };

        var tabQueue = [];
        return {
            /**
             * options.title:'New Tab' 标题
             * options.content:'#' tab页内容 只能接受字符串和jQuery对象
             * options.forceLoad:false 点击到tab标签是否强制加载内容
             * options.closeAble:true, 是否在tab标签上显示关闭按钮
             * options.isIframe:true, 当content为url时，是否使用iframe加载内容还是使用jquery.load
             * options.onClose:null, 关闭时回调
             * options.type:null//order:工单 user:客户 im:多渠道
			 * options.onLoad : null //加载后回调
             */
            open : function(options){
                $("#leftMenu li.selected").removeClass('selected');
                for(var i=0,len=tabQueue.length;i<len;i++){
                    var tab = tabQueue[i];
                    if(isEqual(options.content,tab.getContent())){
                    	tab.options = $.extend(tab.options,options);
                        tab.focus();
                        return true;
                    }
                }
                if(tabQueue.length === MAX_LENGTH){
                    for(var j=0,l=tabQueue.length;j<l;j++){
                        var t = tabQueue[j];
                        if(t.options.closeAble){
                            t.closeTab();
                            break;
                        }
                    }
                }

                options.onTabClose = function(){
                    var id = this._id;
                    for(var j=0,l=tabQueue.length;j<l;j++){
                        var tab = tabQueue[j];
                        if(this === tab){
                            tabQueue.splice(j,1);
                            break;
                        }
                    }
                    $.each(locationStack,function(index,item){
                        if(id === item){
                            locationStack.splice(index,1);
                            return false;
                        }
                    });
                    if(this.$tab.is('.active')){
                        var lt = locationStack.length && locationStack[locationStack.length - 1];
                        //如果为tab的id,显示tab,否则显示左侧菜单栏的页面
                        if(lt && /^id_\d+$/i.test(lt)){
                            $.each(tabQueue,function(i){
                                if(tabQueue[i]._id === lt){
                                    tabQueue[i].focus();
                                }
                            });
                        }
                        else{
                            $contentContainer.children().hide();
                            $("#rightContent")[0].contentWindow.location.reload();
                            $("#rightContent").show();
                            $("#wrapper .left-menu>li>a").each(function(){
                                var href = $(this).data("href");
                                if(lt === href){
                                    $("#wrapper .left-menu li.selected").removeClass('selected');
                                    $(this).parent().addClass('selected');
                                }
                            });
                        }
                    }
                    options.onClose && options.onClose.call(this);
                };
                var tab = new Tab(options);
                locationStack.push(tab._id);
                tabQueue.push(tab);
            },
            getTabBody : function(content){
            	var _content = null;
				tabQueue.forEach(function(tab){
					var _c = tab.getContent();
					if(_c instanceof jQuery){
						if(content instanceof jQuery && _c.is(content)){
							_content = tab.$content;
							return false;
						}
					}
					else if(_c === content){
						_content = tab.$content;
						return false;
					}
				});
				return _content;
			},
			/**
			 * 向所有的iframe广播消息
			 * @param {string,object} message
			 * @param {string} origin
			 */
			broadcast : function(message,origin){
            	origin = origin || location.origin;
				tabQueue.forEach(function(tab){
					if(tab.$content.is('iframe')){
						tab.$content[0].contentWindow.postMessage(message,origin);
					}
				});
			}
        };
    }();
    var openTab = function(url,type,title,reload){
        tabManager.open({
            content:url,
            type:type,
            title:title,
            forceLoad:reload
        });
    };

    function showUserDetail(){
    	var url="<%=request.getContextPath()%>/userManageMongo/userDetails?userId="+'${user.userId}'+"&loginTime="+'${loginTime}';
        openTab(url,"user",'${user.userName}',false);
    }

    function switchUser(loginName,loginPwd){
    	$("#loginNameSwitch").val(loginName);
		$("#loginPwdSwitch").val(loginPwd);
		$("form#switchUser").submit();
    }

    /**
     * 用户详情页创建新工单
     */
    function newwork(curEmail,curUserId,curUserName,param) {
    	tabManager.open({
            content:'<%=request.getContextPath()%>/newwork/index?customId='+curUserId+'&customName='+curUserName +'&selectEmail=' + curEmail +'&param='+param,
            type:'order',
            closeAble:true,
            title:'新建工单'
        });
    }

    /**
     * 是否发邮件提醒
     */
    var send="false";

    $("#receiveEmail").click(function(){
        var isChecked=$(this).prop("checked");
        if(isChecked==true ){
        	if($("#inputPassword3").val()!="")
        		send="true";
        	else{
        		notice.warning("请先填写邮箱！");
        		$(this).attr("checked",false);
        		return;
        	}
        }   
    });

	/**
	 * 查询我的预约
	 */
	var queryReservationThread = function(){
		var _stop  = false;
		var _t     = null;
		var _delay = 5;//显示几分钟内的提醒
		function _request(){
            $.ajax({
                url: "<%=request.getContextPath()%>/appointment/remind",
                global: false,
                success: function (resp) {
                    if(resp.success && resp.rows.length > 0){
                        var _now = new Date().getTime();
                        _.each(resp.rows,function(item){
                            var _time = cri.string2Date(item.appointmentTime,'yyyy-MM-dd HH:mm:ss');
                            if(_time && _time.getTime() <= _now + _delay*60*1000 && _time.getTime() >= _now){
                                notice.showReservation(item);
                            }
                        });
                    }
                }
            })
		}
		function _thread(){
			_t = window.setTimeout(function(){
				_request();
				if(!_stop){
					_thread();
				}
			},1000*60);
		}
		return {
			start : function(){
				_stop = false;
				_thread();
			},
			stop  : function(){
				_stop = true;
				window.clearTimeout(_t);
			}
		};
	}();

    // 标记为要关闭的页面
    function toBeCloseTab() {
    	$('#tagList > li.active').addClass('to-close');
    }
    
    // 关闭被标记页面
    function closeBeCloseTab() {
    	$('#tagList > li.to-close > i').click();
    }
    
    function closeThisTab(){
    	$('#tagList .active i').click();
    }
</script>
<script>

    $(function(){
        $("#logoutBtn").on('click',function(){
            // 手动点击退出，移除session
            logout(null, function(data) {
                if(data.success) {
                    window.location.href = '<%=request.getContextPath()%>';
                } else {
                    notice.danger(data.msg);
                }
            });
        });
    });

    /**
     * @desc 登出系统
     * @author Lesty
     * @codeDate 2016.11.11
     */
    var logout = (function() {
        // 登出请求发送的标志(避免重复发送)
        var LOGOUT_FLAG = false;

        return function(param, callback) {
            param = param != null ? param : {};

            // 没发送过请求
            if(LOGOUT_FLAG === false) {
                // 设置登出请求标志为true
                LOGOUT_FLAG = true;
                $.ajax({
                    async: false,
                    url: '<%=request.getContextPath()%>/logout',
                    data: param,
                    method: 'POST',
                    success: function(data) {
                        if(typeof callback === 'function') {
                            callback(data);
                        }
                    },
                    dataType: 'json'
                }).done(function() {
                    // 登出多渠道
                    WebAgent && WebAgent.multiChannelLogout && WebAgent.multiChannelLogout();
                });
            }
        }
    })();

    /*
     * @author Lesty
     * @codeDate 2016.8.6
     * @desc 到添加客户modal
     * */
    function toAddUserModal() {
        addUserModal.init();
    }

    /**
     * @desc [隐藏标签关闭提示]
     * @codeDate 2016.8.30
     */
    function hideCloseTip() {
        $('#closeTip').fadeOut(500);
    }

    function goSearch(type) {
        // 标题类别-名称对应MAP
        var titleMap = {
            work: '搜索-工单',
            user: '搜索-客户',
            document: '搜索-知识库'
        };
        var title = titleMap[type];
        var key = $("#top-search").val();
        var url = "<%=request.getContextPath()%>/msearch/?type=" + encodeURIComponent(type) + "&key=" + encodeURIComponent(key);

        if (key) {
            title += '-' + key;
        }

        parent.openTab(url, "search", title, true);
    }
    
    /* 设置logo刷新*/
    function refreshEntLogo(imgUrl) {
    	$('#mainLogo').attr('src', "<%=request.getContextPath()%>/" + imgUrl);
    }
    
    /* top设置右上角头像刷新*/
    function refUserPhoto(imgUrl, cUserId) {
    	var userId = "${user.userId}";
    	if(userId == cUserId){
    		$('#userPhotoId').attr('src',imgUrl);
    	}
    }

    /*
    * @desc 初始化全局权限菜单数组
    * */
    function initGlobalPermissionMenu(callback) {
        $.post('<%=request.getContextPath()%>/permission/queryPermission', function(data) {
            PERMISSION_MENU_G.set(data.rows);
            localStorage.setItem('optionControl', JSON.stringify(data.rows));
            // 控制页面菜单权限元素的隐藏和显示
            PERMISSION_MENU_G.menuControl();

            if(typeof callback === 'function') {
                callback();
            }
        });
    }
</script>
<%@include file="/views/include/webAgent.jsp"%>
</body>
</html>
