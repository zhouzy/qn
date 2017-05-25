/**
 * 自定义字段区域
 */
<template>
    <div class="container-fluid">
        <div class="row self-defining-field-bar">
            <template v-for="field in fieldList">
                <div v-if="field.componentType === '1'" class="col-sm-3">
                    <input-component :field="field" v-on:change="formDataChange"></input-component>
                </div>
                <div v-if="field.componentType === '2'" class="col-sm-12">
                    <textarea-component :field="field" v-on:change="formDataChange"></textarea-component>
                </div>
                <div v-if="field.componentType === '3'" class="col-sm-3">
                    <select-component :field="field" v-on:change="formDataChange"></select-component>
                </div>
                <div v-if="field.componentType === '5'" class="col-sm-12">
                    <checkbox-component :field="field" v-on:change="formDataChange"></checkbox-component>
                </div>
                <div v-if="field.componentType === '6'" class="col-sm-3">
                    <input-component :field="field" v-on:change="formDataChange"></input-component>
                </div>
                <div v-if="field.componentType === '7'" class="col-sm-3">
                    <input-component :field="field" v-on:change="formDataChange"></input-component>
                </div>
                <div v-if="field.componentType === '8'" class="col-sm-3">
                    <input-component :field="field" v-on:change="formDataChange"></input-component>
                </div>
                <div v-if="field.componentType === '9'" class="col-sm-3">
                    <input-component :field="field" v-on:change="formDataChange"></input-component>
                </div>
                <div v-if="field.componentType === '10'" class="col-sm-3">
                    <time-input-component :field="field" v-on:change="formDataChange"></time-input-component>
                </div>
                <div v-if="field.componentType === '11'" class="col-sm-12">
                    <pca-input-component :field="field" v-on:change="formDataChange"></pca-input-component>
                </div>
            </template>
        </div>
    </div>
