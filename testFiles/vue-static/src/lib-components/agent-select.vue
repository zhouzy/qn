/**
 * 坐席选择器
 * 中余
 * 2017/4/14 16:56
 * <agent-select label="坐席" name="agentId" :value="ref" v-on:change="onChange({value:_newValue})"></agent-select>
 */
<template>
    <div class="form-group bs-form-group select2-form-group">
        <label class="control-label col-sm-3 text-nowrap" v-text="label">归属人:</label>
        <div class="col-sm-9" style="margin-top: 8px">
            <select style="width:100%;" class="form-control" :name="name"></select>
        </div>
    </div>
</template>
<script type="text/ecmascript-6">
    export default{
    	props   : ["label","name","value"],//name:select 对应的name value:默认值
        create  : function(){
			this.defaultValue = this.defaultValue || "";
			this.select2Value = this.value || this.defaultValue;
        },
        mounted : function(){
    		if(this.$store.state.agentGroup.agentGroups.length){
				this._initSelect2();
            }
            else{
                this.$store.dispatch("fetchAgentList");
            }
        },
        data : function(){
    		return {
    			select2Value : "",
                $select : null
            };
        },
        computed : {
        	options : function(){
        		return this.$store.state.agentGroup.agentGroups;
            }
        },
        methods : {
    		_initSelect2 : function(){
				this.$select = $(this.$el).find("select");
				this.$select.select2({
					data : this.$store.getters.select2Data,
					language : "zh-CN"
				}).on("select2:select",function(){
					let _v = this.$select.val();
					if(_v !== this.select2Value){
						this.select2Value = _v;
						this._change();
                    }
				}.bind(this));
				this.$select.val(this.select2Value).trigger("change");
            },
            _change : function(){
    			let _val = this.select2Value === "-1" ? "" : this.select2Value;
    			this.$emit('change',{
    				value : _val
                });
            }
        },
        watch : {
    		options : function(){
                this._initSelect2();
            },
            value : function(){
    			if(this.value === ""){
    				this.select2Value = '-1';
					this.$select.val(this.select2Value).trigger("change");
                }
                else if(this.value !== this.select2Value){
					this.select2Value = this.value;
					this.$select.val(this.select2Value).trigger("change");
                }
            }
        }
    }
</script>
<style lang="less">
    .select2-form-group{

    }
</style>