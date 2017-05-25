<template>
    <div class="manage-tool-sidebar__container" :class="{ 'manage-tool-sidebar__container__show' : toolSideBar_IsShow}">
        <slot name="bottomContent"></slot>
    </div>
</template>

<script>
    module.exports = {
        data : function () {
            return {

            }
        },
        computed: {
            toolSideBar_IsShow(){
                return this.$store.state.allActivity.checkSelect.length;
            }
        }
    }
</script>

<style lang="less" scoped>
    .manage-tool-sidebar__container{
        height:60px;
        font-size:14px;
        background: #fff;
        padding:0 15px;
        position: fixed;
        z-index: 9;
        bottom: -70px;
        left:300px;
        right:0;
        box-shadow: 0 -1px 3px rgba(0, 0, 0, 0.15);
        -webkit-transition: all ease 0.3s;
        -moz-transition: all ease 0.3s;
        -o-transition: all ease 0.3s;
        transition: all ease 0.3s;
    }
    .manage-tool-sidebar__container__show{
        bottom: 0;
    }
    .manage-tool-sidebar__container__full-screen{
        left: 0;
    }
</style>