</template>
<script type="text/ecmascript-6">
	var InputComponent = {
		props : ['field'],
		template : '<div class="form-group" :class="{\'has-error\':hasError}">' +
                    '<label class="col-sm-4 control-label text-nowrap">{{label}}:</label>' +
                    '<div class="col-sm-8">' +
                        '<input class="form-control" v-model="value" :name="name" @change="handleChange($event.target.value)"/>' +
                        '<span class="help-block">{{hasErrorText}}</span>' +
                    '</div>' +
                '</div>',
        data : function(){
            return {
            	hasError       : false,
                hasErrorText   : this.field.isRequired ? "该值不能为空" : "",
                label          : this.field.name,
                value          : this.field.defaultValue,
                name           : this.field.name,
                key            : this.field.key,
				candidateValue : this.field.candidateValue
            }
        },
        methods : {
            handleChange: function (newVal) {
                //必填验证
                this.hasErrorText = "";
                if(this.field.isRequired){
                    if(newVal){
                        this.hasError = false;
                    }
                    else{
                        this.hasError = true;
                        this.hasErrorText = "请输入";
                        return ;
                    }
                }
                //正则验证
                if(this.field.componentType === "8" && this.candidateValue.length){
                    if(!new RegExp(this.candidateValue[0]).test(newVal)){
                        this.hasErrorText = "输入不合法";
                        this.hasError = true;
                        return ;
                    }
                    else{
                        this.hasError = false;
                    }
                }
                //电话号码
                if(this.field.componentType === "9"){
                    if(!new RegExp(this.candidateValue[0]).test(newVal)){
                        this.hasErrorText = "请输入合法的电话号码";
                        this.hasError = true;
                        return ;
                    }
                    else{
                        this.hasError = false;
                    }
                }
                //数字
                if(this.field.componentType === "6"){
                    if(!cri.isNum(newVal)){
                        this.hasErrorText = "请输入合法的数字";
                        this.hasError = true;
                        return ;
                    }
                    else{
                        this.hasError = false;
                    }
                }
                //小数
                if(this.field.componentType === "7"){
                    if(/^-?\\d+\\.\\d+$/.test(""+newVal)){
                        this.hasErrorText = "请输入合法的小数";
                        this.hasError = true;
                        return ;
                    }
                    else{
                        this.hasError = false;
                    }
                }
                this.change(newVal);
            },
        	change : function (newVal) {
				this.$emit("change",{
					key : this.key,
                    value : newVal
                });
			}
        }
    };
	var TextareaComponent = {
		props : ['field'],
		template : '<div class="form-group" v-bind:class="{\'has-error\':hasError}">' +
		'<label class="col-sm-1 control-label text-nowrap">{{label}}:</label>' +
		'<div class="col-sm-11">' +
		'<textarea class="form-control" v-model="value" :name="name" @change="handleChange($event.target.value)></textarea>' +
		'<span class="help-block">{{hasErrorText}}</span>' +
		'</div>' +
		'</div>',
		data : function(){
			return {
				hasError       : false,
				hasErrorText   : "",
				key            : this.field.key,
				label          : this.field.name,
				value          : this.field.defaultValue,
				name           : this.field.name,
				candidateValue : this.field.candidateValue
			}
		},
		methods : {
            handleChange: function (newVal) {
                //必填验证
                if(this.field.isRequired){
                    if(newVal){
                        this.hasError = false;
                    }
                    else{
                        this.hasError = true;
                        this.hasErrorText = "请输入";
                        return ;
                    }
                }
                this.change();
            },
			change : function () {
				this.$emit("change",{
					key : this.key,
					value : newVal
				});
			}
		}
	};
	var SelectComponent = {
		props : ['field'],
		template : '<div class="form-group" v-bind:class="{\'has-error\':hasError}">' +
		'<label class="col-sm-4 control-label text-nowrap">{{label}}:</label>' +
		'<div class="col-sm-8">' +
        '<select class="form-control" :name="name" v-model="value"><option v-for="op in options" :value="op.value">{{op.text}}</option></select>' +
		'<span class="help-block">{{hasErrorText}}</span>' +
		'</div>' +
		'</div>',
		data : function(){
			return {
				hasError     : false,
				hasErrorText : "",
				label        : this.field.name,
				value        : this.field.defaultValue,
				name         : this.field.name,
				key          : this.field.key,
				options      : _.map(this.field.candidateValue,function(item){ return {value:item,text:item}; })
			}
		},

		watch : {
			value : function(){
				//必填验证
				if(this.field.isRequired){
					if(this.value){
						this.hasError = false;
					}
					else{
						this.hasError = true;
						this.hasErrorText = "请输入";
						return ;
					}
				}
				this.change();
			}
		},
		methods : {
			change : function () {
				this.$emit("change",{
					key : this.key,
					value : this.value
				});
			}
		}
	};
	var CheckBoxComponent = {
		props : ['field'],
		template : '<div class="checkbox" v-bind:class="{\'has-error\':!hasError}">' +
		'<label class="radio-inline control-label" v-for="op in options">' +
            '<input type="checkbox" :value="op.value" :name="name"/>{{op.text}}</label>' +
		'<span class="help-block">{{hasErrorText}}</span>' +
		'</div>' +
		'</div>',
		data : function(){
			return {
				hasError     : false,
				hasErrorText : "",
				label        : this.field.name,
				value        : this.field.defaultValue,
				name         : this.field.name,
				key          : this.field.key,
				options      : _.map(this.field.candidateValue,function(item){ return {value:item,text:item}; })
			}
		},

		watch : {
			value : function(){
				//必填验证
				if(this.field.isRequired){
					if(this.value){
						this.hasError = false;
					}
					else{
						this.hasError = true;
						this.hasErrorText = "请输入";
						return ;
					}
				}
				this.change();
			}
		},
		methods : {
			change : function () {
				this.$emit("change",{
					key : this.key,
					value : this.value
				});
			}
		}
    };
	var TimeInputComponent ={
		props : ['field'],
		template : '<input :name="name" :value="value" :id="id"/>',
        mounted : function(){
			var self = this;
			var value = this.value ? cri.string2Date(value):"";
			this.timeInput = $("#" + this.id).timeInput({
			    value : value,
                onChange : function(){
			    	self.value = this.value;
                },
            });
        },
		data : function(){
			return {
				id           : "id_" + (new Date().getTime()),
				timeInput    : null,
				hasError     : false,
				hasErrorText : "",
				label        : this.field.name,
				value        : this.field.defaultValue,
				name         : this.field.name,
				key          : this.field.key,
				options      : _.map(this.field.candidateValue,function(item){ return {value:item,text:item}; })
			}
		},

		watch : {
			value : function(){
				//必填验证
				if(this.field.isRequired){
					if(this.value){
						this.hasError = false;
					}
					else{
						this.hasError = true;
						this.hasErrorText = "请输入";
						return ;
					}
				}
				this.change();
			}
		},
		methods : {
			change : function () {
				this.$emit("change",{
					key : this.key,
					value : this.value
				});
			}
		}
	};
	var PCAInputComponent ={
		props : ['field'],
		template : '<div class="form-group"><label class="control-label col-md-1 col-sm-1">{{label}}:</label>' +
            '<div class="col-sm-3 col-md-3"><select :id="provinceId" class="form-control" v-model="province"></select></div>' +
            '<div class="col-sm-3 col-md-3"><select :id="cityId" class="form-control" v-model="city"></select></div>' +
            '<div class="col-sm-3 col-md-3"><select :id="areaId" class="form-control" v-model="area"></select></div>' +
        '</div>',
		mounted : function(){
			new PCAS("#"+this.provinceId, "#"+this.cityId, "#"+this.areaId);
		},
		data : function(){
			var _timeShame = +new Date();
			return {
				provinceId   : "provinceId_" + _timeShame,
				cityId       : "cityId_" + _timeShame,
				areaId       : "areaId_" + _timeShame,
				timeInput    : null,
				hasError     : false,
				hasErrorText : "",
				label        : this.field.name,
				value        : this.field.defaultValue,
				key          : this.field.key,
				province     : "",
                city         : "",
                area         : "",
				name         : this.field.name
			}
		},

		watch : {
			province : function(){
				//必填验证
				if(this.field.isRequired){
					if(this.value){
						this.hasError = false;
					}
					else{
						this.hasError = true;
						this.hasErrorText = "请输入";
						return ;
					}
				}
				this.provinceChange();
				this.change();
			},
			city : function(){
				this.cityChange();
				this.change();
            },
            area : function(){
				this.areaChange();
				this.change();
            }
		},
		methods : {
			change : function () {
				this.$emit("change",{
					key : this.key,
					value : this.province + "," + this.city + "," + this.area
				});
			},
			provinceChange : function(){
				this.$emit("change",{
					key : "province_" + this.key,
					value : this.province
				});
            },
            cityChange : function(){
				this.$emit("change",{
					key : "city_" + this.key,
					value : this.city
				});
            },
            areaChange : function(){
            	this.$emit("change",{
					key : "area_" + this.key,
					value : this.area
				});
            }
		}
	};

	/**
     * 自定义字段
     * zhouzy
     * 2017.03.09
	 */
	module.exports = {
        props: [ 'fieldList', 'formData' ],
        data: function () {
            return {
            	fieldListArray : []
            };
        },
        methods: {
			formDataChange : function(formData){
            	this.$emit("formDataChange",formData);
            }
        },
        components : {
        	'input-component'    : InputComponent,
            'select-component'   : SelectComponent,
            'checkbox-component' : CheckBoxComponent,
            'textarea-component' : TextareaComponent,
            'time-input-component' : TimeInputComponent,
            'pca-input-component' : PCAInputComponent
        }
    };

</script>

<style lang="less" scoped>
    /* 解决浮动高度不统一造成的错位问题 */
    .self-defining-field-bar{
        font-size:0;
        &>*{
            font-size:12px;
            vertical-align: top;
            max-height:57px;
        }
    }
    .cri-form-group .control-label{
        width:33.3%;
    }
</style>