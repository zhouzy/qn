/*
* @author Lesty
* @codeDate 2016.8.6
* @desc [复用的工具类，包括一些约定的正则判断]
* */
!function(window){
    window.Tools = {};

    /**
     * @author wly
     * @desc 全屏遮罩层
     * @eg: show/hide: 显示/隐藏 zIndex: 设置css样式z-index
     */
    Tools.createMask = (function () {
        var windowMask = document.createElement('div');
        // 是否已经添加过遮罩层
        var isAppend = false;
        windowMask.style.cssText = 'position:fixed;top:0;bottom:0;left:0;right:0;background:#000;opacity:0.5;z-index:1';

        function show(zIndex) {
            windowMask.style.zIndex = zIndex;

            if(isAppend) {
                windowMask.style.display = 'block';
            } else {
                document.body.appendChild(windowMask);
                isAppend = true;
            }

        }
        
        function hide() {
            windowMask.style.display = 'none';
        }

        return {
            show: show,
            hide: hide
        };
    })();

    /**
     *  @author wly
     *  @desc 加载动画
     *  eg: show/hide: 显示/隐藏
     */
    Tools.loadingBox = (function () {
        var loadinbBox = document.createElement('div');
        loadinbBox.className = 'loading-box';
        loadinbBox.innerHTML = '<div class="sk-spinner sk-spinner-three-bounce"><div class="sk-bounce1"></div><div class="sk-bounce2"></div><div class="sk-bounce3"></div></div>';
        var isAppend = false; // 是否已添加到body
        function show() {
            if(isAppend){
                loadinbBox.style.display = 'block';
            }else {
                document.body.appendChild(loadinbBox);
                isAppend = true;
            }
        }
        function hide() {
            loadinbBox.style.display = 'none';
        }
        return {
            show: show,
            hide: hide
        }
    })();

    /*
     * @author Lesty
     * @codeDate 2016.8.6
     * @desc 手机、座机格式检测(只要是数字，且位数为7,8,11,12位其中一个都可以)
     * @return Boolean true:格式正确 false:格式错误
     * */
    Tools.phoneCheck = function(phone) {
        return /^\d{7,8}$|^\d{11,13}$/.test(phone);
    };

    /*
     * @desc 邮箱格式检测
     * @return Boolean true:格式正确 false:格式错误
     * */
    Tools.mailCheck = function(mail) {
        return /^(\w)+(\.\w+)*@(\w)+((\.\w+)+)$/.test(mail);
    };

    /*
     * @desc 根据长度生成随机密码
     * @length Number [密码长度]
     * @return String [随机密码字符串]
     * */
    Tools.createRandPwd = function (length) {
        var chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
        var result = "";

        for (var x = 0; x < length; x++) {
            var i = Math.floor(Math.random() * chars.length);
            result += chars.charAt(i);
        }

        return result;
    };

    /*
     * @desc 判断用户账号登录方式
     * @account String [登录账号]
     * @return String [登录方式 '0':邮箱 '1':手机 '8':用户输入]
     * */
    Tools.getAccountType = function(account) {
        // 邮箱验证正则
        var emailReg = /^(\w)+(\.\w+)*@(\w)+((\.\w+)+)$/;
        // 手机验证正则
        var phoneReg = /^1\d{10}$/;
        // 登录方式
        var loginType = '';

        if (emailReg.test(account)) { // 邮箱
            loginType = "0";
        } else if (phoneReg.test(account)) { // 手机
            loginType = "1";
        } else { // 用户输入
            loginType = "8";
        }

        return loginType;
    };

    /**
     * @desc [判断对象是否为空]
     * @obj Object 需要判断的对象
     * @return Boolean true:为空
     */
    Tools.isEmptyObj = function (obj) {
        return Object.keys(obj).length === 0;
    };

    /**
     * @desc [获取search字符串里相应参数的值]
     * @search String 要查询的字符串(一般是?param=value形式)
     * @parameter String 查询参数
     * @return String 参数对应的值
     */
    Tools.getSearchParamValue = function(search, parameter) {
        // 要查找的字符串
        var searchStr = search || location.search;
        // 匹配正则
        var reg = new RegExp("(^\\?|&)" + parameter + "=([^&]*)(&|$)", "i");

        return reg.test(searchStr) ? (reg.exec(searchStr))[2] : '';
    };

    /**
     * @desc [将文件大小转换成更可读的方式返回]
     * @size Number 文件大小
     * @returns String 可读的文件大小字符串
     */
    Tools.getFileSize = function(size) {
        if(!size) {
            return '';
        }

        var NUM = 1024.00; //byte
        // 最终返回的文件大小
        var finalSize = size + '';
        size = parseInt(size, 10);

        if (size < NUM) {
            finalSize = size + "B"; //B
        } else if(size < Math.pow(NUM, 2)) {
            finalSize = (size / NUM).toFixed(2) + "K"; //KB
        } else if(size < Math.pow(NUM, 3)) {
            finalSize = (size / Math.pow(NUM, 2)).toFixed(2) + "M"; //M
        } else if(size < Math.pow(NUM, 4)) {
            finalSize = (size / Math.pow(NUM, 3)).toFixed(2) + "G"; //G
        } else if(size < Math.pow(NUM, 5)) {
            finalSize = (size / Math.pow(NUM, 4)).toFixed(2) + "T"; //T
        }

        return finalSize;
    };

    /**
     * @desc 操作权限控制
     * @return object { optionUrl: optionName }
     */
    Tools.getPagePermission = function (parentId) {
        var tmpData = null;
        // 页面权限菜单
        var pagePermissionArr = [];

        var allOptionList = JSON.parse(localStorage.getItem('optionControl'));
        for(var i = 0, iLen = allOptionList.length; i < iLen; i++) {
            tmpData = allOptionList[i];
            // 如果属于父级菜单，则保存权限
            if(tmpData.parentId === parentId) {
                pagePermissionArr.push(tmpData);
            }
        }
        
        var options = {};
        for (var j = 0, jLen = pagePermissionArr.length; j < jLen; j++) {
            options[pagePermissionArr[j].url]=(pagePermissionArr[j].name);
        }
        return options;
    }
}(window);