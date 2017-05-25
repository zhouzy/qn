<template>
    <header class="tele-activity__right-part-header">
        <div class="tele-activity__right-part-header-sidebar">
            <span>{{topTitle}}</span>
            <!--顶部内容分发区域-->
            <slot name="topContent"></slot>
        </div>
    </header>
</template>
<script type="text/ecmascript-6">
    /**
     * @desc 页面顶部标题组件
     * @author Lesty
     * @code-date 2017.2.21
     **/
    module.exports = {
        props: ['topTitle']
    };
</script>