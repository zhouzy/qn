<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script src="${WebAgent_ROOT}/WebAgent.js"></script>
<script type="text/javascript">
	//名单详情弹屏是否加载完成
	var _isNamesDetailLoad = false;
	//sip电话类型：sip软电话==1 sip硬件电话==0
	var sipUseCphone = '${sipUseCphone}' === '1';
	var customInfo = null;
	//thisCall 每通电话，需要填鸭式写入各个阶段的数据例如接听时间，通话时长等，最后入库
	var thisCall = {};
	var workOrderId = null;
	var OUTBOUND = '6';//外呼
	var INBOUND  = '5';//入呼叫
	// 去往弹屏页的URL路径
	var GO_COM_URL = '';

	window.onbeforeunload = function(){
		if(top.location.href === window.location.href) {
			// 刷新退出，不移除session
			logout({
				logoutType: 'refresh'
			});
		}
	};

	$(function(){
		// 置忙/置闲状态切换事件
		$("#setReadyToggle input").on("change",function(e){
			setCCODAgentStatusText('正在切换坐席状态');
			if(!$(this).prop("checked")){
				WebAgent.multiChannelState.agentBusy(function(){
					console.log('[CDesk] 多渠道能力置忙成功');
				},function(){
					console.log('[CDesk] 多渠道能力置忙失败');
				});
			}
			else{
				WebAgent.multiChannelState.agentReady(function(){
					console.log('[CDesk] 多渠道能力置闲成功');
				},function(){
					console.log('[CDesk] 多渠道能力置闲失败');
				});
			}
		});

		// butel软电话点击事件
		$("#phoneBtn").on('click',function(){
			// 显示或隐藏拨号面板
			WebAgent.WaChat.toggle();
		});

		clickIMEvent();

		//点击重置按钮，重置多渠道状态
		$("#restBtn").click(function(){
            WebAgent.extend.reset();
            notice.success('多渠道状态已经重置');
        });

		// 职能人员不登录多渠道
		if("${user.roleId}" != "6") {
			setCCODAgentStatusText('正在初始化WebAgent');
			WebAgent.init({
				useLocal : false,
				loadBootstrap : false,
				callback: function() {
					setCCODAgentStatusText('正在初始化软电话');
					WebAgent.WaInit({
						ui:false,
                        sipUseCphone : sipUseCphone,
						callback: function(autoLoginResult,autoLoginData) {
							//开发环境公网
							setCCODAgentStatusText('正在初始化WebChat');
							var cchatJs = "${WebAgent_ROOT}/WA/theme/cchat.js";
							var loginParam = {
								entId: "${user.ccodEntId}",
								agentId: "${user.agentId}",
								agentPassword: "${pwd}",
								agentNumber: '${phoneNum}',
								waAutoLoginResult: false,
								waAutoLoginData : null,
								isLocking: isLocking,
								unLocking: unLocking
							};

							WebAgent.attachModule(cchatJs, function() {
								WebAgent.ChatInit({
									selectorName:'#im-container',
                                    quickReplaySelector : '#quickReplayContainer',
									callback: function(){
										setCCODAgentStatusText('初始化WebAgent成功');
										// 多渠道登录事件监听
										MultiChannelEventHook();
										console.log(JSON.stringify(loginParam));
										// 非自动登陆入口
										WebAgent.multiChannelLogin(WebAgent,loginParam);
										WebAgent.ChatToggle();
										WebChatEventHook();
									}
								});
								WAEventHook();
							});

							// 自定义结果处理
							WebAgent.registerResultHandler(function (data) {
								// 自动登录
								if (data.type == "autoLogin") {
									if (data.code == 0) {
										setCCODAgentStatusText('登录多渠道:软电话已自动登录');
										setCCODAgentStatusText('登录多渠道:WebChat');
										// 小休列表
										var awayStatus = data && data.ext && data.ext.awayStatus;
										loginParam.waAutoLoginResult = true;
										loginParam.waAutoLoginData = data;
										loginParam.awayStatus = awayStatus;
										// 自动登录接口(对cchat是否加载完成做了判断)
										WebAgent.multiChannelAutoLogin(WebAgent,loginParam);
									}
								}
							});
						}
					});
				}
			});
		}
	});

	/**
	 * 禁用重置按钮
	 */
	function _disableResetBtn(){
        $("#restBtn").addClass('disabled');
	}

	/**
	 * 启用重置按钮
	 */
    function _enableResetBtn(){
        $("#restBtn").removeClass('disabled');
	}

	/**
	 * 启用外呼按钮
	 */
	function _enablePhoneBtn(){
        $("#phoneBtn").removeClass('disabled');
	}

	/**
	 * 禁用外呼按钮
	 */
    function _disablePhoneBtn(){
        $("#phoneBtn").addClass('disabled');
	}

	/**
	 * 启用状态切换按钮
	 */
	function _enableToggleBtn(){
        $("#setReadyToggle").removeClass('disabled');
	}

    /**
     * 禁用状态切换按钮
     */
    function _disableToggleBtn(){
        $("#setReadyToggle").addClass('disabled');
	}

	var clickIMEvent = function(){
		var $im = null;
		var isIMOpened = false;
		$("#IMBtn").click(function(){
			$im = $im ||$('#IMWindowContainer');
			isIMOpened || $im.detach();
			$im.show();
			isIMOpened = true;
			tabManager.open({
				content:$im,
				type:'im',
				closeAble:true,
				title:'IM通话',
				onClose:function(){
					if(this.$content){
						$im = this.$content.find('#IMWindowContainer').detach();
						isIMOpened = false;
					}
				}
			});
		});
	};

	/*
	 * @desc [置闲置忙不能用时的回调函数]
	 * */
	function isLocking() {
		console.log('[CDesk] 当前置忙置闲状态不能使用');
		//$("#setReadyToggle").addClass('disabled');
		_disableToggleBtn();
	}

	/*
	 * @desc [置闲置忙可以用时的回调函数]
	 * */
	function unLocking(s,moreStates) {
		console.log('[CDesk] 当前置闲置忙状态能使用,状态为:' + s);
		//$("#setReadyToggle.disabled").removeClass('disabled');
		_enableToggleBtn();
		if (s === 'BUSY') {
			$("#currentStatus").text('已经置忙');
			//$("#phoneBtn").removeClass('disabled');
			_enablePhoneBtn();
			$("#setReadyToggle").find('input[type=checkbox]').prop('checked', false);
		}
		else {
			$("#currentStatus").text('已经置闲');
			$("#setReadyToggle").find('input[type=checkbox]').prop('checked', true);
			if (moreStates.waState === "READY") {
				//$("#phoneBtn").addClass('disabled');
				_disablePhoneBtn();
				WebAgent.WaChat.hide();
			}
		}
		setCCODAgentStatusText();
	}

	/**
	 * @desc 重新连接多渠道
	 */
	function reconnectMultiChannel() {
		var phoneNum = '${phoneNum}';
		var loginParam = {
			entId: "${user.ccodEntId}",
			agentId: "${user.agentId}",
			agentPassword: "${pwd}",
			agentNumber: phoneNum,
			waAutoLoginResult: false,
			waAutoLoginData : null,
			isLocking: isLocking,
			unLocking: unLocking
		};

		//自动登陆和非自动登陆入口
		WebAgent.multiChannelLogin(WebAgent, loginParam);
	}

	/**
	 * 软电话事件：（1）电话分外呼和入呼（2）每通电话分3个阶段：振铃事件，接通事件，挂断事件
	 */
	function WAEventHook(){
		var isInBound = false;
		WebAgent.registerEventHandler(function(data){
			//EVENT_INBOUND_ALERTING 呼入振铃事件    ||  EVENT_OUTBOUND_ALERTING_OP 外呼客户振铃
			//strAni是主叫号码    strDnis是被叫号码
			//外呼客户振铃事件 呼入坐席振铃事件
			if(data.type == "EVENT_OUTBOUND_ALERTING_OP" || data.type == "EVENT_INBOUND_ALERTING"){
				/*
				 * 外呼有3种情况，1是从客户详情里面发起外呼，2是从电话面板里面直接发起外呼，3是外呼模块发起外呼
				 * 情况1和情况2需要添加或者更新客户，情况3不需要添加或者添加客户
				 * 情况1和情况2保存联络历史和情况3保存联络历史的接口不同
				 */
				console.info("振铃信息:"+JSON.stringify(data));
				thisCall.source="";
				thisCall.isConnected='0';
				_disableResetBtn();
				var telphone="";
				//都是需要客户号码，所以外呼时是strDnis，呼入是strAni
				if(data.type == "EVENT_OUTBOUND_ALERTING_OP"){
					thisCall.source = OUTBOUND;
					telphone = data.ext.strDnis.replace(/^(.*)(\d{11})$/,"$2");//坐席外呼时，strDnis存储客户号码
					//如果是电销模块发起外呼，不需要新增客户
					if(CCODPhone.isTeleActivity()){
						_addCommunicate(data).then(function(resp) {
							GO_COM_URL = "<%=request.getContextPath()%>/teleActivity/detail?namesId="+CCODPhone.getNamesId()+"&commId=" + resp.rows.commId;
							CCODPhone.getReserveId() && (GO_COM_URL +=  "&reserveId=" + CCODPhone.getReserveId());
							$("#IMContainer").hide();
                            _isNamesDetailLoad = false;
							tabManager.open({
							    title : "外呼:" + telphone,
								content : GO_COM_URL,
								type : "",
                                forceLoad : true,
								onLoad : function(){
                                    _isNamesDetailLoad = true;
								}
							});

						});
						return ;
					}
				}
				else if(data.type == "EVENT_INBOUND_ALERTING"){
					thisCall.source = INBOUND;
					//客户呼入，strAni存储客户号码
					telphone = data.ext.strAni.replace(/^(.*)(\d{11})$/,"$2");
				}
				var userParam={
					userAccount:telphone,
					userAccountType:'1',
					telphone:telphone,
					entId:'${user.entId}',
					signature:'${signKey}',
					updatorAccount:'${user.loginName}'
				};
				$.post('<%=request.getContextPath()%>/userApi/updateOrAddUser',userParam).then(function(userData){
					var ud = (new Function('return ' + userData)());
					thisCall.startTime = new Date().getTime();
					if(ud.success){
						createComm(thisCall.startTime,data,ud.rows.userId, telphone, thisCall.source);
					}
					else{
					    notice.error("系统异常：添加用户出错!");
						console.error("添加用户出错:"+ud.msg);
					}
				});
			}

			// EVENT_CONSULT_ALERTING_TP 咨询振铃事件
			// EVENT_MONITOR_ALERTING 监听振铃事件
			// @latest Lesty 2016.8.5
			if(data.type == 'EVENT_CONSULT_ALERTING_TP' || data.type == 'EVENT_MONITOR_ALERTING') {
				console.log('[' + data.type + '事件] ' + JSON.stringify(data));
				// 客户号码
				var userPhone = '';
				// tab页标题
				var title = '';
				var source = '';

                _disableResetBtn();
				if(data.ext.callType === "CallTypeOutbound") { // 外呼
					userPhone = data.ext.strDnis;
					source = OUTBOUND;
				} else { // 呼入
					userPhone = data.ext.strAni;
					source = INBOUND;
				}

				// 设置弹屏tab页面标题
				if(data.type == 'EVENT_CONSULT_ALERTING_TP') {
					title = '咨询:' + userPhone;
				} else if(data.type == 'EVENT_MONITOR_ALERTING') {
					title = '监听:' + userPhone;
				}

				// 弹屏 needCommPo 1:需要CommPo参数 0:不需要CommPo参数
				openTab("<%=request.getContextPath()%>/communicate/goComm?needCommPo=0&userphone=" + userPhone + '&source=' + source,"",title,true);
			}

			//呼入坐席接通 外呼客户接通
			if(data.type == "EVENT_INBOUND_CONNECTED" || data.type == "EVENT_OUTBOUND_CONNECTED_OP"){
				console.info("接通事件信息:"+JSON.stringify(data));
				//电话接通isConnected='1',未接通为'0',直接修改随路参数对应值（这是由于CCOD的bug造成的）
				thisCall.isConnected='1';
				thisCall.startTime = new Date().getTime();//开始时间
				if(data.type === "EVENT_INBOUND_CONNECTED"){
					isInBound = true;
					// 拨号按钮可点击
					$('#phoneBtn').removeClass('disabled');
				}
				else{
					isInBound = false;
					if(CCODPhone.isTeleActivity()){
						//通知名单详情页面当前的电话状态
						var $tabBody = tabManager.getTabBody(GO_COM_URL);
						if($tabBody.is('iframe')){
						    //判断namesDetails是否已经完全加载，如果已经完成就发送消息过去，否则等待其完成后再发送消息
							if(_isNamesDetailLoad){
								$tabBody[0].contentWindow.postMessage({
									phoneStatus : 'connected'
								}, location.origin);
							}
							else{
							   	var _it = window.setInterval(function(){
							   	    if(_isNamesDetailLoad === true){
                                        $tabBody[0].contentWindow.postMessage({
                                            phoneStatus : 'connected'
                                        }, location.origin);
                                        clearInterval(_it);
									}
								},1000);
							}

						}
						$.post('<%=request.getContextPath()%>/teleCommunicate/connectComm', {
							namesId: CCODPhone.getNamesId(),
							commId: Tools.getSearchParamValue(GO_COM_URL.substring(GO_COM_URL.indexOf(('?'))), 'commId')
						});
					}
				}

				// 隐藏拨号面板
				WebAgent.WaChat.hide();
			}

			//EVENT_TP_DISCONNECT:外呼挂断（客户挂断或者坐席挂断）
			//EVENT_OP_DISCONNECT呼入挂断事件
			if(data.type == "EVENT_TP_DISCONNECT" || data.type == "EVENT_OP_DISCONNECT"){
				console.dir("挂机事件信息:"+JSON.stringify(data));
				_enableResetBtn();
				//修改随路参数的接通值
				data.ext.isConnected = thisCall.isConnected;
				thisCall.endTime = new Date().getTime();
				thisCall.startTime = thisCall.startTime || thisCall.endTime;
				var callSeconds = Math.ceil((thisCall.endTime-thisCall.startTime)/1000);
				var showTimes = callSeconds+"秒";
				if(callSeconds >= 3600){
					showTimes = Math.floor(callSeconds/3600) + "时" + Math.floor((callSeconds%3600)/60) + "分" + (callSeconds%60) + "秒";
				}
				else if(callSeconds >= 60){
					showTimes = Math.floor((callSeconds%3600)/60) + "分" + (callSeconds%60) + "秒";
				}
				var content1 = "";
				if(data.type == "EVENT_OP_DISCONNECT") {
					content1 = '<ul><li>去电详情</li><li>呼出电话至:'+data.ext.strDnis+'</li>'+
						'<li>呼出号码:' + data.ext.strAni + '</li>' +
						'<li>通话时间:' + cri.formatDate(new Date(thisCall.startTime),'yyyy年MM月dd日 hh:mm') + '</li>' +
						'<li>通话时长:'+showTimes+'</li>'+
						'<li>呼入人:${user.loginName}</li></ul>';
				}
				else {
					content1 = '<ul><li>去电详情</li><li>呼出电话至:'+data.ext.strDnis+'</li>'+
						'<li>呼出号码:' + data.ext.strAni + '</li>' +
						'<li>通话时间:' + cri.formatDate(new Date(thisCall.startTime),'yyyy年MM月dd日 hh:mm') + '</li>' +
						'<li>通话时长:'+showTimes+'</li>'+
						'<li>呼出人:${user.loginName}</li></ul>';
				}
				//更新联络历史必须传thisCall.source
				if(CCODPhone.isTeleActivity()){
					thisCall.source && updateComm(thisCall.startTime, thisCall.endTime, callSeconds, data,thisCall.source,CCODPhone.getNamesId());
					CCODPhone.resetStatus();
				}
				else{
					thisCall.source && updateComm(thisCall.startTime, thisCall.endTime, callSeconds, data,thisCall.source);
				}
				if(isInBound){
					WebAgent.multiChannelState.agentReady(function(){
						console.log('[CDesk] 多渠道能力置闲成功');
						$("#currentStatus").text('已经置闲');
					},function(){
						console.log('[CDesk] 多渠道能力置闲失败');
					});
					isInBound = false;
				}
				else{
					WebAgent.multiChannelState.agentBusy(function(){
						console.log('[CDesk] 多渠道能力置忙成功');
						$("#currentStatus").text('已经置忙');
					},function(){
						console.log('[CDesk] 多渠道能力置忙失败');
					});
				}
			}

			//与服务器断开连接
			if(data.type == "EVENT_SOCKET_ABNORMAL_DISCONNECT") {
				notice.danger("多渠道组件网络异常,网络失去连接!");
				setCCODAgentStatusText("正在恢复，长时间未恢复请<a href='javascript:void(0);' onclick='reconnectMultiChannel()' style='text-decoration: underline;'>重试</a>");
				// 隐藏拨号面板
				WebAgent.WaChat.hide();
			}
		});
	}

	/**
	 * WebChat 事件回调
	 */
	function WebChatEventHook(){
		//新用户进来注册函数
		WebAgent.ChatRegisterEvent('newCustomInter',function(data){
			console.log('[WebChat] 新用户进入 信息:' + JSON.stringify(data));//{userId:'如果cDesk没有传入给IM，则IM生成userId,如果传入，则回传给cDesk',skillGroupId:'',skillGroupName:''}
			imWindow && imWindow.onNewCustomer(data.userId, data.userSource);
		});

        WebAgent.ChatRegisterEvent('autoMatchCallback',function(data){
            console.log('[WebChat] 打开常用语Tab');
            imWindow && imWindow.focusQuickReplyTab();
        });

		//切换客户注册函数
		WebAgent.ChatRegisterEvent('selectUser',function(data){
			console.log('[WebChat] 切换客户 信息:' + JSON.stringify(data));//data.userId:（如果cDesk没有传入给IM，则IM生成userId,如果传入，则回传给cDesk）
			imWindow && imWindow.switchCustomer(data.userId);
		});

		//客户下线注册函数
		WebAgent.ChatRegisterEvent('sessionQuit',function(data){
			console.log('[WebChat] 客户下线 信息:' + JSON.stringify(data));//data.userId;data.messages:聊天记录(数组)
			imWindow && imWindow.onCustomerLeave(data.userId,data.messages);
		});

		WebAgent.ChatRegisterEvent('getButelState',function(data){
			console.log('[WebChat] Butel事件:' + JSON.stringify(data));
			//坐席振铃
			if(data === 'msgFromAgentButelAlerting') {
				console.log('[WebChat] TODO:视频振铃');
				$("#content-main iframe").hide();
				$("#IMContainer").show();
			}

			//坐席接通
			if(data === 'msgFromAgentButelConnected') {
				console.log('[WebChat] TODO:坐席接通');
			}
			//坐席发送butel呼叫结束
			//坐席发送butel呼叫振铃取消，没有接听只振铃就取消了
			if(data === 'msgFromAgentButelEnd' || data === 'msgFromAgentButelAlertingAbort') {
				console.log('[WebChat] TODO:取消');
			}

			if(data === 'msgFromAgentButelLogout') {
				console.log('[WebChat] Butel登出');
				console.log('[WebChat] 登出IM');
				WebAgent && WebAgent.ChatLogout();
				location.href = "<%=request.getContextPath()%>/logout";
			}
		});

		WebAgent.ChatRegisterEvent('unReadMsgNum',function(data){
			console.log('未读消息数' + data.unReadMsgNum);
			var n = +data.unReadMsgNum;
			n = n < 100 ? n:99;
			var $n = $("#noticeNumber").text(n);
			if(n <= 0){
				$n.hide();
			}
			else{
				$n.show();
			}
		});

		//与openfire断开连接
		WebAgent.ChatRegisterEvent("openfireDisconnect", function() {
			notice.danger("IM的连接已断开,请退出重新登录!");
			setCCODAgentStatusText("正在恢复，长时间未恢复请<a href='javascript:void(0);' onclick='reconnectMultiChannel()' style='text-decoration: underline;'>重试</a>");
			// 隐藏拨号面板
			WebAgent.WaChat.hide();
		});

		WebAgent.ChatRegisterEvent("butelAjaxError", function(data) {
			notice.danger("多渠道连接失败，与Butel已断开连接！");
			setCCODAgentStatusText("正在恢复，长时间未恢复请<a href='javascript:void(0);' onclick='reconnectMultiChannel()' style='text-decoration: underline;'>重试</a>");
			console.log("butelAjaxError:" + data.ret || "ButelState:" + data.ButelState + ", AgentStatus:" + data.AgentStatus);
			// 隐藏拨号面板
			WebAgent.WaChat.hide();
		});
	}

	/*
	 * @author Lesty
	 * @codeDate 2016.8.22
	 * @desc [多渠道登录事件：登录过程、登录完成]
	 * */
	function MultiChannelEventHook() {
		// 登录过程事件
		WebAgent.multiRegisterEvent("setAgentStateText", function(data) {
			setCCODAgentStatusText(data.text);
		});

		// 登录完成事件
		WebAgent.multiRegisterEvent("login", function(data) {
			if(data.type === 'loginSuccess') {
				notice.success('坐席登陆成功');
				setCCODAgentStatusText();
			} else if(data.type === 'loginFail') {
				onLoginError(data);
			}
		});

		// 登出多渠道事件
		WebAgent.multiRegisterEvent("logout", function() {
			notice.info('正在登出多渠道！');
			console.log("[CDesk]:正在登出多渠道");
		});
	}

	/*
	 * @desc [登录失败处理]
	 * */
	function onLoginError(e){
		var channel = e.channel;
		var msg = e.msg;
		// code编码013(分配butel分机失败)，需要特殊处理
		if(msg == '分配butel分机失败') {
			msg = '请输入分机号码！';
		}

		notice.danger('登录多渠道('+channel+')失败:' + msg);
		setCCODAgentStatusText("登录失败，请<a href='javascript:void(0);' onclick='reconnectMultiChannel()' style='text-decoration: underline;'>重试</a>");

		if(channel === 'WA'){}
		else if(channel === 'IM'){
			WebAgent && WebAgent.extend.logout();
		}
		else if(channel === 'Butel'){
			WebAgent && WebAgent.extend.logout();
		}
	}

	/**
	 * 查询所属客服组
	 * @param userId
	 * @param entId
	 */
	function queryServiceGroup(userId,entId){
		return $.post("<%=request.getContextPath()%>/userApi/queryAgentGroup",{userId:userId,entId:entId});
	}

	/**
	 * 软电话创建联络历史
	 **/
	function createComm(startTime,paramData,userId,calloutPhone, source){
		var title = "";
		if(source == INBOUND) {
			title ='来电号码：'+calloutPhone;
		}
		if(source == OUTBOUND) {
			title='去电号码：'+calloutPhone;
		}

		var param=encodeURI(JSON.stringify(paramData));

		$.post("<%=request.getContextPath()%>/communicate/saveComms?startTimeStr="+startTime+"&source="+source+"&userId="+userId+"&param="+param, function(data) {
			var rows = data.rows || {};
			console.log('[saveComms]' + JSON.stringify(rows));
			// needCommPo 1:需要CommPo参数 0:不需要CommPo参数
			GO_COM_URL = "<%=request.getContextPath()%>/communicate/goComm?needCommPo=1&userId=" + userId + "&userphone=" + calloutPhone+ "&commPo="+encodeURI(JSON.stringify(rows));
			console.log("判断是否需要重新打开来电弹屏页面:" + GO_COM_URL);
			$("#IMContainer").hide();
			openTab(GO_COM_URL,"",title,true);
		});
	}

	/**
	 * 电销任务创建联络历史
	 * @param startTime
	 * @param param
	 * @param userId
	 * @param phoneNum
	 */
	function _addCommunicate(param){
		var resq = {
			startTimeStr : +new Date(),
			teleActivityId : CCODPhone.getTeleActivityId(),
			namesId        : CCODPhone.getNamesId(),
            appointmentId: CCODPhone.getReserveId(),
			source         : OUTBOUND,
			param          : JSON.stringify(param)
		};
		return $.post("<%=request.getContextPath()%>/teleCommunicate/saveComms?",resq);
	}

	/**
	 * 更新联络历史
	 * 如果是电销，则需要传入namesId
	 * 挂机调用
	 */
	function updateComm(startTime, endTime, showTimes, paramData, source,namesId){
		var req = {
			param:encodeURI(JSON.stringify(paramData)),
			startTimeStr: startTime,
			endTimeStr:endTime,
			commTime:showTimes,
			source:source,
			namesId : namesId
		};
		if(namesId !== undefined){
			$.post("<%=request.getContextPath()%>/teleCommunicate/endComm",req).then(function(resp){
				if(!resp.success){
					var msg = resp.msg || "";
					notice.danger("联络历史更新失败:" + msg);
				}
			});
		}
		else{
			$.post("<%=request.getContextPath()%>/communicate/endComm",req).then(function(resp){
				if(!resp.success){
					var msg = resp.msg || "";
					notice.danger("联络历史更新失败:" + msg);
				}
			});
		}
	}

	/**
	 * 扩展外呼
	 * @param telPhone
	 * @param isTeleActivity
	 * @param {
	 * 		teleActivityId : 外呼活动ID,
	 * 		namesId        : 名单ID,
	 * 		reserveId      : 预约ID,
	 * 		disNumber      : 外显号码
	 * 	}
	 */
	function callOut(telPhone,isTeleActivity,param){
		if(isTeleActivity){
			$.post("<%=request.getContextPath()%>/teleActivity/teleConditionJudge",{teleActivityId:param.teleActivityId}).then(function(resp){
				if(resp.success){
					CCODPhone.callOut(telPhone,isTeleActivity,param);
				}
				else{
					notice.danger("对不起，该活动目前不能外呼，请联系管理员！");
				}
			});
		}
		else{
			CCODPhone.callOut(telPhone,isTeleActivity,param);
		}
	}

	/**
	 * 设置顶部工具栏CCOD组件的状态的提示文本
	 * 如果文本为空，则去掉遮罩
	 * @param str
	 */
	function setCCODAgentStatusText(str){
		str = str || "";
		console.log('[WebAgent] setCCODAgentStatus:' + str);
		$('#ccodAgentStatus span').html(str);
		if(str){
			$('#ccodAgentStatus').parent().addClass('ccodAgentStatus-initing');
		}
		else{
			$('#ccodAgentStatus').parent().removeClass('ccodAgentStatus-initing');
		}
	}

	/**
	 * 电话外呼单例对象，保存是否为电销任务状态
	 */
	var CCODPhone = (function(){
		var _isTeleActivity   = false,//是否为电销任务
			_teleActivityId   = "",   //活动ID
			_namesId          = "",   //名单ID
			_reserveId        = "",   //预约ID
			_disNumber        = "";   //外显号码
		return {
			//是否为电销任务外呼
			isTeleActivity : function(){
				return _isTeleActivity
			},

			resetStatus : function(){
				_isTeleActivity = false;
				_namesId = "";
			},

			getTeleActivityId : function(){
				return _teleActivityId;
			},

			getNamesId : function(){
				return _namesId;
			},

			getReserveId : function(){
				return _reserveId;
			},

			callOut : function(telPhone,isTeleActivity,param){
				_isTeleActivity   = !!isTeleActivity;
				_teleActivityId   = param ? param.teleActivityId : "";
				_namesId          = param ? param.namesId : "";
				_reserveId        = param ? param.reserveId : "";
				_disNumber        = param ? param.disNumber : "";
				var _re = null;
				if(_disNumber){
					_re = WebAgent.extend.makeCall({
						outCallNumber : telPhone,
						disNumber     : _disNumber
					});
				}
				else{
					_re = WebAgent.extend.makeCall({
						outCallNumber : telPhone
					});
				}
				if(_re.code != 0){
					notice.danger("外呼失败：" + _re.msg);
				}
			}
		};
	})();

</script>

