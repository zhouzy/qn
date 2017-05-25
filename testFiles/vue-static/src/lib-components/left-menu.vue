/**
 * 二级菜单组件
 * 中余
 * 2017/2/10 16:56
 */
<template>
    <div :class="['tele-activity__left-part', {'tele-activity__left-part_close': !isOpen}]">
        <div class="tele-activity__left-part-content" v-show="isOpen">
            <header class="tele-activity__left-part-header">
                <div class="tele-activity__left-part-header-sidebar">{{topTitle}}</div>
            </header>

            <div class="tele-activity__left-menu">
                <div class="tele-activity__left-menu-panel" v-for="menu in menus">
                    <div class="tele-activity__left-menu-header" v-if="typeof menu.title === 'string'"><strong>{{menu.title}}</strong></div>
                    <ul class="tele-activity__left-menu-list">
                        <!-- 绑定click事件，动态添加active类 -->
                        <li v-for="(item, $index) in menu.list" :class="['tele-activity__left-menu-list-item', {active: curIndex == $index}]">
                            <a :href="item.path + '?parentId=' + item.id" class="tele-activity__left-menu-item-link">{{item.text}}</a>
                        </li>
                    </ul>
                </div>
            </div>
        </div>

        <div class="tele-activity__toggle-btn-box">
            <button class="tele-activity__toggle-btn" @click.prevent="toggleLeftPart"><i :class="['fa', isOpen === true ? 'fa-angle-left' : 'fa-angle-right']" aria-hidden="true" style="font-size: 20px;"></i></button>
        </div>
    </div>
</template>
<script type="text/ecmascript-6">
    import {mapState} from 'vuex';

    /**
     * @desc 左侧菜单组件
     * @author Lesty
     * @code-date 2017.2.18
     **/
    module.exports = {
        // 父组件传递过来的属性
        props: ['topTitle', 'isOpen'],
        watch: {
            '$route': function(to, from) {
                // 获取当前路由路径
                let routeName = to.path;
                let menuInfo = {};

                menuInfo = this.getMenuInfoByRouter(this.menus, routeName);
                // 选中菜单
                this.selectMenu(menuInfo.index, menuInfo.title);
            }
        },
        // 实例创建完成，数据观测配置完成后调用
        created: function() {
            let permissionArr = JSON.parse(localStorage.getItem('permissionControl'));
            let dataArr=[];

            for (let i = 0, len = permissionArr.length; i < len; i++) {
                if (permissionArr[i].id == '81') {
                    dataArr = permissionArr[i].children;
                    break;
                }
            }

            let menuList=[];

            for (let i = 0, len = dataArr.length; i < len; i++) {
                let obj = {};
                obj.path = dataArr[i].actionUrl;
                obj.text = dataArr[i].text;
                obj.id = dataArr[i].id;
                menuList.push(obj);
            }

            // 菜单项对照表
            const map = {
                '/teleActivity/findAllTeleActivities': '#/control',
                '/teleActivity/findMyTeleActivities': '#/my-activity',
                '/teleCommunicate/queryCommHistory': '#/foreign-call-history',
                '/namelist/getIndex': '#/list-field-config',
                '3': '#/activity-statistics',
                '/teleCommunicate/queryMyCommHistory': '#/my-foreign-call-history',
				'/appointment/queryAppointment': '#/reservation-manage',           //预约管理
				'/appointment/queryMyAppointment': '#/my-reservation'              //我的预约
            };

            for (let i = 0; i < menuList.length; i++) {
                let key = menuList[i].path;
                menuList[i].path = map[key] || '#/not-found';
            }

            this.menus = [
                {
                    title: null,
                    list: menuList
                }
            ];

            // 路由路径
            let routeName = location.hash;
            // 重定向
            if(routeName === '#/') {
                // 菜单栏第一个选项对应路由
                routeName = menuList.length > 0 ? menuList[0].path : '';
                // 替换当前路由
                this.$router.replace(routeName.replace('#', ''));
                return;
            }

            let menuInfo = {};
            // 根据路由获取菜单信息
            menuInfo = this.getMenuInfoByRouter(this.menus, routeName);
            // 选中菜单效果
            this.selectMenu(menuInfo.index, menuInfo.title);
        },
        data : function(){
            return {
                // 当前索引(用于确定哪个item被选中)
                curIndex: -1,
                // 菜单列表
                menus: [
                    {
                        title: null,
                        list: []
                    }
                ]
            };
        },
        methods: {
            /**
             * @desc 选中某菜单时触发
             **/
            selectMenu: function (index, menuTitle) {
                // 修改索引值
                this.curIndex = index;
                // 触发select-menu事件，并传递选中菜单名
                this.$emit('select-menu', menuTitle);
            },
            // 展开/收起左侧部分
            toggleLeftPart: function () {
                this.$store.commit('SET_OPEN_STATUS', !this.isOpen);
            },
            // 根据路由获取菜单信息
            getMenuInfoByRouter: function (menus, routeName) {
                let menuIndex = -1;
                let menuTitle = '';
                let menuInfo = null;

                for(let i = 0, iLen = menus.length; i < iLen; i++) {
                    // 获取一个菜单列表
                    menuInfo = menus[i].list;

                    for(let j = 0, jLen = menuInfo.length; j < jLen; j++) {
                        // 如果页面路由是菜单path(去除#号)的子路由
                        if(routeName.indexOf(menuInfo[j].path.replace('#', '')) !== -1) {
                            menuIndex = j;
                            menuTitle = menuInfo[j].text;
                            break;
                        }
                    }

                    // 如果找到匹配项
                    if(menuIndex !== -1) {
                        break;
                    }
                }

                // 如果没有匹配项，保留现有选中状态
                if(menuIndex === -1) {
                    menuIndex = this.curIndex;
                }

                return {
                    index: menuIndex,
                    title: menuTitle
                };
            }
        }
    };
</script>