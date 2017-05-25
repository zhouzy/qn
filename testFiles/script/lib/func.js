/**
 * Created by zhouzhongyu on 15/11/13.
 */

/**
 * 通知组件
 */
!function(){
    function _alert(msg,style){
        style = style || 'alert-success';
        var html = $('<div class="alert alert-dismissable '+ style+'">'+
        				'<button aria-hidden="true" data-dismiss="alert" class="close" type="button">×</button>'+ msg+
        			 '</div>');
        var $alertBox = $('#alert-box');
        if(!$alertBox.length){
            $alertBox = $('<div id="alert-box" class="alert-box"></div>');
            $('body').append($alertBox);
        }
        $alertBox.append(html);
        window.setTimeout((function($d){
            return function(){
                $d.remove();
            };
        })(html),3*1000);
    }
    function _showReservation(reservation){
        var html = '<div id="reservationAlert{{appointmentId}}" class="reservation-box modal">' +
						'<div class="modal-dialog">' +
							'<div class="modal-content">' +
								'<div class="modal-header"> ' +
									'<h4 class="reservation-title">预约提醒</h4> ' +
								'</div> ' +
								'<div class="modal-body"> ' +
									'<p>您预约于<em>{{appointmentTime}}</em>，回访<em>{{activityName}}</em>活动的<em>{{userName}}</em>名单客户的时间到了</p> ' +
									'<p>回访原因：<em>{{reason}}</em></p> ' +
								'</div> ' +
								'<div class="modal-footer"> ' +
									'<button id="reservationCancelBtn{{appointmentId}}" type="button" class="btn btn-sm btn-default" style="color: #999;">稍后处理</button> ' +
									'<button id="reservationCallBtn{{appointmentId}}" class="btn btn-sm btn-success">点击进行拨打</button>' +
								'</div>' +
							'</div>' +
						'</div>' +
					'</div>';
		var _link = Handlebars.compile(html);
		var _html = _link(reservation);
		debugger;
        if($("#reservationAlert"+reservation.appointmentId).length == 1){
            return $("#reservationAlert"+reservation.appointmentId).show(function () {
                var self = $(this);
                setTimeout(function () {
                    self.fadeOut();
                    // 排序
                    $('.reservation-box:visible').css({
                        bottom: function (index) {
                            return 150 * index
                        }
                    });
                }, 30000); // 30s 后隐藏
            });
		}
		$("body").append(_html);
		$("#reservationAlert"+reservation.appointmentId).show(function () {
		    var self = $(this);
            setTimeout(function () {
                self.fadeOut();
                // 排序
                $('.reservation-box:visible').css({
                    bottom: function (index) {
                        return 150 * index
                    }
                });
            }, 30000); // 30s 后隐藏
        });
        // 排序
        $('.reservation-box:visible').css({
            bottom: function (index) {
                return 150 * index
            }
        });
        $("#reservationCallBtn"+reservation.appointmentId).click(function(){
			callOut(reservation.telPhone,true,reservation);
		});
		$("#reservationCancelBtn"+reservation.appointmentId).click(function(){
			$("#reservationAlert"+reservation.appointmentId).hide();
            // 排序
            $('.reservation-box').css({
                bottom: function (index) {
                    return 150 * index
                }
            });
		});
	}

    var Notice = function(){};

    Notice.prototype.alert = function(msg,style){
    	if(typeof goToLogin != 'undefined' && goToLogin instanceof Function){
    		goToLogin(msg);
    	}
        if(top.location != self.location){
            parent.window.notice.alert(msg,style);
        }
        else{
            _alert(msg,style);
        }
    };

    Notice.prototype.success = function(msg){
        this.alert(msg,'alert-success');
    };

    Notice.prototype.danger = function(msg){
        this.alert(msg,'alert-danger');
    };

    Notice.prototype.warning = function(msg){
        this.alert(msg,'alert-warning');
    };

    Notice.prototype.info= function(msg){
        this.alert(msg,'alert-info');
    };

	/**
	 * 显示提醒窗口
	 * @param reservation
	 * {
	 * 	telPhone        : 外呼号码(required),
	 *  teleActivityId  : 活动ID(required);
	 *  activityName    : 活动名称(required);
	 *  namesId         : 名单ID(required);
	 *  userName        : 客户名称(required);
	 *  appointmentId   : 预约ID(required)
	 *  reason          : 预约原因(required)
	 *  appointmentTime : 预约时间(required)
	 *  displayNumber   : 外显号码(required)
	 *  }
	 */
	Notice.prototype.showReservation = function(reservation){
        if(reservation) {
            reservation.reserveId = reservation.appointmentId;
        }

		_showReservation(reservation);
	};

    window.notice = new Notice();
}();

$(document).ajaxStart(function() {
    var $loading = $(".loading-box");
    if($loading.length == 0) {
        $loading = $(
            '    <div class="loading-box">' +
            '    <div class="sk-spinner sk-spinner-three-bounce">' +
            '        <div class="sk-bounce1"></div>' +
            '        <div class="sk-bounce2"></div>' +
            '        <div class="sk-bounce3"></div>' +
            '    </div>' +
            '</div>'
        );
        $('body').append($loading);
    }
    $loading.show();
});

$(document).ajaxComplete(function(){
    $(".loading-box").hide();
});

$(function(){
    $.material.init({
        /*"inputElements" : "input.form-control:not('.time-box .form-control'), textarea.form-control, select.form-control",*/
		"validate" : false
    });
});

Handlebars.registerHelper('equal', function(v1, v2, options) {
    if(v1 === v2) {
        return options.fn(this);
    }
    return options.inverse(this);
});

Handlebars.registerHelper('formatDate', function(date,formatStr) {
    return cri.formatDate(new Date(date),formatStr);
});



